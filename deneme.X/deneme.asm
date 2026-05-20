

    LIST P=16F628A

    #INCLUDE <P16F628A.INC>

    __CONFIG _BOREN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _MCLRE_OFF & _INTOSC_OSC_NOCLKOUT



    ORG 0x000

    GOTO KURULUM



; --- KESME VEKTORU (INTERRUPT SERVISI) ---

    ORG 0x004

    GOTO ALARM_KESMESI



; --- BASLANGIC AYARLARI ---

KURULUM

    MOVLW   0x07          ; PORTA'yi dijital moda al

    MOVWF   CMCON



    BSF     STATUS, RP0   ; Bank 1'e gec

    MOVLW   B'00000000'   ; PORTA hepsi cikis (Siren ve Biber Gazi)

    MOVWF   TRISA

    MOVLW   B'11111111'   ; PORTB hepsi giris (RB4-RB7 Sensorleri icin)

    MOVWF   TRISB

    

    ; Kesme Ayarlari

    MOVLW   B'10001000'   ; GIE=1 (Genel Kesme Acik), RBIE=1 (RB4-RB7 Degisiklik Kesmesi Acik)

    MOVWF   INTCON

    BCF     STATUS, RP0   ; Bank 0'a don



    ; Baslangicta her seyi kapat (Siren ve Gaz pasif)

    CLRF    PORTA

    GOTO    ANA_DONGU



; --- ANA DONGU (SENSÖR TET?KLENMED??? SÜRECE BURADA DÖNER) ---

ANA_DONGU

    ; Soruda "sensör tetiklenmedi?i sürece ç?k??lar pasif kalacakt?r" denmi?.

    ; E?er kesmeden ç?k?p buraya geldiysek ve sensörler tekrar 0 olduysa ç?k??lar? temizle.

    MOVF    PORTB, W      ; PORTB'yi oku (Mevcut durumu ogrenmek ve kesme bayragini sifirlayabilmek icin sart)

    ANDLW   B'11110000'   ; Sadece RB4-RB7 pinlerine bak

    BTFSC   STATUS, Z     ; Eger hepsi 0 ise (Hirsiz yoksa Z=1 olur)

    CLRF    PORTA         ; Siren ve Gaz? kapat (Pasif yap)

    GOTO    ANA_DONGU

    ; --- KESME ALT PROGRAMI (BUZZER VE LED AKT?F) ---
ALARM_KESMESI
    ; H?rs?z girdi!
    ; RA0 (Siren + Buzzer) ve RA1 (Biber Gaz?) pinlerini aktif ediyoruz.
    MOVLW   B'00000011'   
    MOVWF   PORTA         ; Hem buzzer ötecek, hem LED yanacak, hem gaz aç?lacak!

    ; Kesme bayra??n? temizle
    MOVF    PORTB, W      
    BCF     INTCON, RBIF  
    RETFIE                
    END