/*
  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³  Application: TAGTEST.PRG                                                ³
  ³       Author: Nicholas Solomon                                           ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	compile:    clipper tagtest /a/n/w
					clipper tagbrow /a/n/w

	link:       rtlink fi tagtest, tagbrow

*/

#include "tagbrow.ch"

func main()
	local x, aRecsSelected:={}

	/* first create temp dbf */
	dbcreate( 'TAGBROW.DBF', { { 'TEST_SAMPLE', 'C', 15, 0 }} )
	use tagbrow alias tag exclusive new
	for x := 1 to 25
		dbappend()
		replace tag->test_sample with 'Choice ' + str(x,2)
	next
	dbgotop()

	cls
	/* now make call to tagbrow */
	create tagbrowse array aRecsSelected usefield 'test_sample' ;
		top 5 left 20 colname 'SELECT' ;
		title 'Tag Browse' message

	/* now display the contents of the selected items */
	cls
	? 'The selected (tagged) items: '
	? ''
	x:=0
	aeval( aRecsSelected, { |ele| dbgoto(ele), ;
								  QOUT( str(++x,2) + '. ' + ;
								  tag->test_sample ) } )

	dbcloseall()
	ferase('TAGBROW.DBF')
return (nil)

