''
' Sauce Reader (this will eventually also be a QB64_GJ_LIB module)
'
' This module works using 2 shared UDTs: 
'   SauceRecord - The actual sauce record structure fetched as BINARY with GET
'   SaucePacket - The filled in packet of sauce with friendly names and vars
'
' USAGE:
'   '$INCLUDE('SAUCE2.BAS')
'   DIM SHARED SauceRecord AS SAUCE
'   DIM SHARED SaucePacket AS SAUCE_PACKET
'   SAUCE.InitPacket
'   SAUCE.GetRecord F$
'   IF SauceRecord.ID$ = "SAUCE" THEN
'       SAUCE.FillPacket
'       SAUCE.PrintPacket
'   ELSE
'       PRINT "Invalid or no Sauce header found."
'   END IF
' 
' @see https://github.com/grymmjack/sauce
' @author Rick Christy <grymmjack@gmail.com>
'

TYPE SAUCE
    ID       AS STRING * 5
    Version  AS STRING * 2
    Title    AS STRING * 35
    Author   AS STRING * 20
    Group    AS STRING * 20
    Date     AS STRING * 8
    FileSize AS _UNSIGNED LONG
    DataType AS _UNSIGNED _BYTE
    FileType AS _UNSIGNED _BYTE
    TInfo1   AS _UNSIGNED INTEGER
    TInfo2   AS _UNSIGNED INTEGER
    TInfo3   AS _UNSIGNED INTEGER
    TInfo4   AS _UNSIGNED INTEGER
    Comments AS _UNSIGNED _BYTE
    TFlags   AS _UNSIGNED _BYTE
    TInfoS   AS STRING * 22
END TYPE

TYPE SAUCE_PACKET
    Comments              AS STRING
    DataType              AS STRING
    FileType              AS STRING
    CharacterWidth        AS _UNSIGNED INTEGER
    NumberOfLines         AS _UNSIGNED INTEGER
    NumberOfColors        AS _UNSIGNED INTEGER
    CharacterScreenHeight AS _UNSIGNED INTEGER
    IceColors             AS STRING
    FontName              AS STRING
    LetterSpacing         AS STRING
    AspectRatio           AS STRING
    PixelWidth            AS _UNSIGNED INTEGER
    PixelHeight           AS _UNSIGNED INTEGER
    PixelDepth            AS _UNSIGNED INTEGER
    SampleRate            AS _UNSIGNED INTEGER
END TYPE

DIM SHARED SAUCE_DATA_TYPE(0 TO 8) AS STRING
SAUCE_DATA_TYPE$(0) = "None"
SAUCE_DATA_TYPE$(1) = "Character"
SAUCE_DATA_TYPE$(2) = "Bitmap"
SAUCE_DATA_TYPE$(3) = "Vector"
SAUCE_DATA_TYPE$(4) = "Audio"
SAUCE_DATA_TYPE$(5) = "BinaryText"
SAUCE_DATA_TYPE$(6) = "XBin"
SAUCE_DATA_TYPE$(7) = "Archive"
SAUCE_DATA_TYPE$(8) = "Executable"

DIM SHARED SAUCE_CHARACTER_TYPES(0 TO 8) AS STRING
SAUCE_CHARACTER_TYPES$(0) = "ASCII"
SAUCE_CHARACTER_TYPES$(1) = "ANSI"
SAUCE_CHARACTER_TYPES$(2) = "ANSIMation"
SAUCE_CHARACTER_TYPES$(3) = "RIP script"
SAUCE_CHARACTER_TYPES$(4) = "PCBoard"
SAUCE_CHARACTER_TYPES$(5) = "Avatar"
SAUCE_CHARACTER_TYPES$(6) = "HTML"
SAUCE_CHARACTER_TYPES$(7) = "Source"
SAUCE_CHARACTER_TYPES$(7) = "TundraDraw"

DIM SHARED SAUCE_BITMAP_TYPES(0 TO 13) AS STRING
SAUCE_BITMAP_TYPES$(0) = "GIF"
SAUCE_BITMAP_TYPES$(1) = "PCX"
SAUCE_BITMAP_TYPES$(2) = "LBM/IFF"
SAUCE_BITMAP_TYPES$(3) = "TGA"
SAUCE_BITMAP_TYPES$(4) = "FLI"
SAUCE_BITMAP_TYPES$(5) = "FLC"
SAUCE_BITMAP_TYPES$(6) = "BMP"
SAUCE_BITMAP_TYPES$(7) = "GL"
SAUCE_BITMAP_TYPES$(8) = "DL"
SAUCE_BITMAP_TYPES$(9) = "WPG"
SAUCE_BITMAP_TYPES$(10) = "PNG"
SAUCE_BITMAP_TYPES$(11) = "JPG/JPeg"
SAUCE_BITMAP_TYPES$(12) = "MPG"
SAUCE_BITMAP_TYPES$(13) = "AVI"

