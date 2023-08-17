'*********** CHAP2-2.BAS - shows how to find a far string from its descriptor

'Copyright (c) 1992 Ethan Winer

DEF FNPeekWord& (A&)
  FNPeekWord& = PEEK(A&) + 256& * PEEK(A& + 1)
END DEF

Work$ = "This is a test"

DescAddr& = VARPTR(Work$)
AddressPtr& = FNPeekWord&(DescAddr&)
SegmentPtr& = FNPeekWord&(DescAddr& + 2)
Segment& = FNPeekWord&(SegmentPtr&)

DEF SEG = Segment&
DataAddr& = FNPeekWord&(AddressPtr&)
Length% = FNPeekWord&(DataAddr&)
StrAddr& = DataAddr& + 2

PRINT "The descriptor address is:"; DescAddr&
PRINT "      The data segment is:"; Segment&
PRINT "            The length is:"; Length%
PRINT "The string data starts at:"; StrAddr&
PRINT "   And the string data is: ";

FOR X& = StrAddr& TO StrAddr& + Length% - 1
  PRINT CHR$(PEEK(X&));
NEXT
