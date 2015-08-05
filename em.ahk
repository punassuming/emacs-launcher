; Emacs Launcher
; author : Rich Alesi
; manage server creation and emacsclient issues in windows
; wait to load file until server started
; allow command line arguments to work from shell

files=
func=
prefix=
suffix=
mode=

EnvGet, emacs_path, EmacsPath

If (emacs_path=) {
  MsgBox Set environment variable "EmacsPath" to root directory of your emacs installation
  ExitApp
}

client=\bin\emacsclientw.exe
server=\bin\runemacs.exe

; TODO work with files with SPACES
; TODO deal with Emacs instances that aren't runing servers

;; set local variables

filecount=0
arglist=
command=

loop, %0% {
  param := %A_Index%
  arglist.=param
  ; MsgBox % param
  if ((param == "--diff") or (param == "-d"))
    mode=ediff-files
  else if (param == "-o")
    func=-e "(split-window-vertically)"
  else if (param == "-v")
    func=-e "(split-window-horizontally)"
  else if (param == "-f")
    func=-e "(make-frame)"
  else if ((param == "-h") or (param == "--help"))
    GoSub, Help
  else if (param == "--eq")
    suffix=-e "(balance-windows)"
  else {
    if FileExist(param) {
      ; MsgBox %param% exists as a file
      ;; if path not specified
      if RegExMatch(param, "\\") == 0
        param = %A_WorkingDir%\%param%
      
      ;; convert path to unix delimiters
      param := RegExReplace(param, "\\", "/")

      filecount+=1

      files=%files% \"%param%\"
      command=%command% %func% -e "(find-file \"%param%\")"
    }
    ;; if not a path, append to prefix string
    else 
      prefix = %prefix% %param%
  }
}

; MsgBox % arglist
; MsgBox, %prefix% %command% %suffix%
; ExitApp

; MsgBox %0% and filecount is %filecount%
Process, wait, emacs.exe, 1
NewPID = %ErrorLevel%  ; Save the value immediately since ErrorLevel is often changed.

; if emacs is not running, why does server file exist?
EnvGet, HOME, USERPROFILE

; -f "%repodir%\files-%USERDOMAIN%-%USERNAME%\server"
server_path = %HOME%\.emacs.d\server

; If emacs.exe isn't running...
if (NewPID == 0) {
  Loop, %server_path%\* {
    MsgBox, 4, , Delete old server files?
    ; IfMsgBox Yes
    FileDelete, %server_path%\*
  }
  Tooltip, Starting Emacs...
  Run %emacs_path%%client% -n -c -a %emacs_path%%server%
  WinWait, ahk_class Emacs

  ; Continuous
  started=
  Loop {
    Loop, %server_path%\* {
      If FileExist(A_LoopFileLongPath)
        started=1
    }
    If (started)
      break
  Sleep, 1000
}
}

; clear tooltip
Tooltip

; create new window if one doesn't exist
if not WinExist("ahk_class Emacs")
  prefix = -c %prefix%

; If no command line arguments, just bring window to front, or create new window
If (filecount = 0) {
  if WinExist("ahk_class Emacs")
    WinActivate, ahk_class Emacs
  Else
    Run %emacs_path%%client% -n %prefix%

  WinWait, ahk_class Emacs
  ExitApp
}

; If filecount = 1
; {
;   ; MsgBox, Running Now
;   Run %emacs_path%%client% -n %prefix% %param%
;   ExitApp
; }

if (mode == "ediff-files") {
  if (filecount < 2) {
    MsgBox, At least two files are needed to perform a difference
    ExitApp
  }
  else if (filecount > 2)
    mode=ediff3
}

if (mode) {
  ; MsgBox "mode"
  Run %emacs_path%%client% %prefix% -e "(%mode% %files%)"
}
else {
  ; MsgBox "command"
  Run %emacs_path%%client% %prefix% %command% %suffix%
}

WinActivate, ahk_class Emacs

Exit:
  ExitApp
  Return

Help:
  message =
  (LTrim0
Arguments:
  -f  Create a new frame
  -d  or  --diff Diff mode (like 'ediff')
  -C   Don't load .emacs.d
  -f   Create new frame
  -D   Debugging mode
  -B   List Emacs buffers
  --eq Make created windows equal
  -T <terminal> Open Emacs in shell-mode
  -f  Open tab pages (default: one for each file)
  -o  Open windows horizontally (default: one for each file)
  -v  Like -o but split vertically
  -e <execute>  <Execute> function after loading the first file
  -S <server>  Open in specified Emacs server
  -h  or  --help Print Help (this message) and exit
  )
  MsgBox %message%
  ExitApp
  return
