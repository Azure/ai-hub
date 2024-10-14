import * as SpeechSDK from "microsoft-cognitiveservices-speech-sdk";
import { createAvatar, createWebRTCConnection, getIceToken, getSpeechToken } from "../services/services.ts";
import { useState } from "react";
import { useRef } from "react";
import React from "react";
import SessionButton from "./SessionButton.tsx";
import { Status } from "../types/enums.js";
import MicrophoneCheckBox from "./MicrophoneCheckBox.tsx";
import ChatTextArea from "./ChatTextArea.tsx";
import ClearChatButton from "./ClearChatButton.tsx";
import SpeakButton from "./SpeakButton.tsx";
import ErrorText from "./ErrorText.tsx";

export default function Avatar() {
    const [sessionState, setSessionState] = useState<Status>(Status.STOPPED);
    const [speakState, setSpeakState] = useState<Status>(Status.STOPPED);
    const [speechText, setSpeechText] = useState('');
    const [chatTextArea, setChatTextArea] = useState('');
    const [avatarSynth, setAvatarSynth] = useState<SpeechSDK.AvatarSynthesizer>();
    const [microphoneChecked, setMicrophoneChecked] = useState(false);
    const avatarVideoRef = useRef<HTMLDivElement>(null);
    const avatarVideoElementRef = useRef<HTMLVideoElement>(null);
    const avatarAudioElementRef = useRef<HTMLAudioElement>(null);
    const [errorText, setErrorText] = useState('');

    function handleSpeechText() {
        setSpeechText(speechText);
        if (speakState === Status.STARTED || speakState === Status.STARTING) {
            stopSpeakingText();
        } else {
            speakSelectedText();
        }
    }

    function handleChatTextAreaChange(event) {
        event.preventDefault();
        setChatTextArea(event.target.value);
        setSpeechText(event.target.value);
    }

    function handleChatTextAreaClear() {
        console.log('clearing chat...')
        setChatTextArea('')
        setSpeechText('');
    }

    function handleActivateMicrophone(event) {
        setMicrophoneChecked(event.target.checked)
    }

    function handleOnTrack(event) {
        console.log("onTrack: ", event.track.kind);
        if (event.track.kind === 'video') {
            const mediaPlayer = avatarVideoElementRef.current;
            if (mediaPlayer !== null) {
                mediaPlayer.id = event.track.kind;
                mediaPlayer.srcObject = event.streams[0];
                mediaPlayer.autoplay = true;
                mediaPlayer.playsInline = true;
                mediaPlayer.addEventListener('play', () => {
                    window.requestAnimationFrame(() => { });
                });
            } else {
                console.log("video element not found...")
                setErrorText("Video element not found")
            }
        } else if (event.track.kind === 'audio') {
            const audioPlayer = avatarAudioElementRef.current;
            if (audioPlayer !== null) {
                audioPlayer.srcObject = event.streams[0];
                audioPlayer.autoplay = true;
                audioPlayer.muted = true;
            }
            else {
                console.log("audio element not found...")
                setErrorText("Audio element not found")
            }
        } else {
            console.log("unknown track kind: ", event.track.kind);
            setErrorText("Unknown track kind: " + event.track.kind)
        }
    };

    function stopSpeakingText() {
        try {
            if (avatarSynth === undefined) {
                console.log("Avatar synth is not initialized");
                setErrorText("Avatar synth is not initialized")
                return;
            }
            avatarSynth.stopSpeakingAsync().then(() => {
                console.log("stopping speaking...")
                setSpeakState(Status.STOPPED);
            }).catch();
        } catch (error) {
            console.log("Error stopping speaking: ", error)
            setErrorText("Error stopping speaking: " + error)
        }
    }

    function stopSession() {
        try {
            if (avatarSynth === undefined) {
                console.log("Avatar synth is not initialized");
                setErrorText("Avatar synth is not initialized");
                return;
            }
            avatarSynth.stopSpeakingAsync().then(() => {
                console.log("stopping session...")
                avatarSynth.close();
                setSessionState(Status.STOPPING);
            }).catch();
        } catch (error) {
            console.log("Error stopping session: ", error)
            setErrorText("Error stopping session: " + error)
        }
    }

    function speakSelectedText() {
        const audioPlayer = avatarAudioElementRef.current;

        if (audioPlayer === null) {
            console.log("Audio player not found")
            setErrorText("Audio player not found")
            return;
        }

        console.log("Audio muted status ", audioPlayer.muted);
        audioPlayer.muted = false;

        if (avatarSynth === undefined) {
            console.log("Avatar synth is not initialized");
            setErrorText("Avatar synth is not initialized")
            return;
        }

        setSpeakState(Status.STARTED);

        avatarSynth.speakTextAsync(speechText).then(
            (result) => {
                switch (result.reason) {
                    case SpeechSDK.ResultReason.SynthesizingAudioStarted:
                        console.log("Synthesizing audio started. Result ID: " + result.resultId)
                        break;
                    case SpeechSDK.ResultReason.SynthesizingAudioCompleted:
                        console.log("Synthesizing audio completed. Result ID: " + result.resultId)
                        setSpeakState(Status.STOPPED);
                        break;
                    case SpeechSDK.ResultReason.Canceled:
                        console.log("Cancellation reason: " + result.reason)
                        setErrorText("Cancellation reason: " + result.reason)
                        setSpeakState(Status.STOPPED);
                        break;
                    default:
                        break;
                }
            }).catch((error) => {
                avatarSynth.close()
                console.log("Error speaking text: " + error)
                setErrorText("Error speaking text: " + error)
                setSpeakState(Status.STOPPED);
            });
    }

    async function startSession() {
        let [iceToken, speech] = await Promise.all([getIceToken(), getSpeechToken()]);
        setErrorText('');
        var peerConnection = createWebRTCConnection(iceToken)

        if (peerConnection === undefined || peerConnection === null) {
            console.log("WebRTC connection is not initialized");
            setErrorText("WebRTC connection is not initialized")
            return;
        }

        peerConnection.ontrack = handleOnTrack;
        peerConnection.addTransceiver('video', { direction: 'sendrecv' })
        peerConnection.addTransceiver('audio', { direction: 'sendrecv' })

        var avatarSynth = createAvatar(speech.token, speech.region);
        setAvatarSynth(avatarSynth);
        console.log("starting session...")
        setSessionState(Status.STARTING);

        peerConnection.oniceconnectionstatechange = e => {
            if (peerConnection === undefined || peerConnection === null) {
                console.log("WebRTC connection is not initialized");
                setErrorText("WebRTC connection is not initialized")
                return;
            }

            console.log("WebRTC status: " + peerConnection.iceConnectionState)

            if (peerConnection.iceConnectionState === 'connected') {
                setSessionState(Status.STARTED);
                console.log("Avatar connected");
            }

            if (peerConnection.iceConnectionState === 'disconnected' || peerConnection.iceConnectionState === 'failed') {
                setSessionState(Status.STOPPED);
                console.log("Avatar disconnected");
            }
        }

        avatarSynth.startAvatarAsync(peerConnection)
            .then((r) => {
                setSessionState(Status.STARTED);
                console.log("Avatar started successfully");
            })
            .catch((error) => {
                setSessionState(Status.STOPPED);
                console.log("Avatar failed to start with error: " + error)
                setErrorText("Avatar failed to start with error: " + error)
            }
            );
    }

    return (
        <div className="shadow-lg p-6 rounded-lg">
            <div className="border-2 bg-white min-h-[32rem]">
                <div ref={avatarVideoRef}>
                    <video ref={avatarVideoElementRef}></video>
                    <audio ref={avatarAudioElementRef}></audio>
                </div>
            </div>
            <MicrophoneCheckBox microphoneChecked={microphoneChecked} handleActivateMicrophone={handleActivateMicrophone} />
            <ChatTextArea value={chatTextArea} onChange={handleChatTextAreaChange} />
            <div className="flex justify-center space-x-2 h-12 pt-2">
                <SessionButton sessionState={sessionState} startSession={startSession} stopSession={stopSession} />
                <SpeakButton speechText={speechText} sessionState={sessionState} speakState={speakState} handleSpeechText={handleSpeechText} />
                <ClearChatButton handleChatTextAreaClear={handleChatTextAreaClear} />
            </div>
            <ErrorText value={errorText} />
        </div>
    )
}
