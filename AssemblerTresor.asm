	org	00H
Temp1	equ	R7
Temp2	equ	R1
Input1	equ	R2
Input2	equ	R3
Master1	equ	R4
Master2	equ	R5
LED	equ	R6

	cseg	at 0h
	JMP	init_program

;interrupt for timer1 
	org	1Bh
	CALL	timer_ended
	JMP main_loop


	org	30h

timer_ended:
	CLR	TR1
	CLR	TF1
	CALL	reset_input
	RET

stop_timer:
	CLR	TR1
	RET


start_timer:
	CALL	stop_timer	;stop timer (if already running)
	MOV	TMOD, #10h
	MOV	TL1, #0h	;setup timer
	MOV	TH1, #0FEh
	SETB	EA		;activate individual interrupts
	SETB	ET1		;activate interrupt for timer1
	SETB	TR1
	RET
;loop: jnb TF1, loop		;just for testing purposes
;nop

reset_input:
	MOV	DPTR, #LUT	; MOVES START ADDR OF LUT TO DPTR
	MOV	A, #11111111B	; LOADS A WITH ALL 1'S
	MOV	P1, #1111111b
	MOV	P2, #00000000B	; INITIALIZES P0 AS OUTPUT PORT
	MOV	R0, #10000b
	MOV	R2, #11111111b
	MOV	R3, #11111111b
	RET



;begin of input routine
input_routine:
	CALL	reset_input
input_loop:
	CALL	Eingabe
	CJNE	R0, #10000b, erste_zahl
	LJMP	input_loop

erste_Zahl:
	CALL	start_timer
	CALL	check_for_numbers
	MOV	A, R0
	MOV	48h, A
	ORL A, #11110000b
	MOV	R2, A
	CALL	Display
	CALL	Eingabe
	MOV	A, R0
	CJNE	A, 48h, erste_zahl_change
	JMP	erste_Zahl

erste_zahl_change:
	CJNE	R0, #10000b, zweite_Zahl
	CALL	Eingabe
	JMP	erste_zahl_change
	;schreib eingaeb in Speicher fuer erste Zahl
	;Zahlen
	;warten bis zahl losgelseen und eine andere gedrückt jm zu 2.zahl

zweite_Zahl:
	CALL	start_timer
	CALL	check_for_numbers
	MOV	A,R2
	ANL	A,#00001111b
	MOV	R2, A	
	MOV	A, R0
	MOV	48h, A
	RL	A
	RL	A
	RL	A
	RL	A
	ORL	A, R2
	MOV	R2, A
	CALL	Display
	CALL	Eingabe
	MOV	A, R0
	CJNE	A, 48h, zweite_zahl_change
	;schreib eingaeb in Speicher fuer zweite Zahl
	;Zahlen
	;warten bis zahl losgelseen und eine andere gedrückt jm zu 2.zahl
	JMP	zweite_Zahl

zweite_zahl_change:
	CJNE	R0, #10000b, dritte_Zahl
	CALL	Eingabe
	JMP	zweite_zahl_change

dritte_Zahl:
	CALL	start_timer
	CALL	check_for_numbers
	MOV	A, R0
	MOV	48h, A
	ORL A, #11110000b
	MOV	R3, A
	CALL	Display
	CALL	Eingabe
	MOV	A, R0
	CJNE	A, 48h, dritte_zahl_change
	JMP	dritte_Zahl
	;schreib eingaeb in Speicher fuer dritte Zahl
	;Zahlen
	;warten bis zahl losgelseen und eine andere gedrückt jm zu 2.zahl
dritte_zahl_change:
	CJNE	R0, #10000b, vierte_Zahl
	CALL	Eingabe
	JMP	dritte_zahl_change


vierte_Zahl:
	CALL	start_timer
	CALL	check_for_numbers
	MOV	A,R3
	ANL	A,#00001111b
	MOV	R3, A
	MOV	A, R0
	MOV	48h, A
	RL	A
	RL	A
	RL	A
	RL	A
	ORL	A, R3
	MOV	R3, A
	CALL	Display

;schreib eingaeb in Speicher fuer vierte Zahl
	;Zahlen

final:
	CALL	start_timer
	CALL	Eingabe
	MOV	A, R0
	CJNE	a, #1010b, weiter1
	CALL	stop_timer
	CALL change_password
weiter1:
	CJNE	a, #1111b, weiter2
	CALL	stop_timer
	RET
;call pwcheck

