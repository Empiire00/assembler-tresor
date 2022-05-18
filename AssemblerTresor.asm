
	ORG 	00H

Start:
	;check for eingabe 
	;if not jmp start
	;els jmp 1.Zahl;

erste_Zahl:
	;schreib eingaeb in Speicher fuer erste Zahl
	;Zahlen
	;warten bis zahl losgelseen und eine andere gedrückt jm zu 2.zahl
	
zweite_Zahl:
	;schreib eingaeb in Speicher fuer zweite Zahl
	;Zahlen
	;warten bis zahl losgelseen und eine andere gedrückt jm zu 2.zahl
	
dritte_Zahl:
	;schreib eingaeb in Speicher fuer dritte Zahl
	;Zahlen
	;warten bis zahl losgelseen und eine andere gedrückt jm zu 2.zahl
vierte_Zahl:
	;schreib eingaeb in Speicher fuer vierte Zahl
	;Zahlen
	;warten bis A oder #  oder Abbruch Gedrückt



	
Eingabe:
	MOV 	DPTR,#LUT 	; MOVES START ADDR OF LUT TO DPTR
	MOV 	A,#11111111B 	; LOADS A WITH ALL 1'S
	mov 	P1,#1111111b
	MOV 	P2,#00000000B 	; INITIALIZES P0 AS OUTPUT PORT

BACK:	MOV 	P0,#11111111B 	; LOADS P1 WITH ALL 1'S
     	CLR 	P0.0  		; MAKES ROW 1 LOW
     	JB 	P0.4,NEXT1  	; CHECKS WHETHER COLUMN 1 IS LOW AND JUMPS TO NEXT1 IF NOT LOW
     	MOV 	A,#1D   	; LOADS A WITH 0D IF COL IS LOW (THAT MEANS KEY 1 IS PRESSED)
     	ACALL 	DISPLAY ; CALLS DISPLAY SUBROUTINE
     	LJMP 	BACK 	
NEXT1:	JB 	P0.5,NEXT2 	; CHECKS WHETHER COLUMN 2 IS LOW AND SO ON...
      	MOV 	A,#4D
      	ACALL 	DISPLAY
      	LJMP 	BACK
NEXT2:	JB 	P0.6,NEXT3
      	MOV 	A,#7D
      	ACALL 	DISPLAY
      	LJMP 	BACK
NEXT3:	JB 	P0.7,NEXT4
      	MOV 	A,#14D  ;* is E
      	ACALL 	DISPLAY
      	LJMP 	BACK
NEXT4:	SETB 	P0.0
      	CLR 	P0.1
      	JB 	P0.4,NEXT5
      	MOV 	A,#2D
      	ACALL 	DISPLAY
      	LJMP 	BACK
NEXT5:	JB 	P0.5,NEXT6
      	MOV 	A,#5D
      	ACALL 	DISPLAY
      	LJMP 	BACK
NEXT6:	JB 	P0.6,NEXT7
      	MOV 	A,#8D
      	ACALL 	DISPLAY
      	LJMP 	BACK
NEXT7:	JB 	P0.7,NEXT8
      	MOV 	A,#0D
      	ACALL DISPLAY
      	LJMP 	BACK
NEXT8:	SETB 	P0.1
      	CLR 	P0.2
      	JB 	P0.4,NEXT9
      	MOV 	A,#3D
      	ACALL 	DISPLAY
      	LJMP 	BACK
NEXT9:	JB 	P0.5,NEXT10
      	MOV 	A,#6D
      	ACALL 	DISPLAY
      	LJMP 	BACK
NEXT10:	JB 	P0.6,NEXT11
       	MOV 	A,#9D
       	ACALL 	DISPLAY
       	LJMP 	BACK
NEXT11:	JB 	P0.7,NEXT12
       	MOV 	A,#15D ;# = F
       	ACALL 	DISPLAY
       	LJMP 	BACK
NEXT12:	SETB 	P0.2
       	CLR 	P0.3
       	JB 	P0.4,NEXT13
       	MOV 	A,#10D
       	ACALL 	DISPLAY
       	LJMP 	BACK
NEXT13:	JB 	P0.5,NEXT14
       	MOV 	A,#11D
       	ACALL 	DISPLAY
       	LJMP 	BACK
NEXT14:	JB 	P0.6,NEXT15
       	MOV 	A,#12D
       	ACALL 	DISPLAY
       	LJMP 	BACK
NEXT15:	JB 	P0.7,Nothing
       	MOV 	A,#13D
       	ACALL 	DISPLAY
       	LJMP 	BACK
Nothing:
	mov a, #16D
	ACALL 	DISPLAY
	mov a, #16D
       	LJMP 	BACK
	
DISPLAY:MOVC 	A,@A+DPTR 	; GETS DIGIT DRIVE PATTERN FOR THE CURRENT KEY FROM LUT
	MOV 	DPTR,#LUT1
	MOVC 	A,@A+DPTR
        MOV 	P2,A       	; PUTS CORRESPONDING DIGIT DRIVE PATTERN INTO P0
        MOV 	DPTR,#LUT
        RET

LUT: 
DB 0000b, 0001b, 0010b, 0011b, 0100b, 0101b, 0110b, 0111b, 1000b, 1001b, 1010b, 1011b, 1100b, 1101b, 1110b, 1111b, 10000b
;00000000

LUT1: 
DB 3FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH,0F7H,0FCH,0B9H,0DEH,0F9H,0F1H,0  
;00000000

     END
