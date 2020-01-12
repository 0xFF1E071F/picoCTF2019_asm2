;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ˮ��Ч�������ӳ���
; by ���Ʊ�http://asm.yeah.net��luoyunbin@sina.com
; V 1.0.041019 --- ��ʼ�汾
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ��Դ������ֻ��Ҫ include WaveObject.asm
; Ȼ�����²�����ü��ɣ�
;********************************************************************
; 1������ˮ������
;    Ҫ��һ�����ڽ��л滭������Ҫ����һ��ˮ�����󣨱���������һЩ��������
;    invoke _WaveInit,lpWaveObject,hWnd,hBmp,dwTime,dwType
;       lpWaveObject --> ָ��һ���յ� WAVE_OBJECT �ṹ
;       hWnd --> Ҫ�滭ˮ��Ч���Ĵ��ڣ���Ⱦ���ͼƬ���������ڵĿͻ�����
;       hBmp --> ����ͼƬ���滭�ķ�Χ��Сͬ����ͼƬ��С
;       dwTime --> ˢ�µ�ʱ���������룩������ֵ��10��30
;	dwType --> =0 ��ʾԲ��ˮ����=1��ʾ��Բ��ˮ��������͸��Ч����
;       ����ֵ��eax = 0���ɹ������󱻳�ʼ������eax = 1��ʧ�ܣ�
;********************************************************************
; 2����� _WaveInit �������سɹ�������󱻳�ʼ���������󴫸����и��ֺ���
;    ����ʵ�ָ���Ч�������溯���е� lpWaveObject ����ָ���� _WaveInit ����
;    �г�ʼ���� WAVE_OBJECT �ṹ
;
;    �� ��ָ��λ�á���ʯͷ��������ˮ��
;       invoke _WaveDropStone,lpWaveObject,dwPosX,dwPosY,dwStoneSize,dwStoneWeight
;          dwPosX,dwPosY --> ����ʯͷ��λ��
;          dwStoneSize --> ʯͷ�Ĵ�С������ʼ��Ĵ�С������ֵ��0��5
;          dwStoneWeight --> ʯͷ�������������˲������ɢ�ķ�Χ��С������ֵ��10��1000
;
;    �� �Զ���ʾ��Ч
;       invoke _WaveEffect,lpWaveObject,dwEffectType,dwParam1,dwParam2,dwParam3
;          dwParam1,dwParam2,dwParam3 --> Ч���������Բ�ͬ����Ч���Ͳ������岻ͬ
;          dwEffectType --> ��Ч����
;             0 --> �ر���Ч
;             1 --> ���꣬Param1���ܼ��ٶȣ�0���ܣ�Խ��Խϡ�裩������ֵ��0��30
;                         Param2��������ֱ��������ֵ��0��5
;                         Param3������������������ֵ��50��250
;             2 --> ��ͧ��Param1���ٶȣ�0������Խ��Խ�죩������ֵ��0��8
;                         Param2������С������ֵ��0��4
;                         Param3��ˮ����ɢ�ķ�Χ������ֵ��100��500
;             3 --> ���ˣ�Param1���ܶȣ�Խ��Խ�ܣ�������ֵ��50��300
;                         Param2����С������ֵ��2��5
;                         Param3������������ֵ��5��10
;
;    �� ���ڿͻ���ǿ�Ƹ��£������ڴ��ڵ�WM_PAINT��Ϣ��ǿ�Ƹ��¿ͻ��ˣ�
;       .if     uMsg == WM_PAINT
;               invoke  BeginPaint,hWnd,addr @stPs
;               mov     @hDc,eax
;               invoke  _WaveUpdateFrame,lpWaveObject,eax,TRUE
;               invoke  EndPaint,hWnd,addr @stPs
;               xor     eax,eax
;               ret
;********************************************************************
; 3���ͷ�ˮ������
;    ʹ����Ϻ󣬱��뽫ˮ�������ͷţ����������ͷ�����Ļ������ڴ����Դ��
;       invoke  _WaveFree,lpWaveObject
;       lpWaveObject --> ָ�� WAVE_OBJECT �ṹ
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ʵ���ϵ�ϸ��˵����
;
; 1�� ˮ����������
;   �� ��ɢ��ÿһ��Ĳ�����ɢ�������ܵ�λ����
;   �� ˥����ÿ����ɢ����ʧ��������������ˮ��������ֹͣ������ȥ��
;
; 2�� Ϊ�˱�������ʱ���е������ֲ�ͼ�������ж���2��������Wave1��Wave2
;  ��������lpWave1��lpWave2ָ��Ļ������ڣ���Wave1Ϊ��ǰ���ݣ�Wave2Ϊ
;   ��һ֡�����ݣ�ÿ����Ⱦʱ�����������2����������Wave1�����ݼ������
;   �����ֱ�ͼ�󣬱��浽Wave2�У�Ȼ�����Wave1��Wave2����ʱWave1������
;   �µ����ݡ�
;      ����ķ���Ϊ��ĳ����������������ܵ��ϴ�������ƽ��ֵ * ˥��ϵ��
;   ȡ���ܵ�ƽ��ֵ��������չ����������˥��ϵ��������˥��������
;      �ⲿ�ִ����� _WaveSpread �ӳ�����ʵ�֡�
;
; 3�� ������ lpDIBitsSource �б�����ԭʼλͼ�����ݣ�ÿ����Ⱦʱ����ԭʼ
;   λͼ�����ݸ���Wave1�б���������ֲ����ݲ����µ�λͼ�����Ӿ��Ͽ���
;   ĳ���������Խ��ˮ��Խ�󣩣�����������ԽԶ���ĳ�����
;      �㷨Ϊ�����ڵ㣨x,y������Wave1���ҳ��õ㣬��������ڵ�Ĳ��ܲ�
;  ��Dx��Dy�������ݣ�������λͼ���أ�x,y����ԭʼλͼ���أ�x+Dx,y+Dy����
;   ���㷨������������СӰ�������������ƫ�ƴ�С��
;      �ⲿ�ִ����� _WaveRender �ӳ�����ʵ�֡�
;
; 4�� ��ʯͷ���㷨�ܺ����⣬����Wave1�е�ĳ���������ֵ��Ϊ��0ֵ����ֵ
;   Խ�󣬱�ʾ���µ�ʯͷ������Խ��ʯͷ�Ƚϴ��򽫸õ����ܵĵ�ȫ��
;   ��Ϊ��0ֵ��
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;
;
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
ifndef		WAVEOBJ_INC
WAVEOBJ_INC	equ	1
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
F_WO_ACTIVE		equ	0001h
F_WO_NEED_UPDATE	equ	0002h
F_WO_EFFECT		equ	0004h
F_WO_ELLIPSE		equ	0008h

