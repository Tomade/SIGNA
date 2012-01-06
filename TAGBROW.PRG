/*
  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³  Application: Example of a tagging browse object                         ³
  ³    File Name: TAGBROW.PRG                                                ³
  ³       Author: Nicholas Solomon                                           ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

#include "inkey.ch"
#include "tagbrow.ch"
/*
  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³     Function: TAGBROW()                                                  ³
  ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³  Description: allow user a taggable browse pick object                   ³
  ³       Params: cFieldName   =  Name of field used for selection           ³
  ³                 cColName   =  Column header for above col. object        ³
  ³                     nTop   =  top row of object                          ³
  ³                    nLeft   =  left col of object                         ³
  ³                 lMessage   =  .t. = include message (default to .t.)     ³
  ³                   cTitle   =  title a box around the object              ³
  ³       Return: (aSelected) = record numbers of selected items             ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
function tagbrow( cFieldName, cColName, nTop, nLeft, lMessage, cTitle)
   local nTot, nSel
	local tb_methods := { ;
               	{K_DOWN,       {|b| b:down()}}, ;
               	{K_UP,         {|b| b:up()}}, ;
						{K_CTRL_PGUP,	{|b| b:gotop() }},;
						{K_CTRL_PGDN,	{|b| b:gobottom() }},;
               	{K_PGDN,       {|b| b:pagedown()}}, ;
               	{K_PGUP,       {|b| b:pageup()}}, ;
               	{K_HOME,       {|b| b:gotop()}}, ;
               	{K_END,        {|b| b:gobottom()}} }
   local meth_no, column
	local b,exit_request:=.f.,lkey,skey:="", nFound, cOldColor:=setcolor()
   local nLenField, bSelect
	local bField := fieldblock( cFieldName )

	DEFAULT cColName TO cFieldName
	DEFAULT lMessage TO .t.

   // Conta totali negozi gia' in lista   
   SELECT Lista
   COUNT FOR !Deleted() TO nSel
   GO TOP

   // Conta totali negozi   
   SELECT Negozi
   COUNT FOR !Deleted() TO nTot
   GO TOP

	/* get length of browse field to determine width of browse screen */
	nLenField := len(eval(bField))

	/* build a box if cTitle was passed - could be done better! */
	if cTitle != NIL
      @ nTop-1, nLeft-1 to maxrow()-3, nLeft + nLenField+1 color 'R/W'
		@ nTop-1, ( nLeft + ( int( (nLeft + nLenField) - (nLeft-1) ) / 2 ) ) - ;
					 ( int( len(cTitle)  / 2 ) ) - 1 say '´' + cTitle + 'Ã' ;
                color 'GR+/R'
	endif

	/* declare browse object */
   b := TBrowseDB( nTop, nLeft , maxrow(), nLeft + nLenField + 1)
   // b:headsep := "ÍÍÍ"
   // b:footsep := "ÍÍÍ"
   // b:colorspec := "W/B, N/W, R+/N, R+/W, W+/B, W/N, N/W"
   b:colorSpec := "N/BG, GR+/RB, W+/BG, W+/RB, B/W, B/BG, R/W, B/R"

	/*
		the first column MUST be the array for
		selected (tagged) record numbers
	*/
   column := TBColumnNew( ' ',;                             // Colonna checkmarks
      {|| iif( InList(NEGOZI->Codice),;
		 		CHECKMARK,' ') } )
	column:width:=1
   column:defColor   := { 6, 6 }
   column:colorBlock := {|| { 6, 6 } }
	b:addColumn( column )
	/*
		block to highlight selected vs. unselected items
	*/
   bSelect := {|| iif( InList(NEGOZI->Codice), ;
					{ 3, 4 } , { 1, 2 } ) }


   // column := TBColumnNew( cColName, bField )
   column := TBColumnNew( NIL, bField )                     // Colonna nome negozio
	column:defColor   := { 3,3}
	column:colorBlock := bSelect
	b:addColumn( column )
	/*
		freeze the first column - don't allow them to go into it
	*/
	b:freeze := 1
	dispbegin()
	do while !b:stabilize()   ;  enddo
	dispend()
	do while !exit_request
		/* keep 'em out of first column */
		if b:colPos <= b:freeze
			b:colPos := b:freeze + 1
		endif
		do while nextkey() = 0 .and. !b:stabilize() ; enddo
      SayCount(nSel, nTot)
		lkey = inkey( 0)
		meth_no = ascan( tb_methods,{|elem| lkey = elem[1]})
		if meth_no != 0
	  		eval( tb_methods[meth_no,2],b)
		else
  			do case
				/* deletes ALL selections */
            case lkey == K_DEL
               SELECT Lista
               ZAP
               PACK
               nSel := 0
               SELECT Negozi
					b:refreshall()

				/* select-unselect element */
            case lkey == 32
               if ( InList(NEGOZI->Codice) )
                  DelInList(NEGOZI->Codice)
                  --nSel
					else
                  CopyInList(NEGOZI->Codice)
                  ++nSel
					endif
					b:refreshcurrent()
               b:down()

            case lkey == K_F2
               IF InList(NEGOZI->Codice)
                  SELECT Lista
                  SEEK NEGOZI->Codice
                  EditFList()
                  SELECT Negozi
               ENDIF


            case lkey = K_F10 .or. lkey == K_ESC
        			exit_request = .T.

				/*
					this simply allows user to jump
					as alpha keys are typed --
					not much good in this example !

				case ( lkey > 47 .and. lkey < 123) .or. ;
						lkey = 32 .or. lkey = 39
		 			if ! dbseek( upper( chr( lkey)))
		    			dbgotop()
		 			endif
		 			b:refreshall()
            */
  			endcase
		endif
   enddo
   SELECT Lista
   PACK
   SELECT Negozi
	setcolor( cOldColor )
return NIL


FUNCTION SayCount(nSel, nTot)
   local oldcol := SetColor("N/W")
   local s := 'Selezionati: '+ alltrim(str(nSel)) + "/" + alltrim(str(nTot))
   @ 0, 0 say padc(s, 22)
   SetColor(oldcol)
RETURN NIL





FUNCTION InList(nCodice)
   LOCAL retval
   LOCAL nWorkArea := SELECT()

   SELECT Lista
   SEEK nCodice
   IF FOUND()
      retval := .T.
   ELSE
      retval := .F.
   ENDIF
   SELECT (nWorkArea)

RETURN retval



FUNCTION CopyInList(nCodice)
   LOCAL k
   LOCAL NomeNeg, Dir, NomeHost, Host

   SELECT Lista
   SEEK nCodice

   IF !FOUND()
      APPEND BLANK

      REPLACE  Codice WITH NEGOZI->Codice

      FOR k := 0 TO 9
         NomeNeg := "NOMENEG"  + str(k,1)
         Dir     := "DIR"      + str(k,1)
         NomeHost:= "NOMEHOST" + str(k,1)
         Host    := "HOST"     + str(k,1)

         REPLACE &NomeNeg  WITH NEGOZI-> &NomeNeg
         REPLACE &Dir      WITH NEGOZI-> &Dir
         REPLACE &NomeHost WITH NEGOZI-> &NomeHost
         REPLACE &Host     WITH NEGOZI-> &Host
      NEXT k
   ENDIF

   SELECT Negozi
RETURN NIL




FUNCTION DelInList(nCodice)

   SELECT Lista
   SEEK nCodice
   IF FOUND()
      DELETE
   ENDIF

   SELECT Negozi
RETURN NIL
