' struct SAUCE
' {
'     char           ID[5];
'     char           Version[2];
'     char           Title[35];
'     char           Author[20];
'     char           Group[20];
'     char           Date[8];
'     unsigned long  FileSize;
'     unsigned char  DataType;
'     unsigned char  FileType;
'     unsigned short TInfo1;
'     unsigned short TInfo2;
'     unsigned short TInfo3;
'     unsigned short TInfo4;
'     unsigned char  Comments;
'     unsigned char  TFlags;
'     char           TInfoS[22];
' };

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
DIM SHARED SauceRecord AS SAUCE

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

' Variables:
'     Byte : Count;
'     Long : FileSize;
'     file : F;

' Code:
'     Open_File(F);                             | Open the file for read access
'     FileSize = Size_of_file(F);               | Determine file size
'     Seek_file (F, FileSize-128);              | Seek to start of SAUCE (Eof-128)
'     Read_File (F, SAUCE);                     | Read the SAUCE record
'     IF SAUCE.ID="SAUCE" THEN                  | ID bytes match "SAUCE" ?
'         IF SAUCE.Comments&gt;0 THEN              | Is there a comment block ?
'             Seek_File(F, FileSize-128-(SAUCE.Comments*64)-5);
'                                               | Seek to start of Comment block.
'             Read_File(F, CommentID);          | Read Comment ID.
'             IF CommentID="COMNT" THEN         | Comment ID matches "COMNT" ?
'                 FOR Count=1 to SAUCE.Comments |  Read all comment lines.
'                     Read_File(F, CommentLine) | /
'                 ENDFOR
'             ELSE
'                 Invalid_Comment;              | Non fatal, No comment present.
'             ENDIF
'         ENDIF
'     ELSE
'         Invalid_SAUCE;                        | No valid SAUCE record was found.
'     ENDIF

DIM AS _BYTE Count
DIM AS _UNSIGNED _INTEGER64 FileSize
DIM AS STRING F, CommentID

' Choose an image file with dialog
F$ = _OPENFILEDIALOG$( _
    "Choose a scene file", _
    , _
    "*.jpg|*.png|*.tga|*.bmp|*.psd|*.gif|*.hdr|*.pic|*.pnm|*.pcx|*.svg|*.qoi|*.asc|*.ans|*.rip|*.avt|*.html|*.c|*.cpp|*.bas|*.tnd|*.fli|*.flc|*.gl|*.dl|*.avi|*.dxf|*.mod|*.669|*.stm|*.s3m|*.mtm|*.mid", _
    "Scene Files", _
    -1 _
)
IF F$ = "" THEN SYSTEM ' image is required...

PRINT LEN(SauceRecord)
SLEEP 

OPEN F$ FOR BINARY AS #1
FileSize~&& = LOF(1)
PRINT FileSize~&&
SLEEP

GET #1, FileSize~&& - 127, SauceRecord
IF SauceRecord.ID$ = "SAUCE" THEN
    IF SauceRecord.Comments > 0 THEN
        GET #1, FileSize~&& - 127 - (SauceRecord.Comments * 64) - 5, CommentID$
        IF CommentID$ = "COMNT" THEN

        END IF
    END IF
ELSE
    PRINT "Invalid Sauce"
END IF

PRINT SauceRecord.ID$
PRINT SauceRecord.Version$
PRINT SauceRecord.Title$
PRINT SauceRecord.Author$
PRINT SauceRecord.Group$
PRINT SauceRecord.Date$
PRINT SauceRecord.FileSize~&
PRINT SauceRecord.DataType~%%
PRINT SAUCE_DATA_TYPE$(SauceRecord.DataType~%%)
PRINT SauceRecord.FileType~%%
SELECT CASE SAUCE_DATA_TYPE$(SauceRecord.DataType~%%)
    CASE "None":
        PRINT "No Data Type Detected"
    CASE "Character":
        PRINT "Character Data Type Detected: "; 
        PRINT SAUCE_CHARACTER_TYPES$(SauceRecord.FileType~%%)
        SELECT CASE SAUCE_CHARACTER_TYPES$(SauceRecord.FileType~%%)
            CASE "ASCII":
            CASE "ANSI":
            CASE "PCBoard":
            CASE "Avatar":
            CASE "TundraDraw":
                PRINT "Character Width: "; SauceRecord.TInfo1~%
                PRINT "Number of Lines: "; SauceRecord.TInfo2~%
            CASE "ANSIMation":
                PRINT "Character Width: "; SauceRecord.TInfo1~%
                PRINT "Character Screen Height: "; SauceRecord.TInfo2~%
            CASE "RIP script":
                PRINT "Pixel width: "; SauceRecord.TInfo1~%
                PRINT "Pixel height: "; SauceRecord.TInfo2~%
                PRINT "# Colors: "; SauceRecord.TInfo3~%
        END SELECT
    CASE "Bitmap":
        PRINT "Bitmap Data Type Detected: "; 
        PRINT SAUCE_BITMAP_TYPES$(SauceRecord.FileType~%%)
        PRINT "Pixel Width: "; SauceRecord.TInfo1~%
        PRINT "Pixel Height: "; SauceRecord.TInfo2~%
        PRINT "Pixel Depth: "; SauceRecord.TInfo3~%
    CASE "Vector":
        PRINT "Vector Data Type Detected: "; 
        PRINT SAUCE_VECTOR_TYPES$(SauceRecord.FileType~%%)
    CASE "Audio":
        PRINT "Audio Data Type Detected: "; 
        PRINT SAUCE_AUDIO_TYPES$(SauceRecord.FileType~%%)
        SELECT CASE SAUCE_AUDIO_TYPES$(SauceRecord.FileType~%%)
            CASE "SMP8":
            CASE "SMP8S":
            CASE "SMP16":
            CASE "SMP16S":
                PRINT "Sample Rate: "; SauceRecord.TInfo1~%
        END SELECT
    CASE "BinaryText":
        PRINT "Binary Text Detected: BIN / RAW"; 
    CASE "XBin":
        PRINT "XBin Data Type Detected: "; 
        PRINT SAUCE_BITMAP_TYPES$(SauceRecord.FileType~%%)
        PRINT "Character Width: "; SauceRecord.TInfo1~%
        PRINT "Number of Lines: "; SauceRecord.TInfo2~%
    CASE "Archive":
        PRINT "Archive Data Type Detected:"
        PRINT SAUCE_ARCHIVE_TYPES$(SauceRecord.FileType~%%)
    CASE "Executable":
        PRINT "Executable Detected."
END SELECT
PRINT SauceRecord.TInfo1~%
PRINT SauceRecord.TInfo2~%
PRINT SauceRecord.TInfo3~%
PRINT SauceRecord.TInfo4~%
PRINT SauceRecord.Comments~%%
PRINT SauceRecord.TFlags~%%
PRINT SauceRecord.TInfoS$
