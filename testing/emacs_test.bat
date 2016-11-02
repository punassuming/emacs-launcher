set test="C:\Program Files (x86)\AutoHotkey\AutoHotkey.exe" "C:\Users\rralesij\Documents\settings\emacs\system\emacs_launcher.ahk"

:: testing diff
start, %test% -d emacs_taskbar.bat emacs_test.bat
PAUSE

:: testing space in names
start, %test% -d "emacs space.bat" emacs_test.bat
PAUSE

:: testing unescaped fullnames
start, %test% -d "C:\Users\rralesij\Documents\settings\emacs\config\init-appearance.el" "C:\Users\rralesij\Documents\settings\dotemacs\config\init-eyecandy.el"
PAUSE

:: testing escaped fullnames
start, %test% -d "C:\\Users\\rralesij\\Documents\\settings\\emacs\\config\\init-appearance.el" "C:\\Users\\rralesij\\Documents\\settings\\dotemacs\\config\\init-eyecandy.el"
PAUSE

:: testing help
start, %test% -h
PAUSE

:: testing default run
start, %test%
PAUSE

:: testing default run
start, %test% -c
PAUSE

:: testing diff
start, %test% -d emacstaskbar.bat emacs_test.bat
PAUSE

:: testing vertical diff
start, %test% -v ediff.cmd
PAUSE

:: testing default run
start, %test% -v ediff.cmd -o ediff.cmd
PAUSE

:: testing horizontal split open
start, %test% -o ediff.cmd
PAUSE

:: testing new frame
start, %test% -f emacs_xplorer2.bat
PAUSE

:: testing 3 way diff
start, %test% -d emacsclient.bat emacsclients.bat emacsclientw.bat
PAUSE

:: testing new empty frame
start, %test% -f
PAUSE
