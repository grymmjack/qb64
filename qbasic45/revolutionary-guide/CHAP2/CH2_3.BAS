REM How we can solve QBasic’s division by zero problem
REM PROGRAMS\CHAP_2\CH2_3.BAS
  
Input "INPUT x =";x
If x = 0 Then y = 1 
If x <> 0 Then y = SIN (x) / x
Print "Sin(x)/x = ";y

End     
