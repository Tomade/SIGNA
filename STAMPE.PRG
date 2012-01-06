// Stampe.prg

#include "NT2Win.ch"
#include "inkey.ch"


#define F_REGION  1
#define F_MASCHI  2
#define F_FEMMINE 3
#define F_GARA1   4
#define F_GARA2   5
#define F_GARA3   6
#define F_GARA4   7
#define F_GARA5   8
#define F_GARA6   9
#define F_STAFF1  10
#define F_STAFF2  11

memvar   Prn2File

static OptRecs := {   {1,10, "REGIONALE" }, ;
                      {3,2,  "Maschi"    }, ;
                      {3,19, "Femmine"   }, ;
                      {5,2,  "50 SL"     }, ;
                      {5,19, "50 RA"     }, ;
                      {6,2,  "50 DO"     }, ;
                      {6,19, "50 FA"     }, ;
                      {7,2,  "100 MX"    }, ;
                      {7,19, "200 SL"    }, ;
                      {8,2,  "4 x 50 MX" }, ;
                      {8,19, "4 x 50 SL" }  ;
}
static OptVals := { .F., .F., .F., .F., .F., .F., .F., .F., .F., .F., .F.}


static r := 0
static npag := 1



FUNCTION PrintMenu()
 LOCAL MenuBox, acMenuItems[7], Choice

   SETCOLOR("R/W")
   MenuBox := WOPEN(09,26, 17,49)
   WBOX(WB_SINGLE_CLEAR)

   SetColor("B/W")
   @ -1, 0 SAY ' STAMPE '

   acMenuItems[1] = ' Programma Gara       '
   acMenuItems[2] = ' Codici Iscritti      '
   acMenuItems[3] = ' Iscritti per Societ… '
   acMenuItems[4] = ' Cartellini Iscritti  '
   acMenuItems[5] = ' Cartellini Bianchi   '
   acMenuItems[6] = ' Classifiche Atleti   '
   acMenuItems[7] = ' Classifiche Societ…  '
   Choice := 1

   DO WHILE .T.
      FootMsg( " ESC-Uscita  -Selezione  INVIO-Conferma " )

      SETCOLOR("N/W")
      Choice := ACHOICE(0,0, 7, 28, acMenuItems,,"MenuFunc", Choice)

      DO CASE

      CASE ( Choice == 1 )
         FootMsg( " Stampa Programma Gara " )
         ST_EleIscr()

      CASE ( Choice == 2 )
         FootMsg( " Stampa Codici Iscritti " )
         ST_EleCods()

      CASE ( Choice == 3 )
         FootMsg( " Iscritti per Societ… " )
         ST_EleSoc()

      CASE ( Choice == 4 )
         FootMsg( " Stampa Cartellini Iscritti ")
         ST_Cartellini()

      CASE ( Choice == 5 )
         FootMsg( " Stampa Cartellini Bianchi " )
         // if CheckPrinter()
            Cards(.T.)
         // endif

      CASE ( Choice == 6 )
         FootMsg( " Stampa Classifiche e Punteggi Atleti " )
         ST_ClassAtl()

      CASE ( Choice == 7 )
         FootMsg( " Stampa Classifiche e Punteggi Societa' " )
         ST_ClassSoc()

      OTHERWISE
         IF LastKey() == K_ESC
            EXIT
         ELSE
            Func_NA()
         ENDIF
      ENDCASE

   ENDDO
   WClose()
RETURN NIL



FUNCTION ST_EleCods()
   local mast_marg

   IF (prn2file)
      SET PRINTER TO ("EleCods.Prn")
   else
      if !CheckPrinter()
         return NIL
      endif
   ENDIF
   SET DEVICE TO PRINTER
   SET PRINTER ON
   PrintInit()

   @ 0,0 say PADC("ELENCO CODICI ISCRITTI IN ORDINE ALFABETICO",78)
   @ 1,0 say PADC("ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ",78)

   OpenAtleti()
   Set Order To 14
   go top

   r := 4
   npag := 1
   while (!eof())
      @ r, 1 say Atleti->Codice + " " + alltrim(Atleti->Cognome) + " " + alltrim(Atleti->Nome)
      ++r
      r := CheckRow(r)
      skip
   enddo
   CloseAtleti()

   r := 4
   eject
   OpenStaffette()
   Set Order To 6
   go top
   @ 0,0 say PADC("*** LISTA STAFFETTE ***",78)
   @ 1,0 say PADC("ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ",78)

   while (!eof())
      @ r, 1 say Staffette->Codice + " " + Staffette->Nome + "     CAT. : " + Staffette->Categoria
      ++r
      r := CheckRow(r)
      skip
   enddo
   CloseStaffette()


   r := 1000      // Per stampare l'ultima pagina
   CheckRow(r)
   SET DEVICE TO SCREEN
   SET PRINTER OFF
   SET PRINTER TO
return NIL



