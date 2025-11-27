@echo off
chcp 65001 > nul
git add .
git commit -m "auto-backup %date%"
git push origin main
pause