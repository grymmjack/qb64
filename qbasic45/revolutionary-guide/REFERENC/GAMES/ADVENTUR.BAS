DECLARE SUB RESTART ()
DECLARE SUB RestartConfirm ()
DECLARE SUB DrawHeader ()
DECLARE SUB Help ()
DECLARE SUB QuitFunction ()
DECLARE SUB IntroScreen ()
DECLARE SUB QuitScreenConfirm ()

REM ADVENTURE
REM Written by A.Sill for Wrox Press
REM In GWBASIC
REM (c) 1995

IntroScreen

220 REM ########## INITIALIZE ###########

Objects% = 3: Rooms% = 5
DIM Word$(200), PlaceName$(Rooms%), PlaceDescription$(Rooms%)
DIM Direction$(Rooms%), Barrier$(Rooms%), ObjectKey$(Objects%)
DIM ObjectDescription$(Objects%), ObjectInfo$(Objects%)
DIM SHARED Reply$
DIM UnknownResponse$(15)

CurrentLocation% = 1

FOR a = 1 TO Rooms%: READ PlaceName$(a), PlaceDescription$(a), Direction$(a), Barrier$(a): NEXT a
DATA "The Path", "This wide gravel path leads from the locked gate at the foot of the hill and    winds up steeply to the front door of the castle.  The hedges that are adjacent to the path are impenetrable.", "00020000", "06020604"
DATA "The Lobby", "You are in the hallway inside the main doors.   Doors lead off in different     directions.   The room looks to have been used very little.", "05000401", "00050002"
DATA "The Dungeon", "The dungeon also couples as a torture chamber.   It is very dark, smelly and    and damp drips from green fronds on the ceiling.", "00000005", "05050500"
DATA "The Bedroom", "The bedroom is definately the best kept room in the castle.   Decorated with    extreme amounts of freshly coloured drapes, it is such a contrast!", "02000000", "00050505"
DATA "The Kitchen", "This is where all the castles food is prepared.   Functional furniture dots     the dusty long-unused room.", "00030200", "05000005"
FOR a = 1 TO Objects%: READ ObjectKey$(a), ObjectDescription$(a), ObjectInfo$(a): NEXT a
DATA "Cross", "This is a large wooden well-crafted cross.   There are signs of extensive       hammering and stains of a dark liquid on the base.", "0304"
DATA "Key", "A heavy and well-worn brass key.", "0101"
DATA "Lantern", "Dull, brown, grubby cob-webbed lantern thats obviously not worked properly for years. Probably needs a good clean.", "0401"

FOR a = 1 TO 15: READ UnknownResponse$(a): NEXT a
DATA "Pardon?", "Come again?", "I don't understand", "Sorry, what was that?"
DATA "Eh?", "Speak English boy", "Sorry, I didn't quite catch that"
DATA "Are you okay?", "Don't want to", "Give me a proper command"
DATA "Say it again", "I seem to have a little problem understanding you"
DATA "What?", "Slow down, slow down, what was that?", "Stop messing me about"

350 REM ######## SCREEN LAYOUT #########

DrawHeader

480 REM ######## START INTERFACE #########