FUNCTION ST_EleIscr()
   local mast_marg
   local nAtl

   IF (prn2file)
      SET PRINTER TO ("EleIscr.Prn")
   else
      if !CheckPrinter()
         return NIL
      endif
   ENDIF

   SET DEVICE TO PRINTER
   SET PRINTER ON
   PrintInit()

   @ 0,0  say PADC("PROGRAMMA GARA",78)
   @ 1,0  say PADC("CAMPIONATO REGIONALE MASTER UISP '96",78)
   @ 2,0  say PADC([SIENA - Piscina dell' "Acquacalda" - 24 Marzo 1996],78)
   @ 3,0  say PADC("ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ",78)

   OpenAtleti()
   mast_marg := FindLongest() + 5
   npag := nAtl := 1
   r := 5


   Set Order To 7
   go top
   @ r,0 say "*** 200 STILE LIBERO - FEMMINE ***"
   r += 2
   do while (Atleti->sesso == 'F' .and. !eof())
      if !EmptyTime(Atleti->T_ISCR6)
         @ r,  0  say PADL(alltrim(str(nAtl++)),3) + " " + alltrim(Atleti->Cognome) + " " + alltrim(Atleti->Nome)
         @ r, mast_marg say " M." + Atleti->Categoria + " " + subs(Atleti->Anno, 3,2) + " ";
            + SOC_GetName(Atleti->Societa) + " " + Atleti->T_ISCR6
         ++r
         r := CheckRow(r)
      endif
      skip
   enddo

   r += 3
   r := CheckRow(r)
   nAtl := 1

   @ r,0 say "*** 200 STILE LIBERO - MASCHI ***"
   r += 2
   do while (Atleti->sesso == 'M' .and. !eof())
      if !EmptyTime(Atleti->T_ISCR6)
         @ r,  0  say PADL(alltrim(str(nAtl++)),3) + " " + alltrim(Atleti->Cognome) + " " + alltrim(Atleti->Nome)
         @ r, mast_marg say " M." + Atleti->Categoria + " " + subs(Atleti->Anno, 3,2) + " ";
            + SOC_GetName(Atleti->Societa) + " " + Atleti->T_ISCR6
         ++r
         r := CheckRow(r)
      endif
      skip
   enddo

   r += 3
   r := CheckRow(r)
   nAtl := 1

   Set Order To 5
   go top
   @ r,0 say "*** 50 FARFALLA - FEMMINE ***"
   r += 2
   do while (Atleti->sesso == 'F' .and. !eof())
      if !EmptyTime(Atleti->T_ISCR4)
         @ r, 0 say PADL(alltrim(str(nAtl++)),3) + " " + alltrim(Atleti->Cognome) + " " + alltrim(Atleti->Nome)
         @ r, mast_marg say " M." + Atleti->Categoria + " " + subs(Atleti->Anno, 3,2) + " ";
            + SOC_GetName(Atleti->Societa) + " " + Atleti->T_ISCR4
         ++r
         r := CheckRow(r)
      endif
      skip
   enddo

   r += 3
   r := CheckRow(r)
   nAtl := 1

   @ r,0 say "*** 50 FARFALLA - MASCHI ***"
   r += 2
   do while (Atleti->sesso == 'M' .and. !eof())
      if !EmptyTime(Atleti->T_ISCR4)
         @ r,  0  say PADL(alltrim(str(nAtl++)),3) + " " + alltrim(Atleti->Cognome) + " " + alltrim(Atleti->Nome)
         @ r, mast_marg say " M." + Atleti->Categoria + " " + subs(Atleti->Anno, 3,2) + " ";
            + SOC_GetName(Atleti->Societa) + " " + Atleti->T_ISCR4
         ++r
         r := CheckRow(r)
      endif
      skip
   enddo

   r += 3
   r := CheckRow(r)
   nAtl := 1

   Set Order To 4
   go top
   @ r,0 say "*** 50 DORSO - FEMMINE ***"
   r += 2
   do while (Atleti->sesso == 'F' .and. !eof())
      if !EmptyTime(Atleti->T_ISCR3)
         @ r,  0  say PADL(alltrim(str(nAtl++)),3) + " " + alltrim(Atleti->Cognome) + " " + alltrim(Atleti->Nome)
         @ r, mast_marg say " M." + Atleti->Categoria + " " + subs(Atleti->Anno, 3,2) + " ";
            + SOC_GetName(Atleti->Societa) + " " + Atleti->T_ISCR3
         ++r
         r := CheckRow(r)
      endif
      skip
   enddo

   r += 3
   r := CheckRow(r)
   nAtl := 1

   @ r,0 say "*** 50 DORSO - MASCHI ***"
   r += 2
   do while (Atleti->sesso == 'M' .and. !eof())
      if !EmptyTime(Atleti->T_ISCR3)
         @ r,  0  say PADL(alltrim(str(nAtl++)),3) + " " + alltrim(Atleti->Cognome) + " " + alltrim(Atleti->Nome)
         @ r, mast_marg say " M." + Atleti->Categoria + " " + subs(Atleti->Anno, 3,2) + " ";
            + SOC_GetName(Atleti->Societa) + " " + Atleti->T_ISCR3
         ++r
         r := CheckRow(r)
      endif
      skip
   enddo

   r += 3
   r := CheckRow(r)
   nAtl := 1

   Set Order To 2
   go top

   @ r,0 say "*** 50 STILE LIBERO - FEMMINE ***"
   r += 2
   do while (Atleti->sesso == 'F' .and. !eof())
      if !EmptyTime(Atleti->T_ISCR1)
         @ r, 0 say PADL(alltrim(str(nAtl++)),3) + " " + alltrim(Atleti->Cognome) + " " + alltrim(Atleti->Nome)
         @ r, mast_marg say " M." + Atleti->Categoria + " " + subs(Atleti->Anno, 3,2) + " ";
            + SOC_GetName(Atleti->Societa) + " " + Atleti->T_ISCR1
         ++r
         r := CheckRow(r)
      endif
      skip
   enddo

   r += 3
   r := CheckRow(r)
   nAtl := 1

   @ r,0 say "*** 50 STILE LIBERO - MASCHI ***"
   r += 2
   do while (Atleti->sesso == 'M' .and. !eof())
      if !EmptyTime(Atleti->T_ISCR1)
         @ r,  0  say PADL(alltrim(str(nAtl++)),3) + " " + alltrim(Atleti->Cognome) + " " + alltrim(Atleti->Nome)
         @ r, mast_marg say " M." + Atleti->Categoria + " " + subs(Atleti->Anno, 3,2) + " ";
            + SOC_GetName(Atleti->Societa) + " " + Atleti->T_ISCR1
         ++r
         r := CheckRow(r)
      endif
      skip
   enddo

   r += 3
   r := CheckRow(r)
   nAtl := 1

   Set Order To 6
   go top
   @ r,0 say "*** 100 MISTI - FEMMINE ***"
   r += 2
   do while (Atleti->sesso == 'F' .and. !eof())
      if !EmptyTime(Atleti->T_ISCR5)
         @ r,  0  say PADL(alltrim(str(nAtl++)),3) + " " + alltrim(Atleti->Cognome) + " " + alltrim(Atleti->Nome)
         @ r, mast_marg say " M." + Atleti->Categoria + " " + subs(Atleti->Anno, 3,2) + " ";
            + SOC_GetName(Atleti->Societa) + " " + Atleti->T_ISCR5
         ++r
         r := CheckRow(r)
      endif
      skip
   enddo

   r += 3
   r := CheckRow(r)
   nAtl := 1

   @ r,0 say "*** 100 MISTI - MASCHI ***"
   r += 2
   do while (Atleti->sesso == 'M' .and. !eof())
      if !EmptyTime(Atleti->T_ISCR5)
         @ r,  0  say PADL(alltrim(str(nAtl++)),3) + " " + alltrim(Atleti->Cognome) + " " + alltrim(Atleti->Nome)
         @ r, mast_marg say " M." + Atleti->Categoria + " " + subs(Atleti->Anno, 3,2) + " ";
            + SOC_GetName(Atleti->Societa) + " " + Atleti->T_ISCR5
         ++r
         r := CheckRow(r)
      endif
      skip
   enddo

   r += 3
   r := CheckRow(r)
   nAtl := 1

   Set Order To 3
   go top
   @ r,0 say "*** 50 RANA - FEMMINE ***"
   r += 2
   do while (Atleti->sesso == 'F' .and. !eof())
      if !EmptyTime(Atleti->T_ISCR2)
         @ r,  0  say PADL(alltrim(str(nAtl++)),3) + " " + alltrim(Atleti->Cognome) + " " + alltrim(Atleti->Nome)
         @ r, mast_marg say " M." + Atleti->Categoria + " " + subs(Atleti->Anno, 3,2) + " ";
            + SOC_GetName(Atleti->Societa) + " " + Atleti->T_ISCR2
         ++r
         r := CheckRow(r)
      endif
      skip
   enddo

   r += 3
   r := CheckRow(r)
   nAtl := 1

   @ r,0 say "*** 50 RANA - MASCHI ***"
   r += 2
   do while (Atleti->sesso == 'M' .and. !eof())
      if !EmptyTime(Atleti->T_ISCR2)
         @ r,  0  say PADL(alltrim(str(nAtl++)),3) + " " + alltrim(Atleti->Cognome) + " " + alltrim(Atleti->Nome)
         @ r, mast_marg say " M." + Atleti->Categoria + " " + subs(Atleti->Anno, 3,2) + " ";
            + SOC_GetName(Atleti->Societa) + " " + Atleti->T_ISCR2
         ++r
         r := CheckRow(r)
      endif
      skip
   enddo


   CloseAtleti()

   /*
   r += 3
   r := CheckRow(r)
   OpenStaffette()
   SET ORDER TO 2
   go top
   @ r,0 say "*** STAFFETTA 4 X 50 STILE LIBERO FEMMINILE ***"
   r += 2
   do while (Staffette->sesso == 'F' .and. !eof())
      if !EmptyTime(Staffette->T_ISCR1)
         @ r,  2  say "CAT. " + Staffette->Categoria + SPACE(5) + Staffette->Nome + SPACE(13) + Staffette->T_ISCR1
         ++r
         r := CheckRow(r)
      endif
      skip
   enddo

   r += 3
   r := CheckRow(r)
   @ r,0 say "*** STAFFETTA 4 X 50 STILE LIBERO MASCHILE ***"
   r += 2
   do while (Staffette->sesso == 'M' .and. !eof())
      if !EmptyTime(Staffette->T_ISCR1)
         @ r,  2  say "CAT. " + Staffette->Categoria + SPACE(5) + Staffette->Nome + SPACE(13) + Staffette->T_ISCR1
         ++r
         r := CheckRow(r)
      endif
      skip
   enddo

   Set Order To 3
   go top

   r += 3
   r := CheckRow(r)
   @ r,0 say "*** STAFFETTA 4 X 50 MISTA FEMMINILE ***"
   r += 2
   do while (Staffette->sesso == 'F' .and. !eof())
      if !EmptyTime(Staffette->T_ISCR2)
         @ r,  2  say "CAT. " + Staffette->Categoria + SPACE(5) + Staffette->Nome + SPACE(13) + Staffette->T_ISCR2
         ++r
         r := CheckRow(r)
      endif
      skip
   enddo

   r += 3
   r := CheckRow(r)
   @ r,0 say "*** STAFFETTA 4 X 50 MISTA MASCHILE ***"
   r += 2
   do while (Staffette->sesso == 'M' .and. !eof())
      if !EmptyTime(Staffette->T_ISCR2)
         @ r,  2  say "CAT. " + Staffette->Categoria + SPACE(5) + Staffette->Nome + SPACE(13) + Staffette->T_ISCR2
         ++r
         r := CheckRow(r)
      endif
      skip
   enddo
   CloseStaffette()
   */

   r := 1000      // Per stampare l'ultima pagina
   CheckRow(r)
   SET DEVICE TO SCREEN
   SET PRINTER OFF
   SET PRINTER TO
   RETURN Nil



FUNCTION CalcScores( _src, _dst )
   local categ, scateg, punti, last_punti, last_time, parity

   go top
   FOR categ := 20 to 75 step 5
      scateg := str(categ,2)
      if (alltrim(Atleti->Categoria) != scateg)
         loop
      endif
      last_time := "99" + "'" + "99" + '"' + "99"
      punti := last_punti := 10
      parity := .F.
      do while (!eof() .and. alltrim(Atleti->Categoria) == scateg)
         if (EmptyTime(&_src))
            if (!empty(&_dst))
               replace &_dst with " "
            endif
            skip
            loop
         endif

         if (&_src == "99" + "'" + "99" + '"' + "99")    // squalifica
            replace &_dst with "0"
            skip
            loop
         endif

         if (&_src == last_time)
            replace &_dst with str(last_punti,1)
            parity := .T.
         else
            if punti > 1
               --punti
               if punti == 8
                  punti := 7
               endif
            endif
            if punti > 1 .AND. parity
               --punti
            endif
            parity := .F.
            replace &_dst with str(punti,1)
            last_time  := &_src
            last_punti := punti
         endif
         skip
      enddo
   NEXT
   return NIL


FUNCTION PrintScores( title, _tempo, _punti )
   local mast_marg, categ, scateg, r, rank

   IF (prn2file)
      SET PRINTER TO ("ClassAtl.Prn") additive
   else
      if !CheckPrinter()
         return NIL
      endif
   ENDIF
   SET DEVICE TO PRINTER
   SET PRINTER ON
   PrintInit()

   mast_marg := FindLongest() + 5
   go top
   @ 0,0 say title
   @ 1,0 say PADC("ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ",78)
   r := 4
   FOR categ := 20 to 75 step 5
      scateg := str(categ,2)
      if (alltrim(Atleti->Categoria) != scateg)
         loop
      endif
      @ r,0 say PADC("CATEGORIA: M." + scateg, 78)
      npag := 1
      rank := 1
      ++r
      do while (!eof() .and. alltrim(Atleti->Categoria) == scateg)
         ++r
         r := CheckRow(r)
         @ r,  0 say padl(alltrim(str(rank++)),3) + " " + alltrim(Atleti->Cognome) + " " + alltrim(Atleti->Nome)
         if (&_punti != "0")
            @ r, mast_marg say " " + subs(Atleti->Anno, 3,2) + " ";
               + SOC_GetName(Atleti->Societa) + " " + &_tempo + space(4) + &_punti
         else
            @ r, mast_marg say " " + subs(Atleti->Anno, 3,2) + " ";
               + SOC_GetName(Atleti->Societa) + " " + if(Atleti->sesso == 'M', "SQUALIFICATO", "SQUALIFICATA")
         endif
         skip
      enddo
      r += 3
      r := CheckRow(r)
   NEXT
   eject
   SET DEVICE TO SCREEN
   SET PRINTER OFF
   SET PRINTER TO
   return NIL

FUNCTION CalcStaffs( _src, _dst )
   local categ, scateg, punti, last_punti, last_time, parity

   go top

   FOR categ := 0 to 5
      scateg := chr(categ + asc("A"))
      if (alltrim(Staffette->Categoria) != scateg)
         loop
      endif
      last_time := "99" + "'" + "99" + '"' + "99"
      punti := last_punti := 20
      parity := .F.
      do while (!eof() .and. alltrim(Staffette->Categoria) == scateg)
         if (EmptyTime(&_src))
            if (!empty(&_dst))
               replace &_dst with "  "
            endif
            skip
            loop
         endif
         if (&_src == "99" + "'" + "99" + '"' + "99")    // squalifica
            replace &_dst with "00"
            skip
            loop
         endif
         if (&_src == last_time)
            replace &_dst with str(last_punti,2)
            parity := .T.
         else
            if punti > 2
               punti := punti - 2
               if punti == 16
                  punti := 14
               endif
            endif
            if punti > 2 .AND. parity
               --punti
            endif
            parity := .F.
            replace &_dst with str(punti,2)
            last_time  := &_src
            last_punti := punti
         endif
         skip
      enddo
   NEXT
   RETURN NIL


FUNCTION PrintStaffs( title, _tempo, _punti )
   local mast_marg, categ, scateg, r, rank

   IF (prn2file)
      SET PRINTER TO ("ClassAtl.Prn") additive
   else
      if !CheckPrinter()
         return NIL
      endif
   ENDIF

   SET DEVICE TO PRINTER
   SET PRINTER ON
   PrintInit()

   go top
   @ 0,0 say title
   @ 1,0 say PADC("ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ",78)
   r := 4
   FOR categ := 0 to 5
      scateg := chr(categ + asc("A"))
      if (alltrim(Staffette->Categoria) != scateg)
         loop
      endif
      @ r,0 say PADC("CATEGORIA: " + scateg, 78)
      npag := 1
      rank := 1
      ++r
      do while (!eof() .and. alltrim(Staffette->Categoria) == scateg)
         ++r
         r := CheckRow(r)
         if (&_punti != "00")
            @ r,  1  say Staffette->Nome + " " + &_tempo + space(4) + &_punti
         else
            @ r,  1  say Staffette->Nome + " " + "SQUALIFICATA"
         endif
         skip
      enddo
      r += 3
      r := CheckRow(r)
   NEXT
   eject
   SET DEVICE TO SCREEN
   SET PRINTER OFF
   SET PRINTER TO
   return NIL



FUNCTION ST_ClassAtl()
   local mast_marg, title
   local categ, scateg, punti, last_punti, last_time, parity


   if OptBox(09,10,21,46, "GR+/BG", "N/BG", " Selezione Stampa ", OptRecs, OptVals) == .F.
      return NIL
   endif

   IF (prn2file)
      SET PRINTER TO ("ClassAtl.Prn") additive
   else
      if !CheckPrinter()
         return NIL
      endif
   ENDIF


   // Stampa classifica 50 STILE femmine - tutte le categorie
   OpenAtleti()

   IF OptVals[F_GARA1]
      Set Order To 8

      IF OptVals[F_FEMMINE]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 50 STILE LIBERO - FEMMINE   (REGIONALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_GARA1)) ;
            .and. SOC_IsRegional(Atleti->Societa)
            DispMsg("Calcolo classifica 50 SL femminile (REGIONALE)...")
         ELSE
            title := PADC("*** CLASSIFICA 50 STILE LIBERO - FEMMINE ***",78)
            SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_GARA1))
            DispMsg("Calcolo classifica 50 SL femminile (GENERALE)...")
         ENDIF
         CalcScores( "Atleti->T_GARA1", "Atleti->P_GARA1")
         WClose()
         IF OptVals[F_REGION]
            DispMsg("Stampa classifica 50 SL femminile (REGIONALE)...")
         ELSE
            DispMsg("Stampa classifica 50 SL femminile (GENERALE)...")
         ENDIF
         PrintScores(title, "Atleti->T_GARA1", "Atleti->P_GARA1")
         WClose()
      ENDIF

      IF OptVals[F_MASCHI]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 50 STILE LIBERO - MASCHI   (REGIONALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_GARA1)) ;
            .and. SOC_IsRegional(Atleti->Societa)
            DispMsg("Calcolo classifica 50 SL maschile (REGIONALE)...")
         ELSE
            title := PADC("*** CLASSIFICA 50 STILE LIBERO - MASCHI ***",78)
            SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_GARA1))
            DispMsg("Calcolo classifica 50 SL maschile (GENERALE)...")
         ENDIF
         CalcScores( "Atleti->T_GARA1", "Atleti->P_GARA1")
         WClose()
         IF OptVals[F_REGION]
            DispMsg("Stampa classifica 50 SL maschile (REGIONALE)...")
         ELSE
            DispMsg("Stampa classifica 50 SL maschile (GENERALE)...")
         ENDIF
         PrintScores(title, "Atleti->T_GARA1", "Atleti->P_GARA1")
         WClose()
      ENDIF
   ENDIF


   IF OptVals[F_GARA2]
      Set Order To 9

      IF OptVals[F_FEMMINE]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 50 RANA - FEMMINE   (REGIONALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_GARA2)) ;
            .and. SOC_IsRegional(Atleti->Societa)
            DispMsg("Calcolo classifica 50 Rana femminile (REGIONALE)...")
         ELSE
            title := PADC("*** CLASSIFICA 50 RANA - FEMMINE ***",78)
            SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_GARA2))
            DispMsg("Calcolo classifica 50 Rana femminile (GENERALE)...")
         ENDIF
         CalcScores( "Atleti->T_GARA2", "Atleti->P_GARA2")
         WClose()
         IF OptVals[F_REGION]
            DispMsg("Stampa classifica 50 Rana femminile (REGIONALE)...")
         ELSE
            DispMsg("Stampa classifica 50 Rana femminile (GENERALE)...")
         ENDIF
         PrintScores(title, "Atleti->T_GARA2", "Atleti->P_GARA2")
         WClose()
      ENDIF

      IF OptVals[F_MASCHI]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 50 RANA - MASCHI   (REGIONALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_GARA2)) ;
            .and. SOC_IsRegional(Atleti->Societa)
            DispMsg("Calcolo classifica 50 Delfino maschile (REGIONALE)...")
         ELSE
            title := PADC("*** CLASSIFICA 50 RANA - MASCHI ***",78)
            SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_GARA2))
            DispMsg("Calcolo classifica 50 Rana maschile (GENERALE)...")
         ENDIF
         CalcScores( "Atleti->T_GARA2", "Atleti->P_GARA2")
         WClose()
         IF OptVals[F_REGION]
            DispMsg("Stampa classifica 50 Rana maschile (REGIONALE)...")
         ELSE
            DispMsg("Stampa classifica 50 Rana maschile (GENERALE)...")
         ENDIF
         PrintScores(title, "Atleti->T_GARA2", "Atleti->P_GARA2")
         WClose()
      ENDIF
   ENDIF

   IF OptVals[F_GARA3]
      Set Order To 10

      IF OptVals[F_FEMMINE]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 50 DORSO - FEMMINE   (REGIONALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_GARA3)) ;
            .and. SOC_IsRegional(Atleti->Societa)
            DispMsg("Calcolo classifica 50 Dorso femminile (REGIONALE)...")
         ELSE
            title := PADC("*** CLASSIFICA 50 DORSO - FEMMINE ***",78)
            SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_GARA3))
            DispMsg("Calcolo classifica 50 Dorso femminile (GENERALE)...")
         ENDIF
         CalcScores( "Atleti->T_GARA3", "Atleti->P_GARA3")
         Wclose()
         IF OptVals[F_REGION]
            DispMsg("Stampa classifica 50 Dorso femminile (REGIONALE)...")
         ELSE
            DispMsg("Stampa classifica 50 Dorso femminile (GENERALE)...")
         ENDIF
         PrintScores(title, "Atleti->T_GARA3", "Atleti->P_GARA3")
         WClose()
      ENDIF

      IF OptVals[F_MASCHI]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 50 DORSO - MASCHI   (REGIONALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_GARA3)) ;
            .and. SOC_IsRegional(Atleti->Societa)
            DispMsg("Calcolo classifica 50 Dorso maschile (REGIONALE)...")
         ELSE
            title := PADC("*** CLASSIFICA 50 DORSO - MASCHI ***",78)
            SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_GARA3))
            DispMsg("Calcolo classifica 50 Dorso maschile (GENERALE)...")
         ENDIF
         CalcScores( "Atleti->T_GARA3", "Atleti->P_GARA3")
         WClose()
         IF OptVals[F_REGION]
            DispMsg("Stampa classifica 50 Dorso maschile (REGIONALE)...")
         ELSE
            DispMsg("Stampa classifica 50 Dorso maschile (GENERALE)...")
         ENDIF
         PrintScores(title, "Atleti->T_GARA3", "Atleti->P_GARA3")
         WClose()
      ENDIF
   ENDIF


   IF OptVals[F_GARA4]
      Set Order To 11

      IF OptVals[F_FEMMINE]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 50 FARFALLA  - FEMMINE   (REGIONALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_GARA4)) ;
            .and. SOC_IsRegional(Atleti->Societa)
            DispMsg("Calcolo classifica 50 FA femminile (REGIONALE)...")
         ELSE
            title := PADC("*** CLASSIFICA 50 FARFALLA - FEMMINE ***",78)
            SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_GARA4))
            DispMsg("Calcolo classifica 50 FA femminile (GENERALE)...")
         ENDIF
         CalcScores( "Atleti->T_GARA4", "Atleti->P_GARA4")
         WClose()
         IF OptVals[F_REGION]
            DispMsg("Stampa classifica 50 FA femminile (REGIONALE)...")
         ELSE
            DispMsg("Stampa classifica 50 FA femminile (GENERALE)...")
         ENDIF
         PrintScores(title, "Atleti->T_GARA4", "Atleti->P_GARA4")
         WClose()
      ENDIF

      IF OptVals[F_MASCHI]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 50 FARFALLA  - MASCHI   (REGIONALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_GARA4)) ;
            .and. SOC_IsRegional(Atleti->Societa)
            DispMsg("Calcolo classifica 50 FA maschile (REGIONALE)...")
         ELSE
            title := PADC("*** CLASSIFICA 50 FARFALLA - MASCHI ***",78)
            SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_GARA4))
            DispMsg("Calcolo classifica 50 FA maschile (GENERALE)...")
         ENDIF
         CalcScores( "Atleti->T_GARA4", "Atleti->P_GARA4")
         WClose()
         IF OptVals[F_REGION]
            DispMsg("Stampa classifica 50 FA maschile (REGIONALE)...")
         ELSE
            DispMsg("Stampa classifica 50 FA maschile (GENERALE)...")
         ENDIF
         PrintScores(title, "Atleti->T_GARA4", "Atleti->P_GARA4")
         WClose()
      ENDIF
   ENDIF


   IF OptVals[F_GARA5]
      Set Order To 12

      IF OptVals[F_FEMMINE]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 100 MISTI - FEMMINE   (REGIONALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_GARA5)) ;
            .and. SOC_IsRegional(Atleti->Societa)
            DispMsg("Calcolo classifica 100 Misti femminile (REGIONALE)...")
         ELSE
            title := PADC("*** CLASSIFICA 100 MISTI - FEMMINE ***",78)
            SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_GARA5))
            DispMsg("Calcolo classifica 100 Misti femminile (GENERALE)...")
         ENDIF
         CalcScores( "Atleti->T_GARA5", "Atleti->P_GARA5")
         WClose()
         IF OptVals[F_REGION]
            DispMsg("Stampa classifica 100 Misti femminile (REGIONALE)...")
         ELSE
            DispMsg("Stampa classifica 100 Misti femminile (GENERALE)...")
         ENDIF
         PrintScores(title, "Atleti->T_GARA5", "Atleti->P_GARA5")
         WClose()
      ENDIF

      IF OptVals[F_MASCHI]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 100 MISTI - MASCHI   (REGIONALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_GARA5)) ;
            .and. SOC_IsRegional(Atleti->Societa)
            DispMsg("Calcolo classifica 100 Misti maschile (REGIONALE)...")
         ELSE
            title := PADC("*** CLASSIFICA 100 MISTI - MASCHI ***",78)
            SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_GARA5))
            DispMsg("Calcolo classifica 100 Misti maschile (GENERALE)...")
         ENDIF
         CalcScores( "Atleti->T_GARA5", "Atleti->P_GARA5")
         WClose()
         IF OptVals[F_REGION]
            DispMsg("Stampa classifica 100 Misti maschile (REGIONALE)...")
         ELSE
            DispMsg("Stampa classifica 100 Misti maschile (GENERALE)...")
         ENDIF
         PrintScores(title, "Atleti->T_GARA5", "Atleti->P_GARA5")
         WClose()
      ENDIF
   ENDIF

   IF OptVals[F_GARA6]
      Set Order To 13

      IF OptVals[F_FEMMINE]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 200 STILE LIBERO - FEMMINE   (REGIONALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_GARA6)) ;
            .and. SOC_IsRegional(Atleti->Societa)
            DispMsg("Calcolo classifica 200 Stile Libero femminile (REGIONALE)...")
         ELSE
            title := PADC("*** CLASSIFICA 200 STILE LIBERO - FEMMINE ***",78)
            SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_GARA6))
            DispMsg("Calcolo classifica 200 Stile Libero femminile (GENERALE)...")
         ENDIF
         CalcScores( "Atleti->T_GARA6", "Atleti->P_GARA6")
         Wclose()
         IF OptVals[F_REGION]
            DispMsg("Stampa classifica 200 Stile Libero femminile (REGIONALE)...")
         ELSE
            DispMsg("Stampa classifica 200 Stile Libero femminile (GENERALE)...")
         ENDIF
         PrintScores(title, "Atleti->T_GARA6", "Atleti->P_GARA6")
         WClose()
      ENDIF

      IF OptVals[F_MASCHI]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 200 STILE LIBERO - MASCHI   (REGIONALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_GARA6)) ;
            .and. SOC_IsRegional(Atleti->Societa)
            DispMsg("Calcolo classifica 200 Stile Libero maschile (REGIONALE)...")
         ELSE
            title := PADC("*** CLASSIFICA 200 STILE LIBERO - MASCHI ***",78)
            SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_GARA6))
            DispMsg("Calcolo classifica 200 Stile Libero maschile (GENERALE)...")
         ENDIF
         CalcScores( "Atleti->T_GARA6", "Atleti->P_GARA6")
         WClose()
         IF OptVals[F_REGION]
            DispMsg("Stampa classifica 200 Stile Libero maschile (REGIONALE)...")
         ELSE
            DispMsg("Stampa classifica 200 Stile Libero maschile (GENERALE)...")
         ENDIF
         PrintScores(title, "Atleti->T_GARA6", "Atleti->P_GARA6")
         WClose()
      ENDIF
   ENDIF


   CloseAtleti()

   // ------------------- CLASSIFICHE STAFFETTE
   OpenStaffette()
   IF OptVals[F_STAFF1]
      Set Order To 4
      IF OptVals[F_FEMMINE]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 4x50 MX - FEMMINE   (REGIONALE) ***",78)
            SET FILTER to (Staffette->Sesso == 'F' .and. !EmptyTime(Staffette->T_GARA1)) ;
            .and. SOC_IsRegional(Staffette->Societa)
            DispMsg("Calcolo classifica 4x50 MX femminile (REGIONALE)...")
         ELSE
            title := PADC("*** CLASSIFICA 4x50 MX - FEMMINE ***",78)
            SET FILTER to (Staffette->Sesso == 'F' .and. !EmptyTime(Staffette->T_GARA1))
            DispMsg("Calcolo classifica 4x50 MX femminile (GENERALE)...")
         ENDIF
         CalcStaffs( "Staffette->T_GARA1", "Staffette->P_GARA1")
         WClose()
         IF OptVals[F_REGION]
            DispMsg("Stampa classifica 4x50 MX femminile (REGIONALE)...")
         ELSE
            DispMsg("Stampa classifica 4x50 MX femminile (GENERALE)...")
         ENDIF
         PrintStaffs(title, "Staffette->T_GARA1", "Staffette->P_GARA1")
         WClose()
      ENDIF
      IF OptVals[F_MASCHI]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 4x50 MX - MASCHI   (REGIONALE) ***",78)
            SET FILTER to (Staffette->Sesso == 'M' .and. !EmptyTime(Staffette->T_GARA1)) ;
            .and. SOC_IsRegional(Staffette->Societa)
            DispMsg("Calcolo classifica 4x50 MX maschile (REGIONALE)...")
         ELSE
            title := PADC("*** CLASSIFICA 4x50 MX - MASCHI ***",78)
            SET FILTER to (Staffette->Sesso == 'M' .and. !EmptyTime(Staffette->T_GARA1))
            DispMsg("Calcolo classifica 4x50 MX maschile (GENERALE)...")
         ENDIF
         CalcStaffs( "Staffette->T_GARA1", "Staffette->P_GARA1")
         WClose()
         IF OptVals[F_REGION]
            DispMsg("Stampa classifica 4x50 MX maschile (REGIONALE)...")
         ELSE
            DispMsg("Stampa classifica 4x50 MX maschile (GENERALE)...")
         ENDIF
         PrintStaffs(title, "Staffette->T_GARA1", "Staffette->P_GARA1")
         WClose()
      ENDIF
   ENDIF

   IF OptVals[F_STAFF2]
      Set Order To 5
      IF OptVals[F_FEMMINE]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 4x50 SL - FEMMINE   (REGIONALE) ***",78)
            SET FILTER to (Staffette->Sesso == 'F' .and. !EmptyTime(Staffette->T_GARA2)) ;
            .and. SOC_IsRegional(Staffette->Societa)
            DispMsg("Calcolo classifica 4x50 SL femminile (REGIONALE)...")
         ELSE
            title := PADC("*** CLASSIFICA 4x50 SL - FEMMINE ***",78)
            SET FILTER to (Staffette->Sesso == 'F' .and. !EmptyTime(Staffette->T_GARA2))
            DispMsg("Calcolo classifica 4x50 SL femminile (GENERALE)...")
         ENDIF
         CalcStaffs( "Staffette->T_GARA2", "Staffette->P_GARA2")
         WClose()
         IF OptVals[F_REGION]
            DispMsg("Stampa classifica 4x50 SL femminile (REGIONALE)...")
         ELSE
            DispMsg("Stampa classifica 4x50 SL femminile (GENERALE)...")
         ENDIF
         PrintStaffs(title, "Staffette->T_GARA2", "Staffette->P_GARA2")
         WClose()
      ENDIF
      IF OptVals[F_MASCHI]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 4x50 SL - MASCHI   (REGIONALE) ***",78)
            SET FILTER to (Staffette->Sesso == 'M' .and. !EmptyTime(Staffette->T_GARA2)) ;
            .and. SOC_IsRegional(Staffette->Societa)
            DispMsg("Calcolo classifica 4x50 SL maschile (REGIONALE)...")
         ELSE
            title := PADC("*** CLASSIFICA 4x50 SL - MASCHI ***",78)
            SET FILTER to (Staffette->Sesso == 'M' .and. !EmptyTime(Staffette->T_GARA2))
            DispMsg("Calcolo classifica 4x50 SL maschile (GENERALE)...")
         ENDIF
         CalcStaffs( "Staffette->T_GARA2", "Staffette->P_GARA2")
         WClose()
         IF OptVals[F_REGION]
            DispMsg("Stampa classifica 4x50 SL maschile (REGIONALE)...")
         ELSE
            DispMsg("Stampa classifica 4x50 SL maschile (GENERALE)...")
         ENDIF
         PrintStaffs(title, "Staffette->T_GARA2", "Staffette->P_GARA2")
         WClose()
      ENDIF
   ENDIF
   CloseStaffette()
   RETURN Nil



