// Societa.Prg

#include "inkey.ch"
#include "setcurs.ch"
#include "nt2win.ch"


#define MY_HSEP      "мям"
#define MY_CSEP      " Ё "



FUNCTION TabSocieta(oldcodice)
   static memrec := -1
   local b, column, cType, n
   local cColorSave, nCursSave, nAreaSave := SELECT()
   local lMore, nKey, lAppend, meth_no
   local nTop, nLeft, nBottom, nRight
   local Buts1 :=  { ;
         { "<", chr(25) + chr(24) + " PgUp PgDn>" }, ;
         { "Nuovo", "<F2>" }, ;
         { "Modifica", "<Spazio>" }  ;
      }

   local Buts2 :=  { ;
         { "Regionale", "<F3>" },  ;
         { "Cancella", "<Del>" }, ;
         { "OK", "<Invio>" } ;
      }



   local tb_methods := { ;
         {K_LEFT,       {|b| if(b:colPos > 3, b:left(), )}  }, ;
         {K_RIGHT,      {|b| b:right()}}, ;
         {K_PGDN,       {|b| b:pagedown()}}, ;
         {K_HOME,       {|b| b:home()}}, ;
         {K_END,        {|b| b:end()}} }


   SELECT Societa
   SET ORDER TO 2
   if memrec == -1
      go top
   else
      GO memrec
   endif


   SetColor("N/W")
   WOpen(1,2, 23,46)
   WBox(WB_SINGLE)

   nTop := 0
   nLeft := 0
   nBottom := 15
   nRight := 42

   SetColor("GR+/R")
   @ -1, 12 SAY " TABELLA SOCIETA' "
   SetColor("N/W")

   ButtsRow(17, 0, 41, Buts1)
   ButtsRow(19, 0, 41, Buts2)

   /* make new browse object */
   b := TBrowseDB(nTop, nLeft, nBottom, nRight)

   /* default heading and column separators */
   b:headSep := MY_HSEP
   b:colSep := MY_CSEP
   b:autoLite := .T.

   /* add custom 'skipper' (to handle append mode) */
   b:skipBlock := {|x| Skipper(x, lAppend)}

   /* colors */
   b:colorSpec := "N/BG, GR+/RB, W+/BG, B/BG, B/W, B/BG, R/W, B/R"


   column := TBColumnNew("COD.", { || IF (val(Societa->Codice) > 0, Societa->Codice, "   ") }  )
   column:defColor := {3, 2}
   b:addColumn(column)

   column := TBColumnNew("R.", { || IF (!empty(Societa->Toscana), "Ш", " ") }  )
   column:defColor := {3, 2}
   b:addColumn(column)

   column := TBColumnNew("NOME", FieldWBlock("NOME", Select())  )
   column:defColor := {1, 2}
   b:addColumn(column)

   b:freeze := 2
   nCursSave := SetCursor(0)
   lAppend := .f.
   b:colPos := 3
   lMore := .t.
   while (lMore)

/*
      while ( !b:stabilize() )
         nKey := InKey()
         if ( nKey != 0 )
            exit        // (abort if a key is waiting)
         end
      end
*/

      while ( !b:stabilize() )
      end

      if ( b:stable )
         /* display is stable */
         if ( b:hitBottom .and. !lAppend )
            /* banged against EOF; go into append mode */
            lAppend := .t.
            nKey := K_DOWN

         else
            if ( b:hitTop .or. b:hitBottom )
               Tone(125, 0)
            end

            /* everything's done; just wait for a key */
            nKey := InKey(0)

         end
      end

      meth_no = ascan( tb_methods,{|elem| nKey = elem[1]})
		if meth_no != 0
	  		eval( tb_methods[meth_no,2],b)
		else
         // process special key
         do case
            case ( nKey == K_DOWN )
               b:down()
               IF lAppend
                  Soc_DoGet(b, lAppend)
                  lAppend := .f.
               ENDIF

            case ( nKey == K_UP )
               b:up()
               if ( lAppend )
                  lAppend := .f.
                  b:refreshAll()
               end

            case ( nKey == K_PGUP )
               b:pageUp()
               if ( lAppend )
                  lAppend := .f.
                  b:refreshAll()
               end

            case ( nKey == K_CTRL_PGUP )
               b:goTop()
               lAppend := .f.

            case ( nKey == K_CTRL_PGDN )
               b:goBottom()
               lAppend := .f.

            case ( nKey == K_RETURN )
               lMore := .f.

            case ( nKey == K_ESC )
               set order to 1
               seek oldcodice
               lMore := .f.

            case ( nKey == K_SPACE )
               Soc_DoGet(b, lAppend)

            case ( nKey == K_DEL )
               IF !Eof()
                  IF AskDel()          // Cancellazione con conferma
                     SELECT Societa
                     Delete
                     skip -1
                  ENDIF
                  b:refreshAll()
               ENDIF

            case ( nKey == K_F2 )
               b:goBottom()
               KEYBOARD ( Chr(K_DOWN) )

            case ( nKey == K_F3 )
               if ( empty(societa->Toscana) )
                  replace societa->Toscana with 'x'
               else
                  replace societa->Toscana with ' '
               endif
               b:refreshAll()


            otherwise
               IF IsDigit(Chr(nKey)) .or. IsAlpha(CHr(nKey))
                  KEYBOARD( Chr(nKey) )
                  Soc_DoGet(b, lAppend)
               ENDIF

         endcase

      endif

   end

   SetCursor(nCursSave)
   SELECT(nAreaSave)
   WClose()
   memrec := recno()
   return Societa->Codice



