; Keygen template
; ==============================================================================
; Author : Canterwood <canterwood@altern.org>
; Website: http://kickme.to/canterwood
; IDE    : MASM32 8
; ==============================================================================
; v2.2.1 [16.01.2004]

.486
.model flat, stdcall
option casemap: none

; Lib functions
; ------------------------------------------------------------------------------
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\gdi32.inc
include ./inc/mfmplayer.inc                ; XM player (thanks to Lise_Grim)


includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\gdi32.lib
includelib ./lib/mfmplayer.lib

; Additional libs

; ------------------------------------------------------------------------------

; Functions
; ------------------------------------------------------------------------------
DialogProc PROTO : HWND, : UINT, : WPARAM, : LPARAM
IdProc     PROTO : HWND, : UINT, : WPARAM, : LPARAM
InfoProc   PROTO : HWND, : UINT, : WPARAM, : LPARAM
DrawItem   PROTO : HWND, : LPARAM
KeygenProc PROTO : HWND
; ------------------------------------------------------------------------------

.const

; Resource ids
; ------------------------------------------------------------------------------
IDD_KEYGEN   equ 100
IDD_INFO     equ 101

IDI_KEYGEN   equ 200

IDC_TITLE    equ 400
IDC_ID       equ 401
IDC_GENERATE equ 402
IDC_COPY     equ 403
IDC_EXIT     equ 404
IDC_NAME     equ 405
IDC_SERIAL   equ 406
IDC_INFO     equ 407
IDC_CLOSE    equ 408

IDM_KEYGEN   equ 500
; ------------------------------------------------------------------------------

; Colors
; ------------------------------------------------------------------------------
CR_BACKGROUND equ 009933FFh
CR_FOREGROUND equ 00000000h
CR_HIGHLIGHT  equ 00CCCCFFh
CR_INPUT      equ 009933FFh
CR_INPUT2     equ 009933FFh
CR_TEXT       equ 009999FFh
; ------------------------------------------------------------------------------

.data
wsptf 	db "picoCTF{0x%x}",0

; Keygen parameters
; ------------------------------------------------------------------------------

; Required data
sId          TCHAR "#?", 0
sTitle       TCHAR "Not Another Keygen", 0
sDefaultName TCHAR "tiphergane // nact", 0
sInfo        TCHAR "PicoCTF 2019 asm2", 10, 13
             TCHAR "Protection: none", 10, 13
             TCHAR 10, 13
             TCHAR "Author: tiphergane", 10, 13
             TCHAR "WWW: https://game2019.picoctf.com", 10, 13
             TCHAR 10, 13
             TCHAR "Thanks to: RaX|, Neitsa, Meat, Haiklr", 10, 13
             TCHAR "Greetings: NGEN, FFF, RIF, CiM, Defisfc", 10, 13
             TCHAR 10, 13
             TCHAR "Music: So Close", 10, 13
             TCHAR "Image: Nact logo - Meat", 0

; Keygen definided-variables
sValidError TCHAR "You must enter a name.", 0

.data?


; Required data
sSerial  CHAR 500h dup(?)
sName	  CHAR 500h dup(?)

; Keygen undefinided-variables

; ------------------------------------------------------------------------------

hInstance  HINSTANCE ?

hIcon      HICON     ?
hIdCursor  HCURSOR   ?

; Brushes & pens
hBgColor   HBRUSH    ?
hFgColor   HBRUSH    ?
hInColor   HBRUSH    ?
hIn2Color  HBRUSH    ?
hEdge      HPEN      ?

; Font & text
BoldFont   LOGFONT   <?>
sBtnText   TCHAR     16 dup(?)

; Music
nMusicSize DWORD     ?
pMusic     LPVOID    ?

DefIdProc  WNDPROC   ?

.code

start:

INVOKE GetModuleHandle, NULL
mov hInstance, eax

; Load icon & cursor
INVOKE LoadIcon, eax, IDI_KEYGEN
mov hIcon, eax
INVOKE LoadCursor, NULL, IDC_HAND
mov hIdCursor, eax

; Create brushes for custom colors
INVOKE CreateSolidBrush, CR_BACKGROUND
mov hBgColor, eax
INVOKE CreateSolidBrush, CR_FOREGROUND
mov hFgColor, eax
INVOKE CreateSolidBrush, CR_INPUT
mov hInColor, eax
INVOKE CreateSolidBrush, CR_INPUT2
mov hIn2Color, eax
INVOKE CreatePen, PS_INSIDEFRAME, 1, CR_FOREGROUND
mov hEdge, eax

; Load the music
push esi
INVOKE FindResource, hInstance, IDM_KEYGEN, RT_RCDATA
push eax
INVOKE SizeofResource, hInstance, eax
mov nMusicSize, eax
pop eax
INVOKE LoadResource, hInstance, eax
INVOKE LockResource, eax
mov esi, eax
mov eax, nMusicSize
add eax, SIZEOF nMusicSize
INVOKE GlobalAlloc, GPTR, eax
mov pMusic, eax
mov ecx, nMusicSize
mov dword ptr [eax], ecx
add eax, SIZEOF nMusicSize
mov edi, eax
rep movsb
pop esi

