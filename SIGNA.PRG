// Signa.Prg

#include "NT2Win.ch"
#include "Inkey.ch"
#include "achoice.ch"


FUNCTION Signa()

   LOCAL k, opt, opz

   PARAMETERS opt1, opt2

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

   PUBLIC prn2file := .F.
   PUBLIC timefmt := "99" + "'" + "99" + '"' + "99"
   PUBLIC ManifCodice, ManifNome1, ManifNome2, ManifData


   ManifCodice := ManifNome1 := ManifNome1 := ""

   // lettura parametri di linea
   k := 1
   DO WHILE (k <= PCOUNT() .and. k <= 2)
      opt := "opt" + STR(k, 1)
      opt := LOWER(&opt)
      DO CASE
         CASE ( len(opt) >= 3 .and. subs(opt, 1, 2) == "-l" )
         CASE ( opt == "-f" )
            prn2file := .T.
      ENDCASE
      ++k
   ENDDO


   if (AskPassword(""))
      InitScreen()
      Hello()
      MenuMain()
      GoodBye()
      CleanUp()
   else
      // LogIntruder()
      ?? "Shark: Accesso Interdetto"
   endif

   RETURN NIL


FUNCTION InitScreen()
   Memvar ManifNome1, ManifNome2, ManifCodice, ManifData

   CGA80()
   Set Cursor OFF
   SETCOLOR("bg/b, gr+/n,,, w/n")
   WAClose()
   SetBoxGrow(5)
   WSetShadow("N+/N")


   @ 0,0,24,79 BOX "ÉÍ»º¼ÍÈº "


   // Lettura nome manifestazione corrente
   use Manifest
   locate for Manifest->Data >= date() - 3
   if found()
      ManifCodice := alltrim(Manifest->Codice)
      ManifNome1 := alltrim(Manifest->Nome1)
      ManifNome2 := alltrim(Manifest->Nome2)
      ManifData := Manifest->Data
   endif
   use

   SETCOLOR("G+/g")
   WOpen(0,1,3,78)
   WBOX(WB_SINGLE_CLEAR)
   SetColor("G+/g")
   @ 0, 1 say "Polisportiva"
   @ 1, 1 say "  Sestese    "
   SetColor("GR+/g")
   @ 0, 0 + ((76-len(ManifNome1)) / 2) say ManifNome1
   @ 1, 0 + ((76 - len (ManifNome2 + " " + dtoc(ManifData))) / 2) say ManifNome2 + " " + dtoc(ManifData)

   SETCOLOR("W+/g")
   SAYmoveIn( "SHARK", 64, 0,70)
   @ 1,71 say "1.0"
   ShowTime(24, 71, .F., "r/w")
RETURN NIL




FUNCTION Hello()
   SetColor("W+/R")
   WOpen(08,23,16,54,.T.)
   WBox(WB_DOUBLE_CLEAR)
   @ 0, 10 say "Benvenuti in"
   SetColor("R+/R")
   @ 2, 10 say " S.I.G.N.A. "
   SetColor("GR+/R")
   @ 4, 5  say " Sistema Informativo "
   @ 5, 5  say "Gare Nuoto Amatoriale "
   FootMsg(" Controllo archivi... " , .T.)

   SetFiles()
   FootMsg(" Premi un tasto per iniziare " )
   Tone(1000, 2)
   Inkey(0)
   WClose()

RETURN NIL


