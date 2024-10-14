import React from "react";

export default function MenuBar() {
    return (
        <nav class="flex items-center justify-between flex-wrap bg-slate-500 p-6">
            <div class="flex items-center flex-shrink-0 text-white mr-6">
                <svg version="1.0" xmlns="http://www.w3.org/2000/svg" width="51pt" height="51pt" viewBox="0 0 512.000000 512.000000" preserveAspectRatio="xMidYMid meet">
                    <g transform="translate(0.000000,512.000000) scale(0.100000,-0.100000)"
                        fill="#000000" stroke="none">
                        <path d="M2285 4664 c-630 -85 -1163 -423 -1515 -959 -74 -113 -172 -320 -219
                                -460 -179 -538 -142 -1118 103 -1620 181 -369 472 -685 822 -891 617 -363
                                1380 -393 2019 -79 732 359 1185 1088 1185 1905 0 572 -218 1099 -619 1501
                                -337 337 -753 541 -1234 604 -143 18 -403 18 -542 -1z m395 -1005 c167 -38
                                319 -181 371 -348 25 -82 27 -213 3 -291 -88 -299 -408 -455 -689 -337 -147
                                61 -268 201 -304 352 -19 76 -15 201 9 276 50 163 190 298 357 344 58 16 192
                                18 253 4z m295 -1164 c189 -54 335 -177 416 -350 54 -117 63 -172 64 -395 0
                                -186 -1 -197 -23 -231 -44 -72 -1 -69 -872 -69 -871 0 -828 -3 -872 69 -22 34
                                -23 45 -22 241 0 235 9 284 77 414 56 108 155 207 263 263 147 76 191 82 589
                                79 268 -3 330 -6 380 -21z"/>
                    </g>
                </svg>
                <span class="font-semibold text-xl tracking-tight pl-4">Avatar</span>
            </div>
            <div class="block lg:hidden md:hidden">
                <button class="flex items-center px-3 py-2 border rounded text-slate-200 border-slate-400 hover:text-white hover:border-white">
                    <svg class="fill-current h-3 w-3" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><title>Menu</title><path d="M0 3h20v2H0V3zm0 6h20v2H0V9zm0 6h20v2H0v-2z" /></svg>
                </button>
            </div>
            <div class="w-full block flex-grow md:flex lg:flex lg:items-center md:items-center lg:w-auto md:w-auto">
                <div class="text-sm lg:flex-grow md:flex-grow">
                    <a href="#responsive-header" class="block mt-4 lg:inline-block md:inline-block lg:mt-0 text-slate-200 hover:text-white mr-4">
                        Docs
                    </a>
                    <a href="#responsive-header" class="block mt-4 lg:inline-block lg:mt-0 md:mt-0 md:inline-block text-slate-200 hover:text-white mr-4">
                        Examples
                    </a>
                    <a href="#responsive-header" class="block mt-4 lg:inline-block lg:mt-0 md:mt-0 md:inline-block text-slate-200 hover:text-white">
                        Blog
                    </a>
                </div>
                <div>
                    <a href="#" class="inline-block text-sm px-4 py-2 leading-none border rounded text-white border-white hover:border-transparent hover:text-slate-500 hover:bg-white mt-4 md:mt-0 lg:mt-0">Login</a>
                </div>
            </div>
        </nav>
    );
}