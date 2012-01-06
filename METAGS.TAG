ÄÄ´ ATLETI.PRG    ÃÄÄÄÄÄÄ´ 19/04/95 22.28 ÃÄÄÄÄÄÄÄþDT=512996241þPATH=C:\SIGNA\
AtletaADD                                                 FUNCTION AtletaADD()
AtletiEdit                                                FUNCTION AtletiEdit( InsertMode )
CheckCateg                                                FUNCTION CheckCateg()
CheckNome                                                 FUNCTION CheckNome()
DrawTitles                                                STATIC FUNCTION DrawTitles()
LookUp                                                    static PROCEDURE LookUp(cProc, nLine, cVar)
PreAnno                                                   FUNCTION PreAnno()
PreCateg                                                  FUNCTION PreCateg()    // precalcolo categoria atleta dall'anno di nascita
                                                            þ
ÄÄ´ CARTELLI.PRG  ÃÄÄÄÄÄÄ´ 21/04/95 18.54 ÃÄÄÄÄÄÄÄþDT=513119960þPATH=C:\SIGNA\
Cards                                                     FUNCTION Cards(bEject, cAnno, cCat, cDist, cStile, cTempo, cNome, cCod1, cSoc, cCod2)
initstring                                                static FUNCTION initstring()
                                                            þ
ÄÄ´ CONVERT.PRG   ÃÄÄÄÄÄÄ´ 24/04/95 12.50 ÃÄÄÄÄÄÄÄþDT=513304131þPATH=C:\SIGNA\
scan_480                                                  function scan_480
                                                            þ
ÄÄ´ FILLATL.PRG   ÃÄÄÄÄÄÄ´ 08/04/94 01.47 ÃÄÄÄÄÄÄÄþDT=478678511þPATH=C:\SIGNA\
pickcogn                                                  function pickcogn()
pickname                                                  function pickname()
scan_480		function scan_480
                                                            þ
ÄÄ´ OPTIONS.PRG   ÃÄÄÄÄÄÄ´ 03/07/94 18.16 ÃÄÄÄÄÄÄÄþDT=484676111þPATH=C:\SIGNA\
OptBox                                                    FUNCTION OptBox(ur, uc, lr, lc, framecolor, boxcolor, title, aOptions, aValues)
scan_480		function scan_480
                                                            þ
ÄÄ´ SIGNA.PRG     ÃÄÄÄÄÄÄ´ 24/04/95 14.33 ÃÄÄÄÄÄÄÄþDT=513307699þPATH=C:\SIGNA\
AskPassword                                               FUNCTION AskPassword(password)
CleanUp                                                   FUNCTION CleanUp()
CloseAtleti                                               FUNCTION CloseAtleti()
CloseStaffette                                            FUNCTION CloseStaffette()
Hello                                                     FUNCTION Hello()
InitScreen                                                FUNCTION InitScreen()
MenuAtleti                                                FUNCTION MenuAtleti()
MenuMain                                                  FUNCTION MenuMain
MenuStaffette                                             FUNCTION MenuStaffette()
MenuTempi                                                 FUNCTION MenuTempi()
OpenAtleti                                                FUNCTION OpenAtleti()
OpenStaffette                                             FUNCTION OpenStaffette()
SCAN_480                                                  function SCAN_480
SetFiles                                                  FUNCTION SetFiles()
Signa                                                     FUNCTION Signa()
                                                            þ
ÄÄ´ SOCIETA.PRG   ÃÄÄÄÄÄÄ´ 01/07/94 19.48 ÃÄÄÄÄÄÄÄþDT=484548108þPATH=C:\SIGNA\
SOC_AddPunti                                              FUNCTION SOC_AddPunti(sCod, nPunti)
SOC_FlushPunti                                            FUNCTION SOC_FlushPunti()
SOC_GetName                                               FUNCTION SOC_GetName(mCodice)
SOC_IsRegional		FUNCTION SOC_IsRegional(mCodice)
Soc_DoGet                                                 func Soc_DoGet(b, lAppend)
TabSocieta                                                FUNCTION TabSocieta(oldcodice)
                                                            þ
ÄÄ´ SPECIAL.PRG   ÃÄÄÄÄÄÄ´ 07/07/94 10.58 ÃÄÄÄÄÄÄÄþDT=484923212þPATH=C:\SIGNA\
CheckRow                                                  Function CheckRow(r)
CloseAtleti                                               FUNCTION CloseAtleti()
OpenAtleti                                                FUNCTION OpenAtleti()
PrintScores                                               FUNCTION PrintScores( title, _tempo, _punti )
SCAN_480                                                  function SCAN_480
SetFiles                                                  FUNCTION SetFiles()
special                                                   function special
                                                            þ
ÄÄ´ STAFFETT.PRG  ÃÄÄÄÄÄÄ´ 04/07/94 13.05 ÃÄÄÄÄÄÄÄþDT=484731049þPATH=C:\SIGNA\
DrawTitles                                                STATIC FUNCTION DrawTitles()
LookUp                                                    static PROCEDURE LookUp(cProc, nLine, cVar)
StaffettaADD                                              FUNCTION StaffettaADD()
StaffetteEdit                                             FUNCTION StaffetteEdit( InsertMode )
                                                            þ
