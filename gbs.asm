GBS = 1

SECTION "GBS Header", ROM0[$390]
	db "GBS"         ;signature
	db 1             ;version
	db NUM_MUSIC - 1 ;number of songs
	db 1             ;first song
	dw $400          ;load address
	dw DS_Init       ;init address
	dw DS_Play       ;play address
	dw wStack        ;stack pointer
	db $e7           ;rTMA
	db $7            ;rTAC
GBS_TitleText:
	db "Bright Fields of Odd Lights"
	ds GBS_TitleText - @ + 32
GBS_AuthorText:
	db "Pigu"
	ds GBS_AuthorText - @ + 32
GBS_CopyrightText:
	db "2017/10/??"
	ds GBS_CopyrightText - @ + 32

SECTION "GBS Main", ROM0[$400]

INCLUDE "DevSound.asm"
