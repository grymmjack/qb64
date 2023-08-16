'*********************************************************************
'_|_|_|   SUBTUTOR.BAS - A short tutorial on SUB and FUNCTION usage
'_|_|_|   ============
'_|_|_|   No warrantee or guarantee is given or implied.
'_|_|_|   Tutorial ueber das Anwenden von SUBs und FUNCTIONs
'         Released   PUBLIC DOMAIN   by Kurt Kuzba.  (10/6/96)
'*********************************************************************
DECLARE SUB MySub (p$)
DECLARE SUB MyShare ()
DECLARE SUB Fixed (p$)
DECLARE FUNCTION MyFunc$ (p$)
'
COLOR 15, 1: CLS
PRINT " This is a short tutorial on use of SUB and FUNCTION in QBasic"
PRINT " and Quick Basic. It explores some of the relationships of"
PRINT " variables between modules. By studying the code and following"
PRINT " with the text, one may grasp module concepts."
PRINT " Variables in a SUB or FUNCTION, unless declared as STATIC,"
PRINT " are AUTOMATIC variables. BASIC initializes them every time"
PRINT " the module containing them is called. They may have the same"
PRINT " name as variables in other modules without confusion."
PRINT " SHARED and PASSED variables will be examined. Ready?"
DO: LOOP WHILE INKEY$ = "": CLS
PRINT " We will begin with the SUB. Variables may be passed by SEG or"
PRINT " or by VAL. Variables enclosed in parentheses are passed by VALue."
PRINT " FUNCTION variables must be enclosed in a group parentheses, and"
PRINT " we may also use VAL parentheses. First, we will pass by VALue."
PRINT : MyStr$ = "This won't be changed.": MySub (MyStr$)
PRINT " MyStr$ = "; MyStr$: PRINT
PRINT " As you can see, MyStr$ is unchanged"
DO: LOOP WHILE INKEY$ = "": CLS
PRINT " Now we will pass by SEGment.": PRINT
MyStr$ = "This will be changed."
MySub MyStr$: PRINT " MyStr$ = "; MyStr$: PRINT
PRINT " Since the ADDRESS of MyStr$ was passed, the SUB was"
PRINT " able to change the contents of the variable."
DO: LOOP WHILE INKEY$ = "": CLS
PRINT " Now we will use a FUNCTION and pass by VALue.": PRINT
MyStr$ = "This won't be changed.": FuncStr$ = MyFunc((Myelt und hinter dem
'      "z" eingeordnet
'    - Gro·buchstaben werden vor den Kleinbuchstaben eingeordnet.
' - Erster Sortierlauf:
'    - Das zu sortierende Feld wird zunÑchst in zwei HÑlften geteilt.
'    - Alle Elemente der oberen HÑlfte werden - von oben beginnend - mit dem
'      Mittelelement verglichen. Ebenso werden alle Elemente der unteren
'      HÑlfte - von unten beginnend - mit dem Mittelfeld verglichen.
'    - Ist ein oberes Feldelement grî·er als das Mittelelement und ein unteres
'      Feldelement kleiner als das mittelelement, so werden unteres und oberes
'    - Feldelement miteinander vertauscht.
'    - Hat der Vergleichslauf das Mittelelement erreicht, so sind in der unte-
'      ren HÑlfte des Feldes alle Elemente versammelt, die >= dem Mittelele-
'      ment sind. In der oberen HÑlfte tummeln sich alle anderen (grî·eren)
'      Elemente.
' - Weitere SortierlÑufe:
'    - Damit ist der Sortiervorgang noch nicht beendet, denn jetzt haben wir
'      zwei jeweils ungeordnete Teilfelder, die nach dem gleichen Prinzip
'      durchgeackert werden mÅssen wie vorher das Gesamtfeld. Und ist das
'      Åberstanden, so warten schon vier Felder auf ihre "Bestellung". Dieser
'      Zerlegungsproze· geht solange weiter bis kein Teilfeld aus mehr als
'      einem Element besteht!
'    - Die Zerlegung der Teilfelder erfolgt durch rekursive Aufrufe der
'      Subroutine, d.h. die Subroutine ruft sich selbst fortwÑhrend auf.
'    - Hierbei ist zu beachten, da· bei jedem Selbstaufruf die RÅcksprunga-
'      dresse und die lokalen Variablen auf den Stack abgeleget und neue
'      Kopien (Instanzen) der lokalen Variablen angelegt werden.
'      Nach einem RÅcksprung aus einem rekursiv angesprungenem Subroutinen-
'      -Durchlauf werden die alten Lokalvariablen wieder restauriert.
'    - Bei rekursiven Subroutinen ist eine eindeutige Abbruchbedingung essenti-
'      ell. Bei der QuickSort ist diese dadurch gegeben, da· der Sortier-
'      proze· zuende ist, wenn der Anfangsindex des Restfeldes grî·er wird
'      als der Endindex.-
'      holen des Endindes
' - Die Anzahl der SortierlÑufe ist proportional zu
'               ~ (Anzahl Feldelemente) * ld (Anzahl Feldelemente)
'   (ld = Logarithmus Dualis; d.h. Logarithmus zur Basis 2; z.B. ld (1024)=10)
' - Nachteile des hier verwendeten QickSort-Algorithmus:
'    - Bei jedem Aufruf wird die RÅcksprungadresse sowie die Parameter und
'      lokalen Variablen auf dem Stack abgelegt und beanspruchen dort einen
'      Speicherplatz, der proportional der Anzahl der Rekursions-Schachtel-
'      tiefe ist. In der Voreinstellung steht fÅr den Stack ein Bereich von
'      lediglich 1200 Bytes zur VefÅgung