490 LOCATE 7, 1: PRINT STRING$(79, " ")
500 LOCATE 7, (80 - (LEN(PlaceName$(CurrentLocation%)))) / 2: COLOR 6: PRINT PlaceName$(CurrentLocation%)
510 LOCATE 9, 1: PRINT STRING$(79, " "): LOCATE 10, 1: PRINT STRING$(79, " "): LOCATE 11, 1: PRINT STRING$(78, " ")
520 LOCATE 9, 1: COLOR 7: PRINT PlaceDescription$(CurrentLocation%)
530 LOCATE 13, 1: PRINT STRING$(79, " ")
535 LOCATE 22, 1: PRINT STRING$(79, " ");
536 LOCATE 23, 1: PRINT STRING$(79, " ");
540 LOCATE 13, 1: COLOR 2: PRINT "Exits : "; : COLOR 7
550 flag% = 0
560 IF VAL(MID$(Direction$(CurrentLocation%), 1, 2)) <> 0 THEN PRINT " North";
570 IF VAL(MID$(Direction$(CurrentLocation%), 3, 2)) <> 0 THEN PRINT " East";
580 IF VAL(MID$(Direction$(CurrentLocation%), 5, 2)) <> 0 THEN PRINT " South";
590 IF VAL(MID$(Direction$(CurrentLocation%), 7, 2)) <> 0 THEN PRINT " West";
600 LOCATE 15, 1: PRINT STRING$(78, " ")
610 flag% = 0: LOCATE 15, 1: COLOR 2: PRINT "Objects present : "; : COLOR 7
620 FOR a = 1 TO Objects%
630 IF VAL(LEFT$(ObjectInfo$(a), 2)) = CurrentLocation% THEN IF flag% = 1 THEN PRINT ", ";
640 IF VAL(LEFT$(ObjectInfo$(a), 2)) = CurrentLocation% THEN PRINT ObjectKey$(a); : flag% = 1
650 NEXT a
660 IF flag% = 1 THEN PRINT "." ELSE PRINT "None"
670 LOCATE 18, 1: PRINT STRING$(78, " ")
680 LOCATE 20, 1: PRINT STRING$(78, " ")

REM ########### GET TEXT INPUT ##############

COLOR 7: LOCATE 18, 2: PRINT "INPUT :": COLOR 2
X = 10: Y = 18: MAX% = 50: EntryString$ = "": a$ = ""
StartTextEntry:
a$ = "": WHILE a$ = "": a$ = UCASE$(INKEY$): WEND
SOUND 137, .1
IF a$ = CHR$(13) AND EntryString$ <> "" THEN GOTO StartAnalysis
IF a$ = CHR$(8) AND EntryString$ <> "" THEN EntryString$ = LEFT$(EntryString$, LEN(EntryString$) - 1): LOCATE Y, X: PRINT EntryString$; "     ": GOTO StartTextEntry
IF (ASC(a$) < 64 OR ASC(a$) > 91) AND (a$ <> " " AND a$ <> "-" AND a$ <> "." AND a$ <> ",") THEN GOTO StartTextEntry
IF LEN(EntryString$) > MAX% - 1 THEN GOTO StartTextEntry
EntryString$ = EntryString$ + a$
LOCATE Y, X: PRINT EntryString$ + " "
GOTO StartTextEntry

REM ########## INPUT STRING ANALYSIS ############

StartAnalysis:
NumberOfWords% = 0: NumberOfSentences% = 0: WordLength% = 0
FOR a = 1 TO 20: Word$(a) = "": NEXT a
  IF RIGHT$(EntryString$, 1) <> "." THEN EntryString$ = EntryString$ + "."
FOR a = 1 TO LEN(EntryString$)
  B$ = MID$(EntryString$, a, 1)
  IF B$ = "." THEN NumberOfSentences% = NumberOfSentences% + 1
  IF B$ = " " AND WordLength% = 0 THEN GOTO 910
  IF (B$ = " " OR B$ = "(" OR B$ = ")" OR B$ = "?" OR B$ = "!" OR B$ = CHR$(34) OR B$ = "." OR B$ = "," OR B$ = "" OR a = LEN(EntryString$)) AND WordLength% > 0 THEN GOSUB GetWord: GOTO 910
  WordLength% = WordLength% + 1
910 NEXT a

REM ############# ACTION ###############

