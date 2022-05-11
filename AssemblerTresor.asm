Eingabe1	equ	R2
Eingabe2	equ	R3
Master1	equ	R4
Master2	equ	R5

;test password for testing
	mov	A, #00010001b
	mov	Eingabe1, A
	mov	A, #00010001b
	mov	Eingabe2, A
;test master password
	mov	A, #00010001b
	mov	Master1, A
	mov	A, #00010001b
	mov	Master2, A

open_check:	;opening (# was pressed)
	call	password_check
	jmp	open_tresor

change_check: 	;changing (A was pressed)
	call 	password_check
	jmp	change_password


password_check:	;check password
	mov	A, Eingabe1
	subb	A, Master1
	jnz	false_input	; if first part of password wrong, jump to false_input
	mov	A, Eingabe2
	subb	A, Master2
	jnz	false_input	; if second part of password wrong, jump to false_input
	ret
	;don't jump if password was correct, use automatic callback from 'call'

false_input:
nop
open_tresor:
nop
change_password:
nop

	end