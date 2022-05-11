init:
mov r6, #00100001b



false_input:
mov a, R6
anl a, #11100000b ;clean input (set all bit exept 7,6 and 5 to 0)

;check if 3 fails
cjne a, #11100000b, inc_fail_count
ajmp fail_lock

;check count of fails
inc_fail_count:

;check if zero fails then make one
cjne a, #00000000b, go_ahead
ajmp set_to_one_fail

;check if one or two fails then make two or three
go_ahead:
cjne a, #00100000b, set_to_three_fail
ajmp set_to_two_fail

;set akku to one fail
set_to_one_fail:
mov a, #00100000b
ajmp output_false_input

;set akku to two fails
set_to_two_fail: 
mov a, #01100000b
ajmp output_false_input

;set akku to three fails
set_to_three_fail:
mov a, #11100000b

output_false_input:
mov r6, a ;write akku to r6
xrl a, #11111111b ;invert byte for output
mov P3, a ;write akku to Port 3

AJMP false_input

;dead lock
fail_lock:

Ajmp fail_lock