DIM SHARED SAUCE_VECTOR_TYPES(0 TO 3) AS STRING
SAUCE_VECTOR_TYPES$(0) = "DXF"
SAUCE_VECTOR_TYPES$(1) = "DWG"
SAUCE_VECTOR_TYPES$(2) = "WPG"
SAUCE_VECTOR_TYPES$(3) = "3DS"

DIM SHARED SAUCE_AUDIO_TYPES(0 TO 24) AS STRING
SAUCE_AUDIO_TYPES$(0) = "MOD"
SAUCE_AUDIO_TYPES$(1) = "669"
SAUCE_AUDIO_TYPES$(2) = "STM"
SAUCE_AUDIO_TYPES$(3) = "S3M"
SAUCE_AUDIO_TYPES$(4) = "MTM"
SAUCE_AUDIO_TYPES$(5) = "FAR"
SAUCE_AUDIO_TYPES$(6) = "ULT"
SAUCE_AUDIO_TYPES$(7) = "AMF"
SAUCE_AUDIO_TYPES$(8) = "DMF"
SAUCE_AUDIO_TYPES$(9) = "OKT"
SAUCE_AUDIO_TYPES$(10) = "ROL"
SAUCE_AUDIO_TYPES$(11) = "CMF"
SAUCE_AUDIO_TYPES$(12) = "MID"
SAUCE_AUDIO_TYPES$(13) = "SADT"
SAUCE_AUDIO_TYPES$(14) = "VOC"
SAUCE_AUDIO_TYPES$(15) = "WAV"
SAUCE_AUDIO_TYPES$(16) = "SMP8"
SAUCE_AUDIO_TYPES$(17) = "SMP8S"
SAUCE_AUDIO_TYPES$(18) = "SMP16"
SAUCE_AUDIO_TYPES$(19) = "SMP16S"
SAUCE_AUDIO_TYPES$(20) = "PATCH8"
SAUCE_AUDIO_TYPES$(21) = "PATCH16"
SAUCE_AUDIO_TYPES$(22) = "XM"
SAUCE_AUDIO_TYPES$(23) = "HSC"
SAUCE_AUDIO_TYPES$(24) = "IT"

DIM SHARED SAUCE_ARCHIVE_TYPES(0 TO 9) AS STRING
SAUCE_ARCHIVE_TYPES$(0) = "ZIP"
SAUCE_ARCHIVE_TYPES$(1) = "ARJ"
SAUCE_ARCHIVE_TYPES$(2) = "LZH"
SAUCE_ARCHIVE_TYPES$(3) = "ARC"
SAUCE_ARCHIVE_TYPES$(4) = "TAR"
SAUCE_ARCHIVE_TYPES$(5) = "ZOO"
SAUCE_ARCHIVE_TYPES$(6) = "RAR"
SAUCE_ARCHIVE_TYPES$(7) = "UC2"
SAUCE_ARCHIVE_TYPES$(8) = "PAK"
SAUCE_ARCHIVE_TYPES$(9) = "SQZ"

DIM SHARED SauceRecord AS SAUCE
DIM SHARED SaucePacket AS SAUCE_PACKET
SAUCE.InitPacket



''
' Initialiaze the SaucePacket
' @return BYREF Empty SaucePacket filled ready to be filled
'
SUB SAUCE.InitPacket
    SauceRecord.ID$                     = SPACE$(5)
    SauceRecord.Version$                = SPACE$(2)
    SauceRecord.Title$                  = SPACE$(35)
    SauceRecord.Author$                 = SPACE$(20)
    SauceRecord.Group$                  = SPACE$(20)
    SauceRecord.Date$                   = SPACE$(8)
    SauceRecord.FileSize~&              = 0
    SauceRecord.DataType~%%             = 0
    SauceRecord.FileType~%%             = 0
    SauceRecord.Comments~%%             = 0
    SauceRecord.TInfo1~%                = 0
    SauceRecord.TInfo2~%                = 0
    SauceRecord.TInfo3~%                = 0
    SauceRecord.TInfo4~%                = 0
    SauceRecord.TFlags~%%               = 0
    SauceRecord.TInfoS$                 = SPACE$(22)
    SaucePacket.Comments$               = ""
    SaucePacket.DataType$               = ""
    SaucePacket.FileType$               = ""
    SaucePacket.CharacterWidth~%        = 0
    SaucePacket.NumberOfLines~%         = 0
    SaucePacket.CharacterScreenHeight~% = 0
    SaucePacket.NumberOfColors~%        = 0
    SaucePacket.IceColors$              = ""
    SaucePacket.FontName$               = ""
    SaucePacket.LetterSpacing$          = ""
    SaucePacket.AspectRatio$            = ""
    SaucePacket.PixelWidth~%            = 0
    SaucePacket.PixelHeight~%           = 0
    SaucePacket.PixelDepth~%            = 0
    SaucePacket.SampleRate~%            = 0