FUNCTION ST_ClassSoc()

   IF (prn2file)
      SET PRINTER TO ("Classsoc.Prn")
   else
      if !CheckPrinter()
         return NIL
      endif
   ENDIF

   DispMsg("Azzeramento punteggi societa'...")
   SOC_FlushPunti()
   WClose()

   OpenAtleti()

   DispMsg("Ricalcolo classifiche 50 Stile LIbero (GENERALE)...")
   Set Order To 8
   SET FILTER to Atleti->Sesso == 'F'
   CalcScores( "Atleti->T_GARA1", "Atleti->P_GARA1")
   SET FILTER to Atleti->Sesso == 'M'
   CalcScores( "Atleti->T_GARA1", "Atleti->P_GARA1")
   WClose()

   DispMsg("Ricalcolo classifiche 50 Rana (GENERALE)...")
   Set Order To 9
   SET FILTER to Atleti->Sesso == 'F'
   CalcScores( "Atleti->T_GARA2", "Atleti->P_GARA2")
   SET FILTER to Atleti->Sesso == 'M'
   CalcScores( "Atleti->T_GARA2", "Atleti->P_GARA2")
   WClose()

   DispMsg("Ricalcolo classifiche 50 Dorso (GENERALE)...")
   Set Order To 10
   SET FILTER to Atleti->Sesso == 'F'
   CalcScores( "Atleti->T_GARA3", "Atleti->P_GARA3")
   SET FILTER to Atleti->Sesso == 'M'
   CalcScores( "Atleti->T_GARA3", "Atleti->P_GARA3")
   WClose()

   DispMsg("Ricalcolo classifiche 50 Farfalla (GENERALE)...")
   Set Order To 11
   SET FILTER to Atleti->Sesso == 'F'
   CalcScores( "Atleti->T_GARA4", "Atleti->P_GARA4")
   SET FILTER to Atleti->Sesso == 'M'
   CalcScores( "Atleti->T_GARA4", "Atleti->P_GARA4")
   WClose()

   DispMsg("Ricalcolo classifiche 100 Misti (GENERALE)...")
   Set Order To 12
   SET FILTER to Atleti->Sesso == 'F'
   CalcScores( "Atleti->T_GARA5", "Atleti->P_GARA5")
   SET FILTER to Atleti->Sesso == 'M'
   CalcScores( "Atleti->T_GARA5", "Atleti->P_GARA5")
   WClose()

   DispMsg("Ricalcolo classifiche 200 Stile Libero (GENERALE)...")
   Set Order To 13
   SET FILTER to Atleti->Sesso == 'F'
   CalcScores( "Atleti->T_GARA6", "Atleti->P_GARA6")
   SET FILTER to Atleti->Sesso == 'M'
   CalcScores( "Atleti->T_GARA6", "Atleti->P_GARA6")
   WClose()

   DispMsg("Totalizzazione punti gare individuali (GENERALE)...")
   Set Order to 0
   Set Filter to
   go top
   while (!eof())
      SOC_AddPunti(Atleti->Societa, val(Atleti->P_GARA1))
      SOC_AddPunti(Atleti->Societa, val(Atleti->P_GARA2))
      SOC_AddPunti(Atleti->Societa, val(Atleti->P_GARA3))
      SOC_AddPunti(Atleti->Societa, val(Atleti->P_GARA4))
      SOC_AddPunti(Atleti->Societa, val(Atleti->P_GARA5))
      SOC_AddPunti(Atleti->Societa, val(Atleti->P_GARA6))
      skip
   enddo
   CloseAtleti()
   WClose()



   DispMsg("Ricalcolo classifiche staffette (GENERALE)...")
   OpenStaffette()
   Set Order To 4
   SET FILTER to Staffette->Sesso == 'F'
   CalcStaffs( "Staffette->T_GARA1", "Staffette->P_GARA1")
   SET FILTER to Staffette->Sesso == 'M'
   CalcStaffs( "Staffette->T_GARA1", "Staffette->P_GARA1")

   Set Order To 5
   SET FILTER to Staffette->Sesso == 'F'
   CalcStaffs( "Staffette->T_GARA2", "Staffette->P_GARA2")
   SET FILTER to Staffette->Sesso == 'M'
   CalcStaffs( "Staffette->T_GARA2", "Staffette->P_GARA2")
   WClose()

   DispMsg("Totalizzazione punti staffette (GENERALE)...")
   Set Order to 0
   Set Filter to
   go top
   while (!eof())
      SOC_AddPunti(Staffette->Societa, val(Staffette->P_GARA1))
      SOC_AddPunti(Staffette->Societa, val(Staffette->P_GARA2))
      skip
   enddo
   CloseStaffette()
   WClose()

   DispMsg("Stampa classifica societa' (GENERALE)...")

   IF (prn2file)
      SET PRINTER TO ("Classsoc.Prn")
   else
      if !CheckPrinter()
         return NIL
      endif
   ENDIF
   SET DEVICE TO PRINTER
   SET PRINTER ON
   PrintInit()

   @ 0,0 say PADC("*** CLASSIFICA FINALE SOCIETA' ***", 78)
   // @ 1,0 say PADC("( GENERALE )", 78)
   @ 1,0 say PADC("ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ", 78)
   ClassSocGara()

   SET DEVICE TO SCREEN
   SET PRINTER OFF
   SET PRINTER TO
   WClose()

   DispMsg("Azzeramento punteggi societa'...")
   SOC_FlushPunti()
   WClose()

   OpenAtleti()

   DispMsg("Ricalcolo classifiche 50 Stile Libero (REGIONALE)...")
   Set Order To 8
   SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_GARA1)) ;
      .and. SOC_IsRegional(Atleti->Societa)
   CalcScores( "Atleti->T_GARA1", "Atleti->P_GARA1")
   SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_GARA1)) ;
      .and. SOC_IsRegional(Atleti->Societa)
   CalcScores( "Atleti->T_GARA1", "Atleti->P_GARA1")
   WClose()

   DispMsg("Ricalcolo classifiche 50 Rana (REGIONALE)...")
   Set Order To 9
   SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_GARA2)) ;
      .and. SOC_IsRegional(Atleti->Societa)
   CalcScores( "Atleti->T_GARA2", "Atleti->P_GARA2")
   SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_GARA2)) ;
      .and. SOC_IsRegional(Atleti->Societa)
   CalcScores( "Atleti->T_GARA2", "Atleti->P_GARA2")
   WClose()

   DispMsg("Ricalcolo classifiche 50 Dorso (REGIONALE)...")
   Set Order To 10
   SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_GARA3)) ;
      .and. SOC_IsRegional(Atleti->Societa)
   CalcScores( "Atleti->T_GARA3", "Atleti->P_GARA3")
   SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_GARA3)) ;
      .and. SOC_IsRegional(Atleti->Societa)
   CalcScores( "Atleti->T_GARA3", "Atleti->P_GARA3")
   WCLose()

   DispMsg("Ricalcolo classifiche 50 Farfalla (REGIONALE)...")
   Set Order To 11
   SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_GARA4)) ;
      .and. SOC_IsRegional(Atleti->Societa)
   CalcScores( "Atleti->T_GARA4", "Atleti->P_GARA4")
   SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_GARA4)) ;
      .and. SOC_IsRegional(Atleti->Societa)
   CalcScores( "Atleti->T_GARA4", "Atleti->P_GARA4")
   WClose()

   DispMsg("Ricalcolo classifiche 100 Misti (REGIONALE)...")
   Set Order To 12
   SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_GARA5)) ;
      .and. SOC_IsRegional(Atleti->Societa)
   CalcScores( "Atleti->T_GARA5", "Atleti->P_GARA5")
   SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_GARA5)) ;
      .and. SOC_IsRegional(Atleti->Societa)
   CalcScores( "Atleti->T_GARA5", "Atleti->P_GARA5")
   WClose()

   DispMsg("Ricalcolo classifiche 200 Stile Libero (REGIONALE)...")
   Set Order To 13
   SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_GARA6)) ;
      .and. SOC_IsRegional(Atleti->Societa)
   CalcScores( "Atleti->T_GARA6", "Atleti->P_GARA6")
   SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_GARA6)) ;
      .and. SOC_IsRegional(Atleti->Societa)
   CalcScores( "Atleti->T_GARA6", "Atleti->P_GARA6")
   WCLose()



   DispMsg("Totalizzazione punti gare individuali (REGIONALE)...")
   Set Order to 0
   Set Filter to SOC_IsRegional(Atleti->Societa)
   go top
   while (!eof())
      SOC_AddPunti(Atleti->Societa, val(Atleti->P_GARA1))
      SOC_AddPunti(Atleti->Societa, val(Atleti->P_GARA2))
      SOC_AddPunti(Atleti->Societa, val(Atleti->P_GARA3))
      SOC_AddPunti(Atleti->Societa, val(Atleti->P_GARA4))
      SOC_AddPunti(Atleti->Societa, val(Atleti->P_GARA5))
      SOC_AddPunti(Atleti->Societa, val(Atleti->P_GARA6))
      skip
   enddo
   CloseAtleti()
   WClose()


   DispMsg("Ricalcolo classifiche staffette (REGIONALE)...")
   OpenStaffette()
   Set Order To 4
   SET FILTER to (Staffette->Sesso == 'F' .and. !EmptyTime(Staffette->T_GARA1)) ;
      .and. SOC_IsRegional(Staffette->Societa)
   CalcStaffs( "Staffette->T_GARA1", "Staffette->P_GARA1")
   SET FILTER to (Staffette->Sesso == 'M' .and. !EmptyTime(Staffette->T_GARA1)) ;
      .and. SOC_IsRegional(Staffette->Societa)
   CalcStaffs( "Staffette->T_GARA1", "Staffette->P_GARA1")
   WClose()

   Set Order To 5
   SET FILTER to (Staffette->Sesso == 'F' .and. !EmptyTime(Staffette->T_GARA2)) ;
      .and. SOC_IsRegional(Staffette->Societa)
   CalcStaffs( "Staffette->T_GARA2", "Staffette->P_GARA2")
   SET FILTER to (Staffette->Sesso == 'M' .and. !EmptyTime(Staffette->T_GARA2)) ;
      .and. SOC_IsRegional(Staffette->Societa)
   CalcStaffs( "Staffette->T_GARA2", "Staffette->P_GARA2")

   DispMsg("Totalizzazione punti staffette (REGIONALE)...")
   Set Order to 0
   Set Filter to SOC_IsRegional(Staffette->Societa)
   go top
   while (!eof())
      SOC_AddPunti(Staffette->Societa, val(Staffette->P_GARA1))
      SOC_AddPunti(Staffette->Societa, val(Staffette->P_GARA2))
      skip
   enddo
   CloseStaffette()
   WClose()

   DispMsg("Stampa classifica societa' (REGIONALE)...")
   IF (prn2file)
      SET PRINTER TO ("ClassSoc.Prn") additive
   else
      if !CheckPrinter()
         return NIL
      endif
   ENDIF
   SET DEVICE TO PRINTER
   SET PRINTER ON
   PrintInit()

   @ 0,0 say PADC("*** CLASSIFICA FINALE SOCIETA' ***", 78)
   // @ 1,0 say PADC("( REGIONALE )", 78)
   @ 1,0 say PADC("ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ", 78)
   ClassSocGara()

   SET DEVICE TO SCREEN
   SET PRINTER OFF
   SET PRINTER TO
   WClose()

   RETURN Nil



