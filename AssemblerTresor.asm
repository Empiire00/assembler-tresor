;initial setup to test open function
init_test_open:
mov a, #11111111b
clr a.5
mov r6, a
mov P3, r6

open_tresor:

mov a, r6	;write r6 into akku
clr a.0		;set open bit to true
setb a.5	;clear failed tries
setb a.6
setb a.7
mov r6,a	;write akku back into r6
mov P3, r6	;output r6 on Port 3

end


