'****************************************************************
' StarWarF.BAS = Star-Wars Intro mit Star-Wars Melodie und -Font
' ============
' Dieses Programm laeuft nur auf sehr schnellen Rechnern!!!
' (erfolgreich auf P3 866MHz und AMD-Athlon 2GHz getestet)
'
' (c) by Thomas Decker 5.5.2003
'****************************************************************
'
DECLARE SUB Punkt (x%, y%, f%)
DECLARE SUB Wart (z!)
DECLARE SUB Schreib (text$, XP1Er%, XP2Er%, FG!, f%)
DECLARE SUB Linie (x1%, y1%, x2%, y2%, f%, fuell%)
'
CONST SM% = 7, xr% = 320, yr% = 200
CONST fak1! = .01
'
1 CLS : SCREEN SM%
COLOR 9
LOCATE 15, 10: PRINT "Es war einmal vor einer langen Zeit"
LOCATE 16, 10: PRINT "in einer weit entfernten Galaxis..."
Wart 5
'
2 CLS : SCREEN , , 1, 2
'
GOSUB Music
RESTORE
READ nummer%
za% = 14
'
FOR hoehe% = (yr% - 20) TO -20 - nummer% * za% STEP -1
 RESTORE
    READ nummer%
    FOR k% = 1 TO nummer%
     READ zeile$
     Schreib zeile$, 0, hoehe% + k% * za%, 1, 14
    NEXT k%

   PCOPY 1, 2
 
   CLS
 
   'LINE (0, 0)-(xr%, yr%), 0, BF
 
   'RESTORE
   ' READ nummer%
   ' FOR k% = 1 TO nummer%
   '  READ zeile$
   '  Schreib zeile$, 0, hoehe% + k% * za%, 1, 0
   ' NEXT k%
 
NEXT hoehe%
END
'
Music:
PLAY "MB O3L6CL5F> L3C< L9A+AG>L3FC < L9A+AG>L3FC <L9A+AA+L3G"
RETURN
'
MeinText:
DATA 13
DATA "STAR WARS"
DATA "Die Rckkehr"
DATA "von QBasic"
DATA "Selbst auf meinem"
DATA "AMD Athlon XP 2600+"
DATA "l„uft dieses Pro-"
DATA "gramm nur m„áig."
DATA "Es hackelt noch zu"
DATA "sehr. Ist wahr-"
DATA "scheinlich noch zu"
DATA "rechenintensiv."
DATA "...
DATA "5.5.2003"

'
SUB Linie (x1%, y1%, x2%, y2%, f%, fuell%)
   ab% = (xr% / 2) - y1% * fak1!
   plus% = ((xr% - (2 * ab%)) / xr%) * x1%
   P1X% = ab% + plus%
   P1Y% = y1%

   ab% = (xr% / 2) - y2% * fak1!
   plus% = ((xr% - (2 * ab%)) / xr%) * x2%
   P2X% = ab% + plus%
   P2Y% = y2%

   IF fuell% = 0 THEN
    LINE (P1X%, P1Y%)-(P2X%, P2Y%), f%
   ELSE
    LINE (P1X%, P1Y%)-(P2X%, P2Y%), f%
   END IF

   'COLOR 15
   'PRINT P1X%, P1Y%, P2X%, P2Y%, f%
   'SLEEP
END SUB

'
SUB Punkt (x%, y%, f%)
   ab! = (xr% / 2) - y% ^ 2 * fak1!
   plus! = ((xr% - (2 * ab!)) / xr%) * x%
   PSET (ab! + plus!, y%), f%
END SUB

'
SUB Schreib (text$, XP1Er%, XP2Er%, FG!, f%)
bgrx% = 11
bgry% = 10
XP1Er% = (xr% - LEN(text$) * bgrx%) / 2
DIM Feld$(1 TO bgrx%)
'
FOR i% = 1 TO LEN(text$)
 SELECT CASE UCASE$(MID$(text$, i%, 1))
  CASE "A"
   Feld$(1) = "   ###    "
   Feld$(2) = "  #   #   "
   Feld$(3) = " #     #  "
   Feld$(4) = "#       # "
   Feld$(5) = "######### "
   Feld$(6) = "#       # "
   Feld$(7) = "#       # "
   Feld$(8) = "#       # "
   Feld$(9) = "#       # "
  Feld$(10) = "#       # "
