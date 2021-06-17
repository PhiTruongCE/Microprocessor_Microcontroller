		list		p=PIC18F8722
		#include	p18f8722.inc
		#include	"Timer.inc"
		#include	"LCD.inc"
		CONFIG		OSC = HS, WDT = OFF, LVP = OFF
		#define  	LED  		LATD
  		#define  	LED_IO 		TRISD
		#define		KEY_IO		TRISB
		#define		ALLCOL		PORTB
		#define		ALLROW		LATB
		#define		COL1		PORTB,RB0
		#define		COL2		PORTB,RB1
		#define		COL3		PORTB,RB2
		#define		COL4		PORTB,RB3
		#define		ROW1		LATB,RB4
		#define		ROW2		LATB,RB5
		#define		ROW3		LATB,RB6
		#define		ROW4		LATB,RB7
		code 		H'00000'
		goto		start
		org			0x08
		goto		isr_high
		org			0x18
		goto		isr_low
;vung dinh nghia du lieu
		udata_acs
;SODEM10MS	equ			.12500
row_idx		res			.1
scan_code	res			.1
key			res			.1
key_code	res			.1
MAXIDX		res			.3
;vung viet code
PRG		code
start	rcall		init
		rcall		Timer0_init
		rcall		Lcd_init
main	
		bra			main
init	
		movlw		H'0F'
		movwf		ADCON1
		movlw		H'0F'
		movwf		KEY_IO
		clrf		LED_IO
		clrf		LED
		clrf		row_idx
		clrf		scan_code
		clrf		key
		clrf		key_code
		return
GetScancode
		movf		row_idx,W
		incf		WREG
		dcfsnz		WREG
		bra			getrow1
		dcfsnz		WREG
		bra			getrow2
		dcfsnz		WREG
		bra			getrow3
getrow4	
		movlw		B'01111111'
		bra			getend
getrow3
		movlw		B'10111111'
		bra			getend
getrow2
		movlw		B'11011111'
		bra			getend
getrow1
		movlw		B'11101111'
getend	
		movwf		scan_code
		return
Getkey
		movf		ALLCOL,W
		movwf		key
		clrf		key_code
		btfss		key,0
		bra			Getkeyend
		incf		key_code
		btfss		key,1
		bra			Getkeyend
		incf		key_code
		btfss		key,2
		bra			Getkeyend
		incf		key_code
		btfss		key,3
		bra			Getkeyend
		setf		key_code
		return
Getkeyend
		movf		row_idx,W
		rlncf		WREG
		rlncf		WREG
		addwf		key_code
		return
Inc_rowidx
		incf		row_idx
		movlw		MAXIDX
		cpfslt		row_idx
		clrf		row_idx
		return
		global		Timer_process
Timer_process
		rcall		GetScancode
		movwf		ALLROW
;kiem tra cot
		rcall 		Getkey
		rcall		Inc_rowidx
		incf		key_code,W
		tstfsz		WREG
		rcall		Key_process	
		return
Key_process
		movwf		LED
		return		
;ham ngat
isr_low	
		rcall		Timer0_isr
		retfie
isr_high
		retfie
end