FUNCTION CheckPrinter()
   local retval := .F., key
   local oldcolor := SetColor()
   do while .T.
      if PrintReady()
         retval := .T.
         exit
      else
         WOpen(10,24,15,58)
         WBox(WB_SINGLE)
         @ 0,1 say "Stampante NON pronta, riprovo ?"
         ButtsRow(2, 0, 32, { { "S", "<S>" }, {"No", "<N>"} } )
         do while .T.
            key := Upper(Chr(Inkey(0)))
            if key$"SN" .or. lastkey() == K_ESC
               exit
            endif
         enddo
         WClose()
         IF key == 'S'
            LOOP
         ELSE
            exit
         endif
      ENDIF
   Enddo
   SetColor(oldcolor)
   return retval



STATIC Function CheckRow(r)
   if ( r >= 60)          // 80 per lj
      @ 63, 36 say "- " + alltrim( str(npag,2,0) ) + " -"   // 83 per lj
      eject
      ++ npag
      r := 0
   endif
   return r


FUNCTION DispMsg(msg)
   local nhandle, oldcolor, lx, rx

   lx = (80 - len(msg) - 4) / 2
   rx = lx + len(msg) + 3
   oldcolor := setcolor("n/rb")
   nhandle := WOpen(11,lx,13,rx)
   setcolor("rb+/rb")
   WBox(WB_SINGLE)
   setcolor("w+/rb")
   @ 0,1 say msg
   setcolor(oldcolor)
   return nhandle


