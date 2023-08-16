'***************************************************************************
' REPLACE.BAS - Textstuecke in einer Textdatei suchen und ersetzen
' ===========   Searching and replacing text strings in a text file
'
' *** Deutsche Programmbeschreibung
' Dieses Q(uick)Basic-Programm demonstriert das Suchen und Ersetzen von
' Text mit Hilfe der SUBroutine "Replace". Detaillierte Informationen ueber
' die Arbeitsweise des Programms kannst Du dem Kommentarkopf der SUBroutine
' "Replace" entnehmen.
'
' Zunaechst wird ein ziemlich unsinniger Text angezeigt, der 5 mal das
' Wort "blue" enthaelt. Der Anwender kann jetzt eine neue Farbe eingegeben.
' Alle Vorkommen von "blue" weden durch die neue farbe ersetzt und der so
' geaenderte Text wird angezeigt.
'
' *** English-Language description
' This Q(uick)Basic program demonstrates the usage of the SUB "Replace".
' For detailed information please refer to the comment header of "Replace" .
'
' The demo works as follows: a nonsense text is generated containing
' the word "blue" five times. The user is asked for a new color. All
' occurrences of "blue" are replaced by the new color and the modified
' text is displayed on the screen.
'
' (c) Thomas Antoni, 14.04.01 - 15.04.01
'       thomas*antonis.de
'       http://www.antonis.de   --- Hottest QBasic Stuff on Earth ---
'
'***************************************************************************
DECLARE SUB Replace (pathname$, filename$, oldstring$, newstring$)
'
COLOR 0, 7                                 'black text on grey background
CLS
s1$ = "blue men are blue but not too blue" 'create old text
s2$ = "blue women should be dark blue."

OPEN "temp.txt" FOR OUTPUT AS #1
PRINT #1, s1$                              'write old text to file
PRINT #1, s2$
CLOSE #1

PRINT
PRINT "Demo of the SUBroutine  R e p l a c e : Finding and replacing textstrings"
PRINT STRING$(75, "Ä")
PRINT : PRINT "--- Old Text: ---"
PRINT : PRINT s1$: PRINT s2$: PRINT        'display old text

INPUT "please enter the new color replacing >>blue<< "; newcolor$
                                           'ask for new color

CALL Replace(".", "temp.txt", "blue", newcolor$)  'replace blue by new color

OPEN "temp.txt" FOR INPUT AS #1
LINE INPUT #1, s1$                         'read new text from file
LINE INPUT #1, s2$
CLOSE #1
KILL "temp.txt"
PRINT : PRINT : PRINT "--- New Text: ---"
PRINT : PRINT s1$: PRINT s2$               'display new text

LOCATE 20: COLOR 12
PRINT " Thank you for testing REPLACE.BAS !" 'display Goodbye text
PRINT " Visit my homepage http://www.antonis.de  ---  Hottest QBasic Stuff on Earth"
PRINT
PRINT "       >>>>>> Hit any key to close this program <<<<<<"
SLEEP
COLOR 0
END

SUB Replace (pathname$, filename$, oldstring$, newstring$)
'***************************************************************************
' Replace - QBasic SUBroutine for Replacing a Textstring in a TXT File
' ==========================================================================
' This program opens the ASCII or ANSI text file "filename$" in the path
' "pathname$". 'Replace' searches all occurrences of the string "oldstring$"
' in this text file and replaces them by "newstring$".
'
' Examples of correct pathname$ parameters:
'  - pathname$ = "."      => The text file is located in the actual directory
'  - pathname$ = "d:\txt" => The text file is located in the "txt" directory
'                            of drive D:\
'         
' Note: Characters in the find string are handled case sensitive. I.e.
' ~~~~~ lower/upper case letters are distinguished when finding strings.
'
' Credits:
' ~~~~~~~~
' This program is based on other find & replace algorithms by
'  - Kai Hagemann  - KaiHagemann*Profanet.de   - http://www.KaiHagemann.de
'  - Urs Langmeier - urs_langmeier*hotmail.com - http://www.laosoft.ch
'  - Kurt Kuzba (program snippet "SANDR.BAS" from the ABC-Archive)
' I only have perfected and de-bugged these programs and build a little demo
' program around it.
'
' (c) Thomas Antoni, 14.04.01 - 15.04.01
'       thomas*antonis.de
'       http://www.antonis.de   --- Hottest QBasic Stuff on Earth ---
'
'***************************************************************************

oldlength% = LEN(oldstring$)
newlength% = LEN(newstring$)
f1% = FREEFILE                     '1st free file No for text file
f2% = f1% + 1                      'next free file No for temp file
CHDIR pathname$
OPEN filename$ FOR INPUT AS f1%    'source text file
OPEN "replace.tmp" FOR OUTPUT AS f2%  ' Temporary file
WHILE NOT EOF(f1%)                 'loop over all lines of the text file
  LINE INPUT #f1%, line$           'read one line, i.e. all chars until CR LF
  lineptr% = 1                     'initialize line pointer

  DO
    foundptr% = INSTR(lineptr%, line$, oldstring$)
                                         'pointer to oldstring in line
    IF foundptr% > 0 THEN                'old string found?
      line$ = LEFT$(line$, foundptr% - 1) + newstring$ + MID$(line$, foundptr% + oldlength%)
                                         'replace old by new string
      lineptr% = foundptr% + newlength%  'set line pointer behind new string
      IF lineptr% > LEN(line$) THEN EXIT DO
                                         'line already completely analyzed
    ELSE EXIT DO                   'old string not found -> goto next line
    END IF
  LOOP

  PRINT #f2%, line$                'append line to temp file
WEND

CLOSE f1%: CLOSE f2%
KILL filename$                     'delete source text file
NAME "replace.tmp" AS filename$    'rename temp to source file
END SUB

