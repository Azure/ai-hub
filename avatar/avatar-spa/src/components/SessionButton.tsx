import { Status } from "../types/enums.js";
import React from "react";

interface SessionButtonProps {
    sessionState: Status;
    startSession: () => Promise<void>;
    stopSession: () => void;
}

export default function SessionButton({ sessionState, startSession, stopSession }: SessionButtonProps) {
    if (sessionState === Status.STARTED) {
        return <button onClick={stopSession} disabled={false} className="inline-block px-4 w-36 text-sm  border-2 border-slate-500 hover:shadow-md leading-none rounded hover:border-transparent text-slate-500 hover:text-white hover:border-slate-500 hover:bg-slate-500 hover:border-2 mt-4 lg:mt-0 active:scale-95 disabled:opacity-50 disabled:hover:bg-slate-100 disabled:hover:text-slate-500 disabled:border-slate-500 disabled:active:scale-0">Stop Session</button>
    } else if (sessionState === Status.STARTING) {
        return <button onClick={startSession} className="focus:pointer-events-none animate-pulse text-sm w-36 px-4 border-2 border-slate-500 leading-none rounded text-slate-500 mt-4 lg:mt-0">Starting...</button>
    } else if (sessionState === Status.STOPPING) {
        return <button onClick={stopSession} className="focus:pointer-events-none animate-pulse text-sm w-36 px-4 border-2 border-slate-500 leading-none rounded text-slate-500 mt-4 lg:mt-0">Stopping...</button>
    } else if (sessionState === Status.STOPPED) {
        return <button onClick={startSession} disabled={false} className="inline-block px-4 w-36 text-sm  border-2 border-slate-500 hover:shadow-md leading-none rounded hover:border-transparent text-slate-500 hover:text-white hover:border-slate-500 hover:bg-slate-500 hover:border-2 mt-4 lg:mt-0 active:scale-95 disabled:opacity-50 disabled:hover:bg-slate-100 disabled:hover:text-slate-500 disabled:border-slate-500 disabled:active:scale-0">Start Session</button>
    }
}