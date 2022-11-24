'From: https://qb64forum.alephc.xyz/index.php?topic=4638.0
'4 Letter Word Invaders Game
'By SierraKen on Feb. 6, 2022
'
'Test your typing skills by typing each word that falls. No need press the Enter key.
'The more you get right, the faster it goes. 40 points wins. Good Luck!
 
Dim a$(600)
_Title "4 Letter Word Invasion"
For t = 1 To 500
    Read a$(t)
Next t
Screen _NewImage(800, 600, 32)
Color _RGB32(255, 255, 255)
Randomize Timer
start:
Cls
Line (0, 501)-(800, 501), _RGB32(255, 255, 255)
For skyy = 0 To 500
    col = Int(skyy / 2)
    Line (0, skyy)-(800, skyy), _RGB32(0, 0, col)
Next skyy
For groundy = 502 To 600
    g = g + 2
    colg = Int(g / 2)
    Line (0, groundy)-(800, groundy), _RGB32(0, colg, 0)
Next groundy
g = 0
Locate 15, 40
Print "4 Letter Word Invasion!"
Locate 17, 40
Print "By SierraKen"
Locate 19, 40
Print "Type the words that fall down"
Locate 20, 40
Print "Before they reach the ground!"
Locate 21, 40
Print "45 points wins the game."
Locate 22, 40
Print "Start out with 5 lives."
Locate 23, 40
Print "Good luck!"
Locate 25, 40
Input "Press Enter To Start.", en$
Cls
score = 0
speed = .5
lives = 5
score$ = Str$(score)
lives$ = Str$(lives)
s$ = "Score: " + score$ + " Lives: " + lives$
_Title s$
 
Do
    x = Rnd * 750
    y = 5
    tt = Int(Rnd * 500) + 1
    word$ = a$(tt)
    c = 1
    Do
        Line (0, 501)-(800, 501), _RGB32(255, 255, 255)
        For skyy = 0 To 500
            col = Int(skyy / 2)
            Line (0, skyy)-(800, skyy), _RGB32(0, 0, col)
        Next skyy
        For groundy = 502 To 600
            g = g + 2
            colg = Int(g / 2)
            Line (0, groundy)-(800, groundy), _RGB32(0, colg, 0)
        Next groundy
        g = 0
        y = y + 10
        If y > 500 Then
            Sound 250, 1
            Sound 150, 1
            lives = lives - 1
            score$ = Str$(score)
            lives$ = Str$(lives)
            s$ = "Score: " + score$ + " Lives: " + lives$
            _Title s$
            If lives = 0 Then
                Locate 15, 40
                Print "G A M E   O V E R"
                Locate 17, 40
                Input "Again (Y/N)"; ag$
                If Left$(ag$, 1) = "y" Or Left$(ag$, 1) = "Y" Then GoTo start:
                End
            End If
            GoTo more:
        End If
        _PrintString (x, y), word$
        Locate 25, 1
        Print "->";
        w$ = InKey$
        If w$ = Chr$(27) Then End
        Locate 25, 3 + c: Print w$
        If w$ <> "" Then
            If w$ = Mid$(word$, c, 1) Then
                c = c + 1
                If c > 4 Then
                    Sound 850, .5
                    If score < 39 Then speed = speed - .012375
                    score = score + 1
                    score$ = Str$(score)
                    lives$ = Str$(lives)
                    s$ = "Score: " + score$ + " Lives: " + lives$
                    _Title s$
                    If score = 45 Then
                        Locate 15, 40
                        Print "Y O U   W I N ! ! ! ! ! ! ! ! ! !"
                        Locate 17, 40
                        Input "Again (Y/N)"; ag$
                        If Left$(ag$, 1) = "y" Or Left$(ag$, 1) = "Y" Then GoTo start:
                        End
                    End If
                    _Display
                    Cls
                    GoTo more:
                End If
            Else
                c = 1
            End If
        End If
        _Delay speed
        _Display
        Cls
    Loop
    more:
Loop
 
Data able,acid,aged,also,area,army,away,baby,back,ball
Data band,bank,base,bath,bear,beat,been,beer,bell,belt
Data best,bill,bird,blow,blue,boat,body,bomb,bond,bone
Data book,boom,born,boss,both,bowl,bulk,burn,bush,busy
Data call,calm,came,camp,card,care,case,cash,cast,cell
Data chat,chip,city,club,coal,coat,code,cold,come,cook
Data cool,cope,copy,core,cost,crew,crop,dark,data,date
Data dawn,days,dead,deal,dean,dear,debt,deep,deny,desk
Data dial,diet,disc,disk,dock,does,done,door,dose,down
Data draw,drew,drop,drug,dual,duke,dust,duty,each,earn
Data ease,east,easy,edge,else,even,ever,evil,exit,face
Data fact,fail,fair,fall,farm,fast,fate,fear,feed,feel
Data feet,fell,felt,file,fill,film,find,fine,fire,firm
Data fish,five,flat,flow,food,foot,ford,form,fort,four
Data free,from,fuel,full,fund,gain,game,gate,gave,gear
Data gene,gift,girl,give,glad,goal,goes,gold,Golf,gone
Data good,gray,grew,grey,grow,gulf,hair,half,hall,hand
Data hang,hard,harm,hate,have,head,hear,heat,held,hell
Data help,here,hero,high,hill,hire,hold,hole,holy,home
Data hope,host,hour,huge,hung,hunt,hurt,idea,inch,into
Data iron,item,jack,jane,jean,john,join,jump,jury,just
Data keen,keep,kent,kept,kick,kill,kind,king,knee,knew
Data know,lack,lady,laid,lake,land,lane,last,late,lead
Data left,less,life,lift,like,line,link,list,live,load
Data loan,lock,logo,long,look,lord,lose,loss,lost,love
Data luck,made,mail,main,make,male,many,mark,mass,matt
Data meal,mean,meat,meet,menu,mere,mike,mile,milk,mill
Data mind,mine,miss,mode,mood,moon,more,most,move,much
Data must,name,navy,near,neck,need,news,next,nice,nick
Data nine,none,nose,note,okay,once,only,onto,open,oral
Data over,pace,pack,page,paid,pain,pair,palm,park,part
Data pass,past,path,peak,pick,pink,pipe,plan,play,plot
Data plug,plus,poll,pool,poor,port,post,pull,pure,push
Data race,rail,rain,rank,rare,rate,read,real,rear,rely
Data rent,rest,rice,rich,ride,ring,rise,risk,road,rock
Data role,roll,roof,room,root,rose,rule,rush,ruth,safe
Data said,sake,sale,salt,same,sand,save,seat,seed,seek
Data seem,seen,self,sell,send,sent,sept,ship,shop,shot
Data show,shut,sick,side,sign,site,size,skin,slip,slow
Data snow,soft,soil,sold,sole,some,song,soon,sort,soul
Data spot,star,stay,step,stop,such,suit,sure,take,tale
Data talk,tall,tank,tape,task,team,tech,tell,tend,term
Data test,text,than,that,them,then,they,thin,this,thus
Data till,time,tiny,told,toll,tone,tony,took,tool,tour
Data town,tree,trip,true,tune,turn,twin,type,unit,upon
Data used,user,vary,vast,very,vice,view,vote,wage,wait
Data wake,walk,wall,want,ward,warm,wash,wave,ways,weak
Data wear,week,well,went,were,west,what,when,whom,wide
Data wife,wild,will,wind,wine,wing,wire,wise,wish,with
Data wood,word,wore,work,yard,yeah,year,your,zero,zone
 