REM $Id: emacsassoc.bat,v 1.1 2003/01/10 08:21:27 reichr Exp $
REM You should adjust the path to gnuclientw.exe
REM %%1 is needed for 4nt, %1 can be used for cmd.exe

ftype emacs-file=c:\emacs-21.2.x\bin\gnuclientw.exe -q -F "%%1"
assoc .vhdl=emacs-file
assoc .vhd=emacs-file
assoc .v=emacs-file
assoc .c=emacs-file
assoc .txt=emacs-file
assoc .el=emacs-file
assoc .tex=emacs-file
