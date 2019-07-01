# // Serial_In.scmp     Version from 01.07.2019
# // This program for SC/MP (Fixed Startaddress: $7200)
# // Receives Data (Programs) through the serial interface
# // Baudrate = 600 and cannot be changed
# // Monitor Software 'Elbug' has to be on the SC/MP
# // Use for example the utility "Z80_Term_Utility" to send the data from PC

# // Compiled with SB-Assembler
# // https://github.com/sbprojects/sbasm3


        .LF     SerialIn.scmp.lst

		.CR 	scmp	 		        //Select the intended overlay
        .TF     SerialIn.scmp.hex,int
		.TF     SerialIn.scmp.bin,BIN
                .LI     TON

                #// .OR     $0001           //The SC/MP can't start at $0000 !
                .OR $7200
                #//.TA $0000

		
        LDI #$00     // Place where to store received Data is $2000
        ST $0F(2)     
        LDI #$20 
        ST $10(2)
        NOP 
Loop    DINT  
        
        LDI #$11        // Ptr I on LEDs
        XPAH 1      
        LDI #$00
        XPAL 1
        
        LDI #$2F       // Addr. Interrupt -1 --> Rout. Addr.
        ST $1D(2)
        LDI #$72
        ST $1C(2)

        LDI #$00        // Push - 1 --> Ptr. III
        XPAH 3      
        LDI #$55        
        XPAL 3
      
        LDI #$90        // CTS 
        ST $00(1)

        IEN 
        NOP
        NOP
        JMP Loop

        
        Nop                 // Dummies
        Nop
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP

#//**********************************************************
SerialRead              
        LDI #$E0            // Stackbase --> Ptr III
        XPAL 2
        LDI #$0F        
        XPAH 2

        LDI #$11            // Pointer to LEDs in Ptr I     
        XPAH 1
        LDI #$00       
        XPAL 1


        LDI #$90            // Set LEDs on "Read"
        ST (1)             
        LDI #$01
        XPAH 3
        LDI #$D0
        XPAL 3
        XPPC 3              // Get byte
        XAE 
        LDI #$A0            // Startaddress in Ptr I
        ST (1)
        LD $0F(2)
        XPAL 1 
        LD $10(2)
        XPAH 1
        XAE 
        ST $00(1)           // Store Byte
        XPAL 1              // Increment pointer
        CCL
        ADI $01
        ST $0F(2)           // and store pointer
        XPAH 1
        ADI $00
        ST $10(2)
        LDI #$00
        XPAH 3
        LDI #$14
        XPAL 3
        XPPC 3              // Jump back to main program
        HALT
        HALT




        





