
; =============================================
; PIC16F628A - Üretim Hatt? Otomasyonu 
; RMW (Oku-De?i?tir-Yaz) Korumal? Versiyon
; =============================================

    LIST P=16F628A
    #INCLUDE <P16F628A.INC>
    __CONFIG _CP_OFF & _WDT_OFF & _PWRTE_ON & _MCLRE_ON & _INTRC_OSC_NOCLKOUT & _LVP_OFF & _BOREN_OFF

    CBLOCK 0x20
        KAPASITE
        SAYAC_B
        SAYAC_E
        MOTORLAR    
        GEC1
        GEC2
    ENDC

    ORG 0x00
    GOTO BASLANGIC

BASLANGIC
    MOVLW   0x07
    MOVWF   CMCON
    BANKSEL TRISA
    MOVLW   b'11111111' 
    MOVWF   TRISA
    CLRF    TRISB      
    BANKSEL PORTA
    CLRF    PORTA
    CLRF    PORTB
    CLRF    KAPASITE
    CLRF    SAYAC_B
    CLRF    SAYAC_E
    CLRF    MOTORLAR

AYAR_DONGUSU
    BTFSS   PORTA, 0   
    GOTO    BASLAT_BAK
    
    INCF    KAPASITE, F 
    CALL    BEKLE
BEKLE_RA0
    BTFSC   PORTA, 0    
    GOTO    BEKLE_RA0
    GOTO    AYAR_DONGUSU

BASLAT_BAK
    BTFSS   PORTA, 1   
    GOTO    AYAR_DONGUSU
    
    MOVF    KAPASITE, F
    BTFSC   STATUS, Z   
    GOTO    AYAR_DONGUSU

  
    
    MOVLW   b'00000011' 
    MOVWF   MOTORLAR    
    MOVWF   PORTB      

URETIM_DONGUSU
    ; --------------------------------------
    ; --- BAYAN SENSÖR KONTROLÜ (RA2) ---
    ; --------------------------------------
    BTFSS   MOTORLAR, 0 
    GOTO    ERKEK_BAK   
    
    BTFSS   PORTA, 2    
    GOTO    ERKEK_BAK
    
    INCF    SAYAC_B, F
    CALL    BEKLE
BEKLE_RA2
    BTFSC   PORTA, 2
    GOTO    BEKLE_RA2
    
  
    MOVF    KAPASITE, W
    SUBWF   SAYAC_B, W
    BTFSS   STATUS, Z
    GOTO    ERKEK_BAK  
    
    
    BCF     MOTORLAR, 0 
    MOVF    MOTORLAR, W
    MOVWF   PORTB       

ERKEK_BAK
    ; --------------------------------------
    ; --- ERKEK SENSÖR KONTROLÜ (RA3) ---
    ; --------------------------------------
    BTFSS   MOTORLAR, 1 
    GOTO    URETIM_DEVAM
    
    BTFSS   PORTA, 3  
    GOTO    URETIM_DEVAM
    
    INCF    SAYAC_E, F
    CALL    BEKLE
BEKLE_RA3
    BTFSC   PORTA, 3
    GOTO    BEKLE_RA3
    
    
    MOVF    KAPASITE, W
    SUBWF   SAYAC_E, W
    BTFSS   STATUS, Z
    GOTO    URETIM_DEVAM
    
  
    BCF     MOTORLAR, 1 
    MOVF    MOTORLAR, W
    MOVWF   PORTB      

URETIM_DEVAM
    GOTO    URETIM_DONGUSU

BEKLE
    MOVLW   .255
    MOVWF   GEC1
L1  MOVLW   .100
    MOVWF   GEC2
L2  DECFSZ  GEC2, F
    GOTO    L2
    DECFSZ  GEC1, F
    GOTO    L1
    RETURN

    END