Reply$ = UnknownResponse$((RND * 14) + 1)
WHILE a$ <> "": a$ = INKEY$: WEND
W1$ = LEFT$(Word$(1), LEN(Word$(1)) - 1)
IF Word$(2) <> "" THEN W2$ = LEFT$(Word$(2), LEN(Word$(2)) - 1)
IF Word$(3) <> "" THEN W3$ = LEFT$(Word$(3), LEN(Word$(3)) - 1)
IF Word$(4) <> "" THEN W4$ = LEFT$(Word$(4), LEN(Word$(4)) - 1)
IF Word$(5) <> "" THEN W5$ = LEFT$(Word$(5), LEN(Word$(5)) - 1)
IF W1$ = "DROP" AND W2$ <> "" THEN GOSUB DropObject
IF W1$ = "DROP" AND W2$ = "" THEN Reply$ = "Drop what?"
IF (W1$ = "GET" OR W1$ = "GRAB" OR W1$ = "TAKE") AND W2$ <> "" THEN W4$ = W2$: GOSUB GetObject
IF (W1$ = "GET" OR W1$ = "GRAB" OR W1$ = "TAKE") AND W2$ = "" THEN Reply$ = "Try again - what do you want?"
IF (W1$ = "GO" OR W1$ = "RUN" OR W1$ = "WALK" OR W1$ = "CRAWL" OR W1$ = "HOP") AND (W2$ = "NORTH" OR W2$ = "SOUTH" OR W2$ = "EAST" OR W2$ = "WEST") THEN GOSUB MoveRoutine
IF (W1$ = "GO" OR W1$ = "RUN" OR W1$ = "WALK" OR W1$ = "CRAWL" OR W1$ = "HOP") AND W2$ = "" THEN Reply$ = "After exercising on the spot, you get tired and give up."
IF (W1$ = "H" OR W1$ = "HELP") AND W2$ <> "ME" THEN Reply$ = "Help who?"
IF (W1$ = "H" OR W1$ = "HELP") AND W2$ = "ME" THEN Help
IF W1$ = "INVENTORY" OR W1$ = "RUMMAGE" OR W1$ = "INV" THEN GOSUB ListInventory
IF W1$ = "OPEN" AND W2$ = "DOOR" THEN GOSUB OpenDoor
IF W1$ = "PICK" AND W2$ = "UP" AND W3$ = "" THEN Reply$ = "Pick up what?"
IF W1$ = "PICK" AND W2$ = "UP" AND W3$ <> "" THEN W4$ = W3$: GOSUB GetObject
IF W1$ = "QUIT" OR (W1$ = "LOG" AND W2$ = "OUT") OR (W1$ = "LOG" AND W2$ = "OFF") THEN QuitFunction
IF W1$ = "RESTART" THEN RESTART
IF W1$ = "UNLOCK" AND W2$ = "" THEN Reply$ = "Unlock what?"
IF W1$ = "UNLOCK" AND W2$ <> "" THEN GOSUB UnlockDoor
COLOR 15: LOCATE 20, 1: PRINT Reply$
WHILE INKEY$ = "": WEND
GOTO 490

MoveRoutine:
REM ########## 'GO' SUBROUTINE RESPONSE SEEKER #####
1330 IF W2$ = "NORTH" THEN MOVE% = 1
1340 IF W2$ = "EAST" THEN MOVE% = 3
1350 IF W2$ = "SOUTH" THEN MOVE% = 5
1360 IF W2$ = "WEST" THEN MOVE% = 7

IF VAL(MID$(Barrier$(CurrentLocation%), MOVE%, 2)) = 2 THEN Reply$ = "The door is locked."
IF VAL(MID$(Barrier$(CurrentLocation%), MOVE%, 2)) = 5 THEN Reply$ = "You cannot walk through that wall."
IF VAL(MID$(Barrier$(CurrentLocation%), MOVE%, 2)) = 6 THEN Reply$ = "You cannot penetrate the impenetrable bushes."

REM #### Check Move Type
IF VAL(MID$(Barrier$(CurrentLocation%), MOVE%, 2)) = 0 THEN CurrentLocation% = VAL(MID$(Direction$(CurrentLocation%), MOVE%, 2)): Reply$ = "YOU " + W1$ + " " + W2$
RETURN

ListInventory:
REM ############ LIST INVENTORY OBJECTS #############
LOCATE 22, 1
FOR a% = 1 TO Objects%
IF LEFT$(ObjectInfo$(a%), 2) = "00" THEN PRINT ObjectKey$(a%); " ";
NEXT a%
Reply$ = "You are holding : "
RETURN

