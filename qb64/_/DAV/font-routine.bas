'=============
'FONTPRINT.BAS
'=============
'Clean looking built-in FONT to print larger text.
'Uses built-in font sheet of a monospaced font.
'X/Y, Font Size & Color can be specified.
'Coded by Dav, JUN/2022

Screen _NewImage(800, 600, 32)

Cls , _RGB(0, 0, 64)

Do
    '=== generate some some random info for testing

    txt$ = ""
    For t = 1 To 6
        txt$ = txt$ + Chr$(32 + Int(Rnd * 90)) 'make a random letters
    Next
    x = Rnd * _Width: y = Rnd * _Height 'random x/y position
    size = 12 + Int(Rnd * 112) 'random font size
    clr& = _RGBA(Rnd * 255, Rnd * 255, Rnd * 255, Rnd * 255) 'random color

    '=== display on screen

    FONTPRINT x, y, size, clr&, txt$ 'show text

    _Limit 24

    'fade screen over time...
    Line (0, 0)-(_Width, _Height), _RGBA(0, 0, 0, 25), BF

Loop Until InKey$ <> ""

Sub FONTPRINT (x, y, size, clr&, txt$)
    'SUB by Dav, Prints text using built-in Monospaced Font.
    'x/y = position on screen to print
    'size = size on font to use
    'clr& = color of text (use _RGB or _RGBA colors)
    'txt$ = the text you want to print.

    Static initfont, fontsheet&

    origdest = _Dest

    'only do this once, first time...

    If initfont = 0 Then
        'make font sheet
        fontsheet& = _NewImage(3040, 64, 256)
        Dim m As _MEM: m = _MemImage(fontsheet&)
        A$ = ""
        A$ = A$ + "haIkLUVTdSK[lk6Xko]eQSHjZ89b=B9E;MCl3?U`BR49YDSaQO_om_]]]]]]"
        A$ = A$ + "]]]]]]]MWfASaM522na]a\_6E2#b_2N_]]]]]]]]]]]m>]gcbNGanmD0X9?3"
        A$ = A$ + "i2cmKdnFV_:;oB8nffffffffffffKdNCoGim5\O_00JfC#^\Do:]_Ui[`c_5"
        A$ = A$ + "R_]]]]]]]]]]]m6]gd:C_lmkWI#o]_6iGblE><WhbaffffffffffffOEkM]a"
        A$ = A$ + "dig_G20=oLb5U9WF;Fn;a^G2NIcO5X?3YMZo]#_anoVJoKg>klo^[OKKKKoI"
        A$ = A$ + "]h]L8a]UoYom9g0lYco_93XT_4iml[QSIi7cnmO^g>IOOiJhMlG_BQ20nUP;"
        A$ = A$ + "kZcQN2hIH[_V#GFT`b^87;Z3oDn?#6elMaQ8BmE944`#UQBTCF?=UBi3YIVO"
        A$ = A$ + "LGOhT#Z6gP<JMY7Ic0PEBRb4UlMShmboTdhWU1LhbUb]mIHi_IA2j:?4NH6c"
        A$ = A$ + "lbO9<^HCCFVoK;bVFnG4elDRK<9ANmiSdY^JMnkVG30UO>#_Q8lCmZ?1mB^m"
        A$ = A$ + "4>NX\<Ef5VU[L>7=JaB54G>\1C^OO#8_3m8FC=3O9Nfm?3g_O2Y1bUk[NDi]"
        A$ = A$ + "IQP\a7\U=>a<210hl67N`WQoFKZT_G4_Gn7UG=Y4lGQgKkkabOe27cFN8lh4"
        A$ = A$ + "Z\S2A=<^hA8<XW[?K;aVDnG4eIB9^]T4ieW?#WkReY_IN=0DnI;dU3HnQ>ac"
        A$ = A$ + "Jog^#KFACakNoNkgOVHkIL2C]OOBom>X<TdX<lUh=cnmS:RD2Mb[H\BZgE^C"
        A$ = A$ + "LOV42adh9kgG5hN7b9F?0o;bV;kK4a57PhTCB4Tc<UMiBifn4\hG^8QLU?7l"
        A$ = A$ + "Uh8jinklVR7#`0OJkgFX=Wl?5ZOLkgW_fn9_GMfKVWnVmcRS?OiWi4?#n5Ni"
        A$ = A$ + "9Jl`#X;5<B2BJ8?8;I2fj=9#2OHn6J9Xg1SP\953WkI_\gkRZ8J5<ENG\NGi"
        A$ = A$ + "aogOU2#RnL?kg3VHc0l_8K^\_A4GL0BC>2E#BCEfE;UKk3`BOkR5aFN6l\mk"
        A$ = A$ + "adk:g_gPONogFT=Wl_:\CUBLC99:ZO>X3bCb\ggnm=57Onnc?;M^b4aES`k>"
        A$ = A$ + "AS7>9MYMAIYbX7DM>lOo1n_R4ZNCLFm^<6SFjWQ02U\;3GoTh9FOo7?d42i?"
        A$ = A$ + ">JnOo`F^^NFko950NakgCEg>_<6=B#[nS7#W=Ijg6R[>1Y9WP:Ze9h_Vb_]_"
        A$ = A$ + "3;ke[T8hjc`_??;llUdBJNGB[5NoF`bfPnMEZK#QV[>[g4Amc1M#NJZ]<4Wm"
        A$ = A$ + "NMCa1W_?oSkP:VKon6gbA8JlD]8Z6i54#<\jhe_oXkgkK73ARW:UVSohXW_N"
        A$ = A$ + "Cighnm]^#U[g_WB#4lAjWfV<mK3aEWPdTC#5ej4lGCioEIoRWm^ASM:c?nM_"
        A$ = A$ + "OjR31bS_H#2ZN2n5co]UI3bgU9_1eI^j\NCDeWRmY_EM^;VWmNMCa9_ol8F]"
        A$ = A$ + "2mjm\?0=lCf06<4CNnNckg3T\JoRZOV`X60HcOPmk3WOj0NIe3Njlkg3BX]N"
        A$ = A$ + "Dij=6<l?NoN`I9dV=oK2aU7QdTS#5TdDUMeBigSmkMfI__1c181mn[YiRkj1"
        A$ = A$ + "h57l1a<ESh7VP^WokJ7?n?V\^Ne;ljadh>E:amTTXZnD\?mUZcMadE=hEWJl"
        A$ = A$ + "b?YOOia3e:#:aoi2en:jZ1P=NjLTef5DN1Q=HLiJimS^lmk94^<ED7hncTCl"
        A$ = A$ + "nmeZ=hEjhXS:WH24la9ng?JbjI38MLP8<FMaG=QfjAUCY06_5Woo5JcVo=Qh"
        A$ = A$ + "2<Ob^UT70\9Hee;UO?f_gIOLb4gAPB0kmi9`_f4Jc5_513AZ6`W`_7Wm_8m_"
        A$ = A$ + "OkhaOoHQ:1oiTQ7G#N3:SVBL;99:[?4kcOYjDG<UjNhKOUO:NoiWOG;1X4oD"
        A$ = A$ + "2ZkegF5CHkSdi<gO=Xl228HaiHJd4PQ[MQOTU4n2f_?]A9cG5T`a[P`Ak=?D"
        A$ = A$ + "6;>oU3PiZWFNlOodk5?o``3J54d3N10?e4Plm[MonK[KAiECJ2NMmBigSmkM"
        A$ = A$ + "f7W<`TNdIjbI_?cRKkaTgo3O3#\?YQooR_:TK?4PiE2YJSL\8`CUBL;99:[O"
        A$ = A$ + "V;`1D`b^e0AXk703VCiWRgOniWTB0407C_OoHSKOP>Y<obMBd8#U>Zn#g727"
        A$ = A$ + "_f9J3<mW#lIko\=:1O06QSGE?3g__<o4lZML]jIl]<BJICi5?oj`og3`BJO6"
        A$ = A$ + "d_^d77?b#To9\Y;hN#LIJ<AQ9IEPJ>l_HYlkanm>kSCVj=DP4`cV1W47:LYS"
        A$ = A$ + "Ad6NPaUl1DNhBSnUNo0H=col_F<D#heSi1NZDRK99AImQPO1gOFEjJZE_JJS"
        A$ = A$ + "QbZlcEf_70ohm=B#hnmmDQg3QKITXmki:7EO2onI9nHK8WGlnkR7foIKD2n0"
        A$ = A$ + "<27_OBYL>L`l\jlo?8J;OnA[G;K:_j68X?ITJ[0d_>0?09`b=bV^Pk1aUYae"
        A$ = A$ + "coUao^YbW\mkMfI_]2B191l\I`1aY_5WIon9CcdA4ZT>Mgg?nD^oe9QQbnHe"
        A$ = A$ + "5dZ`S[L2TW9UhI#a=c>BA#7#QKbHjn1c0YEnibkg3X#LDfUYn^=gaXj8\;FP"
        A$ = A$ + "82S`l#iJHmGonmVh\2L0AB\m944QSg84?:YNbhT?ki34olj]h[WD_GM3`bco"
        A$ = A$ + "mP[RSaHSi3CXTi4O6Ln:^54GV6G?oG6okV:Obf_gIWmf:85T4`c>]Qe>\`nm"
        A$ = A$ + "<jIK^YS:bRPf#cCHO8G07>TXg;deG`[f0BScANVDRW0BR9ghSP>P2gTIdmZE"
        A$ = A$ + "cZlC1\?2Z;_1Sj_kj``?79oc^AV0<hn8c_O_iS9mNTjG#mkmk?##lXTj1SCn"
        A$ = A$ + "\W?#lc[gR_NBmNe=#4U=B?e?89JTg3H2X<C]i[hF#LIJLmlOIl_KZl9KoNWM"
        A$ = A$ + "mkg?M5_QYCZ#a5OO8[[QOIXVVYS2bN9kgO8<LVcfQ;eZdSCH129]8eo#21dO"
        A$ = A$ + "]JKc<dKJh9Bjn<e]JimCM2bS]716_#1X#gCThUFeaV7o7SC0YC0IP>5kmkM5"
        A$ = A$ + "h0RTHcC#427_o;Wja#mTa9ODn1CHnj]hW8K:_h6P7hAQ1RiC8PTXY3S=3CfI"
        A$ = A$ + "n:HN9YIbbCFn2<oT5NmhO_Di^7dVVXJoEOnmaKSC6HBkO_NF03Ro`5?FF?Wo"
        A$ = A$ + "O=0C7AhBjeBg?>4fBChMJHbAY<7RTV`jm9Pnm^OOdMc4:L?6FO17^dWQGPUW"
        A$ = A$ + "K?lO0ne07`?ed2`W:hD3b9eaT86#=PI0KKeG_7UlUDoNonFM_N<D?ILb7UO`"
        A$ = A$ + "4V_NLl5oc^8_3nT?>:<J:ChjCgjYA6U4LTP^Z9IDAQlWOIRYY1Dl1lGm=HaO"
        A$ = A$ + "m2WcX;_6PofJc7[kn6M0o7Y8]Yl9DLnPj?mS?lnc4#STZ`T5fLK[cS1Oj0Dd"
        A$ = A$ + "Wb5P>lZ`b=b<YRo`S:FB?W?=C7AhBjETh#I4o0JZ9l6=:ej251B#GXMOMX5Y"
        A$ = A$ + "T;]h4=UW;=9DhN<\n2?HkMY_o:?gjcjIj0:`Onak[X6A97o?2YT7O8HNR>Gm"
        A$ = A$ + "QEG<[leW^0L>nVh\2L0ABliCH027_1<NFBmTa9O<nQCHnjaa3obJRl<hSd_J"
        A$ = A$ + "`112#I2E73[O735VGnCG:l=4X;PX9Pb[cV4n2nHn3?_`SVIj6M503`7OWe0n"
        A$ = A$ + ";_OP[W?PlmkibDRn`B#BIkkGSL5Pi82m?K`W>0l3L4R3:Yd#R8<1T7^JN^Nb"
        A$ = A$ + "cSkR#foXkgC9F9\7UTf4787kggnmAho>?Mo7kF]dKO:Tk_Z;6?ln8>]IlWmo"
        A$ = A$ + "1#<aHi=M\^#`l44XhJ`A6WgkgK03IX4ng`UkgnnmYOImZg_74L#P4K9ahVNB"
        A$ = A$ + "b;g^O=i_MRC`2Q:hR]oHD_SiWBh45SO423`GcIc#G0nIP0SBZ?FoZ<\00_F:"
        A$ = A$ + "hBAYeUZO0e7Pi80m?K`W[>gnnmC4WZ7QM]>D^4El1Znjo=2Njg#01eiW#b^n"
        A$ = A$ + "J<:]PYh`9X?C495KE:iB[PM[dh9`hV]Y^eejdLoEM_hQcO23B[FJa3X[d1T6"
        A$ = A$ + "fTQ8FG8QLYnOnQkmk99nh9BmQS7b#9ld35O2o89<Om3N:<>BfDN9=0G`X^X7"
        A$ = A$ + "I2=?><9dWUYJ4oXaYYH2kB84L;n\XdE#E2787BgDjO2iOTgdlO8jJUgTa??="
        A$ = A$ + "G7<X;5U>Glh8eGMVPkW6O^l#700P#LI6_NFl6?bYaA\UF__hDoXXK9<PC9eA"
        A$ = A$ + "4Q8_<SC:FJbDB#P7K2NC`HV0h<3m>C2ghnmdQ^VeHR<A_a[kn[h:MIoNjmNF"
        A$ = A$ + "c7XYB03^oXBh<GnNfj:76XEI#Ld^6O>0V7OLlR=;#T4Ol4Yn`aSb`ZCWlAhG"
        A$ = A$ + "]UW\Nh8T:K:_\6H2n`?0cA=TA>eD`RN0=MdFDF<nE]O_QPd`\n[D>AkA?APa"
        A$ = A$ + ";n=iiio:A?b?OF[N3jBAYcUYR^XTCQQLjacbXdaG<#8N`<P4i2ghAXV8^ScH"
        A$ = A$ + "B^ekM<WB=df48>WaRDoK\a9=gUJjiShSHadNZnWS=>AKi1=hV>NYW99[b;_["
        A$ = A$ + "?n=Wb?;40]mAKATD\n2^QVL9F5o<GoNfi::74[F[3KR7=lGFoiM848BRW4fO"
        A$ = A$ + "Rf1AK9Elk1\R?VO05I]jY><j7>>bkX?9O7e5c7:8D<I48Q?8V9lYg?d]1Z<J"
        A$ = A$ + "0oO7kg;`P4UC_Genm^4RS3N:hl[j1;YTGP7O0QIkSDdXOPHf10<#mAZ1091c"
        A$ = A$ + "2fOhGKa51;7UQVJfbAbAmmA8lVaf`#Y]JMWcVTcjdUhhjd5<o[A\P4]e7dPk"
        A$ = A$ + "ilUN_K\I#]7nf`oZSch;8A<X07BTPZbXCoEdf>HbIYXBk9kP7383D[3KRW#l"
        A$ = A$ + "I9dm<81FmOIkgG?S2egBl3ClYg_?L1OLHTgAO]?;XCEY0HB8H`4`RN#<BS59"
        A$ = A$ + "Pk3YJFmZnSV#6k#g_Qlm2g_G01;lCOXOU`OV00h^>Q\c7j14I8?PVDD`mK<<"
        A$ = A$ + "8jh#0Z8P0WL00346HX1J088E]4aIl7W`<L;COPY#3fRA:on4]iI\X29#_2aQ"
        A$ = A$ + "2OLOGIbV9S0:<Ua^jEK6Dl7LnhaaDKN\>5lkn3nGE12^hlOQ3^1ZKb2\KUmk"
        A$ = A$ + "Aej`Vhad0Lh?fmk3VODhlmk7oo=<Ea7c_ZL\Dm`kb3JPNoH_GF;Qi?:;\o7:"
        A$ = A$ + "UQNilgLaQY_hm1Ah6V^MQ#195SUUo<Q#:NlLJMIP05^DmPC?oe?J?oV=ob7Z"
        A$ = A$ + "9Y7<k\0H2jS>8O8:JkfojEO2IEeCWD5`:i#gnND5l[gV91Ika8HQ7l7lXP4B"
        A$ = A$ + "_?BK5nB[A2e[#K<G=BAH50lMh>VMimcYg_WFoH>6FP3l\d9_6`VXB:6X3QHJ"
        A$ = A$ + "[QLENj>JbV\mnmJ`jol2HT>mnm<18]nA`P3YJHaa#N;nJNV5KRmkAT3McIRj"
        A$ = A$ + "A4R\o7ml1S6OP3?oD>W1OG3^PmkM8PRghJlG3GI9hDRKWOSn?F0<1cDU=k\0"
        A$ = A$ + "j1PCo1i[ZH`E\IjGjDTGOP#=>\TXIO]KXVN;?1EgY#XSn83Fck`8RMOXfJ\E"
        A$ = A$ + "M28;iVU6J32k<WQN^Kk`M<lbkWc^O?_nVWPC1[#8WVmV0OT6BY9ICFc7=QP`"
        A$ = A$ + "n3T0X4U0>dS6n_]mkW5f7AKA0<Be5I3eGgl_HmTYD<]h#8_5O=>haZoPA#0i"
        A$ = A$ + "jB#776UCoJMhhIXE14D_Jnmhki76[4mA2V50D2=^6oe1[X3MLllOMkgWloOS"
        A$ = A$ + "8JfSV?fSPT7T?aO4#a0al0[Od7_N_#Q98L<`Pj7M60dhFbI;GT0UM>6:4a?:"
        A$ = A$ + "K=fR[BRe;AIXM8Xejc>oA[]5gad;_YRhWhK;20JNR<5T:KMmO1h<D<R0:ECY"
        A$ = A$ + "lK8BjnT`8637o=Pne9a95eh40HjT^momf_W<OYlkRZWZ:da571i]h[a1U]6:"
        A$ = A$ + "Zifojeoi3cYO]\NT<`2J[3o<=mRaoGonmeh7U7PET>EIoemT0H2T]Oo1V#7M"
        A$ = A$ + "VT1RY1FoXC^Lhe9SF262]FEQ\8238BEYIg_g]P_\fN4<XoAK[`Gi1PYVkEHX"
        A$ = A$ + "]8XgVc>kA[]5gahO0OE2BDXgFWR;a=?YEHBY?o\7jK4fA4D2\5PWZ8YkC2SH"
        A$ = A$ + "<LlgUPmC3<^4L7R2mWV#gcHQfd1:ASV87^6HO6mXlCB2hi;VO3i_Fm:MQT1>"
        A$ = A$ + "0bKagC7PdI3hTkgKn2_YH>m5<>1GCi`?G4YYCRom_O__NaLmlW3>G#okM5F?"
        A$ = A$ + "WV^ajhYa7m[KonalOnLoo4Om1A2=n8#T3070[:58TS3Q]i<jEnk;>BhT_bO2"
        A$ = A$ + "ST5D]Q6]f:inH]iI<]29<_6MQfSPVKIX;1G?^SiWOI?Ko[FW?o9l2^M8<_0l"
        A$ = A$ + "ON?JoWAChoEA7`]ES8;4kcMliI8\kD7Gmnmae7`N5l<0M=RThSW8eW=Nm926"
        A$ = A$ + "Yo=NolTkg;hW_NS`Pc170iUBYeg_?PojQ;Mf;09H\_[oQf_?XLaLmlW3>GAo"
        A$ = A$ + "?>Gm3^\cEddCC8V0TiiicmoCanUB:8V4L8>Q8e3#6>YVL:gD`=WiPon1Q4<b"
        A$ = A$ + "=jG>4ZP^9okd4gkV<M98CdRCHjc^OSkgWg78mKLf6N8eaG7Y\Ye8\jA\#eh1"
        A$ = A$ + "JMhffRan]hUPU_P28f2ko5Q>bS1PYag1?3#GS89nhY3<0ISGORP3To=LklTk"
        A$ = A$ + "g[hW[n0Y1UF^l8X48Ml0:F?IUmkc:5e51S]MeG^l[R9CW3omnmCGoP;kL5=o"
        A$ = A$ + "d`N20W7#bmocC^OOn88I;:C0d3LTVA9;^JTfUJ5HJ`T_ZK17TCXOdE82\Iaj"
        A$ = A$ + "V\9HT<E92_VAfL`6D;=]0A:9\T2gZ9O[iOm\OdKl]GJlN0oaC<[QL]S]3U`a"
        A$ = A$ + "Bg9?SHDTlmZZLd[#BiDF?=1CmVh>hI0jJ49aW?Q18KlNnc1WX;#6i3c?#Y;F"
        A$ = A$ + "OThL_kgSkXPV1SPLlRZ4f4#Q]^LRZYlhon<[?>lOekg?Ieo6f_?B2X1m4``g"
        A$ = A$ + "7N6nW\m#=DP>4\jE\5VI=P]B:?>DFBK#i2[g=neo05GXoK]OOl6njddeoJ6i"
        A$ = A$ + "59GC:jCO=:9QUDhF=iK=oKPm3Nc_lbBhQ[^O4cjNbFjA?D<PC^QjI4SRakgk"
        A$ = A$ + "o077MPW`3THlM`c0de8BR?OZLZ>ahmlW3>_nmk]S=InX8Pa;XA<_L:YbNPTb"
        A$ = A$ + "oM0D4OZQ21>Ao`MbYYVboe]OObN`0O?oiPc_QmkCd0J8?1jn`D=maVcH1WM>"
        A$ = A$ + "mD?1<fBAX6`A#NNdQGPCGHD^`jMbZ[n><nS]OOd6n^DdSTOT_2mPfT#1WcbX"
        A$ = A$ + "S\09`BQKcT_el_19J`k4GNaIldCg?RIm0dU>dg<9Fj>iI4QQ\m51ZAW[Dm<^"
        A$ = A$ + "Qfj=aM`c0de8BR=?1A8KlNnc1Wl;#DlYl;HJDe?fI3PGinmS_j0kG77_YmkE"
        A$ = A$ + "a`=A<<^^6Dn__mk5e;V[WoL`iGanm1G#W9#aES3Nf6:8hVmKPMek60KKZ1d="
        A$ = A$ + "#U8KhCJ4U]:OWIoN3cR6N>VfiO9l_<cL^H?fT7Yi4h40X`85L=0;GM>4_H[i"
        A$ = A$ + "<]Sl3NmGN[#FOSki?oi7YlK4je^[4LlLRmk9TSZ6kmk7O2N`V=N?n=diXF[U"
        A$ = A$ + "?:o2V6EmUF[1l3JonSR594PjEa`m##7CGC:ogcnm1e;V[WoL`iGbnmfof0EM"
        A$ = A$ + "B>ONj#TmXaYWR3dY=N0X9nkHon0Fcj_QHA3?5Ckl7Z^gW9>Il7JGenmWKnY#"
        A$ = A$ + "4S=9a\j3DX0:l:]VCe>boc3YGN9HfiJhWAZA?DY<#2fJA]DT9#<eh7G^YY6g"
        A$ = A$ + "g0MmVh>hI06O\dWHkC88b6_7o6jLD[eb7WOnYAFoH[SADh>DbjVl3827_Pmk"
        A$ = A$ + "3R=f31M<M=YlhK]\lLhojg_W30:QRD>hl[IoNcOMP:>9W??1E=^36WL2>HCi"
        A$ = A$ + "ff_Wg0EVTIGRDGHUPRji9f_gA\\YW2ZKnSegkc8LcOTMM[goE_O_>]gmY;bJ"
        A$ = A$ + "Dm>^oc3YGN9H>PfSOoc?Big8d[YTjj>7ZD12#g>G^aQYVoVg_?hSe3QOlKXc"
        A$ = A$ + "BcTb7WOnYAFOYgY8:LSl:DA54nmkSFRW7A6S1TT>kmkc>KhMX8U3>oRf_GnW"
        A$ = A$ + "7XRCdic3?8D>`V87>9VQVT8f<[1dUabl[MoN5_dSn9<GgO=Fmd9h0kIJG#W?"
        A$ = A$ + "14GanmTCi`bOSgOFcJDM`YNk3UOVPI5POMkgO`\QhPBHaQhCmH0HJlM`c0<m"
        A$ = A$ + "LI#PLRAfhmc3EW`V9U?1o4SCBmSm^`?E7a^ANEn4#dCA`0MPW0=]9H:ZbZo>"
        A$ = A$ + "9M5l9UKW^cbOO7RkVC:^emkaGGb[WCc0IYfjKJoN8:S1mi`9a4\T5RWZB9iL"
        A$ = A$ + "CV:IfU#e56U;`GPd9MeAE5_TCnI\94hKe6>Ol7G=UM1mm<#lng_GVgW`YkXe"
        A$ = A$ + "Lf2N[[=Yb?kA0SI[SA`RD3<D;:T1_No:f__?3NLBmn60iWSo<7^ha=:1oaI;"
        A$ = A$ + "NlniQZCLgDbWAo9SCi__Zf_G>OT>RMSlZl9Phng__6jlk7;`NEl3aQ=KcaOK"
        A$ = A$ + "7bW6U>cj#S[aO5]On:_odjb;?1b2XhHe=jliH`8]<>5:9VPU\#lDE:i4jCkD"
        A$ = A$ + "PWmfBheG0;XU[_O_0Rf<H1?]IKo;cjHB8]>?e_TYWRA>hRKAWQ0CPa[d07eo"
        A$ = A$ + "Kl5Tag6i8Pm0NjWOTb_2f[YSfCW5PmPJma1E0NZF1=l5_O?k_?HXGNSRX?G]"
        A$ = A$ + "d`mO?0LRk6`3QPfaJ6m[d\;KoNjm[jPc0VmmNGL=]=oUE#8[n3UD0fVia#k9"
        A$ = A$ + "W>F7]3X]3jLJLYdIF7JL=n[Gjnmlko1b2J8_dmk7n:?YS7dkj?LjH19>UmPH"
        A$ = A$ + "lL30Inkg>RJZ7PVbU#i<4D0AK6\PWf\]g3`EcUQOj[hRjiI1IV0h<3m>GO^g"
        A$ = A$ + "k?[I]Gj>:FC>UOR#0k1ld?oH:nm_TGB3#KnH9<DZN7X?ohB07^X065a:H<9V"
        A$ = A$ + "E?3`\CVb98NJm][?<g9IjhjWKnYC4N2jN\fMnii__mk;APEIdCo=VnoD8_1I"
        A$ = A$ + "eW>M5jojg_g]31:JYj1Wakgc^oFiTCO6l48;fYLZKW8ElXch#PcY6Wb2MdTi"
        A$ = A$ + "UW;74A3:QVR<nonA#5ca?\0`5gGUIk_QMG:mO0E6V9]fTaU`Nc5hH82m>GSN"
        A$ = A$ + "[g^nQ00GM7eMFC>UO>RPIOYnl9\1CiQfORkiZ:G4eZXQD_W8GW0cc6hY9<6f"
        A$ = A$ + "?1JjDbg81F523GLimd5>BX4Z4LfiWZO7eW:eGjNnOOVhg=?EJZn6PMQK68Y["
        A$ = A$ + "^dJJj7^O8=16]6cW=`ICWheEJQH\XM#WCW[ZFhj#S[aOU]OOjk?akgC08FCd"
        A$ = A$ + "Z[OiIHR7M671L>=nLT#6m4cOC4168F`TW9g_?l?g9o4YLoNiiWi=SGQijOHl"
        A$ = A$ + "[J0>NlZNFbV4]TkB8?5TLda9>GiOVkg[^fgm``k2hOFP#nmmQdoi7YLNLgY5"
        A$ = A$ + "5BEU;R:P?4mPX^SOPR76Gne]OObnY:7hn?9oB7_KHon`iG8Pni[6gMnceM<R"
        A$ = A$ + "P><bB9`Ln1Odb_dmk[O2R<?dWWLOc`j=CWmmK#QS^h57XaM^dUS2fhJlGc^O"
        A$ = A$ + "_nm7fiGJnH11##\4<Z_d_8DCXD?S17T30Tn#a04\bM8oQ?2`Q60gPN7LEX<Z"
        A$ = A$ + "#n9POl_aShWXUbc?3]O9VYm>2Ni3`aSo3OZf6KIgU#NcUPH82mVGoLHL;6l4"
        A$ = A$ + "PlZAGZS9#`5Gl9g_g_Nl<VZ`515#WNGNnWXO;GnbkWnVf_?JiWV4PCG[C:M2"
        A$ = A$ + "iO9m#mSDOJki;B6eMZV8#PdV3Lliogo0C#7o7mDk_^nn20am_Q9V>e0#;<Q0"
        A$ = A$ + "en41V\ND\Rf<h<PoZY?hl37]0?F#j:AY0I44V0L<Hj::78oXCQ9F=YXi_94="
        A$ = A$ + "0^1Ab3LDUekRW^NO4o<\nC`\<l=>0n>keg;QmD#bA7WhTec_8V0amHb;nSYd"
        A$ = A$ + "hM<>5Gh[GUFnhi<ePPnR:Yi`i4kgSX\N0Zi33_HiOjkgCQSeO22`Y[e9U>CZ"
        A$ = A$ + "oLmC_O6MLB587Adj38=6bhf<F756KOa<d4NigObgOcQ_Dmgkg_hg_RC#:8nn"
        A$ = A$ + "CcbD_hOo0U^2bYg5141n>nU=ooS[TV64S?IjLeKagdD3m3#hC`L<lM>0n>Ke"
        A$ = A$ + "g[QlDDRQWTH>mhInN_OY_hgoLgDd4GY=Tg^:]\[3c#KJ;V`<7>[_NolkgS:P"
        A$ = A$ + ";PRb=94XFB0:eCM#8H8mI>8Sg5^OoDkW7:PliSg120FRXT7DJ\8QlUQ3f=VL"
        A$ = A$ + "X6>IhL1`RP]1dY;0O1OE00jC4H:0#QJL=n[dmkcNoQ?PV<T22_NKF60heCI0"
        A$ = A$ + "F^8cSH;nXik;OoNKkQ9XK:UO>0n4<75OSC##S]2le#N::a`CBL2jYi#44gQY"
        A$ = A$ + "_ik:\lC<dUVXNGKV3T^JFoZ>_^5Ad;Z8aI\CZhfb==8#\T0#9D:33Y?CB9Sg"
        A$ = A$ + "bkg[FH1A##jN5LRi3?RRNhk^9;BTQlXUa`1k6a]n<[^eQ1]A7gSP3OjdQ:O8"
        A$ = A$ + "E#QS^2J?W53^D8PRdhJlGakg7mncbI854:0n\d08:W2=V^SUAPQfKSl4?oDU"
        A$ = A$ + "dfPDlI3W[L3na==X144n0\`QlUbY^F7TR8[[QmDDRQWTh4dCcQ88^53N44L_"
        A$ = A$ + "oILSj2Nk2E1m]#7_ODbj_\b[KA4URjAg3ZiFTP]LH3VJonQoM^j;XD?e1QSQ"
        A$ = A$ + "dWiQ<NGjnmC]O^G1e_Q1bB[#NR`47LBT83iEP^f\0nEIFUT5gMQeeBkC09VB"
        A$ = A$ + "0In;Uc^o:`:Hnh\P2FDeGcnmC^k<Q3TDT223PP\T0XZV5[nk^j:Nb`W8>CNm"
        A$ = A$ + "]==]\P`83nTI;T2A:cE2`7PIhhKL2BJ\CQ_6fCA96NBRc#?97bPh><mEOMM="
        A$ = A$ + "9;aN4<4fdG3M4oI5;oj:]^C2X#D?:V2WJ6fj[9dUEVFeFGO1UjY>8\<Tn4ik"
        A$ = A$ + "jg_7F2WR4JG=20^iceo8RPeVdjkmSNbbO6nS43cb1WMQOjG>Pbi_?D0AWAmj"
        A$ = A$ + "RGC5DhX;YfhHAaUGSTlN`IfnmR3WW>iSGOTQLT2200A^RTl082fjO<WJE>28"
        A$ = A$ + "7=LJZHU\HcEN3``cW=Ybk`OZnZW#NmO0VQS__A8Za>jM=TgLoIM4VALIin^_"
        A$ = A$ + "R9OiAGEiWDd1OFPVIZHDOcMi;kbcVgkko_i_2m1X0_Gk:ToCPaI?nWn]Z?:;"
        A$ = A$ + "SkjTTH4PoEYOghi`WlA<QK]^5\_VeT3iY_oo^OoiTmofOoo\`k:oR`oclUS4"
        A$ = A$ + ";BNNQlY_cAI]LhcBUHaQTh<R;;ggnU?Do_`g:bQIj>NIg]UW=O]OIHKO8fgn"
        A$ = A$ + "ORIKGPMSG2n2_O=?Uo27b[`nS>fK;cn`G_?2XkS;_bmkUH42a;cN;kgon<f`"
        A$ = A$ + "^odjf^2Ko7YgfNonFK_OOXm7M\gFVmm_Oo5HkmkWeN\Oo5m_Le5#YKe`cjWd"
        A$ = A$ + "Mh]m5Kko8mO?KjoWlhIJeGge[mnmQfOdaNKAfkkbaWdUb?Smk9BbWT#mdN^P"
        A$ = A$ + "oIifWil=Hkmkgf=JgibMKkSd6?]O1[go=MkJ_OOVm=Nf^]GVmNG_oCiBiWdn"
        A$ = A$ + "mhU8CQhUI72K1T^7BNM6NbnX^4_]_HKoGYoSI37h[nacP>\l7VO[fNon<k_i"
        A$ = A$ + "D_]#K_Ooogfkg?_mgJoNhIc7eMh]m=Kko<mO<kJnfiLMhj`nn]iilghDNNk_"
        A$ = A$ + "iD_]#kMMihcjB9U=ad4oFf\_ka196RGVan3DOTTmlfNon]]]]MAf;hKWOgOG"
        A$ = A$ + "N_OOTmENf^]GVm^^KlIMYlbf__9kEn^:<m?:UZaXo9Z?AbNN[>JoVWf]]]]M"
        A$ = A$ + "Of;hCWOgOFNNBoE>VWenC>dKK6k?ooGGKoW2i^2QPi865_?fOMhenfnK^m_H"
        A$ = A$ + "[>JoR7f]]]]MWfmoUc_k?;??Yo:7ccJo97j]mYKOHG:1O5Lf?<:0HJR0laik"
        A$ = A$ + "MoW9ldmkn?TTJUIkgl`^]]]]ke^k?LnMoEiiImgiLN>k;m`MKob]?\kTP?3>"
        A$ = A$ + "mG6Y0<?CbL9\YJiI\gLkOYFIdn5?[KKKKk^]kmcVOgODNNJoU>XWbn;>cKKK"
        A$ = A$ + "CJP_3>oW690LglmM_PmK^m_>3<H[>[o?TSDj%%%0"
        btemp$ = ""
        For i& = 1 To Len(A$) Step 4: B$ = Mid$(A$, i&, 4)
            If InStr(1, B$, "%") Then
                For C% = 1 To Len(B$): F$ = Mid$(B$, C%, 1)
                    If F$ <> "%" Then C$ = C$ + F$
                Next: B$ = C$: End If: For j = 1 To Len(B$)
                If Mid$(B$, j, 1) = "#" Then
            Mid$(B$, j) = "@": End If: Next
            For t% = Len(B$) To 1 Step -1
                B& = B& * 64 + Asc(Mid$(B$, t%)) - 48
                Next: X$ = "": For t% = 1 To Len(B$) - 1
                X$ = X$ + Chr$(B& And 255): B& = B& \ 256
        Next: btemp$ = btemp$ + X$: Next
        btemp$ = _Inflate$(btemp$, m.SIZE)
        _MemPut m, m.OFFSET, btemp$: _MemFree m
        _Dest fontsheet&: _ClearColor 0 '<<< Important to do
        _Dest origdest
        initfont = 1
    End If

    'To change color of original fontsheet
    _Dest fontsheet&
    _PaletteColor 15, clr&, fontsheet&
    'copy it
    monofont& = _CopyImage(fontsheet&)

    xw = Int(size / 2)
    For i = 1 To Len(txt$)
        A$ = Mid$(txt$, i, 1)
        tmp& = _NewImage(32, 64, 32)
        _Dest tmp&
        If A$ = "A" Then _PutImage (0, 0), monofont&
        If A$ = "B" Then _PutImage (0 - 32, 0), monofont&
        If A$ = "C" Then _PutImage (0 - (32 * 2), 0), monofont&
        If A$ = "D" Then _PutImage (0 - (32 * 3), 0), monofont&
        If A$ = "E" Then _PutImage (0 - (32 * 4), 0), monofont&
        If A$ = "F" Then _PutImage (0 - (32 * 5), 0), monofont&
        If A$ = "G" Then _PutImage (0 - (32 * 6), 0), monofont&
        If A$ = "H" Then _PutImage (0 - (32 * 7), 0), monofont&
        If A$ = "I" Then _PutImage (0 - (32 * 8), 0), monofont&
        If A$ = "J" Then _PutImage (0 - (32 * 9), 0), monofont&
        If A$ = "K" Then _PutImage (0 - (32 * 10), 0), monofont&
        If A$ = "L" Then _PutImage (0 - (32 * 11), 0), monofont&
        If A$ = "M" Then _PutImage (0 - (32 * 12), 0), monofont&
        If A$ = "N" Then _PutImage (0 - (32 * 13), 0), monofont&
        If A$ = "O" Then _PutImage (0 - (32 * 14), 0), monofont&
        If A$ = "P" Then _PutImage (0 - (32 * 15), 0), monofont&
        If A$ = "Q" Then _PutImage (0 - (32 * 16), 0), monofont&
        If A$ = "R" Then _PutImage (0 - (32 * 17), 0), monofont&
        If A$ = "S" Then _PutImage (0 - (32 * 18), 0), monofont&
        If A$ = "T" Then _PutImage (0 - (32 * 19), 0), monofont&
        If A$ = "U" Then _PutImage (0 - (32 * 20), 0), monofont&
        If A$ = "V" Then _PutImage (0 - (32 * 21), 0), monofont&
        If A$ = "W" Then _PutImage (0 - (32 * 22), 0), monofont&
        If A$ = "X" Then _PutImage (0 - (32 * 23), 0), monofont&
        If A$ = "Y" Then _PutImage (0 - (32 * 24), 0), monofont&
        If A$ = "Z" Then _PutImage (0 - (32 * 25), 0), monofont&
        If A$ = "a" Then _PutImage (0 - (32 * 26), 0), monofont&
        If A$ = "b" Then _PutImage (0 - (32 * 27), 0), monofont&
        If A$ = "c" Then _PutImage (0 - (32 * 28), 0), monofont&
        If A$ = "d" Then _PutImage (0 - (32 * 29), 0), monofont&
        If A$ = "e" Then _PutImage (0 - (32 * 30), 0), monofont&
        If A$ = "f" Then _PutImage (0 - (32 * 31), 0), monofont&
        If A$ = "g" Then _PutImage (0 - (32 * 32), 0), monofont&
        If A$ = "h" Then _PutImage (0 - (32 * 33), 0), monofont&
        If A$ = "i" Then _PutImage (0 - (32 * 34), 0), monofont&
        If A$ = "j" Then _PutImage (0 - (32 * 35), 0), monofont&
        If A$ = "k" Then _PutImage (0 - (32 * 36), 0), monofont&
        If A$ = "l" Then _PutImage (0 - (32 * 37), 0), monofont&
        If A$ = "m" Then _PutImage (0 - (32 * 38), 0), monofont&
        If A$ = "n" Then _PutImage (0 - (32 * 39), 0), monofont&
        If A$ = "o" Then _PutImage (0 - (32 * 40), 0), monofont&
        If A$ = "p" Then _PutImage (0 - (32 * 41), 0), monofont&
        If A$ = "q" Then _PutImage (0 - (32 * 42), 0), monofont&
        If A$ = "r" Then _PutImage (0 - (32 * 43), 0), monofont&
        If A$ = "s" Then _PutImage (0 - (32 * 44), 0), monofont&
        If A$ = "t" Then _PutImage (0 - (32 * 45), 0), monofont&
        If A$ = "u" Then _PutImage (0 - (32 * 46), 0), monofont&
        If A$ = "v" Then _PutImage (0 - (32 * 47), 0), monofont&
        If A$ = "w" Then _PutImage (0 - (32 * 48), 0), monofont&
        If A$ = "x" Then _PutImage (0 - (32 * 49), 0), monofont&
        If A$ = "y" Then _PutImage (0 - (32 * 50), 0), monofont&
        If A$ = "z" Then _PutImage (0 - (32 * 51), 0), monofont&
        If A$ = "0" Then _PutImage (0 - (32 * 52), 0), monofont&
        If A$ = "1" Then _PutImage (0 - (32 * 53), 0), monofont&
        If A$ = "2" Then _PutImage (0 - (32 * 54), 0), monofont&
        If A$ = "3" Then _PutImage (0 - (32 * 55), 0), monofont&
        If A$ = "4" Then _PutImage (0 - (32 * 56), 0), monofont&
        If A$ = "5" Then _PutImage (0 - (32 * 57), 0), monofont&
        If A$ = "6" Then _PutImage (0 - (32 * 58), 0), monofont&
        If A$ = "7" Then _PutImage (0 - (32 * 59), 0), monofont&
        If A$ = "8" Then _PutImage (0 - (32 * 60), 0), monofont&
        If A$ = "9" Then _PutImage (0 - (32 * 61), 0), monofont&
        If A$ = "+" Then _PutImage (0 - (32 * 62), 0), monofont&
        If A$ = "-" Then _PutImage (0 - (32 * 63), 0), monofont&
        If A$ = "=" Then _PutImage (0 - (32 * 64), 0), monofont&
        If A$ = ":" Then _PutImage (0 - (32 * 65), 0), monofont&
        If A$ = "." Then _PutImage (0 - (32 * 66), 0), monofont&
        If A$ = "," Then _PutImage (0 - (32 * 67), 0), monofont&
        If A$ = " " Then _PutImage (0 - (32 * 68), 0), monofont&
        If A$ = "<" Then _PutImage (0 - (32 * 69), 0), monofont&
        If A$ = ">" Then _PutImage (0 - (32 * 70), 0), monofont&
        If A$ = "/" Then _PutImage (0 - (32 * 71), 0), monofont&
        If A$ = "?" Then _PutImage (0 - (32 * 72), 0), monofont&
        If A$ = ";" Then _PutImage (0 - (32 * 73), 0), monofont&
        If A$ = "'" Then _PutImage (0 - (32 * 74), 0), monofont&
        If A$ = "[" Then _PutImage (0 - (32 * 75), 0), monofont&
        If A$ = "]" Then _PutImage (0 - (32 * 76), 0), monofont&
        If A$ = "{" Then _PutImage (0 - (32 * 77), 0), monofont&
        If A$ = "}" Then _PutImage (0 - (32 * 78), 0), monofont&
        If A$ = "\" Then _PutImage (0 - (32 * 79), 0), monofont&
        If A$ = "|" Then _PutImage (0 - (32 * 80), 0), monofont&
        If A$ = "_" Then _PutImage (0 - (32 * 81), 0), monofont&
        If A$ = "`" Then _PutImage (0 - (32 * 82), 0), monofont&
        If A$ = "~" Then _PutImage (0 - (32 * 83), 0), monofont&
        If A$ = "!" Then _PutImage (0 - (32 * 84), 0), monofont&
        If A$ = "@" Then _PutImage (0 - (32 * 85), 0), monofont&
        If A$ = "#" Then _PutImage (0 - (32 * 86), 0), monofont&
        If A$ = "$" Then _PutImage (0 - (32 * 87), 0), monofont&
        If A$ = "%" Then _PutImage (0 - (32 * 88), 0), monofont&
        If A$ = "^" Then _PutImage (0 - (32 * 89), 0), monofont&
        If A$ = "&" Then _PutImage (0 - (32 * 90), 0), monofont&
        If A$ = "*" Then _PutImage (0 - (32 * 91), 0), monofont&
        If A$ = "(" Then _PutImage (0 - (32 * 92), 0), monofont&
        If A$ = ")" Then _PutImage (0 - (32 * 93), 0), monofont&
        If A$ = Chr$(34) Then _PutImage (0 - (32 * 94), 0), monofont&

        _Dest origdest
        _PutImage (x + (i * xw), y)-(x + (i * xw) + Int(size / 2), y + size), tmp&
        _FreeImage tmp&
    Next

    _FreeImage monofont&

End Sub