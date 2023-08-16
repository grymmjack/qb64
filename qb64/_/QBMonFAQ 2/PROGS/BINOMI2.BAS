'*********************************************************
' BINOMI2.BAS = Berechnung des Binominalkoeffizienten
' ===========
' Dieses QBasic-Programm berechnet den Binominalkoeffizi-
' enten k aus n (manchmal auch "n ueber k" genannt). Dabei
' wird durch einen Trick der zur Verfuegung stehende
' Zahlenbereich optimal genutzt, um moeglichst grosse
' Werte von n und k verarbeiten zu koennen.
'
' In der Wahrscheinlichkeitsrechnung wird der
' Binominalkoeffizient verwendet, um die Anzahl der
' Moeglichkeiten zu ermitteln, k aus insgesamt n unter-
' schiedlichen Elementen zu kombinieren. Dabei wird die
' Reihenfolge nicht beruecksichtigt, und die Elemente
' werden nach dem "Ziehen" nicht zurueckgelegt.
' Beispiel: Beim Lotto "6 aus 49" gibt es 6 aus 49
' Moeglichkeiten, den Lottoschein auszufuellen.
'
' Es wird der Datentyp DOUBLE verwendet (Doppelt lange
' 64-Bit-Gleitpunktzahl). Damit sind Zahlen bis ca.
' 1,8 * 10^308 darstellbar.
'
' Dieser Zahlenbereich ermoeglicht normalerweise Bereiche
' fuer k und n bis jeweils 170. Die meisten Taschenrechner
' gehen nur bis maximal 69. Ab n = 60 erhaelt man eine
' Ergebnisanzeige in Exponentialdarstellung.
'
' Durch folgenden Trick wurde der Bereich fuer k und n
' soweit wie moeglich erhoeht:
' Der Bruch (k aus n) = n! / ((n-k)! * k!) wird vor der
' weiteren Berechnung durch den groesseren der beiden
' Nennerfaktoren gekuerzt wird. Abhaengig davon, welcher
' Term groesser ist, wird im darauf folgenden Programm
' eine Fallunterscheidung getroffen.
'
' In beiden Faellen gibt es anschlieáend gibt es in
' Zaehler und Nenner dieselbe Anzahl von Termen. Daher
' kann man den groáen Bruch in viele kleine Brche
' aufteilen, die nacheinander berechnet und miteinander
' multipliziert werden. So erhaelt man viele kleine statt
' weniger grosser Terme und ein schnelles "Anstossen"
' an die Zahlenbereichsgrenze wird vermieden.
'
' Die beiden zu betrachtenden Faelle werden wie folgt
' abgearbeitet:
'
' *** Fall 1: (n-k) >  k
' (k aus n) = (n-'*********************************************************
' BINOMI2.BAS = Berechnung des Binominalkoeffizienten
' ===========
' Dieses QBasic-Programm berechnet den Binominalkoeffizi-
' enten k aus n (manchmal auch "n ueber k" genannt). Dabei
' wird durch einen Trick der zur Verfuegung stehende
' Zahlenbereich optimal genutzt, um moeglichst grosse
' Werte von n und k verarbeiten zu koennen.
'
' In der Wahrscheinlichkeitsrechnung wird der
' Binominalkoeffizient verwendet, um die Anzahl der
' Moeglichkeiten zu ermitteln, k aus insgesamt n unter-
' schiedlichen Elementen zu kombinieren. Dabei wird die
' Reihenfolge nicht beruecksichtigt, und die Elemente
' werden nach dem "Ziehen" nicht zurueckgelegt.
' Beispiel: Beim Lotto "6 aus 49" gibt es 6 aus 49
' Moeglichkeiten, den Lottoschein auszufuellen.
'
' Es wird der Datentyp DOUBLE verwendet (Doppelt lange
' 64-Bit-Gleitpunktzahl). Damit sind Zahlen bis ca.
' 1,8 * 10^308 darstellbar.
'
' Dieser Zahlenbereich ermoeglicht normalerweise Bereiche
' fuer k und n bis jeweils 170. Die meisten Taschenrechner
' gehen nur bis maximal 69. Ab n = 60 erhaelt man eine
' Ergebnisanzeige in Exponentialdarstellung.
'
' Durch folgenden Trick wurde der Bereich fuer k und n
' soweit wie moeglich erhoeht:
' Der Bruch (k aus n) = n! / ((n-k)! * k!) wird vor der
' weiteren Berechnung durch den groesseren der beiden
' Nennerfaktoren gekuerzt wird. Abhaengig davon, welcher
' Term groesser ist, wird im darauf folgenden Programm
' eine Fallunterscheidung getroffen.
'
' In beiden Faellen gibt es anschlieáend gibt es in
' Zaehler und Nenner dieselbe Anzahl von Termen. Daher
' kann man den groáen Bruch in viele kleine Brche
' aufteilen, die nacheinander berechnet und miteinander
' multipliziert werden. So erhaelt man viele kleine statt
' weniger grosser Terme und ein schnelles "Anstossen"
' an die Zahlenbereichsgrenze wird vermieden.
'
' Die beiden zu betrachtenden Faelle werden wie folgt
' abgearbeitet:
'
' *** Fall 1: (n-k) >  k
' (k aus n) = (n-'*********************************************************
' BINOMI2.BAS = Berechnung des Binominalkoeffizi