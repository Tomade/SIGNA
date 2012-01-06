// Utils.prg

#include "inkey.ch"
#include "setcurs.ch"
#include "achoice.ch"
#include "nt2win.ch"

#define MY_HSEP      "Õ—Õ"
#define MY_CSEP      " ≥ "


FUNCTION MenuFunc
   PARAMETER mode
   LOCAL retval

   retval := AC_CONT
   IF mode == AC_EXCEPT
      DO CASE
         CASE LastKey() == K_ESC
            retval := AC_ABORT
         CASE LastKey() == K_ENTER
            retval := AC_SELECT
         CASE LastKey() == K_HOME
            KEYBOARD CHR(K_CTRL_HOME)
         CASE LastKey() == K_END
            KEYBOARD CHR(K_CTRL_END)
      ENDCASE
   ENDIF

   IF mode == AC_HITTOP
      KEYBOARD CHR(K_CTRL_END)
   ENDIF

   IF mode == AC_HITBOTTOM
      KEYBOARD CHR(K_CTRL_HOME)
   ENDIF

RETURN RETVAL



****
*  Skipper()
*

func Skipper(n, lAppend)
   local i := 0

   if ( LastRec() != 0 )

      if ( n == 0 )
         SKIP 0

      elseif ( n > 0 .and. Recno() != LastRec() + 1 )
         while ( i < n )
            SKIP 1
            if ( Eof() )
               if ( lAppend )
                  i++
               else
                  SKIP -1
               end

               exit
            end
            i++
         end

      elseif ( n < 0 )
         while ( i > n )
            SKIP -1
            if ( Bof() )
               exit
            end

            i--
         end
      end
   end

   IF lAppend
      SetColor("W+/W")
      @ -1, 2 SAY "NUOVO"
   ELSE
      SetColor("N/W")
      @ -1, 2 SAY "ƒƒƒƒƒ"
   ENDIF


   return (i)


FUNCTION AskDel
   LOCAL retval := .F.
   LOCAL oldcol := SetColor("N/W")

   WOpen(10,26,15,56)
   WBox(WB_SINGLE)

   @ 0,1 say "Confermi la cancellazione ?"
   ButtsRow(2, 0, 28, { { "Sç", "<S>" }, {"No", "<N>"} } )
   Inkey(0)
   IF Upper(Chr(LastKey())) == 'S'
      retval = .T.
   ENDIF
   WClose()
   SetColor("N/W")
   RETURN retval




/* ButtsRow:
   Disegna un array di pushbuttons
   Parametri:
      r: riga display
      c: colonna iniziale display
      wid: ampiezza in colonne, in cui spaziare i pushbuttons
      aButts: array pushbuttons
*/
FUNCTION ButtsRow(r, c, wid, aButts)
   LOCAL nButts := LEN (aButts)
   LOCAL k, TSpace := 0, ILeave

   // Compute total space needed
   FOR k := 1 TO nButts
      TSpace += ( LEN(aButts[k][1]) + LEN(aButts[k][2])  )
   NEXT k

   // Compute interleave among buttons
   ILeave := ROUND ( (wid - TSpace) / (nButts + 1), 0 )

   // Draw buttons
   c += ILeave
   FOR k := 1 TO nButts
      PushButton(r, c, aButts[k][1], aButts[k][2])
      c += ( LEN( aButts[k][1] ) + LEN( aButts[k][2] ) + ILeave )
   NEXT k

RETURN NIL


FUNCTION FootMsg(cMsg, blink)
   LOCAL handle, oldcol

   handle := WSELECT()
   WSELECT(0)
   if blink == NIL
      blink := .F.
   endif
   oldcol := SETCOLOR( if(blink, "n*/w", "n/w"))
   SAYmoveIn( CENTER(cMsg, 78, " ", .T.), 2, 24, 1, .T.)
   SetColor(oldcol)
   WSelect(handle)
RETURN NIL





FUNCTION PushButton()
   PARAMETERS r, c, cFunc, cKey

   LOCAL FLen := LEN(cFunc)
   LOCAL KLen := LEN(cKey)
   LOCAL oldcol := SetColor("BG+/B")

   @ r,c say cFunc
   SetColor("GR+/B")
   @ r,c + FLen SAY cKey

   // Let's shadow!
   SetColor("n+/w")
   @ r,c + FLen + KLen SAY "‹"
   @ r+1, c+1 say REPLICATE("ﬂ", FLen + KLen)

   SetColor(oldcol)
   RETURN NIL



PROCEDURE OK(cProc, nLine, cVar)
   Set KEY K_F10 TO
   Keyboard chr(K_PGDN)
   Set KEY K_F10 TO OK
   return


FUNCTION EmptyTime(cTime)
   local retval := .F.
   IF empty(cTime) .OR. cTime == "  " + "'" + "  " + '"' + "  "
      retval := .T.
   ENDIF
   return retval



