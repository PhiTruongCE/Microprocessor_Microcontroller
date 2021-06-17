			list		p=PIC18f8722
			#include	P18F8722.INC
			#include	"LCD.inc"
			#define		AN0_IO		TRISA,RA0
			#define			AN5_IO TRISF,RF0
			#define			AN1_IO TRISF,RA1
			extern		Adc_process
global		ad_res
			udata_acs
AD_CFG05 equ        H'15'
AD_CFG01 	equ        H'5'
AD_CFG0		equ			H'01'
AD_CFG1		equ			H'0E'			
AD_CFG2		equ			H'81'
ad_res		res			.2
PRG			code
			global		Adc_init
Adc_init
;b			movlw		AD_CFG0
;			movwf		ADCON0
;			movlw		AD_CFG1
;			movwf		ADCON1
;			movlw		AD_CFG2
;			movwf		ADCON2
;			bsf			AN0_IO 		b
;c        movlw       AD_CFG01
;        movwf       ADCON0
;        movlw       AD_CFG1
;        movwf       ADCON1
;        movlw       AD_CFG2
;        movwf       ADCON2
;        bsf         AN1_IO       c
       		movlw       AD_CFG05
       	 	movwf       ADCON0
        	movlw       AD_CFG1
       	 	movwf       ADCON1
        	movlw       AD_CFG2
        	movwf       ADCON2
        	bsf         AN5_IO

			bsf			RCON,IPEN
			bsf			IPR1,ADIP
			bcf			PIR1,ADIF;xoa co ngat
			bsf			PIE1,ADIE
			bsf			INTCON,GIEH
			bsf			INTCON,GIEL
			bsf			ADCON0,GO
			return
			global		Adc_go
Adc_go
			bsf			ADCON0,GO
Adc_wait
			btfsc		ADCON0,DONE	
			bra			Adc_wait
			movf		ADRESH,W
			movwf		ad_res+1
			movf		ADRESL,W
			movwf		ad_res
			rcall		Adc_process
			return
			global		Adc_isr
Adc_isr
			btfss		PIR1,ADIF
			bra			Adc_isr
			bcf			PIR1,ADIF	;xoa co ngat
			movf		ADRESH,W
			movwf		ad_res+1
			movf		ADRESL,W
			movwf		ad_res
			rcall		Adc_process
			bsf			ADCON0,GO
			return			
end	