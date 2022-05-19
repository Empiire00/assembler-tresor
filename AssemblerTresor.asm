
	ORG 	00H
init:
	MOV 	DPTR,#LUT 	; MOVES START ADDR OF LUT TO DPTR
	MOV 	A,#11111111B 	; LOADS A WITH ALL 1'S
	mov 	P1,#1111111b
	MOV 	P2,#00000000B 	; INITIALIZES P0 AS OUTPUT PORT
	MOV 	R0,#10000b
	Mov  	R2,#11111111b
	Mov 	R3,#11111111b
	
Start:
	ACall Eingabe
	CJNE R0,#10000b,erste_zahl
	LJMP START
	
erste_Zahl:
call check_for_numbers
MOV A, R0
MOV R2, A
MOV 48h, A 
Acall Display
ACall Eingabe
MOV A, R0
CJNE A,48h, erste_zahl_change
jmp erste_Zahl

erste_zahl_change:
	CJNE R0,#10000b, zweite_Zahl
	ACall Eingabe
	jmp erste_zahl_change
	;schreib eingaeb in Speicher fuer erste Zahl
	;Zahlen
	;warten bis zahl losgelseen und eine andere gedrückt jm zu 2.zahl
	
zweite_Zahl:
call check_for_numbers
MOV A, R0
MOV 48h, A
RL A
RL A
RL A
RL A
ORL A, R2
MOV R2, A 
Acall Display
ACall Eingabe
MOV A, R0
CJNE A,48h, zweite_zahl_change
	;schreib eingaeb in Speicher fuer zweite Zahl
	;Zahlen
	;warten bis zahl losgelseen und eine andere gedrückt jm zu 2.zahl
	jmp zweite_Zahl

zweite_zahl_change:
	CJNE R0,#10000b, dritte_Zahl
	ACall Eingabe
	jmp zweite_zahl_change

dritte_Zahl:
call check_for_numbers
MOV A, R0
MOV R3, A
MOV 48h, A 
Acall Display
ACall Eingabe
MOV A, R0
CJNE A,48h, dritte_zahl_change

jmp dritte_Zahl
	;schreib eingaeb in Speicher fuer dritte Zahl
	;Zahlen
	;warten bis zahl losgelseen und eine andere gedrückt jm zu 2.zahl
dritte_zahl_change:
	CJNE R0,#10000b, vierte_Zahl
	ACall Eingabe
	jmp dritte_zahl_change

	
vierte_Zahl:
call check_for_numbers
MOV A, R0
MOV 48h, A
RL A
RL A
RL A
RL A
ORL A, R3
MOV R3, A 
call Display

;schreib eingaeb in Speicher fuer vierte Zahl
	;Zahlen

final:	
ACall Eingabe
MOV A, R0
cjne a, #1010b ,weiter1
;call change
weiter1:
cjne a, #1111b ,weiter2
;call pwcheck
weiter2:
cjne a, #1101b, final
jmp init
	;warten bis A oder #  oder Abbruch Gedrückt

Check_for_numbers:
Mov 	A, R0
inc a
inc a
inc a
inc a
inc a
inc a
anl a, #00010000b
cjne a, #10000b , return
call Eingabe
jmp Check_for_numbers
return:
RET



	
Eingabe:
	MOV 	P0,#11111111B 	; LOADS P1 WITH ALL 1'S
     	CLR 	P0.0  		; MAKES ROW 1 LOW
     	JB 	P0.4,NEXT1  	; CHECKS WHETHER COLUMN 1 IS LOW AND JUMPS TO NEXT1 IF NOT LOW
     	MOV 	A,#1D   	; LOADS A WITH 0D IF COL IS LOW (THAT MEANS KEY 1 IS PRESSED)
     	ACALL 	WRITE ; CALLS DISPLAY SUBROUTINE
     	RET
NEXT1:	JB 	P0.5,NEXT2 	; CHECKS WHETHER COLUMN 2 IS LOW AND SO ON...
      	MOV 	A,#4D
      	ACALL 	WRITE
      	RET
