; ================================================================
; DevSound song data
; ================================================================
	
; =================================================================
; Song speed table
; =================================================================

SongSpeedTable:
	db	6,6,6			; sample test
	
	
SongPointerTable:
	dw	PT_SampleTest
	
; =================================================================
; Volume sequences
; =================================================================

; Wave volume values
w0			equ	%00000000
w1			equ	%01100000
w2			equ	%01000000
w3			equ	%00100000

; For pulse instruments, volume control is software-based by default.
; However, hardware volume envelopes may still be used by adding the
; envelope length * $10.
; Example: $3F = initial volume $F, env. length $3
; Repeat that value for the desired length.
; Note that using initial volume $F + envelope length $F will be
; interpreted as a "table end" command, use initial volume $F +
; envelope length $0 instead.
; Same applies to initial volume $F + envelope length $8 which
; is interpreted as a "loop" command, use initial volume $F +
; envelope length $0 instead.

vol_majchord: 		db	15,$ff

; =================================================================
; Arpeggio sequences
; =================================================================

arp_Dummy:	db	0,$ff

; =================================================================
; Vibrato sequences
; Must be terminated with a loop command!
; =================================================================

vib_Dummy:	db	0,0,$80,1

; =================================================================
; Pulse / Wave / Noise sequences
; =================================================================

; Noise values are the same as Deflemask, but with one exception:
; To convert 7-step noise values (noise mode 1 in deflemask) to a
; format usable by DevSound, take the corresponding value in the
; arpeggio macro and add s7.
; Example: db s7+32 = noise value 32 with step lengh 7
; Note that each noiseseq must be terminated with a loop command
; ($80) otherwise the noise value will reset!

s7	equ	$2d

WaveTable:
	dw	wave_Bass

wave_Bass:		db	$00,$01,$11,$11,$22,$11,$00,$02,$57,$76,$7a,$cc,$ee,$fc,$b1,$23

SampleTable:
	const_def
	dsmp majchord, 3938, 6144, 0

; $fe, nn = sample nn
; use $c0 to use the wave buffer
waveseq_Dummy:			db	0,$ff
waveseq_majchord:		db	$fe, 0

; =================================================================
; Instruments
; =================================================================

InstrumentTable:
	const_def
	dins	majchord

; Instrument format: [no reset flag],[wave mode (ch3 only)],[voltable id],[arptable id],[pulsetable/wavetable id],[vibtable id]
; note that wave mode must be 0 for non-wave instruments
; !!! REMEMBER TO ADD INSTRUMENTS TO THE INSTRUMENT POINTER TABLE !!!

ins_majchord:			Sample	0,majchord,Dummy,majchord,Dummy

; =================================================================

PT_SampleTest:	dw	DummyChannel,DummyChannel,SampleTest,DummyChannel

SampleTest
	db	SetInstrument,id_majchord
	db	C_5,16,rest,8
	db	C_5,8,D_5,8,E_5,8,F_5,8,G_5,8,A_5,8,B_5,8,C_6,32
	db	rest,8
	db	EndChannel

; =================================================================
; Sample Data
; =================================================================

smpdata_majchord	incbin	"maj.raw"
