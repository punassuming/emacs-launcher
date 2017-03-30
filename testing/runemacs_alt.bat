::::::::::::::::::::::::::::::::::::::::::::::::::
:::
::: Emacsclient startup script runemacsclientw.bat
::: Robert Adesam, robert@adesam.se
::: http://www.adesam.se/robert/
:::
::: N.B. Alot of this is reused from other Emacs
::: users that have published stuff on the
::: Internet. Thank you! :)
::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off
:: Emacs binaries...
set binpath=c:\Program Files\emacs\bin
:: If no arg is given set filename to c:\
if "%~1"=="" (
  set filename=c:\
) else (
  set filename=%~1
)
:: Run Emacsclient
"%binpath%\emacsclientw.exe" --no-wait --alternate-editor="%binpath%\runemacs.exe" "%filename%"