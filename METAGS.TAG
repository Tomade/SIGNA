�Ĵ ATLETI.PRG    ������Ĵ 19/04/95 22.28 ���������DT=512996241�PATH=C:\SIGNA\
AtletaADD                                                 FUNCTION AtletaADD()
AtletiEdit                                                FUNCTION AtletiEdit( InsertMode )
CheckCateg                                                FUNCTION CheckCateg()
CheckNome                                                 FUNCTION CheckNome()
DrawTitles                                                STATIC FUNCTION DrawTitles()
LookUp                                                    static PROCEDURE LookUp(cProc, nLine, cVar)
PreAnno                                                   FUNCTION PreAnno()
PreCateg                                                  FUNCTION PreCateg()    // precalcolo categoria atleta dall'anno di nascita
                                                            �
�Ĵ CARTELLI.PRG  ������Ĵ 21/04/95 18.54 ���������DT=513119960�PATH=C:\SIGNA\
Cards                                                     FUNCTION Cards(bEject, cAnno, cCat, cDist, cStile, cTempo, cNome, cCod1, cSoc, cCod2)
initstring                                                static FUNCTION initstring()
                                                            �
�Ĵ CONVERT.PRG   ������Ĵ 24/04/95 12.50 ���������DT=513304131�PATH=C:\SIGNA\
scan_480                                                  function scan_480
                                                            �
�Ĵ FILLATL.PRG   ������Ĵ 08/04/94 01.47 ���������DT=478678511�PATH=C:\SIGNA\
pickcogn                                                  function pickcogn()
pickname                                                  function pickname()
scan_480		function scan_480
                                                            �
�Ĵ OPTIONS.PRG   ������Ĵ 03/07/94 18.16 ���������DT=484676111�PATH=C:\SIGNA\
OptBox                                                    FUNCTION OptBox(ur, uc, lr, lc, framecolor, boxcolor, title, aOptions, aValues)
scan_480		function scan_480
                                                            �
�Ĵ SIGNA.PRG     ������Ĵ 24/04/95 14.33 ���������DT=513307699�PATH=C:\SIGNA\
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
                                                            �
�Ĵ SOCIETA.PRG   ������Ĵ 01/07/94 19.48 ���������DT=484548108�PATH=C:\SIGNA\
SOC_AddPunti                                              FUNCTION SOC_AddPunti(sCod, nPunti)
SOC_FlushPunti                                            FUNCTION SOC_FlushPunti()
SOC_GetName                                               FUNCTION SOC_GetName(mCodice)
SOC_IsRegional		FUNCTION SOC_IsRegional(mCodice)
Soc_DoGet                                                 func Soc_DoGet(b, lAppend)
TabSocieta                                                FUNCTION TabSocieta(oldcodice)
                                                            �
�Ĵ SPECIAL.PRG   ������Ĵ 07/07/94 10.58 ���������DT=484923212�PATH=C:\SIGNA\
CheckRow                                                  Function CheckRow(r)
CloseAtleti                                               FUNCTION CloseAtleti()
OpenAtleti                                                FUNCTION OpenAtleti()
PrintScores                                               FUNCTION PrintScores( title, _tempo, _punti )
SCAN_480                                                  function SCAN_480
SetFiles                                                  FUNCTION SetFiles()
special                                                   function special
                                                            �
�Ĵ STAFFETT.PRG  ������Ĵ 04/07/94 13.05 ���������DT=484731049�PATH=C:\SIGNA\
DrawTitles                                                STATIC FUNCTION DrawTitles()
LookUp                                                    static PROCEDURE LookUp(cProc, nLine, cVar)
StaffettaADD                                              FUNCTION StaffettaADD()
StaffetteEdit                                             FUNCTION StaffetteEdit( InsertMode )
                                                            �
�Ĵ STAMPE.PRG    ������Ĵ 24/04/95 13.34 ���������DT=513305692�PATH=C:\SIGNA\
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
                                                            �
�Ĵ SYSCONF.PRG   ������Ĵ 24/04/95 13.34 ���������DT=513305692�PATH=C:\SIGNA\
AskBaud                                                   FUNCTION AskBaud()
AskData                                                   FUNCTION AskData()
AskParity                                                 FUNCTION AskParity()
AskSistema                                                FUNCTION AskSistema()
AskStop                                                   FUNCTION AskStop()
ComConf                                                   FUNCTION ComConf
HostConf                                                  FUNCTION HostConf
SysConf                                                   FUNCTION SysConf
TimesConf		FUNCTION TimesConf()
                                                            �
�Ĵ TAGBROW.PRG   ������Ĵ 08/09/93 17.20 ���������DT=455641746�PATH=C:\SIGNA\
CopyInList                                                FUNCTION CopyInList(nCodice)
DelInList                                                 FUNCTION DelInList(nCodice)
InList                                                    FUNCTION InList(nCodice)
SayCount                                                  FUNCTION SayCount(nSel, nTot)
tagbrow                                                   function tagbrow( cFieldName, cColName, nTop, nLeft, lMessage, cTitle)
                                                            �
�Ĵ TAGTEST.PRG   ������Ĵ 08/09/93 17.20 ���������DT=455641746�PATH=C:\SIGNA\
main                                                      func main()
                                                            �
�Ĵ TEMPI.PRG     ������Ĵ 20/04/95 00.45 ���������DT=513017274�PATH=C:\SIGNA\
AtletiTitles                                              STATIC FUNCTION AtletiTitles()
StaffetteTitles                                           STATIC FUNCTION StaffetteTitles()
TempiAtleti                                               FUNCTION TempiAtleti( )
TempiStaffette                                            FUNCTION TempiStaffette( )
                                                            �
�Ĵ TEST.PRG      ������Ĵ 24/04/95 19.30 ���������DT=513317849�PATH=C:\SIGNA\
scan_480                                                  function scan_480
test                                                      function test
trap                                                      procedure trap(nkey)
                                                            �
�Ĵ UTILS.PRG     ������Ĵ 24/04/95 13.34 ���������DT=513305692�PATH=C:\SIGNA\
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
