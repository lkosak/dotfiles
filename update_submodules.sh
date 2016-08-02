#!/bin/bash
git submodule init # needed for first run; should no-op if already run
git submodule update # needed for first run; should no-op if already run
git submodule foreach git pull origin master
