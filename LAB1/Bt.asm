		list 		p=PIC18F8722
		#include 	p18f8722.inc
		CONFIG 		OSC = HS , WDT = OFF , LVP = OFF
		#define 	LED		LATD
		#define 	LED_IO	TRISD
		#define 	NUT 	PORTA,RA5
		#define 	NUT_IO 	TRISA,RA5
		code 		H'00000'
		goto 		start
;vung dinh nghia du lieu (neu co)
		udata_acs
TRI_BD	equ			H'00'   ;XX phai la so cu the
dem		res			.1
dem1a	res			.1
dem1b	res			.1
dem_ngoai	equ		.5

;vung dinh nghia cac chuong trinh con
PRG		code
start	rcall		init	;khoi dong cac thanh ghi va bien trong RAM

;chuong trinh chinh
main	btfsc		NUT		
		bra			main
		rcall		xuat_led	
swoff	btfss		NUT
		bra			swoff		
		bra			main

;chuong trinh khoi dong ban dau
init	movlw		H'0F'
		movwf		ADCON1
		bsf			NUT_IO
		clrf		LED_IO
		movlw		TRI_BD
		movwf		LED
		return

;cac chuong trinh con khac (neu co)
xuat_led	comf	LED
			rcall	delay500ms
			;comf	LED
			return

delay		movlw	.249
			movwf	dem
			nop
lap1		nop
			decfsz	dem
			bra		lap1
			return
delay500ms	movf	dem_ngoai,W
			movwf	dem1a
lap2		movlw	.250
			movwf	dem1b
lap3		call	delay
			decfsz	dem1b
			bra		lap3
			decfsz	dem1a
			bra		lap2
			return
			end			;chi thi ket thuc module hop ngu