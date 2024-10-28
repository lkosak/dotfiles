// ==UserScript==
// @name         Lou's Google Meet Monkeypatches
// @namespace    http://www.lou.co
// @version      2024-10-29
// @description  Yeahhhh
// @author       You
// @match        https://meet.google.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=google.com
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    const TOOLTIP_TEXT = "You are still sending your video to others in the meeting";

    const playerInterval = setInterval(() => {
        const players = document.querySelectorAll('[data-participant-id]');

        switch(players.length) {
          case 0:
            console.debug("Not in a call; no-op");
            return;
          case 1:
            console.debug("Alone in call; no-op");
            return;
        }

        const btnVfx = document.querySelector("[aria-label='Apply visual effects']");

        if(btnVfx == null) {
          console.error("Can't find visual effects button for current user");
          return;
        }

        const player = btnVfx.closest('[data-participant-id]');

        if(player == null) {
          console.error("Current user's player elem not found");
          return;
        }

        const btnOptions = player.querySelector('[aria-label="More options"]');

        if(btnOptions == null) {
          console.error('More options button not found');
          return;
        }

        btnOptions.click();

        setTimeout(() => {
          const btnMinimize = document.querySelector('[aria-label="Minimize"]:not([aria-disabled=true])');

          if(btnMinimize == null) {
            console.error('Minimize button not found');
            return;
          }

          btnMinimize.click();
          clearInterval(playerInterval);
        }, 100);
      }, 1000);

      setInterval(() => {
        const btnClose = document.querySelector('[data-is-tooltip-wrapper=true] [aria-label="Close"]');

        if(btnClose !== null) {
          const dialog = btnClose.closest('[role="dialog"]');

          if(dialog.textContent.includes(TOOLTIP_TEXT)) {
            btnClose.click();
          }
        }
      }, 500);

    console.log("Lou's magic monkeypatches installed");
})();
