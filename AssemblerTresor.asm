	ORG	00H
Input1	equ	R2
Input2	equ	R3
Master1	equ	R4
Master2	equ	R5
LED	equ	R6

	cseg	at 0h
	jmp	init_program

;interrupt for timer1 
	ORG	1Bh
	call	timer_ended
	reti


	org	20h

timer_ended:
	clr	TR1
	clr	TF1
	mov	A, #0ffh
	mov	Input1, A
	mov	Input2, A
	ret

stop_timer:
	clr	TR1
	ret


start_timer:
	call	stop_timer	;stop timer (if already running)
	mov	TMOD, #10h
	mov	TL1, #0h	;setup timer
	mov	TH1, #0ffh
	setb	EA		;activate individual interrupts
	setb	ET1		;activate interrupt for timer1
	setb	TR1
	ret
;loop: jnb TF1, loop		;just for testing purposes
;nop

reset_input:
	MOV	DPTR, #LUT	; MOVES START ADDR OF LUT TO DPTR
	MOV	A, #11111111B	; LOADS A WITH ALL 1'S
	mov	P1, #1111111b
	MOV	P2, #00000000B	; INITIALIZES P0 AS OUTPUT PORT
	MOV	R0, #10000b
	Mov	R2, #11111111b
	Mov	R3, #11111111b
	ret

init:
	call	reset_input


;begin of input routine
input_routine:
	call	reset_input
input_loop:
	ACall	Eingabe
	CJNE	R0, #10000b, erste_zahl
	LJMP	input_loop

erste_Zahl:
	CALL	check_for_numbers
	MOV	A, R0
	MOV	48h, A
;ORL A, #11110000b
	MOV	R2, A
	ACALL	Display
	ACALL	Eingabe
	MOV	A, R0
	CJNE	A, 48h, erste_zahl_change
	JMP	erste_Zahl

erste_zahl_change:
	CJNE	R0, #10000b, zweite_Zahl
	ACALL	Eingabe
	JMP	erste_zahl_change
	;schreib eingaeb in Speicher fuer erste Zahl
	;Zahlen
	;warten bis zahl losgelseen und eine andere gedrückt jm zu 2.zahl

zweite_Zahl:
	CALL	check_for_numbers
	MOV	A, R0
	MOV	48h, A
	RL	A
	RL	A
	RL	A
	RL	A
	ORL	A, R2
	MOV	R2, A
	ACALL	Display
	ACALL	Eingabe
	MOV	A, R0
	CJNE	A, 48h, zweite_zahl_change
	;schreib eingaeb in Speicher fuer zweite Zahl
	;Zahlen
	;warten bis zahl losgelseen und eine andere gedrückt jm zu 2.zahl
	JMP	zweite_Zahl

zweite_zahl_change:
	CJNE	R0, #10000b, dritte_Zahl
	ACall	Eingabe
	JMP	zweite_zahl_change

dritte_Zahl:
	CALL	check_for_numbers
	MOV	A, R0
	MOV	R3, A
	MOV	48h, A
	ACALL	Display
	ACALL	Eingabe
	MOV	A, R0
	CJNE	A, 48h, dritte_zahl_change

	JMP	dritte_Zahl
	;schreib eingaeb in Speicher fuer dritte Zahl
	;Zahlen
	;warten bis zahl losgelseen und eine andere gedrückt jm zu 2.zahl
dritte_zahl_change:
	CJNE	R0, #10000b, vierte_Zahl
	ACALL	Eingabe
	JMP	dritte_zahl_change


vierte_Zahl:
	CALL	check_for_numbers
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
	ACall	Eingabe
	MOV	A, R0
	CJNE	a, #1010b, weiter1
;call change
weiter1:
	CJNE	a, #1111b, weiter2
	ret
;call pwcheck
weiter2:
	CJNE	a, #1101b, final
	JMP	init
;warten bis A oder #  oder Abbruch Gedrückt

;checks if the pressed key is a number
Check_for_numbers:
	Mov	A, R0
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
	Call	Display
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
	mov	A, Input1
	subb	A, Master1
	jnz	false_input	; if first part of password wrong, jump to false_input
	mov	A, Input2
	subb	A, Master2
	jnz	false_input	; if second part of password wrong, jump to false_input
	ret
	;don't jump if password was correct, use automatic callback from 'call'

;end of password check routine


;begin of false input routine
false_input:
	mov	a, R6
	anl	a, #11100000b	;clean input (set all bit exept 7,6 and 5 to 0)

;check if 3 fails
	cjne	a, #11100000b, inc_fail_count
	ajmp	fail_lock

;check count of fails
inc_fail_count:

;check if zero fails then make one
	cjne	a, #00000000b, go_ahead
	ajmp	set_to_one_fail

;check if one or two fails then make two or three
go_ahead:
	cjne	a, #00100000b, set_to_three_fail
	ajmp	set_to_two_fail

;set akku to one fail
set_to_one_fail:
	mov	a, #00100000b
	ajmp	output_false_input

;set akku to two fails
set_to_two_fail:
	mov	a, #01100000b
	ajmp	output_false_input

;set akku to three fails
set_to_three_fail:
	mov	a, #11100000b

output_false_input:
	mov	r6, a		;write akku to r6
	xrl	a, #11111111b	;invert byte for output
	mov	P3, a		;write akku to Port 3

;call reset_input
	AJMP	main_loop

;dead lock
fail_lock:

	Ajmp	fail_lock
;end of false_input
	nop

;begin tresor open routine
open_tresor:
	mov	a, r6		;write r6 into akku
	setb	a.0		;set open bit to true
;clear failed tries
	clr	a.5
	clr	a.6
	clr	a.7

	mov	r6, a		;write akku back into r6
	xrl	a, #11111111b	;invert byte for output
	mov	P3, a		;output a on Port 3
	ret
;end of tresor open routine

init_program:
	mov	A, #00h
	mov	Master1, A
	mov	Master2, A
	;mov r6, #00100001b; init for false_input
	jmp	main_loop

main_loop:
	call	input_routine
	call	password_check
	call	open_tresor
	jmp	main_loop

	end
