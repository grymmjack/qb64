'=============
'PATTERNS.BAS
'=============
'QB64PE code by Dav, NOV/2022
'Collection of 40 different seamless patterns.
'Can be used for making backgrounds for games.
'Patterns have transparent background and can be
'layered on top of each other for different effects.
'Pattern color and size can be specified.

'===================================================

'DEMO below randomly shows all 40 available patterns

RANDOMIZE TIMER

SCREEN _NEWIMAGE(900, 700, 32)

DO

    'get a random pattern...
    style = INT(RND * 40) + 1 'get random pattern number
    size = INT(RND * 200) + 100 'get random pattern size
    clr& = _RGB(RND * 255, RND * 255, RND * 255) 'random color

    'call SUB, it will tile the pattern on the entire screen.
    tile style, size, clr&

    'show what pattern number and size is being used
    LOCATE 1, 1: PRINT "Style:"; style; ", size:"; size;

    'a demo effect, blur the screen, removes jaggies..
    FOR x = 0 TO _WIDTH - 1
        FOR y = 0 TO _HEIGHT - 1
            p1~& = POINT(x, y)
            p2~& = POINT(x + 1, y)
            p3~& = POINT(x, y + 1)
            p4~& = POINT(x + 1, y + 1)
            p5~& = POINT(x - 1, y)
            p6~& = POINT(x, y - 1)
            p7~& = POINT(x - 1, y - 1)
            p8~& = POINT(x - 1, y + 1)
            p9~& = POINT(x + 1, y - 1)
            r = _RED32(p1~&) + _RED32(p2~&) + _RED32(p3~&) + _RED32(p4~&) + _RED32(p5~&) + _RED32(p6~&) + _RED32(p7~&) + _RED32(p8~&) + _RED32(p9~&)
            g = _GREEN32(p1~&) + _GREEN32(p2~&) + _GREEN32(p3~&) + _GREEN32(p4~&) + _GREEN32(p5~&) + _GREEN32(p6~&) + _GREEN32(p7~&) + _GREEN32(p8~&) + _GREEN32(p9~&)
            b = _BLUE32(p1~&) + _BLUE32(p2~&) + _BLUE32(p3~&) + _BLUE32(p4~&) + _BLUE32(p5~&) + _BLUE32(p6~&) + _BLUE32(p7~&) + _BLUE32(p8~&) + _BLUE32(p9~&)
            PSET (x, y), _RGB(r / 9, g / 9, b / 9)
        NEXT
    NEXT

    _DISPLAY
    _DELAY .3

    'once in a while, show 25 random tiles at random places.
    'This shows how to grab single tiles, and use however you wish.
    IF INT(RND * 10) = 1 THEN
        FOR d = 1 TO 25
            LINE (0, 0)-(_WIDTH, _HEIGHT), _RGBA(0, 0, 0, 32), BF
            sz = INT(RND * 100 + 100) 'random size
            tl = INT(RND * 40) + 1 'random tile of 40
            t& = _NEWIMAGE(sz, sz, 32): _DEST t&
            tile tl, sz, _RGB(RND * 255, RND * 255, 255): _DEST 0
            _PUTIMAGE (RND * _WIDTH, RND * _HEIGHT), t&
            LOCATE 1, 1: PRINT "Style:"; tl; ", size:"; sz;
            _DELAY .1: _DISPLAY
            _FREEIMAGE t&
        NEXT

    END IF


    'for demo, fade previous pattern mostly out, leaving some.
    'this is just to show that patterns can be layered on top.
    LINE (0, 0)-(_WIDTH, _HEIGHT), _RGBA(0, 0, 0, 160), BF

LOOP UNTIL INKEY$ <> ""


