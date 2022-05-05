init:
mov r6, #00000001b



false_input:
mov a, R6

;check if 3 fails
cjne R6, #00000111b, inc_fail_count
ajmp fail_lock

;else add one 
inc_fail_count:
rl a
inc a
mov r6, a
ajmp false_input


fail_lock:

Ajmp fail_lock