weiter2:
	CJNE	a, #1110b, weiter3
	CALL	stop_timer
	CALL	reset_input
	JMP main_loop
weiter3:
	CJNE	A, #00001101b, final
	CALL	stop_timer
	CALL close
	JMP final
;warten bis A oder #  oder Abbruch Gedrückt

;checks if the pressed key is a number
Check_for_numbers:
	MOV	A, R0
	CJNE	A, #00001101b, not_close
	CALL close
not_close:
	INC	a
	INC	a
	INC	a
	INC	a
	INC	a
	INC	a
	ANL	a, #00010000b
	CJNE	a, #10000b, return
	CALL	Eingabe
	JMP	Check_for_numbers
return:
	RET




Eingabe:
	MOV	P0, #11111111B	; LOADS P1 WITH ALL 1'S
	CLR	P0.0		; MAKES ROW 1 LOW
	JB	P0.4, NEXT1	; CHECKS WHETHER COLUMN 1 IS LOW AND JUMPS TO NEXT1 IF NOT LOW
	MOV	A, #1D		; LOADS A WITH 0D IF COL IS LOW (THAT MEANS KEY 1 IS PRESSED)
	ACALL	WRITE		; CALLS DISPLAY SUBROUTINE
	RET
NEXT1:	JB	P0.5, NEXT2	; CHECKS WHETHER COLUMN 2 IS LOW AND SO ON...
	MOV	A, #4D
	ACALL	WRITE
	RET
NEXT2:	JB	P0.6, NEXT3
	MOV	A, #7D
	ACALL	WRITE
	RET
NEXT3:	JB	P0.7, NEXT4
	MOV	A, #14D		;* is E
	ACALL	WRITE
	RET
NEXT4:	SETB	P0.0
	CLR	P0.1
	JB	P0.4, NEXT5
	MOV	A, #2D
	ACALL	WRITE
	RET
NEXT5:	JB	P0.5, NEXT6
	MOV	A, #5D
	ACALL	WRITE
	RET
NEXT6:	JB	P0.6, NEXT7
	MOV	A, #8D
	ACALL	WRITE
	RET
NEXT7:	JB	P0.7, NEXT8
	MOV	A, #0D
	ACALL	WRITE
	RET
NEXT8:	SETB	P0.1
	CLR	P0.2
	JB	P0.4, NEXT9
	MOV	A, #3D
	ACALL	WRITE
	RET
NEXT9:	JB	P0.5, NEXT10
	MOV	A, #6D
	ACALL	WRITE
	RET
NEXT10:	JB	P0.6, NEXT11
	MOV	A, #9D
	ACALL	WRITE
	RET
NEXT11:	JB	P0.7, NEXT12
	MOV	A, #15D		;# = F
	ACALL	WRITE
	RET
NEXT12:	SETB	P0.2
	CLR	P0.3
	JB	P0.4, NEXT13
	MOV	A, #10D
	ACALL	WRITE
	RET
NEXT13:	JB	P0.5, NEXT14
	MOV	A, #11D
	ACALL	WRITE
	RET
NEXT14:	JB	P0.6, NEXT15
	MOV	A, #12D
	ACALL	WRITE
	RET
NEXT15:	JB	P0.7, NOTHING
	MOV	A, #13D
	ACALL	WRITE
	RET
NOTHING:
	mov	a, #16D
	ACALL	WRITE
	mov	a, #16D
	RET

WRITE:
	MOV	DPTR, #LUT
	MOVC	A, @A+DPTR
	MOV	R0, A
	CALL	Display
	RET

DISPLAY:

	;erst zahl
	MOV	a, R2
	ANL	a, #00001111b
	MOV	DPTR, #LUT1
	MOVC	A, @A+DPTR
	MOV	P2, #00h
	MOV	P1, #00000001b
	MOV	P2, A
	MOV	P1, #00000000b

	;zweite Zahl
	MOV	a, R2
	ANL	a, #11110000b
	RR	a
	RR	a
	RR	a
	RR	a
	MOV	DPTR, #LUT1
	MOVC	A, @A+DPTR
	MOV	P2, #00h
	MOV	P1, #00000010b
	MOV	P2, A
	MOV	P1, #00000000b

	;dritte zahl
	MOV	a, R3
	ANL	a, #00001111b
	MOV	DPTR, #LUT1
	MOVC	A, @A+DPTR
	MOV	P2, #00h
	MOV	P1, #00000100b
	MOV	P2, A
	MOV	P1, #00000000b

	;vierte Zahl
	MOV	a, R3
	ANL	a, #11110000b
	RR	a
	RR	a
	RR	a
	RR	a
	MOV	DPTR, #LUT1
	MOVC	A, @A+DPTR
	MOV	P2, #00h
	MOV	P1, #00001000b
	MOV	P2, A
	MOV	P1, #00000000b

	RET



