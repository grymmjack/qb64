10 REM DATASTORE MANUAL
20 REM Written by A.Sill
30 REM FOR WROX PRESS
40 REM (c) 1992
50 REM
60 RAND = 0
70 PRINT "Since this was made, all references to shareware software are obsolete and all  rights are the same as the rest of the software on this disk (THE BASIC ARRAY)."
80 WHILE INKEY$ = "": WEND
90 SCREEN 9: CLS
100 A$ = "DATASTORE MANUAL": GOSUB 1710
110 COLOR 2: LOCATE 5, 1: PRINT "Requirements"
120 COLOR 10: LOCATE 6, 1: PRINT "------------"
130 PRINT
140 COLOR 2: PRINT "   IBM PC Compatible."
150 PRINT "   GWBASIC, BASICA, QBASIC or a similar compatible version of BASIC."
160 PRINT "   A Colour monitor is preferable but not necessary."
170 PRINT : COLOR 2: PRINT "Author"
180 COLOR 10: PRINT "------"
190 COLOR 2
200 PRINT : PRINT "   Adrian Sill    of"
210 PRINT "                      19 Sherwood Drive,"
220 PRINT "                      Skellow,"
230 PRINT "                      Doncaster,"
240 PRINT "                      DN6 8NY."
250 GOSUB 1640
260 A$ = "INTRODUCTION": GOSUB 1710
270 COLOR 2: LOCATE 5, 1: PRINT "Package"
280 COLOR 10: PRINT "-------"
290 PRINT
300 COLOR 2: PRINT "   Datastore is part of THE BASIC ARRAY shareware compilation, written by the   author. Registration must be via the whole package."
310 PRINT : PRINT "Datastore Introduction"
320 COLOR 10: PRINT "----------------------"
330 PRINT : COLOR 2
340 PRINT "     The program is all menu driven, from one main menu and is fairly self      explanatory for those with any database experience. If you haven't used one"
350 PRINT "at all before, please read the next section titled 'The General Idea'.               This is a BASIC shareware program, and not a commercial program, so bear"
360 PRINT "this in mind please. It was written to bring credibility to a much criticized   language, despite being hampered by the restrictions of the language."
370 PRINT "     Admittedly, it doesn't have the power, speed or the flexibility of other   databases, but it is competent and usable."
380 GOSUB 1640
390 A$ = "THE GENERAL IDEA": GOSUB 1710
400 COLOR 2: LOCATE 5, 1: PRINT "     A database stores lots of similar data or information, in fact it is the   direct computer equivalent of a filing cabinet. A database lets you create a"
410 PRINT "file for whatever requirement you need, whether it be an address book, club     membership file, or a file of cooking recipes. Each database file you create"
420 PRINT "MUST consist of two things. First the fields, i.e. the headings of the data you wish to put in the file, such as NAME, ADDRESS, AGE etc. Second is the data."
430 PRINT "The data will be directly related to the fields. A record is an individual      'card' containing the data. Consider the following record :"
440 COLOR 10
450 PRINT : PRINT "    Record 7              NAME : Joe Public"
460       PRINT "                       ADDRESS : 1 High Street, LONDON"
470       PRINT "                           AGE : 40"
480 COLOR 2: PRINT : PRINT "     Each record is given a number (i.e. 7), and each record in the file has thesame fields (i.e. NAME, ADDRESS and AGE in this case). Each record has it's own"
490 PRINT "data as well (Joe Public, 40 etc.)"
500 GOSUB 1640
510 A$ = "ABOUT DATASTORE": GOSUB 1710
520 COLOR 2: LOCATE 5, 1: PRINT "     Datastore is based around the following main menu, consisting of several   different functions :"
530 COLOR 10: PRINT : PRINT "               1. Create a new database"
540 PRINT "               2. Insert data into the current database"
550 PRINT "               3. Browse and edit the current database"
560 PRINT "               4. Search the current database for data"
570 PRINT "               5. Change database name or fields"
580 PRINT "               6. Sort the database"
590 PRINT "               7. Load a previous database"
600 PRINT "               8. Save current database"
610 PRINT "               9. Quit program"
620 COLOR 2: PRINT : PRINT "     The UP and DOWN arrow keys will move a white pointer through the options,  and a single press of the ENTER or RETURN key, will select the highlighted item.";
630 PRINT "     There are at some stages of the program times when some of the options are unavailable to you, these are blanked out and cannot be accessed until some     further action is taken."
640 GOSUB 1640
650 A$ = "DEFINITIONS": GOSUB 1710
660 COLOR 2: LOCATE 5, 1: PRINT "     Before we begin looking at the various functions of DATASTORE, I would liketo make some clear definitions of the terms used, in respect to it's manual"
670 PRINT "equivalent - the filing cabinet."
680 COLOR 10: PRINT
690 PRINT "        DATABASE"; : COLOR 2: PRINT " : The whole filing cabinet"
700 COLOR 10: PRINT "        FILE    "; : COLOR 2: PRINT " : The whole filing cabinet or a whole section"
710 COLOR 10: PRINT "        FIELDS  "; : COLOR 2: PRINT " : The headings on the cards in the filing cabinet"
720 COLOR 10: PRINT "        RECORDS "; : COLOR 2: PRINT " : The individual cards in the filing cabinet"
730 COLOR 10: PRINT "        DATA    "; : COLOR 2: PRINT " : The information on the cards"
740 PRINT
750 PRINT "     You may wish to write this down or obtain a printout (Press PrintScreen),  if you are unsure about these terms."
760 GOSUB 1640
770 A$ = "CREATE A NEW DATABASE": GOSUB 1710
780 COLOR 2: LOCATE 5, 1: PRINT "    If you already have a database in memory, then completing this option from  the menu will erase the current database. So, you will be asked whether you are"
790 PRINT "sure you want to do this. Just return Y or N (Yes or No) in answer to this."
800 PRINT "     Before you can start filling your filing cabinet with cards, you must work out what the filing cabinet is going to be called and what headings you want to"
810 PRINT "have on the cards."
820 PRINT "    So, the first task is in naming the filing cabinet. Don't make the name too long though, but make it something you can recognise it with. It isn't necessary";
830 PRINT "for you to memorise this name since it is only used as a heading and a reminder.";
840 PRINT "    The next bit requires some planning - as it asks you how many fields you    want in the database. Be careful, because this cannot be changed once it has"
850 PRINT "been confirmed. Too many fields will slow DATASTORE down if there's going to be lots of records, so we have a maximum of eleven fields."
860 GOSUB 1640
870 A$ = "CREATE A NEW DATABASE (CONT.)": GOSUB 1710
880 LOCATE 5, 1: COLOR 2: PRINT "     After this, you have to enter all the fields' names in the order that you  want them to appear in. For example, you 'normally' wouldn't place a NAME field"
890 PRINT "after an ADDRESS or an AGE field because it looks better with the name at the   top of a page."
900 PRINT "     We also have to tell the computer whether you intend each field to be      either numerical or alpha-numerical in content. For example, a NAME field would need to be alpha-numerical - but an AGE field would need to be numerical."
910 PRINT "     Once this has been completed, you have a fully working database, just      waiting for you to add some records to it."
920 PRINT "     At the moment, if we regard it as a filing cabinet, it is full of blank    cards, just itching to be filled in. We should now enter some records into it,  so we now should choose the next item on the main menu INSERT DATA INTO THE"
930 PRINT "CURRENT DATABASE."
940 PRINT "     Remember, an empty filing cabinet is no good to anybody, the records/cards are the most important part of the database."
950 GOSUB 1640
960 A$ = "INSERT DATA INTO THE DATABASE": GOSUB 1710
970 LOCATE 5, 1: COLOR 2: PRINT "     Now you want to fill in the cards in your filing cabinet (or records in    your database). When you select this option from the main menu, you must enter"
980 PRINT "the data of a record, one field at a time, pressing RETURN or ENTER after each  entry. Once a record has been filled, you will be given a choice of whether to"
990 PRINT "go back to the main menu, discard it, or do another one. Discard the record, andthe program will erase it and give you a record to fill again. Going back to the";
1000 PRINT "main menu gives you a chance to use some of the other options whilst ALWAYS     being able to add some more later. Hitting RETURN or ENTER however (accepting   the record) will store it away and give you another blank record to fill in."
1010 PRINT "     If, when you are at the main menu, you wish to add some more records to theones you have already got, choosing this second option is the way to do it. You"
1020 PRINT "will automatically be given the next blank record/card to enter more details    into."
1030 GOSUB 1640
1040 A$ = "BROWSE AND EDIT THE CURRENT DATABASE": GOSUB 1710
1050 COLOR 2: LOCATE 5, 1: PRINT "     This is an option to view the records which have already been entered into the database. That is basically what this section does - browse through the"
1060 PRINT "records one at a time. When you pick it, it will start by showing you the first record, and below it is a command list. This command list shows you what you cando in this browse mode."
1070 PRINT "     To scroll through the records then, we use the 'N' key to see the 'N'ext   record, and the 'L' key to see the 'L'ast record. Hitting the 'M' key will take you back to the main 'M'enu and depressing the 'G' key will let you type in the"
1080 PRINT "number of the record you wish to 'G'o to. This latter utility is particularly   useful if there are a lot of records, as pressing 'N' a lot of times is very    tedious work. So once you have typed the number of the record you wish to go to"
1090 PRINT "you will straight away have it displayed in browse mode."
1100 PRINT "     There are numerous occasions as well, where the data you enter into a      record is later found to be incorrect. To alleviate the errors we have the      services of two commands, the EDIT and the DELETE options."
1110 GOSUB 1640
1120 A$ = "BROWSE AND EDIT THE CURRENT DATABASE (CONT.)": GOSUB 1710
1130 COLOR 2: LOCATE 5, 1: PRINT "     Delete is accessed by pressing the 'D' key, where you will be asked whetheryou are sure - just in case you hit it by accident. Confirming this, the whole  record is erased from memory FOREVER."
1140 PRINT "     Pressurising the 'E' for edit key, provides you with a chance to amend     individual bits of data without deleting the whole record. You will be guided   through each field of the record, and are able to amend, add or delete any of"
1150 PRINT "the data in them. Simply press RETURN if a field is o.k. and re-type the data ifit isn't."
1160 PRINT "     One last option is the one to print out a record, this will send the recordviewed currently on the screen, to the printer. See the notes on THE BASIC ARRAYmain menu for printer compatibility."
1170 PRINT : PRINT "     It isn't necessary to remember the keypresses, as they are shown on the    browse mode screen."
1180 GOSUB 1640
1190 A$ = "SEARCH THE CURRENT DATABASE FOR DATA": GOSUB 1710
1200 COLOR 2: LOCATE 5, 1: PRINT "     What do you do when you want to find a certain card in a filing cabinet ?  You have to search for it manually one-by-one. So, since the computer is "
1210 PRINT "particularly adept at handling data, we have a built in option for finding bits of wanted data."
1220 PRINT "     From now on we will call the data that we are trying to find the SEARCH    DATA. Before you go ahead and search the database, you must choose the method ofsearch you want. Methods of search ? Yes, we have the option of using THREE"
1230 PRINT "different searches.                                                                  The first search is the '=' search, where the program searches through all the fields of the database looking for an exact match to the SEARCH DATA. The"
1240 PRINT "second and third searches are the 'smaller than' and the 'greater than' or the  '<' and '>' searches. These are simply the same as the '=' search except that   they are looking for all data to be less than or greater than the SEARCH DATA,"
1250 PRINT "respectively. Both of these only work on one field at a time, and they both workirrespective of the fields contents i.e. searches can be done on both numeric   and alphabetic fields."
1260 GOSUB 1640
1270 A$ = "SEARCH THE CURRENT DATABASE FOR DATA (CONT.)": GOSUB 1710
1280 COLOR 2: LOCATE 5, 1: PRINT "     When you have selected which type of search you want, you must first enter the search data. Then, if the search selected was the straight '=' search the"
1290 PRINT "program will proceed to scan the database for the search data. If you choose the'<' search or the '>' search, then you will be then asked to enter the field"
1300 PRINT "number to search in."
1310 PRINT "     Once all this has been done, DATASTORE will then show you how many times   the search found your data. Then you are placed in a browse mode, similar to"
1320 PRINT "option three on the main menu."
1330 PRINT "     There is also an option afterwards to print out all the records where the  data was found, to the printer - it's all very straight forward and like the    other sections of this program."
1340 GOSUB 1640
1350 A$ = "CHANGE DATABASE NAMES OR FIELDS": GOSUB 1710
1360 COLOR 2: LOCATE 5, 1: PRINT "     This is a straight forward option, which lets you have the opportunity to  change some of the fixed items names. First off, you are asked whether you wish"
1370 PRINT "to change the name of the database, a simple Y or N for Yes or No will suffice. If yes then you are prompted for the replacement name."
1380 PRINT "     After this we are asked if we would liek to amend the field names. A simpleY or N will again answer this question. If so, you are asked to type in the     field names once more. If not you are returned to the main menu."
1390 PRINT "     If your database was planned thoroughly this option should never be used.  However, it is often easier with hindsight and this option is able to satisfy   any omissions made originally. For example, if we had a field called ARE, which"
1400 PRINT "seems sufficient when initiating the database, but when we begin to enter       records we might feel it should read AREA (SQ.KM.) instead to be more precise."
1410 GOSUB 1640
1420 A$ = "SORT DATABASE": GOSUB 1710
1430 COLOR 2: LOCATE 5, 1: PRINT "     There are many instances when records are required in an ordered way,      whether it be in NAME order, COST order, AGE order or TOWN order. This option"
1440 PRINT "sorts a whole database into order depending on ONE fields contents. The field   could be any of those mentioned above, or indeed ANY field in your database."
1450 PRINT "     This sort actually PHYSICALLY moves the records i.e. it exactly copies a   would be manual filing cabinet sorting routine. Can you imagine sorting a filingcabinet by hand, it isn't a pretty thought. This sort is not the fastest, but it";
1460 PRINT "does the job in hand. With hundreds of records, the sort may in fact take a     couple of miutes so patience is required for those large files, like the ATLAS  database file."
1470 PRINT "     Also, the routine nestled in the DATASTORE program is fully transferable   and can be easily used in your own programs."
1480 GOSUB 1640
1490 A$ = "LOAD A PREVIOUS DATABASE": GOSUB 1710
1500 COLOR 2: LOCATE 5, 1: PRINT "     This option allows you to load a database file you have created and saved  before with DATASTORE into memory. The file MUST have been created with"
1510 PRINT "DATASTORE previously."
1520 PRINT "     If you are using another database file when you choose this option, then   you will be questioned as to whether you are sure you want to do this. This is  necessary because the loading of another file would IMMEDIATELY erase the former";
1530 PRINT "file. Otherwise, just type in the name of the database file and it will be      loaded within a few seconds. You will then be returned back to the main menu."
1540 GOSUB 1640
1550 A$ = "SAVE CURRENT DATABASE": GOSUB 1710
1560 COLOR 2: LOCATE 5, 1: PRINT "     This option lets you store the database in which you are working to a disk.It has several advantages : 1. It saves you re-typing the whole lot in again the";
1570 PRINT "the next time you require to use it. 2. It helps in case of a computer crash or a power failure - all your data is safely stored to the disk in such an event."
1580 PRINT "     You will be asked for a filename, this should be something you will be ableto remember it by when it comes to loading it back in. It should not exceed 8   (eight) characters in length. It is stored in an ASCII format which is easily"
1590 PRINT "compatible with your word processor if you wish."
1600 PRINT "     You will be returned to the main menu once it has been saved, and please   make sure you enter the correct path on the saving as with the loading."
1610 GOSUB 1640
1620 GOTO 1760
1630 REM SUB ROUTINE TO PRESS A KEY **********
1640 LOCATE 24, 33: COLOR 12: PRINT "Press any key";
1650 A$ = ""
1660 A$ = INKEY$: RAND = RAND + .1: IF A$ = "" THEN 1660
1670 RAND = RAND - VAL(RIGHT$(TIME$, 2))
1680 RANDOMIZE RAND
1690 RETURN
1700 REM SUB ROUTINE TO GIVE HEADING **********
1710 COLOR 14
1720 CLS
1730 LOCATE 2, (80 - LEN(A$)) / 2
1740 PRINT A$
1750 RETURN
1760 REM ********* RETURN TO MENU POSER
1770 CLS
1780 COLOR 12: PRINT : PRINT : PRINT "          Do you want to 1. Run again or": PRINT "                         2. Return to menu or": PRINT "                         3. Return to DOS ?."
1790 LOCATE 3, 26: COLOR 7: PRINT "1"
1800 LOCATE 4, 26: PRINT "2"
1810 LOCATE 5, 26: PRINT "3"
1820 A$ = INKEY$: IF A$ = "" THEN GOTO 1820
1830 IF A$ = "1" THEN CLEAR : RUN
1840 IF A$ = "2" THEN RUN "MENU-SH"
1850 IF A$ = "3" THEN CLS : SYSTEM
1860 GOTO 1820

