_TITLE "Gradebook"

TYPE Gradebook
    Student AS STRING * 20
    Math AS STRING * 2
    Science AS STRING * 2
    Reading AS STRING * 2
    Writing AS STRING * 2
    Spelling AS STRING * 2
    Geography AS STRING * 2
    History AS STRING * 2
END TYPE

DIM grades AS Gradebook

grades.Student = "Bobby Fisher"
grades.Math = "A"
grades.Science = "B+"
grades.Reading = "C-"
grades.Writing = "A-"
grades.Spelling = "B-"
grades.Geography = "A+"
grades.History = "C+"

PRINT "Here are your grades:"
PRINT "Student: "; grades.Student
PRINT "Math: "; grades.Math
PRINT "Science: "; grades.Science
PRINT "Reading: "; grades.Reading
PRINT "Writing: "; grades.Writing
PRINT "Spelling: "; grades.Spelling
PRINT "Geography: "; grades.Geography
PRINT "History: "; grades.History