****
*  Soc_DoGet()
*
func Soc_DoGet(b, lAppend)
   FIELD Codice
   local bInsSave, lScoreSave, lExitSave
   local column, get, nKey
   local nCodice, nOrder, i

   /* make sure browse is stable */
   while ( !b:stabilize() ) ; end

   /* if confirming new record, append blank */
   if ( lAppend .and. Recno() == LastRec() + 1 )
      nOrder := INDEXORD()
      SET ORDER TO 0
      go bottom
      nCodice := val(Societa->Codice) + 1
      set order to nOrder
      APPEND BLANK
      REPLACE Codice WITH alltrim(str(nCodice,3))
      b:colPos := 3
      b:refreshCurrent()
      while ( !b:stabilize() ) ; end
   else
      nCodice := val(Societa->Codice)
   end

   /* save state */
   lScoreSave := Set(_SET_SCOREBOARD, .f.)
   lExitSave := Set(_SET_EXIT, .t.)
   bInsSave := SetKey(K_INS)
   ReadInsert(.T.)

   /* set insert key to toggle insert mode and cursor */
   SetKey( K_INS, ;
      {|| SetCursor( if(ReadInsert(!ReadInsert()), SC_NORMAL, SC_INSERT))};
        )

   /* initial cursor setting */
   SetCursor( if(ReadInsert(), SC_INSERT, SC_NORMAL) )

   /* get column object from browse */
   column := b:getColumn(b:colPos)

   /* create a corresponding GET */
   get := GetNew(Row(), Col(), column:block, column:heading,column:cargo, b:colorSpec)

   /* read it */
   ReadModal( {get} )

   // restore state
   SetCursor(0)
   Set(_SET_SCOREBOARD, lScoreSave)
   Set(_SET_EXIT, lExitSave)
   SetKey(K_INS, bInsSave)

   IF Empty(Societa->Nome)
      DELETE
      go bottom
   else
      if b:ColPos == 3
         // contiamo quante skip servono
         i := 0
         Go Top
         while val(Codice) != nCodice
            skip
            ++ i
         end
         b:goTop()
         b:rowPos := 1
         keyboard(replicate(chr(K_DOWN), i))    // FIX: troppo lento su Atari PC piscina
      endif
      /*
      if lAppend
         keyboard(chr(K_RIGHT) + chr(K_ENTER) )
      endif
      */
   ENDIF

   // force redisplay
   b:refreshAll()

   // check exit key
   /*
   nKey := LastKey()
   if ( nKey == K_UP .or. nKey == K_DOWN .or. ;
      nKey == K_PGUP .or. nKey == K_PGDN )

      KEYBOARD( Chr(nKey) )
   end
   */

Return (NIL)



FUNCTION SOC_GetName(mCodice)
   local oldarea, oldindex, retval := NIL

   oldarea := select()
   select Societa
   oldindex := indexord()
   set order to 1
   seek mCodice
   if found()
      retval := Societa->Nome
   endif
   set order to oldindex
   select(oldarea)
   return retval


FUNCTION SOC_IsRegional(mCodice)
   local oldarea, oldindex, retval := .F.

   oldarea := select()
   select Societa
   oldindex := indexord()
   set order to 1
   seek mCodice
   if found()
      retval := IF (!empty(Societa->Toscana), .T., .F.)
   endif
   set order to oldindex
   select(oldarea)
   return retval



FUNCTION SOC_AddPunti(sCod, nPunti)
   local oldarea, oldindex

   oldarea := select()
   select Societa
   oldindex := indexord()
   set order to 1
   seek sCod
   if found()
      replace Societa->Punti WITH Societa->Punti + nPunti
   endif
   set order to oldindex
   select(oldarea)
   return NIL


FUNCTION SOC_FlushPunti()
   local oldarea, oldindex

   oldarea := select()
   select Societa
   oldindex := indexord()
   set order to 0
   REPLACE punti with 0 ALL
   set order to oldindex
   select(oldarea)
   return NIL