'
  CASE "B"
   Feld$(1) = "#######   "
   Feld$(2) = "#      #  "
   Feld$(3) = "#       # "
   Feld$(4) = "#       # "
   Feld$(5) = "########  "
   Feld$(6) = "#      #  "
   Feld$(7) = "#       # "
   Feld$(8) = "#       # "
   Feld$(9) = "#      #  "
  Feld$(10) = "#######   "
'      
  CASE "C"
   Feld$(1) = "  ####### "
   Feld$(2) = " #        "
   Feld$(3) = "#         "
   Feld$(4) = "#         "
   Feld$(5) = "#         "
   Feld$(6) = "#         "
   Feld$(7) = "#         "
   Feld$(8) = "#         "
   Feld$(9) = " #        "
  Feld$(10) = "  ####### "
'
  CASE "D"
   Feld$(1) = "######    "
   Feld$(2) = "#     #   "
   Feld$(3) = "#      #  "
   Feld$(4) = "#       # "
   Feld$(5) = "#       # "
   Feld$(6) = "#       # "
   Feld$(7) = "#       # "
   Feld$(8) = "#      #  "
   Feld$(9) = "#     #   "
  Feld$(10) = "######    "
'
  CASE "E"
   Feld$(1) = "######### "
   Feld$(2) = "#         "
   Feld$(3) = "#         "
   Feld$(4) = "#         "
   Feld$(5) = "#######   "
   Feld$(6) = "#         "
   Feld$(7) = "#         "
   Feld$(8) = "#         "
   Feld$(9) = "#         "
  Feld$(10) = "######### "
'
  CASE "F"
   Feld$(1) = "######### "
   Feld$(2) = "#         "
   Feld$(3) = "#         "
   Feld$(4) = "#         "
   Feld$(5) = "#######   "
   Feld$(6) = "#         "
   Feld$(7) = "#         "
   Feld$(8) = "#         "
   Feld$(9) = "#         "
  Feld$(10) = "#         "
'
  CASE "G"
   Feld$(1) = "  #####   "
   Feld$(2) = " #     #  "
   Feld$(3) = "#       # "
   Feld$(4) = "#       # "
   Feld$(5) = "#         "
   Feld$(6) = "#   ##### "
   Feld$(7) = "#       # "
   Feld$(8) = "#       # "
   Feld$(9) = " #     #  "
  Feld$(10) = "  #####   "
'
  CASE "H"
   Feld$(1) = "#       # "
   Feld$(2) = "#       # "
   Feld$(3) = "#       # "
   Feld$(4) = "#       # "
   Feld$(5) = "######### "
   Feld$(6) = "#       # "
   Feld$(7) = "#       # "
   Feld$(8) = "#       # "
   Feld$(9) = "#       # "
  Feld$(10) = "#       # "
'
  CASE "I"
   Feld$(1) = "    #     "
   Feld$(2) = "    #     "
   Feld$(3) = "    #     "
   Feld$(4) = "    #     "
   Feld$(5) = "    #     "
   Feld$(6) = "    #     "
   Feld$(7) = "    #     "
   Feld$(8) = "    #     "
   Feld$(9) = "    #     "
  Feld$(10) = "    #     "
'
  CASE "J"
   Feld$(1) = "######### "
   Feld$(2) = "        # "
   Feld$(3) = "        # "
   Feld$(4) = "        # "
   Feld$(5) = "        # "
   Feld$(6) = "        # "
   Feld$(7) = "#       # "
   Feld$(8) = "#       # "
   Feld$(9) = " #     #  "
  Feld$(10) = "  #####   "
'
  CASE "K"
   Feld$(1) = "#     ##  "
   Feld$(2) = "#    #    "
   Feld$(3) = "#   #     "
   Feld$(4) = "#  #      "
   Feld$(5) = "###       "
   Feld$(6) = "###       "
   Feld$(7) = "#  #      "
   Feld$(8) = "#   #     "
   Feld$(9) = "#    #    "
  Feld$(10) = "#     ### "
