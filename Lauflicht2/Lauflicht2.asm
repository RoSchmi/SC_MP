        .LF     Lauflicht2.lst

		.CR 	scmp	 		        //Select the intended overlay
        .TF     Lauflicht2.hex,int
		.TF     Lauflicht2.bin,BIN
                .LI     TON

                #// .OR     $0001           //The SC/MP can't start at $0000 !
                .OR $2000
                .TA $0000


		NOP
        LDI    #$11
        XPAH 3
        LDI #$00
        XPAL 3
SETLED  LDI #$01
.LOOP   ST (3)
        RR
        XAE
        DLY #$FF
        LDE
        JMP .LOOP
        

