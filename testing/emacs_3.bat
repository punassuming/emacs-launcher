@ECHO OFF

:: CUSTOMIZE THESE
set installdir=C:\Chocolatey\lib\Emacs.24.3\tools\emacs-24.3\bin
set repodir=D:\Dropbox\settings\dotemacs

set buffer=%1
if ""%1""=="""" set buffer=new
%installdir%\emacsclient.exe --no-wait ^
    --alternate-editor "%installdir%\runemacs.exe" ^
    -f "%repodir%\files-%USERDOMAIN%-%USERNAME%\server" %buffer%