'
  CASE "L"
   Feld$(1) = "#         "
   Feld$(2) = "#         "
   Feld$(3) = "#         "
   Feld$(4) = "#         "
   Feld$(5) = "#         "
   Feld$(6) = "#         "
   Feld$(7) = "#         "
   Feld$(8) = "#         "
   Feld$(9) = "#         "
  Feld$(10) = "######### "
'
  CASE "M"
   Feld$(1) = "##     ## "
   Feld$(2) = "# #   # # "
   Feld$(3) = "#  ###  # "
   Feld$(4) = "#   #   # "
   Feld$(5) = "#   #   # "
   Feld$(6) = "#       # "
   Feld$(7) = "#       # "
   Feld$(8) = "#       # "
   Feld$(9) = "#       # "
  Feld$(10) = "#       # "
'
  CASE "N"
   Feld$(1) = "##      # "
   Feld$(2) = "###     # "
   Feld$(3) = "#  #    # "
   Feld$(4) = "#  ##   # "
   Feld$(5) = "#   #   # "
   Feld$(6) = "#   #   # "
   Feld$(7) = "#   #   # "
   Feld$(8) = "#    #  # "
   Feld$(9) = "#    #  # "
  Feld$(10) = "#    #### "
'
  CASE "O"
   Feld$(1) = "  #####   "
   Feld$(2) = " #     #  "
   Feld$(3) = "#       # "
   Feld$(4) = "#       # "
   Feld$(5) = "#       # "
   Feld$(6) = "#       # "
   Feld$(7) = "#       # "
   Feld$(8) = "#       # "
   Feld$(9) = " #     #  "
  Feld$(10) = "  #####   "
'
  CASE "P"
   Feld$(1) = "#######   "
   Feld$(2) = "#      #  "
   Feld$(3) = "#       # "
   Feld$(4) = "#       # "
   Feld$(5) = "#      #  "
   Feld$(6) = "#######   "
   Feld$(7) = "#         "
   Feld$(8) = "#         "
   Feld$(9) = "#         "
  Feld$(10) = "#         "
'
  CASE "Q"
   Feld$(1) = "  #####   "
   Feld$(2) = " #     #  "
   Feld$(3) = "#       # "
   Feld$(4) = "#       # "
   Feld$(5) = "#       # "
   Feld$(6) = "#       # "
   Feld$(7) = "#    #  # "
   Feld$(8) = "#     # # "
   Feld$(9) = " #     #  "
  Feld$(10) = "  ##### # "
'
  CASE "R"
   Feld$(1) = "#######   "
   Feld$(2) = "#      #  "
   Feld$(3) = "#       # "
   Feld$(4) = "#       # "
   Feld$(5) = "#      #  "
   Feld$(6) = "########  "
   Feld$(7) = "#       # "
   Feld$(8) = "#       # "
   Feld$(9) = "#       # "
  Feld$(10) = "#       # "
'
  CASE "S"
   Feld$(1) = "  ####### "
   Feld$(2) = " #        "
   Feld$(3) = "#         "
   Feld$(4) = "#         "
   Feld$(5) = " #        "
   Feld$(6) = "  ######  "
   Feld$(7) = "        # "
   Feld$(8) = "        # "
   Feld$(9) = "       #  "
  Feld$(10) = "#######   "
'
  CASE "T"
   Feld$(1) = "######### "
   Feld$(2) = "    #     "
   Feld$(3) = "    #     "
   Feld$(4) = "    #     "
   Feld$(5) = "    #     "
   Feld$(6) = "    #     "
   Feld$(7) = "    #     "
   Feld$(8) = "    #     "
   Feld$(9) = "    #     "
  Feld$(10) = "    #     "
'
  CASE "U"
   Feld$(1) = "#       # "
   Feld$(2) = "#       # "
   Feld$(3) = "#       # "
   Feld$(4) = "#       # "
   Feld$(5) = "#       # "
   Feld$(6) = "#       # "
   Feld$(7) = "#       # "
   Feld$(8) = "#       # "
   Feld$(9) = " #     #  "
  Feld$(10) = "  #####   "
'
  CASE "V"
   Feld$(1) = "#       # "
   Feld$(2) = "#       # "
   Feld$(3) = "#       # "
   Feld$(4) = "#       # "
   Feld$(5) = "#       # "
   Feld$(6) = "#       # "
   Feld$(7) = "#       # "
   Feld$(8) = " #     #  "
   Feld$(9) = "  #####   "
  Feld$(10) = "    #     "