WAVE_OBJECT		struct
 hWnd			dd	?
 dwFlag			dd	?	; �� F_WO_xxx ���
;********************************************************************
 hDcRender		dd	?
 hBmpRender		dd	?
 lpDIBitsSource		dd	?	; ԭʼ��������
 lpDIBitsRender		dd	?	; ������ʾ����Ļ����������
 lpWave1		dd	?	; ˮ���������ݻ���1
 lpWave2		dd	?	; ˮ���������ݻ���2
;********************************************************************
 dwBmpWidth		dd	?
 dwBmpHeight		dd	?
 dwDIByteWidth		dd	?	; = (dwBmpWidth * 3 + 3) and ~3
 dwWaveByteWidth	dd	?	; = dwBmpWidth * 4
 dwRandom		dd	?
;********************************************************************
; ��Ч����
;********************************************************************
 dwEffectType		dd	?
 dwEffectParam1		dd	?
 dwEffectParam2		dd	?
 dwEffectParam3		dd	?
;********************************************************************
; �����д���Ч
;********************************************************************
 dwEff2X		dd	?
 dwEff2Y		dd	?
 dwEff2XAdd		dd	?
 dwEff2YAdd		dd	?
 dwEff2Flip		dd	?
;********************************************************************
 stBmpInfo		BITMAPINFO <>
WAVE_OBJECT		ends
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


		.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ����������ӳ���
