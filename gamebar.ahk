#Persistent
#SingleInstance, Force
CoordMode, Mouse, Screen

SetTimer, WatchMouse, 250

WatchMouse:
 MouseGetPos, mx, my
 if (mx > 400 && mx < 800 && my = 0) {
  SetTimer, WatchMouse, Off
  Sleep, 400
  MouseGetPos, nx, my
  if (nx = mx && my = 0) {
   Loop, C:\Games\*.*
   {
    lnk := RegExReplace(A_LoopFileName, ".lnk")
    Gui, Games:Add, Button, w230 h30 gGameBut, % lnk
   }
   Gui, Games:+ToolWindow
   Gui, Games:Add, Button, w230 h30 gComic, Comic Reader
   Gui, Games:Add, Button, w230 h30 gSteam, Steam
   Gui, Games:Show, x%mx% y%my%, AHK - Games Menu
   SetTimer, WatchMouseOnceOpen, 250
  } else {
   SetTimer, WatchMouse, 250
  }
 }
return

WatchMouseOnceOpen:
 MouseGetPos, mx, my
 WinGetPos, wx, wy, ww, wh, AHK - Games Menu
 if (my > wh + 30 || mx < wx - 100 || mx > (wx + ww) + 100) {
  GoSub, GamesGuiClose
  SetTimer, WatchMouseOnceOpen, Off
  SetTimer, WatchMouse, 250
 }
return

WatchMouseOnceSteamOpen:
 MouseGetPos, mx, my
 WinGetPos, wx, wy, ww, wh, AHK - Steam Menu
 if (my > (wy + 30)) {
  if (my > wh + wy + 30 || mx < wx - 100 || mx > (wx + ww) + 100) {
   GoSub, CloseAll
   SetTimer, WatchMouseOnceSteamOpen, Off
   SetTimer, WatchMouse, 250
  }
 } else {
  WinGetPos, wx, wy, ww, wh, AHK - Games Menu
  if (my > wh + 30 || mx < wx - 100 || mx > (wx + ww) + 100) {
   GoSub, closeAll
   SetTimer, WatchMouseOnceSteamOpen, Off
   SetTimer, WatchMouse, 250
  }
 }
return

GameBut:
 lnk := "C:\Games\" A_GuiControl ".lnk"
 GoSub, CloseAll
 SetTimer, WatchMouse, 250
 Run, % lnk
return

Comic:
 Run, %ComSpec% /c "cd C:\Users\Deadpool\WebstormProjects\comic-reader\ && npm run start"
return

Steam:
 SetTimer, WatchMouseOnceOpen, Off
 WinGetPos, winx, , , , AHK - Games Menu
 menx := winx + 230
 Gui, Steam:Add, Button, w230 h30 gSteamOpen, Open Steam
 Loop, C:\Games\Steam\*.*
 {
  lnk := RegExReplace(A_LoopFileName, ".url")
  Gui, Steam:Add, Button, w230 h30 gSteamBut, % lnk
 }
 Gui, Steam:+ToolWindow
 Gui, Steam:Show, x%menx% y110, AHK - Steam Menu
 SetTimer, WatchMouseOnceSteamOpen, 250
return

SteamBut:
 lnk := "C:\Games\Steam\" A_GuiControl ".url"
 GoSub, CloseAll
 SetTimer, WatchMouse, 250
 Run, % lnk
return

SteamOpen:
 GoSub, CloseAll
 SetTimer, WatchMouse, 250
 Run, "C:\Program Files (x86)\Steam\Steam.exe"
return

CloseAll:
 GoSub, GamesGuiClose
 GoSub, SteamGuiClose
return

GamesGuiClose:
 Gui, Games:Destroy
 SetTimer, WatchMouse, 250
return

SteamGuiClose:
 Gui, Steam:Destroy
return