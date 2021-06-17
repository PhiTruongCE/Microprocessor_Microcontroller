			list		p=PIC18f8722
			#include	P18F8722.INC
			extern		Timer_process
SODEM10MS	equ			.12500
PRG			code
;Cau hinh Timer0
			global		Timer0_init
Timer0_init
			bsf			RCON,IPEN
			bcf			INTCON2,TMR0IP
			bsf			INTCON,TMR0IE
			bsf			INTCON,GIEH
			bsf			INTCON,GIEL
			clrf		T0CON
			rcall		Timer0_reset
			return
Timer0_reset
			bcf			INTCON,TMR0IF
			bcf			T0CON,TMR0ON
			movlw		high (-SODEM10MS)
			movwf		TMR0H
			movlw		low (-SODEM10MS)
			movwf		TMR0L
			bsf			T0CON,TMR0ON
			return
			global		Timer0_isr
Timer0_isr
			rcall		Timer0_reset
			rcall		Timer_process
			return
			end