FUNCTION MenuMain
   LOCAL MenuBox, acMenuItems[5], Choice

   SETCOLOR("R/W")
   MenuBox := WOPEN(5,24, 11,50)
   WBOX(WB_SINGLE_CLEAR)

   SetColor("B/W")
   @ -1, 0 SAY ' FUNZIONI DISPONIBILI '

   acMenuItems[1] = ' Schede Atleti          '
   acMenuItems[2] = ' Schede Staffette       '
   acMenuItems[3] = ' Aggiornamento Tempi    '
   acMenuItems[4] = ' Stampe                 '
   acMenuItems[5] = " Configurazione Sistema "
   Choice := 1

   DO WHILE .T.
      FootMsg(" ESC-Uscita  -Selezione  INVIO-Conferma " )

      SETCOLOR("N/W")
      Choice := ACHOICE(0,0, 12, 41, acMenuItems,,"MenuFunc", Choice)
      DO CASE
         CASE ( Choice == 1 )
            MenuAtleti()

         CASE ( Choice == 2 )
            MenuStaffette()

         CASE ( Choice == 3 )
            FootMsg( " Aggiornamento Tempi Gara " )
            MenuTempi()

         CASE ( Choice == 4 )
            PrintMenu()

         OTHERWISE
            IF LastKey() == K_ESC
               if ConfExit()
                  EXIT
               endif
            ELSE
               Func_NA()
            ENDIF

      ENDCASE

   ENDDO
   WClose()
RETURN NIL


FUNCTION CleanUp()
   Close Data
   ShowTime()
   WAClose()
   Set Cursor ON
   SetColor("w/n")
   clear screen
RETURN NIL



FUNCTION SetFiles()
   FIELD codice, nome, societa, cognome, sesso, categoria
   FIELD T_Iscr1, T_Iscr2, T_Iscr3, T_Iscr4, T_Iscr5, T_Iscr6
   FIELD T_Gara1, T_Gara2, T_Gara3, T_Gara4, T_Gara5, T_Gara6
   FIELD punti
   MEMVAR FileLista, FileNegozi

   close data

   use Societa NEW
   pack
   index on codice to soccod
   index on nome   to socnom
   index on descend(str(punti, 3)) + nome to socpun
   set index to soccod, socnom, socpun

   use Atleti NEW
   pack
   index on Codice to AtlCod
   index on Sesso + DESCEND(T_Iscr1) + Cognome + Nome to AtlIsc1
   index on Sesso + DESCEND(T_Iscr2) + Cognome + Nome to AtlIsc2
   index on Sesso + DESCEND(T_Iscr3) + Cognome + Nome to AtlIsc3
   index on Sesso + DESCEND(T_Iscr4) + Cognome + Nome to AtlIsc4
   index on Sesso + DESCEND(T_Iscr5) + Cognome + Nome to AtlIsc5
   index on Sesso + DESCEND(T_Iscr6) + Cognome + Nome to AtlIsc6
   index on Categoria + Sesso + T_Gara1 + Cognome + Nome to AtlGar1
   index on Categoria + Sesso + T_Gara2 + Cognome + Nome to AtlGar2
   index on Categoria + Sesso + T_Gara3 + Cognome + Nome to AtlGar3
   index on Categoria + Sesso + T_Gara4 + Cognome + Nome to AtlGar4
   index on Categoria + Sesso + T_Gara5 + Cognome + Nome to AtlGar5
   index on Categoria + Sesso + T_Gara6 + Cognome + Nome to AtlGar6
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
   set index to AtlCod, AtlIsc1, AtlIsc2, AtlIsc3, AtlIsc4, AtlIsc5, AtlIsc6, ;
                AtlGar1, AtlGar2, AtlGar3, AtlGar4, AtlGar5, AtlGar6, AtlAlpha
   return NIL

FUNCTION CloseAtleti()
   select Atleti
   DBCommit()
   use
   return NIL


FUNCTION OpenStaffette()
   use Staffett ALIAS Staffette NEW
   set index to StafCod, StafIsc1, StafIsc2, StafGar1, StafGar2, StafAlph
   return NIL

FUNCTION CloseStaffette()
   select Staffette
   DBCommit()
   use
   return NIL


// stub per evitare unresolved con 5.2c e ntools II
function SCAN_480
return NIL