SUB tile (pattern, size, clr&)
    'SUB Coded by Dav, NOV/2022.
    'tile SUB will tile 1 of 40 patterns on screen.
    'The tile patterns are seamless.
    'pattern: number of pattern to use
    'size: size of tile in pixels (100 is normal)
    'clr&: color of pattern
    '----------------------
    'By default, the SUB tiles the pattern on entire screen,
    'but you can retrieve just one tile to use by doing this:
    'Make a new image of the tile size you want, and _DEST to it.
    'tile25& = _NEWIMAGE(300, 300, 32): _DEST t&
    'Now get the tile to the image, then reset _DEST back to main
    'tile 25, 300, _RGB(255, 0, 0): _DEST 0
    'After that you can _PUTIMAGE tile25& anywhere in your code.


    SELECT CASE pattern
        CASE 1
            A$ = ""
            A$ = A$ + "haIkF7T3233345mO3bmofbffP7`27;TMm\mkWX:[H]^<fVIHMBQ8LBQ:D<a4"
            A$ = A$ + "N41jQPd5VGnaiFLoC1AhT2EXHR9<1[0m##j2fWKQiE;9o74R`95Z#a4CH2V1"
            A$ = A$ + "jQPC:<Wo;E2i?hm?Ui?giF<QW#PN88M1k;VH9iG?DZS:4QC:DQR9V`O?#?4T"
            A$ = A$ + "^0BClfnjc#HQSWjX2EXHR9<1[0m##j2fWKQiE;9o74R`95Z#a4CXP1jQPd5#"
            A$ = A$ + "DQT;Si9LlD7EX25C<QW#PN88M1k;VhE9%%L2"
        CASE 2
            A$ = ""
            A$ = A$ + "haIkF6T433323TO#noofNf=8:bQR5MZ>:?KmT4Z#VIfekbl<3?l34<fKB#j["
            A$ = A$ + ":A:5lNHB4Q3=cQ`<FT02OKc`85AHF02=QW[]8J2`IhK0MJNR>N>^JikA;cE0"
            A$ = A$ + "A3\1AG93L0K#XIBm:QVK>gPXSN9NS0QSNl47mb7Li>nQj7BTBB6bd#lJ3[9Z"
            A$ = A$ + "MMgQFK7GV0JB#HgTgYjC\ck:l=P86IE=H6<209N2M[ZaS#28:a:>Y_\4cZLG"
            A$ = A$ + "QoD14<fKB#j[Ji^Dj7QXQ0iBG\L\5Te^X?<;8oo^38l\]KRVXSk`Y8Gd3N^Z"
            A$ = A$ + "JQ07[#oEec^0A38Li^_NM#=CZgH[FZCnGE[2RSNi3^Lg3[ZYBi^>2IJ8\\Qe"
            A$ = A$ + "4e^^k#[]S;C0=98\KbkDm9NLE]D4S\Z6<361P4?Q^Eeh35914UH5WdGFRIE^"
            A$ = A$ + "k508%%L2"
        CASE 3
            A$ = ""
            A$ = A$ + "haIkF6U333323eg0^ogf9]e>1Y1Y6=7GbDh;CNO<=JRa0O:kKQHA4L`^N:G0"
            A$ = A$ + "b>Oi09W_1GKbdo:8[Ii0VGKmd40VCNd4\2X0Ngi=I\90VoO41O?0LTnJZP4="
            A$ = A$ + "egPCjg0oQU43iJ^iLDPI94JPXabD01G]91PRI5:j]TRVQKU;ik?ZCR\a1:b<"
            A$ = A$ + "d4NaJeT04SZU04<[0LTnjU3TXgIhNVBanSR^iLDPI94J0[eJQ?8hZ=90D<[#"
            A$ = A$ + "A_U\c`A_T_oXVK>_7#A^Tc>okoPG070]XJY01c:07Y_Ni09jM6^WYD\oXXK>"
            A$ = A$ + "75HF2Q6`J]Fh32^JC205c:DdK9k<Ld;ik?ZiVck1DT;i\con?h5`1#;ZF:#`"
            A$ = A$ + "\2`Aj[G>#RNWQkI:5k?:jVcA1VU#H12>>T1_04l;%%h1"
        CASE 4
            A$ = ""
            A$ = A$ + "haIkF_T3332340M^1nnOK[D9903>]RXIlZhUn5T3o189R8bBoD8QnnmI=iQ#"
            A$ = A$ + "RLl;94H9Ro1lXboK1=Bfc;66<?`QdB4V0`0\2ce^;<\O;^4[0Z0JTK`O<d1["
            A$ = A$ + "0ZIRJMIR1HIWP>0FQPQ`4`5d9PQ;2d1LNLNIWF0L86bb;6^mT;M#FjfZ?I#F"
            A$ = A$ + "OCK5bTSaDQ`kKhf0V>m:<1P1H5V[MGHHoFL9F1D1d8g`?SMnfKKa#7\2XV9Z"
            A$ = A$ + "eU96PUM2j0H5262C0G#W06^8#7`iaiUMJ1`QH8;okKhBPl38UFjgg`]9`knU"
            A$ = A$ + "3CWN5V0`0\2ce^;<\O;^4[0Z0JTK`O<d1[0ZIRJMIR1HIWP>0FQPQ`4`5d9P"
            A$ = A$ + "Q;2d1LNLNIWF0L86bbon6^48[_Y]2IbaHZ#hm=LK0CWN5V0`0\2ce^;<\O;^"
            A$ = A$ + "4[0Z0JTKhWa>Ok]]HX3F1Dc4ejb43`b>1M0\213Q9P;XC03G4X3hlhlb>]0h"
            A$ = A$ + "#<TUG;TVn^OYW1O0nDPf%%%0"
        CASE 5
            A$ = ""
            A$ = A$ + "haIkH^U[33234UM0koMkmSZ81N6o2<dDY;o5<WJ8`<hdNKXe7Jc?<>X:8JfM"
            A$ = A$ + "UVXS4]6RHW372<7=Ic=7N4#>00I_kC#04MKa7RP2<e_hUmKRXcRX#8?m7VX3"
            A$ = A$ + "1D809V;1PhA<ZSki9D7l0FOGR?#Zo63?7Shcc#o?[ONjiCd\45mJ?4a0S<#Q"
            A$ = A$ + "4[;3B#L<3PJ]nX4baLN2hZX:80ATE`U882Ek`Y9HRC21LY##2E3061f2ATJF"
            A$ = A$ + "YNcC0RK\OldY9ACfbCL3mAiUZY8d3b_1a?BYJI847^cO[V;18S[W0=;:T07?"
            A$ = A$ + "G9UUH>VRLFeDDWP>H[5hZ_49;^4K]m\4b0Z4;LX6fR>VDSoKEF>T^l7ikJ5W"
            A$ = A$ + "l>EaMjadV8I9HOl32\gU`H>f^d0X;F>TWRlcQ=1K:#JNiH1Rd[3CR_cnACfL"
            A$ = A$ + "cQ7aGAOL122#1nEGagm6gOLUk1?HYJi[00=;L8\<HhHI9`1fGZD=MCA]CeT9"
            A$ = A$ + "lHP29fYD]`4Gi#m;E>7Th2OG[L<WWhoo7>U`<e?Q#N:::1J3H#P]#4YVEP\>"
            A$ = A$ + "1a=f?NjdTX9Ki9^Qnh:5gM3oZGZCm;_h>#6G?1JFD81>N^B:;aL<5i\ZYX>1"
            A$ = A$ + "M`F;`EO9BFL9fJkI9T1D907k`4T8J40B#2J4=R5=0lcQUeW?QhTgAnfi5^Vh"
            A$ = A$ + "WioQS0hDJP3197TNbDn1B<?7Vdn4S0]Lh#l70h:S%%%0"
        CASE 6
            A$ = ""
            A$ = A$ + "haIkF7TT423256VK0goKk<CGSbS0h2cOfem6UlIe64`BcnmWog?koO[WS0^k"
            A$ = A$ + "J#8H`W3nJ0:haQ:32JJjCi?1dD^`P^VSBWbN`mMAB_[WRP`MaiC`9PHYdi70"
            A$ = A$ + "^b]e]04DK8jj>8PYj54\4HCGe6PDJR0D`M1Z;Q1bCbfm65l#9R0<CRd0>Xkf"
            A$ = A$ + "=^?N5TW477Ag6:M0d#\Te`TPfALES0QD?P_601WkO>WDB#8H`MY95P2NLXbP"
            A$ = A$ + "PVVnDnC0Wl]9M=7U>UmPdDbhhcf#ie0h#\Djl30GifjF02Z=4MM74`Dm22F2"
            A$ = A$ + "\Y[J3#:=A0:h^0eU`0i9IkNS2NX4A0V9AJ07dMk6g7_2bCRSSXK3U>0J8FbJ"
            A$ = A$ + "h_O3gB?kanWc9U4426LGJB1XP77Z<8XYY?Uo4`9OKBGcAYCI?8=U<>n\=DN="
            A$ = A$ + "0>4;U>o0`E^]^5PPJ3AGg11<E_PPU0KjZf0TBC4P2^;#M9<#NBf^gXP7:A4P"
            A$ = A$ + "IBT6`1Mg^ama[PlThh8jf#Y3P6RU\6nkg`]dcN\oiLB91QP1gUVD0:haQ:32"
            A$ = A$ + "JJjCi?1LbgVdeLDjDf3BC9SS?K3UG3P3aBYc?0LUK[K18Xf#deM#0Ce;8H9`"
            A$ = A$ + "V^Z=0Yd41XPk2DG23TWT]k=:hQB41HV4Y1L#g]KLOl:8?9>>R^=Dj0XQH9[Q"
            A$ = A$ + "on=L2lSo%%L2"
        CASE 7
            A$ = ""
            A$ = A$ + "haIkH7U3332330=gPLo_]CkSY1SHQ6HWBZJoYFlZd6[d4F=c<omQ5L#3l?7j"
            A$ = A$ + "0g1B]0g1BeQfcJPa4M8<^=d_H810l5IK`RR\QVR<bP4V7P\<#djZf??E?Od3"
            A$ = A$ + "IlLN:e[>e:eCQc\ci2PQ6W9Tan[2^:]0Lbb3VOC[4Pk0Y6#O#14593X\:8UN"
            A$ = A$ + "]gXnPj1h4T746g6bHM5JAmco=86^d2b:Pc\ci2PQ6W98KoEX?>N`dOgf7nN_"
            A$ = A$ + "1_AX20^3TZ3]We0S92#jm1E1gXnPj1h4T70b?_7^IPVWco1bXNeYFYN:LVM>"
            A$ = A$ + "G0<dh<QoOgB[03GUF0>Ii1c_YE2`MPD3X?X0RRT1DF5TB_fKDO#m0L2b32SK"
            A$ = A$ + "3I\^2]Xnim`53GJ1I5`IfiL1`#Sc4T\oZG`2%%L2"
        CASE 8
            A$ = ""
            A$ = A$ + "haIkF7T2334344DoPiooKcEC26K1IJHQN?ZjP`H#d9GNcUGnO`#031<4`#03"
            A$ = A$ + "1<00`g1`oSd7BO8m1PEPL9i^iEPY?lml2`?c5^5#^CRLX4iB9bYBTKUf`m4H"
            A$ = A$ + "3g:`6^g2Y?Tn#j30[`6>Kh>M`6^EP=L?1f`]2\Qc6^2#j3Y?0\2Kh\Qkd1Kh"
            A$ = A$ + "F1f`m4H3g:`6>Kh:0Y?Tn0`:\Qc6^C7\QK5Lf=LO0DT2%%h1"
        CASE 9
            A$ = ""
            A$ = A$ + "haIkF7UZ433256fMPkoMkLi>SA<HJQbigWjlD;OI#C8NX^k^5obWnkI]`RPP"
            A$ = A$ + "B302oCh`T5Q5\;Z^<h[hWn;2Q>A8lKcemG42Q\KjQO3\2Q^3]jb43U078`FC"
            A$ = A$ + "YX#V5X36Y8]GR?<WnD0Nb>P3R#XCT3SETYRXLFH_1T2Ugg3L42ifT1:=08TS"
            A$ = A$ + "lT`T5Q5\;Z^<8Beh1hTng_Qk>Xk#[^<a#9`12\eD::TI1jPA:BkUh3cY?5PW"
            A$ = A$ + "\3hP84j4i`H5IZ8:W5fK0Y#imm07Q#^=IPB302i8?9<IAH1kRZ;3RD=N0>Yo"
            A$ = A$ + "mKh^3j>dZ;C<D2LP0K=UR2IFP>HTRdN9n`LjC1h9k0>82Q>A><FAV:RbIQm6"
            A$ = A$ + "#:DNO?`A8TKC6Xd0P#>bC2CF4F`^XjbP8ES7PCjOo6^kP^3]jb43U078`FCY"
            A$ = A$ + "X#V5X36Y8]GR?<WnD0Nb>P3R#XCT3SETYRXLFH_1T2O0Cg3M%%%0"
        CASE 10
            A$ = ""
            A$ = A$ + "haIkH_U\422340UM#fokfk;MTT^3#CHniF3OY078R1\:]6]H^K\dVFBlm]4D"
            A$ = A$ + "H#3CR\h7BdhZ`\hXZ;nUT7XoL=Y3RRo8F6`hSYXhRH?g4dFbTX8j[:2<BL_U"
            A$ = A$ + "hiIceDgel9ABLg80`8LOAg[ZAQN=aEFM04f7471EaM^RU3J`A6[;lmU<H`H\"
            A$ = A$ + "[0G9B1jRk[Wn:6Fi55]d\C4X;NM=;ece;XN9QK58#\8#G09;D2M:D4TX8l`k"
            A$ = A$ + "ZEF<H1];XcVRE5=OQ#lMBFPK>91Z[GWA#>k[T8[TfYJ=D=LG#lFFf]`DD=mI"
            A$ = A$ + "Zh<K36:>bfiaRcM\DZhY2SB6<5[:j___9ghDk3;#T\oWkb4C2Ah5k6RHB]A8"
            A$ = A$ + "S?<JZ0gLfC<F6U^0Z178_CG#9haBe4d4ChFLBT41BBNJAAKB8BfEY;J^JcB9"
            A$ = A$ + "::JM?M\l3bJR^XkeDB<m<^K;Jg204ZXRh:W>2JnBAa1nm>c5`DB;3>ML5aJ]"
            A$ = A$ + "\A3_W`eR[#WOIocoQ[ThX7;U9>ha[iRSmIRAR3mi^a2b7Q7Wm\Sh:[>02k3R"
            A$ = A$ + "SPZh>Gab1=h8Se5nnB6<H<fEP[4Y0MameCO53[lRRFJf92d5_^VUjij5D_T`"
            A$ = A$ + "]248F4X;PT5:Q>5:2BD4NhMe:;6\Pf5dICaZRV_#8n>9;`=WT0mcoQ;f#e`M"
            A$ = A$ + "1aKIIg2CaWo3gBRcM\DZhY2SB6<5[:j___9ghDk3;#T\oWkb4C2Ah5k6RHB]"
            A$ = A$ + "A8S?<JZ0gLfC<F6U^0Z178_CG#9haBe4d4ChFLBT41BBNJAAKB8BfEY;J^Jc"
            A$ = A$ + "B9::JM?M\l3bJR^XkeDB<m<^K;Jg204ZXRh:W>2JnBAaodo3g9;O10Xh%%h1"
        CASE 11
            A$ = ""
            A$ = A$ + "haIkG7T3522340UK#_ogfo>CE6n1Sc<B=dUmU040;eF37aPl53R_14U3PD`6"
            A$ = A$ + "0T0h:5BPcT:8AQ>hP416WFUkC4?GW24Me]M=L0l[V0bgNo2Yg6`i;7<8OePU"
            A$ = A$ + "IQ#\W:7cm^WZ9QQE^83#Q7hl]T>R74i`1T9N#d5D1a3__mYWOn=5HiZKRD2F"
            A$ = A$ + "ZVH[\8<Om0LnMoL_3\<;4Rm<n=PEmkgaPUoLfdK9oYI;RPmnf2MPR6[l=jW0"
            A$ = A$ + "UkC4?GW24Me]M=L0l[V0bgNo2Yg6`i;7<8OePUIQ#\W:7cm^WZ9QQE^83#Q7"
            A$ = A$ + "hl]T>R74i`1T9N#d5D1a3__mYWOn=5HiZKRD2FZVH[\8<Om0LnMoLnRO?hHW"
            A$ = A$ + "%%%0"
        CASE 12
            A$ = ""
            A$ = A$ + "haI_FVU]T3233UMPgokfnLjGAR7T0c#\oZ#bGPHV:AnOdl1Ak=FPX19PmSH8"
            A$ = A$ + "8VXQ0IBV]?:WC8f0<C9>4RhGY4S0AKG2QT?JZ\21Y8<X5^#WV#Dih;3T:J2R"
            A$ = A$ + "`RShd3Mfa4ofig\QbI3R`P3?Zng1h[A0cWHWShRMEJR__8NfBK6RW<Q4gHCM"
            A$ = A$ + "_4N`A]94RXK388iTW#\0T[n4F\8QOV0_h4QTV8^HjGfX899DKHh?#fH8I8JV"
            A$ = A$ + "X;R<a8c9Jn`#0=GT8<2lBBgNMR2n>ZIm`;oX4\HUTT45Ln#iXJXeSik\bAlI"
            A$ = A$ + "gGEam^V_Z?km3PEH7S?oM8ZhmlO^\=h=Dnk#lF37;];a5k:SMDjJU44aMGJe"
            A$ = A$ + "4Q9eEfRB8Lb_>Zf#S44n9eaGI`9PiHSVm3I52gTRa4BKI2SlEN::\6<i1bPn"
            A$ = A$ + ">4AWSn[10E`Tje5:^aO:2=loI3TfTXR_SBF?ZHOE9W?ZhLN9gGEam^UlnA5_"
            A$ = A$ + "3VneiCN?GMN\5S[B0cWHWShRMEJR__8NfBK6RW<Q4gHCM_4N`A]94RXK388i"
            A$ = A$ + "TW#\0KOeG>2o<inGj7G<_mSGZ=<nBJL_4AO<Ac4MAT96I>Ac762XiR4QAPGB"
            A$ = A$ + "jf[CD`gA=[7Ni7UP5[TTTXPc7:7E3]N<OWE>R?knZ:^gelEmI_O0\2kHli_3"
            A$ = A$ + "A5_WocU]1_QbO7RgJhHYM9beECe6jNiB2R8kB;L<BBdKC[^K\YfihjXG7Eka"
            A$ = A$ + "SaLRWFRXI#]FP`<h`L\AVaH81Hl2iKC;7QjgV>JjCAQa85QEgc4dGPhA8fGS"
            A$ = A$ + "o[1XaH61`Zk25Gi?5I00G8PT85aI4oCC%%L2"
        CASE 13
            A$ = ""
            A$ = A$ + "haIkHVT435224UK0goKKFTZB1Jg>`P[2[Djo;i[289ZZZ<IjG[#Q19eH5:HU"
            A$ = A$ + "df4DVo:5da]?RPTQ#mOe2A8=QK6T#bA<bCX;U0mHC1ZW#0>lo9ARHZU07iO?"
            A$ = A$ + "161V6aSkgA\89bZRlM<a3F7#PR??FALXgM4niNAP#e4`a9946QMmVWXkj^3Q"
            A$ = A$ + "0MLoafd[l2dLbb44[eRP<JD1Ha[H4=8lRm:_TfV#Wa^MTZa9:^E=F1b05;?S"
            A$ = A$ + "h5GC0fA7?:WBH_Wh5GKC:N]280Q82`5?b?71lCY6RkGigB0m212OVOXg<4V9"
            A$ = A$ + "6gnWbSL=1LLG4nhAbKN825Bdd?Zf7KDim73nog3g61IbH2_P8^`;f[lBJK2_"
            A$ = A$ + "8f]PD]38:\TaB2g<X#bVk:XE=<1oV1d>jhAim4ng#JDim4[KoH_cS8J[E]7g"
            A$ = A$ + "LgbE>\Dde4#PR?cGALXgM4niNAP#e4`a9946Q?N<;AgeM721jhnS]YGi5XiT"
            A$ = A$ + "U98F[51IdX2`RGa8J#h5kEN9]=Q>SMk8ESCDL[J\2T1:FN6a;^VXUFeVCaE_"
            A$ = A$ + "A2GbAP;N]280Q82`5?b?71lCY6RkGigB0m212OVOXg<4V96gnWbSL=1LLG4n"
            A$ = A$ + "hAbKN825BlooQKQ0=E]<1aJ]88C6C86a7#>m%%h1"
        CASE 14
            A$ = ""
            A$ = A$ + "haIkI7]M\32250Uo0oooKkZMV6U37D0IjC=?=ALWXXBFmNUQiBnibfbkVTl2"
            A$ = A$ + "1=6`gg]dH91H0a[k^G\Jd=lLG3RY1BT:QLY`>:eQjA<38m60NiH?VMSUO3;j"
            A$ = A$ + "?]c4c1SH4c]?S;5mM<HWXWScW4gGFJ_0G]#nJkg9dcFZ06E94Z=9K6F`jK11"
            A$ = A$ + "_j6?GTF8PPFPE5[ZH]EXMo8A5faG\7E2AZ989_7AXO7aGJC8#`_=I5`c<Q`2"
            A$ = A$ + "6dSJkN574TYa[fEQ9e<b8lNC>?YK5S03GC:9Z#N47Bk`BKN1o3`laIJQX5>k"
            A$ = A$ + "ZG3FE\d8<H7V#Y5VOma2db`eC\RK:]k8JJk3G86A\S1i53hJcaIf[XTHCh22"
            A$ = A$ + "_Nij:8<394lTNGbhi5k:A_\4NY`K?`<j\ij2XC3<F?2XHPK5WlR6ODnRePAC"
            A$ = A$ + "954VBIWGJ;8NO_IiK\NaN2Y4od0863R#B;lK;D9SHR6ODnRfB9K5M_db5nO#"
            A$ = A$ + "ii^I[2B2;`bVZHOTjETB3N]7#l7E_b>1UAfDb9AgO:Jkn]?l7QOM?:6SN5hL"
            A$ = A$ + "UDUa#B9N?_EQ9S;DWGloOcI0QX5`ICMo_C\d8I3_>DJQiGO\0]<Lm4[hVBk>"
            A$ = A$ + "RVfn`5RA\FiiM#E?Z:6`EiSc<1K#Q3#JYc42U;``=oo8PfTh119]_G0K6PoG"
            A$ = A$ + "0lBCI4c6NVejY?:T>5dC>ZHY5VOYOBjnOUP4PEmIoSbCXV\QB9E5d5:XjCPU"
            A$ = A$ + "F^##aa]XE53m5<2^l`9I#mZMEHkiZD2CO?E6\PP=[=3LHgJN1ic=Hb\1Qo7D"
            A$ = A$ + "N^[11OOfB`IcG8\SBMXN4jRG=60NiH?VMSUO3;j?]c4#E6X2ZNoCMAO73f9j"
            A$ = A$ + "ihl9amUUl4O1AMi9%%%0"
        CASE 15
            A$ = ""
            A$ = A$ + "haIkF6T204234[o0ooof5IIQ5K;X`#AX97WLc3f<6C\o<nQ>QI96M2K5m2gn"
            A$ = A$ + "WAW8HoeXC4^?=j49k00#;YRoM;inA9g1;iNN9M9UdGA3g^2g>=LaRTM00XU#"
            A$ = A$ + "3gA2Jh^=Q`WT<Q]RNQKW6^HAb>00dBXQk81=LgV#hCBV`FA_`]C3G\8I700J"
            A$ = A$ + "9d`MTP6^=5?0njXC%%%0"
        CASE 16
            A$ = ""
            A$ = A$ + "haIcF^U[63224VM0koMkiUoT3G4EJ7VDNY1;OHJ56DUeVnkQeL_Y1QX[HdE0"
            A$ = A$ + "o_HOR4SoU084=`XU0^UkChgAh4RaMI^:gT7#Do2ie47nUXI7d4nCf7CDGRj["
            A$ = A$ + "A[gTG#8Ak54;U<F[I\LCN:a1321j_36W7E40[[dXIcS?nIjX`dWW06#_bhe<"
            A$ = A$ + "EGCh2JXi7fh3nX82akGZL;jB8I3;AUFc69S?91SoED>cIDkBY7TQF25=A6Jk"
            A$ = A$ + "DVAaHF;Uk<doV<H8>H#8#oM`hlXR0HMU6=KNla?C75Vnl4`0jE6_VYjJ2G#3"
            A$ = A$ + "=o`6O`75A8NoBUKAG29KH9ZdJf8Il99Hl_RbI>SJG:mP<dBXX9b#KWb<:6cJ"
            A$ = A$ + "YLWQngT13a1321j_36W7E40[[dXIcS?nIjX`dWW06#_bhe<EGCh2JXi7fh3n"
            A$ = A$ + "X82akGZL;jB8I3;AUFc69S?91SoED>cIDkBY7TQF25=A6JkDVAaHF;Uk<doV"
            A$ = A$ + "<H8>H#8#oM`hlXR0HMU6=KNla?C75Vnl4`0jE6_VYjJ2G#3=o`6O`75A8NoB"
            A$ = A$ + "UKAG29KH9ZdJf8IdVh?0jnV:%%%0"
        CASE 17
            A$ = ""
            A$ = A$ + "haIkG6S303233<oPnoo]M[2#hj`0^ADOS8^N34#ZGG28N8e^Fg86=JUW\nT6"
            A$ = A$ + "D3g`=>V68`=X6_^;cW#^S6dhC^_K_AWlhjCK#<LSbg01^1a#F3co3mc^:^3j"
            A$ = A$ + "6eZ12L3RQO_ZN4AV3Wf=]Xaano7^QK\S68`=X6nQgU#aiQni:g`=fA34h6D3"
            A$ = A$ + "oNEm8gA3Jl9gg]gXCNLmY=86^AiKP0gPH8[QioQnIG5g1MSJe01^1a`_GE?R"
            A$ = A$ + "8cQCkVFdhHoo3g`=fA34h6D3=?lN3T`:%%h1"
        CASE 18
            A$ = ""
            A$ = A$ + "haIkF_U2532346Nf1cnOgNP3UBD;D#b_=FjlFlkUXh=k#doha\IPO;PgF#QL"
            A$ = A$ + "D32WeH#H:21=;S8PK21HC3[;SMPXQ`n_41e=<;dO>:AHI7kUHQ:L1M:#mNaL"
            A$ = A$ + "Bh:IcP:d3I>MN;`cO:MF#QLD32WeH#H:21=;S8PK21HC3[;SMPXQ`n_41e=l"
            A$ = A$ + "gOh^3THQ:L1M:#mNaLBh:IcP:d3I>MN;`cO:MF#QLD32WeH#H:21=;S8PK21"
            A$ = A$ + "HC3[;SMPXQ`n_41e=lgOh^3THQ:L1M:#mNaLBh:IcP:d3I>MN;`cO:MF#QLD"
            A$ = A$ + "32WeH#H:21=;S8PK21HC3[;SMPXQ`n_41e=lgOh^3THQ:L1M:#mNaLBh:IKP"
            A$ = A$ + "O<]=%%h1"
        CASE 19
            A$ = ""
            A$ = A$ + "haIkH7U2333330eg0Mo_]ko4[a\FXE2BnD?XU2Y>Z]Zn58i20E#J#_PlP>19"
            A$ = A$ + "2k2b4F5T:0Fn5fPZ8BF#]^b4fb]H2gHX9gPCL63]i_N3Pa09oXm[NjKh30d="
            A$ = A$ + "0I1dG8c2X38c208BF00Ab208b11?Ob50?g9:0N>I#0lLB]0hi9W2PW=Inc2M"
            A$ = A$ + "WlbjI3I1hEo`TC2lbFQ1lbFQ1lbFQ1lbFGH5ZR8I1ej:CH;gR9LSQVL3>aI<"
            A$ = A$ + "dVoj=063TlkoQkk0M3#F0m5b\0j0b\00RT50#T\00RL#`cWL1`cMR2PWC640"
            A$ = A$ + "?WD;0NNbY0hICVO4n#iA%%h1"
        CASE 20
            A$ = ""
            A$ = A$ + "haIkF7T[333240UK`Lo_]EoOUMZ1l6[QA6Y`Vj>?U5>a12\l2P7TCo5B52dg"
            A$ = A$ + "8R`oo0G<\2P9mco82SeHMI=`?5M8:F?1_HM5\Mi_#00f8m2P_j94b;\AfjBZ"
            A$ = A$ + "#jVZ2hiPA5c1Maf<R:HaR;T5?^V>1:^G9iI^Rc^BN7DA_49m4_cY170gidi3"
            A$ = A$ + "P]O`b;40P=B_0h[N2Ql2KT]^T:T^YZ0N>HDaL#G\=SX2F\h2IaS[YCPRkEBN"
            A$ = A$ + "V[h\[Tg1Ed;AB?akLJ`1`M>Mn0Hk7\l210HSd;0nZW#8_`6I[;Y2YKZ:PW36"
            A$ = A$ + "E<7d5Kc8ZP5;^#FlhJj4XhNUTWi:>k:iM#5mBTdCl>W6L0LWCW?0fn1;_#00"
            A$ = A$ + "f8m2P_j94b;\AfjBZ#jVZ2hiPA5c1Maf<R:HaR;T5?^6F`70m<C9%%%0"
        CASE 21
            A$ = ""
            A$ = A$ + "haIkF6T334225UK0goKKWVD4a<\H6o#X4IS<nZQd?82cG6A4oKUVGQ18anjb"
            A$ = A$ + "o<\0B=N\o5i?6<]?KfOC`960RA#P`Z[h<02QG_eR4HU^e=00VRRf4S03\1F;"
            A$ = A$ + ";23LOBKGPa8bQ\5X;aX;PDZ[B1H_LZo_Q2LVD28#l_mG33XjfB3IL0=gDd9b"
            A$ = A$ + "Zc<LM1TQFieXWR24EME6g15iBLFG106RWgYP0DM;\NkJ^YB_ZmHPa8bQ\5X;"
            A$ = A$ + "aX;PRF9n2#6gc5QDLFG104o8kkVbk7J^YXCTMVQ3=83]b[AoI6^k0ag;I8NN"
            A$ = A$ + "W22#e]`j][iV:mZfS16S87bFP^4S^0:JUh;0IL?G4BaIM50#lS\_K:_OXiVR"
            A$ = A$ + ">AfI6>dP<d:_6mWIh^34O_TQhiM:80Eg2[g^VKZd[J?6H<RL8K1jB<j2XXER"
            A$ = A$ + "_0TamLA8WLFoNG`75GG;%%%0"
        CASE 22
            A$ = ""
            A$ = A$ + "haIkD7K3003234<K#fo]=]<0>5FLdR47Eom<VkL2^8i]P012T?Rl]76248#2"
            A$ = A$ + "SDM\5248#2SdMA7248K2YjH;48#P46YkR>48#f4BeaF8#P09<Bg5M8#P\9T7"
            A$ = A$ + "9L;<%%%0"
        CASE 23
            A$ = ""
            A$ = A$ + "haIeE7TS532330egPLo_]SDk#o9h`VR=BUUnEYF;J0PoGam2dB5lT>CjPhgK"
            A$ = A$ + "^n1X3R4D4M###X6R:PjS81ZYn0TGS7C:0H6JVQVKln0UO#PcO=d`W0<eVU]l"
            A$ = A$ + "c0m5I<Ai3^3\1Yo242[?1F8dMd<D3P0X762U[4#1P7h:U_SA?dOKR<hYJc_N"
            A$ = A$ + "M#J7Rg1e0A2:R>888D3A5jVEg5ZYn0TGS7C:0H6JVQVKln0UO#PcO=d`W0<e"
            A$ = A$ + "VU]lc0m5I<Ai3^3\1Yo242[?1F8dMd<D3P0X762U[4#1P7h:U_SA?dOKR<hY"
            A$ = A$ + "Jc_NM#J7Rg1e0A2:R>888D3A5jVEg5ZYn0TGS7C:0H6JVQVKln0UO#PcO=d`"
            A$ = A$ + "W0<eVU]lc0m5I<Ai3^3\1Yo242[?1F8dMd<D3P0X762U[4#1P7h:U_SA?dOK"
            A$ = A$ + "R<hYJc_NM#J7Rg1e0A2:R>888D3A5jVEg5ZYn0TGS7C:0H6JVQVKln0UO#Pc"
            A$ = A$ + "O=d`W0<eVU]lc0m5I<Ai3^3\1Yo242[?1F8dMd<D3P0X762U[4#1P7HIZ4h?"
            A$ = A$ + "eW_m%%%0"
        CASE 24
            A$ = ""
            A$ = A$ + "haIkH7TK532346VKP_ogf^hUB6?f^BiUOfe\Zh_X2SQPZJ4A\:?aW78HEY[:"
            A$ = A$ + "P`bG0kQPP9b0#XnF=;TG3FJG71FjNcR6RTX1544A66\P>m]W?8PL6UjTPgAS"
            A$ = A$ + "S0GO<F[c1k4N^L<g4aPU>ZA0PkYXo#=0TJDAE0PdDdL931H1e5>HH;R467`1"
            A$ = A$ + "SQR3lmV]`1Nimd22bPfGR3T`FC;2LR]iicdWjLlh4b1S=>HH]<Q5B==EH1Ke"
            A$ = A$ + "LES3\]nXnc4#ZN>SDPEoFXQ#OnDaOo_76o3j2B`5_kR0IA7#1FBTda2Mm=D#"
            A$ = A$ + "UlZ06Nn]X?3<Yo4aKQa[G81A\d22k2UjTPmQ3;LZO_:Lffc_El5#NCS1<A60"
            A$ = A$ + "2Wjk^o<][S0jmSeM]g2ABdP22RD_gW26_IT4bIDZC2N7=>2LmaH]>7\Chiba"
            A$ = A$ + "LC43FjX610^WRn3e0#ZA5E10BCAcU<4P5DGhPQ]8BHL07<6:>`gKf27hUgC;"
            A$ = A$ + "883JO9>#2K=]8`9fVW?COZcaSC87<fhPQeb4F8edDQ5\EcE=>`fjSj?C0Yji"
            A$ = A$ + "<B1FmKQ62miC5omoNhoo?L?0\T8YS5jjKXP:iE1<llKAO6HBo9Rg2SG_#2RH"
            A$ = A$ + "Y54f5:e91k37Fh70A2fm%%%0"
        CASE 25
            A$ = ""
            A$ = A$ + "haIkF5T33323;o0noof]MY2GR1bHHaZR?e:Za>4bV;UoKH_Q09^4QZGLSLKG"
            A$ = A$ + "_N5d[P?j_#cnj``\:A0m:gOdKQF[k`HM=P7?3=fDo`aR<f;O_:6o`#P4PFVV"
            A$ = A$ + "bJk#D[IR[Xmh?JQ97e^C7]Ho5lV7Sl3bD63Vi9eD_OoXnUCCS>moHWEcng4D"
            A$ = A$ + "#IdFCSmN7A6_#H[WhW31m0fUjE=BklaIWQk0cGmEJP7EI6^UQ090]<=UefQX"
            A$ = A$ + "FCVQSbH`<OVQSL8J`GQNO6#IdFCI6^7?4d3HGZGe8]c7I6^<3WW5mgG6ZHHX"
            A$ = A$ + "5g4481XUYY\f>4eJb<LD63Vic<LT3A3n:dkc0:SfJ:c`mhQPN0kBmZ6YMn8c"
            A$ = A$ + "`UIhl\Xonb#533]hVP090]<=UefQXFCVQSbH`<OVQSL8J`GQNO6#I`:f?_7B"
            A$ = A$ + "QII4fj78N9iK%%h1"
        CASE 26
            A$ = ""
            A$ = A$ + "haIkD7K3002334T=`kofB9<04YX`UfG:GWC>gjjB:9P0124MV8Ul948#PXh0"
            A$ = A$ + "248#li4cKU7124CUHPC`8#P0aC28#P0AW96h4<248#lT0248#dIRe6#2%%L2"
        CASE 27
            A$ = ""
            A$ = A$ + "haIkH6^333224fg0NoOKgBfbZL09RX;fdkneLhGdD>XTfJ?09_eF8^fU8:T#"
            A$ = A$ + "ld4GkB45R4M77S0>kK;A[oI`_o78d?McCh;83>PbC\?_;eLJo94d:^<2\6BI"
            A$ = A$ + "n;#X;K`Zf?;3[^6S0>JmNn^bN3OV4VGbhd6]<AW<gFm2;`4463Wh6X61eiZl"
            A$ = A$ + "9]19#[_CPZ4n5DZ0CAP6lk:1WQ[>15eFDNWh0=>SjBPdW9A;hga=eVP8B;<O"
            A$ = A$ + "#Am?efN?8<G1WQSc`]H2>3gYYmW##[hb8`J8Ui_0Q^\1[Jko<>CC07]N?OGI"
            A$ = A$ + "_Q?C2c;ILJSFVXCVK[NQ5H22SQCL3DSPjLEnTfP4Xeg9#E2o2:EPY8#3nMUP"
            A$ = A$ + "c`EWPRJ;:_CLP6WAM9#jcTPO7>Z5[G#\%%L2"
        CASE 28
            A$ = ""
            A$ = A$ + "haIkD_T2033240]g0_ogf^[T:Ja1o#ReIIPgVaXGGM?dC:BH2oQ#1WXhmcS8"
            A$ = A$ + "ffeR#9]DH:hR>Vdj=Q1hi8FN>Da:M4Ag^n4LLb21lLkZdTF]_AOh`G3\98he"
            A$ = A$ + "io[0_Mm9hh]C8PWCObYl65JTO<25LR2R_d>R0KG;2UhDH:hR91T:6DQnQ[Re"
            A$ = A$ + "Pg2ZPei^8`KG;2UdBQYP;jHB[g46PWSHii#5[dA4MkjC`a9;4`c][BCJen6m"
            A$ = A$ + "Q3O=`VPPGWo_2lfeWPSg>Q0N>m9WbKDXAna8D`9:8nBk82\M]8DRCQYP;:8g"
            A$ = A$ + "^[L^%%%0"
        CASE 29
            A$ = ""
            A$ = A$ + "haIkF6U333323=g0^ogfmg4>4[YThBeT<ObS:35JU7SD4A<F6J1[I72hJ\0Y"
            A$ = A$ + "7D9?0X#42JATPA^0l:3bC8BASF^]JiSTOm=jM0bOHT1H=R^QRnNC60fo#5b0"
            A$ = A$ + "`1>d6j0I=:ST6`Ra#=8fn9^#SigW?00FJc=hMPYlY3>MPil3X2=0Fm:1]7M<"
            A$ = A$ + "DdUcY0^6f3gF0kQ[2:JH?L_jo`nZ1E?Im>mmV>#Ng0EX3T_aPf#78BPL=f3W"
            A$ = A$ + "m`M<H>o0Z`NhXA735MiL:P[Qm`]5`NhZPR6f3Wm`93Tg=#5j0iK<X=d1R48G"
            A$ = A$ + "Sm`I?L73Vc?P:\7>Jda#AG>W2hJH?LK1\7^:XXQm`I?LZ0`n7Z#60>`Qf#78"
            A$ = A$ + "[AITd0F<6]i_job37VoOg3gX6R1;B;5l1XV9%%h1"
        CASE 30
            A$ = ""
            A$ = A$ + "haI]I7UL333240M_1Lo_]MjT9f2HG9`1[?e;P\\DgVYe\k1n<\dX?HLhoYXb"
            A$ = A$ + "6#f::lI:Rl<P\A^fcAi88JEZ00A[N>HN00LY6`KU[00`UO3<1`NOF0T]:3lc"
            A$ = A$ + "\9Ql5SjP\E>`<A[63\`X=8KeG8fXAS]`j8[RXX=#cFMOf>8P`ddD]C#mFMm9"
            A$ = A$ + "77POjDZF9XD[0N9XGZffh^hZ5GB7HM1k0TBe\^`YCiD5FG`Z0[YJFGP=_>l:"
            A$ = A$ + "?_>E[?le9?`[5:VWf?>XCL4mBEP2^O_c>ZJ3b[9KBLBK4?TJEZC;WhNiiPi1"
            A$ = A$ + "0`57Pm#\E^>10^lKP90fkcd3OYd>5`?cV4bG<B0f3M2eL[AK`hP57GE`VO;#"
            A$ = A$ + "kT>YYEjT\GHMTEEQS1dcF?TOPe0ADgCT0j2`3bOGMLnMPG#G0M1#PH\V[2D4"
            A$ = A$ + "jThlS09ai0H=0Mheh09:j0#RkT#QXXY0EnX6dO7>e#e_70RUjjm^>l:1W2e8"
            A$ = A$ + "W8\Fe6F?dcIGW3_b#li=D#:9:eZf`blR8Z2QGIHiiUE0b;1=`I>`]MK0aMT6"
            A$ = A$ + "27J_0\L5K9<X8P:PIRF=6HaAJ?O2`9P\l[O2bdk1IW8?1_=X^>H;W]BXD[n>"
            A$ = A$ + "ah#::bRUL3b:2[QXE0C1P0MRRTE4;MK[l_>73j459[8]6SMQY2d?:2k1KG[<"
            A$ = A$ + "ke0A<`68njnLWLe93LK\BlUjje;=aY;`FmUS#jmT3ETPl6inUD#N<4O=24[P"
            A$ = A$ + "45MXR8H>00LiWPeMT8k2:8eYNPo\\0H7PhSKjl_=8Kee==;930;?EV9ZH<`B"
            A$ = A$ + "SdNna0LS<[2g>moiTl48Z#T4]45e7b7RdXC8ZHi#WLMHRO?::2a_>#8aa1QF"
            A$ = A$ + "Y08J56301dQGI8n9>3j`[aQ:aMai[35CedPE6j7gmmWTZ0_A>89j8]g2KAnl"
            A$ = A$ + "enk`m7`H%%L2"
        CASE 31
            A$ = ""
            A$ = A$ + "haIkF6U333323=g0^ogfmg4>4[YThBeT<ObS:35JU7SD4A<F6J1[I72hJ\0Y"
            A$ = A$ + "7D9?0X#42JATPA^0l:3bC8BASF^]JiSTOm=jM0bOHT1H=R^QRnNC60fo#5b0"
            A$ = A$ + "`1>d6j0I=:ST6`Ra#=8fn9^#SigW?00FJc=hMPYlY3>MPil3X2=0Fm:1]7M<"
            A$ = A$ + "DdUcY0^6f3gF0kQ[2:JH?L_jo`nZ1E?Im>mmV>#Ng0EX3T_aPf#78BPL=f3W"
            A$ = A$ + "m`M<H>o0Z`NhXA735MiL:P[Qm`]5`NhZPR6f3Wm`93Tg=#5j0iK<X=d1R48G"
            A$ = A$ + "Sm`I?L73Vc?P:\7>Jda#AG>W2hJH?LK1\7^:XXQm`I?LZ0`n7Z#60>`Qf#78"
            A$ = A$ + "[AITd0F<6]i_job37VoOg3gX6R1;B;5l1XV9%%h1"
        CASE 32
            A$ = ""
            A$ = A$ + "haIkF7S4334235UK0goK[kG#SQMAD9:iETaC2aOgc73\o608fX#ZH339R=>4"
            A$ = A$ + "4S0HXmC2f2#a7`G0oLV72kaoPkF8I?n`i>8M?n?0^10kI=;l<]`g=;lK\5^E"
            A$ = A$ + "HLJSQEn3BJ0UgIL24NgG46oMhI``]8i`X=E8PeWWJhJ1ZQ[3Dl1D=L9kE3gO"
            A$ = A$ + "SJh:2;L[`hdF=L?0ZQ[5X6^o0e`e2D3GM`?WiQ`Ne`U3Pm\6e`E4FhFQaY]J"
            A$ = A$ + "hN0D3G;#=Lo1ZQ[5X6^jPO>c3QmZQ;70kI=ZQ[8\`]2SCKe`m0X6^F0]6^?0"
            A$ = A$ + "U;8^%%%0"
        CASE 33
            A$ = ""
            A$ = A$ + "haIkF5]K4422do0nooKK_[g238X`jjUnPGJJd<0cjP>QF[A_nenl[KcS0#On"
            A$ = A$ + "e]a0hooAI`K8:HS1XaDQ[7U1_Ql3j_=OnLTbnkZgo9[eAiG:ZKSi8o>M^\8M"
            A$ = A$ + "_81S2cFEg>09QF:>J:>hn^Sl]O>leZk`A\FYPU=<53kiHDQUBFKSjjP;eU8m"
            A$ = A$ + "JEDQUjKl6l[hUX1jRjA00I=i9_PjNe>dDaQifdZ0`eEO[DnNBNCd20I;e5E_"
            A$ = A$ + ">5Kf;:O7^o0`^B[14n_bmIGL4YE[aAenA47[i`I0`\ajRW8:S3g80>KKM1A3"
            A$ = A$ + "bnANW[Z;ZN?T37VAGf?__KmCNIe5KJYLhZkRBn1=`Qk<3gfi`G[^37cLhZjn"
            A$ = A$ + "LVQc^I30Q>L;10bJbCN1emZMXYR3c]YE1P[[nFYlmTlVX50bFZ;ZNM:f\GDW"
            A$ = A$ + "IhRh8B[FSSZmS8>FcQc0PISe5?AD67^A0LfWIh^;#mCNIe5KJYLhZkRBn1=`"
            A$ = A$ + "Qk<3gfi`G[^37cLhZjnLVQc^I30Q>L;10bJbCN1emZMXYR3c]YE1P[[nFYlm"
            A$ = A$ + "TlVX50bFZ;ZNM:f\GDWIhRh8B[FSSZmS8>FcQc0PISe5?AD67^A0LfWIh^;#"
            A$ = A$ + "mCNIe5KJYLhZkRBn1=`Qk<3gfi`G[^37cLhZjnLVQc^I30Q>L;10bJbCN1em"
            A$ = A$ + "ZMXYR3c]YE1P[[nFYlmTlVX50bFZ;ZNM:f\GDWIhRh8B[:`1EgQ;U;:0\eIh"
            A$ = A$ + "jO:fGZd_?T_KCM1A3bnANW[Z[_lIFGc_Rch76hX?%%%0"
        CASE 34
            A$ = ""
            A$ = A$ + "haIkH7TJ343445]_1emof6<6S=Jj:42oi_bJIm0K4B]D[9cn8Ulo3TM:\`V4"
            A$ = A$ + "JhZ4NhDbM0YUC2YUC2YUC2YUC2YUC2YUC2YUC263QiQ`jQ`n:Qj3QjlI:27<"
            A$ = A$ + "CAhPI:27<W3NhB>omi;idmU\VcfOUa_kWi]957DGLhPjV<>XF\`1_;DcM195"
            A$ = A$ + "Q3B:27Tc1?L9oU`1;i?5>H=oQ`1ULdQal#Im#IOUBmQBM^biE:WkZLoQbmP:"
            A$ = A$ + "gW[dGROOKToO:mkZdg^bk?DN7Ubk1oUV]0QNcFP#_I;#Xg\58dKf24nnMhnk"
            A$ = A$ + "P`jQ`n:Qj3QjlI:27<CAhPI:27<W3NhB>omi;idmU\Vkg?gg_3gFnmnnSJa2"
            A$ = A$ + "7l^#=g5TD4>8Y8L#>7l`UlG27\ToDhPel727DbA76c3Ue3UmE:e7:ei:WGYL"
            A$ = A$ + "^[bm7:g3ZLO^BO9gGoEo0l\f%%h1"
        CASE 35
            A$ = ""
            A$ = A$ + "haIkHVU333324=g0^ogfZ^YfJ<fJ6SW#Ubl9hGn`4<;77gUmB7ME?_`4f75O"
            A$ = A$ + "nOL^4A;CP;H2[A1Wo;?[ClfCTM22_S7n2<W8AP89#0NRDB2<P`[mcV05hBNE"
            A$ = A$ + "d#;:AICe`8bmQ<1?_VLI20?kX0INU]7A\Sf?l49e6eYC\ok:cVA\J<gJd<kh"
            A$ = A$ + "4]fc?7dKM`WbXN;Y[E9=gEcZ144e\j<1aUlZT1:6R2Vh`AXHVC9c>[H70BfU"
            A$ = A$ + "QRMb8IgBWNSG9AXh^b\#V0G`4FS2>_UiOkK87dk`Bo]T^^24912#Q[OP1Dfj"
            A$ = A$ + "iX0Gb[R6Ja7oXXYJhS3Vg3I:VM>gb44=a5IWQ#a>IJL>a8?aOD[J39foMUIc"
            A$ = A$ + "8F=VK=JVMLRFkiW3j]>hCID_UdeZTVkZIe02RJFMVPhBNEb053A1CLh8D<cY"
            A$ = A$ + "TIWE\309kb#a>IT\KY=ghe=0\ic`%%%0"
        CASE 36
            A$ = ""
            A$ = A$ + "haIkF_T3423330=g0Oo_]c:ZXY9KH\=OcBoZDQfP80kZHDH^408Gl0EKA\2P"
            A$ = A$ + ">4iL5#<7[1be7L]P`14TQ7e^h0^L]MO`DPF0H;#6PAA7FfKn#ANckmAQdUT4"
            A$ = A$ + "`bTK6>[#E_0O`A_[E`agiknAS#8mHL_PRLf#E>IX<W9dD];W6Hh0d#O`igWo"
            A$ = A$ + "bQd:40H[d10Ia14\QYZE40F61[Mci1]_PlPUlo4>YNGnPS_c77JQD8E?5`ao"
            A$ = A$ + "cm<HG`5jXP:hilbb5oU[en3V2d20K1b0<:j`bNc7:bKN_?:T^TT0FV>dbhQF"
            A$ = A$ + "V?dA_[E`agiknAS#8mHL_PRLf#E>IX<W9dD];W6Hh0d#O`igWo^1TFR0089l"
            A$ = A$ + "1P\h02f`De:20bCJm3#a%%L2"
        CASE 37
            A$ = ""
            A$ = A$ + "haIkF6U332333=g0^ogf9a6E5AcD2hd#D]o1`?nP8J\\8OeFCbI14lSMe5;#"
            A$ = A$ + "dl;7#aWPT0_cC9N1a_3ngeoW1>^O[1KG4DPaO:X1GWE1moVQne;k:claZYDo"
            A$ = A$ + "OD=`<f1W#Dbne^GJ?8[m2h0FVF#P\?IP3Xh_bIDJRMh<3RO7<`N#7?dWhd7h"
            A$ = A$ + "P1hIH;HoZRUMalAkRMhL0H7>G0;C;8#fW<`1DlGi<:=a>LV1a_32>SZ7LW6I"
            A$ = A$ + "n1N6FfQK8#aWMhRE\3W30k`i2HIJ11bnT1>PRo:WAY9fQc<8nM#`IDmPkd8c"
            A$ = A$ + "?`c`b>L31:n\3G\RMhL0VD7^AUP#2nPl%%L2"
        CASE 38
            A$ = ""
            A$ = A$ + "haIkH6U[43225UM0koMk;IBJEh2J1AnjiG]Lid15:d<<c4^hO[;:`C[;A`l2"
            A$ = A$ + "TD4TfjTO82G2Qd9=b_KCA\f5#=>Q`8NNJY6WHfXMM107WHTYLZmT>UShYhc:"
            A$ = A$ + "XN;n`ciH4?oVK8dV3BHo^RP`C80A7[MAEQ2FiY;#LDic:Ri2n?oJ#L25Ki=0"
            A$ = A$ + "daRW]38`cdbK8Kl0B>VHe>5fFfkeESkl9PR_QJa3jY_##W#XEl86<Q9#1GRd"
            A$ = A$ + "2]LFMkL>iD9Fl7geakP>?P]?dP4MdC\UNk_VPldf9>OW8nTcS8dV[W`CX2R>"
            A$ = A$ + "Fk2gS5RWX2CL]b7F2lLQ10;L:5QlB[PBkGH2MlI7Dj0<41N>k1LD3iM^8^?1"
            A$ = A$ + "1\GWbD#1KN2R#TgUYha4d2Pb86<N:E#LOQ6>[Z?W35FCnQ8L94BWd8LjgJ_N"
            A$ = A$ + "_T>j9fB_mmCLT>US8nTc44?oVK8dV3Bhe4NR`C80A7[MAEQ2FiYooOh`PBbF"
            A$ = A$ + "N30M\hIk02l<]l6b6?PTS9F]CQ]UmNMeh>O2XhKXFlPNj;4d94J5?R1CH2D`"
            A$ = A$ + "U8]#;WEg>WC>ERooo`iAdA?aFj]oJ2bCKWhlMRhC>?R#K^N2?Q:8jH];L?F8"
            A$ = A$ + "NR:<ae:OH9`c560\`YD4b;]2:]OQ9daWM#Y3`#4hi\7`A=TgiRhn44`NM:C1"
            A$ = A$ + "5\i982ANGVR7C#;0:SHnk9:Qh?0\%%L2"
        CASE 39
            A$ = ""
            A$ = A$ + "haIkF6U[53224eM`\og]_g7RPXdNEAR=AoKba9E74BCYD2o_BdB:L3PlZAh7"
            A$ = A$ + "0`#h;8oECe2=HN7#4IE2=#^fW3ENoIM\BFe_2f0X=?^S#Nk6A?H:RI9giE3>"
            A$ = A$ + "_j705a`>TGC[6WjM=USBIiT7bL8>fNm#>D[g[46D4CiP?3:7N1RX?Wb<J95O"
            A$ = A$ + ":#0I5PQ`G#n[VZ5J`l>P8bNYM^jH^977bHYUM\BFe_2f0X=?^SklZC34#F1H"
            A$ = A$ + "8l5`G[W05a`>TGC[6Wko`5ZS]G?T3ejm:Q15aD>hcPbQGP8jcY<SFBaW24#F"
            A$ = A$ + "1H8l5ToZYJQ6<_38R\GJW[>VKbaQ<FJI7[TEm[P=0JcSkh>_jd01TE062O1l"
            A$ = A$ + "ej9#A<\3iedZain?LQjHke3i#]N_BH#A<U3n<XLh58RnL:cXUDlY01TE062O"
            A$ = A$ + "1i_JZFX1ck0R8kUfiZSiVLL8SUFfa:IEo:H3Pflh>^c[>=#0I5PQ`G0O]N2D"
            A$ = A$ + "43k#N=]JL^o3GX>fNm#>D[g[46D4CiP?3:7N1RX?Wb<J95>1n3`Q%%L2"
        CASE 40
            A$ = ""
            A$ = A$ + "haIkF7K3043244lk0goMkWj2h0QA3Y[4CjMn^^cm5<TlG#N8T628#DG01R`1"
            A$ = A$ + "8#bR\Wm2#V7B3148Z;P0Ah048IAfcN18c3YQ024e5#P8L02T\8kI_0TiQd#0"
            A$ = A$ + "1Rj28#4>01BFTO0M%%L2"
        CASE ELSE: EXIT SUB
    END SELECT

    origdest = _DEST

    v& = _NEWIMAGE(100, 100, 256)
    DIM m AS _MEM: m = _MEMIMAGE(v&)
    btemp$ = ""
    FOR i& = 1 TO LEN(A$) STEP 4: B$ = MID$(A$, i&, 4)
        IF INSTR(1, B$, "%") THEN
            FOR C% = 1 TO LEN(B$): F$ = MID$(B$, C%, 1)
                IF F$ <> "%" THEN C$ = C$ + F$
            NEXT: B$ = C$: END IF: FOR j = 1 TO LEN(B$)
            IF MID$(B$, j, 1) = "#" THEN
        MID$(B$, j) = "@": END IF: NEXT
        FOR t% = LEN(B$) TO 1 STEP -1
            B& = B& * 64 + ASC(MID$(B$, t%)) - 48
            NEXT: X$ = "": FOR t% = 1 TO LEN(B$) - 1
            X$ = X$ + CHR$(B& AND 255): B& = B& \ 256
    NEXT: btemp$ = btemp$ + X$: NEXT
    btemp$ = _INFLATE$(btemp$)
    _MEMPUT m, m.OFFSET, btemp$: _MEMFREE m
    BASIMAGE1& = _COPYIMAGE(v&): _FREEIMAGE v&

    _DEST BASIMAGE1&
    _CLEARCOLOR 0: _PALETTECOLOR 15, clr&, BASIMAGE1&

    _DEST origdest

    'tile the image on screen
    FOR x = 0 TO _WIDTH STEP size
        FOR y = 0 TO _HEIGHT STEP size
            _PUTIMAGE (x, y)-(x + size, y + size), BASIMAGE1&
        NEXT
    NEXT

    _FREEIMAGE BASIMAGE1&

END SUB