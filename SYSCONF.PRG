// SysConf.Prg

#include "NT2Win.ch"
#include "Inkey.ch"
#include "achoice.ch"

#define MY_HSEP      "мям"
#define MY_CSEP      " Ё "


FUNCTION SysConf
   LOCAL MenuBox, acMenuItems[5], Choice

   SETCOLOR("R/W")
   MenuBox := WOPEN(11,26, 15,53)
   WBOX(WB_SINGLE_CLEAR)

   SetColor("B/W")
   @ -1, 0 SAY ' CONFIGURAZIONE SISTEMA '

   acMenuItems[1] = ' Porte di Comunicazione '
   acMenuItems[2] = ' Parametri Hosts Locali '
   acMenuItems[3] = ' Orari di Chiamata      '
   Choice := 1

   DO WHILE .T.
      FootMsg( " ESC-Uscita  -Selezione  INVIO-Conferma " )

      SETCOLOR("N/W")
      Choice := ACHOICE(0,0, 3, 36, acMenuItems,,"MenuFunc", Choice)

      DO CASE

         CASE ( Choice == 1 )
            FootMsg( " Configurazione Porte Seriali " )
            ComConf()

         CASE ( Choice == 2 )
            FootMsg( " Configurazione Parametri Hosts Locali " )
            HostConf()

         CASE ( Choice == 3 )
            FootMsg( " Impostazione defaults Orari di Chiamata " )
            TimesConf()

         OTHERWISE
            IF LastKey() == K_ESC
               EXIT
            ELSE
               WOpen(10,10,15,50)
               WBox(WB_DOUBLE_CLEAR)
               ? "Funzione non ancora disponibile!"
               inkey(0)
               WClose()
            ENDIF

      ENDCASE

   ENDDO
   WClose()
RETURN NIL



FUNCTION ComConf
   local b, column, cType, n
   local cColorSave, nCursSave
   local lMore, nKey, meth_no
   local nTop, nLeft, nBottom, nRight
   local Buts :=  { ;
         { "Modifica", "<ENTER>" }, ;
         { "OK", "<F10>" } ;
      }

   local tb_methods := { ;
         {K_DOWN,       {|b| b:down()}}, ;
         {K_UP,         {|b| b:up()}}, ;
         {K_LEFT,       {|b| b:left()}}, ;
         {K_RIGHT,      {|b| b:right()}}, ;
         {K_CTRL_PGUP,  {|b| b:gotop() }},;
         {K_CTRL_PGDN,  {|b| b:gobottom() }},;
         {K_PGDN,       {|b| b:pagedown()}}, ;
         {K_PGUP,       {|b| b:pageup()}}, ;
         {K_HOME,       {|b| b:gotop()}}, ;
         {K_END,        {|b| b:gobottom()}} }

   SELECT Porte
   GO TOP
   WOpen(13,9, 21,71)
   WBox(WB_SINGLE)
   SetColor("R/W")
   // @ 0,2  say "#   BAUDRATE   DATABITS   STOPBITS   PARITA' "
   @ 0,2  say "#"

   SetColor("b/W")
   @ 1,2  say "1"
   @ 2,2  say "2"
   @ 3,2  say "3"

   nTop := 0
   nLeft := 6
   nBottom := 3
   nRight := 56

   SetColor("GR+/R")
   @ -1, 20 SAY " CONFIGURAZIONE PORTE "

   ButtsRow(5, 0, 60, Buts)


   SetColor("N/W")


   /* make new browse object */
   b := TBrowseDB(nTop, nLeft, nBottom, nRight)

   /* default heading and column separators */
   // b:headSep := MY_HSEP
   // b:colSep := MY_CSEP

   b:autoLite := .T.

   /* add custom 'skipper' (to handle append mode) */
   // b:skipBlock := {|x| Skipper(x, lAppend)}

   /* colors */
   b:colorSpec := "N/BG, GR+/RB, W+/BG, B/BG, B/W, B/BG, BG+/BG, B/R"

   column := TBColumnNew(" BAUDRATE ", {|| PADC(Porte->BAUDRATE, 9)} )
   column:defColor := {7, 2}
   column:colorBlock := { |x| {1, 2} }
   column:width := 9
   b:addColumn(column)

   column := TBColumnNew(" DATABITS ", {|| PADC(Porte->DATABITS, 9)}  )
   column:defColor := {7, 2}
   column:colorBlock := { |x| {1, 2} }
   column:width := 9
   b:addColumn(column)

   column := TBColumnNew(" STOPBITS ", {|| PADC(Porte->STOPBITS, 9)} )
   column:defColor := {7, 2}
   column:colorBlock := { |x| {1, 2} }
   column:width := 9
   b:addColumn(column)

   column := TBColumnNew(" PARITA' ", {|| PADC(Porte->PARITA, 9)} )
   column:defColor := {7, 2}
   column:colorBlock := { |x| {1, 2} }
   column:width := 9
   b:addColumn(column)

   column := TBColumnNew(" SISTEMA ", {|| PADC(Porte->SISTEMA, 9)} )
   column:defColor := {7, 2}
   column:colorBlock := { |x| {1, 2} }
   column:width := 9
   b:addColumn(column)

   nCursSave := SetCursor(0)

   lMore := .t.
   while (lMore)

      while ( !b:stabilize() )
         nKey := InKey()
         if ( nKey != 0 )
            exit        /* (abort if a key is waiting) */
         endif
      enddo

      if ( b:stable )
         nKey := InKey(0)
      endif

      meth_no = ascan( tb_methods,{|elem| nKey = elem[1]})
		if meth_no != 0
	  		eval( tb_methods[meth_no,2],b)
		else
         // process special key
         do case
            case ( nKey == K_F10 .or. nKey == K_ESC)
               lMore := .f.

            case ( nKey == K_ENTER )  // space bar
               do case
                  case ( b:colPos == 1 )
                     AskBaud()

                  case ( b:colPos == 2 )
                     AskData()

                  case ( b:colPos == 3 )
                     AskStop()

                  case ( b:colPos == 4 )
                     AskParity()

                  case ( b:colPos == 5 )
                     AskSistema()

               endcase
               b:refreshAll()
         endcase
      endif

   end

   SetCursor(nCursSave)

   WClose()
   RETURN NIL