LUT:
	DB	0000b, 0001b, 0010b, 0011b, 0100b, 0101b, 0110b, 0111b, 1000b, 1001b, 1010b, 1011b, 1100b, 1101b, 1110b, 1111b, 10000b
;00000000

LUT1:
	DB	3FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH, 0F7H, 0FCH, 0B9H, 0DEH, 0F9H, 0
;00000000

;Ende:
;	jmp	ende

;end of input routine

;start of password check routine
password_check:			;check password
	MOV	A, Input1
	SUBB	A, Master1
	JNZ	false_input	; if first part of password wrong, jump to false_input
	MOV	A, Input2
	SUBB	A, Master2
	JNZ	false_input	; if second part of password wrong, jump to false_input
	RET
	;don't jump if password was correct, use automatic callback from 'call'

;end of password check routine


;begin of false input routine
false_input:
	MOV	a, R6
	ANL	a, #11100000b	;clean input (set all bit exept 7,6 and 5 to 0)

;check if 3 fails
	CJNE	a, #11100000b, inc_fail_count
	JMP	fail_lock

;check count of fails
inc_fail_count:

;check if zero fails then make one
	CJNE	a, #00000000b, go_ahead
	JMP	set_to_one_fail

;check if one or two fails then make two or three
go_ahead:
	CJNE	a, #00100000b, set_to_three_fail
	JMP	set_to_two_fail

;set akku to one fail
set_to_one_fail:
	MOV	a, #00100000b
	JMP	output_false_input

;set akku to two fails
set_to_two_fail:
	MOV	a, #01100000b
	JMP	output_false_input

;set akku to three fails
set_to_three_fail:
	MOV	a, #11100000b

output_false_input:
	MOV	r6, a		;write akku to r6
	XRL	a, #11111111b	;invert byte for output
	MOV	P3, a		;write akku to Port 3

;call reset_input
	JMP	main_loop

;dead lock
fail_lock:

	JMP	fail_lock
;end of false_input
	NOP

;begin tresor open routine
open_tresor:
	MOV	a, r6		;write r6 into akku
	SETB	a.0		;set open bit to true
;clear failed tries
	CLR	a.5
	CLR	a.6
	CLR	a.7

	MOV	r6, a		;write akku back into r6
	XRL	a, #11111111b	;invert byte for output
	MOV	P3, a		;output a on Port 3
	RET
;end of tresor open routine
close:
	SETB  P3.0		
	RET

;begin change password routine
change_password:		;change the master password, correct password was already entered
	CALL	input_routine
;copy input to R1/R2
	MOV	A, Input1
	MOV	Temp1, A
	MOV	A, Input2
	MOV	Temp2, A

	CALL	input_routine
;check if temp matches input
	MOV	A, Input1
	SUBB	A, Temp1
	JNZ	password_change_failed	; if first part of password wrong, jump to password_change_failed
	MOV	A, Input2
	SUBB	A, Temp2
	JNZ	password_change_failed	; if second part of password wrong, jump to password_change_failed
;change master password
	MOV	A, Temp1
	MOV	Master1, A
	MOV	A, Temp2
	MOV	Master2, A
	JMP	password_change_successful

password_change_successful:
;flash LED 3
	CLR	p3.3
	CALL	sleep
	SETB	p3.3
	JMP	main_loop

password_change_failed:
;flash LED 2
	CLR	p3.2
	CALL	sleep
	SETB	p3.2
	JMP main_loop


sleep:
	MOV	TMOD, #01
	MOV	TL0, #0f2h
	MOV	TH0, #0ffh
	SETB	TR0
sleep_wait:
	JNB	TF0, sleep_wait
	CLR	TR0
	CLR	TF0
	RET

ende:
NOP

;end of change password routine
init_program:
	MOV	A, #00h
	MOV	Master1, A
	MOV	Master2, A
	;mov r6, #00100001b; init for false_input
	JMP	main_loop

main_loop:
	CALL	input_routine
	CALL	password_check
	CALL	open_tresor
	JMP	main_loop

end
