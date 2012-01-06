
clear screen
use nomi new
use cognomi new
use atleti new
zap
USE staffette new
zap
ncod = 0
select atleti
go top
for k:= 1 to 100
   append blank
   ++ncod
   replace Atleti->codice with alltrim(str(ncod,4))
   replace Atleti->societa with alltrim(str((ncod%10) + 1,4))
   replace Atleti->nome with pickname()
   replace Atleti->cognome with pickcogn()
   replace Atleti->sesso with if(right(alltrim(Atleti->nome), 1) == 'o', 'M', 'F')
   replace Atleti->anno with str(random() % 25 + 1950, 4)
   eta := year(date()) - val(Atleti->Anno)
   eta := 5 * int(eta / 5)
   REPLACE Atleti->Categoria WITH str(eta,2)
   mm := random() % 5 + 1
   ss := random() % 60
   cc := random() % 100
   tt := str(mm,2) + "'" + str(ss,2) +'"' + str(cc,2)
   replace Atleti->T_Iscr1 with STRTRAN(tt, " ", "0")
   mm := random() % 4 + 1
   ss := random() % 60
   cc := random() % 100
   tt := str(mm,2) + "'" + str(ss,2) +'"' + str(cc,2)
   replace Atleti->T_Gara1 with STRTRAN(tt, " ", "0")


   mm := random() % 3
   ss := 20 + random() % 40
   cc := random() % 100
   tt := str(mm,2) + "'" + str(ss,2) +'"' + str(cc,2)
   replace Atleti->T_Iscr2 with STRTRAN(tt, " ", "0")
   mm := random() % 2
   ss := 20 + random() % 40
   cc := random() % 100
   tt := str(mm,2) + "'" + str(ss,2) +'"' + str(cc,2)
   replace Atleti->T_Gara2 with STRTRAN(tt, " ", "0")
   @ 1,1 say k
next k


// staffette
ncod := 0
select staffette
go top
for k:= 1 to 100
   append blank
   ++ncod
   replace Staffette->codice with alltrim(str(ncod,4))
   replace Staffette->societa with alltrim(str((ncod%10) + 1,4))
   replace Staffette->nome with pickcogn()+pickname()
   replace Staffette->sesso with if(right(alltrim(Staffette->nome), 1) == 'o', 'M', 'F')
   REPLACE Staffette->Categoria WITH chr(ASC("A") + random() % 5)
   mm := random() % 5 + 1
   ss := random() % 60
   cc := random() % 100
   tt := str(mm,2) + "'" + str(ss,2) +'"' + str(cc,2)
   replace Staffette->T_Iscr1 with STRTRAN(tt, " ", "0")
   mm := random() % 4 + 1
   ss := random() % 60
   cc := random() % 100
   tt := str(mm,2) + "'" + str(ss,2) +'"' + str(cc,2)
   replace Staffette->T_Gara1 with STRTRAN(tt, " ", "0")


   mm := random() % 3
   ss := 20 + random() % 40
   cc := random() % 100
   tt := str(mm,2) + "'" + str(ss,2) +'"' + str(cc,2)
   replace Staffette->T_Iscr2 with STRTRAN(tt, " ", "0")
   mm := random() % 2
   ss := 20 + random() % 40
   cc := random() % 100
   tt := str(mm,2) + "'" + str(ss,2) +'"' + str(cc,2)
   replace Staffette->T_Gara2 with STRTRAN(tt, " ", "0")

   @ 2,1 say k
next k

close data
return NIL


function pickname()
   local oldarea := select()
   select nomi
   go (random() % lastrec() + 1)
   select (oldarea)
   return nomi->nome

function pickcogn()
   local oldarea := select()
   select cognomi
   go (random() % lastrec() + 1)
   select (oldarea)
   return cognomi->cognome


function scan_480
return NIL