END SUB


''
' Fill the SaucePacket with data
' @return BYREF Filled SaucePacket
'
SUB SAUCE.FillPacket
    DIM AS STRING _
        DataType, _
        FileType, _
        IceColors, _
        FontName, _
        LetterSpacing, _
        AspectRatio
    DIM AS _UNSIGNED INTEGER _
        CharacterWidth, _
        NumberOfLines, _
        CharacterScreenHeight, _
        NumberOfColors, _
        PixelWidth, _
        PixelHeight, _
        PixelDepth, _
        SampleRate

    DataType$ = SAUCE_DATA_TYPE$(SauceRecord.DataType~%%)

    SELECT CASE SAUCE_DATA_TYPE$(SauceRecord.DataType~%%)
        CASE "None":
            DataType$ = "None"
            FileType$ = "None"
        CASE "Character":
            FileType$ = SAUCE_CHARACTER_TYPES$(SauceRecord.FileType~%%)
            SELECT CASE SAUCE_CHARACTER_TYPES$(SauceRecord.FileType~%%)
                CASE "ASCII", "ANSI", "PCBoard", "Avatar", "TundraDraw":
                    CharacterWidth~% = SauceRecord.TInfo1~%
                    NumberOfLines~%  = SauceRecord.TInfo2~%
                    FontName$        = SauceRecord.TInfoS$
                    SAUCE.ParseTFlags
                CASE "ANSIMation":
                    CharacterWidth~%        = SauceRecord.TInfo1~%
                    CharacterScreenHeight~% = SauceRecord.TInfo2~%
                    FontName$               = SauceRecord.TInfoS$
                    SAUCE.ParseTFlags
                CASE "RIP script":
                    PixelWidth~%     = SauceRecord.TInfo1~%
                    PixelHeight~%    = SauceRecord.TInfo2~%
                    NumberOfColors~% = SauceRecord.TInfo3~%
            END SELECT
        CASE "Bitmap":
            FileType$ = SAUCE_BITMAP_TYPES$(SauceRecord.FileType~%%)
            PixelWidth~%  = SauceRecord.TInfo1~%
            PixelHeight~% = SauceRecord.TInfo2~%
            PixelDepth~%  = SauceRecord.TInfo3~%
        CASE "Vector":
            FileType$ = SAUCE_VECTOR_TYPES$(SauceRecord.FileType~%%)
        CASE "Audio":
            FileType$ = SAUCE_AUDIO_TYPES$(SauceRecord.FileType~%%)
            SELECT CASE SAUCE_AUDIO_TYPES$(SauceRecord.FileType~%%)
                CASE "SMP8", "SMP8S", "SMP16", "SMP16S":
                    SampleRate~% = SauceRecord.TInfo1~%
            END SELECT
        CASE "BinaryText":
            FileType$ = "BinaryText"
            FontName$ = SauceRecord.TInfoS$
            SAUCE.ParseTFlags
        CASE "XBin":
            FileType$        = "XBin"
            CharacterWidth~% = SauceRecord.TInfo1~%
            NumberOfLines~%  = SauceRecord.TInfo2~%
        CASE "Archive":
            FileType$ = SAUCE_ARCHIVE_TYPES$(SauceRecord.FileType~%%)
        CASE "Executable":
            FileType$ = "Executable"
    END SELECT

    ' Fill the sauce packet...
    SaucePacket.DataType$        = DataType$
    SaucePacket.FileType$        = FileType$
    SaucePacket.CharacterWidth~% = CharacterWidth~%
    SaucePacket.NumberOfLines~%  = NumberOfLines~%
    SaucePacket.IceColors$       = SaucePacket.IceColors$
    SaucePacket.FontName$        = FontName$
    SaucePacket.LetterSpacing$   = SaucePacket.LetterSpacing$
    SaucePacket.AspectRatio$     = SaucePacket.AspectRatio$
    SaucePacket.PixelWidth~%     = PixelWidth~%
    SaucePacket.PixelHeight~%    = PixelHeight~%
    SaucePacket.PixelDepth~%     = PixelDepth~%
    SaucePacket.SampleRate~%     = SampleRate~%