GetObject:
REM ############ PICK UP AN OBJECT ############
flag% = 0
FOR a% = 1 TO Objects%
  IF UCASE$(ObjectKey$(a%)) = W4$ THEN flag% = a%
NEXT a%
IF flag% = 0 THEN Reply$ = "I can't see a " + W4$: GOTO EndGetObject
IF VAL(LEFT$(ObjectInfo$(flag%), 2)) = 0 THEN Reply$ = "You're already carrying it! ": GOTO EndGetObject
IF (VAL(LEFT$(ObjectInfo$(flag%), 2)) > 0) AND (VAL(LEFT$(ObjectInfo$(flag%), 2)) <> CurrentLocation%) THEN Reply$ = "It isn't here!": GOTO EndGetObject
IF VAL(RIGHT$(ObjectInfo$(flag%), 2)) = 4 THEN Reply$ = "After a-heaving and a-hoing, you decide it's far too heavy to even lift.": GOTO EndGetObject
ObjectInfo$(flag%) = "00" + RIGHT$(ObjectInfo$(flag%), 2)
Reply$ = "You've picked up the " + W4$

EndGetObject:
RETURN

DropObject:
REM ############# DROP AN OBJECT ###############
flag% = 0
FOR a% = 1 TO Objects%
  IF UCASE$(ObjectKey$(a%)) = W2$ THEN flag% = a%
NEXT a%
IF flag% = 0 THEN Reply$ = "I can't see a " + W2$
IF VAL(LEFT$(ObjectInfo$(flag%), 2)) <> 0 THEN Reply$ = "You don't have it!": GOTO EndDropObject
temp$ = RIGHT$(STR$(CurrentLocation%), LEN(STR$(CurrentLocation%)) - 1)
IF LEN(temp$) = 1 THEN temp$ = "0" + temp$
ObjectInfo$(flag%) = temp$ + RIGHT$(ObjectInfo$(flag%), 2)
Reply$ = "You've dropped the " + W2$

EndDropObject:
RETURN


GetWord:
REM ############ SUBROUTINE ##########
NumberOfWords% = NumberOfWords% + 1
flag% = 0
'WHILE A - WordLength% > .9: WordLength% = WordLength% - 1: WEND
Word$(NumberOfWords%) = MID$(EntryString$, a - WordLength%, WordLength% + 1)
WordLength% = 0
RETURN

InputStats:
REM ############ INPUT STATS ##########
LOCATE 11, 1: COLOR 7: PRINT "Number of words : "; NumberOfWords%
PRINT "Number of Sentences : "; NumberOfSentences%
PRINT "Average sentence length was : "; (NumberOfWords% / NumberOfSentences%); "words long"
LOCATE 17, 1: FOR a = 1 TO 8: PRINT Word$(a); "   "; : NEXT a
WHILE INKEY$ = "": WEND
RETURN

UnlockDoor:
REM ############ UNLOCK DOOR ############
flag% = 0: flag2% = 0
FOR a% = 1 TO 8 STEP 2
  IF MID$(Barrier$(CurrentLocation%), a%, 2) = "02" THEN flag% = flag% + 1: flag2% = a%
NEXT a%
IF flag% = 0 THEN Reply$ = "There are no doors here!"
IF flag% > 1 AND W2$ = "DOOR" AND W3$ = "" THEN Reply$ = "Which door?"
IF flag% > 1 AND W2$ = "DOOR" AND W3$ <> "" THEN Reply$ = "Sorry, my head hurts with all these doors!"
IF flag% = 1 THEN MID$(Barrier$(CurrentLocation%), flag2%, 2) = "03": Reply$ = "Door is now unlocked"
RETURN

OpenDoor:
REM ############# OPEN DOOR ###############
flag% = 0: flag2% = 0
FOR a% = 1 TO 8 STEP 2
  IF MID$(Barrier$(CurrentLocation%), a%, 2) = "03" THEN flag% = flag% + 1: flag2% = a%