; ���룺Ҫ����������������ֵ������������
; ���ݣ�
; 1. ��ѧ��ʽ Rnd=(Rnd*I+J) mod K ѭ���ش����� K �����ڲ��ظ���
;    α���������K,I,J����Ϊ����
; 2. 2^(2n-1)-1 �ض�Ϊ��������2�������η���1��
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveRandom16	proc	_lpWaveObject

		mov	ebx,_lpWaveObject
		assume	ebx:ptr WAVE_OBJECT
		push	edx
		push	ecx
		mov	eax,[ebx].dwRandom
		mov	ecx,32768-1	;2^15-1
		mul	ecx
		add	eax,2048-1	;2^11-1
		adc	edx,0
		mov	ecx,2147483647	;2^31-1
		div	ecx
		mov	eax,[ebx].dwRandom
		mov	[ebx].dwRandom,edx
		and	eax,0000ffffh
		pop	ecx
		pop	edx
		ret

_WaveRandom16	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveRandom	proc	uses ebx ecx edx _lpWaveObject,_dwMax

		invoke	_WaveRandom16,_lpWaveObject
		mov	edx,eax
		invoke	_WaveRandom16,_lpWaveObject
		shl	eax,16
		or	ax,dx
		mov	ecx,_dwMax
		or	ecx,ecx
		jz	@F
		xor	edx,edx
		div	ecx
		mov	eax,edx
		@@:
		ret

_WaveRandom	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ������ɢ
; �㷨��
; Wave2(x,y) = (Wave1(x+1,y)+Wave1(x-1,y)+Wave1(x,y+1)+Wave1(x,y-1))/2-Wave2(x,y)
; Wave2(x,y) = Wave2(x,y) - Wave2(x,y) >> 5
; xchg Wave1,Wave2
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveSpread	proc	_lpWaveObject

		pushad
		mov	ebx,_lpWaveObject
		assume	ebx:ptr WAVE_OBJECT
;********************************************************************
		test	[ebx].dwFlag,F_WO_ACTIVE
		jz	_Ret

		mov	esi,[ebx].lpWave1
		mov	edi,[ebx].lpWave2
		mov	ecx,[ebx].dwBmpWidth

		mov	eax,[ebx].dwBmpHeight
		dec	eax
		mul	ecx
;********************************************************************
; ebx = width
; ecx = i��eax = max
;********************************************************************
		.while	ecx < eax
			push	eax
			.if	[ebx].dwFlag & F_WO_ELLIPSE
				mov	edx,[esi+ecx*4-1*4]
				add	edx,[esi+ecx*4+1*4]
				add	edx,[esi+ecx*4-2*4]
				add	edx,[esi+ecx*4+2*4]
				lea	edx,[edx+edx*2]
				add	edx,[esi+ecx*4-3*4]
				add	edx,[esi+ecx*4-3*4]
				add	edx,[esi+ecx*4+3*4]
				add	edx,[esi+ecx*4+3*4]

				lea	eax,[esi+ecx*4]
				sub	eax,[ebx].dwWaveByteWidth
				mov	eax,[eax]
				shl	eax,3
				add	edx,eax

				lea	eax,[esi+ecx*4]
				add	eax,[ebx].dwWaveByteWidth
				mov	eax,[eax]
				shl	eax,3
				add	edx,eax

				sar	edx,4
				sub	edx,[edi+ecx*4]

				mov	eax,edx
				sar	eax,5
				sub	edx,eax

				mov	[edi+ecx*4],edx
			.else
				mov	edx,[esi+ecx*4-1*4]
				add	edx,[esi+ecx*4+1*4]

				lea	eax,[esi+ecx*4]
				sub	eax,[ebx].dwWaveByteWidth
				add	edx,[eax]

				lea	eax,[esi+ecx*4]
				add	eax,[ebx].dwWaveByteWidth
				add	edx,[eax]

				sar	edx,1
				sub	edx,[edi+ecx*4]

				mov	eax,edx
				sar	eax,5
				sub	edx,eax

				mov	[edi+ecx*4],edx
			.endif
			pop	eax
			inc	ecx
		.endw

		mov	[ebx].lpWave1,edi
		mov	[ebx].lpWave2,esi
_Ret:
;********************************************************************
		assume	ebx:nothing
		popad
		ret

