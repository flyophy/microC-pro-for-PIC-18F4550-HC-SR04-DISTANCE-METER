
_InitTimer1:

;SENSOR -1-.c,24 :: 		void InitTimer1()
;SENSOR -1-.c,26 :: 		T1CON = 0;
	CLRF        T1CON+0 
;SENSOR -1-.c,27 :: 		TMR1H = 0;
	CLRF        TMR1H+0 
;SENSOR -1-.c,28 :: 		TMR1L = 0;
	CLRF        TMR1L+0 
;SENSOR -1-.c,29 :: 		}
L_end_InitTimer1:
	RETURN      0
; end of _InitTimer1

_MesafeOlc:

;SENSOR -1-.c,31 :: 		int MesafeOlc()
;SENSOR -1-.c,33 :: 		long toplam=0,temp=0;
	CLRF        MesafeOlc_toplam_L0+0 
	CLRF        MesafeOlc_toplam_L0+1 
	CLRF        MesafeOlc_toplam_L0+2 
	CLRF        MesafeOlc_toplam_L0+3 
;SENSOR -1-.c,35 :: 		for(i=0;i<64;i++) // 64 adet ölçüm yapılıp ortalaması alınacak
	CLRF        MesafeOlc_i_L0+0 
L_MesafeOlc0:
	MOVLW       64
	SUBWF       MesafeOlc_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_MesafeOlc1
;SENSOR -1-.c,37 :: 		TRIGGER=1; // tetikleme palsi
	BSF         PORTB+0, 7 
;SENSOR -1-.c,38 :: 		Delay_us(10);// (10us)
	MOVLW       39
	MOVWF       R13, 0
L_MesafeOlc3:
	DECFSZ      R13, 1, 1
	BRA         L_MesafeOlc3
	NOP
	NOP
;SENSOR -1-.c,39 :: 		TRIGGER=0; // gönder
	BCF         PORTB+0, 7 
;SENSOR -1-.c,40 :: 		while(!ECHO);// ECHO "H" olana kadar bekle
L_MesafeOlc4:
	BTFSC       PORTB+0, 0 
	GOTO        L_MesafeOlc5
	GOTO        L_MesafeOlc4
L_MesafeOlc5:
;SENSOR -1-.c,41 :: 		T1CON.TMR1ON=1;// Timer1'i başlat
	BSF         T1CON+0, 0 
;SENSOR -1-.c,42 :: 		while(ECHO); // ECHO "L" olana kadar bekle
L_MesafeOlc6:
	BTFSS       PORTB+0, 0 
	GOTO        L_MesafeOlc7
	GOTO        L_MesafeOlc6
L_MesafeOlc7:
;SENSOR -1-.c,43 :: 		T1CON.TMR1ON=0; // Timer1'i durdur.
	BCF         T1CON+0, 0 
;SENSOR -1-.c,44 :: 		sayac_TMR1=(TMR1H<<8)+TMR1L;// Timer1 değerini int değişkene aktar
	MOVF        TMR1H+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        TMR1L+0, 0 
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVF        R0, 0 
	MOVWF       _sayac_TMR1+0 
	MOVF        R1, 0 
	MOVWF       _sayac_TMR1+1 
;SENSOR -1-.c,45 :: 		toplam+=((long)sayac_TMR1*34)/200; // mesafe hesapla ve topplam değişkeninde topla
	MOVLW       0
	MOVWF       R2 
	MOVWF       R3 
	MOVLW       34
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       200
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_S+0, 0
	MOVF        R0, 0 
	ADDWF       MesafeOlc_toplam_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      MesafeOlc_toplam_L0+1, 1 
	MOVF        R2, 0 
	ADDWFC      MesafeOlc_toplam_L0+2, 1 
	MOVF        R3, 0 
	ADDWFC      MesafeOlc_toplam_L0+3, 1 
;SENSOR -1-.c,46 :: 		TMR1H=0; TMR1L=0; // Timer1'i sıfırla
	CLRF        TMR1H+0 
	CLRF        TMR1L+0 
;SENSOR -1-.c,47 :: 		sayac_TMR1=0; // Timer'i aktardığımız us sayacını sıfırla
	CLRF        _sayac_TMR1+0 
	CLRF        _sayac_TMR1+1 
;SENSOR -1-.c,48 :: 		Delay_ms(5); // 5 ms bekle
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_MesafeOlc8:
	DECFSZ      R13, 1, 1
	BRA         L_MesafeOlc8
	DECFSZ      R12, 1, 1
	BRA         L_MesafeOlc8
;SENSOR -1-.c,35 :: 		for(i=0;i<64;i++) // 64 adet ölçüm yapılıp ortalaması alınacak
	INCF        MesafeOlc_i_L0+0, 1 
;SENSOR -1-.c,49 :: 		}
	GOTO        L_MesafeOlc0
L_MesafeOlc1:
;SENSOR -1-.c,50 :: 		return (toplam>>6); // ortalamayı fonksiyon dışına taşı
	MOVLW       6
	MOVWF       R4 
	MOVF        MesafeOlc_toplam_L0+0, 0 
	MOVWF       R0 
	MOVF        MesafeOlc_toplam_L0+1, 0 
	MOVWF       R1 
	MOVF        MesafeOlc_toplam_L0+2, 0 
	MOVWF       R2 
	MOVF        MesafeOlc_toplam_L0+3, 0 
	MOVWF       R3 
	MOVF        R4, 0 
