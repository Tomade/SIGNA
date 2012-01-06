// Atleti.Prg

#include "inkey.ch"
#include "setcurs.ch"
#include "nt2win.ch"


FUNCTION AtletiEdit( InsertMode )
   memvar timefmt, getlist
   local b, column, cType, n, wCodice
   local cColorSave, nCursSave
   local lMore, nKey, lAppend, meth_no
   local nTop, nLeft, nBottom, nRight
   local insButs :=  { ;
         { "Naviga", "<" + chr(25) + chr(24) + ">" }, ;
         { "Lookup", "<F2>" }, ;
         { "OK", "<F10>" }, ;
         { "Esci", "<ESC>" } ;
      }

   local varButs :=  { ;
         { "Naviga", "<" + chr(25) + chr(24) + ">" }, ;
         { "Lookup", "<F2>" }, ;
         { "Elimina", "<F4>" }, ;
         { "OK", "<F10>" }, ;
         { "Esci", "<ESC>" } ;
      }
/*       { "Naviga", "<" + chr(27) + chr(25) + chr(24) + chr(26) + ">" }, */


   SetColor("N/W")
   WOpen(5,5, 21,73)
   WBox(WB_SINGLE)

   OpenAtleti()
   do while .t.         // ------------------ main loop
      SELECT Atleti
      set order to 1
      GO TOP
      DrawTitles()
      if (InsertMode .OR. eof())
         SetColor("GR+/R")
         @ -1, 18 SAY " INSERIMENTO SCHEDA PARTECIPANTE "
         SetColor("N/W, gr+/rb,,,n/bg")
         ButtsRow(13, 0, 66, insButs)
         AtletaADD()
         @ 01,08 SAY Atleti->Codice PICT "9999"
      else
         SetColor("GR+/R")
         @ -1, 19 SAY " VARIAZIONE SCHEDA PARTECIPANTE "
         SetColor("N/W, gr+/rb,,,n/bg")
         wCodice = space(4)
         do while .t.
            @ 01,08 GET wCodice PICT "9999"
            SetCursor(SC_NORMAL)
            read
            if lastkey() == K_ESC
               SetCursor(SC_NONE)
               WClose()
               CloseAtleti()
               return NIL
            endif
            seek wCodice
            if found()
               ButtsRow(13, 0, 66, varButs)
               exit
            else
               ERR_NotFound()
            endif
         enddo
      endif

      // Continuiamo da qui, sia se nuovo atleta, sia se in modifica dati
      @ 1,23  get Atleti->Societa PICT "999" valid SaySocName(Atleti->Societa)

      @ 3,08  get Atleti->Cognome PICT "!" + repl("x", 20)
      @ 3,36  get Atleti->Nome PICT "!" + repl("x", 20) VALID CheckNome()

      @ 3,64  get Atleti->sesso pict "!" valid Atleti->sesso$"MF"
      @ 6,8   get Atleti->anno pict "9999" WHEN preAnno() VALID !Empty(Atleti->Anno)
      @ 8,9   get Atleti->Categoria pict "999" WHEN preCateg() VALID CheckCateg()

      @ 5,40  get Atleti->T_Iscr1 PICT timefmt
      @ 6,40  get Atleti->T_Iscr2 PICT timefmt
      @ 7,40  get Atleti->T_Iscr3 PICT timefmt
      @ 8,40  get Atleti->T_Iscr4 PICT timefmt
      @ 9,40  get Atleti->T_Iscr5 PICT timefmt
      @ 10,40  get Atleti->T_Iscr6 PICT timefmt

      Set KEY K_F2 TO LookUp
      If !InsertMode
         Set KEY K_F4 TO Cancella
      Endif
      Set KEY K_F10 TO OK
      SaySocName(Atleti->Societa)
      Set Cursor ON
      Read
      Set Cursor OFF
      Set KEY K_F2 TO
      Set KEY K_F4 TO
      Set KEY K_F10 TO
      if (Empty(Atleti->Cognome) .AND. Empty(Atleti->Nome))
         delete
      endif
      if (EmptyTime(Atleti->T_ISCR1) .AND. EmptyTime(Atleti->T_ISCR2) .AND. EmptyTime(Atleti->T_ISCR3) .and. ;
          EmptyTime(Atleti->T_ISCR4) .AND. EmptyTime(Atleti->T_ISCR5) .AND. EmptyTime(Atleti->T_ISCR6) )
         delete
      endif

      if lastkey() == K_ESC
         exit
      endif
   enddo // ----------- main loop

   WClose()

   CloseAtleti()
   return NIL