_WaveSpread	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; esi -> edi, ecx = line width
; return = (4*Pixel(x,y)+3*Pixel(x-1,y)+3*Pixel(x+1,y)+3*Pixel(x,y+1)+3*Pixel(x,y-1))/16
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveGetPixel:
		movzx	eax,byte ptr [esi]
		shl	eax,2
		movzx	edx,byte ptr [esi+3]
		lea	edx,[edx+2*edx]
		add	eax,edx
		movzx	edx,byte ptr [esi-3]
		lea	edx,[edx+2*edx]
		add	eax,edx
		movzx	edx,byte ptr [esi+ecx]
		lea	edx,[edx+2*edx]
		add	eax,edx
		mov	edx,esi
		sub	edx,ecx
		movzx	edx,byte ptr [edx]
		lea	edx,[edx+2*edx]
		add	eax,edx
		shr	eax,4
		mov	[edi],al
		inc	esi
		inc	edi
		ret
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ��Ⱦ�ӳ��򣬽��µ�֡������Ⱦ�� lpDIBitsRender ��
; �㷨��
; posx = Wave1(x-1,y)-Wave1(x+1,y)+x
; posy = Wave1(x,y-1)-Wave1(x,y+1)+y
; SourceBmp(x,y) = DestBmp(posx,posy)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveRender	proc	_lpWaveObject
		local	@dwPosX,@dwPosY,@dwPtrSource,@dwFlag

		pushad
		xor	eax,eax
		mov	@dwFlag,eax
		mov	ebx,_lpWaveObject
		assume	ebx:ptr WAVE_OBJECT

		test	[ebx].dwFlag,F_WO_ACTIVE
		jz	_Ret

		or	[ebx].dwFlag,F_WO_NEED_UPDATE
		mov	esi,[ebx].lpWave1
		mov	edi,[ebx].dwWaveByteWidth	; edi = ����ָ��

		xor	ecx,ecx
		inc	ecx		; ecx=i  --  i=1; i<height; i++
_Loop1:
		xor	edx,edx		; edx=j  --  j=0; j<width; j++
_Loop2:
		push	edx
;********************************************************************
; PosY=i+������1����-������1����
; PosX=j+������1����-������1����
;********************************************************************
		mov	eax,edi
		sub	eax,[ebx].dwWaveByteWidth
		mov	eax,[esi+eax]
		mov	@dwPosY,eax

		mov	eax,[ebx].dwWaveByteWidth
		lea	eax,[edi+eax]
		mov	eax,[esi+eax]
		sub	@dwPosY,eax
		add	@dwPosY,ecx

		mov	eax,[esi+edi-4]
		sub	eax,[esi+edi+4]
		add	eax,edx			;@dwPosX = eax
		mov	@dwPosX,eax

		cmp	eax,0
		jl	_Continue
		cmp	eax,[ebx].dwBmpWidth
		jge	_Continue
		mov	eax,@dwPosY
		cmp	eax,0
		jl	_Continue
		cmp	eax,[ebx].dwBmpHeight
		jge	_Continue
;********************************************************************
; ptrSource = dwPosY * dwDIByteWidth + dwPosX * 3
; ptrDest = i * dwDIByteWidth + j * 3
;********************************************************************
		mov	eax,@dwPosX
		lea	eax,[eax+eax*2]
		mov	@dwPosX,eax
		push	edx
		mov	eax,@dwPosY
		mul	[ebx].dwDIByteWidth
		add	eax,@dwPosX
		mov	@dwPtrSource,eax

		mov	eax,ecx
		mul	[ebx].dwDIByteWidth
		pop	edx
		lea	edx,[edx+edx*2]
		add	eax,edx			;@dwPtrDest = eax
;********************************************************************
; ��Ⱦ���� [ptrDest] = ԭʼ���� [ptrSource]
;********************************************************************
		pushad
		mov	ecx,@dwPtrSource
		mov	esi,[ebx].lpDIBitsSource
		mov	edi,[ebx].lpDIBitsRender
		lea	esi,[esi+ecx]
		lea	edi,[edi+eax]
		.if	ecx !=	eax
			or	@dwFlag,1	;�������Դ���غ�Ŀ�����ز�ͬ�����ʾ���ڻ״̬
			mov	ecx,[ebx].dwDIByteWidth
			call	_WaveGetPixel
			call	_WaveGetPixel
			call	_WaveGetPixel
		.else
			cld
			movsw
			movsb
		.endif
		popad
