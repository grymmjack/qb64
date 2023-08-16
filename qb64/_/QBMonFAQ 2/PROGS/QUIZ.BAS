'******************************************************************************
' QUIZ.BAS = Ein einfaches Quiz-Programm
' ========
' Dieses Q(uick)Basic-Programm ist relisiert ein einfaches Quizspiel. Im
' Multiple-Choice-Verfahren werden zu jeder Frage 4 mögliche Antworten
' genannt, von denen nur eine richtig ist. Die Anzahl der Fragen, die
' jeweiligen 4 Antworten und die Nummer 1..4 der richtigen Antwort sind in
' Datazeilen am Ende des Programms definiert. Dadurch ist das Programm ganz
' einfach um zusätzliche Fragen erweiterbar.
'
' (c) Marc Antoni - www.antonis.de , 03.09.99 - 13.01.06
'******************************************************************************

'Benutzerdefinierten Datentyp "quiz" deklarieren
TYPE quiz
   frage AS STRING * 80
   antw1 AS STRING * 70
   antw2 AS STRING * 70
   antw3 AS STRING * 70
   antw4 AS STRING * 70
   oknr  AS INTEGER      'Nummer 1...4 der richtigen Antwort
END TYPE
'
DIM eintrag AS quiz
'
READ anzahl%
'
FOR i% = 1 TO anzahl%
  CLS
  READ eintrag.frage    'Frage und Antworten einlesen
  READ eintrag.antw1
  READ eintrag.antw2
  READ eintrag.antw3
  READ eintrag.antw4
  READ eintrag.oknr
'
  PRINT eintrag.frage    'Frage und Antworten anzeigen
  PRINT " (1) "; eintrag.antw1
  PRINT " (2) "; eintrag.antw2
  PRINT " (3) "; eintrag.antw3
  PRINT " (4) "; eintrag.antw4
  PRINT
  PRINT "Welche Antwort ist richtig (1..4) ... Beenden mit Esc?"
'
  DO
    DO: taste$ = INKEY$: LOOP WHILE taste$ = ""'Warten auf beliebigen Tastendruck
    IF taste$ = CHR$(27) THEN END             'Beenden mit Esc-Taste
  LOOP UNTIL taste$ >= "1" AND taste <= 4     'Wiederholung bis 1...4 betaetigt
'
  PRINT
  IF VAL(taste$) = eintrag.oknr THEN
   PRINT "Gratulation: Die Antwort ist richtig!"
  ELSE
    PRINT "Die Antwort ist leider falsch! ("; LTRIM$(STR$(eintrag.oknr));
    PRINT ") ist die richtige Antwort"
  END IF
  PRINT
  PRINT "Neue Frage...[Beliebige Taste]  Beenden...[Esc]"
  DO: taste$ = INKEY$: LOOP WHILE taste$ = "" 'Warten auf beliebigen Tastendruck
  IF taste$ = CHR$(27) THEN END               'Beenden mit Esc-Taste  