FUNCTION AskBaud()
   local tabby := { " 150   ", " 300   ", " 1200  ", ;
                    " 2400  ", " 4800  ", " 9600  ", ;
                    " 19200 ", " 38400 ", " 57600 " }
   local choice, oldcolor

   oldcolor := SetColor()
   SetColor("N/BG", "GR+/RB")
   WOpen(10,4, 20,12)
   WBox(WB_SINGLE)
   choice := ACHOICE(0,0, 8,8, tabby, , "MenuFunc", ASCAN(tabby, Porte->BaudRate) )
   if ( choice > 0 )
      replace Porte->BaudRate WITH tabby[ choice ]
   endif
   WClose()
   SetColor(oldcolor)
   RETURN NIL


FUNCTION AskData()
   local tabby := { " 7 ", " 8 " }
   local choice, oldcolor

   oldcolor := SetColor()
   SetColor("N/BG", "GR+/RB")
   WOpen(15,25, 18,29)
   WBox(WB_SINGLE)
   choice := ACHOICE(0,0, 2,4, tabby, , "MenuFunc", ASCAN(tabby, Porte->DataBits) )
   if ( choice > 0 )
      replace Porte->DataBits WITH tabby[ choice ]
   endif
   WClose()
   SetColor(oldcolor)
   RETURN NIL


FUNCTION AskStop()
   local tabby := { " 1 ", " 2 " }
   local choice, oldcolor

   oldcolor := SetColor()
   SetColor("N/BG", "GR+/RB")
   WOpen(15,35, 18,39)
   WBox(WB_SINGLE)
   choice := ACHOICE(0,0, 2,4, tabby, , "MenuFunc", ASCAN(tabby, Porte->StopBits) )
   if ( choice > 0 )
      replace Porte->StopBits WITH tabby[ choice ]
   endif
   WClose()
   SetColor(oldcolor)
   RETURN NIL


FUNCTION AskParity()
   local tabby := { " N ", " E " , " O " }
   local choice, oldcolor

   oldcolor := SetColor()
   SetColor("N/BG", "GR+/RB")
   WOpen(13,45, 17,49)
   WBox(WB_SINGLE)
   choice := ACHOICE(0,0, 3,4, tabby, , "MenuFunc", ASCAN(tabby, Porte->Parita) )
   if ( choice > 0 )
      replace Porte->Parita WITH tabby[ choice ]
   endif
   WClose()
   SetColor(oldcolor)
   RETURN NIL



FUNCTION AskSistema()
   local tabby := { " Ericsson ", " Host A " , " Host B " }
   local choice, oldcolor

   oldcolor := SetColor()
   SetColor("N/BG", "GR+/RB")
   WOpen(13,45, 17,56)
   WBox(WB_SINGLE)
   choice := ACHOICE(0,0, 3,12, tabby, , "MenuFunc", ASCAN(tabby, Porte->Sistema) )
   if ( choice > 0 )
      replace Porte->Sistema WITH tabby[ choice ]
   endif
   WClose()
   SetColor(oldcolor)
   RETURN NIL