NEXT2:	JB 	P0.6,NEXT3
      	MOV 	A,#7D
      	ACALL 	WRITE
      	RET
NEXT3:	JB 	P0.7,NEXT4
      	MOV 	A,#14D  ;* is E
      	ACALL 	WRITE
      	RET
NEXT4:	SETB 	P0.0
      	CLR 	P0.1
      	JB 	P0.4,NEXT5
      	MOV 	A,#2D
      	ACALL 	WRITE
      	RET
NEXT5:	JB 	P0.5,NEXT6
      	MOV 	A,#5D
      	ACALL 	WRITE
      	RET
NEXT6:	JB 	P0.6,NEXT7
      	MOV 	A,#8D
      	ACALL 	WRITE
      	RET
NEXT7:	JB 	P0.7,NEXT8
      	MOV 	A,#0D
      	ACALL WRITE
      	RET
NEXT8:	SETB 	P0.1
      	CLR 	P0.2
      	JB 	P0.4,NEXT9
      	MOV 	A,#3D
      	ACALL 	WRITE
      	RET
NEXT9:	JB 	P0.5,NEXT10
      	MOV 	A,#6D
      	ACALL 	WRITE
      	RET
NEXT10:	JB 	P0.6,NEXT11
       	MOV 	A,#9D
       	ACALL 	WRITE
       	RET
NEXT11:	JB 	P0.7,NEXT12
       	MOV 	A,#15D ;# = F
       	ACALL 	WRITE
       	RET
NEXT12:	SETB 	P0.2
       	CLR 	P0.3
       	JB 	P0.4,NEXT13
       	MOV 	A,#10D
       	ACALL 	WRITE
       	RET
NEXT13:	JB 	P0.5,NEXT14
       	MOV 	A,#11D
       	ACALL 	WRITE
       	RET
NEXT14:	JB 	P0.6,NEXT15
       	MOV 	A,#12D
       	ACALL 	WRITE
       	RET
NEXT15:	JB 	P0.7,NOTHING
       	MOV 	A,#13D
       	ACALL 	WRITE
       	RET
NOTHING:
	mov a, #16D
	ACALL 	WRITE
	mov a, #16D
       	RET

WRITE:
MOV 	DPTR,#LUT
MOVC 	A,@A+DPTR
MOV     R0, A
Call Display
	RET
	
DISPLAY:
	
	;erst zahl
	mov a, R2
	anl a,#00001111b
	MOV 	DPTR,#LUT1
	MOVC 	A,@A+DPTR
	Mov 	P1, #00000001b
        MOV 	P2,A
        Mov 	P1, #00000000b   
        ;zweite Zahl
        mov a, R2
        anl a,#11110000b
	RR a
	RR a
	RR a
	RR a
	MOV 	DPTR,#LUT1
	MOVC 	A,@A+DPTR
	Mov 	P1, #00000010b
        MOV 	P2,A 
        Mov 	P1, #00000000b
        ;dritte zahl
	mov a, R3
	anl a,#00001111b
	MOV 	DPTR,#LUT1
	MOVC 	A,@A+DPTR
	Mov 	P1, #00000100b
        MOV 	P2,A  
        Mov 	P1, #00000000b
        ;vierte Zahl
        mov a, R3
        anl a,#11110000b
	RR a
	RR a
	RR a
	RR a
	MOV 	DPTR,#LUT1
	MOVC 	A,@A+DPTR
	Mov 	P1, #00001000b
        MOV 	P2,A 
        Mov 	P1, #00000000b
            	
        RET



LUT: 
DB 0000b, 0001b, 0010b, 0011b, 0100b, 0101b, 0110b, 0111b, 1000b, 1001b, 1010b, 1011b, 1100b, 1101b, 1110b, 1111b, 10000b
;00000000

LUT1: 
DB 3FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH,0F7H,0FCH,0B9H,0DEH,0F9H,0  
;00000000
Ende: 
jmp ende
     END