L__MesafeOlc15:
	BZ          L__MesafeOlc16
	RRCF        R3, 1 
	RRCF        R2, 1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R3, 7 
	BTFSC       R3, 6 
	BSF         R3, 7 
	ADDLW       255
	GOTO        L__MesafeOlc15
L__MesafeOlc16:
;SENSOR -1-.c,51 :: 		}
L_end_MesafeOlc:
	RETURN      0
; end of _MesafeOlc

_Kurulum:

;SENSOR -1-.c,53 :: 		void Kurulum()
;SENSOR -1-.c,55 :: 		CMCON=7;
	MOVLW       7
	MOVWF       CMCON+0 
;SENSOR -1-.c,56 :: 		TRISD=0;
	CLRF        TRISD+0 
;SENSOR -1-.c,57 :: 		TRISB=1;
	MOVLW       1
	MOVWF       TRISB+0 
;SENSOR -1-.c,58 :: 		PORTB=0;
	CLRF        PORTB+0 
;SENSOR -1-.c,59 :: 		InitTimer1();
	CALL        _InitTimer1+0, 0
;SENSOR -1-.c,60 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;SENSOR -1-.c,61 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;SENSOR -1-.c,62 :: 		}
L_end_Kurulum:
	RETURN      0
; end of _Kurulum

_main:

;SENSOR -1-.c,64 :: 		void main()
;SENSOR -1-.c,66 :: 		Kurulum();
	CALL        _Kurulum+0, 0
;SENSOR -1-.c,67 :: 		Lcd_Out(1,1,"xxxxxxxxxxxxxxxx");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_SENSOR_32_451_45+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_SENSOR_32_451_45+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;SENSOR -1-.c,68 :: 		Lcd_Out(2,1,"    xxxxxxxxx");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_SENSOR_32_451_45+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_SENSOR_32_451_45+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;SENSOR -1-.c,69 :: 		Delay_ms(7000);
	MOVLW       2
	MOVWF       R10, 0
	MOVLW       171
	MOVWF       R11, 0
	MOVLW       34
	MOVWF       R12, 0
	MOVLW       201
	MOVWF       R13, 0
L_main9:
	DECFSZ      R13, 1, 1
	BRA         L_main9
	DECFSZ      R12, 1, 1
	BRA         L_main9
	DECFSZ      R11, 1, 1
	BRA         L_main9
	DECFSZ      R10, 1, 1
	BRA         L_main9
;SENSOR -1-.c,70 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;SENSOR -1-.c,71 :: 		Lcd_Out(1,4,"#YAPIMCI#");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_SENSOR_32_451_45+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_SENSOR_32_451_45+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;SENSOR -1-.c,72 :: 		Lcd_Out(2,2," EMRE METIN.!");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_SENSOR_32_451_45+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_SENSOR_32_451_45+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;SENSOR -1-.c,73 :: 		delay_ms(10000);
	MOVLW       3
	MOVWF       R10, 0
	MOVLW       97
	MOVWF       R11, 0
	MOVLW       195
	MOVWF       R12, 0
	MOVLW       142
	MOVWF       R13, 0
L_main10:
	DECFSZ      R13, 1, 1
	BRA         L_main10
	DECFSZ      R12, 1, 1
	BRA         L_main10
	DECFSZ      R11, 1, 1
	BRA         L_main10
	DECFSZ      R10, 1, 1
	BRA         L_main10
	NOP
;SENSOR -1-.c,74 :: 		Lcd_Cmd(_Lcd_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;SENSOR -1-.c,75 :: 		Lcd_Out(1,2,"OLCULEN MESAFE");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_SENSOR_32_451_45+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_SENSOR_32_451_45+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;SENSOR -1-.c,76 :: 		while(1)
L_main11:
;SENSOR -1-.c,78 :: 		mesafe_mm=MesafeOlc();
	CALL        _MesafeOlc+0, 0
	MOVF        R0, 0 
	MOVWF       _mesafe_mm+0 
	MOVF        R1, 0 
	MOVWF       _mesafe_mm+1 
;SENSOR -1-.c,79 :: 		WordToStr(mesafe_mm,txt);
	MOVF        R0, 0 
	MOVWF       FARG_WordToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_WordToStr_input+1 
	MOVLW       _txt+0
	MOVWF       FARG_WordToStr_output+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_WordToStr_output+1 
	CALL        _WordToStr+0, 0
;SENSOR -1-.c,80 :: 		Lcd_Out(2,1,txt);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _txt+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;SENSOR -1-.c,81 :: 		Lcd_Out_CP(" mm");
	MOVLW       ?lstr6_SENSOR_32_451_45+0
	MOVWF       FARG_Lcd_Out_CP_text+0 
	MOVLW       hi_addr(?lstr6_SENSOR_32_451_45+0)
	MOVWF       FARG_Lcd_Out_CP_text+1 
	CALL        _Lcd_Out_CP+0, 0
;SENSOR -1-.c,82 :: 		}
	GOTO        L_main11
;SENSOR -1-.c,83 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
