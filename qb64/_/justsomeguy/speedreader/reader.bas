'$dynamic
OPTION _EXPLICIT

TYPE tTXTSEGMENT
  start AS LONG
  finish AS LONG
END TYPE


TYPE tMOUSE
  x AS LONG
  xl AS LONG
  y AS LONG
  yl AS LONG
  b1 AS _BYTE
  b1L AS _BYTE
  b1PE AS _BYTE ' positive edge
  hover AS _BYTE
END TYPE

TYPE tFONT
  size AS LONG ' Index to the handle
  handle AS STRING * 512
  fontName AS STRING * 128
  directory AS STRING * 128
END TYPE

TYPE tGUICONTROL
  img AS LONG
  toolTip AS STRING * 32
END TYPE

TYPE tGLOBALS
  font AS tFONT
  status AS LONG
  txtFileName AS STRING * 512
  speed AS LONG
  currentWord AS LONG
  avgWordLength AS SINGLE
  time AS SINGLE
  mouse AS tMOUSE
  os AS LONG
  foreColor AS LONG
  backColor AS LONG
END TYPE

CONST cPAUSE = 0
CONST cFF = 1
CONST cRWD = 2
CONST cSAVE = 4
CONST cLOAD = 8

CONST cGUI_EXIT = 1
CONST cGUI_NEXT = 2
CONST cGUI_PAUSE = 3
CONST cGUI_PREVIOUS = 4
CONST cGUI_REWIND = 5
CONST cGUI_PLAY = 6
CONST cGUI_SAVE = 7
CONST cGUI_LOAD = 8
CONST cGUI_UP = 9
CONST cGUI_DOWN = 10
CONST cGUI_MOUSE = 11
CONST cGUI_FF = 12
CONST cGUI_FCOLOR = 13
CONST cGUI_BCOLOR = 14
CONST cGUI_FONT_SIZE_INCREASE = 15
CONST cGUI_FONT_SIZE_DECREASE = 16
CONST cGUI_FONT_CHANGE = 17

DIM SHARED AS tGLOBALS __g ' Global Variables
DIM SHARED AS STRING __fileText
DIM SHARED AS tTXTSEGMENT __words(0)
DIM SHARED AS tGUICONTROL __gui(20)


main

SUB main STATIC
  OSStuff

  SCREEN _NEWIMAGE(1024, 768, 32)
  _TITLE "Reader"
  _PRINTMODE _KEEPBACKGROUND

  initGui
  setDefaults
  loadState

  IF NOT _FILEEXISTS("reader.cfg") THEN
    _MESSAGEBOX "Reader App", "Please open a text file for reading. This only needs to be done once.", "info"
    __g.txtFileName = _OPENFILEDIALOG$("Open Text File", "", "*.txt", "Text files", -1)
    IF _TRIM$(__g.txtFileName) = "" THEN SYSTEM
    loadFile __g.txtFileName, __fileText
    breakTextSpace __fileText, __words()
    _MESSAGEBOX "Reader App", "Please open a font file for the reader. This only needs to be done once.", "info"
    __g.font.fontName = _OPENFILEDIALOG$("Open Font File", _TRIM$(__g.font.directory), "*.ttf|*.otf", "True Type Font Files", -1)
    IF _TRIM$(__g.font.fontName) <> "" THEN
      _FONT 14
      clearFonts
      loadFonts
      _FONT getArrayLong(__g.font.handle, __g.font.size)
    ELSE
      SYSTEM
    END IF

  END IF

  __g.currentWord = loadPlace(__g.txtFileName)
  __g.status = _SETBIT(__g.status, cPAUSE)

  loadFonts

  _FONT getArrayLong(__g.font.handle, __g.font.size)

  DIM AS STRING w
  DIM AS SINGLE dly, estDly

  DO
    CLS , __g.backColor
    handleInput __g.currentWord, __g.speed
    w = stringOnLine$(__fileText, __words(), __g.currentWord)
    estDly = (__g.avgWordLength * (20 / __g.speed)) + (60 / __g.speed)
    dly = (lenUnicode(w) * (20 / __g.speed)) + (60 / __g.speed)
    IF _READBIT(__g.status, cPAUSE) THEN printInfo estDly
    printWord w
    controlFlow dly
    drawGUI
    _DISPLAY
  LOOP
END SUB

