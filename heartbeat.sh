#!/bin/bash
set -e
cd "$(dirname "$0")"
git pull -q origin main
date -u +"%Y-%m-%dT%H:%M:%SZ" > heartbeat.txt
git add heartbeat.txt
git commit -q -m "heartbeat $(date -u +%Y-%m-%dT%H:%M:%SZ)"
git push -q origin main