;********************************************************************
; ����ѭ��
;********************************************************************
_Continue:
		pop	edx
		inc	edx
		add	edi,4		; ����++
		cmp	edx,[ebx].dwBmpWidth
		jb	_Loop2

		inc	ecx
		mov	eax,[ebx].dwBmpHeight
		dec	eax
		cmp	ecx,eax
		jb	_Loop1
;********************************************************************
; ����Ⱦ���������ݿ����� hDc ��
;********************************************************************
		invoke	SetDIBits,[ebx].hDcRender,[ebx].hBmpRender,0,[ebx].dwBmpHeight,\
			[ebx].lpDIBitsRender,addr [ebx].stBmpInfo,DIB_RGB_COLORS
		.if	! @dwFlag
			and	[ebx].dwFlag,not F_WO_ACTIVE
		.endif
_Ret:
;********************************************************************
		assume	ebx:nothing
		popad
		ret

_WaveRender	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveUpdateFrame	proc	_lpWaveObject,_hDc,_bIfForce

		pushad
		mov	ebx,_lpWaveObject
		assume	ebx:ptr WAVE_OBJECT

		cmp	_bIfForce,0
		jnz	@F
		.if	[ebx].dwFlag & F_WO_NEED_UPDATE
			@@:
			invoke	BitBlt,_hDc,0,0,[ebx].dwBmpWidth,[ebx].dwBmpHeight,\
				[ebx].hDcRender,0,0,SRCCOPY
			and	[ebx].dwFlag,not F_WO_NEED_UPDATE
		.endif

		assume	ebx:nothing
		popad
		ret

_WaveUpdateFrame	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ��һ��ʯͷ
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveDropStone	proc	_lpWaveObject,_dwX,_dwY,_dwSize,_dwWeight
		local	@dwMaxX,@dwMaxY

		pushad
		mov	ebx,_lpWaveObject
		assume	ebx:ptr WAVE_OBJECT
;********************************************************************
; ���㷶Χ
;********************************************************************
		mov	edx,_dwSize
		shr	edx,1

		mov	eax,_dwX
		mov	esi,_dwY

		mov	ecx,eax
		mov	edi,esi
		add	eax,edx		; x + size
		sub	ecx,edx		; x - size

		push	edx
		.if	[ebx].dwFlag & F_WO_ELLIPSE
			shr	edx,1
		.endif
		add	esi,edx		; y + size
		sub	edi,edx		; y - size
		pop	edx

		shl	edx,1
		.if	! edx
			inc	edx
		.endif
		mov	_dwSize,edx
;********************************************************************
; �жϷ�Χ�ĺϷ���
;********************************************************************
		inc	eax
		cmp	eax,[ebx].dwBmpWidth
		jge	_Ret
		cmp	ecx,1
		jl	_Ret
		inc	esi
		cmp	esi,[ebx].dwBmpHeight
		jge	_Ret
		cmp	edi,1
		jl	_Ret

		dec	eax
		dec	esi
;********************************************************************
; ����Χ�ڵĵ��������Ϊ _dwWeight
;********************************************************************
		mov	@dwMaxX,eax
		mov	@dwMaxY,esi
		.while	ecx <=	@dwMaxX
			push	edi
			.while	edi <=	@dwMaxY
				mov	eax,ecx
				sub	eax,_dwX
				imul	eax
				push	eax
				mov	eax,edi
				sub	eax,_dwY
				imul	eax
				pop	edx
				add	eax,edx
				push	eax
				mov	eax,_dwSize
				imul	eax
				pop	edx
				.if	edx <=	eax
					mov	eax,edi
					mul	[ebx].dwBmpWidth
					add	eax,ecx
					shl	eax,2
					add	eax,[ebx].lpWave1
					push	_dwWeight
					pop	[eax]
				.endif
				inc	edi
			.endw
			pop	edi
			inc	ecx
		.endw
		or	[ebx].dwFlag,F_WO_ACTIVE
;********************************************************************
_Ret:
		assume	ebx:nothing
		popad
		ret

