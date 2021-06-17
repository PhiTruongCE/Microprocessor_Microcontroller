				list 			p=PIC18f8722 
				#include 		P18F8722.INC
				extern			Adc_process
				#define			AN0_IO TRISA,RA0
				#define			AN5_IO TRISF,RF0
				#define			AN1_IO TRISF,RA1
				extern			ad_res
				
				udata_acs
AD_CFG0 equ         H'01'
AD_CFG05 equ        H'15'
AD_CFG01 equ        H'5'
AD_CFG1 equ         H'0E'
AD_CFG2 equ         H'81'
				
PRG		code
;Chuong trinh cho yeu cau 1
        global 		Adc_init1
Adc_init1
        movlw       AD_CFG0
        movwf       ADCON0
        movlw       AD_CFG1
        movwf       ADCON1
        movlw       AD_CFG2
        movwf       ADCON2
        bsf         AN0_IO
        return
        
       	global		Adc_go
Adc_go  bsf         ADCON0,GO
Adc_wait
        btfsc       ADCON0,DONE
        bra         Adc_wait
        movf        ADRESH,W 
        movwf       ad_res+1
        movf        ADRESL,W 
        movwf       ad_res
        rcall       Adc_process
        return
        
;CHuong trinh cho yeu cau 2
        global  Adc_init2
Adc_init2
        movlw       AD_CFG0
        movwf       ADCON0
        movlw       AD_CFG1
        movwf       ADCON1
        movlw       AD_CFG2
        movwf       ADCON2
        bsf         AN0_IO
        
        bsf			RCON,IPEN
        bsf			IPR1,ADIP
        bcf			PIR1,ADIF
        bsf			PIE1,ADIE
        bsf			INTCON,GIEH
        bsf			INTCON,GIEL
		bsf			ADCON0,GO	
        return

;CHuong trinh cho yeu cau 4a
        global  Adc_init4a
Adc_init4a
        movlw       AD_CFG05
        movwf       ADCON0
        movlw       AD_CFG1
        movwf       ADCON1
        movlw       AD_CFG2
        movwf       ADCON2
        bsf         AN5_IO
        
        bsf			RCON,IPEN
        bsf			IPR1,ADIP
        bcf			PIR1,ADIF
        bsf			PIE1,ADIE
        bsf			INTCON,GIEH
        bsf			INTCON,GIEL
		bsf			ADCON0,GO	
        return

;CHuong trinh cho yeu cau 4c
        global  Adc_init4c
Adc_init4c
        movlw       AD_CFG01
        movwf       ADCON0
        movlw       AD_CFG1
        movwf       ADCON1
        movlw       AD_CFG2
        movwf       ADCON2
        bsf         AN1_IO
        
        bsf			RCON,IPEN
        bsf			IPR1,ADIP
        bcf			PIR1,ADIF
        bsf			PIE1,ADIE
        bsf			INTCON,GIEH
        bsf			INTCON,GIEL
		bsf			ADCON0,GO	
        return		
		        
        global	Adc_isr
Adc_isr
        btfsc       ADCON0,DONE
        bra         Adc_isr
        movf        ADRESH,W 
        movwf       ad_res+1
        movf        ADRESL,W 
        movwf       ad_res
        rcall       Adc_process
		bcf			PIR1,ADIF
 		return
		end 




		