// Cartelli.prg


static FUNCTION initstring()
   return   "E"     + ;    // reset
            "(10U"  + ;    // pc8
            "(s0P"  + ;    // spaz. fissa
            "(s12H" + ;    // 12 cpi
            "(s10V" + ;    // 10 pt
            "&l8D"  + ;    // 8 lpi
            "(s3T"         // courier



FUNCTION Cards(bEject, cAnno, cCat, cDist, cStile, cTempo, cNome, cCod1, cSoc, cCod2)
   static aAnno [4]
   static aCat  [4]
   static aDist [4]
   static aStile[4]
   static aTempo[4]
   static aNome [4]
   static aCod1 [4]
   static aSoc  [4]
   static aCod2 [4]
   static idx := 1
   local k

   if (bEject)
      for k := idx to 4
         aAnno [k] := space(6)
         aCat  [k] := space(7)
         aDist [k] := space(7)
         aStile[k] := space(7)
         aTempo[k] := space(12)
         aNome [k] := space(31)
         aCod1 [k] := space(10)
         aSoc  [k] := space(31)
         aCod2 [k] := space(10)
      next k
   else
      aAnno [idx] := PADC(alltrim(cAnno ),6)
      aCat  [idx] := PADC(alltrim(cCat  ),7)
      aDist [idx] := PADC(alltrim(cDist ),7)
      aStile[idx] := PADC(alltrim(cStile),7)
      aTempo[idx] := PADC(alltrim(cTempo),12)
      aNome [idx] := PADR(alltrim(cNome ),31)
      aCod1 [idx] := PADC(alltrim(cCod1 ),10)
      aSoc  [idx] := PADR(alltrim(cSoc  ),31)
      aCod2 [idx] := PADC(alltrim(cCod2 ),10)
   endif

   if (++idx > 4 .or. bEject)
      idx := 1
      IF (prn2file)
         SET PRINTER TO ("cards.Prn") ADDITIVE
      ENDIF
      SET DEVICE TO PRINTER
      SET PRINTER ON
      @ 0,0 say initstring()
      @ 00,0 say "                 LEGA NUOTO                                     LEGA NUOTO"

      @ 02,0 say "зддддддддддддддддддддддддддддддддддддддддддд©   зддддддддддддддддддддддддддддддддддддддддддд©"
      @ 03,0 say "Ё   CAMPIONATO REGIONALE MASTER UISP '96    Ё   Ё   CAMPIONATO REGIONALE MASTER UISP '96    Ё"
      @ 04,0 say [Ё        PISCINA DELL' "ACQUACALDA"         Ё   Ё        PISCINA DELL' "ACQUACALDA"         Ё]
      @ 05,0 say "Ё                   SIENA                   Ё   Ё                   SIENA                   Ё"
      @ 06,0 say "Ё               24 Marzo 1996               Ё   Ё               24 Marzo 1996               Ё"
      @ 07,0 say "юддддддддддддддддддддддддддддддддддддддддддды   юддддддддддддддддддддддддддддддддддддддддддды"
      @ 08,0 say "зддддддбдддддддбдддддддбдддддддбдддддддддддд©   зддддддбдддддддбдддддддбдддддддбдддддддддддд©"
      @ 09,0 say "Ё Anno Ё  Cat. Ё Dist. Ё Stile Ё T. Iscriz. Ё   Ё Anno Ё  Cat. Ё Dist. Ё Stile Ё T. Iscriz. Ё"
      @ 10,0 say "Ё      Ё       Ё       Ё       Ё            Ё   Ё      Ё       Ё       Ё       Ё            Ё"
      @ 11,0 say "Ё" + aAnno[1] + "Ё" + aCat[1] + "Ё" + aDist[1] + "Ё" + aStile[1] + "Ё" + aTempo[1] + "Ё   Ё" + aAnno[2] + "Ё" + aCat[2] + "Ё" + aDist[2] + "Ё" + aStile[2] + "Ё" + aTempo[2] + "Ё"
      @ 12,0 say "Ё      Ё       Ё       Ё       Ё            Ё   Ё      Ё       Ё       Ё       Ё            Ё"
      @ 13,0 say "юддддддадддддддадддддддадддддддадддддддддддды   юддддддадддддддадддддддадддддддадддддддддддды"
      @ 14,0 say "зддддддддддддддддддддддддддддддддбдддддддддд©   зддддддддддддддддддддддддддддддддбдддддддддд©"
      @ 15,0 say "Ё COGNOME E NOME                 Ё CODICE   Ё   Ё COGNOME E NOME                 Ё CODICE   Ё"
      @ 16,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 17,0 say "Ё " + aNome[1] + "Ё" + aCod1[1] + "Ё   Ё " + aNome[2] + "Ё" + aCod1[2] + "Ё"
      @ 18,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 19,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 20,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 21,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 22,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 23,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 24,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 25,0 say "Ё SOCIETA'                       Ё          Ё   Ё SOCIETA'                       Ё          Ё"
      @ 26,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 27,0 say "Ё " + aSoc[1] + "Ё" + aCod2[1] + "Ё   Ё " + aSoc[2] + "Ё" + aCod2[2] + "Ё"
      @ 28,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 29,0 say "юддддддддддддддддддддддддддддддддадддддддддды   юддддддддддддддддддддддддддддддддадддддддддды"
      @ 30,0 say "здддддддддддбддддддддддддддддддбдддддддддддд©   здддддддддддбддддддддддддддддддбдддддддддддд©"
      @ 31,0 say "Ё BATTERIA  Ё TEMPO CONSEGUITO Ё CLASSIFICA Ё   Ё BATTERIA  Ё TEMPO CONSEGUITO Ё CLASSIFICA Ё"
      @ 32,0 say "Ё           Ё                  Ё            Ё   Ё           Ё                  Ё            Ё"
      @ 33,0 say "Ё           Ё                  Ё            Ё   Ё           Ё                  Ё            Ё"
      @ 34,0 say "Ё           Ё                  Ё            Ё   Ё           Ё                  Ё            Ё"
      @ 35,0 say "цддддддддддд╢                  цдддддддддддд╢   цддддддддддд╢                  цдддддддддддд╢"
      @ 36,0 say "Ё CORSIA    Ё                  Ё PUNTI      Ё   Ё CORSIA    Ё                  Ё PUNTI      Ё"
      @ 37,0 say "Ё           Ё                  Ё            Ё   Ё           Ё                  Ё            Ё"
      @ 38,0 say "Ё           Ё                  Ё            Ё   Ё           Ё                  Ё            Ё"
      @ 39,0 say "Ё           Ё                  Ё            Ё   Ё           Ё                  Ё            Ё"
      @ 40,0 say "юдддддддддддаддддддддддддддддддадддддддддддды   юдддддддддддаддддддддддддддддддадддддддддддды"
      @ 41,0 say "                                                                                             "
      @ 42,0 say "                                                                                             "
      @ 43,0 say "                                                                                             "
      @ 44,0 say "                LEGA NUOTO                                      LEGA NUOTO                   "

      @ 46,0 say "зддддддддддддддддддддддддддддддддддддддддддд©   зддддддддддддддддддддддддддддддддддддддддддд©"
      @ 47,0 say "Ё   CAMPIONATO REGIONALE MASTER UISP '96    Ё   Ё   CAMPIONATO REGIONALE MASTER UISP '96    Ё"
      @ 48,0 say [Ё        PISCINA DELL' "ACQUACALDA"         Ё   Ё        PISCINA DELL' "ACQUACALDA"         Ё]
      @ 49,0 say "Ё                   SIENA                   Ё   Ё                   SIENA                   Ё"
      @ 50,0 say "Ё               24 Marzo 1996               Ё   Ё               24 Marzo 1996               Ё"
      @ 51,0 say "юддддддддддддддддддддддддддддддддддддддддддды   юддддддддддддддддддддддддддддддддддддддддддды"
      @ 52,0 say "зддддддбдддддддбдддддддбдддддддбдддддддддддд©   зддддддбдддддддбдддддддбдддддддбдддддддддддд©"
      @ 53,0 say "Ё Anno Ё  Cat. Ё Dist. Ё Stile Ё T. Iscriz. Ё   Ё Anno Ё  Cat. Ё Dist. Ё Stile Ё T. Iscriz. Ё"
      @ 54,0 say "Ё      Ё       Ё       Ё       Ё            Ё   Ё      Ё       Ё       Ё       Ё            Ё"
      @ 55,0 say "Ё" + aAnno[3] + "Ё" + aCat[3] + "Ё" + aDist[3] + "Ё" + aStile[3] + "Ё" + aTempo[3] + "Ё   Ё" + aAnno[4] + "Ё" + aCat[4] + "Ё" + aDist[4] + "Ё" + aStile[4] + "Ё" + aTempo[4] + "Ё"
      @ 56,0 say "Ё      Ё       Ё       Ё       Ё            Ё   Ё      Ё       Ё       Ё       Ё            Ё"
      @ 57,0 say "юддддддадддддддадддддддадддддддадддддддддддды   юддддддадддддддадддддддадддддддадддддддддддды"
      @ 58,0 say "зддддддддддддддддддддддддддддддддбдддддддддд©   зддддддддддддддддддддддддддддддддбдддддддддд©"
      @ 59,0 say "Ё COGNOME E NOME                 Ё CODICE   Ё   Ё COGNOME E NOME                 Ё CODICE   Ё"
      @ 60,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 61,0 say "Ё " + aNome[3] + "Ё" + aCod1[3] + "Ё   Ё " + aNome[4] + "Ё" + aCod1[4] + "Ё"
      @ 62,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 63,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 64,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 65,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 66,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 67,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 68,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 69,0 say "Ё SOCIETA'                       Ё          Ё   Ё SOCIETA'                       Ё          Ё"
      @ 70,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 71,0 say "Ё " + aSoc[3] + "Ё" + aCod2[3] + "Ё   Ё " + aSoc[4] + "Ё" + aCod2[4] + "Ё"
      @ 72,0 say "Ё                                Ё          Ё   Ё                                Ё          Ё"
      @ 73,0 say "юддддддддддддддддддддддддддддддддадддддддддды   юддддддддддддддддддддддддддддддддадддддддддды"
      @ 74,0 say "здддддддддддбддддддддддддддддддбдддддддддддд©   здддддддддддбддддддддддддддддддбдддддддддддд©"
      @ 75,0 say "Ё BATTERIA  Ё TEMPO CONSEGUITO Ё CLASSIFICA Ё   Ё BATTERIA  Ё TEMPO CONSEGUITO Ё CLASSIFICA Ё"
      @ 76,0 say "Ё           Ё                  Ё            Ё   Ё           Ё                  Ё            Ё"
      @ 77,0 say "Ё           Ё                  Ё            Ё   Ё           Ё                  Ё            Ё"
      @ 78,0 say "Ё           Ё                  Ё            Ё   Ё           Ё                  Ё            Ё"
      @ 79,0 say "цддддддддддд╢                  цдддддддддддд╢   цддддддддддд╢                  цдддддддддддд╢"
      @ 80,0 say "Ё CORSIA    Ё                  Ё PUNTI      Ё   Ё CORSIA    Ё                  Ё PUNTI      Ё"
      @ 81,0 say "Ё           Ё                  Ё            Ё   Ё           Ё                  Ё            Ё"
      @ 82,0 say "Ё           Ё                  Ё            Ё   Ё           Ё                  Ё            Ё"
      @ 83,0 say "Ё           Ё                  Ё            Ё   Ё           Ё                  Ё            Ё"
      @ 84,0 say "юдддддддддддаддддддддддддддддддадддддддддддды   юдддддддддддаддддддддддддддддддадддддддддддды"

      eject
      SET DEVICE TO SCREEN
      SET PRINTER OFF
      SET PRINTER TO
   endif
   return NIL