_WaveDropStone	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ������ɢ���ݡ���Ⱦλͼ�����´��ڡ�������Ч�Ķ�ʱ������
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveTimerProc	proc	_hWnd,_uMsg,_idEvent,_dwTime

		pushad
		mov	ebx,_idEvent
		assume	ebx:ptr WAVE_OBJECT

		invoke	_WaveSpread,ebx
		invoke	_WaveRender,ebx
		.if	[ebx].dwFlag & F_WO_NEED_UPDATE
			invoke	GetDC,[ebx].hWnd
			invoke	_WaveUpdateFrame,ebx,eax,FALSE
			invoke	ReleaseDC,[ebx].hWnd,eax
		.endif
;********************************************************************
; ��Ч����
;********************************************************************
		test	[ebx].dwFlag,F_WO_EFFECT
		jz	_Ret
		mov	eax,[ebx].dwEffectType
;********************************************************************
; Type = 1 ��㣬Param1���ٶȣ�0��죬Խ��Խ������Param2������С��Param3������
;********************************************************************
		.if	eax ==	1
			mov	eax,[ebx].dwEffectParam1
			or	eax,eax
			jz	@F
			invoke	_WaveRandom,ebx,eax
			.if	! eax
				@@:
				mov	eax,[ebx].dwBmpWidth
				dec	eax
				dec	eax
				invoke	_WaveRandom,ebx,eax
				inc	eax
				mov	ecx,eax

				mov	eax,[ebx].dwBmpHeight
				dec	eax
				dec	eax
				invoke	_WaveRandom,ebx,eax
				inc	eax
				mov	edx,eax

				invoke	_WaveRandom,ebx,[ebx].dwEffectParam2
				inc	eax
				mov	esi,eax
				invoke	_WaveRandom,ebx,[ebx].dwEffectParam3
				add	eax,50
				invoke	_WaveDropStone,ebx,ecx,edx,esi,eax
			.endif
;********************************************************************
; Type = 2 �д���Param1���ٶȣ�0��죬Խ��Խ�죩��Param2����С��Param3������
;********************************************************************
		.elseif	eax ==	2
			inc	[ebx].dwEff2Flip
			test	[ebx].dwEff2Flip,1
			jnz	_Ret

			mov	ecx,[ebx].dwEff2X
			mov	edx,[ebx].dwEff2Y
			add	ecx,[ebx].dwEff2XAdd
			add	edx,[ebx].dwEff2YAdd

			cmp	ecx,1
			jge	@F
			sub	ecx,1
			neg	ecx
			neg	[ebx].dwEff2XAdd
			@@:
			cmp	edx,1
			jge	@F
			sub	edx,1
			neg	edx
			neg	[ebx].dwEff2YAdd
			@@:
			mov	eax,[ebx].dwBmpWidth
			dec	eax
			cmp	ecx,eax
			jl	@F
			sub	ecx,eax
			xchg	eax,ecx
			sub	ecx,eax
			neg	[ebx].dwEff2XAdd
			@@:
			mov	eax,[ebx].dwBmpHeight
			dec	eax
			cmp	edx,eax
			jl	@F
			sub	edx,eax
			xchg	eax,edx
			sub	edx,eax
			neg	[ebx].dwEff2YAdd
			@@:
			mov	[ebx].dwEff2X,ecx
			mov	[ebx].dwEff2Y,edx
			invoke	_WaveDropStone,ebx,ecx,edx,[ebx].dwEffectParam2,[ebx].dwEffectParam3
;********************************************************************
; Type = 3 ���ˣ�Param1���ܶȣ�Param2����С��Param3������
;********************************************************************
		.elseif	eax ==	3
			xor	edi,edi
			.while	edi <=	[ebx].dwEffectParam1
				mov	eax,[ebx].dwBmpWidth
				dec	eax
				dec	eax
				invoke	_WaveRandom,ebx,eax
				inc	eax
				mov	ecx,eax

				mov	eax,[ebx].dwBmpHeight
				dec	eax
				dec	eax
				invoke	_WaveRandom,ebx,eax
				inc	eax
				mov	edx,eax

				invoke	_WaveRandom,ebx,[ebx].dwEffectParam2
				inc	eax
				mov	esi,eax
				invoke	_WaveRandom,ebx,[ebx].dwEffectParam3
				invoke	_WaveDropStone,ebx,ecx,edx,esi,eax
				inc	edi
			.endw
		.endif