ÄÄ´ STAMPE.PRG    ÃÄÄÄÄÄÄ´ 24/04/95 13.34 ÃÄÄÄÄÄÄÄþDT=513305692þPATH=C:\SIGNA\
CalcScores                                                FUNCTION CalcScores( _src, _dst )
CalcStaffs                                                FUNCTION CalcStaffs( _src, _dst )
CheckPrinter                                              FUNCTION CheckPrinter()
CheckRow                                                  STATIC Function CheckRow(r)
ClassSocGara                                              FUNCTION ClassSocGara()
DispMsg                                                   FUNCTION DispMsg(msg)
FindLongest                                               STATIC Function FindLongest()
PrintMenu                                                 FUNCTION PrintMenu()
PrintScores                                               FUNCTION PrintScores( title, _tempo, _punti )
PrintStaffs                                               FUNCTION PrintStaffs( title, _tempo, _punti )
ST_Cartellini                                             FUNCTION ST_Cartellini()
ST_ClassAtl                                               FUNCTION ST_ClassAtl()
ST_ClassSoc                                               FUNCTION ST_ClassSoc()
ST_EleCods                                                FUNCTION ST_EleCods()
ST_EleIscr                                                FUNCTION ST_EleIscr()
ST_EleSoc		FUNCTION ST_EleSoc()
                                                            þ
ÄÄ´ SYSCONF.PRG   ÃÄÄÄÄÄÄ´ 24/04/95 13.34 ÃÄÄÄÄÄÄÄþDT=513305692þPATH=C:\SIGNA\
AskBaud                                                   FUNCTION AskBaud()
AskData                                                   FUNCTION AskData()
AskParity                                                 FUNCTION AskParity()
AskSistema                                                FUNCTION AskSistema()
AskStop                                                   FUNCTION AskStop()
ComConf                                                   FUNCTION ComConf
HostConf                                                  FUNCTION HostConf
SysConf                                                   FUNCTION SysConf
TimesConf		FUNCTION TimesConf()
                                                            þ
ÄÄ´ TAGBROW.PRG   ÃÄÄÄÄÄÄ´ 08/09/93 17.20 ÃÄÄÄÄÄÄÄþDT=455641746þPATH=C:\SIGNA\
CopyInList                                                FUNCTION CopyInList(nCodice)
DelInList                                                 FUNCTION DelInList(nCodice)
InList                                                    FUNCTION InList(nCodice)
SayCount                                                  FUNCTION SayCount(nSel, nTot)
tagbrow                                                   function tagbrow( cFieldName, cColName, nTop, nLeft, lMessage, cTitle)
                                                            þ
ÄÄ´ TAGTEST.PRG   ÃÄÄÄÄÄÄ´ 08/09/93 17.20 ÃÄÄÄÄÄÄÄþDT=455641746þPATH=C:\SIGNA\
main                                                      func main()
                                                            þ
ÄÄ´ TEMPI.PRG     ÃÄÄÄÄÄÄ´ 20/04/95 00.45 ÃÄÄÄÄÄÄÄþDT=513017274þPATH=C:\SIGNA\
AtletiTitles                                              STATIC FUNCTION AtletiTitles()
StaffetteTitles                                           STATIC FUNCTION StaffetteTitles()
TempiAtleti                                               FUNCTION TempiAtleti( )
TempiStaffette                                            FUNCTION TempiStaffette( )
                                                            þ
ÄÄ´ TEST.PRG      ÃÄÄÄÄÄÄ´ 24/04/95 19.30 ÃÄÄÄÄÄÄÄþDT=513317849þPATH=C:\SIGNA\
scan_480                                                  function scan_480
test                                                      function test
trap                                                      procedure trap(nkey)
                                                            þ
ÄÄ´ UTILS.PRG     ÃÄÄÄÄÄÄ´ 24/04/95 13.34 ÃÄÄÄÄÄÄÄþDT=513305692þPATH=C:\SIGNA\
AskDel                                                    FUNCTION AskDel
ButtsRow                                                  FUNCTION ButtsRow(r, c, wid, aButts)
Cancella                                                  PROCEDURE Cancella(cProc, nLine, cVar)
ConfExit                                                  FUNCTION ConfExit()
ERR_NotFound                                              FUNCTION ERR_NotFound()
EmptyTime                                                 FUNCTION EmptyTime(cTime)
FootMsg                                                   FUNCTION FootMsg(cMsg, blink)
Func_NA                                                   FUNCTION Func_NA()
GoodBye                                                   FUNCTION GoodBye()
MenuFunc                                                  FUNCTION MenuFunc
OK                                                        PROCEDURE OK(cProc, nLine, cVar)
OptBox                                                    FUNCTION OptBox(ur, uc, lr, lc, framecolor, boxcolor, title, aOptions, aValues)
PushButton                                                FUNCTION PushButton()
SaySocName                                                FUNCTION SaySocName(cod)
Skipper                                                   func Skipper(n, lAppend)
