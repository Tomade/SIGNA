// Tempi.Prg

#include "inkey.ch"
#include "setcurs.ch"
#include "nt2win.ch"


FUNCTION TempiAtleti( )
   memvar timefmt, getlist
   local b, column, cType, n, wCodice
   local cColorSave, nCursSave
   local lMore, nKey, lAppend, oldcol
   local nTop, nLeft, nBottom, nRight
   local varButs :=  { ;
         { "Naviga", "<" + chr(25) + chr(24) + ">" }, ;
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
      GO TOP
      AtletiTitles()
      SetColor("GR+/R")
      @ -1, 25 SAY " AGGIORNAMENTO TEMPI "
      SetColor("N/W, gr+/rb,,,n/bg")
      wCodice = space(4)
      do while .t.
         @ 01,08 GET wCodice PICT "9999"
         SetCursor(SC_NORMAL)
         read
         if lastkey() == K_ESC
            SetCursor(SC_NONE)
            CloseAtleti()
            WClose()
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

      oldcol := SetColor("R/W")
      @ 1,23  SAY Atleti->Societa PICT "999"
      SaySocName(Atleti->Societa)

      @ 3,08  say Atleti->Cognome PICT "!" + repl("x", 24)
      @ 3,41  say Atleti->Nome PICT "!" + repl("x", 24)

      @ 5,8   say Atleti->sesso pict "!"
      @ 7,8   say Atleti->anno pict "9999"
      @ 9,9   say Atleti->Categoria pict "999"

      @ 5,40  say Atleti->T_Iscr1 PICT timefmt
      @ 6,40  say Atleti->T_Iscr2 PICT timefmt
      @ 7,40  say Atleti->T_Iscr3 PICT timefmt
      @ 8,40  say Atleti->T_Iscr4 PICT timefmt
      @ 9,40  say Atleti->T_Iscr5 PICT timefmt
      @ 10,40  say Atleti->T_Iscr6 PICT timefmt
      SetColor(oldcol)

      if (!emptytime(Atleti->T_Iscr1))
         @ 5,55 get Atleti->T_Gara1 PICT timefmt
      endif
      if (!emptytime(Atleti->T_Iscr2) )
         @ 6,55 get Atleti->T_Gara2 PICT timefmt
      endif
      if (!emptytime(Atleti->T_Iscr3) )
         @ 7,55 get Atleti->T_Gara3 PICT timefmt
      endif
      if (!emptytime(Atleti->T_Iscr4))
         @ 8,55 get Atleti->T_Gara4 PICT timefmt
      endif
      if (!emptytime(Atleti->T_Iscr5) )
         @ 9,55 get Atleti->T_Gara5 PICT timefmt
      endif
      if (!emptytime(Atleti->T_Iscr6) )
         @ 10,55 get Atleti->T_Gara6 PICT timefmt
      endif

      Set KEY K_F10 TO OK
      Set Cursor ON
      Read
      Set Cursor OFF
      Set KEY K_F2 TO
      Set KEY K_F4 TO
      Set KEY K_F10 TO
      if lastkey() == K_ESC
         exit
      endif
   enddo // ----------- main loop

   CloseAtleti()
   WClose()
   return NIL



STATIC FUNCTION AtletiTitles()
   @ 01,01 SAY "Cod.: " + Space(4)
   @ 01,14 SAY "Societ…: " + Space(30)
   @ 03,01 say "Cogn.: " + Space(25)
   @ 03,35 say "Nome: "    + Space(25)
   @ 05,01 say "Sesso:  "
   @ 07,01 say "Anno : "  + Space(4)
   @ 09,01 say "Cat. : M" + Space(3)
   /*
   @ 07,04 say [ÚÄÄ GARA ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ T. ISCRIZIONE ÄÄÄÄÄ T. IN GARA ÄÄ¿]
   @ 08,04 SAY [³ 100 Dorso                                                  ³]
   @ 09,04 SAY [³  50 Rana                                                   ³]
   @ 10,04 SAY [³ 4 x 50 Stile Libero                                        ³]
   @ 11,04 SAY [³ 4 x 50 Misti                                               ³]
   @ 12,04 SAY [ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ]
   */

   @ 04,19 say [ÚÄÄ GARA ÄÄÄÄÄÄÄÄ T. ISCRIZIONE ÄÄ T. IN GARA Ä¿]
   @ 05,19 SAY [³  50 Stile Libero                             ³]
   @ 06,19 SAY [³  50 Rana                                     ³]
   @ 07,19 SAY [³  50 Dorso                                    ³]
   @ 08,19 SAY [³  50 Farfalla                                 ³]
   @ 09,19 SAY [³ 100 Misti                                    ³]
   @ 10,19 SAY [³ 200 Stile Libero                             ³]
   @ 11,19 SAY [ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ]
return NIL





FUNCTION TempiStaffette( )
   memvar timefmt, getlist
   local b, column, cType, n, wCodice
   local cColorSave, nCursSave
   local lMore, nKey, lAppend, oldcol
   local nTop, nLeft, nBottom, nRight
   local varButs :=  { ;
         { "Naviga", "<" + chr(25) + chr(24) + ">" }, ;
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
      GO TOP
      StaffetteTitles()
      SetColor("GR+/R")
      @ -1, 25 SAY " AGGIORNAMENTO TEMPI "
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

      oldcol := SetColor("R/W")
      @ 1,23  SAY Staffette->Societa PICT "999"
      SaySocName(Staffette->Societa)

      @ 3,08  say Staffette->Nome PICT "!" + repl("x", 39)

      @ 3,64  say Staffette->sesso pict "!"
      @ 8,9   say Staffette->Categoria pict "999"

      @ 6,40  say Staffette->T_Iscr1 PICT timefmt
      @ 8,40  say Staffette->T_Iscr2 PICT timefmt
      SetColor(oldcol)

      if (!emptytime(Staffette->T_Iscr1))
         @ 6,55 get Staffette->T_Gara1 PICT timefmt
      endif
      if (!emptytime(Staffette->T_Iscr2) )
         @ 8,55 get Staffette->T_Gara2 PICT timefmt
      endif

      Set KEY K_F10 TO OK
      Set Cursor ON
      Read
      Set Cursor OFF
      Set KEY K_F2 TO
      Set KEY K_F4 TO
      Set KEY K_F10 TO
      if lastkey() == K_ESC
         exit
      endif
   enddo // ----------- main loop

   CloseStaffette()
   WClose()

   return NIL


STATIC FUNCTION StaffetteTitles()
   @ 01,01 SAY "Cod.: " + Space(4)
   @ 01,14 SAY "Societ…: " + Space(30)
   @ 03,01 say "Nome:  "    + Space(40)
   @ 03,57 say "Sesso: "  + Space(1)
   @ 08,01 say "Cat.  : " + Space(1)
   /*
   @ 07,04 say [ÚÄÄ GARA ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ T. ISCRIZIONE ÄÄÄÄÄ T. IN GARA ÄÄ¿]
   @ 08,04 SAY [³ 100 Dorso                                                  ³]
   @ 09,04 SAY [³  50 Rana                                                   ³]
   @ 10,04 SAY [³ 4 x 50 Stile Libero                                        ³]
   @ 11,04 SAY [³ 4 x 50 Misti                                               ³]
   @ 12,04 SAY [ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ]
   */

   @ 05,19 say [ÚÄÄ GARA ÄÄÄÄÄÄÄÄ T. ISCRIZIONE ÄÄ T. IN GARA Ä¿]
   @ 06,19 SAY [³ 4 X 50 SL                                    ³]
   @ 07,19 SAY [³                                              ³]
   @ 08,19 SAY [³ 4 X 50 MX                                    ³]
   @ 09,19 SAY [ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ]

return NIL


