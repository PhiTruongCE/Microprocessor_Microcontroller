list 		p=PIC18F8722
#include	p18f8722.inc
#include	"Timer.inc"
#include	"LCD.inc"
CONFIG		OSC = HS, WDT = OFF, LVP = OFF
;#define		LED_IO	TRISD
;#define		LED		LATD
#define		KEY_IO	TRISD
#define		ALLCOL	PORTD
#define		ALLROW	LATD

#define		COL1	PORTD,RD0	
#define		COL2	PORTD,RD1
#define		COL3	PORTD,RD2
#define		COL4	PORTD,RD3
#define		ROW1	LATD,RD4
#define		ROW2	LATD,RD5
#define		ROW3	LATD,RD6
#define		ROW4	LATD,RD7
			
code		H'00000'
goto		start
org			0x08
goto		isr_high
org			0x18
goto		isr_low

;vung define data
	udata_acs
TRI_BD		equ		B'00000000'
dem			res		.1
dem1		res		.1
dem2		res		.1
dem3		res		.1
MAXIDX		equ		.4
count		res		.4
row_idx		res		.1
key_code	res		.1
key			res		.1
scan_code	res		.1
direc		res		.1
temp		res		.1
lcdrow		res		.1
lcdcol		res		.1
#define		INC		direc,0	

;vung define ct con
PRG		code
start	rcall	init
		rcall	Timer0_init
		rcall	Lcd_init
;ct chinh
main
	bra		main
;ct khoi dong ban dau
init
	movlw	H'0F'
	movwf	ADCON1
	movlw	H'0F'
	movwf	KEY_IO
	;clrf	LED_IO
	;clrf	LED
	clrf	row_idx
	clrf	key_code
	clrf	key
	clrf	scan_code
	clrf	temp
	clrf	lcdrow
	clrf	lcdcol
	return
;cac ct con

GetScancode
	movf	row_idx,W
	incf	WREG
	dcfsnz	WREG
	bra		getrow1
	dcfsnz	WREG
	bra		getrow2
	dcfsnz	WREG
	BRA		getrow3
getrow4
	movlw	B'01111111'
	bra		getend
getrow3
	movlw	B'10111111'
	bra		getend
getrow2
	movlw	B'11011111'
	bra		getend
getrow1
	movlw	B'11101111'
getend
	movwf	scan_code
	return

Getkey
	movf	ALLCOL,W
	movwf	key
	clrf	key_code
	btfss	key,0
	bra		Getkeyend
	incf	key_code
	btfss	key,1
	bra		Getkeyend
	incf	key_code
	btfss	key,2
	bra		Getkeyend
	incf	key_code
	btfss	key,3
	bra		Getkeyend
	setf	key_code
	return
Getkeyend
	movf	row_idx,W
	rlncf	WREG
	rlncf	WREG
	addwf	key_code
	return

Inc_rowidx
	incf	row_idx
	movlw	MAXIDX
	cpfslt	row_idx
	clrf	row_idx
	return
;ct xu ly dinh ky cua Timer (10ms/lan)
	global	Timer_process
Timer_process
	rcall	GetScancode
	movwf	ALLROW
	rcall	Getkey
	rcall	Inc_rowidx
	incf	key_code,W
	tstfsz	WREG
	rcall	Key_process
	return

Key_process
	;movwf	LED
	movwf	temp
	movff	lcdrow,lcd_row
	movff	lcdcol,lcd_col
	rcall	Lcd_gotoxy
	movlw	.64
	addwf	temp,W
	movwf	lcd_wr
	rcall	Lcd_putc

	incf	lcdcol
	movlw	.16
	cpfseq	lcdcol
	bra		exit	
	bra		rowcheck
rowcheck
	clrf	lcdcol
	movlw	.1
	cpfseq	lcdrow
	bra		incrow
	bra		decrow
incrow
	incf	lcdrow
	return
decrow
	clrf	lcdrow
	return
exit	
	return



isr_high
	retfie
;ct ngat uu tien thap
isr_low
	rcall Timer0_isr
	retfie


end