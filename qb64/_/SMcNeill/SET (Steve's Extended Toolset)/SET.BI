' Library declarations
$IF WIN THEN
    $IF 32BIT THEN
        DECLARE DYNAMIC LIBRARY ".\zlib1"
        FUNCTION zlibVersion$ ()
        FUNCTION zlibCompileFlags~& ()
        FUNCTION compressBound& (BYVAL len AS LONG)
        FUNCTION compress& (BYVAL dest AS _OFFSET, destLen AS LONG, BYVAL source AS _OFFSET, BYVAL sourceLen AS LONG)
        FUNCTION compress2& (BYVAL dest AS _OFFSET, destLen AS LONG, BYVAL source AS _OFFSET, BYVAL sourceLen AS LONG, BYVAL level AS LONG)
        FUNCTION uncompress& (BYVAL dest AS _OFFSET, destLen AS LONG, BYVAL source AS _OFFSET, BYVAL sourceLen AS LONG)
        FUNCTION crc32~& (BYVAL PNGCRC AS LONG, BYVAL buf AS _OFFSET, BYVAL len AS LONG)
        FUNCTION adler32~& (BYVAL adler AS LONG, BYVAL buf AS _OFFSET, BYVAL len AS LONG)
        FUNCTION zError$ (BYVAL codenum AS INTEGER)
        END DECLARE
    $ELSE
        DECLARE DYNAMIC LIBRARY ".\zlib"
            FUNCTION zlibVersion$ ()
            FUNCTION zlibCompileFlags~& ()
            FUNCTION compressBound& (BYVAL len AS LONG)
            FUNCTION compress& (BYVAL dest AS _OFFSET, destLen AS LONG, BYVAL source AS _OFFSET, BYVAL sourceLen AS LONG)
            FUNCTION compress2& (BYVAL dest AS _OFFSET, destLen AS LONG, BYVAL source AS _OFFSET, BYVAL sourceLen AS LONG, BYVAL level AS LONG)
            FUNCTION uncompress& (BYVAL dest AS _OFFSET, destLen AS LONG, BYVAL source AS _OFFSET, BYVAL sourceLen AS LONG)
            FUNCTION crc32~& (BYVAL PNGCRC AS LONG, BYVAL buf AS _OFFSET, BYVAL len AS LONG)
            FUNCTION adler32~& (BYVAL adler AS LONG, BYVAL buf AS _OFFSET, BYVAL len AS LONG)
            FUNCTION zError$ (BYVAL codenum AS INTEGER)
        END DECLARE
    $END IF

    ' Constants
    CONST Z_OK = 0
    CONST Z_NO_COMPRESSION = 0
    CONST Z_BEST_SPEED = 1
    CONST Z_BEST_COMPRESSION = 9
    CONST Z_DEFAULT_COMPRESSION = -1

    'These are used for PNG import and export, and are needed for the PNGCRC check
    'If you only want ZLib for something else, these variables could be removed if necessary.
    DIM SHARED PNGCRC_table(0 TO 255) AS _UNSIGNED LONG
    DIM SHARED PNGCRC_table_computed AS LONG: PNGCRC_table_computed = 0
    DIM SHARED PNGCRC AS _UNSIGNED LONG
    DIM SHARED PNGOptions AS PNG_Options_Type

    'I put the types and their info here at the end of the library, so that I wouldn't have to scroll past
    'the stupid things a million times, just to get to my code!


    TYPE ChunkType
        'Chunk type codes are assigned so that a decoder can determine some properties of a chunk
        'even when it does not recognize the type code.

        'These rules are intended to allow safe, flexible extension of the PNG format,
        'by allowing a decoder to decide what to do when it encounters an unknown chunk.
        'The naming rules are not normally of interest when the decoder does recognize the chunk's type.

        'Four bits of the type code, namely bit 5 (value 32) of each byte, are used to convey chunk properties.
        'This choice means that a human can read off the assigned properties according to whether each letter of
        'the type code is uppercase (bit 5 is 0) or lowercase (bit 5 is 1).
        'However, decoders should test the properties of an unknown chunk by numerically testing the specified bits;
        'testing whether a character is uppercase or lowercase is inefficient, and even incorrect if a locale-specific
        'case definition is used.

        'The semantics of the property bits are:

        'Ancillary bit: bit 5 of first byte
        '0 (uppercase) = critical, 1 (lowercase) = ancillary.
        'Chunks that are not strictly necessary in order to meaningfully display the contents of the file are known
        'as "ancillary" chunks.
        'A decoder encountering an unknown chunk in which the ancillary bit is 1 can safely ignore the chunk
        'and proceed to display the image. The time chunk (tIME) is an example of an ancillary chunk.

        'Chunks that are necessary for successful display of the file's contents are called "critical" chunks.
        'A decoder encountering an unknown chunk in which the ancillary bit is 0 must indicate to the user that the
        'image contains information it cannot safely interpret.
        'The image header chunk (IHDR) is an example of a critical chunk.

        'Private bit: bit 5 of second byte
        '0 (uppercase) = public, 1 (lowercase) = private.
        'A public chunk is one that is part of the PNG specification or is registered in the list of PNG special-purpose
        'public chunk types.
        'Applications can also define private (unregistered) chunks for their own purposes.
        'The names of private chunks must have a lowercase second letter, while public chunks will always be assigned names
        'with uppercase second letters.
        'Note that decoders do not need to test the private-chunk property bit, since it has no functional significance;
        'it is simply an administrative convenience to ensure that public and private chunk names will not conflict.

        'Reserved bit: bit 5 of third byte
        'Must be 0 (uppercase) in files conforming to this version of PNG.
        'The significance of the case of the third letter of the chunk name is reserved for possible future expansion.
        'At the present time all chunk names must have uppercase third letters.
        '(Decoders should not complain about a lowercase third letter, however, as some future version of
        'the PNG specification could define a meaning for this bit.
        'It is sufficient to treat a chunk with a lowercase third letter in the same way as any other unknown chunk type.)

        'Safe-to-copy bit: bit 5 of fourth byte
        '0 (uppercase) = unsafe to copy, 1 (lowercase) = safe to copy.
        'This property bit is not of interest to pure decoders, but it is needed by PNG editors (programs that modify PNG files).
        'This bit defines the proper handling of unrecognized chunks in a file that is being modified.
        'If a chunk's safe-to-copy bit is 1, the chunk may be copied to a modified PNG file whether or not the software
        'recognizes the chunk type, and regardless of the extent of the file modifications.
        Ancillary AS _UNSIGNED _BYTE
        Private AS _UNSIGNED _BYTE
        Reserved AS _UNSIGNED _BYTE
        SafeToCopy AS _UNSIGNED _BYTE
    END TYPE


    TYPE PNGChunkLayout
        Length AS _UNSIGNED LONG 'Need to convert this number with the ConvertUL~& function
        Type AS ChunkType
    END TYPE


    TYPE PNGImageHeaderType
        'Can't just read width and height as _unsigned longs.
        'Must convert them to QB64 format with the ConvertUL~& function.
        '   Height              4 bytes
        '   Width               4 bytes
        '   Bit depth:          1 byte    -- single-byte integer giving the number of bits per sample or per palette index
        '                                    (not per pixel). Valid values are 1, 2, 4, 8, and 16,
        '                                    although not all values are allowed for all color types.
        '   Color type:         1 byte    -- 0 is Grayscale, 2 is RGB, 3 is from a palette index (Must have PLTE chunk)
        '                                    4 is Grayscale with alpha, 6 is RGBA
        '   Compression method: 1 byte    -- should be 0
        '   Filter method:      1 byte    -- should be 0
        '   Interlace method:   1 byte    -- should be 0 (None), or 1 (Adam 7 Interlace Method)

        Width AS _UNSIGNED LONG 'Need to convert this number with the ConvertUL~& function
        Height AS _UNSIGNED LONG 'Need to convert this number with the ConvertUL~& function
        Depth AS _UNSIGNED _BYTE
        ColorType AS _UNSIGNED _BYTE
        Compression AS _UNSIGNED _BYTE
        Filter AS _UNSIGNED _BYTE
        Interlace AS _UNSIGNED _BYTE
    END TYPE

    TYPE PNG_Options_Type
        Alpha AS _UNSIGNED _BYTE
        Screen AS LONG
        Color AS INTEGER
        GrabMode AS _UNSIGNED _BYTE
        x1 AS _UNSIGNED INTEGER
        y1 AS _UNSIGNED INTEGER
        x2 AS _UNSIGNED INTEGER
        y2 AS _UNSIGNED INTEGER
        AutoReset AS _UNSIGNED _BYTE
    END TYPE
$END IF

'****************************************************
'  End of ZLib and SMcNeill PNG Export/Import Library
'****************************************************

DIM SHARED LastIndex

'*********************************************
'   MATH Library
'*********************************************
REDIM SHARED OName(0) AS STRING 'Operation Name
REDIM SHARED PL(0) AS INTEGER 'Priority Level
DIM SHARED QuickReturn AS INTEGER

'******************************************************
'  COLOR Library
'******************************************************

$IF KOLOR = UNDEFINED THEN
    $LET KOLOR = 32
$END IF

$IF KOLOR = 32 THEN
    CONST AliceBlue = &HFFF0F8FF~& ' _RGB32(240,248,255)
    CONST Almond = &HFFEFDECD~& '_RGB32(239,222,205)
    CONST AntiqueBrass = &HFFCD9575~& '_RGB32(205,149,117)
    CONST AntiqueWhite = &HFFFAEBD7~& ' _RGB32(250,235,215)
    CONST Apricot = &HFFFDD9B5~& '_RGB32(253,217,181)
    CONST Aqua = &HFF00FFFF~& ' _RGB32(0,255,255)
    CONST Aquamarine = &HFF7FFFD4~& ' _RGB32(127,255,212)
    CONST Asparagus = &HFF87A96B~& '_RGB32(135,169,107)
    CONST AtomicTangerine = &HFFFFA474~& '_RGB32(255,164,116)
    CONST Azure = &HFFF0FFFF~& ' _RGB32(240,255,255)
    CONST BananaMania = &HFFFAE7B5~& '_RGB32(250,231,181)
    CONST Beaver = &HFF9F8170~& '_RGB32(159,129,112)
    CONST Beige = &HFFF5F5DC~& ' _RGB32(245,245,220)
    CONST Bisque = &HFFFFE4C4~& ' _RGB32(255,228,196)
    CONST Bittersweet = &HFFFD7C6E~& '_RGB32(253,124,110)
    CONST Black = &HFF000000~& ' _RGB32(0,0,0)
    CONST BlanchedAlmond = &HFFFFEBCD~& ' _RGB32(255,235,205)
    CONST BlizzardBlue = &HFFACE5EE~& '_RGB32(172,229,238)
    CONST Blue = &HFF0000FF~& ' _RGB32(0,0,255)
    CONST BlueBell = &HFFA2A2D0~& '_RGB32(162,162,208)
    CONST BlueGray = &HFF6699CC~& '_RGB32(102,153,204)
    CONST BlueGreen = &HFF0D98BA~& '_RGB32(13,152,186)
    CONST BlueViolet = &HFF8A2BE2~& ' _RGB32(138,43,226)
    CONST Blush = &HFFDE5D83~& '_RGB32(222,93,131)
    CONST BrickRed = &HFFCB4154~& '_RGB32(203,65,84)
    CONST Brown = &HFFA52A2A~& ' _RGB32(165,42,42)
    CONST BurlyWood = &HFFDEB887~& ' _RGB32(222,184,135)
    CONST BurntOrange = &HFFFF7F49~& '_RGB32(255,127,73)
    CONST BurntSienna = &HFFEA7E5D~& '_RGB32(234,126,93)
    CONST CadetBlue = &HFF5F9EA0~& ' _RGB32(95,158,160)
    CONST Canary = &HFFFFFF99~& '_RGB32(255,255,153)
    CONST CaribbeanGreen = &HFF1CD3A2~& '_RGB32(28,211,162)
    CONST CarnationPink = &HFFFFAACC~& '_RGB32(255,170,204)
    CONST Cerise = &HFFDD4492~& '_RGB32(221,68,146)
    CONST Cerulean = &HFF1DACD6~& '_RGB32(29,172,214)
    CONST ChartReuse = &HFF7FFF00~& ' _RGB32(127,255,0)
    CONST Chestnut = &HFFBC5D58~& '_RGB32(188,93,88)
    CONST Chocolate = &HFFD2691E~& ' _RGB32(210,105,30)
    CONST Copper = &HFFDD9475~& '_RGB32(221,148,117)
    CONST Coral = &HFFFF7F50~& ' _RGB32(255,127,80)
    CONST Cornflower = &HFF9ACEEB~& '_RGB32(154,206,235)
    CONST CornflowerBlue = &HFF6495ED~& ' _RGB32(100,149,237)
    CONST Cornsilk = &HFFFFF8DC~& ' _RGB32(255,248,220)
    CONST CottonCandy = &HFFFFBCD9~& '_RGB32(255,188,217)
    CONST CrayolaAquamarine = &HFF78DBE2~& '_RGB32(120,219,226)
    CONST CrayolaBlue = &HFF1F75FE~& '_RGB32(31,117,254)
    CONST CrayolaBlueViolet = &HFF7366BD~& '_RGB32(115,102,189)
    CONST CrayolaBrown = &HFFB4674D~& '_RGB32(180,103,77)
    CONST CrayolaCadetBlue = &HFFB0B7C6~& '_RGB32(176,183,198)
    CONST CrayolaForestGreen = &HFF6DAE81~& '_RGB32(109,174,129)
    CONST CrayolaGold = &HFFE7C697~& '_RGB32(231,198,151)
    CONST CrayolaGoldenrod = &HFFFCD975~& '_RGB32(252,217,117)
    CONST CrayolaGray = &HFF95918C~& '_RGB32(149,145,140)
    CONST CrayolaGreen = &HFF1CAC78~& '_RGB32(28,172,120)
    CONST CrayolaGreenYellow = &HFFF0E891~& '_RGB32(240,232,145)
    CONST CrayolaIndigo = &HFF5D76CB~& '_RGB32(93,118,203)
    CONST CrayolaLavender = &HFFFCB4D5~& '_RGB32(252,180,213)
    CONST CrayolaMagenta = &HFFF664AF~& '_RGB32(246,100,175)
    CONST CrayolaMaroon = &HFFC8385A~& '_RGB32(200,56,90)
    CONST CrayolaMidnightBlue = &HFF1A4876~& '_RGB32(26,72,118)
    CONST CrayolaOrange = &HFFFF7538~& '_RGB32(255,117,56)
    CONST CrayolaOrangeRed = &HFFFF2B2B~& '_RGB32(255,43,43)
    CONST CrayolaOrchid = &HFFE6A8D7~& '_RGB32(230,168,215)
    CONST CrayolaPlum = &HFF8E4585~& '_RGB32(142,69,133)
    CONST CrayolaRed = &HFFEE204D~& '_RGB32(238,32,77)
    CONST CrayolaSalmon = &HFFFF9BAA~& '_RGB32(255,155,170)
    CONST CrayolaSeaGreen = &HFF9FE2BF~& '_RGB32(159,226,191)
    CONST CrayolaSilver = &HFFCDC5C2~& '_RGB32(205,197,194)
    CONST CrayolaSkyBlue = &HFF80DAEB~& '_RGB32(128,218,235)
    CONST CrayolaSpringGreen = &HFFECEABE~& '_RGB32(236,234,190)
    CONST CrayolaTann = &HFFFAA76C~& '_RGB32(250,167,108)
    CONST CrayolaThistle = &HFFEBC7DF~& '_RGB32(235,199,223)
    CONST CrayolaViolet = &HFF926EAE~& '_RGB32(146,110,174)
    CONST CrayolaYellow = &HFFFCE883~& '_RGB32(252,232,131)
    CONST CrayolaYellowGreen = &HFFC5E384~& '_RGB32(197,227,132)
    CONST Crimson = &HFFDC143C~& ' _RGB32(220,20,60)
    CONST Cyan = &HFF00FFFF~& ' _RGB32(0,255,255)
    CONST Dandelion = &HFFFDDB6D~& '_RGB32(253,219,109)
    CONST DarkBlue = &HFF00008B~& ' _RGB32(0,0,139)
    CONST DarkCyan = &HFF008B8B~& ' _RGB32(0,139,139)
    CONST DarkGoldenRod = &HFFB8860B~& ' _RGB32(184,134,11)
    CONST DarkGray = &HFFA9A9A9~& ' _RGB32(169,169,169)
    CONST DarkGreen = &HFF006400~& ' _RGB32(0,100,0)
    CONST DarkKhaki = &HFFBDB76B~& ' _RGB32(189,183,107)
    CONST DarkMagenta = &HFF8B008B~& ' _RGB32(139,0,139)
    CONST DarkOliveGreen = &HFF556B2F~& ' _RGB32(85,107,47)
    CONST DarkOrange = &HFFFF8C00~& ' _RGB32(255,140,0)
    CONST DarkOrchid = &HFF9932CC~& ' _RGB32(153,50,204)
    CONST DarkRed = &HFF8B0000~& ' _RGB32(139,0,0)
    CONST DarkSalmon = &HFFE9967A~& ' _RGB32(233,150,122)
    CONST DarkSeaGreen = &HFF8FBC8F~& ' _RGB32(143,188,143)
    CONST DarkSlateBlue = &HFF483D8B~& ' _RGB32(72,61,139)
    CONST DarkSlateGray = &HFF2F4F4F~& ' _RGB32(47,79,79)
    CONST DarkTurquoise = &HFF00CED1~& ' _RGB32(0,206,209)
    CONST DarkViolet = &HFF9400D3~& ' _RGB32(148,0,211)
    CONST DeepPink = &HFFFF1493~& ' _RGB32(255,20,147)
    CONST DeepSkyBlue = &HFF00BFFF~& ' _RGB32(0,191,255)
    CONST Denim = &HFF2B6CC4~& '_RGB32(43,108,196)
    CONST DesertSand = &HFFEFCDB8~& '_RGB32(239,205,184)
    CONST DimGray = &HFF696969~& ' _RGB32(105,105,105)
    CONST DodgerBlue = &HFF1E90FF~& ' _RGB32(30,144,255)
    CONST Eggplant = &HFF6E5160~& '_RGB32(110,81,96)
    CONST ElectricLime = &HFFCEFF1D~& '_RGB32(206,255,29)
    CONST Fern = &HFF71BC78~& '_RGB32(113,188,120)
    CONST FireBrick = &HFFB22222~& ' _RGB32(178,34,34)
    CONST Floralwhite = &HFFFFFAF0~& ' _RGB32(255,250,240)
    CONST ForestGreen = &HFF228B22~& ' _RGB32(34,139,34)
    CONST Fuchsia = &HFFC364C5~& '_RGB32(195,100,197)
    CONST FuzzyWuzzy = &HFFCC6666~& '_RGB32(204,102,102)
    CONST Gainsboro = &HFFDCDCDC~& ' _RGB32(220,220,220)
    CONST GhostWhite = &HFFF8F8FF~& ' _RGB32(248,248,255)
    CONST Gold = &HFFFFD700~& ' _RGB32(255,215,0)
    CONST GoldenRod = &HFFDAA520~& ' _RGB32(218,165,32)
    CONST GrannySmithApple = &HFFA8E4A0~& '_RGB32(168,228,160)
    CONST Gray = &HFF808080~& ' _RGB32(128,128,128)
    CONST Green = &HFF008000~& ' _RGB32(0,128,0)
    CONST GreenBlue = &HFF1164B4~& '_RGB32(17,100,180)
    CONST GreenYellow = &HFFADFF2F~& ' _RGB32(173,255,47)
    CONST HoneyDew = &HFFF0FFF0~& ' _RGB32(240,255,240)
    CONST HotMagenta = &HFFFF1DCE~& '_RGB32(255,29,206)
    CONST HotPink = &HFFFF69B4~& ' _RGB32(255,105,180)
    CONST Inchworm = &HFFB2EC5D~& '_RGB32(178,236,93)
    CONST IndianRed = &HFFCD5C5C~& ' _RGB32(205,92,92)
    CONST Indigo = &HFF4B0082~& ' _RGB32(75,0,130)
    CONST Ivory = &HFFFFFFF0~& ' _RGB32(255,255,240)
    CONST JazzberryJam = &HFFCA3767~& '_RGB32(202,55,103)
    CONST JungleGreen = &HFF3BB08F~& '_RGB32(59,176,143)
    CONST Khaki = &HFFF0E68C~& ' _RGB32(240,230,140)
    CONST LaserLemon = &HFFFEFE22~& '_RGB32(254,254,34)
    CONST Lavender = &HFFE6E6FA~& ' _RGB32(230,230,250)
    CONST LavenderBlush = &HFFFFF0F5~& ' _RGB32(255,240,245)
    CONST LawnGreen = &HFF7CFC00~& ' _RGB32(124,252,0)
    CONST LemonChiffon = &HFFFFFACD~& ' _RGB32(255,250,205)
    CONST LemonYellow = &HFFFFF44F~& '_RGB32(255,244,79)
    CONST LightBlue = &HFFADD8E6~& ' _RGB32(173,216,230)
    CONST LightCoral = &HFFF08080~& ' _RGB32(240,128,128)
    CONST LightCyan = &HFFE0FFFF~& ' _RGB32(224,255,255)
    CONST LightGoldenRodYellow = &HFFFAFAD2~& ' _RGB32(250,250,210)
    CONST LightGray = &HFFD3D3D3~& ' _RGB32(211,211,211)
    CONST LightGreen = &HFF90EE90~& ' _RGB32(144,238,144)
    CONST LightPink = &HFFFFB6C1~& ' _RGB32(255,182,193)
    CONST LightSalmon = &HFFFFA07A~& ' _RGB32(255,160,122)
    CONST LightSeaGreen = &HFF20B2AA~& ' _RGB32(32,178,170)
    CONST LightSkyBlue = &HFF87CEFA~& ' _RGB32(135,206,250)
    CONST LightSlateGray = &HFF778899~& ' _RGB32(119,136,153)
    CONST LightSteelBlue = &HFFB0C4DE~& ' _RGB32(176,196,222)
    CONST LightYellow = &HFFFFFFE0~& ' _RGB32(255,255,224)
    CONST Lime = &HFF00FF00~& ' _RGB32(0,255,0)
    CONST LimeGreen = &HFF32CD32~& ' _RGB32(50,205,50)
    CONST Linen = &HFFFAF0E6~& ' _RGB32(250,240,230)
    CONST MacaroniAndCheese = &HFFFFBD88~& '_RGB32(255,189,136)
    CONST Magenta = &HFFFF00FF~& ' _RGB32(255,0,255)
    CONST MagicMint = &HFFAAF0D1~& '_RGB32(170,240,209)
    CONST Mahogany = &HFFCD4A4C~& '_RGB32(205,74,76)
    CONST Maize = &HFFEDD19C~& '_RGB32(237,209,156)
    CONST Manatee = &HFF979AAA~& '_RGB32(151,154,170)
    CONST MangoTango = &HFFFF8243~& '_RGB32(255,130,67)
    CONST Maroon = &HFF800000~& ' _RGB32(128,0,0)
    CONST Mauvelous = &HFFEF98AA~& '_RGB32(239,152,170)
    CONST MediumAquamarine = &HFF66CDAA~& ' _RGB32(102,205,170)
    CONST MediumBlue = &HFF0000CD~& ' _RGB32(0,0,205)
    CONST MediumOrchid = &HFFBA55D3~& ' _RGB32(186,85,211)
    CONST MediumPurple = &HFF9370DB~& ' _RGB32(147,112,219)
    CONST MediumSeaGreen = &HFF3CB371~& ' _RGB32(60,179,113)
    CONST MediumSlateBlue = &HFF7B68EE~& ' _RGB32(123,104,238)
    CONST MediumSpringGreen = &HFF00FA9A~& ' _RGB32(0,250,154)
    CONST MediumTurquoise = &HFF48D1CC~& ' _RGB32(72,209,204)
    CONST MediumVioletRed = &HFFC71585~& ' _RGB32(199,21,133)
    CONST Melon = &HFFFDBCB4~& '_RGB32(253,188,180)
    CONST MidnightBlue = &HFF191970~& ' _RGB32(25,25,112)
    CONST MintCream = &HFFF5FFFA~& ' _RGB32(245,255,250)
    CONST MistyRose = &HFFFFE4E1~& ' _RGB32(255,228,225)
    CONST Moccasin = &HFFFFE4B5~& ' _RGB32(255,228,181)
    CONST MountainMeadow = &HFF30BA8F~& '_RGB32(48,186,143)
    CONST Mulberry = &HFFC54B8C~& '_RGB32(197,75,140)
    CONST NavajoWhite = &HFFFFDEAD~& ' _RGB32(255,222,173)
    CONST Navy = &HFF000080~& ' _RGB32(0,0,128)
    CONST NavyBlue = &HFF1974D2~& '_RGB32(25,116,210)
    CONST NeonCarrot = &HFFFFA343~& '_RGB32(255,163,67)
    CONST OldLace = &HFFFDF5E6~& ' _RGB32(253,245,230)
    CONST Olive = &HFF808000~& ' _RGB32(128,128,0)
    CONST OliveDrab = &HFF6B8E23~& ' _RGB32(107,142,35)
    CONST OliveGreen = &HFFBAB86C~& '_RGB32(186,184,108)
    CONST Orange = &HFFFFA500~& ' _RGB32(255,165,0)
    CONST OrangeRed = &HFFFF4500~& ' _RGB32(255,69,0)
    CONST OrangeYellow = &HFFF8D568~& '_RGB32(248,213,104)
    CONST Orchid = &HFFDA70D6~& ' _RGB32(218,112,214)
    CONST OuterSpace = &HFF414A4C~& '_RGB32(65,74,76)
    CONST OutrageousOrange = &HFFFF6E4A~& '_RGB32(255,110,74)
    CONST PacificBlue = &HFF1CA9C9~& '_RGB32(28,169,201)
    CONST PaleGoldenRod = &HFFEEE8AA~& ' _RGB32(238,232,170)
    CONST PaleGreen = &HFF98FB98~& ' _RGB32(152,251,152)
    CONST PaleTurquoise = &HFFAFEEEE~& ' _RGB32(175,238,238)
    CONST PaleVioletRed = &HFFDB7093~& ' _RGB32(219,112,147)
    CONST PapayaWhip = &HFFFFEFD5~& ' _RGB32(255,239,213)
    CONST Peach = &HFFFFCFAB~& '_RGB32(255,207,171)
    CONST PeachPuff = &HFFFFDAB9~& ' _RGB32(255,218,185)
    CONST Periwinkle = &HFFC5D0E6~& '_RGB32(197,208,230)
    CONST Peru = &HFFCD853F~& ' _RGB32(205,133,63)
    CONST PiggyPink = &HFFFDDDE6~& '_RGB32(253,221,230)
    CONST PineGreen = &HFF158078~& '_RGB32(21,128,120)
    CONST Pink = &HFFFFC0CB~& ' _RGB32(255,192,203)
    CONST PinkFlamingo = &HFFFC74FD~& '_RGB32(252,116,253)
    CONST PinkSherbet = &HFFF78FA7~& '_RGB32(247,143,167)
    CONST Plum = &HFFDDA0DD~& ' _RGB32(221,160,221)
    CONST PowderBlue = &HFFB0E0E6~& ' _RGB32(176,224,230)
    CONST Purple = &HFF800080~& ' _RGB32(128,0,128)
    CONST PurpleHeart = &HFF7442C8~& '_RGB32(116,66,200)
    CONST PurpleMountainsMajesty = &HFF9D81BA~& '_RGB32(157,129,186)
    CONST PurplePizzazz = &HFFFE4EDA~& '_RGB32(254,78,218)
    CONST RadicalRed = &HFFFF496C~& '_RGB32(255,73,108)
    CONST RawSienna = &HFFD68A59~& '_RGB32(214,138,89)
    CONST RawUmber = &HFF714B23~& '_RGB32(113,75,35)
    CONST RazzleDazzleRose = &HFFFF48D0~& '_RGB32(255,72,208)
    CONST Razzmatazz = &HFFE3256B~& '_RGB32(227,37,107)
    CONST Red = &HFFFF0000~& ' _RGB32(255,0,0)
    CONST RedOrange = &HFFFF5349~& '_RGB32(255,83,73)
    CONST RedViolet = &HFFC0448F~& '_RGB32(192,68,143)
    CONST RobinsEggBlue = &HFF1FCECB~& '_RGB32(31,206,203)
    CONST RosyBrown = &HFFBC8F8F~& ' _RGB32(188,143,143)
    CONST RoyalBlue = &HFF4169E1~& ' _RGB32(65,105,225)
    CONST RoyalPurple = &HFF7851A9~& '_RGB32(120,81,169)
    CONST SaddleBrown = &HFF8B4513~& ' _RGB32(139,69,19)
    CONST Salmon = &HFFFA8072~& ' _RGB32(250,128,114)
    CONST SandyBrown = &HFFF4A460~& ' _RGB32(244,164,96)
    CONST Scarlet = &HFFFC2847~& '_RGB32(252,40,71)
    CONST ScreaminGreen = &HFF76FF7A~& '_RGB32(118,255,122)
    CONST SeaGreen = &HFF2E8B57~& ' _RGB32(46,139,87)
    CONST SeaShell = &HFFFFF5EE~& ' _RGB32(255,245,238)
    CONST Sepia = &HFFA5694F~& '_RGB32(165,105,79)
    CONST Shadow = &HFF8A795D~& '_RGB32(138,121,93)
    CONST Shamrock = &HFF45CEA2~& '_RGB32(69,206,162)
    CONST ShockingPink = &HFFFB7EFD~& '_RGB32(251,126,253)
    CONST Sienna = &HFFA0522D~& ' _RGB32(160,82,45)
    CONST Silver = &HFFC0C0C0~& ' _RGB32(192,192,192)
    CONST SkyBlue = &HFF87CEEB~& ' _RGB32(135,206,235)
    CONST SlateBlue = &HFF6A5ACD~& ' _RGB32(106,90,205)
    CONST SlateGray = &HFF708090~& ' _RGB32(112,128,144)
    CONST Snow = &HFFFFFAFA~& ' _RGB32(255,250,250)
    CONST SpringGreen = &HFF00FF7F~& ' _RGB32(0,255,127)
    CONST SteelBlue = &HFF4682B4~& ' _RGB32(70,130,180)
    CONST Sunglow = &HFFFFCF48~& '_RGB32(255,207,72)
    CONST SunsetOrange = &HFFFD5E53~& '_RGB32(253,94,83)
    CONST Tann = &HFFD2B48C~& ' _RGB32(210,180,140)
    CONST Teal = &HFF008080~& ' _RGB32(0,128,128)
    CONST TealBlue = &HFF18A7B5~& '_RGB32(24,167,181)
    CONST Thistle = &HFFD8BFD8~& ' _RGB32(216,191,216)
    CONST TickleMePink = &HFFFC89AC~& '_RGB32(252,137,172)
    CONST Timberwolf = &HFFDBD7D2~& '_RGB32(219,215,210)
    CONST Tomato = &HFFFF6347~& ' _RGB32(255,99,71)
    CONST TropicalRainForest = &HFF17806D~& '_RGB32(23,128,109)
    CONST Tumbleweed = &HFFDEAA88~& '_RGB32(222,170,136)
    CONST Turquoise = &HFF40E0D0~& ' _RGB32(64,224,208)
    CONST TurquoiseBlue = &HFF77DDE7~& '_RGB32(119,221,231)
    CONST UnmellowYellow = &HFFFFFF66~& '_RGB32(255,255,102)
    CONST Violet = &HFFEE82EE~& ' _RGB32(238,130,238)
    CONST VioletBlue = &HFF324AB2~& '_RGB32(50,74,178)
    CONST VioletRed = &HFFF75394~& '_RGB32(247,83,148)
    CONST VividTangerine = &HFFFFA089~& '_RGB32(255,160,137)
    CONST VividViolet = &HFF8F509D~& '_RGB32(143,80,157)
    CONST Wheat = &HFFF5DEB3~& ' _RGB32(245,222,179)
    CONST White = &HFFFFFFFF~& ' _RGB32(255,255,255)
    CONST Whitesmoke = &HFFF5F5F5~& ' _RGB32(245,245,245)
    CONST WildBlueYonder = &HFFA2ADD0~& '_RGB32(162,173,208)
    CONST WildStrawberry = &HFFFF43A4~& '_RGB32(255,67,164)
    CONST WildWatermelon = &HFFFC6C85~& '_RGB32(252,108,133)
    CONST Wisteria = &HFFCDA4DE~& '_RGB32(205,164,222)
    CONST Yellow = &HFFFFFF00~& ' _RGB32(255,255,0)
    CONST YellowGreen = &HFF9ACD32~& ' _RGB32(154,205,50)
    CONST YellowOrange = &HFFFFAE42~& '_RGB32(255,174,66)
$END IF

$IF KOLOR = 0 THEN
    CONST Black = 0~%%
    CONST Blue = 1~%%
    CONST Green = 2~%%
    CONST Cyan = 3~%%
    CONST Red = 4~%%
    CONST Magenta = 5~%%
    CONST Brown = 6~%%
    CONST White = 7~%%
    CONST Gray = 8~%%
    CONST LightBlue = 9~%%
    CONST LightGreen = 10~%%
    CONST LightCyan = 11~%%
    CONST LightRed = 12~%%
    CONST LightMagenta = 13~%%
    CONST Yellow = 14~%%
    CONST BrightWhite = 15~%%
    CONST Blink = 16~%%
$END IF

$IF KOLOR = 256 THEN
    CONST Black = 0~%%
    CONST Blue = 1~%%
    CONST Green = 2~%%
    CONST Cyan = 3~%%
    CONST Red = 4~%%
    CONST Magenta = 5~%%
    CONST Brown = 6~%%
    CONST White = 7~%%
    CONST Gray = 8~%%
    CONST LightBlue = 9~%%
    CONST LightGreen = 10~%%
    CONST LightCyan = 11~%%
    CONST LightRed = 12~%%
    CONST LightMagenta = 13~%%
    CONST Yellow = 14~%%
    CONST BrightWhite = 15~%%
    _PALETTECOLOR 16, _RGBA32(240, 248, 255, 255): CONST AliceBlue = 16~%%
    _PALETTECOLOR 17, _RGBA32(239, 222, 205, 255): CONST Almond = 17~%%
    _PALETTECOLOR 18, _RGBA32(205, 149, 117, 255): CONST AntiqueBrass = 18~%%
    _PALETTECOLOR 19, _RGBA32(250, 235, 215, 255): CONST AntiqueWhite = 19~%%
    _PALETTECOLOR 20, _RGBA32(253, 217, 181, 255): CONST Apricot = 20~%%
    _PALETTECOLOR 21, _RGBA32(0, 255, 255, 255): CONST Aqua = 21~%%
    _PALETTECOLOR 22, _RGBA32(127, 255, 212, 255): CONST Aquamarine = 22~%%
    _PALETTECOLOR 23, _RGBA32(135, 169, 107, 255): CONST Asparagus = 23~%%
    _PALETTECOLOR 24, _RGBA32(255, 164, 116, 255): CONST AtomicTangerine = 24~%%
    _PALETTECOLOR 25, _RGBA32(240, 255, 255, 255): CONST Azure = 25~%%
    _PALETTECOLOR 26, _RGBA32(250, 231, 181, 255): CONST BananaMania = 26~%%
    _PALETTECOLOR 27, _RGBA32(159, 129, 112, 255): CONST Beaver = 27~%%
    _PALETTECOLOR 28, _RGBA32(245, 245, 220, 255): CONST Beige = 28~%%
    _PALETTECOLOR 29, _RGBA32(255, 228, 196, 255): CONST Bisque = 29~%%
    _PALETTECOLOR 30, _RGBA32(253, 124, 110, 255): CONST Bittersweet = 30~%%
    _PALETTECOLOR 31, _RGBA32(255, 235, 205, 255): CONST BlanchedAlmond = 31~%%
    _PALETTECOLOR 32, _RGBA32(172, 229, 238, 255): CONST BlizzardBlue = 32~%%
    _PALETTECOLOR 33, _RGBA32(162, 162, 208, 255): CONST BlueBell = 33~%%
    _PALETTECOLOR 34, _RGBA32(102, 153, 204, 255): CONST BlueGray = 34~%%
    _PALETTECOLOR 35, _RGBA32(13, 152, 186, 255): CONST BlueGreen = 35~%%
    _PALETTECOLOR 36, _RGBA32(138, 43, 226, 255): CONST BlueViolet = 36~%%
    _PALETTECOLOR 37, _RGBA32(222, 93, 131, 255): CONST Blush = 37~%%
    _PALETTECOLOR 38, _RGBA32(203, 65, 84, 255): CONST BrickRed = 38~%%
    _PALETTECOLOR 39, _RGBA32(222, 184, 135, 255): CONST BurlyWood = 39~%%
    _PALETTECOLOR 40, _RGBA32(255, 127, 73, 255): CONST BurntOrange = 40~%%
    _PALETTECOLOR 41, _RGBA32(234, 126, 93, 255): CONST BurntSienna = 41~%%
    _PALETTECOLOR 42, _RGBA32(95, 158, 160, 255): CONST CadetBlue = 42~%%
    _PALETTECOLOR 43, _RGBA32(255, 255, 153, 255): CONST Canary = 43~%%
    _PALETTECOLOR 44, _RGBA32(28, 211, 162, 255): CONST CaribbeanGreen = 44~%%
    _PALETTECOLOR 45, _RGBA32(255, 170, 204, 255): CONST CarnationPink = 45~%%
    _PALETTECOLOR 46, _RGBA32(221, 68, 146, 255): CONST Cerise = 46~%%
    _PALETTECOLOR 47, _RGBA32(29, 172, 214, 255): CONST Cerulean = 47~%%
    _PALETTECOLOR 48, _RGBA32(127, 255, 0, 255): CONST ChartReuse = 48~%%
    _PALETTECOLOR 49, _RGBA32(188, 93, 88, 255): CONST Chestnut = 49~%%
    _PALETTECOLOR 50, _RGBA32(210, 105, 30, 255): CONST Chocolate = 50~%%
    _PALETTECOLOR 51, _RGBA32(221, 148, 117, 255): CONST Copper = 51~%%
    _PALETTECOLOR 52, _RGBA32(255, 127, 80, 255): CONST Coral = 52~%%
    _PALETTECOLOR 53, _RGBA32(154, 206, 235, 255): CONST Cornflower = 53~%%
    _PALETTECOLOR 54, _RGBA32(100, 149, 237, 255): CONST CornflowerBlue = 54~%%
    _PALETTECOLOR 55, _RGBA32(255, 248, 220, 255): CONST Cornsilk = 55~%%
    _PALETTECOLOR 56, _RGBA32(255, 188, 217, 255): CONST CottonCandy = 56~%%
    _PALETTECOLOR 57, _RGBA32(220, 20, 60, 255): CONST Crimson = 57~%%
    _PALETTECOLOR 58, _RGBA32(253, 219, 109, 255): CONST Dandelion = 58~%%
    _PALETTECOLOR 59, _RGBA32(0, 0, 139, 255): CONST DarkBlue = 59~%%
    _PALETTECOLOR 60, _RGBA32(0, 139, 139, 255): CONST DarkCyan = 60~%%
    _PALETTECOLOR 61, _RGBA32(184, 134, 11, 255): CONST DarkGoldenRod = 61~%%
    _PALETTECOLOR 62, _RGBA32(169, 169, 169, 255): CONST DarkGray = 62~%%
    _PALETTECOLOR 63, _RGBA32(0, 100, 0, 255): CONST DarkGreen = 63~%%
    _PALETTECOLOR 64, _RGBA32(189, 183, 107, 255): CONST DarkKhaki = 64~%%
    _PALETTECOLOR 65, _RGBA32(139, 0, 139, 255): CONST DarkMagenta = 65~%%
    _PALETTECOLOR 66, _RGBA32(85, 107, 47, 255): CONST DarkOliveGreen = 66~%%
    _PALETTECOLOR 67, _RGBA32(255, 140, 0, 255): CONST DarkOrange = 67~%%
    _PALETTECOLOR 68, _RGBA32(153, 50, 204, 255): CONST DarkOrchid = 68~%%
    _PALETTECOLOR 69, _RGBA32(139, 0, 0, 255): CONST DarkRed = 69~%%
    _PALETTECOLOR 70, _RGBA32(233, 150, 122, 255): CONST DarkSalmon = 70~%%
    _PALETTECOLOR 71, _RGBA32(143, 188, 143, 255): CONST DarkSeaGreen = 71~%%
    _PALETTECOLOR 72, _RGBA32(72, 61, 139, 255): CONST DarkSlateBlue = 72~%%
    _PALETTECOLOR 73, _RGBA32(47, 79, 79, 255): CONST DarkSlateGray = 73~%%
    _PALETTECOLOR 74, _RGBA32(0, 206, 209, 255): CONST DarkTurquoise = 74~%%
    _PALETTECOLOR 75, _RGBA32(148, 0, 211, 255): CONST DarkViolet = 75~%%
    _PALETTECOLOR 76, _RGBA32(255, 20, 147, 255): CONST DeepPink = 76~%%
    _PALETTECOLOR 77, _RGBA32(0, 191, 255, 255): CONST DeepSkyBlue = 77~%%
    _PALETTECOLOR 78, _RGBA32(43, 108, 196, 255): CONST Denim = 78~%%
    _PALETTECOLOR 79, _RGBA32(239, 205, 184, 255): CONST DesertSand = 79~%%
    _PALETTECOLOR 80, _RGBA32(105, 105, 105, 255): CONST DimGray = 80~%%
    _PALETTECOLOR 81, _RGBA32(30, 144, 255, 255): CONST DodgerBlue = 81~%%
    _PALETTECOLOR 82, _RGBA32(110, 81, 96, 255): CONST Eggplant = 82~%%
    _PALETTECOLOR 83, _RGBA32(206, 255, 29, 255): CONST ElectricLime = 83~%%
    _PALETTECOLOR 84, _RGBA32(113, 188, 120, 255): CONST Fern = 84~%%
    _PALETTECOLOR 85, _RGBA32(178, 34, 34, 255): CONST FireBrick = 85~%%
    _PALETTECOLOR 86, _RGBA32(255, 250, 240, 255): CONST Floralwhite = 86~%%
    _PALETTECOLOR 87, _RGBA32(34, 139, 34, 255): CONST ForestGreen = 87~%%
    _PALETTECOLOR 88, _RGBA32(195, 100, 197, 255): CONST Fuchsia = 88~%%
    _PALETTECOLOR 89, _RGBA32(204, 102, 102, 255): CONST FuzzyWuzzy = 89~%%
    _PALETTECOLOR 90, _RGBA32(220, 220, 220, 255): CONST Gainsboro = 90~%%
    _PALETTECOLOR 91, _RGBA32(248, 248, 255, 255): CONST GhostWhite = 91~%%
    _PALETTECOLOR 92, _RGBA32(255, 215, 0, 255): CONST Gold = 92~%%
    _PALETTECOLOR 93, _RGBA32(218, 165, 32, 255): CONST GoldenRod = 93~%%
    _PALETTECOLOR 94, _RGBA32(168, 228, 160, 255): CONST GrannySmithApple = 94~%%
    _PALETTECOLOR 95, _RGBA32(17, 100, 180, 255): CONST GreenBlue = 95~%%
    _PALETTECOLOR 96, _RGBA32(173, 255, 47, 255): CONST GreenYellow = 96~%%
    _PALETTECOLOR 97, _RGBA32(240, 255, 240, 255): CONST HoneyDew = 97~%%
    _PALETTECOLOR 98, _RGBA32(255, 29, 206, 255): CONST HotMagenta = 98~%%
    _PALETTECOLOR 99, _RGBA32(255, 105, 180, 255): CONST HotPink = 99~%%
    _PALETTECOLOR 100, _RGBA32(178, 236, 93, 255): CONST Inchworm = 100~%%
    _PALETTECOLOR 101, _RGBA32(205, 92, 92, 255): CONST IndianRed = 101~%%
    _PALETTECOLOR 102, _RGBA32(75, 0, 130, 255): CONST Indigo = 102~%%
    _PALETTECOLOR 103, _RGBA32(255, 255, 240, 255): CONST Ivory = 103~%%
    _PALETTECOLOR 104, _RGBA32(202, 55, 103, 255): CONST JazzberryJam = 104~%%
    _PALETTECOLOR 105, _RGBA32(59, 176, 143, 255): CONST JungleGreen = 105~%%
    _PALETTECOLOR 106, _RGBA32(240, 230, 140, 255): CONST Khaki = 106~%%
    _PALETTECOLOR 107, _RGBA32(254, 254, 34, 255): CONST LaserLemon = 107~%%
    _PALETTECOLOR 108, _RGBA32(230, 230, 250, 255): CONST Lavender = 108~%%
    _PALETTECOLOR 109, _RGBA32(255, 240, 245, 255): CONST LavenderBlush = 109~%%
    _PALETTECOLOR 110, _RGBA32(124, 252, 0, 255): CONST LawnGreen = 110~%%
    _PALETTECOLOR 111, _RGBA32(255, 250, 205, 255): CONST LemonChiffon = 111~%%
    _PALETTECOLOR 112, _RGBA32(255, 244, 79, 255): CONST LemonYellow = 112~%%
    _PALETTECOLOR 113, _RGBA32(240, 128, 128, 255): CONST LightCoral = 113~%%
    _PALETTECOLOR 114, _RGBA32(250, 250, 210, 255): CONST LightGoldenRodYellow = 114~%%
    _PALETTECOLOR 115, _RGBA32(211, 211, 211, 255): CONST LightGray = 115~%%
    _PALETTECOLOR 116, _RGBA32(144, 238, 144, 255): CONST LightGreen2 = 116~%%
    _PALETTECOLOR 117, _RGBA32(255, 182, 193, 255): CONST LightPink = 117~%%
    _PALETTECOLOR 118, _RGBA32(255, 160, 122, 255): CONST LightSalmon = 118~%%
    _PALETTECOLOR 119, _RGBA32(32, 178, 170, 255): CONST LightSeaGreen = 119~%%
    _PALETTECOLOR 120, _RGBA32(135, 206, 250, 255): CONST LightSkyBlue = 120~%%
    _PALETTECOLOR 121, _RGBA32(119, 136, 153, 255): CONST LightSlateGray = 121~%%
    _PALETTECOLOR 122, _RGBA32(176, 196, 222, 255): CONST LightSteelBlue = 122~%%
    _PALETTECOLOR 123, _RGBA32(255, 255, 224, 255): CONST LightYellow = 123~%%
    _PALETTECOLOR 124, _RGBA32(0, 255, 0, 255): CONST Lime = 124~%%
    _PALETTECOLOR 125, _RGBA32(50, 205, 50, 255): CONST LimeGreen = 125~%%
    _PALETTECOLOR 126, _RGBA32(250, 240, 230, 255): CONST Linen = 126~%%
    _PALETTECOLOR 127, _RGBA32(255, 189, 136, 255): CONST MacaroniAndCheese = 127~%%
    _PALETTECOLOR 128, _RGBA32(170, 240, 209, 255): CONST MagicMint = 128~%%
    _PALETTECOLOR 129, _RGBA32(205, 74, 76, 255): CONST Mahogany = 129~%%
    _PALETTECOLOR 130, _RGBA32(237, 209, 156, 255): CONST Maize = 130~%%
    _PALETTECOLOR 131, _RGBA32(151, 154, 170, 255): CONST Manatee = 131~%%
    _PALETTECOLOR 132, _RGBA32(255, 130, 67, 255): CONST MangoTango = 132~%%
    _PALETTECOLOR 133, _RGBA32(128, 0, 0, 255): CONST Maroon = 133~%%
    _PALETTECOLOR 134, _RGBA32(239, 152, 170, 255): CONST Mauvelous = 134~%%
    _PALETTECOLOR 135, _RGBA32(102, 205, 170, 255): CONST MediumAquamarine = 135~%%
    _PALETTECOLOR 136, _RGBA32(0, 0, 205, 255): CONST MediumBlue = 136~%%
    _PALETTECOLOR 137, _RGBA32(186, 85, 211, 255): CONST MediumOrchid = 137~%%
    _PALETTECOLOR 138, _RGBA32(147, 112, 219, 255): CONST MediumPurple = 138~%%
    _PALETTECOLOR 139, _RGBA32(60, 179, 113, 255): CONST MediumSeaGreen = 139~%%
    _PALETTECOLOR 140, _RGBA32(123, 104, 238, 255): CONST MediumSlateBlue = 140~%%
    _PALETTECOLOR 141, _RGBA32(0, 250, 154, 255): CONST MediumSpringGreen = 141~%%
    _PALETTECOLOR 142, _RGBA32(72, 209, 204, 255): CONST MediumTurquoise = 142~%%
    _PALETTECOLOR 143, _RGBA32(199, 21, 133, 255): CONST MediumVioletRed = 143~%%
    _PALETTECOLOR 144, _RGBA32(253, 188, 180, 255): CONST Melon = 144~%%
    _PALETTECOLOR 145, _RGBA32(25, 25, 112, 255): CONST MidnightBlue = 145~%%
    _PALETTECOLOR 146, _RGBA32(245, 255, 250, 255): CONST MintCream = 146~%%
    _PALETTECOLOR 147, _RGBA32(255, 228, 225, 255): CONST MistyRose = 147~%%
    _PALETTECOLOR 148, _RGBA32(255, 228, 181, 255): CONST Moccasin = 148~%%
    _PALETTECOLOR 149, _RGBA32(48, 186, 143, 255): CONST MountainMeadow = 149~%%
    _PALETTECOLOR 150, _RGBA32(197, 75, 140, 255): CONST Mulberry = 150~%%
    _PALETTECOLOR 151, _RGBA32(255, 222, 173, 255): CONST NavajoWhite = 151~%%
    _PALETTECOLOR 152, _RGBA32(0, 0, 128, 255): CONST Navy = 152~%%
    _PALETTECOLOR 153, _RGBA32(25, 116, 210, 255): CONST NavyBlue = 153~%%
    _PALETTECOLOR 154, _RGBA32(255, 163, 67, 255): CONST NeonCarrot = 154~%%
    _PALETTECOLOR 155, _RGBA32(253, 245, 230, 255): CONST OldLace = 155~%%
    _PALETTECOLOR 156, _RGBA32(128, 128, 0, 255): CONST Olive = 156~%%
    _PALETTECOLOR 157, _RGBA32(107, 142, 35, 255): CONST OliveDrab = 157~%%
    _PALETTECOLOR 158, _RGBA32(186, 184, 108, 255): CONST OliveGreen = 158~%%
    _PALETTECOLOR 159, _RGBA32(255, 165, 0, 255): CONST Orange = 159~%%
    _PALETTECOLOR 160, _RGBA32(255, 69, 0, 255): CONST OrangeRed = 160~%%
    _PALETTECOLOR 161, _RGBA32(248, 213, 104, 255): CONST OrangeYellow = 161~%%
    _PALETTECOLOR 162, _RGBA32(218, 112, 214, 255): CONST Orchid = 162~%%
    _PALETTECOLOR 163, _RGBA32(65, 74, 76, 255): CONST OuterSpace = 163~%%
    _PALETTECOLOR 164, _RGBA32(255, 110, 74, 255): CONST OutrageousOrange = 164~%%
    _PALETTECOLOR 165, _RGBA32(28, 169, 201, 255): CONST PacificBlue = 165~%%
    _PALETTECOLOR 166, _RGBA32(238, 232, 170, 255): CONST PaleGoldenRod = 166~%%
    _PALETTECOLOR 167, _RGBA32(152, 251, 152, 255): CONST PaleGreen = 167~%%
    _PALETTECOLOR 168, _RGBA32(175, 238, 238, 255): CONST PaleTurquoise = 168~%%
    _PALETTECOLOR 169, _RGBA32(219, 112, 147, 255): CONST PaleVioletRed = 169~%%
    _PALETTECOLOR 170, _RGBA32(255, 239, 213, 255): CONST PapayaWhip = 170~%%
    _PALETTECOLOR 171, _RGBA32(255, 207, 171, 255): CONST Peach = 171~%%
    _PALETTECOLOR 172, _RGBA32(255, 218, 185, 255): CONST PeachPuff = 172~%%
    _PALETTECOLOR 173, _RGBA32(197, 208, 230, 255): CONST Periwinkle = 173~%%
    _PALETTECOLOR 174, _RGBA32(205, 133, 63, 255): CONST Peru = 174~%%
    _PALETTECOLOR 175, _RGBA32(253, 221, 230, 255): CONST PiggyPink = 175~%%
    _PALETTECOLOR 176, _RGBA32(21, 128, 120, 255): CONST PineGreen = 176~%%
    _PALETTECOLOR 177, _RGBA32(255, 192, 203, 255): CONST Pink = 177~%%
    _PALETTECOLOR 178, _RGBA32(252, 116, 253, 255): CONST PinkFlamingo = 178~%%
    _PALETTECOLOR 179, _RGBA32(247, 143, 167, 255): CONST PinkSherbet = 179~%%
    _PALETTECOLOR 180, _RGBA32(221, 160, 221, 255): CONST Plum = 180~%%
    _PALETTECOLOR 181, _RGBA32(176, 224, 230, 255): CONST PowderBlue = 181~%%
    _PALETTECOLOR 182, _RGBA32(128, 0, 128, 255): CONST Purple = 182~%%
    _PALETTECOLOR 183, _RGBA32(116, 66, 200, 255): CONST PurpleHeart = 183~%%
    _PALETTECOLOR 184, _RGBA32(157, 129, 186, 255): CONST PurpleMountainsMajesty = 184~%%
    _PALETTECOLOR 185, _RGBA32(254, 78, 218, 255): CONST PurplePizzazz = 185~%%
    _PALETTECOLOR 186, _RGBA32(255, 73, 108, 255): CONST RadicalRed = 186~%%
    _PALETTECOLOR 187, _RGBA32(214, 138, 89, 255): CONST RawSienna = 187~%%
    _PALETTECOLOR 188, _RGBA32(113, 75, 35, 255): CONST RawUmber = 188~%%
    _PALETTECOLOR 189, _RGBA32(255, 72, 208, 255): CONST RazzleDazzleRose = 189~%%
    _PALETTECOLOR 190, _RGBA32(227, 37, 107, 255): CONST Razzmatazz = 190~%%
    _PALETTECOLOR 191, _RGBA32(255, 83, 73, 255): CONST RedOrange = 191~%%
    _PALETTECOLOR 192, _RGBA32(192, 68, 143, 255): CONST RedViolet = 192~%%
    _PALETTECOLOR 193, _RGBA32(31, 206, 203, 255): CONST RobinsEggBlue = 193~%%
    _PALETTECOLOR 194, _RGBA32(188, 143, 143, 255): CONST RosyBrown = 194~%%
    _PALETTECOLOR 195, _RGBA32(65, 105, 225, 255): CONST RoyalBlue = 195~%%
    _PALETTECOLOR 196, _RGBA32(120, 81, 169, 255): CONST RoyalPurple = 196~%%
    _PALETTECOLOR 197, _RGBA32(139, 69, 19, 255): CONST SaddleBrown = 197~%%
    _PALETTECOLOR 198, _RGBA32(250, 128, 114, 255): CONST Salmon = 198~%%
    _PALETTECOLOR 199, _RGBA32(244, 164, 96, 255): CONST SandyBrown = 199~%%
    _PALETTECOLOR 200, _RGBA32(252, 40, 71, 255): CONST Scarlet = 200~%%
    _PALETTECOLOR 201, _RGBA32(118, 255, 122, 255): CONST ScreaminGreen = 201~%%
    _PALETTECOLOR 202, _RGBA32(46, 139, 87, 255): CONST SeaGreen = 202~%%
    _PALETTECOLOR 203, _RGBA32(255, 245, 238, 255): CONST SeaShell = 203~%%
    _PALETTECOLOR 204, _RGBA32(165, 105, 79, 255): CONST Sepia = 204~%%
    _PALETTECOLOR 205, _RGBA32(138, 121, 93, 255): CONST Shadow = 205~%%
    _PALETTECOLOR 206, _RGBA32(69, 206, 162, 255): CONST Shamrock = 206~%%
    _PALETTECOLOR 207, _RGBA32(251, 126, 253, 255): CONST ShockingPink = 207~%%
    _PALETTECOLOR 208, _RGBA32(160, 82, 45, 255): CONST Sienna = 208~%%
    _PALETTECOLOR 209, _RGBA32(192, 192, 192, 255): CONST Silver = 209~%%
    _PALETTECOLOR 210, _RGBA32(135, 206, 235, 255): CONST SkyBlue = 210~%%
    _PALETTECOLOR 211, _RGBA32(106, 90, 205, 255): CONST SlateBlue = 211~%%
    _PALETTECOLOR 212, _RGBA32(112, 128, 144, 255): CONST SlateGray = 212~%%
    _PALETTECOLOR 213, _RGBA32(255, 250, 250, 255): CONST Snow = 213~%%
    _PALETTECOLOR 214, _RGBA32(0, 255, 127, 255): CONST SpringGreen = 214~%%
    _PALETTECOLOR 215, _RGBA32(70, 130, 180, 255): CONST SteelBlue = 215~%%
    _PALETTECOLOR 216, _RGBA32(255, 207, 72, 255): CONST Sunglow = 216~%%
    _PALETTECOLOR 217, _RGBA32(253, 94, 83, 255): CONST SunsetOrange = 217~%%
    _PALETTECOLOR 218, _RGBA32(210, 180, 140, 255): CONST Tann = 218~%%
    _PALETTECOLOR 219, _RGBA32(0, 128, 128, 255): CONST Teal = 219~%%
    _PALETTECOLOR 220, _RGBA32(24, 167, 181, 255): CONST TealBlue = 220~%%
    _PALETTECOLOR 221, _RGBA32(216, 191, 216, 255): CONST Thistle = 221~%%
    _PALETTECOLOR 222, _RGBA32(252, 137, 172, 255): CONST TickleMePink = 222~%%
    _PALETTECOLOR 223, _RGBA32(219, 215, 210, 255): CONST Timberwolf = 223~%%
    _PALETTECOLOR 224, _RGBA32(255, 99, 71, 255): CONST Tomato = 224~%%
    _PALETTECOLOR 225, _RGBA32(23, 128, 109, 255): CONST TropicalRainForest = 225~%%
    _PALETTECOLOR 226, _RGBA32(222, 170, 136, 255): CONST Tumbleweed = 226~%%
    _PALETTECOLOR 227, _RGBA32(64, 224, 208, 255): CONST Turquoise = 227~%%
    _PALETTECOLOR 228, _RGBA32(119, 221, 231, 255): CONST TurquoiseBlue = 228~%%
    _PALETTECOLOR 229, _RGBA32(255, 255, 102, 255): CONST UnmellowYellow = 229~%%
    _PALETTECOLOR 230, _RGBA32(238, 130, 238, 255): CONST Violet = 230~%%
    _PALETTECOLOR 231, _RGBA32(50, 74, 178, 255): CONST VioletBlue = 231~%%
    _PALETTECOLOR 232, _RGBA32(247, 83, 148, 255): CONST VioletRed = 232~%%
    _PALETTECOLOR 233, _RGBA32(255, 160, 137, 255): CONST VividTangerine = 233~%%
    _PALETTECOLOR 234, _RGBA32(143, 80, 157, 255): CONST VividViolet = 234~%%
    _PALETTECOLOR 235, _RGBA32(245, 222, 179, 255): CONST Wheat = 235~%%
    _PALETTECOLOR 236, _RGBA32(245, 245, 245, 255): CONST Whitesmoke = 236~%%
    _PALETTECOLOR 237, _RGBA32(162, 173, 208, 255): CONST WildBlueYonder = 237~%%
    _PALETTECOLOR 238, _RGBA32(255, 67, 164, 255): CONST WildStrawberry = 238~%%
    _PALETTECOLOR 239, _RGBA32(252, 108, 133, 255): CONST WildWatermelon = 239~%%
    _PALETTECOLOR 240, _RGBA32(205, 164, 222, 255): CONST Wisteria = 240~%%
    _PALETTECOLOR 241, _RGBA32(154, 205, 50, 255): CONST YellowGreen = 241~%%
    _PALETTECOLOR 242, _RGBA32(255, 174, 66, 255): CONST YellowOrange = 242~%%
$END IF

