; Emacs Launcher
; author : Rich Alesi
/*
Application to help manage server creation and emacsclient issues in ms-windows.

Features:
- wait to load file until server starts
- allow command line arguments to work from shell
- open daemon without showing window (autostart)
*/

;; Script settings
OnExit, Exit
SetBatchLines, -1
SetTitleMatchMode, 3
SetTitleMatchMode, fast
SetWinDelay, 10
#NoEnv
; #SingleInstance force
; #Warn                         ; Enable warnings to assist with detecting common errors.
; #WinActivateForce

files=
func=
prefix=
suffix=
mode=
emacs_path=
emacs_bin_path=

/*
EnvGet, old_path, Original_Path
If old_path
{

EnvSet, Path, %old_path%
EnvSet, Shell, 
}
*/

EnvGet, bin_path, Path

Loop, Parse, bin_path, `;
{
  If FileExist(A_LoopField . "\emacs.exe")
    {
    emacs_bin_path = %A_LoopField%
    Break
  }
}

If (emacs_bin_path=) {
  EnvGet, emacs_path, EmacsPath
  If (emacs_path=) {
    MsgBox Set environment variable "EmacsPath" to root directory of your emacs installation, or add emacs binary directory to "PATH"
    ExitApp
  }
  else {
      emacs_bin_path = %A_LoopField%\bin
  }
}

client_bin=%emacs_bin_path%\bin\emacsclientw.exe
server_bin=%emacs_bin_path%\bin\runemacs.exe

; TODO work with files with SPACES
; TODO deal with Emacs instances that aren't runing servers

;; set local variables

filecount=0
arglist=
command=
was_eval=

loop, %0% {
  param := %A_Index%
  arglist.=param
  ; MsgBox % param
  ; MsgBox % RegexMatch(param, "[*?]")
  if ((param == "--eval") or (param == "-e") or (was_eval)) {
    if was_eval
        param = "%param%"
      suffix=%suffix% %param%
      was_eval=1
  }
  else if ((param == "--diff") or (param == "-d")) {
    mode=ediff-files
  }
  else if (param == "-o") 
    func=(split-window-vertically)
  else if (param == "-v") 
    func=(split-window-horizontally)
  else if (param == "-f")
    func=(select-frame-set-input-focus (make-frame))
  else if ((param == "-h") or (param == "--help"))
    GoSub, Help
  else if (param == "--eq")
    suffix=-e "(balance-windows)"
  else if (RegexMatch(param, "^-"))
    prefix = %prefix% %param%
  else {
    ;; globbing support
    if (RegexMatch(param, "[*?]")) {
      Glob(file_list, param)
      Loop, Parse, file_list, "`n"
      {
        ; MsgBox %A_LoopField%
        If FileExist(A_LoopField) {
          filecount+=1
        ff := FindFile(A_LoopField)
          ; if (filecount==1)
          ;   command=%command% %ff%
          ; else
            command=%command% %func% %ff% 
          }
      }
    }
    ;; else treat like a file     
    else {
      filecount+=1
    ff := FindFile(param)
    ; if (filecount==1)
    ;   command=%command% %ff%
    ; else
      command=%command% %func% %ff% 
    }
  }
}

if (mode == "ediff-files") {
  if (filecount < 2) {
  MsgBox, At least two files are needed to perform a difference
ExitApp
  }
  else if (filecount > 2)
    mode=ediff3
}

if command!=
  command=-e "(progn %command%)"

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
    ; MsgBox, 4, , Delete old server files?
    ; IfMsgBox Yes
    FileDelete, %server_path%\*
  }
  Tooltip, Starting Emacs...

  
  Run %client_bin% -n -c -a %server_bin%
  ; Run cmd.exe /c "set path=%path%;%client_bin% -n -c -a %server_bin%"

  WinWait, ahk_class Emacs, , 60

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

; create new window if one doesn't exist
If not WinExist("ahk_class Emacs")
{
  If (func=-e "(make-frame)")
    func=

  Run %client_bin% -c -n %prefix%
}

WinWait, ahk_class Emacs, , 60
WinActivate, ahk_class Emacs

; If no command line arguments, just bring window to front, or create new window
If (filecount == 0) {
  If (prefix or suffix)
    Run %client_bin% -n %prefix% %suffix%
  ExitApp
}

; Open file or launch mode
if (mode) {
Run %client_bin% %prefix% -e "(%mode% %files%)"
}
else {
  Run %client_bin% %prefix% %command% %suffix%
}

Exit:
  ExitApp
  Tooltip, off
  Return


#ESCAPE::
  ExitApp
  return

Help:
  message =
  (LTrim0
 Arguments:
  -f  Create a new frame
  -d  or  --diff Diff mode (like 'ediff')
  -C   Don't load .emacs.d
  -D   Debugging mode
  --eq Make created windows equal
  -o  Open windows horizontally (default: one for each file)
  -v  Like -o but split vertically
  -e <execute>  <Execute> function after loading the first file
  -S <server>  Open in specified Emacs server
  -h  or  --help Print Help (this message) and exit
)

  MsgBox %message%
  ExitApp
  return

; Subroutine to allow file list by glob
; http://www.autohotkey.com/board/topic/26846-wildcard-folders/

Glob(ByRef list, Pattern, IncludeDirs=0)
{
  if (i:=RegExMatch(Pattern,"[*?]")) && (i:=InStr(Pattern,"\",1,i+1))
    Loop, % SubStr(Pattern, 1, i-1), 2
  Glob(list, A_LoopFileLongPath . SubStr(Pattern,i), IncludeDirs)
  else
    Loop, %Pattern%, %IncludeDirs%
    list .= (list="" ? "" : "`n") . A_LoopFileLongPath
}

FindFile(fparam) {
  ; MsgBox %fparam% exists as a file
  ;; if path not specified
  if RegExMatch(fparam, "\\") == 0
    fparam = %A_WorkingDir%\%fparam%
  
  ;; convert path to unix delimiters
  fparam := RegExReplace(fparam, "\\", "/")

  find_command=(find-file \"%fparam%\")
  return % find_command
}


