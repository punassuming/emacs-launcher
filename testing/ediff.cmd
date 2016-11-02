@rem Put this file (ediff.cmd) in your PATH.


@rem (Created by Setup Helper at Tue Apr 03 20:48:56 2007)
@rem -----------------------------
@rem Starts Emacs ediff (through gnuserv) from command line.
@rem Takes the two file to compare as parameters.

@setlocal
@set f1=%1
@set f2=%2
@set f1=%f1:\=/%
@set f2=%f2:\=/%
@set emacs_cd=%CD:\=/%
@set emacs_client="C:\Emacs\emacs-24.4\bin\emacsclientw.exe"
@start /B "%emacs_client% -n -a "C:\Emacs\emacs-24.4\bin\runemacs.exe""
@%emacs_client% -c -n -e "(ediff-files \"%f1%\" \"%f2%\")"