NEXT
PRINT
PRINT "Es sind alle Fragen abgearbeitet. Vielen Dank fuer Deine Teilnahme am Quiz!"
SLEEP
END
'
'========================= DATA-Zeilen mit den Quizfragen ======================
'Neue Fragen oder Wissensgebiete einfach unten anhaengen oder mitendrin
'einfuegen und nicht vergessen, die Gesamtanzahl der Quizfragen in der ersten
'DATA-Zeile zu aktualisieren
'
'---------- Gesamtanzahl der Quizfragen ------------
DATA  15
'
'---------- Quizfragen und Antworten ---------
'Die einzelnen Datazeilen sind fuer jede Frage wie folgt aufgebaut:
' - Frage (max. 80 Zeichen)
' - Antwort 1 )
' - Antwort 2 )
' - Antwort 3 ) je max. 70 Zeichen
' - Antwort 4 )
' - Nummer 1...4 der richtigen Antwort
'
'---- Wissensgebiet "beruehmte Persoenlichkeiten"
DATA "Wer war Mao Tse-tung?"
DATA "Ein chinesischer, kommunistischer Anfuehrer"
DATA "Ein chinesischer Kaiser"
DATA "Eine japanische Gottheit2"
DATA "Der letzte Kaiser von Kambotscha"
DATA 1
'
DATA "Wo wurde Martin Luther geboren ?"
DATA "In Wittenberg"
DATA "In Eisleben"
DATA "In Erfurt"
DATA "In Magdeburg"
DATA 2
'
DATA "Wer war der erste Bundeskanzler Deutschlands ?"
DATA "Willi Brandt"
DATA "Paul von Hindenburg"
DATA "Ludwig Ehrhard"
DATA "Konrad Adenauer"
DATA 4
'
DATA "Wer war Muddy Waters ?"
DATA "Ein Jazz-Saenger"
DATA "Ein Blues-Saenger"
DATA "Ein Raggee-Saenger"
DATA "Ein Soul-Saenger"
DATA 2
'
DATA "Wer regierte zur Zeit der Geburt Christis in Jerusalem ?"
DATA "Kaiser Augustus"
DATA "Caesar"
DATA "Kaiser Nero"
DATA "Koenig Herodes"
DATA 1
'
'---- Wissensgebiet "Geschichte"
DATA "Welchen Indianischen Stamm fuehrte Pontiac an ?"
DATA "Den Stamm der Sioux-Indianer"
DATA "Den Stamm der Ottawa-Indianer"
DATA "Den Stamm der Apachen-Indianer"
DATA "Den Stamm der Iowa-Indianer"
DATA 2
'
DATA "Welche beiden Staaten kaempften im Opium War gegeneinander ?"
DATA "Grossbritannien und China"
DATA "Grossbritannien und Indien"
DATA "Grossbritannien und die USA"
DATA "Canada und Australien"
DATA 1
'
DATA "Welcher Monarch befahl den Angriff der spanische Armada auf Grossbritannien?"
DATA "Koenig William der erste"
DATA "Kaiser Joseph der zweite"
DATA "Koenig Philipp der zweite"
DATA "Koenig Juan Carlos der erste"
DATA 3
'
DATA "Welches ist das aelteste erhaltene deutsche/ germanische Schrifstueck ?"
DATA "Unter der Lind'n"
DATA "Der Puppenspieler"
DATA "Das Buch der Toten"
DATA "Das Nibelungenlied"
DATA 4
'
DATA "Wie hiess das erste Auto das am Fliessband hergestellt wurde ?"
DATA "Der Red Arrow von Jaguar"
DATA "Die Tin Lizzy von Ford "
DATA "Der X 1 von Renault"
DATA "Der Prometeus von Mercedes"
DATA 2
'
'---- Wissensgebiet Computer-Hard- und Software
DATA "Wie heisst die Kleinste Speichereinheit eines Computers ?"
DATA "Ein Bit"
DATA "Ein Megabyte"
DATA "Ein Kilobyte"
DATA "Ein Byte"              
DATA 1
'
DATA "Wieviel Megaherz hatte der erste Intel Pentium Prozessor ?"
DATA " 40  Mhz"
DATA " 60  Mhz"
DATA " 75  Mhz"
DATA "100  Mhz"
DATA 2

DATA "Wie hiess das erste Videospiel der Welt ?"
DATA "Space Invaders"
DATA "Mario Brothers eins"
DATA "Tetris"
DATA "Pong"
DATA 4
'
DATA "Wer ist Steve Jobs ?"
DATA "Der Erfinder der CD-ROM"
DATA "Einer der Gruender von IBM"
DATA "Einer der Gruender von Apple"
DATA "Einer der Gruender von Microsoft"
DATA 3
'
DATA "Welcher war der erste First Person Shooter (Ego-Shooter) fuer den PC ?"
DATA "Doom"
DATA "Wolfenstein 3D"
DATA "Heretic"
DATA "Power Slave"
DATA 2

