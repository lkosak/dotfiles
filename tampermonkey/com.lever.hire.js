// ==UserScript==
// @name         Full-width Lever
// @namespace    http://tampermonkey.net/
// @version      2026-02-20
// @description  try to take over the world!
// @author       You
// @match        https://hire.lever.co/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=lever.co
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    var monkey = function () {
        document.getElementsByClassName("flyover")[0].style.width='100%';
        document.getElementsByClassName("flyover")[0].style.maxWidth='100%';
        document.getElementsByClassName("flyover-controls")[0].style.display='none';
        document.getElementsByClassName("next-prev-container")[0].style.display='none';
    }

    window.addEventListener('resize', monkey);

    monkey();

    function initInterviewStory(container) {
        // Prevent double initialization
        if (container.dataset.cardsInitialized === "true") return;
        container.dataset.cardsInitialized = "true";

        const elements = container.getElementsByClassName("card-key");

        for (const keyEl of elements) {
            keyEl.style.cursor = "pointer";

            const card = keyEl.parentElement;
            const valueEl = card.querySelector(".card-value");
            const keyText = keyEl.textContent.trim();

            const indicator = document.createElement("span");
            indicator.className = "toggle-indicator";
            indicator.style.marginLeft = "8px";
            keyEl.appendChild(indicator);

            const setOpen = (open) => {
                valueEl.style.display = open ? "block" : "none";
                indicator.textContent = open ? "▾" : "▸";
            };

            // Default open
            setOpen(true);

            // Auto-hide Raw Notes
            if (keyText.toLowerCase() === "raw notes") {
                setOpen(false);
            }

            keyEl.addEventListener("click", function () {
                const isHidden =
                      window.getComputedStyle(valueEl).display === "none";
                setOpen(isHidden);
            });
        }
    }

    function watchForInterviewStory() {
        const observer = new MutationObserver(() => {
            const containers = document.getElementsByClassName("interview-story");

            for (const container of containers) {
                initInterviewStory(container);
            }
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true
        });

        // Run once immediately too
        const existing = document.getElementsByClassName("interview-story");
        for (const container of existing) {
            initInterviewStory(container);
        }
    }

watchForInterviewStory();
})();
