			list		p=PIC18f8722
			#include	P18F8722.INC
			#include	"Timer.inc"
			#include	"LCD.inc"
			CONFIG		OSC = HS, WDT = OFF, LVP = OFF
			#define  	LED  		LATD
  			#define  	LED_IO 		TRISD
   			#define  	NUTRB0  	PORTB,RB0
			#define		FLAG_1S		flags,0
			code 		H'00000'
			goto 		start
			org			H'08'
			goto		isr_high
			org			H'18'
			goto		isr_low
;Vung du lieu
			udata_acs
SODEM1S		equ			.100
dem			res			.1
flags		res			.1
PRG			code
start
			rcall		init
			rcall		Lcd_init
main		
			movlw		.1
			movwf		lcd_row
			movlw		.7
			movwf		lcd_col
			rcall		Lcd_gotoxy
			movlw		'T'
			movwf		lcd_wr
			rcall		Lcd_putc
main1		bra			main1
init
			movlw		H'0F'
			movwf		ADCON1
			clrf		LED_IO
			movlw		SODEM1S
			movwf		dem
			clrf		LED
			bcf			FLAG_1S
			return
			global		Timer_process	
Timer_process
			decfsz		dem
			return
			bsf			FLAG_1S
			movlw		SODEM1S
			movwf		dem
			return
isr_low
			rcall		Timer0_isr
			retfie
isr_high
			retfie
			end