_Ret:
		assume	ebx:nothing
		popad
		ret

_WaveTimerProc	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; �ͷŶ���
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveFree	proc	_lpWaveObject

		pushad
		mov	ebx,_lpWaveObject
		assume	ebx:ptr WAVE_OBJECT
;********************************************************************
		.if	[ebx].hDcRender
			invoke	DeleteDC,[ebx].hDcRender
		.endif
		.if	[ebx].hBmpRender
			invoke	DeleteObject,[ebx].hBmpRender
		.endif
		.if	[ebx].lpDIBitsSource
			invoke	GlobalFree,[ebx].lpDIBitsSource
		.endif
		.if	[ebx].lpDIBitsRender
			invoke	GlobalFree,[ebx].lpDIBitsRender
		.endif
		.if	[ebx].lpWave1
			invoke	GlobalFree,[ebx].lpWave1
		.endif
		.if	[ebx].lpWave2
			invoke	GlobalFree,[ebx].lpWave2
		.endif
		invoke	KillTimer,[ebx].hWnd,ebx
		invoke	RtlZeroMemory,ebx,sizeof WAVE_OBJECT
;********************************************************************
		assume	ebx:nothing
		popad
		ret

_WaveFree	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ��ʼ������
; ������_lpWaveObject �� ָ�� WAVE_OBJECT��ָ��
; ���أ�eax = 0 �ɹ���= 1 ʧ��
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveInit	proc	_lpWaveObject,_hWnd,_hBmp,_dwSpeed,_dwType
		local	@stBmp:BITMAP,@dwReturn

		pushad
		xor	eax,eax
		mov	@dwReturn,eax
		mov	ebx,_lpWaveObject
		assume	ebx:ptr WAVE_OBJECT
		invoke	RtlZeroMemory,ebx,sizeof WAVE_OBJECT

		.if	_dwType
			or	[ebx].dwFlag,F_WO_ELLIPSE
		.endif
;********************************************************************
; ��ȡλͼ�ߴ�
;********************************************************************
		push	_hWnd
		pop	[ebx].hWnd
		invoke	GetTickCount
		mov	[ebx].dwRandom,eax

		invoke	GetObject,_hBmp,sizeof BITMAP,addr @stBmp
		.if	! eax
			@@:
			inc	@dwReturn
			jmp	_Ret
		.endif
		mov	eax,@stBmp.bmHeight
		mov	[ebx].dwBmpHeight,eax
		cmp	eax,3
		jle	@B
		mov	eax,@stBmp.bmWidth
		mov	[ebx].dwBmpWidth,eax
		cmp	eax,3
		jle	@B

		push	eax
		shl	eax,2
		mov	[ebx].dwWaveByteWidth,eax
		pop	eax
		lea	eax,[eax+eax*2]
		add	eax,3
		and	eax,not 0011b
		mov	[ebx].dwDIByteWidth,eax
;********************************************************************
; ����������Ⱦ��λͼ
;********************************************************************
		invoke	GetDC,_hWnd
		mov	esi,eax
		invoke	CreateCompatibleDC,esi
		mov	[ebx].hDcRender,eax
		invoke	CreateCompatibleBitmap,esi,[ebx].dwBmpWidth,[ebx].dwBmpHeight
		mov	[ebx].hBmpRender,eax
		invoke	SelectObject,[ebx].hDcRender,eax
;********************************************************************
; ���䲨�ܻ�����
;********************************************************************
		mov	eax,[ebx].dwWaveByteWidth
		mul	[ebx].dwBmpHeight
		mov	edi,eax
		invoke	GlobalAlloc,GPTR,edi
		mov	[ebx].lpWave1,eax
		invoke	GlobalAlloc,GPTR,edi
		mov	[ebx].lpWave2,eax
;********************************************************************
; �������ػ�����
;********************************************************************
		mov	eax,[ebx].dwDIByteWidth
		mul	[ebx].dwBmpHeight
		mov	edi,eax
		invoke	GlobalAlloc,GPTR,edi
		mov	[ebx].lpDIBitsSource,eax
		invoke	GlobalAlloc,GPTR,edi
		mov	[ebx].lpDIBitsRender,eax
