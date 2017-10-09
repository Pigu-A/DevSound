; ================================================================
; DevSound macros
; ================================================================

if !def(incDSMacros)
incDSMacros	set	1

Instrument:		macro
	db	\1
	dw	vol_\2,arp_\3,waveseq_\4,vib_\5
	endm

Sample:			macro
	db	\1
	dw	vol_\2
	dw	arp_\3
	db	$e0,smp_\4
	dw	vib_\5
	endm

Drum:			macro
	db	SetInstrument,\1,fix,\2
	endm

; Enumerate constants

const_def: MACRO
const_value = 0
ENDM

const: MACRO
if "\1" != "skip"
\1 EQU const_value
endc
const_value = const_value + 1
ENDM

dins:			macro
id_\1	equ	const_value
	dw	ins_\1
endm
	
dsmp:			macro
smp_\1	equ	const_value
	db	BANK(smpdata_\1)
	dw	smpdata_\1			; sample data
	dw	\3 / 2				; length
	dw	(\3 / 2) - (\2 / 2)	; loop length (0 = one shot)
	db	\4					; transpose offset from C-4 (8356Hz)
	endm
	
endc
