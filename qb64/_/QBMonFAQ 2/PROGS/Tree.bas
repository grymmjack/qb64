'***************************************************************************
' TREE.BAS = Displays all directories of a drive
' ========   Listet alle Verzeichnisse eines Laufwerks auf
'
' Deutsche Beschreibung
' ----------------------
' Dieses QuickBASIC-Programm arbeitet aehnlich wie der TREE-Befehl von DOS
' und zeigt eine Liste aller Verzeichnisse eines Laufwerks auf dem
' Bildschirm an. Das Programm ist unter QuickBASIC 4.5 lauffaehig und nicht
' unter QBasic, weil der INTERRUPTX-Befehl verwendet wird. QuickBASIC muss
' mit der Option "/L" aufgerufen weden, also z.B. mit "QB.EXE /L TREE.BAS" .
'
' English Description
' ----------------------
' QUESTION: Hi all, I am looking for a way in Quick Basic 4.5 to put all
' of the directories on the current drive into a file.  Any ideas?
'
' ANSWER: How about SHELL TREE > file.nam? Ha, Ha, Ha, Ha, Ha,  That's a
' good one. Now Listen up Paul I didn't write this it's about as HOT as
' the day is :-). I converted it back to QB for ya.
'
' (c) Steve Demo, July 5, 1993
'*****************************************************************************
'$INCLUDE: 'qb.bi'
DECLARE SUB Tree (drive$, Count!, Array$())
DEFINT A-Z
CONST DOS = &H21
CONST SetDTA = &H1A00, FindFirst = &H4E00, FindNext = &H4F00  ' These
'Const are for Tree sub
DIM Array$(700)
Tree "C:\", Count!, Array$()
FOR x = 1 TO Count! STEP 1
  IF Array$(x) = "" THEN END
  PRINT Array$(x)
NEXT x
'
SUB Tree (drive$, Count!, Array$())
DIM r AS RegTypeX
search$ = drive$                                   'reassign string since it
IF Count! = 0 THEN                                 'gets changed in routine
  search$ = UCASE$(search$)                        'make upper case
  IF LEN(search$) = 1 THEN search$ = search$ + ":" 'define search
  search$ = LEFT$(search$, 2)
  Count! = 1
  Array$(Count!) = search$ + "\"
END IF
'
zero$ = CHR$(0): DTA$ = SPACE$(43) '43  'define ZERO and DTA
search$ = search$ + "\"
srch$ = search$ + "*" + zero$          'DOS requires zero terminated string
'
'get original dta
r.ax = &H2F00
INTERRUPTX &H21, r, r
sgmt = r.es: ofst = r.bx               'save segment and offset of dta
mode = &H4E00                          'set mode to FINDFIRST
'
'set our dta
DO
 r.ax = &H1A00
 r.ds = VARSEG(DTA$): r.dx = SADD(DTA$)  'change SSEG to VARSEG in qb
 INTERRUPTX &H21, r, r                 'tell dos where this dta is

 r.ax = mode                           'findfirst, or findnext
 r.cx = 16                             'look for directories
 r.ds = VARSEG(srch$): r.dx = SADD(srch$)'change SSEG to VARSEG in qb
 INTERRUPTX &H21, r, r                 'find one
 IF (r.flags AND 1) THEN EXIT DO       'if none, bail
 f.attr = ASC(MID$(DTA$, 22))          'attribute in f.attr
 tmp$ = MID$(DTA$, 31) + zero$
 f.name$ = LEFT$(tmp$, INSTR(tmp$, zero$) - 1)  'directory name in f.name
 mode = &H4F00                         'change mode to FINDNEXT
 IF ASC(f.name$) <> 46 THEN            'we don't want '.' or '..'
   IF f.attr = 16 THEN                 'make sure it's a directory
  Count! = Count! + 1                  'increment Count!
  s$ = search$ + f.name$               'full path name
  Array$(Count!) = s$                  'add to array
  Tree s$, Count!, Array$()            'look for some dirs here
   END IF
 END IF
LOOP
r.ax = &H1A00
r.ds = sgmt: r.dx = ofst               'return original dta segment & offset
INTERRUPTX &H21, r, r
END SUB

