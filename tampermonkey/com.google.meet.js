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
    const JOIN_BUTTON_CTAS = ['join now', 'switch here'];
    const FLOATING_CLOCK_ID = 'floatingClock';
    const USER_FULL_NAME = 'Lou Kosak';
    var clockTickInterval;

    // Helper to find the "Join now" button
    function findJoinButton() {
        const buttons = document.querySelectorAll('button');
        for (let btn of buttons) {
            const btnText = btn.innerText.trim().toLowerCase();

            if (JOIN_BUTTON_CTAS.includes(btnText)) {
                return btn;
            }
        }
        return null;
    }

    // Listen for Enter key press
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Enter' || e.keyCode === 13) {
            const players = document.querySelectorAll('[data-participant-id]');

            if (players.length !== 0) {
                console.debug("In a call; no-op");
                return;
            }

            const joinButton = findJoinButton();
            if (joinButton && !joinButton.disabled) {
                joinButton.click();
            }
        }
    });

    // Inject clock and return interval for "ticking"
    function injectFloatingClock() {
        const parentContainer = document.querySelector("body");

        // Create the clock div
        const clockDiv = document.createElement('div');
        clockDiv.id = FLOATING_CLOCK_ID;
        clockDiv.style.position = 'absolute';
        clockDiv.style.bottom = '100px';
        clockDiv.style.left = '50%';
        clockDiv.style.transform = 'translateX(-50%)';
        // clockDiv.style.backgroundColor = 'rgba(0,0,0,.20)'; // Semi-transparent black
        clockDiv.style.color = 'white';
        clockDiv.style.fontSize = '1rem';
        clockDiv.style.fontWeight = '500';
        clockDiv.style.letterSpacing = '.2px';
        clockDiv.style.textShadow = '0 1px 2px rgba(0, 0, 0, .6), 0 0 2px rgba(0, 0, 0, .3)';
        clockDiv.style.fontFamily = '"Google Sans", Roboto, Arial, sans-serif';
        clockDiv.style.zIndex = '10000'; // Ensure it's on top of everything
        parentContainer.appendChild(clockDiv);

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
        const interval = setInterval(updateClock, 1000);

        console.debug("Injected floating clock");

        return interval;
    }

    // Clock management; injects clock and re-injects when removed from DOM.
    setInterval(() => {
        const players = document.querySelectorAll('[data-participant-id]');

        if (players.length == 0) {
            console.debug("Not in a call; no-op");
            return;
        }

        const floatingClock = document.getElementById(FLOATING_CLOCK_ID);

        if (floatingClock === null) {
            console.debug("No clock present; injecting");
            clearInterval(clockTickInterval);
            clockTickInterval = injectFloatingClock();
        }
    }, 1000);

    // Autohide the self-view the first time it appears
    const autoHideInterval = setInterval(() => {
        const players = document.querySelectorAll('[data-participant-id]');

        if (players.length == 0) {
            console.debug("Not in a call; no-op");
            return;
        }

        if (players.length == 1) {
            console.debug("Alone in call; no-op");
            return;
        }

        // Use keyboard shortcut to hide self-view
        document.dispatchEvent(new KeyboardEvent('keydown', { key: 'm', metaKey: true, ctrlKey: true }));

        // Stop trying to close now that it has been closed once.
        clearInterval(autoHideInterval);
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

    console.log("Lou's Marvelous Google Meet Hacks installed");
})();