END SUB


''
' Print SaucePacket
' @return void
'
SUB SAUCE.PrintPacket
    PRINT "Sauce ID:      "; SauceRecord.ID$
    PRINT "Sauce Version: "; SauceRecord.Version$
    PRINT  
    PRINT "Title:         "; SauceRecord.Title$
    PRINT "Author:        "; SauceRecord.Author$
    PRINT "Group:         "; SauceRecord.Group$
    PRINT "Date:          "; SauceRecord.Date$
    PRINT "FileSize:     "; SauceRecord.FileSize~&
    PRINT "DataType:     "; SauceRecord.DataType~%%; 
    PRINT "(" + SAUCE_DATA_TYPE$(SauceRecord.DataType~%%) + ")"
    PRINT "FileType:     "; SauceRecord.FileType~%%

    PRINT 

    SELECT CASE SAUCE_DATA_TYPE$(SauceRecord.DataType~%%)
        CASE "None":
            PRINT "No Data Type Detected"
        CASE "Character":
            PRINT "Character Data Type Detected: "; 
            PRINT SAUCE_CHARACTER_TYPES$(SauceRecord.FileType~%%)
            SELECT CASE SAUCE_CHARACTER_TYPES$(SauceRecord.FileType~%%)
                CASE "ASCII", "ANSI", "PCBoard", "Avatar", "TundraDraw":
                    PRINT "Character Width: "; SaucePacket.CharacterWidth~%
                    PRINT "Number of Lines: "; SaucePacket.NumberOfLines~%
                    PRINT "Font Name: "; SaucePacket.FontName$
                    PRINT "iCE Colors: "; SaucePacket.IceColors$
                    PRINT "Letter Spacing: "; SaucePacket.LetterSpacing$
                    PRINT "Aspect Ratio: "; SaucePacket.AspectRatio$
                CASE "ANSIMation":
                    PRINT "Character Width: "; SaucePacket.CharacterWidth~%
                    PRINT "Character Screen Height: "; SauceRecord.TInfo2~%
                    PRINT "Font Name: "; SaucePacket.FontName$
                    PRINT "iCE Colors: "; SaucePacket.IceColors$
                    PRINT "Letter Spacing: "; SaucePacket.LetterSpacing$
                    PRINT "Aspect Ratio: "; SaucePacket.AspectRatio$
                CASE "RIP script":
                    PRINT "Pixel Width: "; SaucePacket.PixelWidth~%
                    PRINT "Pixel Height: "; SaucePacket.PixelHeight~%
                    PRINT "# Colors: "; SaucePacket.NumberOfColors~%
            END SELECT
        CASE "Bitmap":
            PRINT "Bitmap Data Type Detected: "; 
            PRINT SAUCE_BITMAP_TYPES$(SauceRecord.FileType~%%)
            PRINT "Pixel Width: "; SaucePacket.PixelWidth~%
            PRINT "Pixel Height: "; SaucePacket.PixelHeight~%
            PRINT "Pixel Depth: "; SaucePacket.PixelDepth~%
        CASE "Vector":
            PRINT "Vector Data Type Detected: "; 
            PRINT SAUCE_VECTOR_TYPES$(SauceRecord.FileType~%%)
        CASE "Audio":
            PRINT "Audio Data Type Detected: "; 
            PRINT SAUCE_AUDIO_TYPES$(SauceRecord.FileType~%%)
            SELECT CASE SAUCE_AUDIO_TYPES$(SauceRecord.FileType~%%)
                CASE "SMP8", "SMP8S", "SMP16", "SMP16S":
                    PRINT "Sample Rate: "; SaucePacket.SampleRate~%
            END SELECT
        CASE "BinaryText":
            PRINT "Binary Text Detected: BIN / RAW"; 
            PRINT "Font Name: "; SaucePacket.FontName$
        CASE "XBin":
            PRINT "XBin Data Type Detected." 
            PRINT "Character Width: "; SaucePacket.CharacterWidth~%
            PRINT "Number of Lines: "; SaucePacket.NumberOfLines~%
        CASE "Archive":
            PRINT "Archive Data Type Detected: ";
            PRINT SAUCE_ARCHIVE_TYPES$(SauceRecord.FileType~%%)
        CASE "Executable":
            PRINT "Executable Detected."
    END SELECT
    IF SauceRecord.Comments~%% > 0 THEN
        PRINT
        PRINT "Comments: "
        PRINT SaucePacket.Comments$
    END IF