FUNCTION AskPassword(password)
   LOCAL oldcol, k, wpass, retval := .F.

   if EMPTY(password)
      RETURN .T.
   endif
   oldcol := SetColor("GR+/B")
   WOpen(09,20,14,56)
   WBOX(WB_DOUBLE_CLEAR)
   SetColor("BG+/B")
   @ -1, 13 say " CHECK-IN "

   for k := 1 to 3
      wpass := space(16)
      SetColor("gr+/b", "n/w")
      set cursor on
      @ 1,1 SAY "System Password: "
      wpass := upper(GETSECRET(wpass, 1, 18, .F.))
      set cursor off
      if (wpass != password)
         SetColor("R+*/B")
         @ 3,1 say "PASSWORD ERRATA! (tentativo n. " + str(k,1) + ")"
      else
         SetColor("G+/G")
         WOpen(09,20,15,56)
         WBOX(WB_DOUBLE_CLEAR)
         SetColor("GR+/G")
         @ 2,10 SAY "PASSWORD OK!!!"
         inkey(3)
         WClose()
         retval := .T.
         EXIT
      endif
   next k
   WClose()
   SetColor(oldcol)
   return retval


FUNCTION MenuAtleti()
   LOCAL acMenuItems[2], Choice

   SETCOLOR("R/W")
   WOPEN(6,25, 9,44)
   WBOX(WB_SINGLE_CLEAR)

   SetColor("B/W")
   @ -1, 0 SAY ' SCHEDE ATLETI '
   acMenuItems[1] = ' Iscrizioni      '
   acMenuItems[2] = ' Variazione Dati '
   Choice := 1

   DO WHILE .T.
      SETCOLOR("N/W")
      Choice := ACHOICE(0,0, 2, 41, acMenuItems,,"MenuFunc", Choice)
      DO CASE
         CASE ( Choice == 1 )
            FootMsg( " Iscrizione Atleti " )
            AtletiEdit(.T.)
         CASE ( Choice == 2 )
            FootMsg( " Variazione Atleti " )
            AtletiEdit(.F.)
         OTHERWISE
            EXIT
      ENDCASE
   ENDDO
   WClose()
   RETURN NIL


FUNCTION MenuStaffette()
   LOCAL acMenuItems[2], Choice

   SETCOLOR("R/W")
   WOPEN(7,25, 10,44)
   WBOX(WB_SINGLE_CLEAR)

   SetColor("B/W")
   @ -1, 0 SAY ' SCHEDE STAFFETTE '
   acMenuItems[1] = ' Iscrizioni      '
   acMenuItems[2] = ' Variazione Dati '
   Choice := 1

   DO WHILE .T.
      SETCOLOR("N/W")
      Choice := ACHOICE(0,0, 2, 41, acMenuItems,,"MenuFunc", Choice)
      DO CASE
         CASE ( Choice == 1 )
            FootMsg( " Iscrizione Staffette " )
            StaffetteEdit(.T.)
         CASE ( Choice == 2 )
            FootMsg( " Variazione Atleti " )
            StaffetteEdit(.F.)
         OTHERWISE
            EXIT
      ENDCASE
   ENDDO
   WClose()
   RETURN NIL



FUNCTION MenuTempi()
   LOCAL acMenuItems[2], Choice

   SETCOLOR("R/W")
   WOPEN(8,25, 11,47)
   WBOX(WB_SINGLE_CLEAR)

   SetColor("B/W")
   @ -1, 0 SAY ' AGGIORNAMENTO TEMPI '
   acMenuItems[1] = ' Atleti          '
   acMenuItems[2] = ' Staffette       '
   Choice := 1

   DO WHILE .T.
      SETCOLOR("N/W")
      Choice := ACHOICE(0,0, 2, 41, acMenuItems,,"MenuFunc", Choice)
      DO CASE
         CASE ( Choice == 1 )
            FootMsg( " Aggiornamento Tempi Atleti " )
            TempiAtleti()
         CASE ( Choice == 2 )
            FootMsg( " Aggiornamento Tempi Staffette " )
            TempiStaffette()
         OTHERWISE
            EXIT
      ENDCASE
   ENDDO
   WClose()
   RETURN NIL


