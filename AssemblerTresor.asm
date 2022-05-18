Input1	equ	R2
Input2	equ	R3

	cseg	at 0h
	jmp	start_timer

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
	clr TR1
	ret


start_timer:
	call stop_timer		;stop timer (if already running)
	mov	TMOD, #10h	
	mov	TL1, #0h	;setup timer
	mov	TH1, #0ffh
	setb	EA		;activate individual interrupts
	setb	ET1		;activate interrupt for timer1
	setb	TR1
loop: jnb TF1, loop		;just for testing purposes
nop
