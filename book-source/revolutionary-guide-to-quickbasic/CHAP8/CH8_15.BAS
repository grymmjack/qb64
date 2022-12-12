REM Moving a truck across the screen
REM \CHAP8\CH8_15.BAS

 DECLARE SUB DrawTruck ()
 'Moving a truck across the screen
 SCREEN 1, 0
 CALL DrawTruck				'Call subroutine and draw the truck
 DIM truck%(629) 			'Define array
 GET (20, 21)-(119, 70), truck%	'Put Truck into array

 CLS					'Draw border and sun
 LINE (0, 0)-(319, 148), , B
 CIRCLE (0, 0), 20
 LINE (14, 14)-(50, 50)
 LINE (19, 3)-(70, 10)
 LINE (3, 17)-(12, 65)

 FOR n = 1 TO 210
     PUT (n, 100), truck%, PSET	'Draws truck, erasing the previous 
     LINE (0, 148)-(319, 148)		'Re-draw the line under the truck
 NEXT n
 F$ = INPUT$(1)				'Wait for a keypress
 END

 SUB DrawTruck
 CIRCLE (105, 60), 10		    'Draw front tire
 PAINT (105, 60), 3		    'Paint front tire
 CIRCLE (35, 60), 10		    'Draw rear tire
 PAINT (35, 60), 3		    'Paint rear tire
 LINE (21, 21)-(101, 40), , BF    'Draw back of truck
 LINE (21, 40)-(119, 60), , BF    'Draw hood
 END SUB