'
  CASE "W"
   Feld$(1) = "#       # "
   Feld$(2) = "#       # "
   Feld$(3) = "#       # "
   Feld$(4) = "#       # "
   Feld$(5) = "#       # "
   Feld$(6) = "#   #   # "
   Feld$(7) = "#   #   # "
   Feld$(8) = "#  ###  # "
   Feld$(9) = "# #   # # "
  Feld$(10) = "##     ## "
'
  CASE "X"
   Feld$(1) = "#       # "
   Feld$(2) = "#       # "
   Feld$(3) = " #     #  "
   Feld$(4) = "  #   #   "
   Feld$(5) = "   ###    "
   Feld$(6) = "   ###    "
   Feld$(7) = "  #   #   "
   Feld$(8) = " #     #  "
   Feld$(9) = "#       # "
  Feld$(10) = "#       # "
'
  CASE "Y"
   Feld$(1) = "#       # "
   Feld$(2) = "#       # "
   Feld$(3) = " #     #  "
   Feld$(4) = "  #   #   "
   Feld$(5) = "   ###    "
   Feld$(6) = "   #      "
   Feld$(7) = "  #       "
   Feld$(8) = "  #       "
   Feld$(9) = " #        "
  Feld$(10) = " #        "
'
  CASE "Z"
   Feld$(1) = "######### "
   Feld$(2) = "        # "
   Feld$(3) = "       #  "
   Feld$(4) = "      #   "
   Feld$(5) = "    ##    "
   Feld$(6) = "   #      "
   Feld$(7) = "  ##      "
   Feld$(8) = "##        "
   Feld$(9) = "#         "
  Feld$(10) = "######### "
'
  CASE "/"
   Feld$(1) = "       ## "
   Feld$(2) = "       #  "
   Feld$(3) = "     ##   "
   Feld$(4) = "     #    "
   Feld$(5) = "    #     "
   Feld$(6) = "   #      "
   Feld$(7) = "  #       "
   Feld$(8) = "  #       "
   Feld$(9) = "##        "
  Feld$(10) = "#         "
'
  CASE "\"
   Feld$(1) = "#         "
   Feld$(2) = "##        "
   Feld$(3) = "  #       "
   Feld$(4) = "  #       "
   Feld$(5) = "   #      "
   Feld$(6) = "    #     "
   Feld$(7) = "     #    "
   Feld$(8) = "     ##   "
   Feld$(9) = "       ## "
  Feld$(10) = "        # "
'
  CASE "("
   Feld$(1) = "      ### "
   Feld$(2) = "     #    "
   Feld$(3) = "    #     "
   Feld$(4) = "    #     "
   Feld$(5) = "    #     "
   Feld$(6) = "    #     "
   Feld$(7) = "    #     "
   Feld$(8) = "    #     "
   Feld$(9) = "     #    "
  Feld$(10) = "      ### "
'
  CASE ")"
   Feld$(1) = "###       "
   Feld$(2) = "   #      "
   Feld$(3) = "    #     "
   Feld$(4) = "    #     "
   Feld$(5) = "    #     "
   Feld$(6) = "    #     "
   Feld$(7) = "    #     "
   Feld$(8) = "    #     "
   Feld$(9) = "   #      "
  Feld$(10) = "####      "
'
  CASE "."
   Feld$(1) = "          "
   Feld$(2) = "          "
   Feld$(3) = "          "
   Feld$(4) = "          "
   Feld$(5) = "          "
   Feld$(6) = "          "
   Feld$(7) = "          "
   Feld$(8) = "##        "
   Feld$(9) = "##        "
  Feld$(10) = "          "
'
  CASE ","
   Feld$(1) = "          "
   Feld$(2) = "          "
   Feld$(3) = "          "
   Feld$(4) = "          "
   Feld$(5) = "          "
   Feld$(6) = "          "
   Feld$(7) = "          "
   Feld$(8) = "##        "
   Feld$(9) = "##        "
  Feld$(10) = " #        "
