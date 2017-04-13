; ================================================================
; DevSound demo ROM
; ================================================================

; Debug flag
; If set to 1, enable debugging features.

DebugFlag	set	1

; ================================================================
; Project includes
; ================================================================

include	"Variables.asm"
include	"Constants.asm"
include	"Macros.asm"
include	"hardware.inc"

; ================================================================
; Reset vectors (actual ROM starts here)
; ================================================================

SECTION	"Reset $00",HOME[$00]
Reset00:	ret

SECTION	"Reset $08",HOME[$08]
Reset08:	ret

SECTION	"Reset $10",HOME[$10]
Reset10:	ret

SECTION	"Reset $18",HOME[$18]
Reset18:	ret

SECTION	"Reset $20",HOME[$20]
Reset20:	ret

SECTION	"Reset $28",HOME[$28]
Reset28:	ret

SECTION	"Reset $30",HOME[$30]
Reset30:	ret

SECTION	"Reset $38",HOME[$38]
Reset38:	jp	$100

; ================================================================
; Interrupt vectors
; ================================================================

SECTION	"VBlank interrupt",HOME[$40]
IRQ_VBlank:
	reti

SECTION	"LCD STAT interrupt",HOME[$48]
IRQ_STAT:
	reti

SECTION	"Timer interrupt",HOME[$50]
IRQ_Timer:
	reti

SECTION	"Serial interrupt",HOME[$58]
IRQ_Serial:
	reti

SECTION	"Joypad interrupt",Home[$60]
IRQ_Joypad:
	reti
	
; ================================================================
; System routines
; ================================================================

include	"SystemRoutines.asm"

; ================================================================
; ROM header
; ================================================================

SECTION	"ROM header",HOME[$100]

EntryPoint:
	nop
	jp	ProgramStart

NintendoLogo:	; DO NOT MODIFY OR ROM WILL NOT BOOT!!!
	db	$ce,$ed,$66,$66,$cc,$0d,$00,$0b,$03,$73,$00,$83,$00,$0c,$00,$0d
	db	$00,$08,$11,$1f,$88,$89,$00,$0e,$dc,$cc,$6e,$e6,$dd,$dd,$d9,$99
	db	$bb,$bb,$67,$63,$6e,$0e,$ec,$cc,$dd,$dc,$99,$9f,$bb,$b9,$33,$3e

ROMTitle:		db	"DEVSOUND       "	; ROM title
GBCSupport:		db	0					; GBC support (0 = DMG only, $80 = DMG/GBC, $C0 = GBC only)
NewLicenseCode:	dw	0					; new license code (2 bytes)
SGBSupport:		db	0					; SGB support
CartType:		db	$19					; Cart type, see hardware.inc for a list of values
ROMSize:		ds	1					; ROM size (handled by post-linking tool)
RAMSize:		db	0					; RAM size
DestCode:		db	1					; Destination code (0 = Japan, 1 = All others)
OldLicenseCode:	db	$33					; Old license code (if $33, check new license code)
ROMVersion:		db	0					; ROM version
HeaderChecksum:	ds	1					; Header checksum (handled by post-linking tool)
ROMChecksum:	ds	2					; ROM checksum (2 bytes) (handled by post-linking tool)

; ================================================================
; Start of program code
; ================================================================

ProgramStart:
	di						; disable interrupts
	
	call	ClearWRAM

	; clear HRAM
	ld	a,0
	ld	bc,$6060
._loop
	ld	[c],a
	inc	c
	
	dec	b
	jr	nz,._loop

.wait						; wait for VBlank before disabling the LCD
	ldh	a,[rLY]
	cp	$90
	jr	nz,.wait
	xor	a
	ld	[rLCDC],a			; disable LCD

	call	ClearVRAM
	
	CopyTileset1BPP	Font,0,(Font_End-Font)/8
	ld	hl,MainText
	call	LoadMapText
	ld	a,%11100100			; 3 2 1 0
	ldh	[rBGP],a			; set background palette

	ld	a,IEF_VBLANK
	ldh	[rIE],a				; set VBlank interrupt flag
	
	ld	a,%10010001
	ldh	[rLCDC],a			; enable LCD
	
	; Sample implementation for loading a song.
	; Replace the 0 in ld a,0 with the ID of the song you want to load.
	; Note that invalid values will most likely result in a crash!
	ld	a,0
	call	DS_Init
	
	ei
	
MainLoop:
	; draw song id
	ld	a,[CurrentSong]
	ld	hl,$98b1
	call	DrawHex
	
	; playback controls
	call	CheckInput
	ld	a,[sys_btnPress]
	bit	btnUp,a
	jr	nz,.add16
	bit	btnDown,a
	jr	nz,.sub16
	bit	btnLeft,a
	jr	nz,.sub1
	bit	btnRight,a
	jr	nz,.add1
	bit	btnA,a
	jr	nz,.loadSong
	bit	btnB,b
	jr	nz,.stopSong
	jr	.continue

.add1
	ld	a,[CurrentSong]
	inc	a
	ld	[CurrentSong],a
	jr	.continue
.sub1
	ld	a,[CurrentSong]
	dec	a
	ld	[CurrentSong],a
	jr	.continue
.add16
	ld	a,[CurrentSong]
	add	16
	ld	[CurrentSong],a
	jr	.continue
.sub16
	ld	a,[CurrentSong]
	sub	16
	ld	[CurrentSong],a
	jr	.continue
.loadSong
	ld	a,[CurrentSong]
	call	DS_Init
	jr	.continue
.stopSong
	call	DS_Stop
	
.continue
	ld	a,[rLY]
	and	a
	jr	nz,.continue  
	ldh	a,[rBGP]
	ld	b,a
	xor	$ff
	ldh	[rBGP],a
	call	DS_Play
	
	ldh	a,[rLY]
	ld	hl,$9a11
	call	DrawHex	; draw raster time
	
;	call	WaitStat
	ld	a,b
	ldh	[rBGP],a
	
	
	
	halt
	jp	MainLoop
	
MainText:
;		 ####################
	db	"                    "
	db	"    DevSound v1.0   "
	db	"      by DevEd      "
	db	"  deved8@gmail.com  "
	db	"                    "
	db	" Current song:  $?? "
	db	"                    "
	db	" Controls:          "
	db	" A        Load song "
	db	" B        Stop song "
	db	" D-pad  Select song "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	"                    "
	db	" Raster time:   $?? "
	db	"                    "
;		 ####################

Font:	incbin	"Font.bin"
Font_End:

	include	"DevSound.asm"