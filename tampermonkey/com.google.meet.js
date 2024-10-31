// ==UserScript==
// @name         Lou's Marvelous Google Meet Hacks
// @namespace    http://www.lou.co
// @version      2024-10-28
// @description  Yeahhhh
// @author       You
// @match        https://meet.google.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=google.com
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    const TOOLTIP_TEXT = "You are still sending your video to others in the meeting";

    function injectFloatingClock() {
        if (document.getElementById('floatingClock') !== null) {
            return;
        }

        // Create the clock div
        const clockDiv = document.createElement('div');
        clockDiv.id = 'floatingClock';
        clockDiv.style.position = 'fixed';
        clockDiv.style.top = '0';
        clockDiv.style.left = '0';
        // clockDiv.style.backgroundColor = 'rgba(0,0,0,.20)'; // Semi-transparent black
        clockDiv.style.color = 'white';
        clockDiv.style.fontSize = '1rem';
        clockDiv.style.fontWeight = '500';
        clockDiv.style.letterSpacing = '.2px';
        clockDiv.style.textShadow = '0 1px 2px rgba(0, 0, 0, .6), 0 0 2px rgba(0, 0, 0, .3)';
        clockDiv.style.fontFamily = '"Google Sans", Roboto, Arial, sans-serif';
        clockDiv.style.padding = '15px';
        clockDiv.style.zIndex = '10000'; // Ensure it's on top of everything
        document.body.appendChild(clockDiv);

        // Function to update the time
        function updateClock() {
            const now = new Date();
            const hours = String(now.getHours()).padStart(2, '0');
            const minutes = String(now.getMinutes()).padStart(2, '0');
            const seconds = String(now.getSeconds()).padStart(2, '0');
            clockDiv.textContent = `${hours}:${minutes}:${seconds}`;
        }

        // Update the clock every second
        updateClock();
        setInterval(updateClock, 1000);

        console.log("Injected floating clock");
    }

    // Autohide the self-view the first time it appears
    const playerInterval = setInterval(() => {
        const players = document.querySelectorAll('[data-participant-id]');

        if (players.length == 0) {
            console.debug("Not in a call; no-op");
            return;
        }

        // Call the function to inject the clock
        injectFloatingClock();

        if (players.length == 1) {
            console.debug("Alone in call; no-op");
            return;
        }

        const btnVfx = document.querySelector("[aria-label='Apply visual effects']");

        if (btnVfx == null) {
            console.error("Can't find visual effects button for current user");
            return;
        }

        const player = btnVfx.closest('[data-participant-id]');

        if (player == null) {
            console.error("Current user's player elem not found");
            return;
        }

        const btnOptions = player.querySelector('[aria-label="More options"]');

        if (btnOptions == null) {
            console.error('More options button not found');
            return;
        }

        btnOptions.click();

        setTimeout(() => {
            const btnMinimize = document.querySelector('[aria-label="Minimize"]:not([aria-disabled=true])');

            if (btnMinimize == null) {
                console.error('Minimize button not found');
                return;
            }

            btnMinimize.click();
            clearInterval(playerInterval);
        }, 100);
    }, 1000);

    // Snip the "your camera is still running" tooltip any time it pops up
    setInterval(() => {
        const btnClose = document.querySelector('[data-is-tooltip-wrapper=true] [aria-label="Close"]');

        if (btnClose !== null) {
            const dialog = btnClose.closest('[role="dialog"]');

            if (dialog.textContent.includes(TOOLTIP_TEXT)) {
                btnClose.click();
            }
        }
    }, 500);

    console.log("Lou's magic monkeypatches installed");
})();