; Show the dialog box
INVOKE DialogBoxParam, hInstance, IDD_KEYGEN, NULL, ADDR DialogProc, 0

; Restore the memory used for the music
;INVOKE GlobalFree, pMusic

; Restore the memory used for graphic objects
INVOKE DeleteObject, hEdge
INVOKE DeleteObject, hInColor
INVOKE DeleteObject, hIn2Color
INVOKE DeleteObject, hFgColor
INVOKE DeleteObject, hBgColor

; Exit the program
INVOKE ExitProcess, 0

; Dialog procedure
; ------------------------------------------------------------------------------
DialogProc PROC hWnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM

  .IF uMsg == WM_CTLCOLORDLG
    mov eax, hBgColor
    ret
  .ELSEIF uMsg == WM_CTLCOLORSTATIC
    INVOKE GetDlgCtrlID, lParam

    .IF eax == IDC_TITLE
      INVOKE SendMessage, hWnd, WM_GETFONT, 0, 0
      INVOKE GetObject, eax, SIZEOF LOGFONT, ADDR BoldFont
      mov BoldFont.lfWeight, FW_BOLD
      mov BoldFont.lfItalic, TRUE
      INVOKE CreateFontIndirect, ADDR BoldFont
      INVOKE SelectObject, wParam, eax

      INVOKE SetBkMode, wParam, TRANSPARENT
      INVOKE SetTextColor, wParam, CR_HIGHLIGHT
      mov eax, hFgColor
      ret
    .ELSE
      INVOKE SetBkMode, wParam, TRANSPARENT

      .IF eax == IDC_SERIAL
        INVOKE SetTextColor, wParam, CR_HIGHLIGHT
      .ELSE
        INVOKE SetTextColor, wParam, CR_TEXT
      .ENDIF

      mov eax, hBgColor
      ret
    .ENDIF

  .ELSEIF uMsg == WM_CTLCOLOREDIT
    INVOKE SetBkMode, wParam, TRANSPARENT
    INVOKE SetTextColor, wParam, CR_HIGHLIGHT
    mov eax, hInColor
    ret
  .ELSEIF uMsg == WM_DRAWITEM
    INVOKE DrawItem, hWnd, lParam
  .ELSEIF uMsg == WM_LBUTTONDOWN
    INVOKE SendMessage, hWnd, WM_NCLBUTTONDOWN, HTCAPTION, lParam
  .ELSEIF uMsg == WM_COMMAND
    mov eax,wParam
    mov edx,wParam
    shr edx,16

    .IF wParam == IDC_ID
      INVOKE DialogBoxParam, hInstance, IDD_INFO, hWnd, ADDR InfoProc, 0
    .ELSEIF (edx == EN_UPDATE && ax == IDC_NAME) || wParam == IDC_GENERATE
		INVOKE KeygenProc, hWnd
	    
    .ELSEIF wParam == IDC_COPY
      INVOKE GetDlgItemText, hWnd, IDC_SERIAL, ADDR sSerial, SIZEOF sSerial

      .IF eax != 0
        INVOKE OpenClipboard, hWnd

        .IF eax
          INVOKE GlobalAlloc, GMEM_MOVEABLE or GMEM_DDESHARE, SIZEOF sSerial

          .IF eax != NULL
            push eax
            push eax

            INVOKE GlobalLock, eax
            mov edi, eax
            mov esi, OFFSET sSerial
            mov ecx, SIZEOF sSerial
            rep movsb
            pop eax
            INVOKE GlobalUnlock, eax

            INVOKE EmptyClipboard
            pop eax
            INVOKE SetClipboardData, CF_TEXT, eax
          .ENDIF

          INVOKE CloseClipboard
        .ENDIF

      .ENDIF

    .ELSEIF wParam == IDC_EXIT
      INVOKE SendMessage, hWnd, WM_CLOSE, 0, 0
    .ENDIF

  .ELSEIF uMsg == WM_INITDIALOG

    ; Subclass the id control
    INVOKE GetDlgItem, hWnd, IDC_ID
    INVOKE SetWindowLong, eax, GWL_WNDPROC, ADDR IdProc
    mov DefIdProc, eax

    INVOKE SendMessage, hWnd, WM_SETICON, ICON_BIG, hIcon

    ; Set the limit for the name text field
    INVOKE SendDlgItemMessage, hWnd, IDC_NAME, EM_SETLIMITTEXT, SIZEOF sName - 1, 0

    INVOKE SetWindowText, hWnd, ADDR sTitle
    INVOKE SetDlgItemText, hWnd, IDC_TITLE, ADDR sTitle
    INVOKE SetDlgItemText, hWnd, IDC_ID, ADDR sId
    INVOKE SetDlgItemText, hWnd, IDC_NAME, ADDR sDefaultName

    INVOKE mfmPlay, pMusic

    INVOKE KeygenProc, hWnd
  .ELSEIF uMsg == WM_CLOSE
    INVOKE mfmPlay, 0

    INVOKE EndDialog, hWnd, 0
  .ENDIF

  xor eax, eax
  ret
