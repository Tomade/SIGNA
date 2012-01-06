#include "nt250.ch"

function test
local string := space(40)
clear
trapanykey("trap")
@ 10,10 say "Ok, prova: " get string pict "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
read
trapanykey()
return


procedure trap(nkey)
local objget := getactive()
local code := numlow(nkey)
local buf := objget:buffer
local pos := objget:pos

keysend(nkey, .T.)
getapplykey(objget, inkey(0))

@ 20,10 say space(40)
@ 20,10 say alltrim(objget:buffer)
@ 23,10 say space(40)
@ 23,10 say len(alltrim(objget:buffer))

objget:buffer := buf
objget:pos := pos
keysend(i2bin(nkey), .T.)
return

function scan_480
return nil