NEXT a%
IF flag% = 0 THEN Reply$ = "There are no doors here!"
IF flag% > 1 AND W2$ = "DOOR" AND W3$ = "" THEN Reply$ = "Which door?"
IF flag% > 1 AND W2$ = "DOOR" AND W3$ <> "" THEN Reply$ = "Sorry, my head hurts with all these doors!"
IF flag% = 1 THEN MID$(Barrier$(CurrentLocation%), flag2%, 2) = "00": Reply$ = "Door is now open"
RETURN

SUB DrawHeader

360 CLS
370 FOR a = 1 TO 79
380 LOCATE 1, a: COLOR 4: PRINT "€"
390 LOCATE 2, a: COLOR 12: PRINT "±"
400 LOCATE 4, a: COLOR 12: PRINT "±"
410 LOCATE 5, a: COLOR 4: PRINT "€"
420 NEXT a
430 LOCATE 3, 1: PRINT "€"; : COLOR 12: PRINT "±±±"
440 LOCATE 3, 76: PRINT "±±±"; : COLOR 4: PRINT "€"
450 LOCATE 2, 1: PRINT "€€": LOCATE 2, 78: PRINT "€€"
460 LOCATE 4, 1: PRINT "€€": LOCATE 4, 78: PRINT "€€"
470 COLOR 14: LOCATE 3, 25: PRINT "TEXT ADVENTURE : SAVE THE PRINCESS"

END SUB

SUB Help

LOCATE 22, 1: PRINT "HELP QUIT GO RUN WALK CRAWL HOP GET TAKE GRAB 'PICK UP' INVENTORY RUMMAGE"
LOCATE 23, 1: PRINT "DROP RESTART UNLOCK OPEN"
Reply$ = "All I can offer is this list of keywords"

END SUB

SUB IntroScreen

SCREEN 9: CLS

a$ = "TEXT ADVENTURE : SAVE THE PRINCESS"
RAND = 0

COLOR 2: LOCATE 2, (80 - LEN(a$)) / 2: PRINT a$
COLOR 10: LOCATE 5, 1

PRINT "ADVENTURE is a text adventure where you type in simple commands to complete"
PRINT "the game.   You are the local hero, and must save the princess from the clutchesof the evil witch.   The evil witch lives in a castle and has imprisoned the"
PRINT "princess in a dungeon.   You must save her.   Use commands like GO NORTH or     TAKE FOOD or KISS FROG to control your character."

LOCATE 20, 33: COLOR 12: PRINT "Press any key"

a$ = ""
WHILE a$ = "": a$ = INKEY$: RAND = RAND + .1: WEND
RAND = RAND - VAL(TIME$)
RANDOMIZE RAND

END SUB

SUB QuitFunction

LOCATE 22, 1: PRINT "Are you sure you want to quit this game (Y)es or (N)o ?"

WHILE a$ = "": a$ = UCASE$(INKEY$): WEND
IF a$ = "Y" THEN QuitScreenConfirm

Reply$ = "Quit action cancelled"

END SUB

SUB QuitScreenConfirm

LOCATE 22, 1: PRINT "Are you REALLY sure that you want to quit my game (Y)es or (N)o ?"

a$ = "": WHILE a$ = "": a$ = UCASE$(INKEY$): WEND
IF a$ = "Y" THEN CLOSE ALL: SYSTEM

END SUB

SUB RESTART

LOCATE 22, 1: PRINT "Are you sure you want to restart this game (Y)es or (N)o ?"

WHILE a$ = "": a$ = UCASE$(INKEY$): WEND
IF a$ = "Y" THEN RestartConfirm

Reply$ = "Quit action cancelled"

END SUB

SUB RestartConfirm

LOCATE 22, 1: PRINT "Are you REALLY sure that you want to restart my game (Y)es or (N)o ?"

a$ = "": WHILE a$ = "": a$ = UCASE$(INKEY$): WEND
IF a$ = "Y" THEN RUN

END SUB