FUNCTION SaySocName(cod)
   local oldcol, retval := .F.
   local oldarea := SELECT()

   SELECT Societa
   GO TOP
   Set ORDER to 1
   SEEK cod
   if found()
      oldcol := SetColor("R/W")
      @ 1,27 say Societa->Nome
      SetColor(oldcol)
      retval := .T.
   ENDIF
   SELECT(oldarea)
   RETURN retval


PROCEDURE Cancella(cProc, nLine, cVar)
   local oldcurs := SetCursor(SC_NONE)
   Set KEY K_F4 TO
   IF AskDel()
      Delete
      Keyboard chr(K_PGDN)
   ENDIF
   SetCursor(oldcurs)
   Set KEY K_F4 TO Cancella
   return



FUNCTION ERR_NotFound()
   local oldcol, oldcursor := SetCursor(SC_NONE)

   oldcol := SetColor("R+/R")
   WOpen(11,21, 13,55)
   WBox(WB_SINGLE)

   SetColor("GR+/R")
   @ 0,1 SAY "Codice Non Trovato - Reinserire"
   INKEY(3)
   WClose()
   SetColor(oldcol)
   SetCursor(oldcursor)
   RETURN NIL


FUNCTION Func_NA()
   WOpen(10,10,14,50)
   WBox(WB_DOUBLE_CLEAR)
   ? "   Funzione non ancora disponibile!"
   inkey(0)
   WClose()
   RETURN NIL


FUNCTION ConfExit()
   LOCAL retval := .F.
   LOCAL oldcol := SetColor("N/W")

   WOpen(09,29,14,53)
   WBox(WB_SINGLE)

   @ 0,4 say "Fine sessione?"
   ButtsRow(2, 0, 22, { { "Sç", "<S>" }, {"No", "<N>"} } )
   Inkey(0)
   IF Upper(Chr(LastKey())) == 'S'
      retval = .T.
   ENDIF
   WClose()
   SetColor("N/W")
   RETURN retval



FUNCTION GoodBye()
   FootMsg( " Chiusura Sessione ")
   SETCOLOR("+GR/G")
   WOPEN(10,29,14,53)
   WBOX(WB_SINGLE_CLEAR)
   SET CURSOR OFF
   SETCOLOR("+GR*/G")
   @ 1, 1 say "A R R I V E D E R C I"
   inkey(2)
   WCLOSE()
RETURN NIL



/*
   OptBox:
   visualizza una finestra di opzioni attivabili, processa l'interazione con
   l'utente e torna i valori modificati.
   Parametri:
      ur,uc,lr,lc:   coordinate angoli della box
      framecolor:    stringa colore cornice box
      boxcolor:      stringa colore interno box
      title:         stringa titolo finestra
      aOptions:      array descrittori opzioni;
                     { {r,c,text}, {r,c,text}...}
      aValues:       array valori booleani opzioni (da passare per reference)
   Ritorna:
      Valore logico TRUE se la options box e' stata terminata da un return,
      FALSE se abortita con ESC
*/

FUNCTION OptBox(ur, uc, lr, lc, framecolor, boxcolor, title, aOptions, aValues)
   local oldvalues := ACLONE(aValues)
   local oldcursor := SetCursor()
   local oldcolor := SetColor()
   local key, nOpt, retval := .T.
   local bSayOptions := { ;
      |a| ;
      SETPOS(a[1], a[2]), ;
      QQOUT("[ ] ", a[3]) ;
      }
   local bSayValues := { ;
      |a, idx | ;
      SETPOS(aOptions[idx][1], aOptions[idx][2] + 1), ;
      if (a, QQOUT("X"), QQOUT(" ")) ;
      }

   SetColor(framecolor)
   WOpen(ur, uc, lr, lc)
   WBox(WB_SINGLE)
   @ -1, ((lc-uc+1 - len(Title)) / 2)-1  SAY Title

   SetColor(boxcolor)
   CLS

   aeval(aOptions, bSayOptions)
   aeval(aValues, bSayValues )

   SetCursor(SC_SPECIAL1)
   nOpt := 1
   while (.T.)
      SETPOS(aOptions[nOpt][1], aOptions[nOpt][2] + 1)
      key := INKEY(0)
      do case
         case key == K_UP .OR. key == K_SH_TAB
            nOpt := if (nOpt > 1, nOpt-1, LEN(aOptions))
         case key == K_DOWN .OR. key == K_TAB
            nOpt := if (nOpt < LEN(aOptions), nOpt+1, 1)
         case key == K_SPACE
            aValues[nOpt] := !aValues[nOpt]
            if (aValues[nOpt], QQOUT("X"), QQOUT(" "))
         case key == K_ESC
            ACOPY(oldvalues, aValues)
            retval := .F.
            EXIT
         case key == K_RETURN
            EXIT
      endcase
   enddo
   Wclose()
   SetCursor(oldcursor)
   SetColor(oldcolor)
   return retval



