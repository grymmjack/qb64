PRINT "I Am The Rude Computer"
INPUT "What is your name? ", name$
PRINT name$; " is a dumb name."
RANDOMIZE TIMER

num = 8
DATA "You are a super dunder head."
DATA "Well, I don't care about that."
DATA "Oh really? You are so wrong."
DATA "Can I talk to a smart person, please?"
DATA "I think you are special. Not!"
DATA "How dare you speak to me in that tone!"
DATA "How does that make you feel?"
DATA "I'm not sure what to say."

DO
    INPUT ">> ", user$
    n = INT(RND * num)
    RESTORE
    FOR n = 1 TO n
        READ answer$
    NEXT
    PRINT answer$

LOOP UNTIL user$ = "quit"
PRINT "Fine, be that way."

