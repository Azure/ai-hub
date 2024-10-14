import React from "react";

export default function MicrophoneCheckBox({ microphoneChecked, handleActivateMicrophone }) {
    return <div className="flex p-2 justify-end">
        <input type="checkbox"
            checked={microphoneChecked}
            onChange={handleActivateMicrophone}
        ></input>
        <label className="pl-2 text-slate-500">Activate Mic</label>
    </div>
}