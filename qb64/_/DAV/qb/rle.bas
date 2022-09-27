'=======
'RLE.BAS
'=======
'
'Example of using Run-Length-Encoding (RLE)
'to compress and decompress a SCREEN 13 image. 
'The original palette is saved and restored. 
'Both SUB's contain FULL documentation. 
'
'******************************************
'NOTE: This demo creates a 1,567 byte file
'named IMAGE.RLE in the current directory.
'******************************************

DEFINT A-Z

DECLARE SUB CompressRLE (filename$)
DECLARE SUB DecompressRLE (filename$)

SCREEN 13 'We have to be in this SCREEN mode.

'===============================================
'DEMO START: Let's draw something to save...
'===========

   FOR y% = 0 TO 199
     LINE (0, y%)-(319, y%), RND * 255
   NEXT

'Now we save the screen as a RLE image file.
   
    CompressRLE "IMAGE.RLE"
    PRINT "Screen saved as IMAGE.RLE"
    PRINT
    PRINT "Press any key to load..."

'A pause for the cause...
   
    SLEEP

'Now we load the image back on the screen.

    DecompressRLE "IMAGE.RLE"
    SLEEP

'=========
'DEMO OVER: That's all folks
'===============================================
END

SUB CompressRLE (filename$)
'================================================
'Saves SCREEN 13 to a file using RLE compression.
'================================================

'First we have to OPEN the image file to make.
   
    RLE = FREEFILE
    OPEN filename$ FOR OUTPUT AS RLE

'Now let's make a small header declaring our file as a
'RLE-compressed SCREEN 13 image file. Nothing fancy,
'just a short, simple 3 byte header like R13 will do.
   
    PRINT #RLE, "R13"; 'A genuine R13 image file.

'Saving the 768 byte palette info is the next step. For
'this we use INP to read in the values from the hardware
'port &H3C9 (969). I won't go into detail about that here.

    OUT 967, 0
    FOR C% = 1 TO 768
      PRINT #RLE, CHR$(INP(969));
    NEXT

'Here's were the RLE compression starts. A little explanation
'of RLE may be helpful, so I'll try to give one now. Suppose
'a image contains a run of the following characters: AAAAAAAAA.
'A shorter way of storing this information can be to say that
'the character `A' repeats nine times, or just write.... A9.
'As you can see, saying A9 is a lot shorter than AAAAAAAAA.
'One byte tells us the character, the other tells the length
'of the run of characters, hence the name, Run-Length-Encoding.
'So, a run like aaaaabbbbbbbbccccccccc would become....a5b8c9.
'This encoding method is not good for every image, only on ones
'that have many runs of repeating characters. In fact, on many
'images the resulting RLE file is bigger than the original, but
'for our image it's perfect, compressing 64,000 bytes to 796.
'Add our 3 byte header and 768 byte palette and we get 1,567.
'Got it so far? Let's continue...

'We'll use PEEK to grab the pixel value instead of POINT, so
'we need to define the right segment address before using it.

    DEF SEG = &HA000

'Let's go ahead and get the value of our first pixel.

    pixel% = PEEK(0) 'Like doing a POINT(0, 0)

'Now we'll cycle through all 64,000 pixels of SCREEN 13.
'Each newly read pixel value is compared to the last read
'pixel value. If the're the same, the repeater value goes
'up a point. If not, the last pixel and repeater value is
'saved and the repeater is reset, ready for the next
'comparison. This analyzing process continues until all
'64,000 pixels have been read. Since there are only 255
'ASCII characters available, the repeater is forced to
'reset if a value of 255 is reached. Remember now, the
'repeater number is the length of the run of pixels that
'are the same. So, a pixel value of 22 with a repeater
'value of 10, means 10 pixels with the color value 22.
'We would save it as this: CHR$(22) + CHR$(10).
'Here we go now....

    FOR pix& = 1 TO 64000 '64,000 pixels to do
      
       NewPixel% = PEEK(pix&) 'Get next pixel value.
                                    
        '===========
        POKE pix&, 0 'Erase the pixel -- just for show.
        '===========
          
           'If value is equal to last value read, and the
           'repeater% is not over 255, then add 1 to repeater%.
      
       IF NewPixel% = pixel% AND repeater% < 255 THEN
          repeater% = repeater% + 1
       ELSE
           
            'If not, save current pixel and repeater value.
         
          PRINT #RLE, CHR$(pixel%); CHR$(repeater%);
          pixel% = NewPixel% 'Swap value.
          repeater% = 0 'Reset repeater.
       END IF
    NEXT

'We're done saving, so CLOSE the file.

    CLOSE RLE

'Reset the segment we defined.
  
    DEF SEG

END SUB

SUB DecompressRLE (filename$)
'=============================================
'Loads an RLE compressed SCREEN 13 image file.
'=============================================

'Decompressing our RLE image is just as simple as
'compressing it. We just reverse the entire process.

'Let's OPEN our RLE file.
   
    RLE = FREEFILE: OPEN filename$ FOR BINARY AS RLE

'Check for a vaild R13 header. If it's not there
'we say so, CLOSE the file and EXIT this SUB.

    IF INPUT$(3, RLE) <> "R13" THEN
       PRINT "Invalid header."
       CLOSE RLE: EXIT SUB
    END IF

'Loading the palette info is next. Instead of using INP
'as during reading in the values, we use OUT to send the
'saved values OUT to hardware port &H3C9 (969).

    Pal$ = INPUT$(768, 1)
    OUT 968, 0
    FOR i% = 1 TO LEN(Pal$)
      OUT 969, ASC(MID$(Pal$, i%, 1))
    NEXT

'We're going to use POKE, not PSET, so let's first
'define the right segment address to use.

   DEF SEG = &HA000

'Now we decompress the image. The first byte we read in is
'the pixel value (color) to use, the second byte is the repeater
'value -- that is, how many times to repeat the pixel value.
'We keep a running pixel count (pix&) and stop when 64,000
'pixels have been drawn to the screen, or until the EOF is
'reached -- which ever comes first.

    pix& = 0 'Make sure we start at pixel 0

    DO WHILE NOT EOF(RLE)

          'first byte is the value of pixel color
       a$ = INPUT$(1, RLE): IF a$ = "" THEN a$ = CHR$(0)
       pixel% = ASC(a$)
         
          'second is the repeater value (how many to do)
       a$ = INPUT$(1, RLE): IF a$ = "" THEN a$ = CHR$(0)
       repeater% = ASC(a$)
         
          'Do all pixels that repeater% says
       FOR C% = 0 TO repeater%
          POKE pix&, pixel%
          pix& = pix& + 1 'Keep a running pixel count
          IF pix& = 64000 THEN EXIT DO 'If 64000 then quit
       NEXT
    LOOP

'We're done reading, so CLOSE the file.

    CLOSE RLE

'Reset the segment

    DEF SEG

END SUB