DialogProc ENDP
; ------------------------------------------------------------------------------

; Id procedure
; ------------------------------------------------------------------------------
IdProc PROC hWnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM

  .IF uMsg == WM_SETCURSOR
    INVOKE SetCursor, hIdCursor
  .ELSE
    INVOKE CallWindowProc, DefIdProc, hWnd, uMsg, wParam, lParam
    ret
  .ENDIF

  xor eax, eax
  ret
IdProc ENDP
; ------------------------------------------------------------------------------

InfoProc PROC hWnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM

  .IF uMsg == WM_CTLCOLORDLG
    mov eax, hFgColor
    ret
  .ELSEIF uMsg == WM_CTLCOLORSTATIC
    INVOKE SetBkMode, wParam, TRANSPARENT
    INVOKE SetTextColor, wParam, CR_TEXT
    mov eax, hBgColor
    ret
  .ELSEIF uMsg == WM_DRAWITEM
    INVOKE DrawItem, hWnd, lParam
  .ELSEIF uMsg == WM_INITDIALOG
    INVOKE SetDlgItemText, hWnd, IDC_INFO, ADDR sInfo
  .ELSEIF uMsg == WM_COMMAND

    .IF wParam == IDC_CLOSE
      INVOKE SendMessage, hWnd, WM_CLOSE, 0, 0
    .ENDIF

  .ELSEIF uMsg == WM_CLOSE
    INVOKE EndDialog, hWnd, 0
  .ENDIF

  xor eax, eax
  ret
InfoProc ENDP

DrawItem PROC hWnd: HWND, lParam: LPARAM
  push esi
  mov esi, lParam
  assume esi: ptr DRAWITEMSTRUCT

  .IF [esi].itemState & ODS_SELECTED
    INVOKE SelectObject, [esi].hdc, hIn2Color
  .ELSE
    INVOKE SelectObject, [esi].hdc, hInColor
  .ENDIF

  INVOKE SelectObject, [esi].hdc, hEdge

  INVOKE FillRect, [esi].hdc, ADDR [esi].rcItem, hFgColor
  INVOKE RoundRect, [esi].hdc, [esi].rcItem.left, [esi].rcItem.top, [esi].rcItem.right, [esi].rcItem.bottom, 6, 6

  .IF [esi].itemState & ODS_SELECTED
    INVOKE OffsetRect, ADDR [esi].rcItem, 1, 1
  .ENDIF

  ; Write the text
  INVOKE GetDlgItemText, hWnd, [esi].CtlID, ADDR sBtnText, SIZEOF sBtnText
  INVOKE SetBkMode, [esi].hdc, TRANSPARENT
  INVOKE SetTextColor, [esi].hdc, CR_HIGHLIGHT
  INVOKE DrawText, [esi].hdc, ADDR sBtnText, -1, ADDR [esi].rcItem, DT_CENTER or DT_VCENTER or DT_SINGLELINE

  .IF [esi].itemState & ODS_SELECTED
    INVOKE OffsetRect, ADDR [esi].rcItem, -1, -1
  .ENDIF

  ; Draw the focus rectangle
  .IF [esi].itemState & ODS_FOCUS
    INVOKE InflateRect, ADDR [esi].rcItem, -3, -3
    ;INVOKE DrawFocusRect, [esi].hdc, ADDR [esi].rcItem
  .ENDIF

  assume esi:nothing
  pop esi
  mov eax, TRUE
  ret
DrawItem ENDP

; Keygen procedure
; ------------------------------------------------------------------------------
KeygenProc PROC hWnd: HWND
  push edi
  push esi
  push ebx
  
    
 INVOKE GetDlgItemText, hWnd, IDC_NAME, ADDR sName, SIZEOF sName
 ;invoke CharUpper, addr sName
  cmp eax,5
  jl	ValidityError

  
  Generation:

  mov eax, 9h									;mov 9h in eax
  mov ebx, 1eh									;mov 1eh in ebx

    asm2:
    mov    DWORD PTR [ebp-4h],ebx						;mov ebx in ebp-4 stack
    mov    DWORD PTR [ebp-8h],eax						;mov eax in ebp-8 stack
    jmp    asm3									;jump to asm3 label
    check:
    add    DWORD PTR [ebp-4h],1h						;add 1h to the value in ebp-4
    add    DWORD PTR [ebp-8h],0a9h						;add a9h to the value in ebp-8
    asm3:
    cmp    DWORD PTR [ebp-8h],47a6h						;compare if value in ebp-8 equal 4716h
    jle    check								;if lower or equal, jump to check label

  push dword ptr [ebp-4h]							;push value from ebp-4 in memory
		
  invoke	wsprintf, addr sSerial, addr wsptf					
  INVOKE SetDlgItemText, hWnd, IDC_SERIAL, ADDR sSerial			
   ;end of keygen routine
  jmp EndGen
 
  ValidityError:
  INVOKE SetDlgItemText, hWnd, IDC_SERIAL, ADDR sValidError

  EndGen:
  pop ebx
  pop esi
  pop edi
  ret
KeygenProc ENDP
; ------------------------------------------------------------------------------

END start
