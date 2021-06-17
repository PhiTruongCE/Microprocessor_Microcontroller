			list		p=PIC18f8722
			#include	P18F8722.INC
			CONFIG		OSC=HS, WDT=OFF, LVP=OFF
			#define		PWMOUT_IO	TRISC,RC2
			code 		H'00000'
			udata_acs
TRI_BD  	equ  		H'00'
;PWM_CFG		equ			H'0F'
PWM_CFG		equ			H'0C'
T2_CFG		equ			H'05'
PR2_VAL		equ			.224
;PR2_VAL		equ			.249
;DUTY8_VAL	equ			.120
DUTY8_VAL	equ			.75
PRG			code
			goto 		start
start	
			rcall		Pwm_init
main	
			bra			main
Pwm_init
			bcf				PWMOUT_IO
			movlw			PWM_CFG
			movwf			CCP1CON
			movlw			T2_CFG
			movwf			T2CON
			movlw			PR2_VAL
			movwf			PR2
			movlw			DUTY8_VAL
			movwf			CCPR1L
			bcf				CCP1CON,CCP1X
			bcf				CCP1CON,CCP1Y
;			bsf				CCP1CON,CCP1Y  			
			return
end