;********************************************************************
; ��ȡԭʼ��������
;********************************************************************
		mov	[ebx].stBmpInfo.bmiHeader.biSize,sizeof BITMAPINFOHEADER
		push	[ebx].dwBmpWidth
		pop	[ebx].stBmpInfo.bmiHeader.biWidth
		mov	eax,[ebx].dwBmpHeight
		neg	eax
		mov	[ebx].stBmpInfo.bmiHeader.biHeight,eax
		inc	[ebx].stBmpInfo.bmiHeader.biPlanes
		mov	[ebx].stBmpInfo.bmiHeader.biBitCount,24
		mov	[ebx].stBmpInfo.bmiHeader.biCompression,BI_RGB
		mov	[ebx].stBmpInfo.bmiHeader.biSizeImage,0

		invoke	CreateCompatibleDC,esi
		push	eax
		invoke	SelectObject,eax,_hBmp
		invoke	ReleaseDC,_hWnd,esi
		pop	eax
		mov	esi,eax

		invoke	GetDIBits,esi,_hBmp,0,[ebx].dwBmpHeight,[ebx].lpDIBitsSource,\
			addr [ebx].stBmpInfo,DIB_RGB_COLORS
		invoke	GetDIBits,esi,_hBmp,0,[ebx].dwBmpHeight,[ebx].lpDIBitsRender,\
			addr [ebx].stBmpInfo,DIB_RGB_COLORS
		invoke	DeleteDC,esi

		.if	![ebx].lpWave1 || ![ebx].lpWave2 || ![ebx].lpDIBitsSource ||\
			![ebx].lpDIBitsRender || ![ebx].hDcRender
			invoke	_WaveFree,ebx
			inc	@dwReturn
		.endif

		invoke	SetTimer,_hWnd,ebx,_dwSpeed,addr _WaveTimerProc

		or	[ebx].dwFlag,F_WO_ACTIVE or F_WO_NEED_UPDATE
		invoke	_WaveRender,ebx
		invoke	GetDC,[ebx].hWnd
		invoke	_WaveUpdateFrame,ebx,eax,TRUE
		invoke	ReleaseDC,[ebx].hWnd,eax
;********************************************************************
_Ret:
		assume	ebx:nothing
		popad
		mov	eax,@dwReturn
		ret

_WaveInit	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; һЩ��Ч
; ���룺_dwType = 0	�ر���Ч
;	_dwType <> 0	������Ч���������������
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WaveEffect	proc	uses ebx eax _lpWaveObject,\
			_dwType,_dwParam1,_dwParam2,_dwParam3
		local	@dwMaxX,@dwMaxY

		mov	ebx,_lpWaveObject
		assume	ebx:ptr WAVE_OBJECT
;********************************************************************
		mov	eax,_dwType
		.if	eax ==	0
;********************************************************************
; �ر���Ч
;********************************************************************
			and	[ebx].dwFlag,not F_WO_EFFECT
			mov	[ebx].dwEffectType,eax
		.elseif	eax ==	2
;********************************************************************
; �д���Ч
;********************************************************************
			mov	eax,_dwParam1
			mov	[ebx].dwEff2XAdd,eax
			mov	[ebx].dwEff2YAdd,eax

			mov	eax,[ebx].dwBmpWidth
			dec	eax
			dec	eax
			invoke	_WaveRandom,ebx,eax
			inc	eax
			mov	[ebx].dwEff2X,eax

			mov	eax,[ebx].dwBmpHeight
			dec	eax
			dec	eax
			invoke	_WaveRandom,ebx,eax
			inc	eax
			mov	[ebx].dwEff2Y,eax

			jmp	@F
		.else
;********************************************************************
; Ĭ��
;********************************************************************
			@@:
			push	_dwType
			pop	[ebx].dwEffectType
			push	_dwParam1
			pop	[ebx].dwEffectParam1
			push	_dwParam2
			pop	[ebx].dwEffectParam2
			push	_dwParam3
			pop	[ebx].dwEffectParam3
			or	[ebx].dwFlag,F_WO_EFFECT
		.endif
;********************************************************************
		assume	ebx:nothing
		ret

_WaveEffect	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;
;
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
endif
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
