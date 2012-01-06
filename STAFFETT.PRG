// Staffette.Prg

#include "inkey.ch"
#include "setcurs.ch"
#include "nt2win.ch"


FUNCTION StaffetteEdit( InsertMode )
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
   WOpen(5,5, 19,73)
   WBox(WB_SINGLE)

   OpenStaffette()
   do while .t.         // ------------------ main loop
      SELECT Staffette
      set order to 1
      GO TOP
      DrawTitles()
      if (InsertMode .OR. eof())
         SetColor("GR+/R")
         @ -1, 18 SAY " INSERIMENTO SCHEDA STAFFETTA "
         SetColor("N/W, gr+/rb,,,n/bg")
         ButtsRow(11, 0, 66, insButs)
         StaffettaADD()
         @ 01,08 SAY Staffette->Codice PICT "9999"
      else
         SetColor("GR+/R")
         @ -1, 19 SAY " VARIAZIONE SCHEDA STAFFETTA "
         SetColor("N/W, gr+/rb,,,n/bg")
         wCodice = space(4)
         do while .t.
            @ 01,08 GET wCodice PICT "9999"
            SetCursor(SC_NORMAL)
            read
            if lastkey() == K_ESC
               SetCursor(SC_NONE)
               CloseStaffette()
               WClose()
               return NIL
            endif
            seek wCodice
            if found()
               ButtsRow(11, 0, 66, varButs)
               exit
            else
               ERR_NotFound()
            endif
         enddo
      endif

      // Continuiamo da qui, sia se nuovo atleta, sia se in modifica dati
      @ 1,23  get Staffette->Societa PICT "999" valid SaySocName(Staffette->Societa)

      @ 3,08  get Staffette->Nome PICT "!" + repl("x", 39)

      @ 3,64  get Staffette->sesso pict "!" valid Staffette->sesso$"MF"
      @ 8,9   get Staffette->Categoria pict "!" VALID Staffette->Categoria$"ABCDE"

      @ 6,40  get Staffette->T_Iscr1 PICT timefmt
      @ 8,40  get Staffette->T_Iscr2 PICT timefmt

      Set KEY K_F2 TO LookUp
      If !InsertMode
         Set KEY K_F4 TO Cancella
      Endif
      Set KEY K_F10 TO OK
      SaySocName(Staffette->Societa)
      Set Cursor ON
      Read
      Set Cursor OFF
      Set KEY K_F2 TO
      Set KEY K_F4 TO
      Set KEY K_F10 TO
      if (Empty(Staffette->Nome))
         delete
      endif
      if (EmptyTime(Staffette->T_ISCR1) .AND. EmptyTime(Staffette->T_ISCR2))
         delete
      endif
      if lastkey() == K_ESC
         exit
      endif
   enddo // ----------- main loop

   CloseStaffette()
   WClose()
   return NIL



STATIC FUNCTION DrawTitles()
   @ 01,01 SAY "Cod.: " + Space(4)
   @ 01,14 SAY "Societ…: " + Space(30)
   @ 03,01 say "Nome:  "    + Space(40)
   @ 03,57 say "Sesso: " + Space(1)
   @ 08,01 say "Cat.  : " + Space(1)
   /*
   @ 07,04 say [ÚÄÄ GARA ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ T. ISCRIZIONE ÄÄÄÄÄ T. IN GARA ÄÄ¿]
   @ 08,04 SAY [³ 100 Dorso                                                  ³]
   @ 09,04 SAY [³  50 Rana                                                   ³]
   @ 10,04 SAY [³ 4 x 50 Stile Libero                                        ³]
   @ 11,04 SAY [³ 4 x 50 Misti                                               ³]
   @ 12,04 SAY [ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ]
   */
   @ 05,19 say [ÚÄÄ GARA ÄÄÄÄÄÄÄÄ T. ISCRIZIONE Ä¿]
   @ 06,19 SAY [³ 4 X 50 MX                      ³]
   @ 07,19 SAY [³                                ³]
   @ 08,19 SAY [³ 4 X 50 SL                      ³]
   @ 09,19 SAY [ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ]

return NIL




FUNCTION StaffettaADD()
   FIELD Codice
   local nCodice, nSocieta, nOrder

   nOrder := INDEXORD()
   SET ORDER TO 0
   go bottom
   nCodice := val(Staffette->Codice) + 1
   nSocieta := Staffette->Societa      // 'set carry on'
   set order to nOrder
   APPEND BLANK
   REPLACE Codice WITH alltrim(str(nCodice,4))
   REPLACE Societa WITH nSocieta

   Return (NIL)


static PROCEDURE LookUp(cProc, nLine, cVar)
   Set KEY K_F2 TO
   if (cVar == "STAFFETTE->SOCIETA")
      TabSocieta(Staffette->Societa)
      REPLACE Staffette->Societa WITH SOCIETA->Codice
      keyboard chr(K_RETURN)
   endif
   Set KEY K_F2 TO LookUp
   return