'
  CASE "!"
   Feld$(1) = "##        "
   Feld$(2) = "##        "
   Feld$(3) = "##        "
   Feld$(4) = "##        "
   Feld$(5) = "##        "
   Feld$(6) = "##        "
   Feld$(7) = "          "
   Feld$(8) = "          "
   Feld$(9) = "##        "
  Feld$(10) = "##        "
'
  CASE "?"
   Feld$(1) = "  #####   "
   Feld$(2) = " #     #  "
   Feld$(3) = "#       # "
   Feld$(4) = "#       # "
   Feld$(5) = "       #  "
   Feld$(6) = "      #   "
   Feld$(7) = "     #    "
   Feld$(8) = "          "
   Feld$(9) = "    ##    "
  Feld$(10) = "    ##    "
'
  CASE ":"
   Feld$(1) = " ##       "
   Feld$(2) = " ##       "
   Feld$(3) = "          "
   Feld$(4) = "          "
   Feld$(5) = "          "
   Feld$(6) = "          "
   Feld$(7) = "          "
   Feld$(8) = " ##       "
   Feld$(9) = " ##       "
  Feld$(10) = "          "
'
  CASE "„"
   Feld$(1) = "#  ###  # "
   Feld$(2) = "  #   #   "
   Feld$(3) = " #     #  "
   Feld$(4) = "#       # "
   Feld$(5) = "######### "
   Feld$(6) = "#       # "
   Feld$(7) = "#       # "
   Feld$(8) = "#       # "
   Feld$(9) = "#       # "
  Feld$(10) = "#       # "
'
  CASE "”"
   Feld$(1) = "# #####  #"
   Feld$(2) = " #     #  "
   Feld$(3) = "#       # "
   Feld$(4) = "#       # "
   Feld$(5) = "#       # "
   Feld$(6) = "#       # "
   Feld$(7) = "#       # "
   Feld$(8) = "#       # "
   Feld$(9) = " #     #  "
  Feld$(10) = "  #####   "
'
  CASE ""
   Feld$(1) = "#       # "
   Feld$(2) = "          "
   Feld$(3) = "#       # "
   Feld$(4) = "#       # "
   Feld$(5) = "#       # "
   Feld$(6) = "#       # "
   Feld$(7) = "#       # "
   Feld$(8) = "#       # "
   Feld$(9) = " #     #  "
  Feld$(10) = "  #####   "
'
  CASE "1"
   Feld$(1) = "      ### "
   Feld$(2) = "     #  # "
   Feld$(3) = "    #   # "
   Feld$(4) = "   #    # "
   Feld$(5) = "        # "
   Feld$(6) = "        # "
   Feld$(7) = "        # "
   Feld$(8) = "        # "
   Feld$(9) = "        # "
  Feld$(10) = "        # "
'
  CASE "2"
   Feld$(1) = "  #####   "
   Feld$(2) = " ##    #  "
   Feld$(3) = "      #   "
   Feld$(4) = "     #    "
   Feld$(5) = "    #     "
   Feld$(6) = "   #      "
   Feld$(7) = "  #       "
   Feld$(8) = " #        "
   Feld$(9) = "#         "
  Feld$(10) = "######### "
'
  CASE "3"
   Feld$(1) = "  ######  "
   Feld$(2) = " #      # "
   Feld$(3) = "        # "
   Feld$(4) = "        # "
   Feld$(5) = "   #####  "
   Feld$(6) = "        # "
   Feld$(7) = "        # "
   Feld$(8) = "        # "
   Feld$(9) = "#       # "
  Feld$(10) = " #######  "
'
  CASE "4"
   Feld$(1) = "     ##   "
   Feld$(2) = "    # #   "
   Feld$(3) = "   #  #   "
   Feld$(4) = "  #   #   "
   Feld$(5) = " #    #   "
   Feld$(6) = "######### "
   Feld$(7) = "      #   "
   Feld$(8) = "      #   "
   Feld$(9) = "      #   "
  Feld$(10) = "      #   "
'
  CASE "5"
   Feld$(1) = "######### "
   Feld$(2) = "#         "
   Feld$(3) = "#         "
   Feld$(4) = "#         "
   Feld$(5) = "########  "
   Feld$(6) = "        # "
   Feld$(7) = "        # "
   Feld$(8) = "        # "
   Feld$(9) = "#       # "
  Feld$(10) = " #######  "
