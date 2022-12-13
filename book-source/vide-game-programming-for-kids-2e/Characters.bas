_TITLE "Character Generator"
RANDOMIZE TIMER

TYPE Character
    Name AS STRING * 20
    Age AS INTEGER
    Race AS INTEGER
    Class AS INTEGER
    Specialty AS INTEGER
    Strength AS INTEGER
    Dexterity AS INTEGER
    Willpower AS INTEGER
    Magic AS INTEGER
    Cunning AS INTEGER
    Constitution AS INTEGER
END TYPE

PRINT "Creating character..."
DIM SHARED hero AS Character
hero.Name = "Gray Warden"
hero.Age = 20
hero.Strength = 5 + RND * 10
hero.Dexterity = 5 + RND * 10
hero.Willpower = 5 + RND * 10
hero.Magic = 5 + RND * 10
hero.Cunning = 5 + RND * 10
hero.Constitution = 5 + RND * 10

PRINT "Generating the race..."
hero.Race = INT(RND * 3)

PRINT "Generating the class..."
IF hero.Dexterity > 10 OR hero.Cunning > 10 THEN
    hero.Class = 0 'rogue
ELSEIF hero.Magic > 10 OR hero.Willpower > 10 THEN
    hero.Class = 1 'mage
ELSE
    hero.Class = 2 'warrior
END IF

PRINT "Generating the specialty..."
hero.Specialty = INT(RND * 4)

COLOR 14
PRINT
PRINT "CHARACTER INFO"
COLOR 15
PRINT "Name: "; hero.Name
PRINT "Age: "; hero.Age
PRINT "Race: "; GetRace(hero.Race)
PRINT "Class: "; GetClass(hero.Class)
PRINT "Spec: "; GetSpecialty(hero.Class, hero.Specialty)
PRINT "STR: "; hero.Strength
PRINT "DEX: "; hero.Dexterity
PRINT "WIL: "; hero.Willpower
PRINT "MAG: "; hero.Magic
PRINT "CUN: "; hero.Cunning
PRINT "CON: "; hero.Constitution
END

FUNCTION GetRace$ (n)
IF n = 0 THEN
    GetRace$ = "Human"
ELSEIF n = 1 THEN
    GetRace$ = "Elf"
ELSEIF n = 2 THEN
    GetRace$ = "Dwarf"
END IF
END FUNCTION

FUNCTION GetClass$ (n)
IF n = 0 THEN
    GetClass$ = "Rogue"
ELSEIF n = 1 THEN
    GetClass$ = "Mage"
ELSEIF n = 2 THEN
    GetClass$ = "Warrior"
END IF
END FUNCTION

FUNCTION GetSpecialty$ (class, spec)
IF class = 0 THEN
    IF spec = 0 THEN
        GetSpecialty = "Assassin"
    ELSEIF spec = 1 THEN
        GetSpecialty = "Bard"
    ELSEIF spec = 2 THEN
        GetSpecialty = "Duelist"
    ELSE
        GetSpecialty = "Ranger"
    END IF
ELSEIF class = 1 THEN
    IF spec = 0 THEN
        GetSpecialty = "Arcane Warrior"
    ELSEIF spec = 1 THEN
        GetSpecialty = "Shapeshifter"
    ELSEIF spec = 2 THEN
        GetSpecialty = "Spirit Healer"
    ELSE
        GetSpecialty = "Blood Mage"
    END IF
ELSEIF class = 2 THEN
    IF spec = 0 THEN
        GetSpecialty = "Berserker"
    ELSEIF spec = 1 THEN
        GetSpecialty = "Champion"
    ELSEIF spec = 2 THEN
        GetSpecialty = "Reaver"
    ELSEIF spec = 3 THEN
        GetSpecialty = "Templar"
    END IF
END IF

END FUNCTION


