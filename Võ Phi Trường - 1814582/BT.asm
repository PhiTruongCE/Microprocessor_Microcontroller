		list 		p=PIC18f8722 
		#include 	P18F8722.INC
		CONFIG	OSC = HS, WDT = OFF, LVP = OFF
		#include	"Timer.inc"
		#define	LED	LATD
		#define	LED_IO	TRISD
	
		code	0
		goto	start
		org	H'08'
		goto	isr_high
		org	H'18'
		goto	isr_low

		#define	FLAG		flags,0	
		udata_acs
SODEM1S		equ		.50
SODEM0.5S	equ		.25
SODEM2S		equ		.50
dem				res		.1
flags			res		.1
idx				res		.1
PRG		code
start
		rcall	init
		rcall	Timer0_init
main	
		btfss	FLAG
		bra		main
		bcf		INTCON,GIEH
		bcf		FLAG
		bsf		INTCON,GIEH
		btg		PORTD,7
		bra		main
init	
		movlw	H'0F'
		movwf	ADCON1
		clrf	LED_IO
		movlw	SODEM0.5S
		movwf	dem
		clrf	LED
		bcf		FLAG
		clrf	idx
		return	
		global	Timer_process
Timer_process
		decfsz	dem
		return
		incf	idx
		btfss	idx,1
		bra		bit1c
bit1s
		btfsc	idx,0
		bra		to1s	
		bra		to0.5s
bit1c
		btfsc	idx,0
		bra		to2s	
		bra		to0.5s
to2s
		bsf		FLAG
		movlw	SODEM2S
		movwf	dem
		return
to1s
		bsf		FLAG
		movlw	SODEM1S
		movwf	dem
		return		
to0.5s			
		bsf		FLAG
		movlw	SODEM0.5S
		movwf	dem
		
		movlw	0x3
		cpfseq	idx
		return
		clrf	idx
		return
isr_low
		rcall	Timer0_isr
		retfie
isr_high
		retfie
		end