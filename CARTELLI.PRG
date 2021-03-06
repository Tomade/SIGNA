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

      @ 02,0 say "旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�   旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�"
      @ 03,0 say "�   CAMPIONATO REGIONALE MASTER UISP '96    �   �   CAMPIONATO REGIONALE MASTER UISP '96    �"
      @ 04,0 say [�        PISCINA DELL' "ACQUACALDA"         �   �        PISCINA DELL' "ACQUACALDA"         �]
      @ 05,0 say "�                   SIENA                   �   �                   SIENA                   �"
      @ 06,0 say "�               24 Marzo 1996               �   �               24 Marzo 1996               �"
      @ 07,0 say "읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�   읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�"
      @ 08,0 say "旼컴컴컫컴컴컴컫컴컴컴컫컴컴컴컫컴컴컴컴컴컴�   旼컴컴컫컴컴컴컫컴컴컴컫컴컴컴컫컴컴컴컴컴컴�"
      @ 09,0 say "� Anno �  Cat. � Dist. � Stile � T. Iscriz. �   � Anno �  Cat. � Dist. � Stile � T. Iscriz. �"
      @ 10,0 say "�      �       �       �       �            �   �      �       �       �       �            �"
      @ 11,0 say "�" + aAnno[1] + "�" + aCat[1] + "�" + aDist[1] + "�" + aStile[1] + "�" + aTempo[1] + "�   �" + aAnno[2] + "�" + aCat[2] + "�" + aDist[2] + "�" + aStile[2] + "�" + aTempo[2] + "�"
      @ 12,0 say "�      �       �       �       �            �   �      �       �       �       �            �"
      @ 13,0 say "읕컴컴컨컴컴컴컨컴컴컴컨컴컴컴컨컴컴컴컴컴컴�   읕컴컴컨컴컴컴컨컴컴컴컨컴컴컴컨컴컴컴컴컴컴�"
      @ 14,0 say "旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴�   旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴�"
      @ 15,0 say "� COGNOME E NOME                 � CODICE   �   � COGNOME E NOME                 � CODICE   �"
      @ 16,0 say "�                                �          �   �                                �          �"
      @ 17,0 say "� " + aNome[1] + "�" + aCod1[1] + "�   � " + aNome[2] + "�" + aCod1[2] + "�"
      @ 18,0 say "�                                �          �   �                                �          �"
      @ 19,0 say "�                                �          �   �                                �          �"
      @ 20,0 say "�                                �          �   �                                �          �"
      @ 21,0 say "�                                �          �   �                                �          �"
      @ 22,0 say "�                                �          �   �                                �          �"
      @ 23,0 say "�                                �          �   �                                �          �"
      @ 24,0 say "�                                �          �   �                                �          �"
      @ 25,0 say "� SOCIETA'                       �          �   � SOCIETA'                       �          �"
      @ 26,0 say "�                                �          �   �                                �          �"
      @ 27,0 say "� " + aSoc[1] + "�" + aCod2[1] + "�   � " + aSoc[2] + "�" + aCod2[2] + "�"
      @ 28,0 say "�                                �          �   �                                �          �"
      @ 29,0 say "읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴�   읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴�"
      @ 30,0 say "旼컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴�   旼컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴�"
      @ 31,0 say "� BATTERIA  � TEMPO CONSEGUITO � CLASSIFICA �   � BATTERIA  � TEMPO CONSEGUITO � CLASSIFICA �"
      @ 32,0 say "�           �                  �            �   �           �                  �            �"
      @ 33,0 say "�           �                  �            �   �           �                  �            �"
      @ 34,0 say "�           �                  �            �   �           �                  �            �"
      @ 35,0 say "쳐컴컴컴컴컴�                  쳐컴컴컴컴컴캑   쳐컴컴컴컴컴�                  쳐컴컴컴컴컴캑"
      @ 36,0 say "� CORSIA    �                  � PUNTI      �   � CORSIA    �                  � PUNTI      �"
      @ 37,0 say "�           �                  �            �   �           �                  �            �"
      @ 38,0 say "�           �                  �            �   �           �                  �            �"
      @ 39,0 say "�           �                  �            �   �           �                  �            �"
      @ 40,0 say "읕컴컴컴컴컴좔컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴�   읕컴컴컴컴컴좔컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴�"
      @ 41,0 say "                                                                                             "
      @ 42,0 say "                                                                                             "
      @ 43,0 say "                                                                                             "
      @ 44,0 say "                LEGA NUOTO                                      LEGA NUOTO                   "

      @ 46,0 say "旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�   旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�"
      @ 47,0 say "�   CAMPIONATO REGIONALE MASTER UISP '96    �   �   CAMPIONATO REGIONALE MASTER UISP '96    �"
      @ 48,0 say [�        PISCINA DELL' "ACQUACALDA"         �   �        PISCINA DELL' "ACQUACALDA"         �]
      @ 49,0 say "�                   SIENA                   �   �                   SIENA                   �"
      @ 50,0 say "�               24 Marzo 1996               �   �               24 Marzo 1996               �"
      @ 51,0 say "읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�   읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�"
      @ 52,0 say "旼컴컴컫컴컴컴컫컴컴컴컫컴컴컴컫컴컴컴컴컴컴�   旼컴컴컫컴컴컴컫컴컴컴컫컴컴컴컫컴컴컴컴컴컴�"
      @ 53,0 say "� Anno �  Cat. � Dist. � Stile � T. Iscriz. �   � Anno �  Cat. � Dist. � Stile � T. Iscriz. �"
      @ 54,0 say "�      �       �       �       �            �   �      �       �       �       �            �"
      @ 55,0 say "�" + aAnno[3] + "�" + aCat[3] + "�" + aDist[3] + "�" + aStile[3] + "�" + aTempo[3] + "�   �" + aAnno[4] + "�" + aCat[4] + "�" + aDist[4] + "�" + aStile[4] + "�" + aTempo[4] + "�"
      @ 56,0 say "�      �       �       �       �            �   �      �       �       �       �            �"
      @ 57,0 say "읕컴컴컨컴컴컴컨컴컴컴컨컴컴컴컨컴컴컴컴컴컴�   읕컴컴컨컴컴컴컨컴컴컴컨컴컴컴컨컴컴컴컴컴컴�"
      @ 58,0 say "旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴�   旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴�"
      @ 59,0 say "� COGNOME E NOME                 � CODICE   �   � COGNOME E NOME                 � CODICE   �"
      @ 60,0 say "�                                �          �   �                                �          �"
      @ 61,0 say "� " + aNome[3] + "�" + aCod1[3] + "�   � " + aNome[4] + "�" + aCod1[4] + "�"
      @ 62,0 say "�                                �          �   �                                �          �"
      @ 63,0 say "�                                �          �   �                                �          �"
      @ 64,0 say "�                                �          �   �                                �          �"
      @ 65,0 say "�                                �          �   �                                �          �"
      @ 66,0 say "�                                �          �   �                                �          �"
      @ 67,0 say "�                                �          �   �                                �          �"
      @ 68,0 say "�                                �          �   �                                �          �"
      @ 69,0 say "� SOCIETA'                       �          �   � SOCIETA'                       �          �"
      @ 70,0 say "�                                �          �   �                                �          �"
      @ 71,0 say "� " + aSoc[3] + "�" + aCod2[3] + "�   � " + aSoc[4] + "�" + aCod2[4] + "�"
      @ 72,0 say "�                                �          �   �                                �          �"
      @ 73,0 say "읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴�   읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴�"
      @ 74,0 say "旼컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴�   旼컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴�"
      @ 75,0 say "� BATTERIA  � TEMPO CONSEGUITO � CLASSIFICA �   � BATTERIA  � TEMPO CONSEGUITO � CLASSIFICA �"
      @ 76,0 say "�           �                  �            �   �           �                  �            �"
      @ 77,0 say "�           �                  �            �   �           �                  �            �"
      @ 78,0 say "�           �                  �            �   �           �                  �            �"
      @ 79,0 say "쳐컴컴컴컴컴�                  쳐컴컴컴컴컴캑   쳐컴컴컴컴컴�                  쳐컴컴컴컴컴캑"
      @ 80,0 say "� CORSIA    �                  � PUNTI      �   � CORSIA    �                  � PUNTI      �"
      @ 81,0 say "�           �                  �            �   �           �                  �            �"
      @ 82,0 say "�           �                  �            �   �           �                  �            �"
      @ 83,0 say "�           �                  �            �   �           �                  �            �"
      @ 84,0 say "읕컴컴컴컴컴좔컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴�   읕컴컴컴컴컴좔컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴�"

      eject
      SET DEVICE TO SCREEN
      SET PRINTER OFF
      SET PRINTER TO
   endif
   return NIL

