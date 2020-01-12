;****************************************************************************************************
;********************************random by iSSoGoo v0.0.2 - 2013-05-11*******************************
;****************************************************************************************************
;
;	ATTENTION: I wrote these functions just for myself, please DON'T USE THEM, they are very likely buggy ;)
;				(for a short version history have a look at the end of this file)
;	
;	Contact: iSSoGoo (at) gmail.com
;
;
;
;	This function generates a pseudo random string or a pseudo random integer (32Bit)
;
;
;
;	Sytax:
;
;	int randomInt(				; returns an radomized integer value (EAX)
;	);			
;
;
;	int randomIntMinMax(		; returns an radomized integer value (EAX)
;		int	min,				; minimum value 
;		int max					; maximum value
;	);							; If min is greater the max, zero is returned!
;
;
;	void randomNumStr(			; generates a random numeric-only string
;		LPTSTR	lpString, 		; pointer to the adress where the string should be stored
;		int		len				; length of the string (including zero termination)
;	);
;
;
;	void randomAlphaStr(		; generates a random string with alphabetic chars
;		LPTSTR	lpString, 		; pointer to the adress where the string should be stored
;		int		len,			; length of the string (including zero termination)
;		BOOL	uppercase,		; uppercase chars are generated
;		BOOL 	lowercase		; lowercase chars are generated
;	);							; Note: if both, upper- & lowercase are set to false, 
;								; The function does nothing!
;
;
;	void randomAlphaNumStr(		; generates a random string with alphabetic and numeric chars
;		LPTSTR	lpString, 		; pointer to the adress where the string should be stored
;		int		len,			; length of the string (including zero termination)
;		BOOL	uppercase,		; uppercase chars are generated
;		BOOL 	lowercase		; lowercase chars are generated
;	);							; Note: if both, upper- & lowercase are set to false, 
;								; The function does nothing!
;
;
;	void randomPrintableStr(	; generates a random string with all ASCII-Chars from 33 to 127
;		LPTSTR	lpString, 		; pointer to the adress where the string should be stored
;		int		len				; length of the string (including zero termination)
;	);
;
;
;	void setRenew(				; If you want to let the randomInt() function call the randomRenew() function if  
;		BOOL	renew			; randomOffset reached FFh, set this to true, else the random number will wrap!
;	);
;
;
;	void randomRenew(			; This function generates new random numbers
;	);
;
;
;****************************************************************************************************



; Includings
include 			randomNumbers.dat



; Prototypes
randomInt			proto
randomIntMinMax		proto :DWORD,:DWORD
randomNumStr		proto :DWORD,:DWORD
randomAlphaStr 		proto :DWORD,:DWORD,:DWORD,:DWORD 
randomAlphaNumStr 	proto :DWORD,:DWORD,:DWORD,:DWORD 
randomPrintableStr	proto :DWORD,:DWORD
setRenew			proto :DWORD
randomRenew			proto



; Data
.data
randomOffset	db 0h	; pointer-offset for the randomNumbers-field 
randomRenewFlag	db 0h



; Code
.code
;###randomInt########################################################################################
randomInt proc
		PUSH EBX
		
		XOR		EBX, EBX
		MOV		BL, randomOffset
		MOV		EAX, [randomNumbers+EBX]
		INC		BL
		MOV		randomOffset, BL
		.if BL==0
			MOV BL, randomRenewFlag
			.if BL==TRUE
				invoke randomRenew
			.endif
		.endif
		
		POP	EBX
		RET
randomInt EndP
;####################################################################################################



;###randomIntMinMax##################################################################################
randomIntMinMax proc min:UINT, max:UINT
		PUSH	ECX
		PUSH	EDX		
		
		MOV		ECX, max
		MOV		EDX, min
		
		.if EDX>ECX
			XOR	EAX, EAX
			JMP	@f
		.endif
		
		invoke randomInt
		
		SUB		ECX, EDX
		INC		ECX
		XOR		EDX, EDX
		DIV		ECX
		MOV		EAX, min 
		ADD		EAX, EDX
		
	@@:
		POP		EDX
		POP		ECX
		RET		
randomIntMinMax EndP
;####################################################################################################



;###randomNumStr#####################################################################################
randomNumStr proc lpString:LPTSTR, len:UINT
		PUSHA
		
		MOV EBX, len
		.if	EBX!=0
			DEC	EBX
			MOV	EDI, lpString
			XOR EAX, EAX
			MOV	[EDI+EBX], AL	; zero termination
			
			MOV	ECX, 10
			@@:
				.if EBX!=0
					invoke randomInt
					XOR	EDX, EDX
					DIV	ECX
					ADD	DL, 030h
					MOV [EDI+EBX-1], DL
					DEC	EBX
					JMP @b				
				.endif
		
		.endif
		
		POPA
		RET
randomNumStr EndP
;####################################################################################################



