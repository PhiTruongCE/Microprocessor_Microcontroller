		list		p=PIC18F8722
		#include	p18f8722.inc
		CONFIG		OSC = HS, WDT = OFF, LVP = OFF
		#define 	ROW			LATB
		#define		ROW_IO		TRISB
		#define		GCOL		LATC
		#define		GCOL_IO		TRISC
		#define		RCOL		LATD
		#define		RCOL_IO		TRISD
		#define		NUTNHAN		PORTA,RA5
		#define		NUT_IO		TRISA,RA5
		code 		H'00000'
		goto		start
;Vung dinh nghia du lieu
		udata_acs
G_DATA	res			b'00000001'
R_DATA	res			b'00000001'
;Vung viet code
PRG		code
start	
		rcall 		init
main
		clrf		ROW_IO
		
main1
		btfsc		NUTNHAN	
		bra			main1
		rlncf		ROW
nhaphim
		btfss		BUTNHAN
		bra			nhaphim
		bra			main1
end