SUB setDefaults
  __g.backColor = _RGB32(32, 32, 32)
  __g.foreColor = _RGB32(255, 255, 255)
  __g.font.size = 120
  __g.speed = 600
  __g.time = TIMER(.001)
END SUB

SUB controlFlow (dly AS SINGLE)
  IF NOT _READBIT(__g.status, cPAUSE) THEN
    'skip empty words
    IF TIMER(.001) - __g.time > dly THEN
      DO
        __g.currentWord = __g.currentWord + 1
      LOOP UNTIL LEN(stringOnLine$(__fileText, __words(), __g.currentWord)) > 0
      __g.time = TIMER(.001)
    END IF
  END IF
  IF __g.currentWord > UBOUND(__words) THEN
    __g.status = _TOGGLEBIT(__g.status, cPAUSE)
    __g.currentWord = 0
  END IF
END SUB

SUB printInfo (dly AS SINGLE)
  STATIC avg AS SINGLE
  DIM AS STRING title, info
  title = _TRIM$(__g.txtFileName)
  IF __g.os = 1 OR __g.os = 4 THEN
    title = MID$(title, _INSTRREV(title, "/") + 1)
  ELSE
    title = MID$(title, _INSTRREV(title, "\") + 1)
  END IF
  avg = (avg + dly) / 2
  _FONT 14
  _PRINTSTRING ((_WIDTH / 2) - (_PRINTWIDTH(title) / 2), 0), title
  info = "Progress:" + STR$(INT((__g.currentWord / UBOUND(__words)) * 100)) + "%  Current Word:" + STR$(__g.currentWord) + " out of " + STR$(UBOUND(__words)) + ". WPM:" + STR$(INT(60 / avg))
  _PRINTSTRING ((_WIDTH / 2) - (_PRINTWIDTH(info) / 2), 20), info

END SUB

SUB printWord (w AS STRING)
  _FONT getArrayLong(__g.font.handle, __g.font.size): COLOR __g.foreColor
  printUnicode w, (_WIDTH / 2) - (widthUnicode(w) / 2), (_HEIGHT / 2) - (_FONTHEIGHT / 2)
END SUB

SUB drawGUI
  DIM AS LONG guiPx, guiPy
  guiPx = _WIDTH / 2 - (_WIDTH(__gui(cGUI_PLAY).img) / 2)
  guiPy = _HEIGHT - 160
  drawGuiButton cGUI_PREVIOUS, guiPx - 100, guiPy
  IF _READBIT(__g.status, cPAUSE) THEN
    drawGuiButton cGUI_PLAY, guiPx, guiPy
    drawGuiButton cGUI_FCOLOR, 10, _HEIGHT - 32
    drawGuiButton cGUI_BCOLOR, 42, _HEIGHT - 32
    drawGuiButton cGUI_FONT_CHANGE, 74, _HEIGHT - 32
    drawGuiButton cGUI_FONT_SIZE_DECREASE, 174, _HEIGHT - 32
    drawGuiButton cGUI_FONT_SIZE_INCREASE, 206, _HEIGHT - 32
    drawGuiButton cGUI_LOAD, guiPx - 300, guiPy
  ELSE
    drawGuiButton cGUI_PAUSE, guiPx, guiPy
  END IF
  drawGuiButton cGUI_NEXT, guiPx + 100, guiPy
  drawGuiButton cGUI_FF, guiPx + 200, guiPy
  drawGuiButton cGUI_REWIND, guiPx - 200, guiPy
  drawGuiButton cGUI_EXIT, _WIDTH - 120, guiPy

END SUB

SUB OSStuff
  DIM AS LONG x
  x = _EXIT
  __g.os = ABS(INSTR(, _OS$, "[LINUX]") > 0) + (ABS(INSTR(, _OS$, "[WINDOWS]") > 0) * 2) + (ABS(INSTR(, _OS$, "[MACOSX]") > 0) * 4)
  IF __g.os = 1 THEN
    __g.font.directory = _CWD$ + "/Assets/fonts/" '"/usr/share/fonts/"
  ELSE IF __g.os = 2 THEN
      __g.font.directory = _CWD$ + "\Assets\fonts\" ' "c:\Windows\Fonts\"
    ELSE
      IF __g.os = 4 THEN
        __g.font.directory = _CWD$ + "/Assets/fonts/" ' "~/Library/Fonts/"
      ELSE
        PRINT "Unknown OS. Unable to set default font directory!"
      END IF
    END IF
  END IF
END SUB

SUB loadFonts
  DIM AS LONG iter
  FOR iter = 24 TO 144
    setArrayLong __g.font.handle, iter, _LOADFONT(_TRIM$(__g.font.fontName), iter)
  NEXT
END SUB

SUB clearFonts
  DIM AS LONG iter, f
  FOR iter = 24 TO 144
    f = getArrayLong(__g.font.handle, iter)
    IF f > 0 THEN _FREEFONT getArrayLong(__g.font.handle, iter)
  NEXT
END SUB

SUB handleInput (indx AS LONG, sp AS LONG)
  DIM AS LONG k, p, c
  DIM AS STRING temp
  k = _KEYHIT
  _KEYCLEAR
  IF k = 32 THEN __g.status = _TOGGLEBIT(__g.status, cPAUSE)
  IF k = 18432 THEN sp = sp + 50
  IF k = 20480 THEN sp = sp - 50
  IF sp > 1600 THEN sp = 1600
  IF sp < 200 THEN sp = 200

  IF k = 19200 THEN __g.status = _SETBIT(__g.status, cPAUSE): indx = prevSentence(__fileText, __words(), indx)
  IF k = 19712 THEN __g.status = _SETBIT(__g.status, cPAUSE): indx = nextSentence(__fileText, __words(), indx)
  IF k = ASC("l") OR k = ASC("L") THEN __g.status = _SETBIT(__g.status, cPAUSE): indx = loadPlace(__g.txtFileName)
  IF k = ASC("s") OR k = ASC("S") THEN __g.status = _SETBIT(__g.status, cPAUSE): savePlace __g.txtFileName, indx
  IF k = ASC("f") OR k = ASC("F") THEN
    __g.font.fontName = _OPENFILEDIALOG$("Open Font File", _TRIM$(__g.font.directory), "*.ttf|*.otf", "True Type Font Files", -1)
    IF _TRIM$(__g.font.fontName) <> "" THEN
      _FONT 14
      clearFonts
      loadFonts
      _FONT getArrayLong(__g.font.handle, __g.font.size)
    END IF
  END IF

  IF k = ASC("[") THEN
    decreaseFontSize
  END IF

  IF k = ASC("]") THEN
    increaseFontSize
  END IF

  IF k = ASC("1") THEN
    __g.status = _SETBIT(__g.status, cPAUSE)
    c = _COLORCHOOSERDIALOG("Select a textcolor", __g.foreColor)
    IF c <> 0 AND c <> __g.backColor THEN __g.foreColor = c
  END IF

  IF k = ASC("2") THEN
    __g.status = _SETBIT(__g.status, cPAUSE)
    c = _COLORCHOOSERDIALOG("Select a background color", __g.backColor)
    IF c <> 0 AND c <> __g.foreColor THEN __g.backColor = c
  END IF


  IF _EXIT OR k = 27 THEN savePlace __g.txtFileName, indx: saveState: SYSTEM

  __g.mouse.xl = __g.mouse.x
  __g.mouse.yl = __g.mouse.y
  __g.mouse.b1L = __g.mouse.b1

  DO WHILE _MOUSEINPUT '      Check the mouse status
    __g.mouse.x = _MOUSEX
    __g.mouse.y = _MOUSEY
    __g.mouse.b1 = _MOUSEBUTTON(1)
  LOOP
  __g.mouse.b1PE = __g.mouse.b1 AND NOT __g.mouse.b1L
  _SOURCE __gui(cGUI_MOUSE).img
  p = _RED32(POINT(__g.mouse.x, __g.mouse.y))
  __g.mouse.hover = p
  _SOURCE 0
  IF __g.mouse.b1PE THEN
    SELECT CASE p
      CASE cGUI_EXIT
        savePlace __g.txtFileName, indx: saveState: SYSTEM
      CASE cGUI_NEXT
        __g.status = _SETBIT(__g.status, cPAUSE): indx = nextSentence(__fileText, __words(), indx)
      CASE cGUI_PAUSE
        __g.status = _TOGGLEBIT(__g.status, cPAUSE)
      CASE cGUI_PREVIOUS
        __g.status = _SETBIT(__g.status, cPAUSE): indx = prevSentence(__fileText, __words(), indx)
      CASE cGUI_REWIND
        sp = sp - 50
      CASE cGUI_PLAY
        __g.status = _TOGGLEBIT(__g.status, cPAUSE)
        'CASE cGUI_SAVE
        '  __g.status = _SETBIT(__g.status, cPAUSE): savePlace __g.txtFileName, indx
      CASE cGUI_LOAD
        temp = _OPENFILEDIALOG$("Open Text File", "", "*.txt", "Text files", -1)
        IF _TRIM$(temp) <> "" THEN
          __g.txtFileName = temp
          __fileText = ""
          REDIM AS tTXTSEGMENT __words(0)
          loadFile __g.txtFileName, __fileText
          breakTextSpace __fileText, __words()
          indx = loadPlace(__g.txtFileName)
        END IF
      CASE cGUI_UP
      CASE cGUI_DOWN
      CASE cGUI_FF
        sp = sp + 50
      CASE cGUI_FCOLOR
        __g.status = _SETBIT(__g.status, cPAUSE)
        c = _COLORCHOOSERDIALOG("Select a textcolor", __g.foreColor)
        IF c <> 0 AND c <> __g.backColor THEN __g.foreColor = c
      CASE cGUI_BCOLOR
        __g.status = _SETBIT(__g.status, cPAUSE)
        c = _COLORCHOOSERDIALOG("Select a background color", __g.backColor)
        IF c <> 0 AND c <> __g.foreColor THEN __g.backColor = c
      CASE cGUI_FONT_SIZE_INCREASE
        increaseFontSize
      CASE cGUI_FONT_SIZE_DECREASE
        decreaseFontSize
      CASE cGUI_FONT_CHANGE
        temp = _OPENFILEDIALOG$("Open Font File", _TRIM$(__g.font.directory), "*.ttf|*.otf", "True Type Font Files", -1)
        IF _TRIM$(temp) <> "" THEN
          __g.font.fontName = temp
          _FONT 14
          clearFonts
          loadFonts
          _FONT getArrayLong(__g.font.handle, __g.font.size)
        END IF
    END SELECT
  END IF
END SUB

SUB increaseFontSize
  DIM AS LONG f
  f = __g.font.size
  DO
    f = f + 1
  LOOP WHILE f < 144 AND getArrayLong(__g.font.handle, f) <= 0
  IF getArrayLong(__g.font.handle, f) > 0 THEN
    _FONT getArrayLong(__g.font.handle, f)
    __g.font.size = f
  END IF

END SUB

SUB decreaseFontSize
  DIM AS LONG f
  f = __g.font.size
  DO
    f = f - 1
  LOOP WHILE f > 24 AND getArrayLong(__g.font.handle, f) <= 0
  IF getArrayLong(__g.font.handle, f) > 0 THEN
    _FONT getArrayLong(__g.font.handle, f)
    __g.font.size = f
  END IF

END SUB

SUB savePlace (fln AS STRING, wc AS LONG)
  OPEN _TRIM$(fln) + ".bk" FOR OUTPUT AS #2
  PRINT #2, wc
  CLOSE #2
END SUB

FUNCTION loadPlace (fln AS STRING)
  DIM AS LONG wc
  IF _FILEEXISTS(_TRIM$(fln) + ".bk") THEN
    OPEN _TRIM$(fln) + ".bk" FOR INPUT AS #2
    INPUT #2, wc
    CLOSE #2
  END IF
  loadPlace = wc
END FUNCTION

FUNCTION stringOnLine$ (txt AS STRING, segment() AS tTXTSEGMENT, l AS LONG)
  stringOnLine = MID$(txt, segment(l).start, segment(l).finish)
END FUNCTION

SUB breakTextLine (txt AS STRING, segment() AS tTXTSEGMENT)
  DIM AS LONG start, segm, segmentCount
  segmentCount = 0
  start = 1
  DO
    segm = INSTR(start, txt, CHR$(10))
    IF segm THEN
      segment(segmentCount).start = start
      segment(segmentCount).finish = segm - start
      start = segm + 1
      segmentCount = segmentCount + 1
      IF segmentCount > UBOUND(segment) THEN REDIM _PRESERVE segment(UBOUND(segment) + 1) AS tTXTSEGMENT
    END IF
  LOOP UNTIL segm = 0

END SUB

FUNCTION prevSentence (txt AS STRING, segment() AS tTXTSEGMENT, indx AS LONG)
  DIM AS LONG i, c: i = indx: c = 0
  DIM AS STRING w
  DO WHILE i > 0
    i = i - 1
    w = MID$(txt, segment(i).start, segment(i).finish)
    IF INSTR(w, ".") OR INSTR(w, "?") OR INSTR(w, "!") THEN
      c = c + 1
      IF c > 1 THEN
        prevSentence = i + 1
        EXIT FUNCTION
      END IF
    END IF
  LOOP
  prevSentence = 0
END FUNCTION

FUNCTION nextSentence (txt AS STRING, segment() AS tTXTSEGMENT, indx AS LONG)
  DIM AS LONG i: i = indx
  DIM AS STRING w
  DO WHILE i < UBOUND(segment)
    i = i + 1
    w = MID$(txt, segment(i).start, segment(i).finish)
    IF INSTR(w, ".") OR INSTR(w, "?") OR INSTR(w, "!") THEN
      nextSentence = i + 1
      EXIT FUNCTION
    END IF
  LOOP
  nextSentence = UBOUND(segment)
END FUNCTION

SUB breakTextSpace (txt AS STRING, segment() AS tTXTSEGMENT)
  DIM AS LONG start, segment, segmentCount, wsp
  segmentCount = 0
  start = 1
  DO
    segment = INSTR(start, txt, " ")
    wsp = INSTR(start, txt, CHR$(10))
    IF wsp > 0 AND wsp < segment THEN segment = wsp
    IF segment THEN
      IF segment - start > 0 THEN
        segment(segmentCount).start = start
        segment(segmentCount).finish = segment - start
        __g.avgWordLength = (__g.avgWordLength + segment(segmentCount).finish) / 2
        segmentCount = segmentCount + 1
        IF segmentCount > UBOUND(segment) THEN REDIM _PRESERVE segment(UBOUND(segment) + 1) AS tTXTSEGMENT
      END IF
      start = segment + 1
    END IF
  LOOP UNTIL segment = 0

END SUB


SUB loadFile (file AS STRING, fileText AS STRING)
  DIM AS LONG fileHandle, fileSize
  IF _FILEEXISTS(_TRIM$(file)) THEN
    fileHandle = FREEFILE
    fileText = ""
    ' Open file just to retrieve its length
    OPEN _TRIM$(file) FOR INPUT AS #fileHandle
    fileSize = LOF(fileHandle)
    CLOSE #fileHandle
    ' Now open it for real
    OPEN _TRIM$(file) FOR RANDOM AS #fileHandle LEN = fileSize
    FIELD #fileHandle, fileSize AS fileText
    GET #fileHandle, 1
    CLOSE #fileHandle
  ELSE
    PRINT "File '"; _TRIM$(file); "' does not exist."
    END
  END IF
END SUB

SUB printUnicode (s AS STRING, x AS LONG, y AS LONG)
  DIM AS INTEGER index
  DIM AS LONG unicode, xp
  xp = x
  index = 1
  DO
    unicode = UTF(s, index)
    IF unicode > 127 THEN
      _MAPUNICODE unicode TO 255
      _PRINTSTRING (xp, y), CHR$(255)
      xp = xp + _PRINTWIDTH(CHR$(255))
    ELSE
      _PRINTSTRING (xp, y), CHR$(unicode)
      xp = xp + _PRINTWIDTH(CHR$(unicode))
    END IF
  LOOP UNTIL index > LEN(s)
END SUB

FUNCTION lenUnicode (s AS STRING)
  DIM AS INTEGER index
  DIM AS LONG unicode, l
  l = 0
  index = 1
  DO
    unicode = UTF(s, index)
    l = l + 1
  LOOP UNTIL index > LEN(s)
  lenUnicode = l
END FUNCTION

FUNCTION widthUnicode (s AS STRING)
  DIM AS INTEGER index
  DIM AS LONG unicode, wd
  wd = 0
  index = 1
  DO
    unicode = UTF(s, index)
    IF unicode > 127 THEN
      _MAPUNICODE unicode TO 255
      wd = wd + _PRINTWIDTH(CHR$(255))
    ELSE
      wd = wd + _PRINTWIDTH(CHR$(unicode))
    END IF
  LOOP UNTIL index > LEN(s)
  widthUnicode = wd
END FUNCTION

FUNCTION UTF~& (s AS STRING, index AS INTEGER)
  DIM AS _UNSIGNED LONG unicode
  DIM AS _UNSIGNED _BYTE b1, b2, b3, b4
  unicode = 0
  IF index <= LEN(s) THEN
    b1 = ASC(MID$(s, index, 1))
    IF NOT _READBIT(b1, 7) THEN
      index = index + 1
      unicode = b1
    ELSE
      IF _READBIT(b1, 7) AND _READBIT(b1, 6) AND NOT _READBIT(b1, 5) THEN
        IF index + 1 > LEN(s) THEN ERROR 9
        b1 = b1 AND &H1F
        b2 = ASC(MID$(s, index + 1, 1)) AND &H3F
        unicode = _SHL(b1, 6) OR b2
        index = index + 2
      ELSE
        IF _READBIT(b1, 7) AND _READBIT(b1, 6) AND _READBIT(b1, 5) AND NOT _READBIT(b1, 4) THEN
          IF index + 2 > LEN(s) THEN ERROR 9
          b1 = b1 AND &H0F
          b2 = ASC(MID$(s, index + 1, 1)) AND &H3F
          b3 = ASC(MID$(s, index + 2, 1)) AND &H3F
          unicode = _SHL(b1, 12) OR _SHL(b2, 6) OR b3
          index = index + 3
        ELSE
          IF _READBIT(b1, 7) AND _READBIT(b1, 6) AND _READBIT(b1, 5) AND _READBIT(b1, 4) AND NOT _READBIT(b1, 3) THEN
            IF index + 3 > LEN(s) THEN ERROR 9
            b1 = b1 AND &H07
            b2 = ASC(MID$(s, index + 1, 1)) AND &H3F
            b3 = ASC(MID$(s, index + 2, 1)) AND &H3F
            b4 = ASC(MID$(s, index + 3, 1)) AND &H3F
            unicode = _SHL(b1, 18) OR _SHL(b2, 12) OR _SHL(b3, 6) OR b4
            index = index + 4
          ELSE
            ERROR 150: END
          END IF
        END IF
      END IF
    END IF
  END IF
  UTF = unicode
END FUNCTION

SUB initGui
  __gui(cGUI_EXIT).img = _LOADIMAGE(_CWD$ + "/Assets/exit.png", 32): __gui(cGUI_EXIT).toolTip = "Quit"
  __gui(cGUI_NEXT).img = _LOADIMAGE(_CWD$ + "/Assets/next.png", 32): __gui(cGUI_NEXT).toolTip = "Next Word"
  __gui(cGUI_PAUSE).img = _LOADIMAGE(_CWD$ + "/Assets/pause.png", 32): __gui(cGUI_PAUSE).toolTip = "Pause"
  __gui(cGUI_PREVIOUS).img = _LOADIMAGE(_CWD$ + "/Assets/previous.png", 32): __gui(cGUI_PREVIOUS).toolTip = "Previous Word"
  __gui(cGUI_REWIND).img = _LOADIMAGE(_CWD$ + "/Assets/rewind.png", 32): __gui(cGUI_REWIND).toolTip = "Slower"
  __gui(cGUI_PLAY).img = _LOADIMAGE(_CWD$ + "/Assets/right.png", 32): __gui(cGUI_PLAY).toolTip = "Play"
  __gui(cGUI_LOAD).img = _LOADIMAGE(_CWD$ + "/Assets/disk.png", 32): __gui(cGUI_LOAD).toolTip = "Load"
  __gui(cGUI_UP).img = _LOADIMAGE(_CWD$ + "/Assets/up.png", 32): __gui(cGUI_UP).toolTip = "Not used"
  __gui(cGUI_DOWN).img = _LOADIMAGE(_CWD$ + "/Assets/down.png", 32): __gui(cGUI_DOWN).toolTip = "Not used"
  __gui(cGUI_FF).img = _LOADIMAGE(_CWD$ + "/Assets/fastForward.png", 32): __gui(cGUI_FF).toolTip = "Faster"
  __gui(cGUI_FCOLOR).img = _LOADIMAGE(_CWD$ + "/Assets/TEXT1.png", 32): __gui(cGUI_FCOLOR).toolTip = "Foreground Color"
  __gui(cGUI_BCOLOR).img = _LOADIMAGE(_CWD$ + "/Assets/TEXT0.png", 32): __gui(cGUI_BCOLOR).toolTip = "Background Color"
  __gui(cGUI_FONT_SIZE_INCREASE).img = _LOADIMAGE(_CWD$ + "/Assets/fontPLUSsmall.png", 32): __gui(cGUI_FONT_SIZE_INCREASE).toolTip = "Increase Font Size"
  __gui(cGUI_FONT_SIZE_DECREASE).img = _LOADIMAGE(_CWD$ + "/Assets/fontMINUSsmall.png", 32): __gui(cGUI_FONT_SIZE_DECREASE).toolTip = "Decrease Font Size"
  __gui(cGUI_FONT_CHANGE).img = _LOADIMAGE(_CWD$ + "/Assets/fontChange.png", 32): __gui(cGUI_FONT_CHANGE).toolTip = "Change Font"

  IF __gui(cGUI_EXIT).img > -2 THEN PRINT "Did not load images!": END

  __gui(cGUI_MOUSE).img = _NEWIMAGE(_WIDTH, _HEIGHT, 32)
END SUB

SUB saveState
  OPEN "reader.cfg" FOR OUTPUT AS #1
  PRINT #1, "txtfile="; _TRIM$(__g.txtFileName)
  PRINT #1, "speed="; __g.speed
  PRINT #1, "fontname="; _TRIM$(__g.font.fontName)
  PRINT #1, "fontsize="; __g.font.size
  PRINT #1, "forecolor="; __g.foreColor
  PRINT #1, "backcolor="; __g.backColor
  CLOSE #1
END SUB

SUB loadState
  DIM AS STRING in, param, arg
  IF _FILEEXISTS("reader.cfg") THEN
    OPEN "reader.cfg" FOR INPUT AS #1
    DO UNTIL EOF(1)
      INPUT #1, in
      IF LEN(in) > 0 THEN
        param = MID$(in, 1, INSTR(, in, "=") - 1)
        arg = MID$(in, _INSTRREV(in, "=") + 1)
        SELECT CASE param
          CASE "txtfile"
            __fileText = ""
            REDIM AS tTXTSEGMENT __words(0)
            __g.txtFileName = _TRIM$(arg)
            loadFile __g.txtFileName, __fileText
            breakTextSpace __fileText, __words()
            __g.currentWord = loadPlace(__g.txtFileName)
          CASE "speed"
            __g.speed = VAL(arg)
          CASE "fontname"
            IF _TRIM$(arg) <> "" THEN
              IF _FILEEXISTS(_TRIM$(arg)) THEN
                __g.font.fontName = _TRIM$(arg)
                _FONT 14
                clearFonts
                loadFonts
                _FONT getArrayLong(__g.font.handle, __g.font.size)
              END IF
            END IF
          CASE "fontsize"
            __g.font.size = VAL(arg)
          CASE "forecolor"
            __g.foreColor = VAL(arg)
          CASE "backcolor"
            __g.backColor = VAL(arg)
        END SELECT
      END IF
    LOOP
    CLOSE #1
  END IF
END SUB


SUB drawGuiButton (shape AS LONG, x AS LONG, y AS LONG)
  DIM AS LONG xp
  _PUTIMAGE (x, y), __gui(shape).img, 0
  IF __g.mouse.hover = shape THEN
    LINE (x, y)-(x + _WIDTH(__gui(shape).img), y + _HEIGHT(__gui(shape).img)), , B , &B0101010101010101
    _FONT 8
    _PRINTMODE _FILLBACKGROUND
    COLOR _RGB32(0), _RGB32(255, 255, 0)
    xp = __g.mouse.x - (_PRINTWIDTH(_TRIM$(__gui(shape).toolTip)) / 2): IF xp < 0 THEN xp = 0
    _PRINTSTRING (xp, __g.mouse.y - 16), _TRIM$(__gui(shape).toolTip)
    _PRINTMODE _KEEPBACKGROUND
  END IF
  _DEST __gui(cGUI_MOUSE).img
  LINE (x, y)-(x + _WIDTH(__gui(shape).img), y + _HEIGHT(__gui(shape).img)), _RGB32(shape, 0, 0), BF
  _DEST 0
END SUB

FUNCTION getArrayLong& (s AS STRING, p AS LONG)
  IF p > 0 AND p * 4 + 4 < LEN(s) THEN getArrayLong = CVL(MID$(s, p * 4, 4))
END FUNCTION

SUB setArrayLong (s AS STRING, p AS LONG, v AS LONG)
  IF p > 0 AND p * 4 + 4 < LEN(s) THEN MID$(s, p * 4) = MKL$(v)
END SUB