;###randomAlphaStr###################################################################################
randomAlphaStr proc lpString:LPTSTR, len:UINT, uppercase:BOOL, lowercase:BOOL
		PUSHA
		
		MOV EBX, len
		.if	EBX!=0
			MOV ESI, uppercase
			.if ESI==FALSE
				MOV ESI, lowercase
				.if ESI==FALSE
					POPA
					RET	
				.endif
			.endif	
				
			DEC	EBX
			MOV	EDI, lpString
			XOR EAX, EAX
			MOV	[EDI+EBX], AL	; zero termination
			
			MOV	ECX, 26
			@@:
				.if EBX!=0
					invoke randomInt
					XOR	EDX, EDX
					DIV	ECX
					MOV ESI, uppercase
					.if ESI==TRUE
						MOV ESI, lowercase
						.if ESI==TRUE
							invoke randomInt
							AND AL, 1			; get last bit
							.if AL==0
								ADD	DL, 041h	; uppercase	
							.else
								ADD	DL, 061h	; lowercase
							.endif
						.else
							ADD	DL, 041h	; uppercase	
						.endif
					.else 
						ADD	DL, 061h	; lowercase
					.endif
						
					MOV [EDI+EBX-1], DL
					DEC	EBX
					JMP @b				
				.endif
		
		.endif
		
		POPA
		RET
randomAlphaStr EndP
;####################################################################################################



;###randomAlphaNumStr################################################################################
randomAlphaNumStr proc lpString:LPTSTR, len:UINT, uppercase:BOOL, lowercase:BOOL
		PUSHA
		
		MOV EBX, len
		.if	EBX!=0
			MOV ESI, uppercase
			.if ESI==FALSE
				MOV ESI, lowercase
				.if ESI==FALSE
					POPA
					RET	
				.endif
			.endif	
				
			DEC	EBX
			MOV	EDI, lpString
			XOR EAX, EAX
			MOV	[EDI+EBX], AL	; zero termination
			
			@@:
				.if EBX!=0
					invoke randomInt
					AND AL, 1
					.if AL==0
						;Alpha
						MOV	ECX, 26
						invoke randomInt
						XOR	EDX, EDX
						DIV	ECX
						MOV ESI, uppercase
						.if ESI==TRUE
							MOV ESI, lowercase
							.if ESI==TRUE
								invoke randomInt
								AND AL, 1			; get last bit
								.if AL==0
									ADD	DL, 041h	; uppercase	
								.else
									ADD	DL, 061h	; lowercase
								.endif
							.else
								ADD	DL, 041h	; uppercase	
							.endif
						.else 
							ADD	DL, 061h	; lowercase
						.endif
					.else
						;Numeric
						MOV	ECX, 10
						invoke randomInt
						XOR	EDX, EDX
						DIV	ECX
						ADD	DL, 030h
					.endif	
						
					MOV [EDI+EBX-1], DL
					DEC	EBX
					JMP @b				
				.endif
		
		.endif
		
		POPA
		RET
randomAlphaNumStr EndP
;####################################################################################################



;###randomPrintableStr##############################################################################
randomPrintableStr proc lpString:LPTSTR, len:UINT
		PUSHA
		
		MOV EBX, len
		.if	EBX!=0
			DEC	EBX
			MOV	EDI, lpString
			XOR EAX, EAX
			MOV	[EDI+EBX], AL	; zero termination
			
			@@:
				.if EBX!=0
					invoke randomIntMinMax, 32, 127
					MOV [EDI+EBX-1], AL
					DEC	EBX
					JMP @b				
				.endif
		.endif
		
		POPA
		RET
randomPrintableStr EndP
;####################################################################################################



;###randomRenew######################################################################################
randomRenew proc
	PUSHA
	
	MOV		ECX, 256
	
	rand_loop:	
		PUSH	ECX
		invoke GetTickCount
		XOR		ECX, ECX	
		MOV		CL, AL
		SHR		CL, 3
		@@:
			.if ECX!=0
				ROL		EAX, 1
				DEC		ECX
				JMP	@b
			.endif
		POP		ECX
		XOR		[randomNumbers+ECX*4-4], EAX
	LOOP rand_loop	
	
	MOV		randomOffset, CL
	
	POPA
	RET
randomRenew EndP	
;####################################################################################################



;###setRenew#########################################################################################
setRenew proc renew:BOOL
	PUSHA
	
	MOV	EAX, renew
	XOR	EBX, EBX
	
	.if EAX==TRUE
		INC EBX	
	.endif
	
	MOV randomRenewFlag, BL
	
	POPA
	RET
setRenew EndP	
;####################################################################################################




;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Version-History~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
;
;******************************v0.0.2 - 2013-05-11******************************
;
;	- improved: minor improvements
;	- rename: randomMixStr is now randomPrintableStr
;
;
;
;******************************v0.0.1 - 2013-05-05******************************
;
;	- initial release
;
;
;