END SUB


''
' Get Sauce record from file Sauce header
' @param STRING F$ Filename
' @return BYREF SaucePacket.SauceRecord
'
SUB SAUCE.GetRecord(F$)
    DIM FileSize AS _UNSIGNED _INTEGER64 
    DIM i AS INTEGER
    DIM CommentID AS STRING * 5

    OPEN F$ FOR BINARY AS #1
    FileSize~&& = LOF(1)
    ' PRINT FileSize~&&
    ' SLEEP

    GET #1, FileSize~&& - 127, SauceRecord
    IF SauceRecord.ID$ = "SAUCE" THEN
        IF SauceRecord.Comments~%% > 0 THEN
            ' PRINT "HAS COMMENTS"
            SEEK #1, _
                FileSize~&& - 127 - (SauceRecord.Comments~%% * 64) - 5
            GET #1, _
                FileSize~&& - 127 - (SauceRecord.Comments~%% * 64) - 5, _
                CommentID$
            ' PRINT "CommentID: "; CommentID$
            IF CommentID$ = "COMNT" THEN
                ' PRINT "COMMENT FOUND"
                FOR i% = SauceRecord.Comments~%% TO 1 STEP - 1
                    DIM Comment AS STRING * 64
                    GET #1, FileSize~&& - 127 - (i% * 64), Comment$
                    Comments$ = Comments$ + Comment$ + CHR$(13)
                NEXT i%
                SaucePacket.Comments$ = Comments$
            END IF
        END IF
    END IF
END SUB


''
' Parse Saucee record TFlags field to determine:
' iCE Colors, Letter Spacing, and Aspect Ratio
' @return BYREF SaucePacket fields populated
'
SUB SAUCE.ParseTFlags
    ' PRINT _
    '   "iCE Colors: "; _
    '   ABS((SauceRecord.TFlags~%% AND 2^0) > 0)
    IF ABS((SauceRecord.TFlags~%% AND 2^0) = 0) THEN
        SaucePacket.IceColors$ = "OFF"
    ELSE
        SaucePacket.IceColors$ = "ON"
    END IF
    ' PRINT _
    '   "Letter Spacing: "; _
    '   ABS((SauceRecord.TFlags~%% AND 2^1) > 0); _
    '   ABS((SauceRecord.TFlags~%% AND 2^2) > 0)
    IF ABS((SauceRecord.TFlags~%% AND 2^1) = 0) _
    AND ABS((SauceRecord.TFlags~%% AND 2^2) = 0) THEN
        SaucePacket.LetterSpacing$ = "Legacy / No preference"
    ELSEIF ABS((SauceRecord.TFlags~%% AND 2^1) > 0) _
    AND ABS((SauceRecord.TFlags~%% AND 2^2) = 0) THEN
        SaucePacket.LetterSpacing$ = "8px"
    ELSEIF ABS((SauceRecord.TFlags~%% AND 2^1) = 0) _
    AND ABS((SauceRecord.TFlags~%% AND 2^2) > 0) THEN
        SaucePacket.LetterSpacing$ = "9px"
    END IF
    ' PRINT _
    '   "Aspect Ratio: "; _
    '   ABS((SauceRecord.TFlags~%% AND 2^3) > 0); _
    '   ABS((SauceRecord.TFlags~%% AND 2^4) > 0)
    IF ABS((SauceRecord.TFlags~%% AND 2^3) = 0) _
    AND ABS((SauceRecord.TFlags~%% AND 2^4) = 0) THEN
        SaucePacket.AspectRatio$ = "No preference / legacy"
    ELSEIF ABS((SauceRecord.TFlags~%% AND 2^3) = 0) _
    AND ABS((SauceRecord.TFlags~%% AND 2^4) = 0) THEN
        SaucePacket.AspectRatio$ = "Square Pixels - STRETCHED"
    ELSEIF ABS((SauceRecord.TFlags~%% AND 2^3) = 0) _
    AND ABS((SauceRecord.TFlags~%% AND 2^4) > 0) THEN
        SaucePacket.AspectRatio$ = "Square Pixels - NOT STRETCHED"
    END IF
END SUB
