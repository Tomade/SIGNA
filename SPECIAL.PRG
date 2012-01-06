// Signa.Prg

#include "NT2Win.ch"
#include "Inkey.ch"
#include "achoice.ch"

#define F_REGION  1
#define F_MASCHI  2
#define F_FEMMINE 3
#define F_GARA1   4
#define F_GARA2   5
#define F_GARA3   6
#define F_STAFF1  7
#define F_STAFF2  8

static OptRecs := {   {1,10, "REGIONALE" }, ;
                      {3,2,  "Maschi"    }, ;
                      {3,19, "Femmine"   }, ;
                      {5,2,  "100 SL"    }, ;
                      {5,19, "50 DF"     }, ;
                      {7,2,  "50 RA"     }, ;
                      {7,19, "4 x 50 MX" }, ;
                      {9,2 , "4 x 50 SL" }  ;
}
static OptVals := { .F., .F., .F., .F., .F., .F., .F., .F.}


static r := 0
static npag := 1
   static mast_marg, title
   static categ, scateg, punti, last_punti, last_time, parity



function special
   Set ScoreBoard OFF
   Set Talk OFF
   Set Echo OFF
   Set Confirm ON
   Set Bell OFF
   Set Safety OFF
   Set Deleted ON
   Set TypeAhead TO 100
   Set Date British
   Set Exact ON
   Set Wrap ON

   PUBLIC prn2file := .T.
   PUBLIC timefmt := "99" + "'" + "99" + '"' + "99"


   use Societa NEW
   set index to soccod, socnom, socpun


   if OptBox(09,10,21,46, "GR+/BG", "N/BG", " Selezione Stampa ", OptRecs, OptVals) == .F.
      return NIL
   endif

   // Stampa classifica 100 STILE femmine - tutte le categorie
   OpenAtleti()

   IF OptVals[F_GARA1]
      Set Order To 1

      IF OptVals[F_FEMMINE]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 100 STILE LIBERO - FEMMINE   (REGIONALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_ISCR1)) ;
            .and. SOC_IsRegional(Atleti->Societa)
         ELSE
            title := PADC("*** CLASSIFICA 100 STILE LIBERO - FEMMINE   (GENERALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_ISCR1))
         ENDIF
         PrintScores(title, "Atleti->T_ISCR1", "Atleti->P_GARA1")
      ENDIF

      IF OptVals[F_MASCHI]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 100 STILE LIBERO - MASCHI   (REGIONALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_ISCR1)) ;
            .and. SOC_IsRegional(Atleti->Societa)
         ELSE
            title := PADC("*** CLASSIFICA 100 STILE LIBERO - MASCHI   (GENERALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_ISCR1))
         ENDIF
         PrintScores(title, "Atleti->T_ISCR1", "Atleti->P_GARA1")
      ENDIF
   ENDIF


   IF OptVals[F_GARA2]
      Set Order To 2

      IF OptVals[F_FEMMINE]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 50 DELFINO - FEMMINE   (REGIONALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_ISCR2)) ;
            .and. SOC_IsRegional(Atleti->Societa)
         ELSE
            title := PADC("*** CLASSIFICA 50 DELFINO - FEMMINE   (GENERALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_ISCR2))
         ENDIF
         PrintScores(title, "Atleti->T_ISCR2", "Atleti->P_GARA2")
      ENDIF

      IF OptVals[F_MASCHI]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 50 DELFINO - MASCHI   (REGIONALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_ISCR2)) ;
            .and. SOC_IsRegional(Atleti->Societa)
         ELSE
            title := PADC("*** CLASSIFICA 50 DELFINO - MASCHI   (GENERALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_ISCR2))
         ENDIF
         PrintScores(title, "Atleti->T_ISCR2", "Atleti->P_GARA2")
      ENDIF
   ENDIF

   IF OptVals[F_GARA3]
      Set Order To 3

      IF OptVals[F_FEMMINE]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 50 RANA - FEMMINE   (REGIONALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_ISCR3)) ;
            .and. SOC_IsRegional(Atleti->Societa)
         ELSE
            title := PADC("*** CLASSIFICA 50 RANA - FEMMINE   (GENERALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'F' .and. !EmptyTime(Atleti->T_ISCR3))
         ENDIF
         PrintScores(title, "Atleti->T_ISCR3", "Atleti->P_GARA3")
      ENDIF

      IF OptVals[F_MASCHI]
         IF OptVals[F_REGION]
            title := PADC("*** CLASSIFICA 50 RANA - MASCHI   (REGIONALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_ISCR3)) ;
            .and. SOC_IsRegional(Atleti->Societa)
         ELSE
            title := PADC("*** CLASSIFICA 50 RANA - MASCHI   (GENERALE) ***",78)
            SET FILTER to (Atleti->Sesso == 'M' .and. !EmptyTime(Atleti->T_ISCR3))
         ENDIF
         PrintScores(title, "Atleti->T_ISCR3", "Atleti->P_GARA3")
      ENDIF
   ENDIF
   CloseAtleti()

   RETURN NIL



FUNCTION SetFiles()
   FIELD codice, nome, societa, cognome, sesso, categoria
   FIELD T_Iscr1, T_Iscr2, T_Gara1, T_Gara2, punti
   MEMVAR FileLista, FileNegozi

   close data


   use Atleti NEW
   pack
   index on Codice to AtlCod
   index on Sesso + DESCEND(T_Iscr1) + Cognome + Nome to AtlIsc1
   index on Sesso + DESCEND(T_Iscr2) + Cognome + Nome to AtlIsc2
   index on Sesso + DESCEND(T_Iscr3) + Cognome + Nome to AtlIsc3
   index on Categoria + Sesso + T_Gara1 + Cognome + Nome to AtlGar1
   index on Categoria + Sesso + T_Gara2 + Cognome + Nome to AtlGar2
   index on Categoria + Sesso + T_Gara3 + Cognome + Nome to AtlGar3
   index on Cognome + Nome to AtlAlpha
   use

   use Staffett ALIAS Staffette NEW
   pack
   index on Codice to StafCod
   index on Sesso + Categoria + DESCEND(T_Iscr1) + Nome to StafIsc1
   index on Sesso + Categoria + DESCEND(T_Iscr2) + Nome to StafIsc2
   index on Sesso + Categoria + T_Gara1 + Nome to StafGar1
   index on Sesso + Categoria + T_Gara2 + Nome to StafGar2
   index on Nome  + Categoria to StafAlph
   use

RETURN NIL



FUNCTION OpenAtleti()
   use Atleti NEW
   index on Categoria + Sesso + T_Iscr1 + Cognome + Nome to idx1
   index on Categoria + Sesso + T_Iscr2 + Cognome + Nome to idx2
   index on Categoria + Sesso + T_Iscr3 + Cognome + Nome to idx3
   set index to idx1, idx2, idx3
   return NIL

FUNCTION CloseAtleti()
   select Atleti
   DBCommit()
   use
   return NIL


// stub per evitare unresolved con 5.2c e ntools II
function SCAN_480
return NIL






FUNCTION PrintScores( title, _tempo, _punti )
   local mast_marg, categ, scateg, r, rank

   mast_marg := 40
   go top
   IF (prn2file)
      SET PRINTER TO ("ClassAtl.Prn") additive
   ENDIF
   SET DEVICE TO PRINTER
   SET PRINTER ON
   PrintInit()
   FOR categ := 20 to 75 step 5
      scateg := str(categ,2)
      if (alltrim(Atleti->Categoria) != scateg)
         loop
      endif
      @ 0,0 say title
      @ 1,0 say PADC("CATEGORIA: M." + scateg, 78)
      @ 2,0 say PADC("컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�",78)
      r := 4
      npag := 1
      rank := 1
      do while (!eof() .and. alltrim(Atleti->Categoria) == scateg)
         @ r,  0 say padl(alltrim(str(rank++)),3) + " " + alltrim(Atleti->Cognome) + " " + alltrim(Atleti->Nome)
         @ r, mast_marg say " " + subs(Atleti->Anno, 3,2) + " ";
            + SOC_GetName(Atleti->Societa) + " " + &_tempo + space(4) + &_punti
         ++r
         r := CheckRow(r)
         skip
      enddo
   NEXT
   eject
   SET DEVICE TO SCREEN
   SET PRINTER OFF
   SET PRINTER TO
   return NIL

Function CheckRow(r)
   if ( r >= 60)          // 80 per lj
      @ 63, 36 say "- " + alltrim( str(npag,2,0) ) + " -"   // 83 per lj
      eject
      ++ npag
      r := 0
   endif
   return r


