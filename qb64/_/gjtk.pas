{
push es
push 0040h
pop es
mov di,006ch
mov ax, es:[di]
apa:
mov dx, es:[di]
sub dx, ax
cmp dx, [i]
jnz apa
pop es
}


{============================================================================

 GJTK (GRYMMJACK'S TOOL KIT) FOR PASCAL PROGRAMMING

 ----------------------------------------------------------------------------

 ---(m)ATH ROUTINES---
 mIsNum ........: Returns TRUE if argument is a number.
 mLeading0 .....: If less than 2 digits pads 0's into (for formatDT).
 mPercent ......: Returns percentage part is of a whole in 1-100% range.
 mRandom .......: Returns a random number in range (min/max).
 mPower ........: Increase N to power of X.
 mDec2Bin ......: Converts decimal to binary.
 mHex2Dec ......: Converts hexidecimal to decimal.
 mOct2Dec ......: Converts octal to decimal.
 mBin2Dec ......: Converts binary to decimal.
 mDec2Hex ......: Converts decimal to hexadecimal.
 mDec2Oct ......: Converts decimal to octal.
 mHex2Bin ......: Converts hexadecimal to binary.
 mBin2Hex ......: Converts binary to hexadecimal.
 mRom2Dec ......: Converts roman numeral to decimal.
 mDec2Rom ......: Converts decimal to roman numeral.
 mDuration .....: Converts seconds to years, months, days, hours, mins, secs

 ---GLOBAL ROUTINES---
 i2s ...........: Converts an integer type variable to a string type.
 s2i ...........: Converts a string type variable to an integer.
 formatDT ......: Returns a formatted Date/Time string.

 ---(d)OS PROPRIETARY ROUTINES---
*dSetCursorForm : Set the cursor to cuLine, cuBlock, cuHalf(block), or cuNone
*dCursorOff ....: Turns the cursor off makes it invisible.
*dCursorOn .....: Turns the cursor on and makes it visible.
*dSaveScreen ...: Saves the contents of video text memory for later.
*dLoadScreen ...: Loads the saved contents of video text memory.
*dGetPal .......: Stores palette information (call before fading).
*dFadeIn .......: Fades the screen in at speed of #.
*dFadeOut ......: Fades the screen out at speed of #.
*dWait .........: Waits n 100ths of a sec (going by clock on PC)
*dWinClipBoard .: Copies/pastes/clears windows clipboard.

 ---(s)TRING ROUTINES---
 sDisplayANSI ..: Parses ANSI text.
 sReverse ......: Returns reversed string.
 sStripCodes ...: Strips pipe codes and defined MCI codes.
 sStrip ........: Strips spaces from string.
 sStripR .......: Strips spaces from right side of string.
 sStripL .......: Strips spaces from left side of string.
 sMCICount......: Returns number of MCI codes in string.
 sWrite ........: Writes a string utilizing pipe color codes.
 sWriteln ......: Writes a string using pipe color codes and adds CRLF.
 sWordCount ....: Counts how many words are in a string.
 sGetWord ......: Returns a word in a string.
 sRep ..........: Repeats a character set amount of times.
 sPadL .........: Pads string left with character.
 sPadR .........: Pads string right with character.
 sRightJ .......: Right justifies string.
 sLeftJ ........: Left justifies string.
 sCenter .......: Centers string.
 sLeft .........: Returns portion of a string from the left side.
 sMid ..........: Returns portion of a string in the middle.
 sRight ........: Returns portion of a string on the right side.
 sOut ..........: Writes a string using pipe codes, MCI codes, and ANSI.
 sOutln ........: Writes a string using pipe codes, MCI codes, ANSI, & CRLF.
 sWordWrap .....: Wraps string to next line if exceeds N columns.

 ---(i)NTERFACE ROUTINES---
 iSleep ........: Waits # seconds.
 iNap ..........: Waits # tenths of a second.
 iPause ........: Waits for user to hit a key.
 iAskY .........: Ask a Yes or No question with default of yes.
 iAskN .........: Ask a Yes or No question with default of no.
 iInput ........: Returns input from the user in a proprietary fashion.
 iIsKeyPressed .: Checks to see if ANY key is pressed.
 iStuffBuff ....: Stuffs the keyboard buffer with string.

 ---(f)ILE ROUTINES---
 fRead .........: Read a text file and interpret ANSI codes.
 fView .........: Read a text file, interpret ANSI, pause at 25 lines.
 fShow .........: Show text file w/pausing, ANSI, and MCI parsing.
 fLineCount ....: Returns # of lines in text file.
 ----------------------------------------------------------------------------
 TO DO:
 ----------------------------------------------------------------------------

 fShow, fExists, fCopy, fMove, fRename, fDelete, fFind
 fDBcreate, fDBappend, fDBclose, fDBopen, fDBfindRec, fDBgotoRec, fDBgetRec
 fDBputRec, fDBremRec, fDBinstRec, fDBmoveRec, fDBsort, fDBexport, fDBimport
 iLBmenu, iHKmenu, iBox, iSpinCursor
 mSizeKB
 sAnim
 sConv (upper, lower, proper, random, vowels, numbers)
 duration

 ============================================================================}










uses crt, dos, strings, fasttext;



{$IFNDEF LINUX}
{----------------------------------------------------------------------------
 DOS/Win32 Proprietary Declarations.
 ----------------------------------------------------------------------------}
type
  rgb = record
    r, g, b : byte;
  end;
const
  pelAddrRgR = $3C7;
  pelAddrRgW = $3C8;
  pelDataReg = $3C9;
var
  buffer : array[1..4000] of byte;
  i      : integer;
  ch     : char;
  col    : array[0..63] of rgb;
{$ENDIF}



{----------------------------------------------------------------------------
 MCI Codes Definitions.
 ----------------------------------------------------------------------------}
const
  MCI : array[1..37] of string[2] = (
    '00', {FG Color: Black                    }
    '01', {FG Color: Blue                     }
    '02', {FG Color: Green                    }
    '03', {FG Color: Cyan                     }
    '04', {FG Color: Red                      }
    '05', {FG Color: Purple                   }
    '06', {FG Color: Brown                    }
    '07', {FG Color: White                    }
    '08', {FG Color: Bright Black             }
    '09', {FG Color: Bright Blue              }
    '10', {FG Color: Bright Green             }
    '11', {FG Color: Bright Cyan              }
    '12', {FG Color: Bright Red               }
    '13', {FG Color: Bright Purple            }
    '14', {FG Color: Bright Brown             }
    '15', {FG Color: Bright White             }
    '16', {BG Color: Black                    }
    '17', {BG Color: Blue                     }
    '18', {BG Color: Green                    }
    '19', {BG Color: Cyan                     }
    '20', {BG Color: Red                      }
    '21', {BG Color: Purple                   }
    '22', {BG Color: Brown                    }
    '23', {BG Color: White                    }

    'CR', {Carriage return/line feed (#10+#13)}
    'PA', {Pause                              }
    'PI', {'|'                                }
    '[X', {Goto column                        }
    '[Y', {Goto row                           }
    '[A', {Up 1 row                           }
    '[B', {Down 1 row                         }
    '[C', {Right 1 column                     }
    '[D', {Left 1 column                      }
    '@D', {Duplicate string                   }
    '@R', {Pad Right                          }
    '@L', {Pad Left                           }
    '@C'  {Center                             }

  );



{----------------------------------------------------------------------------
  Keyboard Scan Codes.
 ----------------------------------------------------------------------------}
const
    F1  = 59;    ctrlF1 = 94;    altF1 = 104;  homeKey = 71;
    F2  = 60;    ctrlF2 = 95;    altF2 = 105;   endKey = 79;
    F3  = 61;    ctrlF3 = 96;    altF3 = 106;     pgUp = 73;
    F4  = 62;    ctrlF4 = 97;    altF4 = 107;     pgDn = 81;
    F5  = 63;    ctrlF5 = 98;    altF5 = 108;  upArrow = 72;
    F6  = 64;    ctrlF6 = 99;    altF6 = 109;  rtArrow = 77;
    F7  = 65;    ctrlF7 = 100;   altF7 = 110;  dnArrow = 80;
    F8  = 66;    ctrlF8 = 101;   altF8 = 111;  ltArrow = 75;
    F9  = 67;    ctrlF9 = 102;   altF9 = 112;  insKey  = 82;
   F10  = 68;   ctrlF10 = 103;  altF10 = 113;  delKey  = 83;
  altQ  = 16;      altA = 30;     altZ = 44;      alt1 = 120;   shftF1 = 84;
  altW  = 17;      altS = 31;     altX = 45;      alt2 = 121;   shftF2 = 85;
  altE  = 18;      altD = 32;     altC = 46;      alt3 = 122;   shftF3 = 86;
  altR  = 19;      altF = 33;     altV = 47;      alt4 = 123;   shftF4 = 87;
  altT  = 20;      altG = 34;     altB = 48;      alt5 = 124;   shftF5 = 88;
  altY  = 21;      altH = 35;     altN = 49;      alt6 = 125;   shftF6 = 89;
  altU  = 22;      altJ = 36;     altM = 50;      alt7 = 126;   shftF7 = 90;
  altI  = 23;      altK = 37;                     alt8 = 127;   shftF8 = 91;
  altO  = 24;      altL = 38;                     alt9 = 128;   shftF9 = 92;
  altP  = 25;    ctrlLt = 115;  ctrlRt = 116;     alt0 = 129;  shftF10 = 93;
  ctrlA = #1;     ctrlK = #11;   ctrlU = #21;    ctrlB = #2;     ctrlL = #12;
  ctrlV = #22;    ctrlC = #3;    ctrlM = #13;    ctrlW = #23;    ctrlD = #4;
  ctrlN = #14;    ctrlX = #24;   ctrlE = #5;     ctrlO = #15;    ctrlY = #25;
  ctrlF = #6;     ctrlP = #16;   ctrlZ = #26;    ctrlG = #7;     ctrlQ = #17;
  ctrlS = #19;    ctrlH = #8;    ctrlR = #18;    ctrlI = #9;     ctrlJ = #10;
  ctrlT = #20;   bSpace = #8;   escape = #27;    enter = #13;  nullKey = #0;




{----------------------------------------------------------------------------
  Hardware Independent Timer Variables
 ----------------------------------------------------------------------------}
const
   delayCount : longint = 0;                          { Delay cycle counts }
   hrtimerRate: longint = 1193182;                    { RTC Timer rate }



{----------------------------------------------------------------------------
  ANSI Parser Global Variables.
 ----------------------------------------------------------------------------}
var
  ANSI_St        : string;
  ANSI_SCPL      : integer;
  ANSI_SCPC      : integer;
  ANSI_FG        : integer;
  ANSI_BG        : integer;
  ANSI_C,
  ANSI_I,
  ANSI_B,
  ANSI_R         : boolean;
  p, x, y        : integer;



{----------------------------------------------------------------------------
  Cursor Variables.
 ----------------------------------------------------------------------------}
type
  cursorForm=(cuNone,     { Hidden cursor         }
              cuLine,     { Line cursor           }
              cuBlock,    { Full box cursor       }
              cuHalf);    { Half box cursor       }

var
  cursors   : array [CursorForm] of word;
  cuCurrent : cursorForm; { Current cursor type   }
  cuLast    : cursorForm; { Last used cursor type }



{----------------------------------------------------------------------------
  Stuffkey variables.
 ----------------------------------------------------------------------------}
var
  stuffBuff : string[255];



{----------------------------------------------------------------------------
  Windows clipboard variables.
 ----------------------------------------------------------------------------}
const
  cf_OemText   = 7;
var
  clipBoard : pchar;



{----------------------------------------------------------------------------
  Viewport global variables.
 ----------------------------------------------------------------------------}
var
  viewPortStartLine : integer;
  viewPortEndLine   : integer;
  viewPortHeight    : integer;
  viewFirstPage     : boolean;
  continuousViewing : boolean;
  lineCount         : longint;
  oldLineCount      : integer;



{----------------------------------------------------------------------------
  Other Global variables.
 ----------------------------------------------------------------------------}
type
  buff_1K = array[1..1024] of byte;
var
  exitFlag     : boolean;
  byteBuffer1K : buff_1K;



{----------------------------------------------------------------------------
  Forward Declarations
 ----------------------------------------------------------------------------}
procedure iPause; forward;
procedure iSleep(seconds: integer); forward;
procedure iNap(tenthsOfAsecond: integer); forward;
procedure iSnooze(thousandthsOfAsecond: integer); forward;
procedure dWait(milliseconds: word); forward;
 function sStripL(s: string) : string; forward;
 function sCenter(s: string; numCols: integer) : string; forward;
 function sRep(s: string; numTimes: integer) : string; forward;
 function sStripR(s: string) : string; forward;
procedure sOut(s: string; wrapAt: byte); forward;
 function i2s(i: real) : string; forward;
procedure iStuffBuff(s: string); forward;
procedure sWrite(s: string); forward;










{============================================================================

                                                              (m)ATH ROUTINES

 ============================================================================}

{----------------------------------------------------------------------------
 function : mIsNum
            Tests whether argument is a number.
 ----------------------------------------------------------------------------}
function mIsNum(s: string) : boolean;
  var loop : integer;
begin
  for loop := 1 to length(s) do begin
    if not (s[loop] in ['0'..'9']) then mIsNum := false;
  end;
  mIsNum := true;
end;



{----------------------------------------------------------------------------
 function : mLeading0
            Prefixes numbers less than N places with leading 0's.
 ----------------------------------------------------------------------------}
function mLeading0(w: word; places: byte) : string;
  var s, s2 : string;
      loop  : integer;
begin
  s := ''; s2 := '';
  str(w, s);
  for loop := 1 to places do begin
    if (length(s) + length(s2)) < places then begin
      s2 := s2 + '0';
    end;
  end;
  mLeading0 := s2 + s;
end;



{----------------------------------------------------------------------------
 function : mPercent
            Returns percent from 0 - 100%.
 ----------------------------------------------------------------------------}
function mPercent(part, whole: integer): integer;
  var x : real;
      i : integer;
begin
  if (part = 0) or (whole = 0) then begin
    mPercent := 0;
    exit;
  end;
  if part >= whole then begin
    mPercent := 100;
    exit;
  end;
  x := part / whole * 100;
  i := round(x);
  mPercent := i;
end;



{----------------------------------------------------------------------------
 function : mRandom
            Returns a random number in range.
 ----------------------------------------------------------------------------}
function mRandom(min, max: integer): longint;
begin
  randomize;
  mRandom := random(max - min) + min;
end;



{----------------------------------------------------------------------------
 function : mPower
            Increase N to power of X.
 ----------------------------------------------------------------------------}
function mPower(n, x: word) : longint;
  var temp, loop : longint;
begin
  temp := 1;
  for loop :=1 to x do temp := temp * n;
  mPower := temp;
end;



{----------------------------------------------------------------------------
 function : mDec2Bin
            Converts decimal to binary.
 ----------------------------------------------------------------------------}
function mDec2Bin(dec: longint) : string;
  var b1            : integer;
      bin, binDigit : string;
begin
  binDigit := '01';
  bin := '';
  repeat
  b1 := dec mod 2;
  dec := dec div 2;
  bin := concat(binDigit[b1+1], bin);
  until dec < 1;
  mDec2Bin := bin;
end;



{----------------------------------------------------------------------------
 function : mHex2Dec
            Converts hexadecimal to decimal.
 ----------------------------------------------------------------------------}
function mHex2Dec(hex: string) : longint;
  var t1, t2, dec : longInt;
      error       : boolean;
begin
  t1 := 0; t2 := 0; dec := 0; error := false;
  for t1 := 1 to length(hex) do begin
    t2 := length(hex) - t1;
    case hex[t1] of
      '0'    : dec := dec + 0;
      '1'    : dec := dec + mPower(16, t2);
      '2'    : dec := dec + 2 * mPower(16, t2);
      '3'    : dec := dec + 3 * mPower(16, t2);
      '4'    : dec := dec + 4 * mPower(16, t2);
      '5'    : dec := dec + 5 * mPower(16, t2);
      '6'    : dec := dec + 6 * mPower(16, t2);
      '7'    : dec := dec + 7 * mPower(16, t2);
      '8'    : dec := dec + 8 * mPower(16, t2);
      '9'    : dec := dec + 9 * mPower(16, t2);
      'A','a': dec := dec + 10 * mPower(16,t2);
      'B','b': dec := dec + 11 * mPower(16, t2);
      'C','c': dec := dec + 12 * mPower(16, t2);
      'D','d': dec := dec + 13 * mPower(16, t2);
      'E','e': dec := dec + 14 * mPower(16, t2);
      'F','f': dec := dec + 15 * mPower(16, t2);
    else
      error := true;
    end;
  end;
  mHex2Dec := dec;
  if error then mHex2Dec := 0;
end;



{----------------------------------------------------------------------------
 function : mOct2Dec
            Converts octal to decimal.
 ----------------------------------------------------------------------------}
function mOct2Dec(oct: string) : longint;
  var t1, t2, dec : longint;
      error       : boolean;
begin
  t1 := 0; t2 := 0; dec := 0; error:=false;
  for t1 := 1 to length(oct) do begin
    t2 := length(oct) - t1;
    case oct[t1] of
      '0': dec := dec + 0;
      '1': dec := dec + mPower(8, t2);
      '2': dec := dec + 2 * mPower(8, t2);
      '3': dec := dec + 3 * mPower(8, t2);
      '4': dec := dec + 4 * mPower(8, t2);
      '5': dec := dec + 5 * mPower(8, t2);
      '6': dec := dec + 6 * mPower(8, t2);
      '7': dec := dec + 7 * mPower(8, t2);
    else
      error := true;
    end;
  end;
  mOct2Dec := dec;
  if error then mOct2Dec := 0;
end;



{----------------------------------------------------------------------------
 function : mBin2Dec
            Converts binary to decimal.
 ----------------------------------------------------------------------------}
function mBin2Dec(bin: string) : longint;
  var t1, t2, dec : longint;
      error       : boolean;
begin
  t1 := 0; t2 := 0; dec := 0; error:=false;
  for t1 := 1 to length(bin) do begin
    t2 := length(bin) - t1;
    case bin[t1] of
      '1': dec := dec + mPower(2, t2);
      '0': dec := dec + 0;
    else
      error := true;
    end;
  end;
  mBin2Dec :=dec;
  if error then mBin2Dec := 0;
end;



{----------------------------------------------------------------------------
 function : mDec2Hex
            Converts decimal to hexadecimal.
 ----------------------------------------------------------------------------}
function mDec2Hex(dec: longint) : string;
  var h1            : integer;
      hex, hexDigit : string;
begin
  hexDigit := '0123456789ABCDEF';
  hex := '';
  repeat
    h1 := dec mod 16;
    dec := dec div 16;
    hex := concat(hexdigit[h1+1], hex);
  until dec < 1;
  mDec2Hex := hex;
end;



{----------------------------------------------------------------------------
 function : mDec2Oct
            Converts decimal to octal.
 ----------------------------------------------------------------------------}
function mDec2Oct(dec: longint) : string;
  var o1            : integer;
      oct, octDigit : string;
begin
  octDigit := '01234567';
  oct := '';
  repeat
    o1 := dec mod 8;
    dec := dec div 8;
    oct := concat(octDigit[o1+1], oct);
  until dec < 1;
  mDec2Oct := oct;
end;



{----------------------------------------------------------------------------
 function : mHex2Bin
            Converts hexadecimal to binary.
 ----------------------------------------------------------------------------}
function mHex2Bin(hex: string) : string;
begin
  mHex2Bin := mDec2Bin(mHex2Dec(hex));
end;



{----------------------------------------------------------------------------
 function : mBin2Hex
            Converts binary to hexadecimal.
 ----------------------------------------------------------------------------}
function mBin2Hex(bin: string) : string;
begin
  mBin2Hex := mDec2Hex(mBin2Dec(bin));
end;



{----------------------------------------------------------------------------
 function : mRom2Dec
            Converts roman numeral to decimal.
 ----------------------------------------------------------------------------}
function mRom2Dec (const s: string) : longint;
  const symbolStr = 'MDCLXVI';
  var loop                     : integer;
      number, thisVal, lastVal : longint;
      txt                      : string;
      lookup                   : array [0..7] of longint;
begin
  lookup[0] := 0;
  lookup[1] := 1000;
  lookup[2] := 500;
  lookup[3] := 100;
  lookup[4] := 50;
  lookup[5] := 10;
  lookup[6] := 5;
  lookup[7] := 1;
  lastVal := 0;
  number := 0;
  for loop := 1 to length(s) do begin
    thisVal := lookup[pos(s[loop], symbolStr)];
    if thisVal = 0 then exit;
    if thisVal > lastVal then begin
      lastVal := thisVal - lastVal
    end
    else begin
        number := number + lastVal;
        lastVal := thisVal;
    end;
  end;
  number := number + lastVal;
  mRom2Dec := number;
end;



{----------------------------------------------------------------------------
 function : mDec2Rom
            Converts decimal to roman numeral.
 ----------------------------------------------------------------------------}
function mDec2Rom(num: longint) : string;
  var conv : string;
      n    : longint;

  function buildRoman(n: longint; val: longint; symbol: string) : string;
    var loop      : integer;
        converted : string;
  begin
    converted := '';
    n := n div val;
    for loop := 1 to n do begin;
      converted := symbol;
      n := n mod val;
    end;
    buildRoman := converted;
  end;

begin
  conv := ''; n := 0;
  repeat
    if num >= 1000 then begin
      conv := conv + buildRoman(num, 1000, 'M');
      num := num - 1000;
    end
    else if num >= 900 then begin
      conv := conv + buildRoman(num, 900, 'CM');
      num := num - 900;
    end
    else if num >= 500 then begin
      conv := conv + buildRoman(num, 500, 'D');
      num := num - 500;
    end
    else if num >= 400 then begin
      conv := conv + buildRoman(num, 400, 'CD');
      num := num - 400;
    end
    else if num >= 100 then begin
      conv := conv + buildRoman(num, 100, 'C');
      num := num - 100;
    end
    else if num >= 90 then begin
      conv := conv + buildRoman(num, 90, 'XC');
      num := num - 90;
    end
    else if num >= 50 then begin
      conv := conv + buildRoman(num, 50, 'L');
      num := num - 50;
    end
    else if num >= 40 then begin
      conv := conv + buildRoman(num, 40, 'XL');
      num := num - 40;
    end
    else if num >= 10 then begin
      conv := conv + buildRoman(num, 10, 'X');
      num := num - 10;
    end
    else if num >= 9 then begin
      conv := conv + buildRoman(num, 9, 'IX');
      num := num - 9;
    end
    else if num >= 5 then begin
      conv := conv + buildRoman(num, 5, 'V');
      num := num - 5;
    end
    else if num >= 4 then begin
      conv := conv + buildRoman(num, 4, 'IV');
      num := num - 4;
    end
    else if num >= 1 then begin
      conv := conv + buildRoman(num, 1, 'I');
      num := num - 1;
    end;
  until num = 0;
  mDec2Rom := conv;
end;



{----------------------------------------------------------------------------
 function : mDuration
            Converts seconds to years, months, days, hours, mins, secs.
 ----------------------------------------------------------------------------
            #y=Years     #h=Hours      Note: If you specify '' as format
            #m=Months    #n=Minutes          it will use default conditional.
            #d=Days      #s=Seconds
 ----------------------------------------------------------------------------}
function mDuration(s: string; seconds: longint; numLeadingZeros: byte) : string;
  const
    secsInYear   = 31104000;
    secsInMonth  = 2592000;
    secsInDay    = 86400;
    secsInHour   = 3600;
    secsInMinute = 60;
  var loop, years, months, days, hours, mins : integer;
      processed                              : string;
begin
  years := 0; months := 0; days := 0; hours := 0; mins := 0; processed := '';
  if s = '' then s := '#ss';
  repeat
    if seconds >= secsInYear then begin
      years := seconds div secsInYear;
      if seconds >= secsInYear then insert('#yy', s, 1);
      seconds := seconds mod secsInYear;
    end
    else if seconds >= secsInMonth then begin
      months := seconds div secsInMonth;
      if seconds >= secsInMonth then insert('#mm', s, 1);
      seconds := seconds mod secsInMonth;
    end
    else if seconds >= secsInDay then begin
      days := seconds div secsInDay;
      if seconds >= secsInDay then insert('#dd', s, 1);
      seconds := seconds mod secsInDay;
    end
    else if seconds >= secsInHour then begin
      hours := seconds div secsInHour;
      if seconds >= secsInHour then insert('#hh', s, 1);
      seconds := seconds mod secsInHour;
    end
    else if seconds >= secsInMinute then begin
      mins := seconds div secsInMinute;
      if seconds >= secsInMinute then insert('#nm', s, 1);
      seconds := seconds mod secsInMinute;
    end;
    if seconds = 0 then begin
      delete(s, length(s) - 2, 3);
    end;
  until (seconds = 0) or (seconds <= secsInMinute);
  for loop := 1 to length(s) do begin
    if s[loop] = '#' then begin
      case s[loop+1] of
        'Y', 'y': begin
          if years > 0 then begin
            if numLeadingZeros > 0 then processed := processed + mLeading0(years, numLeadingZeros)
            else processed := processed + i2s(years);
            if s = '' then processed := processed + 'y';
            loop := loop + 1;
          end;
        end;
        'M', 'm': begin
          if months > 0 then begin
            if numLeadingZeros > 0 then processed := processed + mLeading0(months, numLeadingZeros)
            else processed := processed + i2s(months);
            if s = '' then processed := processed + 'm';
            loop := loop + 1;
          end;
        end;
        'D', 'd': begin
          if days > 0 then begin
            if numLeadingZeros > 0 then processed := processed + mLeading0(days, numLeadingZeros)
            else processed := processed + i2s(days);
            if s = '' then processed := processed + 'd';
            loop := loop + 1;
          end;
        end;
        'H', 'h': begin
          if hours > 0 then begin
            if numLeadingZeros > 0 then processed := processed + mLeading0(hours, numLeadingZeros)
            else processed := processed + i2s(hours);
            if s = '' then processed := processed + 'h';
            loop := loop + 1;
          end;
        end;
        'N', 'n': begin
          if mins > 0 then begin
            if numLeadingZeros > 0 then processed := processed + mLeading0(mins, numLeadingZeros)
            else processed := processed + i2s(mins);
            if s = '' then processed := processed + 'm';
            loop := loop + 1;
          end;
        end;
        'S', 's': begin
          if seconds > 0 then begin
            if numLeadingZeros > 0 then processed := processed + mLeading0(seconds, numLeadingZeros)
            else processed := processed + i2s(seconds);
            if s = '' then processed := processed + 's';
            loop := loop + 1;
          end;
        end;
      else
        processed := processed + s[loop];
      end;
    end
    else begin
      processed := processed + s[loop];
    end;
  end;
  mDuration := processed;
end;










{============================================================================

                                                              GLOBAL ROUTINES

 ============================================================================}

{----------------------------------------------------------------------------
  function : i2s
             Converts number to string.
 ----------------------------------------------------------------------------}
function i2s(i: real) : string;
  var s : string;
begin
  s := '';
  str(i:0:0, s);
  i2s := s;
end;



{----------------------------------------------------------------------------
 function : s2i
            Converts string to number.
 ----------------------------------------------------------------------------}
function s2i(s: string) : longint;
  var i, code : integer;
begin
  i := 0; code := 0;
  if mIsNum(s) then val(s, i, code);
  s2i := i;
end;



{----------------------------------------------------------------------------
 function : formatDT
            Returns a formatted Date & Time.
 ----------------------------------------------------------------------------
            m=Month      (01-12)   d=Day    (01-31)    y=Year   (2001-2099)
            h=Hour       (01-12)   n=Minute (00-59)    s=Second (00-59)
            $=Hundredths (00-99)   ?=AM/PM designation                          |
 ----------------------------------------------------------------------------}
function formatDT(s: string) : string;
  var dy, dm, dd, dow   : word;
      th, tm, ts, ths   : word;
      formatted, symbol : string;
      loop              : integer;
      done              : boolean;
begin
  done := false; formatted := ''; loop := 0;
  getdate(dy, dm, dd, dow);
  gettime(th, tm, ts, ths);
  if th > 12 then begin
    th := th - 12;
    symbol := 'pm';
  end
  else begin
    symbol := 'am';
  end;
  for loop := 1 to length(s) do begin
    case s[loop] of
      'm': formatted := formatted + mLeading0(dm, 2);
      'd': formatted := formatted + mLeading0(dd, 2);
      'y': formatted := formatted + mLeading0(dy, 2);
      'h': formatted := formatted + mLeading0(th, 2);
      'n': formatted := formatted + mLeading0(tm, 2);
      's': formatted := formatted + mLeading0(ts, 2);
      '$': formatted := formatted + mLeading0(ths, 2);
      '?': formatted := formatted + symbol;
      else
        formatted := formatted + s[loop];
    end;
  end;
  formatDT := formatted;
end;










{$IFNDEF LINUX OR OS2}
{============================================================================

                                                     DOS PROPRIETARY ROUTINES

 ============================================================================}


{----------------------------------------------------------------------------
 function : dGetCursorKind
            Gets the kind of cursor.
 ----------------------------------------------------------------------------}
function dGetCursorKind : word; assembler;
asm
  mov ah,$03;
  xor bh,bh;
  int $10;
  xchg ax,cx;
end;



{----------------------------------------------------------------------------
 function : dSetCursorKind
            Sets the kind of cursor.
 ----------------------------------------------------------------------------}
procedure dSetCursorKind(w: word); assembler;
asm
  mov cx,w;
  mov ah,1;
  int 10h
end;



{----------------------------------------------------------------------------
 function : dIsColorVideo
            Returns true/false if display is color or b&w.
 ----------------------------------------------------------------------------}
function dIsColorVideo : boolean;
  var cb : word;
begin
  asm
    int $11;
    mov cb,ax
  end;
  dIsColorVideo := cb and $30 <> $30
end;



{----------------------------------------------------------------------------
 function : dInitCursor
            Set values based on color/b&w display.
 ----------------------------------------------------------------------------}
procedure dInitCursor;
begin
  cursors[cuNone] := $0100;
  if dIsColorVideo then begin
    cursors[cuLine] := $0607;
    cursors[cuBlock]:= $0007;
    cursors[cuHalf] := $0407
  end
  else begin
    cursors[cuLine] := $0c0d;
    cursors[cuBlock]:= $000d;
    cursors[cuHalf] := $060d
  end;
  dSetCursorKind(cursors[cuLine])
end;



{----------------------------------------------------------------------------
 function : dSetCursorForm
            Sets the cursor type.
 ----------------------------------------------------------------------------}
procedure dSetCursorForm(kind: CursorForm);
begin
  cuLast := cuCurrent;
  cuCurrent := kind;
  dSetCursorKind(cursors[kind])
end;



{----------------------------------------------------------------------------
 function : dCursorOn
            Turns the cursor on.
 ----------------------------------------------------------------------------}
procedure dCursorOn; {assembler;
}
begin
  if cursors[cuLast] = 0 then cuLast := cuLine;
  dSetCursorForm(cuLast);
end;



{----------------------------------------------------------------------------
 function : dCursorOff
            Turns the cursor off.
 ----------------------------------------------------------------------------}
procedure dCursorOff;
begin
  dSetCursorKind(cursors[cuNone]);
end;



{----------------------------------------------------------------------------
 procedure : dSaveScreen
             Takes snapshot of text video memory.
 ----------------------------------------------------------------------------}
procedure dSaveScreen;
begin
  move(mem[$b800:0000], buffer,4000);
end;



{----------------------------------------------------------------------------
 procedure : dLoadScreen
             Restores text video memory to previous snapshot.
 ----------------------------------------------------------------------------}
procedure dLoadScreen;
begin
  move(buffer, mem[$b800:0000],4000);
end;



{----------------------------------------------------------------------------
 procedure : dFade
             Fades text video in or out at speed.
 ----------------------------------------------------------------------------}
procedure dFade(mode: byte; speed: integer);

  procedure getCol(c : byte; var r, g, b : byte);
  begin
    port[pelAddrRgR] := c;
    r := port[pelDataReg];
    g := port[pelDataReg];
    b := port[pelDataReg];
  end;

  procedure setCol(c, r, g, b : byte);
  begin
    port[pelAddrRgW] := c;
    port[pelDataReg] := r;
    port[pelDataReg] := g;
    port[pelDataReg] := b;
  end;

  procedure setInten(b : byte);
    var fr, fg, fb : byte;
        i          : integer;
  begin
    for i := 0 to 63 do begin
      fr := col[i].r * b div 63;
      fg := col[i].g * b div 63;
      fb := col[i].b * b div 63;
      setCol(i, fr, fg, fb);
    end;
  end;

  procedure fadeIn(speed: integer);
  begin
    for i := 0 to 63 do begin
      setInten(i);
      iSnooze(speed);
    end;
  end;

  procedure fadeOut(speed: integer);
  begin
     for i := 63 downto 0 do begin
       setInten(i);
       iSnooze(speed);
     end;
  end;

begin
  case mode of
    0: fadeOut(speed);
    1: fadeIn(speed);
  end;
end;



{----------------------------------------------------------------------------
 procedure : dGetPal
             Gets snapshot of video palette.
 ----------------------------------------------------------------------------}
procedure dGetPal;
  var i : integer;
begin
  for i := 0 to 63 do begin;
    port[pelAddrRgR] := i;
    col[i].r := port[pelDataReg];
    col[i].g := port[pelDataReg];
    col[i].b := port[pelDataReg];
  end;
end;
{$ENDIF}



{----------------------------------------------------------------------------
 procedure : dWait
             Waits N milliseconds in a hardware independent manner.
 ----------------------------------------------------------------------------}
procedure dWait(milliseconds: word);
{$IFNDEF LINUX}
  {$IFNDEF OS2}
 {---------------------------------------------------------------------------
  function : readMicroTimer
             Read the system timer with 1 microsecond resolution
  ---------------------------------------------------------------------------}
  function readMicroTimer: longint; assembler;
    asm
      cli;                         { disable interrupts  }
      mov al, 0ah;                 { set irr address     }
      out 20h, al;                 { ask to read irr     }
      mov al, 00h;                 { value to set timer  }
      out 43h, al;                 { set timer 0 latch   }
      in al, dx;                   { read irr value      }
      mov di, ax;                  { save value in di    }
      in al, 40h;                  { read counter value  }
      mov bl, al;                  { lsb in bl           }
      in al, 40h;                  { read counter value  }
      mov bh, al;                  { msb in bh           }
      not bx;                      { asscending count    }
      in al, 21h;                  { read pic imr        }
      mov si, ax;                  { save value in si    }
      mov al, 0ffh;                { mask all interrupts }
      out 21h, al;                 { stop all interrupts }
      mov ax, [seg0040];           { dos data segment    }
      mov es, ax;                  { set register        }
      mov dx, es:[006ch];          { read time clock     }
      mov ax, si;                  { reload pic imr      }
      out 21h, al;                 { restore interrupts  }
      sti;                         { enable interrupts   }
      mov ax, di;                  { retreive old irr    }
      test al, 01h;                { counter hit 0       }
      jz @@done;                   { count complete      }
      cmp bx, 0ff00h;              { counter > $ffxx     }
      ja @@done;                   { counter complete    }
      inc dx;                      { count irq request   }
    @@done:
      mov ax, bx;                  { return time pulses  }
    end;
  {$ELSE}
  function readMicroTimer: longint;
    var value: longInt;
  begin
    dosQuerySysInfo(qsv_ms_count, qsv_ms_count, value, sizeof(value));
    readMicroTimer := value;
  end;
  {$ENDIF}

  {$IFNDEF OS2}
 {---------------------------------------------------------------------------
  function : delay
             Waits N milliseconds.
  ---------------------------------------------------------------------------}
  procedure delay (milliSecs: word); assembler;
  asm
    cmp word ptr [delaycount], 0;
    jnz @@alreadyinstalled;        { delay installed  }
    mov ax, [seg0040];
    mov es, ax;                    { dos data segment }
    mov si, 006ch;
    mov ax, es:[si];               { read dos clock   }
  @@differwait:
    cmp ax, es:[si];
    jz @@differwait;               { wait for change  }
    mov ax, es:[si];
    mov cx, 0ffffh;                { preset count     }
  @@differwait1:
    cmp ax, es:[si];
    jnz @@differs;                 { wait for tick    }
    loop @@differwait1;
  @@differs:
    mov ax, 0037h;
    xchg cx, ax;                   { calculate delay  }
    not ax;
    xor dx, dx;
    div cx;
    mov word ptr [delaycount], ax; { hold delay count }
  @@alreadyinstalled:
    mov dx, [millisecs];           { retreive delay   }
  @@countloop:
    or dx, dx;
    jz @@exit;                     { zero delay exit  }
    xor si, si;
    mov ax, [seg0040];             { load address     }
    mov es, ax;
    mov ax, es:[si];
    mov cx, word ptr [delaycount]; { load delay count }
  @@wait2:
    cmp ax, es:[si];
    jnz @@over;
    loop @@wait2;                  { wait 1ms         }
  @@over:
    dec dx;
    jnz @@countloop;               { repeat 1ms delay }
  @@exit:
  end;
  {$ELSE}
 {---------------------------------------------------------------------------
  function : delayLoop
             Waits N milliseconds.
  ---------------------------------------------------------------------------}
 function delayLoop (count: longint; var startvalue: longint): longint;
   var value: longint;
 begin
   repeat
     dosquerysysinfo(qsv_ms_count, qsv_ms_count,
       value, sizeof(value));
     dec(count);
   until (value <> startvalue) or (count = -1);
   startvalue := value;
   delayloop := count;
 end;
 {---------------------------------------------------------------------------
  procedure : calcDelayCount
              Calculates 1ms delay count for delayLoop. Call at startup.
  ---------------------------------------------------------------------------}
  procedure calcdelaycount;
    var interval, startValue, value: longint;
  begin
    dosQuerySysInfo(qsv_timer_interval, qsv_timer_interval, interval, sizeof(interval));
    dosQuerySysInfo(qsv_ms_count, qsv_ms_count, startValue, sizeof(startvalue));
    repeat
      dosQuerySysInfo(qsv_ms_count, qsv_ms_count, value, sizeof(value));
    until (value <> startValue);
    tenthscount := -delayloop(-1, value) div interval;
    delaycount := tenthscount * 10;
  end;
 {---------------------------------------------------------------------------
  procedure : delay
              Delays for N milliseconds.
  ---------------------------------------------------------------------------}
  procedure delay (millisecs: word);
    var startValue, value: longint; count: longint;
  begin
    if (delaycount=0) then calcdelaycount;
    if (millisecs >= (5*31)) then dossleep(millisecs)
    else begin
      dosQuerySysInfo(qsv_ms_count, qsv_ms_count, startValue, sizeof(startValue));
      value := startValue;
      count := millisecs;
      repeat
        delayloop(delaycount, value);
        dec(count);
      until (value-startValue >= millisecs) or (count <= 0);
    end;
  end;
  {$ENDIF}
{$ENDIF}
begin
  delay(milliseconds);
end;


{$IFNDEF LINUX OR OS2}
{---------------------------------------------------------------------------
 procedure : dWinClipBoard
             Copies/Pastes/Clears the windows clipboard.
 ---------------------------------------------------------------------------}
procedure dWinClipBoard(action: integer; s: string);
  var loop   : integer;
      s2     : string;
      clipSz : longint;


  function clipOK: boolean;
    var r: registers;
  begin
    r.ax:= $1700;
    intr($2F,r);
    ClipOK := r.ax <> $1700;
  end;


  function clipBoardCompact(ldesired: longint): longint;
    var r: registers;
  begin
    r.ax:= $1709;
    r.si:= word(ldesired shr 16);
    r.cx:= word(ldesired);
    intr($2F,r);
    clipBoardCompact:= longint(r.ax) + longint(r.dx) shl 16;
  end;


  function closeClipboard: boolean;
    var r: registers;
  begin
    r.ax:= $1708;
    intr($2F,r);
    closeClipboard:= r.ax <> 0;
  end;


  function emptyClipboard: boolean;
    var r: registers;
  begin
    r.ax:= $1702;
    intr($2F,r);
    emptyClipboard:= r.ax <> 0;
  end;


  function getClipboardDataSize(wFormat: Word): longint;
    var r: registers;
  begin
    r.ax:= $1704;
    r.dx:= wFormat;
    intr($2F,r);
    getClipboardDataSize:= longint(r.ax) + longint(r.dx) shl 16;
  end;


  function getClipboardData(wFormat: word; dataPtr: pointer): boolean;
    var r: registers;
  begin
    r.ax:= $1705;
    r.dx:= wFormat;
    r.es:= seg(DataPtr^);
    r.bx:= ofs(DataPtr^);
    intr($2F,r);
    getClipboardData:= r.ax <> 0;
  end;


  function openClipboard: boolean;
    var r: registers;
  begin
    r.ax:= $1701;
    intr($2F,r);
    openClipboard:= r.ax <> 0;
  end;


  function setClipboardData(wFormat: word; dataPtr: pointer; lsize: longint): boolean;
    var r: registers;
  begin
    setClipboardData:= false;
    if (dataPtr <> nil) and (lsize <> 0) then begin
      if clipboardCompact(lSize) >= lsize then begin
        r.ax:= $1703;
        r.dx:= wFormat;
        r.es:= seg(dataPtr^);
        r.bx:= ofs(dataPtr^);
        r.si:= word(lsize shr 16);
        r.cx:= word(lsize);
        intr($2F,r);
        setClipboardData:= r.ax <> 0;
      end;
    end;
  end;


  procedure readFromClipboard(var ClipText: pchar);
    var clipLength : longint;
  begin
    if openClipboard then begin
      clipLength := getClipboardDataSize(cf_OemText);
      getMem(ClipText, clipLength);
      getClipboardData(cf_OemText, clipText);
      closeClipboard;
    end;
  end;


  procedure writeToClipboard(var clipText: pchar);
  begin
    if openClipboard then begin
       if emptyClipboard then begin
         setClipboardData(cf_OemText, clipText, succ(strLen(ClipText)));
       end
       else begin
         writeln('Error clearing the clipboard.');
         closeClipboard;
       end;
    end
    else begin
      writeln('Error opening the clipboard.');
    end;
  end;


begin
  if clipOK = true then begin
    case action of
      0: begin
           openClipBoard;
           emptyClipBoard;
           closeClipBoard;
      end;
      1: begin
           if openClipboard then begin
             clipSz := getClipBoardDataSize(cf_OemText);
             if clipSz > 0 then begin
               readFromClipBoard(clipBoard);
               loop := 0;
               repeat
                 iStuffBuff(clipBoard[loop]);
                 inc(loop);
               until loop = strLen(clipBoard);
             end;
           end;
           closeClipboard;
      end;
      2: begin
           strPCopy(clipBoard, s);
           writeToClipBoard(clipBoard);
      end;
    end;
  end;
end;
{$ENDIF}










{============================================================================

                                                            (s)TRING ROUTINES

 ============================================================================}

{----------------------------------------------------------------------------
 function : sReverse
            Returns string reversed.
 ----------------------------------------------------------------------------}
function sReverse(s: string) : string;
  var s2   : string;
      loop : integer;
begin
  s2 := '';
  for loop := length(s) downto 1 do begin
    s2 := s2 + s[loop];
  end;
  sReverse := s2;
end;



{----------------------------------------------------------------------------
 function : sCheckLine
            Checks current line and pauses if at end of window.
 ----------------------------------------------------------------------------}
procedure sCheckLine;
  var loop : integer;
      ch   : char;
      done : boolean;
begin
  oldLineCount := lineCount;
  if (viewPortStartLine > 0) and (viewPortEndLine > 0) then begin

    if (viewFirstPage = false) and (lineCount = viewPortEndLine) then begin
       viewFirstPage := true;
       exitFlag := true;
       exit;
    end;

    if lineCount = viewPortEndLine then begin
      viewFirstPage := true;
      if continuousViewing = false then begin
        gotoxy(1, viewPortEndLine + 1);
        sOut(sCenter('|15more|07? |08(|15y|08)|07es|08, |08(|15n|08)|07o|08, |08(|07c|08)|15ontinuous', 80), 0);
        repeat
          ch := readkey;
          if ch = nullKey then ch := readkey;
          case ch of
            'Y', 'y', #13: begin
               done := true;
            end;
            'N', 'n', #27: begin
               exitFlag := true;
               exit;
            end;
            'C', 'c': begin
               continuousViewing := true;
               gotoxy(1, viewPortEndLine + 1);
               clrEol;
               done := true;
            end;
          end;
        until done = true
      end;

      lineCount := viewPortStartLine;

      for loop := viewPortStartLine to viewPortEndLine do begin
        gotoxy(1, loop);
        clrEol;
      end;
      gotoxy(1, viewPortStartLine);
    end;
  end;
end;


{----------------------------------------------------------------------------
 function : sDisplayANSI
            Displays ANSI text without need for ANSI.SYS
 ----------------------------------------------------------------------------}
function sDisplayANSI(s: string): string;
  var loop : integer;

  procedure tabulate;
    var x : integer;
  begin
    x := wherex;
    if x < 80 then
      repeat
        inc(x);
      until (x mod 8) = 0;
    if x = 80 then x := 1;
    gotoxy(x, wherey);
    if x = 1 then begin
      writeln;
      lineCount := lineCount + 1;
      sCheckLine;
      if exitFlag then exit;
    end;
  end;


  procedure backspace;
    var x : integer;
  begin
    if wherex > 1 then
      write(^H, ' ', ^H)
    else
      if wherey > 1 then begin
        gotoxy(80, wherey - 1);
        write(' ');
        gotoxy(80, wherey - 1);
        lineCount := lineCount - 1;
        sCheckLine;
        if exitFlag then exit;
      end;
  end;


  procedure tty(ch : char);
    var x : integer;
  begin
    if ANSI_C then begin
      if ANSI_I then ANSI_FG := ANSI_FG or 8;
      if ANSI_B then ANSI_FG := ANSI_FG or 16;
      if ANSI_R then begin
        x := ANSI_FG;
        ANSI_FG := ANSI_BG;
        ANSI_BG := x;
      end;
      ANSI_C := false;
    end;
    textColor(ANSI_FG);
    textBackground(ANSI_BG);
    case ch of
      ^G: begin
            sound(2000);
            delay(75);
            noSound;
          end;
      ^H: backspace;
      ^I: tabulate;
      ^J: begin
            textBackground(0);
            write(^J);
          end;
      ^K: gotoxy(1,1);
      ^L: begin
            textBackground(0);
            clrScr;
            lineCount := viewPortStartLine;
          end;
      ^M: begin
            textBackground(0);
            write(^M);
            lineCount := lineCount + 1;
            sCheckLine;
            if exitFlag then exit;
          end;
      else sWrite(ch);
    end;
  end;


  procedure ANSIWrite(s : String);
    var x : integer;
  begin
    for x := 1 to length(s) do tty(s[x]);
  end;

  function param : integer;   {returns -1 if no more parameters}
    var s2    : string;
        x, xx : integer;
        b     : boolean;
  begin
    b := false;
    for x := 3 to length(ANSI_St) do
      if ANSI_St[x] in ['0'..'9'] then b := true;
    if not b then
      param := -1
    else begin
      s2 := '';
      x := 3;
      if ANSI_St[3] = ';' then begin
        param:=0;
        delete(ANSI_St,3,1);
        exit;
      end;
      repeat
        s2 := s2 + ANSI_St[x];
        x := x + 1;
      until (not (ANSI_St[x] in ['0'..'9'])) or (length(s2) > 2) or (x > length(ANSI_St));
      if length(s2) > 2 then begin
        ANSIWrite(ANSI_St + s[loop]);
        ANSI_St := '';
        param := -1;
        exit;
      end;
      delete(ANSI_St, 3, length(s2));
      if ANSI_St[3] = ';' then delete(ANSI_St, 3, 1);
      val(s2, x, xx);
      param := x;
    end;
  end;

begin

  for loop := 1 to length(s) do begin
    if (s[loop] <> #27) and (ANSI_St = '') then begin
      tty(s[loop]);
      exit;
    end;
    if s[loop] = #27 then begin
      if ANSI_St <> '' then begin
        ANSIWrite(ANSI_St + #27);
        ANSI_St := '';
      end else ANSI_St := #27;
      exit;
    end;
    if ANSI_St = #27 then begin
      if s[loop]='[' then
        ANSI_St := #27 + '['
      else begin
        ANSIWrite(ANSI_St + s[loop]);
        ANSI_St := '';
      end;
      exit;
    end;
    if (s[loop] = '[') and (ANSI_St <> '') then begin
      ANSIWrite(ANSI_St + '[');
      ANSI_St := '';
      exit;
    end;
    if not (s[loop] in ['0'..'9',';','A'..'D','f','H','J','K','m','s','u']) then begin
      ANSIWrite(ANSI_St + s[loop]);
      ANSI_St := '';
      exit;
    end;
    if s[loop] in ['A'..'D','f','H','J','K','m','s','u'] then begin
      case s[loop] of
        'A': begin
               p := param;
               if p = -1 then p := 1;
               if wherey - p < 1 then
                 gotoxy(wherex, 1)
               else gotoxy(wherex, wherey - p);
               lineCount := lineCount - 1;
               sCheckLine;
               if exitFlag then exit;
             end;
        'B': begin
               p := param;
               if p = -1 then p := 1;
               if wherey + p > 25 then
                 gotoxy(wherex, 25)
               else gotoxy(wherex, wherey + p);
               lineCount := lineCount + 1;
               sCheckLine;
               if exitFlag then exit;
             end;
        'C': begin
               p := param;
               if p = -1 then p := 1;
               if wherex + p > 80 then
                 gotoxy(80, wherey)
               else gotoxy(wherex + p, wherey);
             end;
        'D': begin
               p := param;
               if p = -1 then p := 1;
               if wherex - p < 1 then
               gotoxy(1, wherey)
               else gotoxy(wherex - p, wherey);
             end;
    'H','f': begin
               y := param;
               x := param;
               if y < 1 then y := 1;
               if x < 1 then x := 1;
               if (x > 80) or (x < 1) or (y > 25) or (y < 1) then begin
                 ANSI_St := '';
                 exit;
               end;
               gotoxy(x, y);
               if (y > lineCount) and (lineCount < 25) then lineCount := y
               else lineCount := lineCount + (lineCount - y);
               sCheckLine;
               if exitFlag then exit;
             end;
        'J': begin
               p := param;
               if p = 2 then begin
                 textBackground(0);
                 clrScr;
                 lineCount := viewPortStartLine;
                 sCheckLine;
                 if exitFlag then exit;
               end;
               if p = 0 then begin
                 x := wherex;
                 y := wherey;
                 window(1, y, 80, 25);
                 textBackground(0);
                 clrScr;
                 window(1, 1, 80, 25);
                 gotoxy(x, y);
               end;
               if p = 1 then begin
                 x := wherex;
                 Y := wherey;
                 window(1, 1, 80, wherey);
                 textBackground(0);
                 clrScr;
                 window(1, 1, 80, 25);
                 gotoxy(x, y);
               end;
             end;
        'K': begin
               textBackground(0);
               clrEol;
             end;
        'm': begin
               if ANSI_St = #27+ '[' then begin
                 ANSI_FG := 7;
                 ANSI_BG := 0;
                 ANSI_I  := false;
                 ANSI_B  := false;
                 ANSI_R  := false;
               end;
               repeat
                 p := param;
                 case p of
                   -1:;
                    0: begin
                         ANSI_FG := 7;
                         ANSI_BG := 0;
                         ANSI_I  := false;
                         ANSI_R  := false;
                         ANSI_B  := false;
                       end;
                    1: ANSI_I    := true;
                    5: ANSI_B    := true;
                    7: ANSI_R    := true;
                   30: ANSI_FG   := 0;
                   31: ANSI_FG   := 4;
                   32: ANSI_FG   := 2;
                   33: ANSI_FG   := 6;
                   34: ANSI_FG   := 1;
                   35: ANSI_FG   := 5;
                   36: ANSI_FG   := 3;
                   37: ANSI_FG   := 7;
                   40: ANSI_BG   := 0;
                   41: ANSI_BG   := 4;
                   42: ANSI_BG   := 2;
                   43: ANSI_BG   := 6;
                   44: ANSI_BG   := 1;
                   45: ANSI_BG   := 5;
                   46: ANSI_BG   := 3;
                   47: ANSI_BG   := 7;
                 end;
                 if ((p >= 30) and (p <= 47)) or (p = 1) or (p = 5) or (p = 7) then ANSI_C := true;
               until p = -1;
             end;
        's': begin
               ANSI_SCPL := wherey;
               ANSI_SCPC := wherex;
             end;
        'u': begin
               if ANSI_SCPL > -1 then
                 gotoxy(ANSI_SCPC, ANSI_SCPL);
                 ANSI_SCPL := -1;
                 ANSI_SCPC := -1;
               end;
             end;
        ANSI_St := '';
        exit;
      end; {case}
      if s[loop] in ['0'..'9',';'] then begin
        ANSI_St := ANSI_St + s[loop];
        if length(ANSI_St) > 50 then begin
          ANSIWrite(ANSI_St);
          ANSI_St := '';
          exit;
        end;
      end;
  end;
end;



{----------------------------------------------------------------------------
 function : sStripCodes
            Strips all color codes and MCI codes from string.
 ----------------------------------------------------------------------------}
function sStripCodes(s: string) : string;
  var parsed, code    : string;
      p, loop, oldp   : integer;
      done            : boolean;
begin
  p := 0; code := ''; done := false; parsed := '';
  repeat
    p := p + 1;
    oldp := p;
    code := copy(s, p + 1, 2);
    if s[p] = '|' then begin
      for loop := 1 to high(MCI) do begin
        if code = MCI[loop] then begin
           p := p + 2;
        end;
      end;
      if oldp = p then parsed := parsed + s[oldp];
    end
    else begin
      parsed := parsed + s[p];
    end;
    if p = length(s) then done := true;
  until done = true;
  sStripCodes := parsed;
end;



{----------------------------------------------------------------------------
 procedure : sWrite
             Writes text and evaluates color codes.
 ----------------------------------------------------------------------------}
procedure sWrite(s: string);
  var code : string;
      done : boolean;
      p    : integer;
begin
  p := 0; done := false; code := '';
  repeat
    p := p + 1;
    code := copy(s, p + 1, 2);
    if s[p] = '|' then begin
      if code = '00' then begin
         textColor(0);
         p := p + 3;
      end;
      case s2i(code) of
        1..15: begin
          textColor(s2i(code));
          p := p + 2;
        end;
        16..23: begin
          textBackground((s2i(code) - 16));
          p := p + 2;
        end;
        else
          write(s[p]);
      end;
    end
    else begin
      write(s[p]);
    end;
    if p = length(s) then done := true;
  until done = true;
end;



{----------------------------------------------------------------------------
 procedure : sMCICount
             Returns number of MCI codes in string.
 ----------------------------------------------------------------------------}
function sMCICount(s: string) : integer;
  var code           : string;
      ch             : char;
      done           : boolean;
      p, loop, count : integer;
begin
  p := 0; done := false; code := ''; count := 0;
  repeat
    p := p + 1;
    code := copy(s, p + 1, 2);
    ch := s[p];
    if ch = '|' then begin
      if code = '00' then begin
        p := p + 2;
        count := count + 1;
      end;
      case s2i(code) of
        1..23: begin
          p := p + 2;
          count := count + 1;
        end
        else
          for loop := 1 to high(MCI) do begin
            if code = MCI[loop] then begin
              p := p + 2;
              count := count + 1;
            end;
          end;
      end;
    end;
    if p = length(s) then done := true;
  until done = true;
  sMCICount := count * 3;
end;



{----------------------------------------------------------------------------
 procedure : sWriteln
             Writes text and evaluates color codes and appends with CR/LF.
 ----------------------------------------------------------------------------}
procedure sWriteln(s: string);
begin
  sWrite(s + #10 + #13);
end;



{----------------------------------------------------------------------------
 function : sWordCount
            Returns total number of words in argument.
 ----------------------------------------------------------------------------}
function sWordCount(s: string; delimiter: char) : integer;
  var loop, startLoop, wordCounter : integer;
begin
  wordCounter := 1;
  s := sStripL(s);
  s := sStripR(s);
  for loop := 1 to length(s) do begin
    if pos(delimiter, copy(s, loop, 1)) > 0 then begin
      if (s[loop] = ' ') and (s[loop+1] <> ' ') and (s[loop+1] <> #10) then begin
        wordCounter := wordCounter + 1;
      end;
    end
  end;
  sWordCount := wordCounter;
end;



{----------------------------------------------------------------------------
 function : sGetWord
            Returns Nth word in string if it exists, otherwise returns null.
 ----------------------------------------------------------------------------}
function sGetWord(s: string; delimiter: char; wordNum: integer) : string;
  var beginWord, endWord, foundWord, loop : integer;
begin
  foundWord := 1;
  if pos(delimiter, s) > 0 then begin
    if wordNum = 1 then begin
      sGetWord := copy(s, 1, pos(delimiter, s) - 1);
      exit;
    end
    else begin
      for loop := 1 to length(s) do begin
        if s[loop] = delimiter then begin
          foundWord := foundWord + 1;
          if foundWord = wordNum then begin
            beginWord := loop + 1;
            endWord := pos(delimiter, copy(s, beginWord + 1, length(s)));
            if endWord = 0 then endWord := length(s);
            sGetWord := copy(s, beginWord, endWord);
            exit;
          end
        end
      end;
    end
  end
  else begin
    sGetWord := '';
  end
end;



{----------------------------------------------------------------------------
 function : sRep
            Repeats string N times.
 ----------------------------------------------------------------------------}
function sRep(s: string; numTimes: integer) : string;
  var s2    : string;
      loop : integer;
begin
  s2:= '';
  for loop := 1 to numTimes do s2 := s2 + s;
  sRep := s2;
end;



{----------------------------------------------------------------------------
 function : sPadL
            Pads the argument N places using char.
 ----------------------------------------------------------------------------}
function sPadL(s: string; padChar: char; numTimes: integer) : string;
  var padded  : string;
      counter : integer;
begin
  padded := '';
  padded := padded + s;
  for counter := 1 to numTimes do padded := padded + padChar;
  sPadL := padded;
end;



{----------------------------------------------------------------------------
 function : sPadR
            Pads the argument # places to the right using char.                     |
 ----------------------------------------------------------------------------}
function sPadR(s: string; padChar: char; numTimes: integer) : string;
  var padded  : string;
      counter : integer;
begin
  padded := '';
  for counter := 1 to numTimes do begin
    padded := padded + padChar;
  end;
  sPadR := padded + s;
end;



{----------------------------------------------------------------------------
 function : sRightJ
            Right justifies string.
 ----------------------------------------------------------------------------}
function sRightJ(s: string) : string;
begin
  gotoxy(80 + sMCICount(s) - length(s), wherey);
  sRightJ := s;
end;



{----------------------------------------------------------------------------
 function : sLeftJ
            Left justifies string.
 ----------------------------------------------------------------------------}
function sLeftJ(s: string) : string;
begin
  gotoxy(1, wherey);
  sLeftJ := s;
end;



{----------------------------------------------------------------------------
 function : sCenter
            Centers string using N columns.
 ----------------------------------------------------------------------------}
function sCenter(s: string; numCols: integer) : string;
  var center : integer;
begin
  center := (numCols + sMCICount(s) - length(s)) div 2;
  gotoxy(center, wherey);
  sCenter := s;
end;



{----------------------------------------------------------------------------
 function : sMid
            Returns N characters from string between X and Y.
 ----------------------------------------------------------------------------}
function sMid(s: string; startNum: integer; numChars: integer) : string;
begin
  sMid := copy(s, startNum, numChars)
end;



{----------------------------------------------------------------------------
 function : sLeft
            Returns N characters from string starting from left.
 ----------------------------------------------------------------------------}
function sLeft(s: string; numChars: integer) : string;
begin
  sLeft := copy(s, 1, numChars);
end;



{----------------------------------------------------------------------------
 function : sRight
            Returns N characters from string starting from right.
 ----------------------------------------------------------------------------}
function sRight(s: string; numChars: integer) : string;
begin
  sRight := copy(s, (length(s) - (numChars - 1)), length(s));
end;



{----------------------------------------------------------------------------
 function : sStrip
            Strips all spaces from string.
 ----------------------------------------------------------------------------}
function sStrip(s: string) : string;
  var s2   : string;
      loop : integer;
begin
  s2 := '';
  for loop := 1 to length(s) do begin
    if not (s[loop] = ' ') then s2 := s2 + s[loop];
  end;
  sStrip := s2;
end;



{----------------------------------------------------------------------------
 function : sStripR
            Strips spaces from right side of string.
 ----------------------------------------------------------------------------}
{'                         testing 1234 |15test                  }
function sStripR(s: string) : string;
  var s2             : string;
      lastWord, loop : integer;
begin
  s2 := sReverse(s);
  if copy(s, length(s), 1) = ' ' then begin
    for loop := length(s) downto 1 do begin
      if (s2[loop] = ' ') and (s2[loop+1] <> ' ') then lastWord := loop;
    end;
    sStripR := copy(s, 1, length(s) - lastWord);
  end
  else begin
    sStripR := s;
  end;
end;



{----------------------------------------------------------------------------
 function : sStripL
            Strips spaces from left side of string.
 ----------------------------------------------------------------------------}
function sStripL(s: string) : string;
  var s2             : string;
      lastWord, loop : integer;
begin
  if copy(s, 1, 1) = ' ' then begin
    for loop := length(s) downto 1 do begin
      if (s[loop] = ' ') and (s[loop+1] <> ' ') then lastWord := loop;
    end;
    sStripL := copy(s, lastWord+1, length(s));
  end
  else begin
   sStripL := s;
  end;
end;



{----------------------------------------------------------------------------
 function : sFindLastWord
            Returns interger pointer to position of last word in string.
 ----------------------------------------------------------------------------}
function sFindLastWord(s: string) : integer;
  var loop, p : integer;
begin
  p := 0;
  for loop := 1 to length(s) do begin
    if s[loop] = ' ' then p := loop;
  end;
  sFindLastWord := p;
end;


{----------------------------------------------------------------------------
 function : sWordWrap
            Wraps string if it exceeds N columns.
 ----------------------------------------------------------------------------}
function sWordWrap(s: string; wrapAt: integer) : string;
  var lastWord : integer;
begin
  lastWord := 0;
  if s[length(s)] <> ' ' then s := s + ' ';
  if wherex = 80 then gotoxy(1, wherey + 1);
  if wrapAt = 0 then wrapAt := 79;
  if wherex > 1 then wrapAt := wrapAt - wherex;
  if sMCIcount(s) > 0 then wrapAt := wrapAt + sMCIcount(s);
  if length(s) > wrapAt then begin
    lastWord := sFindLastWord(copy(s, 1, wrapAt));
    insert('|CR', s, lastWord);
    delete(s, lastWord+3, 1);
  end;
  sWordWrap := s;
end;



{----------------------------------------------------------------------------
 procedure : sOut
             Writes text and evaluates color and MCI codes.
 ----------------------------------------------------------------------------
 |CR    = CR/LF             |PI   = Pipe(|)           |PA   = Pause
 |[Xnn  = Goto column n     |[Ynn = Goto row n        |[Ann = Move up n rows
 |[Bnn  = Move down n rows  |[Cnn = Move right n cols |[Dnn = Move left n cols
 |@R    = Right justify     |@L   = Left Justify      |@C   = Center
 |@DnnX = Dupe X n times
 ----------------------------------------------------------------------------}
procedure sOut(s: string; wrapAt: byte);
  var code, code2, s2   : string;
      code3             : char;
      done              : boolean;
      p, loop, lastWord : integer;

  procedure doWordWrap;
  begin
    if wherex in [1..wrapAt] then wrapAt := wrapAt - wherex;
    if length(sGetWord(s, ' ', 1)) + wherex > wrapAt then gotoxy(1, wherey+1);
    if sMCIcount(s) > 0 then wrapAt := wrapAt + sMCIcount(s);
    if (length(s) > wrapAt) then begin
      if s[length(s)] <> ' ' then s := s + ' ';
      lastWord := sFindLastWord(copy(s, 1, wrapAt));
      insert('|CR', s, lastWord);
      if s[lastWord+3] = ' ' then delete(s, lastWord+3, 1);
    end;
  end;

begin
  code := ''; code2 := ''; s2 := ''; code3 := nullKey; done := false;
  p := 0; loop := 0; lastWord := 0;
  if s = '' then begin
     writeln;
     exit;
  end;
  if wherex = 80 then gotoxy(1, wherey + 1);
  if wrapAt > 1 then doWordWrap;

  repeat
    p := p + 1;
    code := copy(s, p + 1, 2);
    if s[p] = '|' then begin
      if code = '00' then begin
         textColor(0);
         p := p + 3;
      end;
      case s2i(code) of
        1..15: begin
          textColor(s2i(code));
          ANSI_FG := s2i(code);
          p := p + 2;
        end;
        16..23: begin
          textBackground((s2i(code) - 16));
          ANSI_BG := s2i(code);
          p := p + 2;
        end;
        else begin
          if code = 'CR' then begin
            writeln('');
            p := p + 2;
          end
          else if code = 'PA' then begin
            iPause;
            p := p + 2;
          end
          else if code = 'PI' then begin
            write('|');
            p := p + 2;
          end
          else if code = '[X' then begin
            code2 := copy(s, p + 3, 2);
            gotoxy(s2i(code2), wherey);
            p := p + 4;
          end
          else if code = '[Y' then begin
            code2 := copy(s, p + 3, 2);
            gotoxy(wherex, s2i(code2));
            p := p + 4;
          end
          else if code = '[A' then begin
            code2 := copy(s, p + 3, 2);
            for loop := 1 to s2i(code2) do begin
              if wherey > 1 then begin
                gotoxy(wherex, wherey - 1);
              end;
            end;
            p := p + 4;
          end
          else if code = '[B' then begin
            code2 := copy(s, p + 3, 2);
            for loop := 1 to s2i(code2) do begin
              if wherey < 25 then begin
                gotoxy(wherex, wherey + 1);
              end;
            end;
            p := p + 4;
          end
          else if code = '[C' then begin
            code2 := copy(s, p + 3, 2);
            for loop := 1 to s2i(code2) do begin
              if wherex < 80 then begin
                gotoxy(wherex + 1, wherey);
              end
              else begin
                gotoxy(1, wherey + 1);
              end;
            end;
            p := p + 4;
          end
          else if code = '[D' then begin
            code2 := copy(s, p + 3, 2);
            for loop := 1 to s2i(code2) do begin
              if wherex > 1 then begin
                gotoxy(wherex - 1, wherey);
              end
              else begin
                gotoxy(80, wherey - 1);
              end;
            end;
            p := p + 4;
          end
          else if code = '@D' then begin
            code2 := copy(s, p + 3, 2);
            code3 := s[p+5];
            write(sRep(code3, s2i(code2)));
            p := p + 5;
          end
          else if code = '@R' then begin
            s2 := copy(s, p + 3, length(s));
            sRightJ(s2);
            exit;
          end
          else if code = '@L' then begin
            code2 := copy(s, p + 3, 2);
            s2 := copy(s, p + 3, length(s));
            sLeftJ(s2);
            exit;
          end
          else if code = '@C' then begin
            code2 := copy(s, p + 3, 2);
            s2 := copy(s, p + 5, length(s));
            write(sCenter(s2, s2i(code2)));
            exit;
          end
          else
            write(s[p]);
          end;
      end;
    end
    else begin
      sDisplayANSI(s[p]);
    end;
    if p = length(s) then done := true;
  until done = true;
end;



{----------------------------------------------------------------------------
 procedure : sOutln
             Writes string with pipe codes and MCI codes and adds CRLF.
 ----------------------------------------------------------------------------}
procedure sOutln(s: string; wrapAt: byte);
begin
  sOut(s + #10 + #13, wrapAt);
end;










{============================================================================

                                                         (i)NTERFACE ROUTINES

 ============================================================================}

{----------------------------------------------------------------------------
 procedure : iSleep
             Waits for # seconds.
 ----------------------------------------------------------------------------}
procedure iSleep(seconds : integer);
  var i : integer;
begin
  for i := 1 to seconds do begin
{$IFNDEF LINUX}
    dWait(11931);
    dWait(11931);
    dWait(11931);
    dWait(11931);
    dWait(11931);
    dWait(11931);
    dWait(11931);
    dWait(11931);
    dWait(11931);
    dWait(11931);
{$ELSE}
    delay(1000);
{$ENDIF}
  end;
end;



{----------------------------------------------------------------------------
 procedure : iNap
             Waits for # tenths of a second.
 ----------------------------------------------------------------------------}
procedure iNap(tenthsOfAsecond : integer);
  var i : integer;
begin
  for i := 1 to tenthsOfAsecond do begin
{$IFNDEF LINUX}
    dWait(11931);
{$ELSE}
    delay(100);
{$ENDIF}
  end;
end;



{----------------------------------------------------------------------------
 procedure : iSnooze
             Waits for # 1000ths of a second.
 ----------------------------------------------------------------------------}
procedure iSnooze(thousandthsOfAsecond : integer);
  var i : integer;
begin
  for i := 1 to thousandthsOfAsecond do begin
{$IFNDEF LINUX}
    dWait(119);
{$ELSE}
    delay(10);
{$ENDIF}
  end;
end;



{----------------------------------------------------------------------------
 procedure : iPause
             Waits for the user to hit a key.
 ----------------------------------------------------------------------------}
procedure iPause;
  var ch : char;
begin
  repeat
    ch := readkey;
    if ch = nullKey then readkey;
  until ch <> '';
end;



{----------------------------------------------------------------------------
 function : iAskY
            Awaits a key either Y or N and returns true if Y.
 ----------------------------------------------------------------------------}
function iAskY : boolean;
  var ch   : char;
      done : boolean;
begin
  repeat
    ch := readkey;
    case ch of
      'Y', 'y', #13: begin
        iAskY := true;
        done := true;
      end;
      'N', 'n', #27: begin
        iAskY := false;
        done := true;
      end;
    end;
  until done = true
end;



{----------------------------------------------------------------------------
 function : iAskN
            Awaits a key either Y or N and returns true if N.
 ----------------------------------------------------------------------------}
function iAskN : boolean;
  var ch   : char;
      done : boolean;
begin
  repeat
    ch := readkey;
    case ch of
      'Y', 'y', #27: begin
        iAskN := false;
        done := true;
      end;
      'N', 'n', #13: begin
        iAskN := true;
        done := true;
      end;
    end;
  until done = true
end;



{----------------------------------------------------------------------------
 function : iInput
            Accepts input from the user and returns the result.
 ----------------------------------------------------------------------------
            Field   = The size of the input field in characters.
            Max     = The maximum allowable length for the desired input.
            Default = What the input field already contains.
 ----------------------------------------------------------------------------}
function iInput (field, max: integer; default: string) : string;
  var keypress, ch             : char;
      currentInput, s2         : string;
      counter, posCursor, loop : integer;
      xOrigin, yOrigin         : integer;
      fieldStart, fieldEnd     : integer;
      done, insertToggle       : boolean;

  procedure redrawInput;
  begin
    gotoxy(xOrigin, yOrigin);
    write(sRep(' ', field));
    gotoxy(xOrigin, yOrigin);
    write(copy(currentInput, fieldStart, fieldEnd));
  end;


  procedure doStatus;
  begin
    counter := wherex;
    sOut('|[Y10|[X01posCursor...........:    |[D03' + i2s(posCursor), 80);
    sOut('|[Y11|[X01length(currentInput):    |[D03' + i2s(length(currentInput)), 80);
    sOut('|[Y12|[X01fieldStart..........:    |[D03' + i2s(fieldStart), 80);
    sOut('|[Y13|[X01fieldEnd............:    |[D03' + i2s(fieldEnd), 80);
    sOut('|[Y14|[X01counter.............:    |[D03' + i2s(counter), 80);
    sOut('|[Y15|[X01xOrigin.............:    |[D03' + i2s(xOrigin), 80);
    sOut('|[Y16|[X01keypress............:    |[D03' + keypress, 80);
    gotoxy(counter, yOrigin);
  end;


begin
  xOrigin := wherex;
  yOrigin := wherey;
  counter := 0;
  if field = 0 then field := 79;
  if max = 0 then max := 255;
  if stuffBuff <> '' then begin
    s2 := default;
    for loop := 1 to max - length(default) do begin
      s2 := s2 + stuffBuff[loop];
    end;
  end;
  if length(default) > 0 then begin
    currentInput := default;
    if length(currentInput) > field then begin
      posCursor  := length(currentInput) + 1;
      fieldStart := length(currentInput) - field + 1;
      fieldEnd   := field;
      write(copy(currentInput, fieldStart, fieldEnd));
      gotoxy(xOrigin + field, wherey);
    end
    else begin
      fieldStart := 1;
      fieldEnd   := length(currentInput);
      posCursor  := length(currentInput) + 1;
      write(currentInput);
    end;
  end
  else begin
    currentInput := '';
    posCursor := 0;
  end;
  repeat
    repeat
      keypress := readkey;
      if keypress = nullKey then begin
        keypress := readkey;
        case ord(keypress) of


          endKey: begin
            if length(currentInput) > 0 then begin
              if posCursor >= length(currentInput) then begin
                write(#7);
              end
              else if length(currentInput) > field then begin
                posCursor  := length(currentInput) + 1;
                fieldStart := length(currentInput) - field + 1;
                fieldEnd   := field;
                redrawInput;
                gotoxy(xOrigin + field, wherey);
              end
              else begin
                gotoxy(xOrigin + length(currentInput), yOrigin);
                posCursor := length(currentInput) + 1;
              end;
            end
            else begin
              write(#7);
            end;
          end;


          homeKey: begin
            if wherex > xOrigin then begin
              posCursor  := 1;
              fieldStart := 1;
              fieldEnd   := field;
              redrawInput;
              gotoxy(xOrigin, yOrigin);
            end
            else begin
              write(#7);
            end;
          end;


          rtArrow: begin
            if posCursor > length(currentInput) then begin
              write(#7);
            end
            else begin
              if wherex = xOrigin + field then begin
                if posCursor < length(currentInput) + 1 then begin
                  if fieldStart > (length(currentInput) - field) then begin
                    write(#7);
                  end
                  else begin
                    fieldStart := fieldStart + 1;
                    fieldEnd   := field;
                    counter    := wherex;
                    posCursor  := posCursor + 1;
                    redrawInput;
                    gotoxy(xOrigin + field, yOrigin);
                  end;
                end
                else begin
                  write(#7);
                end;
              end
              else begin
                counter   := wherex;
                posCursor := posCursor + 1;
                gotoxy(counter + 1, yOrigin);
              end;
            end;
          end;


          ltArrow: begin
            if (length(currentInput) > 0) and (posCursor > 1) then begin
              if (wherex = xOrigin) and (length(currentInput) > field) then begin
                posCursor  := posCursor - 1;
                fieldStart := fieldStart - 1;
                fieldEnd   := field;
                if fieldStart = 0 then begin
                  write(#7 + #7);
                end
                else begin
                  redrawInput;
                  gotoxy(xOrigin, yOrigin);
                end;
              end
              else begin
                posCursor := posCursor - 1;
                gotoxy(wherex - 1, yOrigin);
              end;
            end
            else begin
              write(#7);
            end;
          end;


          insKey: begin
            if insertToggle = true then begin
              insertToggle := false;
              dSetCursorForm(cuLine);
            end
            else begin
              insertToggle := true;
              dSetCursorForm(cuHalf);
            end;
          end;


          delKey: begin
            if (length(currentInput) > 0) and (posCursor >= 1) then begin
              if posCursor = length(currentInput) + 1 then begin
                write(#7);
              end
              else begin
                counter := wherex;
                delete(currentInput, posCursor, 1);
                redrawInput;
                gotoxy(counter, yOrigin);
              end;
            end
            else begin
              write(#7);
            end;
          end;


        end; {case}
      end {special keys}
      else begin {non special but non normal keys}
        case keypress of


          bSpace : begin
            if length(currentInput) >= 1 then begin
              if (wherex = xOrigin) and (length(currentInput) = 1) then begin
                 write(#7);
              end
              else if posCursor = length(currentInput) then begin
                if length(currentInput) >= field then begin
                  fieldStart := fieldStart - 1;
                  fieldEnd   := field;
                  posCursor  := posCursor - 1;
                  counter    := wherex;
                  delete(currentInput, posCursor, 1);
                  redrawInput;
                  gotoxy(counter -1, yOrigin);
                end
                else begin
                  fieldStart := fieldStart - 1;
                  fieldEnd   := field;
                  posCursor  := posCursor - 1;
                  counter    := wherex;
                  delete(currentInput, posCursor, 1);
                  redrawInput;
                  if length(currentInput) > field then gotoxy(counter, yOrigin);
                  if posCursor = length(currentInput) then gotoxy(counter - 1, yOrigin);
                end;
              end
              else if wherex = xOrigin then begin
                if (length(currentInput) >= field) and (posCursor >= length(currentInput)) then begin
                  fieldStart := posCursor - field div 2;
                  fieldEnd   := fieldStart + field div 2;
                  posCursor  := posCursor - 1;
                  counter    := wherex;
                  delete(currentInput, posCursor, 1);
                  redrawInput;
                end
                else begin
                  if posCursor = 1 then begin
                    write(#7);
                  end
                  else begin
                    fieldStart := 1;
                    fieldEnd   := field;
                    posCursor  := posCursor - 1;
                    counter    := wherex;
                    delete(currentInput, posCursor, 1);
                    redrawInput;
                    gotoxy(xOrigin + length(currentInput), yOrigin);
                  end;
                end;
              end
              else begin
                posCursor := posCursor - 1;
                counter   := wherex;
                delete(currentInput, posCursor, 1);
                redrawInput;
                gotoxy(counter - 1, yOrigin);
              end;
            end
            else begin
              write(#7);
            end;
          end;


          ctrlV: begin
            if (length(stuffBuff) > 0) then begin
              counter := 0;
              for loop := 1 to length(stuffBuff) do begin
                if loop <= max then begin
                  if length(currentInput)+1 <= max then begin
                    ch := stuffBuff[loop];
                    if stuffBuff[loop] in [#10, #13] then ch := ' ';
                    insert(ch, currentInput, posCursor);
                    posCursor := posCursor + 1;
                    counter := counter + 1;
                  end;
                end
                else begin
                 write(#7);
                end;
              end;
            end
            else begin
              write(#7);
            end;
            if length(currentInput) > field then begin
              fieldStart := length(currentInput) - field + 1;
              fieldEnd   := field;
            end
            else begin
              fieldStart := 1;
              fieldEnd := length(currentInput);
            end;
            counter := wherex;
            gotoxy(counter, yOrigin);
            redrawInput;
          end;


          ctrlY: begin
            posCursor := 1;
            currentInput := '';
            gotoxy(xOrigin, yOrigin);
            write(sRep(' ', field));
            gotoxy(xOrigin, yOrigin);
          end;


          enter : begin
            iInput := currentInput;
            exit;
          end;


          else begin { all other keys }
            if length(currentInput) < max then begin
              if wherex = xOrigin + field then begin
                if posCursor = length(currentInput) + 1 then begin
                  fieldStart   := posCursor - field div 2;
                  fieldEnd     := fieldStart + field div 2;
                  insert(keypress, currentInput, posCursor);
                  posCursor := posCursor + 1;
                  counter := wherex;
                  redrawInput;
                  if posCursor = length(currentInput) + 1 then begin
                    gotoxy(xOrigin + length(copy(currentInput, fieldStart, fieldEnd)), yOrigin);
                  end
                  else begin
                    gotoxy(counter + 1, yOrigin);
                  end;
                end
                else begin
                  fieldStart   := fieldStart + 1;
                  fieldEnd     := field;
                  insert(keypress, currentInput, posCursor);
                  posCursor    := posCursor + 1;
                  redrawInput;
                  gotoxy(xOrigin + field, yOrigin);
                end;
              end
              else begin
                if posCursor = 1 then begin
                  counter := wherex;
                  insert(keypress, currentInput, posCursor);
                  posCursor  := posCursor + 1;
                  fieldStart := 1;
                  fieldEnd   := field;
                  redrawInput;
                  gotoxy(counter + 1, yOrigin);
                end
                else begin
                  counter := wherex;
                  insert(keypress, currentInput, posCursor);
                  posCursor := posCursor + 1;
                  redrawInput;
                  gotoxy(counter + 1, yOrigin);
                end;
              end;
            end
            else begin
              write(#7);
            end; {normal keys}


          end; {case else}
        end; {case others}
      end; {case special}
    until keypressed;
  until done = true;
end;



{----------------------------------------------------------------------------
 function : iIsKeyPressed
            Checks to see if ANY key is pressed.
 ----------------------------------------------------------------------------}
function iIsKeyPressed : boolean;
begin
  iIsKeyPressed := ((mem[$40:$17] and $0F) > 0) or (mem[$40:$18] > 0)
                     or keypressed;
end;



{----------------------------------------------------------------------------
 function : iStuffBuff
            Stuffs input buffer with string.
 ----------------------------------------------------------------------------}
procedure iStuffBuff(s: string);
  var loop : integer;
begin
  for loop := 1 to length(s) do begin
    stuffBuff := stuffBuff + s[loop];
  end;
end;










{============================================================================

                                                              (f)ILE ROUTINES

 ============================================================================}

{----------------------------------------------------------------------------
 function : fFileSize
            Returns number of bytes file.
 ----------------------------------------------------------------------------}
function fFileSize(fn: string) : longint;
  var f  : file of byte;
      sz : longint;
begin
  {$I-}
  assign(f, fn);
  reset(f);
  {$I+}
  if IOresult <> 0 then exit;
  sz := filesize(f);
  close(f);
  fFileSize := sz;
end;



{----------------------------------------------------------------------------
 function : fLineCount
            Returns number of lines in text file.
 ----------------------------------------------------------------------------}
function fLineCount(fn: string) : longint;
  var index, bytesRead          : word;
      fileSz, bytesProc, lCount : longint;
      f                         : file;
begin
  index := 0; bytesRead := 0; bytesProc := 0; lCount := 0;
  {$I-}
  assign(f, fn);
  reset(f, 1);
  {$I+}
  if IOresult <> 0 then exit;
  fileSz := fFilesize(fn);
  repeat
    blockread(f, byteBuffer1K, sizeOf(buff_1K), bytesRead);
    for index := 1 to bytesRead do
      if byteBuffer1K[index] = 10 then
        inc(lCount);
    inc(bytesProc, bytesRead);
  until bytesProc = fileSz;
  close(f);
  fLineCount := lCount + 1;
end;



{----------------------------------------------------------------------------
 procedure : fView
             Outputs the contents of file w/ANSI and screen pausing.
 ----------------------------------------------------------------------------}
procedure fView(fn : string; pageMode: boolean; min, max: integer);
  var f : text;
      s : string;
      y : integer;
begin
  lineCount := 1;
  continuousViewing := false;
  exitFlag := false;

  if pageMode = true then begin
    viewPortStartLine := min;
    viewPortEndLine   := max;
    gotoxy(1, viewPortStartLine);
    lineCount := viewPortStartLine;
  end;

  assign(f, fn);
  reset(f);
  while not EOF(f) do begin
    readln(f, s);
    sOutln(s, 0);
    if exitFlag then begin
      close(f);
      exit;
    end;
  end;

end;



{----------------------------------------------------------------------------
 procedure : fRead
             Outputs the contents of file w/ANSI.
 ----------------------------------------------------------------------------}
procedure fRead(fn: string);
  var f : text;
      s : string;
begin
  assign(f, fn);
  reset(f);
  while not EOF(f) do begin
    readln(f, s);
    sOutln(s, 0);
    if exitFlag then begin
      close(f);
      exit;
    end;
  end;
end;



{----------------------------------------------------------------------------
 procedure : fShow
             Super-duper text file reader.
 ----------------------------------------------------------------------------}
procedure fShow(

  { really important stuff }
  title          : string;     filename       : string;
  XYfilename     : string;     XYtitle        : string;

  { toggles                }
  showPath       : boolean;    showFilesize   : boolean;
  showFilename   : boolean;    showLineNum    : boolean;
  showPageNum    : boolean;    showPercent    : boolean;
  showMCIs       : boolean;

  { percentage indicator   }
  perUnfilled    : string;     perFilled      : string;
  perDigits      : string;     XYperGraph     : string;
  XYperDigits    : string;

  { line number indicator  }
  lineNumInd     : string;     lineNumCurrent : string;
  lineNumTotal   : string;     XYlineNum      : string;

  { page number indicator  }
  pageNumInd     : string;     pageNumCurrent : string;
  pageNumTotal   : string;     XYpageNum      : string;

  { viewport boundaries    }
  YtextBegin     : integer;    YtextEnd       : integer;

  { viewport colors        }
  colorFG        : string;     colorBG        : string
);


  var
    fileLineCount   : longint;    fileCurrentLine : longint;
    filePageCount   : longint;    fileCurrentPage : longint;
    fileLastPage    : integer;    filePosition    : longint;
    filePercent     : integer;    ch              : char;
    loop, count     : integer;    fileSz          : longint;
    fileNoPath      : string;     filePath        : string;
    w               : word;       f               : file;
    d               : dirstr;     n               : namestr;
    e               : extstr;     done            : boolean;
    canScrollUp     : boolean;    canScrollDown   : boolean;
    canPageUp       : boolean;    canPageDown     : boolean;
    tmpReal         : real;       s, s2, s3, s4   : string;



 { handle the errors }
 procedure errorHandler;
 begin
   sOut('|12ERROR|04: |15Opening |08(|07' + filename + '|08)|14!',0);
   halt;
 end;


 { update status displays }
 procedure drawStatus;
 begin
   fileCurrentLine := filePosition;
   fileLastPage    := fileLineCount mod viewPortHeight;
   filePercent     := mPercent(filePosition, fileLineCount);

   tmpReal := fileLineCount / viewPortHeight;
   filePageCount   := round(tmpReal);
   tmpReal := filePosition / viewPortHeight;
   fileCurrentPage := round(tmpReal);

   if showLineNum = true then begin
     sOut(XYlineNum + sRep(' ', length(lineNumInd)) + '           ', 0);
     sOut(XYlineNum + lineNumInd + lineNumCurrent +
          mLeading0(fileCurrentLine,5) + '/' + lineNumTotal +
          mLeading0(fileLineCount,5), 0
         );
   end;

   if showPageNum = true then begin
     sOut(XYpageNum + pageNumCurrent + '     '+ pageNumTotal + '    ', 0);
     sOut(XYpageNum + pageNumInd + pageNumCurrent +
          mLeading0(fileCurrentPage,4) + '/' + pageNumTotal +
          mLeading0(filePageCount,4), 0
         );
   end;

   if showPercent = true then begin
     sOut(XYperGraph, 0);
     case filePercent of
       00 .. 010: count := 1;
       11 .. 020: count := 2;
       21 .. 030: count := 3;
       31 .. 040: count := 4;
       41 .. 050: count := 5;
       51 .. 060: count := 6;
       61 .. 070: count := 7;
       71 .. 080: count := 8;
       81 .. 090: count := 9;
       91 .. 100: count := 10;
     end;
     sOut(XYperGraph + sRep(perUnfilled, 10) + XYperDigits + '    ', 0);
     sOut(XYperGraph + sRep(perFilled, count) + XYperDigits +
          i2s(filePercent) + '%', 0
         );
   end;

   sOut(ColorBG + ColorFG, 0);

 end;


 { clear the viewport }
 procedure clearWindow;
   var loop : integer;
 begin
   for loop := viewPortStartLine to viewPortEndLine do begin
     gotoxy(1, loop);
     clrEol;
   end;
   gotoxy(1, viewPortStartLine);
 end;


 { check to see if it would be ok to scroll up or down }
 procedure checkScrolling;
 begin
   if (filePosition-viewPortHeight) > 1 then canScrollUp := true
   else canScrollUp := false;

   if filePosition = fileLineCount then canScrollDown := false
   else canScrollDown := true;

   if filePosition >= fileLineCount - fileLastPage then canPageDown := false
   else canPageDown := true;

   if filePosition > viewPortHeight then canPageUp := true
   else canPageUp := false;
 end;


 { draw text in viewport }
 procedure drawWindow;
   var loop : integer;
 begin
   for loop := viewPortStartLine to viewPortEndLine do begin
     if not Text_EOF then begin
        gotoxy(1, loop);
        text_readline(s);
        if showMCIs then sOutln(s, 0)
        else writeln(s);
     end;
   end;
 end;


 { move viewport to beginning of file }
 procedure moveHome;
 begin
   if not canScrollUp then exit
   else begin
     text_reset;
     filePosition := viewPortHeight;
     clearWindow;
     drawWindow;
     drawStatus;
     checkScrolling;
   end;
 end;


 { move viewport up a page}
 procedure moveUpPage;
   var loop : integer;
 begin
   if not canPageUp then exit
   else begin
     clearWindow;
     if filePosition > viewPortHeight then filePosition := filePosition - viewPortHeight*2
     else filePosition := 1;
     text_goback(filePosition);
     drawWindow;
     drawStatus;
     checkScrolling;
   end;
 end;


 { move viewport up 1 line }
 procedure moveUpLine;
 begin
   if not canScrollUp then exit
   else begin
     text_goback(filePosition);
     clearWindow;
     drawWindow;
     drawStatus;
     checkScrolling;
   end;
 end;


 { move viewport to end of file }
 procedure moveEnd;
   var loop : integer;
 begin
   if not canPageDown then exit
   else begin
     clearWindow;
     sOut(XYperGraph + 'WORKING...    ',0);
     for loop := filePosition to (fileLineCount - viewPortHeight) do begin
        if not Text_EOF then text_readline(s)
     end;
     filePosition := fileLineCount;
     drawStatus;
     drawWindow;
     checkScrolling;
   end;
 end;


 { move viewport down a page}
 procedure moveDownPage;
   var loop : integer;
 begin
   if not canPageDown then exit
   else begin
     clearWindow;
     drawWindow;
     drawStatus;
     filePosition := filePosition + viewPortHeight;
     checkScrolling;
   end;
 end;


 { move viewport down a line}
 procedure moveDownLine;
 begin
   if not canScrollDown then exit
   else begin
     w := viewPortEndLine - viewPortStartline;
     text_goback(w);
     filePosition := filePosition + 1;
     clearWindow;
     drawWindow;
     drawStatus;
     checkScrolling;
   end;
 end;


 { initialize show }
 procedure initShow;
 begin
   filePosition      := 0;
   fileLineCount     := 0;
   filePageCount     := 0;
   fileCurrentLine   := 0;
   fileCurrentPage   := 0;
   fileLastPage      := 0;
   continuousViewing := true;
   exitFlag          := false;
   viewPortStartLine := YtextBegin;
   viewPortEndLine   := YtextEnd;
   viewPortHeight    := viewPortEndLine - viewPortStartLine;
   lineCount         := viewPortStartLine;
   done              := false;

   gotoxy(1, viewPortStartLine);
   fileLineCount := fLineCount(d + n + e);
   filePosition := viewPortHeight;
   canScrollUp := true;
   drawStatus;
   moveHome;
 end;



 { initialize the display and status }
 procedure setupShow;
 begin
   s := XYfilename; s2 := XYlineNum; s3 := XYpageNum; s4 := XYperGraph;
   if showPath = true then s := s + filePath;
   if showFileName = true then s := s + fileNoPath;
   if showFilesize = true then s := s + ' (' + i2s(fileSz) + ')';
   if showLineNum = true then begin
     s2 := s2 + lineNumInd;
     s2 := s2 + lineNumCurrent;
     s2 := s2 + lineNumTotal;
   end;
   if showPageNum = true then begin
     s3 := s3 + pageNumInd;
     s3 := s3 + pageNumCurrent;
     s3 := s3 + pageNumTotal;
   end;
   if showPercent = true then begin
     s4 := s4 + XYperGraph;
     s4 := s4 + sRep(perUnfilled, 10);
     s4 := s4 + XYperDigits;
     s4 := s4 + sPadL(perDigits + '0%',' ', 3);
   end;
   sout(s, 80);
   sout(s2, 80);
   sout(s3, 80);
   sout(s4, 80);
   s := XYtitle;
   s := s + title;
   sout(s, 80);
 end;


 { start showing the file }
 procedure startShow;
 begin
   repeat
     while done = false do begin
       ch := readkey;
       if ch = nullKey then ch := readkey;
       case ord(ch) of
         dnArrow    : moveDownLine;
         upArrow    : moveUpLine;
         pgUp       : moveUpPage;
         pgDn       : moveDownPage;
         homeKey    : moveHome;
         endKey     : moveEnd;
       else
         case ch of
           ctrlR    : moveUpPage;
           ctrlC    : moveDownPage;
           'Q', 'q' : done := true;
           'D', 'd' :
         end;
       end;
     end;
   until done = true;
  exit;
 end;


begin
  { initialize variables }
  ch := nullKey; s := ''; s2 := ''; s3 := ''; loop := 0; w := 0;

  { setup the file }
  fsplit(filename, d, n, e);
  filePath   := d;
  fileNoPath := n + e;
  text_reset;
  text_load(d + n + e);
  if IOresult <> 0 then errorHandler;
  fileSz := fFileSize(d + n + e);
  setupShow;
  initShow;
  startShow;
  text_dispose;
end;








{============================================================================



 MAIN PROGRAM



 ============================================================================}

 var
   s1 : string;

begin
{----------------------------------------------------------------------------
 Initialize the Windows Clip Board.
 ----------------------------------------------------------------------------}
 GetMem(clipBoard, 65528);

{----------------------------------------------------------------------------
 Initialize the Windows Clip Board.
 ----------------------------------------------------------------------------}
 dInitCursor;

{----------------------------------------------------------------------------
 Initialize the ANSI parser.
 ----------------------------------------------------------------------------}
  ANSI_St:='';
  ANSI_SCPL:=-1;
  ANSI_SCPC:=-1;
  ANSI_FG:=7;
  ANSI_BG:=0;
  ANSI_C:=False;
  ANSI_I:=False;
  ANSI_B:=False;
  ANSI_R:=False;

{----------------------------------------------------------------------------
 Initialize the Exit flag.
 ----------------------------------------------------------------------------}
 exitFlag := false;



{----------------------------------------------------------------------------
 DEMONSTRATION CODE
 ----------------------------------------------------------------------------}
  s1 := '';

  clrScr;

  clrScr;

  sOut('|[Y01|[X01|03‹‹‹‹‹‹‹‹‹‹‹‹‹|08ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ', 0);
  sOut('|[Y02|[X62|08≥', 0);
  sOut('|[Y03|[X01|03ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ|08ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ', 0);
  sOut('|[Y22|[X01|08ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ', 0);
  sOut('|[Y23|[X47|08≥', 0);
  sOut('|[Y23|[X04|11|03/|11 |15Line   |11^R|03/|11^C |15Page   |11D|15ownload   |11Q|15uit', 0);
  sOut('|[Y24|[X01|08ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ', 0);

  fShow('|19|11 HOW TO PLAY |16', 'C:\TMP.TXT'     , '|[Y02|[X15|15', '|[Y02|[X01',
        true, true, true, true, true, true, true,
        '|08∞', '|07≤',  '|09',  '|[Y02|[X64', '|[Y02|[X75|09',
        '|08LN#:      ', '|08|[X54',  '|08|[X60', '|[Y23|[X49',
        '|08PG#:    ',   '|08|[X71',  '|08|[X76', '|[Y23|[X66',
        4, 21,
        '|07',   '|16');

  sOut('|[Y01|[X01|03‹‹‹‹‹‹‹‹‹‹‹‹‹|08ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ', 0);
  sOut('|[Y02|[X62|08≥', 0);
  sOut('|[Y03|[X01|03ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ|08ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ', 0);
  sOut('|[Y22|[X01|08ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ', 0);
  sOut('|[Y23|[X47|08≥', 0);
  sOut('|[Y23|[X04|11|03/|11 |15Line   |11^R|03/|11^C |15Page   |11D|15ownload   |11Q|15uit', 0);
  sOut('|[Y24|[X01|08ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ', 0);

  fShow('|19|11 HOW TO PLAY |16', 'C:\MYSTIC\MYSTIC.DOC', '|[Y02|[X15|15', '|[Y02|[X01',
        true, true, true, true, true, true, false,
        '|08∞', '|07≤',  '|09',  '|[Y02|[X64', '|[Y02|[X75|09',
        '|08LN#:      ', '|08|[X54',  '|08|[X60', '|[Y23|[X49',
        '|08PG#:    ',   '|08|[X71',  '|08|[X76', '|[Y23|[X66',
        4, 21,
        '|07',   '|16');



  exit;

  viewPortStartLine := 1;
  viewPortEndLine := 24;
  fView('C:\MYSTIC\TEXT\MCHATI.ANS', true, 1, 24);
  readln;

  fView('C:\AUTOEXEC.BAT', true, 1, 24); readln;
  fView('C:\MCHAT.DOC', true, 1, 24);
  exit;

  dWinClipBoard(1, '');
  sOutln('Ok.. test this. Home, End, LeftArrow, RightArrow, Delete, Backspace',80);
  sOutln('CTRL-V = Paste windows clipboard, CTRL-Y = Yank line...',80);
  sOutln('Clear the line before you paste cuz it is limited input chars ;)',80);
  writeln;
  sOut('Enter something cool: |17|11', 80);
  s1 := iInput(40, 200, 'something really really really real cool');
  sWriteln('|16|07');
  sOut(s1 + i2s(length(s1)), 80);
  readln;
  exit;

  writeln('let me know if this is actually 10 seconds!');
  writeln(formatDT('h:n:s.$?'));
  writeln('Sleeping for 10 seconds');
  iSleep(10);
  writeln(formatDT('h:n:s.$?'));
  writeln('Napping for half a second');
  iNap(5);
  writeln(formatDT('h:n:s.$?'));
  exit;


  writeln('clipboard has this on it:');
  dWinClipBoard(1, '');
  readln;
  writeln('clearing the clipboard...');
  dWinClipBoard(0, '');
  readln;
  writeln('should be clear no? =]');
  dWinClipBoard(1, '');
  readln;
  writeln('stuffing the clipboard with "this is a test"');
  dWinClipBoard(2, 'this is a test');
  readln;
  writeln('clipboard has this on it:');
  dWinClipBoard(1, '');
  readln;
  iStuffBuff('this is a testewochiwoiecjoisajcoihwevoihweoichoiwecjhoiec' + #13);
  s1 := iInput(79, 250, 'something really really really real cool');
  writeln;
  writeln;
  write('|' + s1 + '|');
  readln;
  writeln(i2s(mRom2Dec('DCCXXII')));
  writeln(mDec2Rom(722));
  readln;
  dInitCursor;
  sOut('The cursor is on and a line.', 80);
  readln;
  dSetCursorForm(cuBlock);
  sOut('The cursor is on and a block.', 80);
  readln;
  dSetCursorForm(cuHalf);
  sOut('The cursor is on and a half block.', 80);
  readln;
  dSetCursorForm(cuNone);
  sOut('The cursor is off.', 80);
  readln;
  dCursorOn;
  sOut('The cursor is on.', 80);
  readln;
  sOut('|07[|15GJTK |07V|08:|151|07.|150|07]|08|@D68-', 80);
  sOut('', 80);
  sOutln('|15|@C80Welcome!', 80);
  sOut('', 80);
  sOut('|07This program is a demonstration of the various procedures and functions that are in the',80);
  sOut('|15GJTK |07(GrymmJacks Tool Kit). The reason that the kit was created was because I, grymmjack,',80);
  sOut('needed something that was flexible enough and versatile enough for a wide variety of programming',80);
  sOut('needs. And, although there are several libraries out there, most of them did not meet this criteria.',80);
  sOut('So what I''ve done is written/ported/taken all of the code that I wanted or liked in other languges',80);
  sOut('such as MPL, JavaScript, BASIC, etc. and put it in one handy Turbo Pascal Unit. So all that I have to',80);
  sOut('do to get to my goodies is declare a USES GJTK; at the top of every program that I wish to write. ',80);
  sOut('Most of the code in the kit is original, but some of it was imported from SWAG or from other toolkits.',80);
  sOut('So that''s the reason all of this stuff was created. Hope you enjoy the toolkit as much as I enjoy it',80);
  sOut('myself.  One day it could become a leaner and faster more robust solution to all of your Turbo Pascal',80);
  sOut('programming endeavors. Thanks for checking it out...', 80);
  readln;
  clrScr;
  sOut('the rest of the demo is slopsville.. hit enter if it just sits there for a while.', 80);
  writeln('let me know if this is actually 10 seconds!');
  writeln(formatDT('h:n:s.$?'));
  writeln('Sleeping for 10 seconds');
  iSleep(10);
  writeln(formatDT('h:n:s.$?'));
  writeln('Napping for half a second');
  iNap(5);
  writeln(formatDT('h:n:s.$?'));
  sOut('|[X40This should be on column 40.|CR|[Y20and line 20|CR|[A10and line 10|CR|[C30Overhere|[D25HI|@D40-', 80);
  readln;
  sOut('This is a test|CRTesting 1234|CRTESTING PIPE: |PI |CRTESTING PAUSE|PA', 80);
  readln;
  clrScr;
  sOut('|@C80This is in the middle.', 80);
  readln;
  sWriteln('|                         testing 1234 |15test                |');
  sWriteln('|' + sStripR('                         testing 1234 |15test                ') + '|');
  sWriteln('|                         testing 1234 |15test                |');
  sWriteln('|' + sStripL('                         testing 1234 |15test                ') + '|');
  sWriteln(sStrip('|CR|PA|PI | |PA |PI |CR |18|00grymmjack||| | |PI|15|07|17|16|03test'));
  sWriteln(sStripCodes('|CR|PA|PI | |PA |PI |CR |18|00grymmjack||| | |PI|15|07|17|16|03test'));
  readln;
  fView('C:\AUTOEXEC.BAT', true, 1, 24); readln;
  fView('C:\MCHAT.DOC', true, 1, 24);
  writeln('Sleeping for 3 seconds...');
  iSleep(3);
  writeln('yawn!');
  sWrite('Enter something cool: |17|11');
  s1 := iInput(30, 60, 'something really really really real cool');
  sWriteln('|16|07');
  writeln(s1 + i2s(length(s1)));
  readln;
  writeln('|' + sGetWord('testing the get word function', ' ', 1) + '|');
  readln;
  writeln('|' + sRight('testing the right string function', 8) + '|');
  readln;
  writeln('|' + sLeft('testing the left string function', 7) + '|');
  readln;
  writeln('|' + sMid('testing strMid', 9, 6) + '|');
  readln;
  sWriteln(sCenter('|07this |15string is center |10justified|07', 80));
  readln;
  writeln(sLeftJ('this string is left justified'));
  readln;
  writeln(sRightJ('this string is right justified'));
  readln;
  writeln(sPadR('to the right', '.', 20));
  readln;
  writeln(sPadL('to the left', '.', 40));
  readln;
  s1 := 'the number of words in this sentence is: ';
  writeln(s1 + ' ' + i2s(sWordCount(s1, ' ')));
  readln;
  writeln(formatDT('m/d/y @ h:n:s.$?'));
  readln;
  writeln(sRep('-', 40) + i2s(length(sRep('-', 40))));
  sWriteln('|07|08|09 |10 |11 |12 |15grymmjack|15|07|17|16|03test');
  writeln('');
  sWriteln('|07line above');
  sWriteln('|08line below');
  write('hi!');
  readln;
  sWriteln('|15220 |07is |14' + i2s(mPercent(220, 16040)) + '|03% |07out of 100% |07of |1516040|07.|08.');
  readln;
  sWriteln('|15these |14numbers |13are |12random |11: ' + i2s(mRandom(1, 100)) + ',' + i2s(mRandom(1,3)));
  readln;
  write('askY(Y/n): ');
  if iAskY then writeln ('Yes!')
  else writeln('No!');
  write('askN(y/N): ');
  if iAskN then writeln ('No!')
  else writeln('Yes!');
  readln;

{$IFNDEF LINUX}
  dSetCursorForm(cuNone);
  writeln('The cursor is off..');
  readln;
  dSetCursorForm(cuLine);
  writeln('But now it''s back!');
  readln;

  dSaveScreen;
  clrscr;
  writeln('DOHT ALL GONE!.. MAYBE WE CAN GET IT BACK...');
  readln;
  dLoadScreen;
  readln;

  dGetPal;
  dFade(0, 50);
  dFade(1, 50);
  readln;
{$ENDIF}

  writeln('paused');
  iPause;
  writeln('Sleeping for 3 seconds...');
  iSleep(3);
  writeln('yawn!');
  readln;
end.

