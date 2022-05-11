;initial setup to test open function
init_test_open:
mov a, #00000000b
setb a.5
mov r6, a
mov P3, r6

open_tresor:

mov a, r6	;write r6 into akku
setb a.0		;set open bit to true
;clear failed tries
clr a.5	
clr a.6
clr a.7

mov r6,a	;write akku back into r6
xrl a, #11111111b ;invert byte for output
mov P3, a	;output a on Port 3



end


