import React from 'react'

export default function ErrorText({ value }) {
    return (
        <div>
            <input
                className="text-red-500 text-md w-full flex justify-center mt-4 bg-slate-100"
                value={value}
            ></input>
        </div>
    )
}