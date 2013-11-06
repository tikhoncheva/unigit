
mmm = [256, 1006.643026;
288, 843.096405;
320, 983.035085;
352, 769.657967;
384, 849.348683;
416, 674.916291;
448, 817.412655;
480, 656.983479;
512, 654.720624;
544, 464.392100;
576, 477.757440;
608, 382.021257;
640, 347.210596;
672, 331.052185;
704, 309.229199;
736, 284.777326;
768, 269.633909;
800, 256.641604;
832, 243.179641;
864, 233.122620;
896, 221.557480;
928, 206.595128;
960, 201.534419;
992, 194.138194;
1024, 192.772338;
1056, 188.112414;
1088, 185.533771;
1120, 184.091926;
1152, 181.498689;
1184, 180.543617;
1216, 178.259673;
1248, 177.566857;
1280, 176.428957;
1312, 175.002215;
1344, 172.996376;
1376, 170.913116;
1408, 171.596902;
1440, 170.465325;
1472, 169.759941;
1504, 169.285405;
1536, 168.382824;
1568, 168.248014;
1600, 169.571531;
1632, 167.783392;
1664, 167.027132;
1696, 167.834931;
1728, 166.668560;
1760, 165.222038;
1792, 166.662711;
1824, 164.835116;
1856, 162.848463;
1888, 162.334801;
1920, 162.685154;
1952, 161.847767;
1984, 164.370842;
2016, 161.933021;
2048, 161.343642];

gs = [512, 650.250000;
544, 640.940802;
576, 627.573333;
608, 648.062576;
640, 660.070459;
672, 649.013612;
704, 649.850000;
736, 653.037576;
768, 645.968723;
800, 647.597837;
832, 645.844759;
864, 636.895767;
896, 639.388800;
928, 635.167407;
960, 632.940690;
992, 625.595412;
1024, 639.480326;
1056, 631.799970;
1088, 631.819004;
1120, 632.872911;
1152, 632.270664;
1184, 630.281267;
1216, 631.626406;
1248, 629.398804;
1280, 628.186154;
1312, 631.693058;
1344, 630.075053;
1376, 632.807775;
1408, 627.566984;
1440, 629.800363;
1472, 630.919708;
1504, 628.121618;
1536, 633.136002;
1568, 630.155582;
1600, 631.819807;
1632, 632.595238;
1664, 630.169854;
1696, 631.846343;
1728, 631.606442;
1760, 631.802055;
1792, 632.388366;
1824, 631.318769;
1856, 630.700183;
1888, 632.354844;
1920, 632.445568;
1952, 631.994635;
1984, 632.750259;
2016, 631.314553;
2048, 637.479756;
2080, 631.914809;
2112, 631.503546;
2144, 630.675681;
2176, 630.170343;
2208, 626.579675;
2240, 628.043135;
2272, 626.492401;
2304, 625.890359;
2336, 624.958564;
2368, 623.149149;
2400, 623.350196;
2432, 622.660863;
2464, 621.686724;
2496, 620.968756;
2528, 616.987303;
2560, 623.177524;
2592, 618.733377;
2624, 617.967101;
2656, 617.869825;
2688, 617.071734;
2720, 616.054901;
2752, 615.671684;
2784, 615.469105;
2816, 614.241527;
2848, 614.002554;
2880, 613.168502;
2912, 612.520906;
2944, 612.047026;
2976, 611.735551;
3008, 611.231434;
3040, 607.866817;
3072, 613.666881;
3104, 609.978163;
3136, 609.428564;
3168, 609.026311;
3200, 609.064319;
3232, 608.332450;
3264, 607.747425;
3296, 607.300664;
3328, 607.539213;
3360, 606.789121;
3392, 604.317319;
3424, 606.216653;
3456, 605.845976;
3488, 605.842859;
3520, 605.199292;
3552, 602.750124;
3584, 607.132146;
3616, 604.209576;
3648, 604.241705;
3680, 603.689900;
3712, 603.688596;
3744, 603.342162;
3776, 603.094362;
3808, 602.731124;
3840, 602.464029;
3872, 602.288244;
3904, 600.813088;];

plot(mmm(:,1),mmm(:,2), 'r*')
hold on
plot(gs(:,1), gs(:,2), 'b+')

xlabel('Matrix row/column size')
ylabel('MFLOPS')
title('MFLOP rate')
legend('Matrix-Matrix-Multiplication', 'Gauss-Seidel')
print -dpng mflops.png

pause
close all

tiled = [1, 113.204205;
2, 248.072860;
4, 547.362064;
8, 1073.741824;
16, 1248.537005;
32, 1447.742111;
64, 1079.137512;
128, 1077.333114;
256, 823.842726;
512, 496.336821;
1024, 192.541892];

tiled2 = [1, 102.370819;
2, 226.318940;
4, 484.030920;
8, 744.469324;
16, 925.639603;
32, 1032.030691;
64, 854.153356;
128, 773.055542;
256, 387.253833;
512, 265.764000;
1024, 188.430875];

semilogx(tiled(:,1), tiled(:,2), 'r*')
hold on
semilogx(tiled2(:,1), tiled2(:,2), 'b+')
xlabel('tile width n (logarithmic!)')
ylabel('MFLOPS')
title('Tiling and Cache')
legend('Matrices 1024x1024', 'Matrices 2048x2048')
print -dpng tiled.png

