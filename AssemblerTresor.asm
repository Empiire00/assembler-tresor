Temp1	equ	R0
Temp2	equ	R1
Input1	equ	R2
Input2	equ	R3
Master1	equ	R4
Master2	equ	R5

led	equ	P3


change_password:		;change the master password, correct password was already entered
	call	input
;copy input to R1/R2
	mov	A, Input1
	mov	Temp1, A
	mov	A, Input2
	mov	Temp2, A

	call	input
;check if temp matches input
	mov	A, Input1
	subb	A, Temp1
	jnz	password_change_failed	; if first part of password wrong, jump to password_change_failed
	mov	A, Input2
	subb	A, Temp2
	jnz	password_change_failed	; if second part of password wrong, jump to password_change_failed
;change master password
	mov	A, Temp1
	mov	Master1, A
	mov	A, Temp2
	mov	Master2, A
	jmp	password_change_successful

password_change_successful:
;flash LED 3
	clr	led.3
	call	sleep
	setb	led.3

password_change_failed:
;flash LED 2
	clr	led.2
	call	sleep
	setb	led.2


input:
	mov	A, #00010001b
	mov	Input1, A
	mov	Input2, A
	ret

sleep:
	ret

	end