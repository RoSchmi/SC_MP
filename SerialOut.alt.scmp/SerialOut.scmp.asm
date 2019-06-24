# // SerialOut.scmp

        .LF     SerialOut.scmp.lst

		.CR 	scmp	 		        //Select the intended overlay
        .TF     SerialOut.scmp.hex,int
		.TF     SerialOut.scmp.bin,BIN
                .LI     TON

                #// .OR     $0001           //The SC/MP can't start at $0000 !
                .OR $2000
                .TA $0000


		NOP
        
        LDI #$0F     // Pointer II auf Adr. $0FFF
        XPAH 2
        LDI #$FF    
        XPAL 2
        #//LDI #$15
        #//LDI #$0B
        #//LDI #$0E
        LDI #$0A 

        ST $F5(2)       // Speed einstellen
        SR 
        ST $F4(2)       // Speed/2 einstellen

        LDI #$E0        // Initialize , Stackptr Stand auf 0FE0
        ST (2)
        LDI #$0F
        ST $FF(2)

        LDI #$00        // Stacktiefe und Stackfüllstand auf Null
        ST $Fa(2)
        ST $F9(2)

        LDI #$00        // Ptr I auf LEDs
        XPAL 1
        LDI #$11
        XPAH 1
        LDI #$C0 
        ST (1)
        
        LDI #$00        // Ptr I auf Display
        XPAL 1
        LDI #$07
        XPAH 1
        LDI #$5F
        ST $07(1)
        LDI #$5E
        ST $06(1)
        LDI #$80
        ST $05(1)
        ST $04(1)
        ST $03(1)
        ST $02(1)
        LDI #$00
        ST $01(1)
        ST $00(1)

        LDI #$3E        // Adr. von Gethex - 1  (=0x0055) in Rout.Adr.
        ST $FE(2)
        LDI #$02
        ST $FD(2)
        LDI #$55        // Adr. von Push -1 (=0x0055) in Ptr III
        XPAL 3
        LDI #$00
        XPAH 3
        XPPC 3          // Anfangsdresse von Keyboard holen

        LDI #$E0
        XPAL 2          // Pointer II auf Stackbase Adr. 0x0FE0 (steht vorher auf 0FFF)
        LDI #$0F
        XPAH 2
        LD $01(2)       // Anfangsadr in 0x0FF5 und 0xFF4 sichern
        ST $15(2)
        LD $02(2)
        ST $14(2)
        XPPC 3          // Endadr. von Keyboard holen
        LD $01(2)
        ST $13(2)       // Endadr in 0x0FF3 und 0xFF2 sichern
        LD $02(2)
        ST $12(2)

        LDI #$D7        // Ptr III auf byte-Ausgabe Routine
        XPAL 3
        LDI #$05
        XPAH 3


LOOP    LDI #$00        // Ptr I auf LEDs
        XPAL 1
        LDI #$11
        XPAH 1      
        LDI #$D0        // Sync an LED4
        ST (1)       
        LDI #$07
        DLY $00
        LDI #$C0
        ST (1)

        LDI #$09       // Bit Counter laden
        ST $08(2) 

        LDI #$00 
        XAE
        SIO             // Startbit ausgeben      
        LDI #$58        
        DLY $01
            
        LD $15(2)      // Anfangsadr. (u. folgende) in Ptr I
        XPAL 1
        LD $14(2)
        XPAH 1
        LD (1)         // Datenbyte laden
        ST $07(2)      // und in Stackbase + 7 sichern
                    
        LD $07(2)      // Datenbyte laden
        #//LDI #$DC
        XAE

L1      SIO       
        LDI #$62      
        DLY $01      
        LDE
        ORI #$80
        XAE
        DLD $08(2)
        JNZ L1

        LDI #$FF    // 2 Stop Bits
        XAE 
        SIO
        LDI #$62          
        DLY $01
        LDI #$62          
        DLY $01
        
        LD $13(2)      // Adresse = Endadresse ?
        SCL 
        CAD $15(2)
        JNZ Weiter1
        LD $12(2)
        CAD $14(2)
        JNZ Weiter1
        JMP $30(2)   // ja: Elbug anspringen
Weiter1 CCL
        LD $15(2)    // Anfangsadresse incrementieren
        ADI $01 
        ST $15(2)
        LD $14(2)
        ADI $00
        ST $14(2)
        CCL
        JMP LOOP