'
  CASE "6"
   Feld$(1) = "  #####   "
   Feld$(2) = " #     #  "
   Feld$(3) = "#         "
   Feld$(4) = "#         "
   Feld$(5) = "# #####   "
   Feld$(6) = "##     #  "
   Feld$(7) = "#       # "
   Feld$(8) = "#       # "
   Feld$(9) = " #     #  "
  Feld$(10) = "  #####   "
'
  CASE "7"
   Feld$(1) = " ######## "
   Feld$(2) = "#       # "
   Feld$(3) = "       #  "
   Feld$(4) = "      #   "
   Feld$(5) = "     #    "
   Feld$(6) = "  #####   "
   Feld$(7) = "   #      "
   Feld$(8) = "  #       "
   Feld$(9) = " #        "
  Feld$(10) = "#         "
'
  CASE "8"
   Feld$(1) = "  #####   "
   Feld$(2) = " #     #  "
   Feld$(3) = "#       # "
   Feld$(4) = " #     #  "
   Feld$(5) = "  #####   "
   Feld$(6) = " #     #  "
   Feld$(7) = "#       # "
   Feld$(8) = "#       # "
   Feld$(9) = " #     #  "
  Feld$(10) = "  #####   "
'
  CASE "9"
   Feld$(1) = "   ####   "
   Feld$(2) = "  #    #  "
   Feld$(3) = " #      # "
   Feld$(4) = " #      # "
   Feld$(5) = "  #    ## "
   Feld$(6) = "   #### # "
   Feld$(7) = "        # "
   Feld$(8) = "        # "
   Feld$(9) = "  #    #  "
  Feld$(10) = "   ####   "
'
  CASE "0"
   Feld$(1) = "   ####   "
   Feld$(2) = "  #    #  "
   Feld$(3) = " #      # "
   Feld$(4) = " #  ##  # "
   Feld$(5) = " #  ##  # "
   Feld$(6) = " #  ##  # "
   Feld$(7) = " #  ##  # "
   Feld$(8) = " #      # "
   Feld$(9) = "  #    #  "
  Feld$(10) = "   ####   "
'
  CASE "-"
   Feld$(1) = "          "
   Feld$(2) = "          "
   Feld$(3) = "          "
   Feld$(4) = "          "
   Feld$(5) = "######### "
   Feld$(6) = "          "
   Feld$(7) = "          "
   Feld$(8) = "          "
   Feld$(9) = "          "
  Feld$(10) = "          "
'
  CASE "Û"
   Feld$(1) = "##########"
   Feld$(2) = "##########"
   Feld$(3) = "##########"
   Feld$(4) = "##########"
   Feld$(5) = "##########"
   Feld$(6) = "##########"
   Feld$(7) = "##########"
   Feld$(8) = "##########"
   Feld$(9) = "##########"
  Feld$(10) = "##########"
'
  CASE " "
   Feld$(1) = "          "
   Feld$(2) = "          "
   Feld$(3) = "          "
   Feld$(4) = "          "
   Feld$(5) = "          "
   Feld$(6) = "          "
   Feld$(7) = "          "
   Feld$(8) = "          "
   Feld$(9) = "          "
  Feld$(10) = "          "
'
  CASE ELSE
 END SELECT
'
FOR y% = 1 TO bgry%
  FOR x% = 1 TO bgrx%
    IF MID$(Feld$(y%), x%, 1) = "#" THEN
      'Linie XP1Er% + i% * (bgrx% * FG!) - (bgrx% * FG!) + x% * FG! - FG!, XP2Er% + y% * FG! - FG!, XP1Er% + i% * (bgrx% * FG!) - (bgrx% * FG!) + x% * FG! - 1, XP2Er% + y% * FG! - 1, f%, 1
       Punkt XP1Er% + i% * bgrx% - bgrx% + x% - 1, XP2Er% + y% - 1, f%
      'PSET (100 + XP1Er% + i% * 6 - 6 + x% - 1, 100 + XP2Er% + y% - 1), f%
   END IF
NEXT x%
NEXT y%
NEXT i%
END SUB

'
SUB Wart (z!)
SZ! = TIMER
DO WHILE SZ! + z! > TIMER
IF INKEY$ = "." THEN EXIT DO
LOOP
END SUB