FUNCTION CheckNome()
   local    c, name := lower(Alltrim(Atleti->nome))
   IF Empty(Atleti->sesso) .and. !Empty(name)
      c := right(name, 1)
      DO CASE
      CASE c ==  'a' .and. name != 'andrea' .and. name != 'luca' .and. name != 'nicola'
         Replace Atleti->Sesso WITH 'F'
      CASE c ==  'o' .or. name == 'andrea' .or. name == 'luca' .or. name == 'nicola'
         Replace Atleti->Sesso WITH 'M'
      ENDCASE
   ENDIF
RETURN .t.


FUNCTION PreAnno()
   keyboard chr(K_RIGHT) + chr(K_RIGHT)
RETURN .t.


FUNCTION PreCateg()    // precalcolo categoria atleta dall'anno di nascita
   local eta := year(date()) - val(Atleti->Anno)
   eta := 5 * int(eta / 5)
   if eta > 75
      eta := 75
   endif
   REPLACE Atleti->Categoria WITH str(eta,2)
RETURN .t.


FUNCTION CheckCateg()
   local retval
   local eta := val(Atleti->Categoria)
   if (eta % 5 != 0 .or. eta < 20 .or. eta > 75)
      retval := .F.
   else
      retval := .T.
   endif
RETURN retval


STATIC FUNCTION DrawTitles()
   @ 01,01 SAY "Cod.: " + Space(4)
   @ 01,14 SAY "Societ…: " + Space(30)
   @ 03,01 say "Cogn.: " + Space(20)
   @ 03,30 say "Nome: "    + Space(20)
   @ 03,57 say "Sesso: "
   @ 06,01 say "Anno : "  + Space(4)
   @ 08,01 say "Cat. : M" + Space(3)
   /*
   @ 07,04 say [ÚÄÄ GARA ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ T. ISCRIZIONE ÄÄÄÄÄ T. IN GARA ÄÄ¿]
   @ 08,04 SAY [³ 100 Dorso                                                  ³]
   @ 09,04 SAY [³  50 Rana                                                   ³]
   @ 10,04 SAY [³ 4 x 50 Stile Libero                                        ³]
   @ 11,04 SAY [³ 4 x 50 Misti                                               ³]
   @ 12,04 SAY [ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ]
   */
   @ 04,19 say [ÚÄÄ GARA ÄÄÄÄÄÄÄÄ T. ISCRIZIONE Ä¿]
   @ 05,19 SAY [³  50 Stile Libero               ³]
   @ 06,19 SAY [³  50 Rana                       ³]
   @ 07,19 SAY [³  50 Dorso                      ³]
   @ 08,19 SAY [³  50 Farfalla                   ³]
   @ 09,19 SAY [³ 100 Misti                      ³]
   @ 10,19 SAY [³ 200 Stile Libero               ³]
   @ 11,19 SAY [ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ]


return NIL




FUNCTION AtletaADD()
   FIELD Codice
   local nCodice, nSocieta, nOrder

   nOrder := INDEXORD()
   SET ORDER TO 0
   go bottom
   nCodice := val(Atleti->Codice) + 1
   nSocieta := Atleti->Societa      // 'set carry on'
   set order to nOrder
   APPEND BLANK
   REPLACE Codice WITH alltrim(str(nCodice,4))
   REPLACE Societa WITH nSocieta
   REPLACE Anno WITH "1900"

   Return (NIL)


static PROCEDURE LookUp(cProc, nLine, cVar)
   Set KEY K_F2 TO
   if (cVar == "ATLETI->SOCIETA")
      TabSocieta(Atleti->Societa)
      REPLACE Atleti->Societa WITH SOCIETA->Codice
      keyboard chr(K_RETURN)
   endif
   Set KEY K_F2 TO LookUp
   return
