@echo off
chcp 65001 > nul
git add .
git commit -m "Бэкап %date%"
git push origin main
pause