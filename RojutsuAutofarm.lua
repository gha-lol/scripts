--[[
AztupBrew(Fork of IronBrew2): obfuscation; Version 2.7.2
]]
return(function(i,a,a)local k=string.char;local e=string.sub;local o=table.concat;local n=math.ldexp;local p=getfenv or function()return _ENV end;local m=select;local f=unpack or table.unpack;local j=tonumber;local function l(h)local b,c,g="","",{}local f=256;local d={}for a=0,f-1 do d[a]=k(a)end;local a=1;local function i()local b=j(e(h,a,a),36)a=a+1;local c=j(e(h,a,a+b-1),36)a=a+b;return c end;b=k(i())g[1]=b;while a<#h do local a=i()if d[a]then c=d[a]else c=b..e(b,1,1)end;d[f]=b..e(c,1,1)g[#g+1],b,f=c,c,f+1 end;return table.concat(g)end;local h=l('1G1Z2751X2132751Z21W21U22621Y1X21527922S21Y22F23421Y22922D22221S27E27G27523522E22527L27N27P27E21027923422F21Y22B22B21Y21Z1X28127522O22422522521Y21S22F1X21227922B22922222528J1128221S28O22B22F1321T22I1P1322S22321U21T28O21Y21Y2271328E132391G22922622222722722228E1X1X27923G22S1X21727922Q22E22F22421X21U29G27727922C21U22228J28B1Z23722721U22I27M2281X21427923322421S21U2272AA2AC27M1X21627922O29422921U28I2AQ27827522Z21Y21U28921927922T28P21Z2B822922822F2AU29I28929T27523022D27M2232B32892A822V21Y2BD22922422I27F27923622E2BS22F23G22V21U22F21U2AG29U28I2222BL2BZ2C128K2792392AM2C027628L27522B2A52BC2AR2A32242292202282CN27Q2C827527I2BE2232BG22921Y2252A227523127C27R2BY2C02BD22S2CB2AQ2BI1Z22Y28Q27M2AX28J2182792372BU22J22229H22F22I2DR22422628W1X2B62752CD2BD23G27L22F22F28P21W2AF2CL1Z22U28G2262BW1W27923222421T1X21F27922Z22E22621U22522422221Z23522422422F2372A028J2112AT22T2AW27D1X2EK27528G22C1Y2792FI1Z2FH2FJ21N26B1X21C27921X2222D428N2242DT2DV22I2FV2E028J2DI2ES2EU2EW2EY1X2F72B12B322722F2232FK2G829U22521W2272BS2FL27926B2292FO2B01Z2EU2GD2FC2792AW21Z2GM27921R22R2CQ2752382CS2CU2CW27E2AH27522U2BL28Q22Z22422721Z2AQ21A2AT2DZ21T2C52C327C21U21W2802792352B328I2CS2BX2752BB21Y27X2BL22929N2792312242FK27927S1Z2I627529Q29S29U29W29Y2A02262GF2GR27B2FB2A82AO2AD2CP2HA1Z2AJ2AL2AN2AB2IT2H31Z2AU2A02DN2DH2ER2ET2EV2EX2892IV2J42GI2I22C62842GZ2751522R2FJ2E31Z21D1H2792GM1321K2FJ29O151N27928L2FH2EK21321M2K02IA2K42792HK2FH2JQ2792GR1321P2FJ28L132FJ1Z2F72KJ2FJ2812KN2FI29T2KQ2792AS21D2761Z2IC2JW2IA1Z2DI2GM23P27921D1J2JS2792KT2KX2KW2ID1Z2FD2KK29O29O2LB1Z2782LK28L1X1I2LE2FJ1027929O2KB2JR2752G92JP21N2IA2A81Z21Q2LU2IA2KC2752DI2JU2FJ2AS2112IV2EQ2FH2FH2K82752MG2LL2K527523Q2M72LX2KY2FI21L2L92KB2FI2JT2KK2AH2LK21B1Z2LK2HK2LK2B62LK2DP2LD29O2EQ2KK2LE29O2LZ2M42IA2MI2MN2NH2NJ279162MQ2L92752LK2N02KK2N22N42N32KK2N72KK2EQ2LK21E2LH2NP2752JT2NO2FI29O2NA1Z2IV2L02LJ2NU2NX2FJ2KW2LK2FQ2LK21J1Z152FI2L82FH21I2MM2792OR2OU27523E2O51Z21H2L62812FH21G2LA2O62IA2M12L929O2ND2KX2GR1Z2382IA2MB28L2782K52JY1Z28L1P2IA2MU2MJ1Z2PQ2NM2H42PI2JV2PK1Z2JV13192PO2Q521R2OH28L28L2M52KN2Q91Z2KG2QC2Q52ON2LD2F72MA2LY2KL1Z21O2QN2Q522V2IA2F72PT2QS2PW2PG2NP2K12LA122Q528L2NT2R31Z2NV2752QD2N52R92Q52KJ2KN2QU2NX2RF2QN2R22LD2812R22NR27528128128S2LD29T2LT2752LD2AS172L62M127G2RV2751K1Z28127G2PC2QM2F72812NC28L2R22F72LD28L2O82OH2RG2Q22SA1Z2Q72K62LV2KL1B2791L2IA29O2PT2SV2LW2792P22RW2P41Z2P62RO2NI1Z2PA2P82S92ND2SX2FI23L2PY2Q52PL2JP2JR2QK2LA2JV2F72F72QP2112OT28L21Y2QT2OX1Z2TV2QX2TG2FH131A2TI1Z2N92M12812OP2H02Q52812NF2FQ28L2U12KD2NK2UH2PJ2LL2OO2N32PZ2Q5141Z2191E1Z2LT2UH2PK2UJ2PI2U42Q02U72S62OH2752Q728L2UD2KL2AH28L22F2T82PT2VD2U02QZ2L12N32NO2QD2OA2RP2OC2KK2V82LE2QG28L2R82R62OJ2RC28L2OL2VY1Z2ON2UA28L22K2IA2ST2PT2W62VH2T02R02NR182R62R52QD2VV2RA2Q82RD2SK2UM2RE2SN2RK2VO2RN2OH2RQ1Z2U42RT1Z2Q42RW2752AS2WF2NR2JV2AS2AS1F2JP2P62S22KK2AS2LI2JP2752XC2KO2MS2TC2TP2V42RL1Z2WT2KN2WV2RS2M92UV2L62X22XV2X12MS2UU2UB2S72LR2KW2XM2SC2RC2SF2XG2Q52MY2R62VN2V41D2VQ2V42OF2R61C2WL28L2L82VT1Z2LQ2YP2JR21D2U81Z2742792LT2VR2FH2112ST2IF2SW2TX23G2K72NK2AH2FL2L3279');local a=(bit or bit32);local d=a and a.bxor or function(a,b)local c,d,e=1,0,10 while a>0 and b>0 do local e,f=a%2,b%2 if e~=f then d=d+c end a,b,c=(a-e)/2,(b-f)/2,c*2 end if a<b then a=b end while a>0 do local b=a%2 if b>0 then d=d+c end a,c=(a-b)/2,c*2 end return d end local function c(b,a,c)if c then local a=(b/2^(a-1))%2^((c-1)-(a-1)+1);return a-a%1;else local a=2^(a-1);return(b%(a+a)>=a)and 1 or 0;end;end;local a=1;local function b()local b,c,f,e=i(h,a,a+3);b=d(b,35)c=d(c,35)f=d(f,35)e=d(e,35)a=a+4;return(e*16777216)+(f*65536)+(c*256)+b;end;local function j()local b=d(i(h,a,a),35);a=a+1;return b;end;local function g()local c,b=i(h,a,a+2);c=d(c,35)b=d(b,35)a=a+2;return(b*256)+c;end;local function l()local d=b();local a=b();local e=1;local d=(c(a,1,20)*(2^32))+d;local b=c(a,21,31);local a=((-1)^c(a,32));if(b==0)then if(d==0)then return a*0;else b=1;e=0;end;elseif(b==2047)then return(d==0)and(a*(1/0))or(a*(0/0));end;return n(a,b-1023)*(e+(d/(2^52)));end;local n=b;local function q(b)local c;if(not b)then b=n();if(b==0)then return'';end;end;c=e(h,a,a+b-1);a=a+b;local b={}for a=1,#c do b[a]=k(d(i(e(c,a,a)),35))end return o(b);end;local a=b;local function o(...)return{...},m('#',...)end local function i()local k={};local d={};local a={};local h={[#{"1 + 1 = 111";"1 + 1 = 111";}]=d,[#{{532;948;272;618};{769;135;245;910};"1 + 1 = 111";}]=nil,[#{"1 + 1 = 111";{70;774;106;396};"1 + 1 = 111";"1 + 1 = 111";}]=a,[#{{918;600;184;964};}]=k,};local a=b()local e={}for c=1,a do local b=j();local a;if(b==0)then a=(j()~=0);elseif(b==1)then a=l();elseif(b==2)then a=q();end;e[c]=a;end;h[3]=j();for a=1,b()do d[a-1]=i();end;for h=1,b()do local a=j();if(c(a,1,1)==0)then local d=c(a,2,3);local f=c(a,4,6);local a={g(),g(),nil,nil};if(d==0)then a[3]=g();a[4]=g();elseif(d==1)then a[3]=b();elseif(d==2)then a[3]=b()-(2^16)elseif(d==3)then a[3]=b()-(2^16)a[4]=g();end;if(c(f,1,1)==1)then a[2]=e[a[2]]end if(c(f,2,2)==1)then a[3]=e[a[3]]end if(c(f,3,3)==1)then a[4]=e[a[4]]end k[h]=a;end end;return h;end;local function l(a,b,g)a=(a==true and i())or a;return(function(...)local d=a[1];local e=a[3];local n=a[2];local k=o local b=1;local h=-1;local o={};local i={...};local j=m('#',...)-1;local a={};local c={};for a=0,j do if(a>=e)then o[a-e]=i[a+1];else c[a]=i[a+#{{783;987;315;656};}];end;end;local a=j-e+1 local a;local e;while true do a=d[b];e=a[1];if e<=28 then if e<=13 then if e<=6 then if e<=2 then if e<=0 then local f;local e;c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];e=a[2];f=c[a[3]];c[e+1]=f;c[e]=f[a[4]];b=b+1;a=d[b];e=a[2]c[e](c[e+1])elseif e==1 then if c[a[2]]then b=b+1;else b=a[3];end;else c[a[2]]=a[3];end;elseif e<=4 then if e>3 then local a=a[2]local d,b=k(c[a](c[a+1]))h=b+a-1 local b=0;for a=a,h do b=b+1;c[a]=d[b];end;else local a=a[2]c[a]=c[a](c[a+1])end;elseif e>5 then local d=a[2];local f=a[4];local e=d+2 local d={c[d](c[d+1],c[e])};for a=1,f do c[e+a]=d[a];end;local d=d[1]if d then c[e]=d b=a[3];else b=b+1;end;else c[a[2]]=c[a[3]]*c[a[4]];end;elseif e<=9 then if e<=7 then local e;local i;local j,m;local l;local e;c[a[2]]=g[a[3]];b=b+1;a=d[b];e=a[2];l=c[a[3]];c[e+1]=l;c[e]=l[a[4]];b=b+1;a=d[b];e=a[2]j,m=k(c[e](c[e+1]))h=m+e-1 i=0;for a=e,h do i=i+1;c[a]=j[i];end;b=b+1;a=d[b];e=a[2]j={c[e](f(c,e+1,h))};i=0;for a=e,a[4]do i=i+1;c[a]=j[i];end b=b+1;a=d[b];b=a[3];elseif e>8 then local b=a[2];local d=c[a[3]];c[b+1]=d;c[b]=d[a[4]];else do return end;end;elseif e<=11 then if e==10 then b=a[3];else if not c[a[2]]then b=b+1;else b=a[3];end;end;elseif e==12 then local b=a[2]c[b](f(c,b+1,a[3]))else c[a[2]][a[3]]=c[a[4]];end;elseif e<=20 then if e<=16 then if e<=14 then local a=a[2]c[a](c[a+1])elseif e==15 then local b=a[2]c[b]=c[b](f(c,b+1,a[3]))else local g;local e;e=a[2];g=c[a[3]];c[e+1]=g;c[e]=g[a[4]];b=b+1;a=d[b];c[a[2]]=a[3];b=b+1;a=d[b];e=a[2]c[e]=c[e](f(c,e+1,a[3]))b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];if(c[a[2]]~=a[4])then b=b+1;else b=a[3];end;end;elseif e<=18 then if e>17 then local h;local e;c[a[2]]=c[a[3]]*c[a[4]];b=b+1;a=d[b];c[a[2]][a[3]]=c[a[4]];b=b+1;a=d[b];c[a[2]]=g[a[3]];b=b+1;a=d[b];e=a[2];h=c[a[3]];c[e+1]=h;c[e]=h[a[4]];b=b+1;a=d[b];c[a[2]]=a[3];b=b+1;a=d[b];e=a[2]c[e]=c[e](f(c,e+1,a[3]))b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];e=a[2];h=c[a[3]];c[e+1]=h;c[e]=h[a[4]];else local a=a[2]c[a]=c[a](c[a+1])end;elseif e==19 then if c[a[2]]then b=b+1;else b=a[3];end;else c[a[2]]();end;elseif e<=24 then if e<=22 then if e>21 then c[a[2]]=c[a[3]]*c[a[4]];else if(c[a[2]]~=c[a[4]])then b=b+1;else b=a[3];end;end;elseif e==23 then local e;c[a[2]]=a[3];b=b+1;a=d[b];e=a[2]c[e]=c[e](c[e+1])b=b+1;a=d[b];c[a[2]]=a[3];b=b+1;a=d[b];e=a[2]c[e]=c[e](f(c,e+1,a[3]))b=b+1;a=d[b];c[a[2]]=c[a[3]]*c[a[4]];b=b+1;a=d[b];c[a[2]]=g[a[3]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=a[3];b=b+1;a=d[b];c[a[2]]=a[3];b=b+1;a=d[b];c[a[2]]=a[3];else c[a[2]]=a[3];end;elseif e<=26 then if e==25 then b=a[3];else local h;local e;c[a[2]]();b=b+1;a=d[b];c[a[2]]=g[a[3]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];e=a[2];h=c[a[3]];c[e+1]=h;c[e]=h[a[4]];b=b+1;a=d[b];c[a[2]]=a[3];b=b+1;a=d[b];e=a[2]c[e]=c[e](f(c,e+1,a[3]))b=b+1;a=d[b];if not c[a[2]]then b=b+1;else b=a[3];end;end;elseif e>27 then local b=a[2]c[b]=c[b](f(c,b+1,a[3]))else c[a[2]]=c[a[3]][a[4]];end;elseif e<=42 then if e<=35 then if e<=31 then if e<=29 then local a=a[2]c[a](c[a+1])elseif e==30 then local g;local e;c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];e=a[2];g=c[a[3]];c[e+1]=g;c[e]=g[a[4]];b=b+1;a=d[b];c[a[2]]=a[3];b=b+1;a=d[b];e=a[2]c[e](f(c,e+1,a[3]))else local e;local i;local j,m;local l;local e;c[a[2]]=g[a[3]];b=b+1;a=d[b];e=a[2];l=c[a[3]];c[e+1]=l;c[e]=l[a[4]];b=b+1;a=d[b];e=a[2]j,m=k(c[e](c[e+1]))h=m+e-1 i=0;for a=e,h do i=i+1;c[a]=j[i];end;b=b+1;a=d[b];e=a[2]j={c[e](f(c,e+1,h))};i=0;for a=e,a[4]do i=i+1;c[a]=j[i];end b=b+1;a=d[b];b=a[3];end;elseif e<=33 then if e==32 then c[a[2]][a[3]]=c[a[4]];else c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=g[a[3]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=a[3];b=b+1;a=d[b];c[a[2]]=a[3];end;elseif e>34 then local b=a[2]c[b](f(c,b+1,a[3]))else local b=a[2]local e={c[b](f(c,b+1,h))};local d=0;for a=b,a[4]do d=d+1;c[a]=e[d];end end;elseif e<=38 then if e<=36 then do return end;elseif e==37 then local g;local e;e=a[2];g=c[a[3]];c[e+1]=g;c[e]=g[a[4]];b=b+1;a=d[b];c[a[2]]=a[3];b=b+1;a=d[b];e=a[2]c[e]=c[e](f(c,e+1,a[3]))b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];if(c[a[2]]~=a[4])then b=b+1;else b=a[3];end;else local a=a[2]local d,b=k(c[a](c[a+1]))h=b+a-1 local b=0;for a=a,h do b=b+1;c[a]=d[b];end;end;elseif e<=40 then if e==39 then if(c[a[2]]~=c[a[4]])then b=b+1;else b=a[3];end;else local e=a[2];local f=a[4];local d=e+2 local e={c[e](c[e+1],c[d])};for a=1,f do c[d+a]=e[a];end;local e=e[1]if e then c[d]=e b=a[3];else b=b+1;end;end;elseif e>41 then c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=g[a[3]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];if(c[a[2]]~=c[a[4]])then b=b+1;else b=a[3];end;else local d=a[2];local b=c[a[3]];c[d+1]=b;c[d]=b[a[4]];end;elseif e<=49 then if e<=45 then if e<=43 then c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=g[a[3]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=a[3];b=b+1;a=d[b];c[a[2]]=g[a[3]];elseif e==44 then if(a[2]<c[a[4]])then b=b+1;else b=a[3];end;else if(a[2]<c[a[4]])then b=b+1;else b=a[3];end;end;elseif e<=47 then if e>46 then c[a[2]]=c[a[3]][a[4]];else local d=a[2]local e={c[d](f(c,d+1,h))};local b=0;for a=d,a[4]do b=b+1;c[a]=e[b];end end;elseif e==48 then local h;local e;c[a[2]]=g[a[3]];b=b+1;a=d[b];e=a[2];h=c[a[3]];c[e+1]=h;c[e]=h[a[4]];b=b+1;a=d[b];c[a[2]]=a[3];b=b+1;a=d[b];e=a[2]c[e]=c[e](f(c,e+1,a[3]))b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];e=a[2];h=c[a[3]];c[e+1]=h;c[e]=h[a[4]];else c[a[2]]=l(n[a[3]],nil,g);end;elseif e<=53 then if e<=51 then if e==50 then c[a[2]]=g[a[3]];else if not c[a[2]]then b=b+1;else b=a[3];end;end;elseif e>52 then c[a[2]]=g[a[3]];else if(c[a[2]]~=a[4])then b=b+1;else b=a[3];end;end;elseif e<=55 then if e>54 then local e;e=a[2]c[e]=c[e](f(c,e+1,a[3]))b=b+1;a=d[b];c[a[2]]=c[a[3]]*c[a[4]];b=b+1;a=d[b];c[a[2]][a[3]]=c[a[4]];b=b+1;a=d[b];c[a[2]]=g[a[3]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];c[a[2]]=c[a[3]][a[4]];b=b+1;a=d[b];e=a[2]c[e](c[e+1])else c[a[2]]();end;elseif e>56 then c[a[2]]=l(n[a[3]],nil,g);else if(c[a[2]]~=a[4])then b=b+1;else b=a[3];end;end;b=b+1;end;end);end;return l(true,{},p())();end)(string.byte,table.insert,setmetatable);
