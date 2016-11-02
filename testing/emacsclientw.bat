@echo off
SET DIR=%~dp0%
"%DIR%..\lib\emacs.24.3\tools\emacs-24.3\bin\emacsclientw.exe" %*
