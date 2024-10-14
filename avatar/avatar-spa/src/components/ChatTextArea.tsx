import React from 'react'

export default function ChatTextArea({ value, onChange }) {
    return (
        <div>
            <textarea
                className="w-full bg-white p-2 rounded-md border-2"
                placeholder="Type your message here..."
                value={value}
                onChange={onChange}
            ></textarea>
        </div>
    )
}