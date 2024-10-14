import * as SpeechSDK from "microsoft-cognitiveservices-speech-sdk";
import { AvatarConfig } from "../config/config";

const voiceName = AvatarConfig.ttsVoice
const avatarCharacter = AvatarConfig.avatarCharacter
const avatarStyle = AvatarConfig.avatarStyle
const avatarBackgroundColor = "#FFFFFFFF";

export function createWebRTCConnection(iceToken) {
    if (!iceToken) {
        console.log("Ice token is not available")
        return null;
    }
    let peerConnection = new RTCPeerConnection({
        iceServers: [{
            urls: iceToken.Urls[0],
            username: iceToken.Username,
            credential: iceToken.Password
        }]
    })

    return peerConnection;
}

export function getIceToken() {
    return fetch(`${AvatarConfig.apiUri}/api/getIceToken`, {
        method: 'GET',
    })
        .then(response => response.json())
        .catch(error => console.log(error));
}

export function getSpeechToken() {
    return fetch(`${AvatarConfig.apiUri}/api/getSpeechToken`, {
        method: 'GET',
    })
        .then(response => response.json())
        .catch(error => console.log(error));
}

export function getSubscriptionKey() {
    return fetch(`${AvatarConfig.apiUri}/api/getSubscriptionKey`, {
        method: 'GET',
    })
        .then(response => response.json())
        .catch(error => console.log(error));
}

export function createAvatar(subscriptionKey, region) {
    const speechSynthesisConfig = SpeechSDK.SpeechConfig.fromSubscription(subscriptionKey, region);
    speechSynthesisConfig.speechSynthesisVoiceName = voiceName;
    const videoFormat = new SpeechSDK.AvatarVideoFormat()

    let videoCropTopLeftX = 600
    let videoCropBottomRightX = 1320

    videoFormat.setCropRange(new SpeechSDK.Coordinate(videoCropTopLeftX, 50), new SpeechSDK.Coordinate(videoCropBottomRightX, 640));

    const talkingAvatarCharacter = avatarCharacter
    const talkingAvatarStyle = avatarStyle

    const avatarConfig = new SpeechSDK.AvatarConfig(talkingAvatarCharacter, talkingAvatarStyle, videoFormat)
    avatarConfig.backgroundColor = avatarBackgroundColor;
    let avatarSynth = new SpeechSDK.AvatarSynthesizer(speechSynthesisConfig, avatarConfig)

    avatarSynth.avatarEventReceived = function (s, e) {
        var offsetMessage = ", offset from session start: " + e.offset / 10000 + "ms."
        if (e.offset === 0) {
            offsetMessage = ""
        }
        console.log("Event received: " + e.description + offsetMessage)
    }

    return avatarSynth;
}