// FindLongest: ritorna la lunghezza max di cognome + nome in archivio
STATIC Function FindLongest()
   local oldarea, oldrecno, oldorder
   local l, longest := 20     // min


   oldarea := select()
   select Atleti
   oldorder := indexord()
   oldrecno := recno()

   set order to 0
   go top
   do while !eof()
      l := len(alltrim(Atleti->nome)) + len(alltrim(Atleti->cognome))
      if l > longest
         longest := l
      endif
      skip
   enddo

   go oldrecno
   set order to oldorder
   select (oldarea)

   return longest


FUNCTION ClassSocGara()
   local oldarea := select()
   r := 4
   select societa
   set order to 3
   go top
   while (!eof())
      if (Societa->Punti > 0)
         @ r, 1 say Societa->Nome + str(Societa->punti, 3)
         ++r
      endif
      skip
   end
   select (oldarea)
   return NIL




FUNCTION ST_Cartellini()
   if OptBox(09,10,21,46, "GR+/BG", "N/BG", " Selezione Stampa ", OptRecs, OptVals) == .F.
      return NIL
   endif

   Select Societa
   Set Order to 1
   OpenAtleti()

   IF OptVals[F_FEMMINE]

      IF OptVals[F_GARA1]
         Set Order To 2
         SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_ISCR1))
         go top
         do while !eof()
            select societa
            seek Atleti->societa
            // FUNCTION Cards(cAnno, cCat, cDist, cStile, cTempo, cNome, cCod1, cSoc, cCod2)
            Cards(.F., Atleti->anno, "M." + Atleti->categoria, "50", "SL", Atleti->T_Iscr1, ;
                  alltrim(Atleti->Cognome) + " " + Atleti->Nome, Atleti->Codice, ;
                  Societa->Nome, Societa->Codice)
            select Atleti
            skip
         enddo
         Cards(.T.)
      ENDIF

      if OptVals[F_GARA2]
         Set Order To 3
         SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_ISCR2))
         go top
         do while !eof()
            select societa
            seek Atleti->societa
            // FUNCTION Cards(cAnno, cCat, cDist, cStile, cTempo, cNome, cCod1, cSoc, cCod2)
            Cards(.F., Atleti->anno, "M." + Atleti->categoria, "50", "RA", Atleti->T_Iscr2, ;
                  alltrim(Atleti->Cognome) + " " + Atleti->Nome, Atleti->Codice, ;
                  Societa->Nome, Societa->Codice)
            select Atleti
            skip
         enddo
         Cards(.T.)
      ENDIF

      IF OptVals[F_GARA3]
         Set Order To 4
         SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_ISCR3))
         go top
         do while !eof()
            select societa
            seek Atleti->societa
            // FUNCTION Cards(cAnno, cCat, cDist, cStile, cTempo, cNome, cCod1, cSoc, cCod2)
            Cards(.F., Atleti->anno, "M." + Atleti->categoria, "50", "DO", Atleti->T_Iscr3, ;
                  alltrim(Atleti->Cognome) + " " + Atleti->Nome, Atleti->Codice, ;
                  Societa->Nome, Societa->Codice)
            select Atleti
            skip
         enddo
         Cards(.T.)
      ENDIF

      IF OptVals[F_GARA4]
         Set Order To 5
         SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_ISCR4))
         go top
         do while !eof()
            select societa
            seek Atleti->societa
            // FUNCTION Cards(cAnno, cCat, cDist, cStile, cTempo, cNome, cCod1, cSoc, cCod2)
            Cards(.F., Atleti->anno, "M." + Atleti->categoria, "50", "FA", Atleti->T_Iscr4, ;
                  alltrim(Atleti->Cognome) + " " + Atleti->Nome, Atleti->Codice, ;
                  Societa->Nome, Societa->Codice)
            select Atleti
            skip
         enddo
         Cards(.T.)
      ENDIF

      if OptVals[F_GARA5]
         Set Order To 6
         SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_ISCR5))
         go top
         do while !eof()
            select societa
            seek Atleti->societa
            // FUNCTION Cards(cAnno, cCat, cDist, cStile, cTempo, cNome, cCod1, cSoc, cCod2)
            Cards(.F., Atleti->anno, "M." + Atleti->categoria, "100", "MX", Atleti->T_Iscr5, ;
                  alltrim(Atleti->Cognome) + " " + Atleti->Nome, Atleti->Codice, ;
                  Societa->Nome, Societa->Codice)
            select Atleti
            skip
         enddo
         Cards(.T.)
      ENDIF

      IF OptVals[F_GARA6]
         Set Order To 7
         SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_ISCR6))
         go top
         do while !eof()
            select societa
            seek Atleti->societa
            // FUNCTION Cards(cAnno, cCat, cDist, cStile, cTempo, cNome, cCod1, cSoc, cCod2)
            Cards(.F., Atleti->anno, "M." + Atleti->categoria, "200", "SL", Atleti->T_Iscr6, ;
                  alltrim(Atleti->Cognome) + " " + Atleti->Nome, Atleti->Codice, ;
                  Societa->Nome, Societa->Codice)
            select Atleti
            skip
         enddo
         Cards(.T.)
      ENDIF

   ENDIF


   IF OptVals[F_MASCHI]
      if OptVals[F_GARA1]
         Set Order To 2
         SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_ISCR1))
         go top
         do while !eof()
            select societa
            seek Atleti->societa
            // FUNCTION Cards(cAnno, cCat, cDist, cStile, cTempo, cNome, cCod1, cSoc, cCod2)
            Cards(.F., Atleti->anno, "M." + Atleti->categoria, "50", "SL", Atleti->T_Iscr1, ;
                  alltrim(Atleti->Cognome) + " " + Atleti->Nome, Atleti->Codice, ;
                  Societa->Nome, Societa->Codice)
            select Atleti
            skip
         enddo
         Cards(.T.)
      ENDIF

      IF OptVals[F_GARA2]
         Set Order To 3
         SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_ISCR2))
         go top
         do while !eof()
            select societa
            seek Atleti->societa
            // FUNCTION Cards(cAnno, cCat, cDist, cStile, cTempo, cNome, cCod1, cSoc, cCod2)
            Cards(.F., Atleti->anno, "M." + Atleti->categoria, "50", "RA", Atleti->T_Iscr2, ;
                  alltrim(Atleti->Cognome) + " " + Atleti->Nome, Atleti->Codice, ;
                  Societa->Nome, Societa->Codice)
            select Atleti
            skip
         enddo
         Cards(.T.)
      ENDIF

      IF OptVals[F_GARA3]
         Set Order To 4
         SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_ISCR3))
         go top
         do while !eof()
            select societa
            seek Atleti->societa
            // FUNCTION Cards(cAnno, cCat, cDist, cStile, cTempo, cNome, cCod1, cSoc, cCod2)
            Cards(.F., Atleti->anno, "M." + Atleti->categoria, "50", "DO", Atleti->T_Iscr3, ;
                  alltrim(Atleti->Cognome) + " " + Atleti->Nome, Atleti->Codice, ;
                  Societa->Nome, Societa->Codice)
            select Atleti
            skip
         enddo
         Cards(.T.)
      ENDIF

      if OptVals[F_GARA4]
         Set Order To 5
         SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_ISCR4))
         go top
         do while !eof()
            select societa
            seek Atleti->societa
            // FUNCTION Cards(cAnno, cCat, cDist, cStile, cTempo, cNome, cCod1, cSoc, cCod2)
            Cards(.F., Atleti->anno, "M." + Atleti->categoria, "50", "FA", Atleti->T_Iscr4, ;
                  alltrim(Atleti->Cognome) + " " + Atleti->Nome, Atleti->Codice, ;
                  Societa->Nome, Societa->Codice)
            select Atleti
            skip
         enddo
         Cards(.T.)
      ENDIF

      IF OptVals[F_GARA5]
         Set Order To 6
         SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_ISCR5))
         go top
         do while !eof()
            select societa
            seek Atleti->societa
            // FUNCTION Cards(cAnno, cCat, cDist, cStile, cTempo, cNome, cCod1, cSoc, cCod2)
            Cards(.F., Atleti->anno, "M." + Atleti->categoria, "100", "MX", Atleti->T_Iscr5, ;
                  alltrim(Atleti->Cognome) + " " + Atleti->Nome, Atleti->Codice, ;
                  Societa->Nome, Societa->Codice)
            select Atleti
            skip
         enddo
         Cards(.T.)
      ENDIF

      IF OptVals[F_GARA6]
         Set Order To 7
         SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_ISCR6))
         go top
         do while !eof()
            select societa
            seek Atleti->societa
            // FUNCTION Cards(cAnno, cCat, cDist, cStile, cTempo, cNome, cCod1, cSoc, cCod2)
            Cards(.F., Atleti->anno, "M." + Atleti->categoria, "200", "SL", Atleti->T_Iscr6, ;
                  alltrim(Atleti->Cognome) + " " + Atleti->Nome, Atleti->Codice, ;
                  Societa->Nome, Societa->Codice)
            select Atleti
            skip
         enddo
         Cards(.T.)
      ENDIF


   endif

   CloseAtleti()

   IF OptVals[F_STAFF1] .or. OptVals[F_STAFF2]
      OpenStaffette()
      IF OptVals[F_FEMMINE]
         Set Order To 2
         SET FILTER to (Staffette->Sesso == 'F' .and. !EmptyTime(Staffette->T_ISCR1))
         go top
         do while !eof()
            // FUNCTION Cards(cAnno, cCat, cDist, cStile, cTempo, cNome, cCod1, cSoc, cCod2)
            Cards(.F., " ", Staffette->Categoria, "4 x 50", "MX", Staffette->T_Iscr1, ;
                  " ", " ", Staffette->Nome, Staffette->Codice)
            skip
         enddo

         Set Order To 3
         SET FILTER to (Staffette->Sesso == 'F' .and. !EmptyTime(Staffette->T_ISCR2))
         go top
         do while !eof()
            // FUNCTION Cards(cAnno, cCat, cDist, cStile, cTempo, cNome, cCod1, cSoc, cCod2)
            Cards(.F., " ", Staffette->Categoria, "4 x 50", "SL", Staffette->T_Iscr2, ;
                  " ", " ", Staffette->Nome, Staffette->Codice)
            skip
         enddo
         Cards(.T.)
      ENDIF

      IF OptVals[F_MASCHI]
         Set Order To 2
         SET FILTER to (Staffette->Sesso == 'M' .and. !EmptyTime(Staffette->T_ISCR1))
         go top
         do while !eof()
            // FUNCTION Cards(cAnno, cCat, cDist, cStile, cTempo, cNome, cCod1, cSoc, cCod2)
            Cards(.F., " ", Staffette->Categoria, "4 x 50", "MX", Staffette->T_Iscr1, ;
                  " ", " ", Staffette->Nome, Staffette->Codice)
            skip
         enddo

         Set Order To 3
         SET FILTER to (Staffette->Sesso == 'M' .and. !EmptyTime(Staffette->T_ISCR2))
         go top
         do while !eof()
            // FUNCTION Cards(cAnno, cCat, cDist, cStile, cTempo, cNome, cCod1, cSoc, cCod2)
            Cards(.F., " ", Staffette->Categoria, "4 x 50", "SL", Staffette->T_Iscr2, ;
                  " ", " ", Staffette->Nome, Staffette->Codice)
            skip
         enddo
         Cards(.T.)
      ENDIF
      CloseStaffette()
   ENDIF

   return NIL





FUNCTION ST_EleSoc()
   IF (prn2file)
      SET PRINTER TO ("IscrSoc.Prn")
   else
      if !CheckPrinter()
         return NIL
      endif
   ENDIF

   SET DEVICE TO PRINTER
   SET PRINTER ON
   PrintInit()

   OpenAtleti()
   set order to 14

   select Societa
   set order to 2
   go top
   do while !eof()
      @ 0,0 say padc("*** LISTA ISCRITTI: " + UPPER(alltrim(Societa->nome)) + " ***", 78)
      @ 1,0 say padc(replicate("_", 70), 78)
      r := 4

      select atleti
      set filter to alltrim(Atleti->Societa) = alltrim(Societa->Codice)
      go top
      npag := 1

      do while !eof()
         @ r,5 say padl(alltrim(atleti->codice), 4) + space (5) + alltrim(Atleti->Cognome) + " " + alltrim(Atleti->nome)
         ++r
         r := CheckRow(r)
         skip
      enddo

      eject
      select societa
      skip

   enddo

   CloseAtleti()
   SET DEVICE TO SCREEN
   SET PRINTER OFF
   SET PRINTER TO
   RETURN Nil
