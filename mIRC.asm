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
include ./inc/random.inc

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
KeyFileProc PROTO : HWND
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
wsptf 	db "%u-%u",0
TABLE	db 00Bh, 000h, 000h, 000h, 006h, 000h, 000h, 000h
		db 011h, 000h, 000h, 000h, 00Ch, 000h, 000h, 000h
		db 00Ch, 000h, 000h, 000h, 00Eh, 000h, 000h, 000h
		db 005h, 000h, 000h, 000h, 00Ch, 000h, 000h, 000h
		db 010h, 000h, 000h, 000h, 00Ah, 000h, 000h, 000h
		db 00Bh, 000h, 000h, 000h, 006h, 000h, 000h, 000h
		db 00Eh, 000h, 000h, 000h, 00Eh, 000h, 000h, 000h
		db 004h, 000h, 000h, 000h, 00Bh, 000h, 000h, 000h
		db 006h, 000h, 000h, 000h, 00Eh, 000h, 000h, 000h
		db 00Eh, 000h, 000h, 000h, 004h, 000h, 000h, 000h
		db 00Bh, 000h, 000h, 000h, 009h, 000h, 000h, 000h
		db 00Ch, 000h, 000h, 000h, 00Bh, 000h, 000h, 000h
		db 00Ah, 000h, 000h, 000h, 008h, 000h, 000h, 000h
		db 00Ah, 000h, 000h, 000h, 00Ah, 000h, 000h, 000h
		db 010h, 000h, 000h, 000h, 008h, 000h, 000h, 000h
		db 00Ah, 000h, 000h, 000h, 006h, 000h, 000h, 000h
		db 00Ah, 000h, 000h, 000h, 00Ch, 000h, 000h, 000h
		db 010h, 000h, 000h, 000h, 008h, 000h, 000h, 000h
		db 00Ah, 000h, 000h, 000h, 004h, 000h, 000h, 000h
		db 010h, 000h, 000h, 000h

; Keygen parameters
; ------------------------------------------------------------------------------

; Required data
sId          TCHAR "#?", 0
sTitle       TCHAR "mIRC v6 Keygen", 0
sDefaultName TCHAR "tiphergane // nact", 0
sInfo        TCHAR "mIRC up to v6.21 Keygen", 10, 13
             TCHAR "Protection: Math + Table", 10, 13
             TCHAR 10, 13
             TCHAR "Author: tiphergane", 10, 13
             TCHAR "WWW: http://tiphergane.free.fr", 10, 13
             TCHAR 10, 13
             TCHAR "Thanks to: RaX|, Neitsa, Meat, Haiklr", 10, 13
             TCHAR "Greetings: NGEN, FFF, RIF, CiM, Defisfc", 10, 13
             TCHAR 10, 13
             TCHAR "Music: So Close- Unknown", 10, 13
			 TCHAR "Keygen Template: Canterwood", 10, 13
             TCHAR "Image: Nact logo - Meat", 10, 13
             TCHAR 10, 13
	     TCHAR 0

; Keygen definided-variables
sValidError TCHAR "You must Enter a Name", 0
sValidErrorHigh TCHAR "Name Should have less than 51 chars", 0
sValidErrorLow	TCHAR "Name Should have more than 3 chars", 0
.data?


; Required data
sLen	CHAR 60h dup(?)
sName   CHAR 60h dup(?)
sSerial CHAR 60h dup(?)
sPart1	CHAR 60h dup(?)
sPart2	CHAR 60h dup(?)




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
    .ELSEIF (edx == EN_UPDATE && ax == IDC_NAME) ;|| wParam == IDC_GENERATE
      INVOKE KeygenProc, hWnd
	 .ELSEIF wParam == IDC_GENERATE
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

; ------------------------------------------------------------------------------
; Keygen procedure
; ------------------------------------------------------------------------------
Start:
KeygenProc PROC hWnd: HWND
  push edi
  push esi
  push ebx

  INVOKE GetDlgItemText, hWnd, IDC_NAME, ADDR sName, SIZEOF sName
  mov	dword ptr [sLen], eax

 
  .if (eax > 3h) && (eax < 34h)
;------------------------------------------------------------------------------
;your Keygen Algo start Here
  
  xor esi, esi																					;mise à 0 des registres
  xor edi, edi
  xor eax, eax
  xor ebx, ebx
  mov ecx, offset sName																			;on place le Name dans le registre ecx
	
		
		add		ecx, 3h																			;on commence au 4eme char du name (on compte de 0 à 3)	
  Loop1:																						;début du serial
		
		movzx	esi, byte ptr ds:[ecx]															;on met dans esi ce qui est contenu dans ecx
		imul	esi, dword ptr ds:[eax*4+offset TABLE]											;on multiplie esi avec le résultat de compteur*4+table (si eax = 1 alors 1*4+table = 2nd valeure du tableau)	
		add		ebx, esi																		;on additionne les résultats entre eux
		inc		eax																				;on incrémente le compteur
		cmp		eax, 26h																		;on vérifie si le compteur est égale à 38d (26h = 38d)
		jle		raz1																			;si inférieur à 38 alors on évite le retour à zéro du compteur du tableau
		xor		eax, eax
  raz1:
		inc		ecx																				;char suivant
		cmp		byte ptr [ecx], 0h															    ;check si le name est fini
		jne		Loop1																			;si non alors Boucle

		mov 	dword ptr [sPart1], ebx															;déplace le résultat final dans l'offset sPart1
		
		xor		eax, eax																		;la seconde partie est quasiement identique, à part qu'elle multiplie char*(char-1)
		mov 	ecx, offset sName
		add 	ecx, 3h
		xor		ebx, ebx
		
  Loop2:
		
		movzx	esi, byte ptr [ecx]
		movzx	edi, byte ptr [ecx-1]
		imul	esi,edi
		imul	esi, dword ptr ds:[eax*4+offset TABLE]
		add		ebx, esi
		inc		eax
		cmp		eax, 26h
		jle		raz2
		xor		eax, eax
   raz2:
		inc		ecx
		cmp		byte ptr [ecx], 0h
		jne		Loop2
		
		mov dword ptr [sPart2], ebx		 														;déplace le résultat dans l'offset sPart2


	

;your Keygen Algo stop Here 
;-------------------------------------------------------------------------------
  @@:
	push dword ptr [sPart2]																		;On push l'offset sPart2
	push dword ptr [sPart1]																		;On push l'offset sPart1
  invoke	wsprintf, addr sSerial, addr wsptf													;On format le résultat avec wsptf %u-%u et on le stock dans l'offset sSerial
  INVOKE SetDlgItemText, hWnd, IDC_SERIAL, ADDR sSerial											;On affiche dans l'editbox IDC_SERIAL le contenu de l'offset sSerial  
 jmp EndGen
;end of keygen routine
; ------------------------------------------------------------------------------  
 .elseif (eax > 33h)
   ValidityErrorHigh:
  INVOKE SetDlgItemText, hWnd, IDC_SERIAL, ADDR sValidErrorHigh
   .elseif (eax < 4h)
   ValidityErrorLow:
  INVOKE SetDlgItemText, hWnd, IDC_SERIAL, ADDR sValidErrorLow
 .else
  ValidityError:
  INVOKE SetDlgItemText, hWnd, IDC_SERIAL, ADDR sValidError
.endif
  jmp EndGen


  EndGen:
  pop ebx
  pop esi
  pop edi
  ret

KeygenProc ENDP
; ------------------------------------------------------------------------------

END start