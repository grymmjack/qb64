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
PRINT SauceRecord.FileType~%%
PRINT SauceRecord.TInfo1~%
PRINT SauceRecord.TInfo2~%
PRINT SauceRecord.TInfo3~%
PRINT SauceRecord.TInfo4~%
PRINT SauceRecord.Comments~%%
PRINT SauceRecord.TFlags~%%
PRINT SauceRecord.TInfoS$