FUNCTION HostConf
   local b, column, cType, n
   local cColorSave, nCursSave
   local lMore, nKey, meth_no
   local nTop, nLeft, nBottom, nRight
   local Buts :=  { ;
         { "Naviga", "<" + chr(27) + chr(25) + chr(24) + chr(26) + ">" }, ;
         { "Modifica", "<ENTER>" }, ;
         { "OK", "<F10>" } ;
      }


   local tb_methods := { ;
         {K_LEFT,       {|b| b:left()}}, ;
         {K_RIGHT,      {|b| b:right()}}, ;
         {K_PGDN,       {|b| b:pagedown()}}, ;
         {K_PGUP,       {|b| b:pageup()}}, ;
         {K_HOME,       {|b| b:home()}}, ;
         {K_DOWN,       {|b| b:down()}}, ;
         {K_UP,         {|b| b:up()}}, ;
         {K_END,        {|b| b:end()}} }


   SELECT Hosts
   GO TOP

   SetColor("N/W")
   WOpen(14,7, 22,71)
   WBox(WB_SINGLE)

   nTop := 0
   nLeft := 2
   nBottom := 3
   nRight := 60

   SetColor("GR+/R")
   @ -1, 19 SAY " Configurazione Hosts "
   SetColor("N/W")

   ButtsRow(5, 0, 57, Buts)

   /* make new browse object */
   b := TBrowseDB(nTop, nLeft, nBottom, nRight)

   /* default heading and column separators */
   b:headSep := MY_HSEP
   b:colSep := MY_CSEP
   b:autoLite := .T.

   /* colors */
   b:colorSpec := "N/BG, GR+/RB, W+/BG, B/BG, B/W, B/BG, R/W, B/R"

   column := TBColumnNew("NOME", FieldWBlock("NOME", Select())  )
   column:defColor := {1, 2}
   b:addColumn(column)

   column := TBColumnNew("RICHIESTA LOGIN", FieldWBlock("LOG_STRING", Select()) )
   column:defColor := {1, 2}
   b:addColumn(column)

   column := TBColumnNew("NOME DI LOGIN", FieldWBlock("LOG_NAME", Select()) )
   column:defColor := {1, 2}
   b:addColumn(column)

   column := TBColumnNew("PROMPT", FieldWBlock("LOG_PROMPT", Select()) )
   column:defColor := {1, 2}
   b:addColumn(column)

   column := TBColumnNew("COMANDO RICHIESTA INVIO FILE", FieldWBlock("SEND_CMD", Select()) )
   column:defColor := {1, 2}
   column:cargo := "@!S50"
   column:width := 50
   b:addColumn(column)

   column := TBColumnNew("COMANDO RICHIESTA RICEZIONE FILE", FieldWBlock("RECEIV_CMD", Select())  )
   column:defColor := {1, 2}
   column:cargo := "@!S50"
   column:width := 50
   b:addColumn(column)

   b:freeze := 1

   nCursSave := SetCursor(0)

   lMore := .t.
   b:colPos := 2

   while (lMore)

      if b:colPos == 1
         b:colPos := 2
      endif


      while ( !b:stabilize() )
         nKey := InKey()
         if ( nKey != 0 )
            exit        /* (abort if a key is waiting) */
         end
      end

      if ( b:stable )
         if ( b:hitTop .or. b:hitBottom )
            Tone(125, 0)
         end

         /* everything's done; just wait for a key */
         nKey := InKey(0)

      end

      meth_no = ascan( tb_methods,{|elem| nKey = elem[1]})
		if meth_no != 0
	  		eval( tb_methods[meth_no,2],b)
		else
         // process special key
         do case

            case ( nKey == K_F10 .or. nKey == K_ESC)
               lMore := .f.

            case ( nKey == K_RETURN )
               DoGet(b, .F.)

            otherwise
               IF IsDigit(Chr(nKey)) .or. IsAlpha(CHr(nKey))
                  KEYBOARD( Chr(nKey) )
                  DoGet(b, .F.)
               ENDIF

         endcase

      endif

   end

   SetCursor(nCursSave)

   WClose()
   return NIL



FUNCTION TimesConf()
   MEMVAR OraInizio, OraFine, GetList
   LOCAL oldcolor := SETCOLOR()

   USE Config NEW
   OraInizio := Config->C_oraIniz
   OraFine   := Config->C_oraFine


   SETCOLOR("R/W")
   WOPEN(15,27, 18,51)
   WBOX(WB_SINGLE_CLEAR)

   SetColor("GR+/R")
   @ -1, 2 SAY ' ORARI DI CHIAMATA '
   SetColor("N/W")
   @  0, 1 say "Ora di Inizio: " Get OraInizio PICT "99:99"  VALID TimeValid(OraInizio)
   @  1, 1 say "Ora di Fine  : " Get OraFine   PICT "99:99"  VALID TimeValid(OraFine)
   SET Cursor ON
   read
   SET Cursor OFF

   if lastkey() != K_ESC
      REPLACE Config->C_oraIniz WITH OraInizio
      REPLACE Config->C_oraFine WITH OraFine
   endif
   use
   WClose()
   SetColor(oldcolor)
   RETURN NIL



