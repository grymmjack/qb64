'=========
'SPLIT.BAS
'=========
'A File Splitter & rejoiner program.
'Splits file into smaller seperate parts
'and later rejoins them re-creating original file.

'Coded by Dav

'====================================
' USE THIS PROGRAM AT YOUR OWN RISK!
'====================================

'I wrote this tool to help put larger files, that wouldn't fit
'onto a 1.45 MB floppy, onto my old laptop which had a floppy dirve.

'SPLIT will take a big file and save it as a series of smaller files
'using a BASE name (8 letters max). You can specify the BASE name and
'the byte size of the segments to save them as.

'For example, if you have a 2MB file named BIGFILE.ZIP, and split it
'using a BASE name of BIG, using 500000 byte size for each part will create
'four smaller files - each 500000 bytes in size. The files will be saved in
'order like this: BIG.000, BIG.001, BIG.002, BIG.003.

'Later, after saving all the parts to the directory where you want to re-
'create the big file, run SPLIT again, this time selecting 'Combine files'
'and all the files will be rejoined creating the BIGFILE.ZIP file.
'Of course, you would need ALL the parts to reassemble the original file.
'There is NO error checking in this program, so do you own checking.

'NOTE:
' For speed, a chunk size of 1024 is used when copying data. Because of
' this, the splitted files may not be the same as you give but will be
' as close to it as possible - give or take 1K bytes. If you want to
' play around the chunk size, look for the buffer% variable and specify
' your own value.


DEFINT A-Z

PRINT "=========="
PRINT "SPLIT v1.0"
PRINT "=========="
INPUT "(S)plit or (C)ombine file"; huh$: huh$ = UCASE$(huh$)

SELECT CASE huh$
   CASE "S": GOTO SPLIT:
   CASE "C": GOTO COMB:
   CASE ELSE: END
END SELECT


SPLIT:

   INPUT "Name of file to split => ", filename$
     IF filename$ = "" THEN END
   INPUT "BASE name of the part => ", basename$
     IF basename$ = "" THEN END
   INPUT "Size (bytes) for part => ", partsize
     IF partsize = 0 THEN END

   OPEN filename$ FOR BINARY AS #1
   IF LOF(1) = 0 THEN
      PRINT filename$; " not found."
      KILL filename$: CLOSE
      END
   END IF
  
   part% = 0

   WHILE NOT EOF(1)
     
      Ext$ = LTRIM$(STR$(part%))
      SELECT CASE LEN(Ext$)
        CASE IS = 1: Ext$ = "00" + Ext$
        CASE IS = 2: Ext$ = "0" + Ext$
      END SELECT

      F$ = basename$ + "." + Ext$
      OPEN F$ FOR OUTPUT AS #2
     
      TotalBytes& = 0
      Buffer% = 1024
      WHILE (NOT EOF(1)) AND (TotalBytes& < partsize)
         IF partsize - TotalBytes& < 1024 THEN
           Buffer% = partsize - TotalBytes&
         ELSE
           Buffer% = 1024
         END IF
         IF Buffer% > partsize THEN Buffer% = partsize
         CHUNK$ = INPUT$(Buffer%, 1): Bytes& = LEN(CHUNK$)
         TotalBytes& = TotalBytes& + Bytes&
         PRINT #2, CHUNK$;
      WEND
      CLOSE 2
      part% = part% + 1
      PRINT "Saved"; part%; "file(s)."
   WEND

   CLOSE
   END


COMB:

   INPUT "BASE name of Files => ", Pieces$
   INPUT "Name of output file => ", Whole$

   OPEN Whole$ FOR OUTPUT AS #1

   part% = 0

   DO

      Ext$ = LTRIM$(STR$(part%))
      SELECT CASE LEN(Ext$)
        CASE IS = 1: Ext$ = "00" + Ext$
        CASE IS = 2: Ext$ = "0" + Ext$
      END SELECT
    
      F$ = Pieces$ + "." + Ext$
      OPEN F$ FOR BINARY AS #2
      IF LOF(2) = 0 THEN
        CLOSE : KILL F$: END
      END IF

      WHILE NOT EOF(2)
         CHUNK$ = INPUT$(1024, 2): PRINT #1, CHUNK$;
      WEND
   
      CLOSE 2: part% = part% + 1
      PRINT "Joined"; part%; "file(s)."
  
   LOOP
  
   CLOSE
  
   END
