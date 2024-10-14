import React from "react";

export default function ClearChatButton({ handleChatTextAreaClear }) {
    return (
        <button
            onClick={handleChatTextAreaClear}
            className="inline-block px-4 w-36 text-sm  border-2 border-slate-500 hover:shadow-md leading-none rounded hover:border-transparent text-slate-500 hover:text-white hover:border-slate-500 hover:bg-slate-500 hover:border-2 mt-4 lg:mt-0 active:scale-95 disabled:opacity-50 disabled:hover:bg-slate-100 disabled:hover:text-slate-500 disabled:border-slate-500 disabled:active:scale-0"
        >Clear Chat</button>
    )
}