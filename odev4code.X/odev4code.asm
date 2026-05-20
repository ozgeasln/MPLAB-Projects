LIST P=16F628A
    #include "p16f628a.inc"
    
    __CONFIG _FOSC_INTOSCIO & _WDTE_OFF & _PWRTE_ON & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF


    CBLOCK 0x20
        w_temp           
        status_temp       
    ENDC

    ORG 0x000             
    GOTO MAIN


    ORG 0x004
   
    MOVWF w_temp
    SWAPF STATUS, W
    MOVWF status_temp


    MOVF PORTB, W         
    ANDLW 0xF0           
    BTFSS STATUS, Z      
    GOTO ALARM_TETIKLE    
    
   
    CLRF PORTA            
    GOTO ISR_EXIT

ALARM_TETIKLE:
    
    MOVLW b'00000111'      
    MOVWF PORTA

ISR_EXIT:
   
    BCF INTCON, RBIF      
    SWAPF status_temp, W  
    MOVWF STATUS
    SWAPF w_temp, F       
    SWAPF w_temp, W
    RETFIE               


MAIN:

    MOVLW 0x07
    MOVWF CMCON

   
    BSF STATUS, RP0     
    MOVLW b'11110000'    
    MOVWF TRISB
    CLRF TRISA          
    BCF STATUS, RP0    

 
    CLRF PORTA          
    MOVF PORTB, W         
    BCF INTCON, RBIF     

   
    BSF INTCON, RBIE      
    BSF INTCON, GIE       


MAIN_LOOP:
    SLEEP                
    NOP                   
    GOTO MAIN_LOOP        

    END