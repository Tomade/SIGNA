// Options.prg
#include "nt2win.ch"
#include "setcurs.ch"
#include "inkey.ch"


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






function scan_480
return NIL
