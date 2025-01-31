--circle in the middle of the fields, free of obstacles (one hopes) to land a helicopter for SAR evacuation
------------------------------------------------------------------------------------------------------- 
-- last modification:  modification
if not versionDCE then versionDCE = {} end
versionDCE["Mission Scripts/circleSAR.lua"] = "1.1.2"
------------------------------------------------------------------------------------------------------- 
-- Miguel21 modification M61_a			SAR 
------------------------------------------------------------------------------------------------------- 

circleSAR = {
   {   
       x2d = 38,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 38,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 38,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 38,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 38,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 38,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 38,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 8,   
       y2d = 1508,  
       radius = 12,  
   },  
   {   
       x2d = 38,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 51,   
       y2d = 351,  
       radius = 5,  
   },  
   {   
       x2d = 88,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 138,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 138,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 138,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 138,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 138,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 138,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 138,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 173,   
       y2d = 1523,  
       radius = 27,  
   },  
   {   
       x2d = 201,   
       y2d = 551,  
       radius = 5,  
   },  
   {   
       x2d = 216,   
       y2d = 866,  
       radius = 20,  
   },  
   {   
       x2d = 238,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 238,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 238,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 238,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 238,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 251,   
       y2d = 601,  
       radius = 5,  
   },  
   {   
       x2d = 266,   
       y2d = 866,  
       radius = 20,  
   },  
   {   
       x2d = 258,   
       y2d = 1558,  
       radius = 12,  
   },  
   {   
       x2d = 301,   
       y2d = 651,  
       radius = 5,  
   },  
   {   
       x2d = 338,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 338,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 338,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 338,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 323,   
       y2d = 1373,  
       radius = 27,  
   },  
   {   
       x2d = 308,   
       y2d = 1508,  
       radius = 12,  
   },  
   {   
       x2d = 301,   
       y2d = 1551,  
       radius = 5,  
   },  
   {   
       x2d = 351,   
       y2d = 701,  
       radius = 5,  
   },  
   {   
       x2d = 373,   
       y2d = 1473,  
       radius = 27,  
   },  
   {   
       x2d = 401,   
       y2d = 751,  
       radius = 5,  
   },  
   {   
       x2d = 438,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 438,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 438,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 501,   
       y2d = 801,  
       radius = 5,  
   },  
   {   
       x2d = 538,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 538,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 531,   
       y2d = 1181,  
       radius = 35,  
   },  
   {   
       x2d = 638,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 638,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 638,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 738,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 738,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 738,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 738,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 838,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 838,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 838,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 838,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 823,   
       y2d = 1173,  
       radius = 27,  
   },  
   {   
       x2d = 881,   
       y2d = 1181,  
       radius = 35,  
   },  
   {   
       x2d = 938,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 938,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 938,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 938,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 938,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 958,   
       y2d = 558,  
       radius = 12,  
   },  
   {   
       x2d = 981,   
       y2d = 1231,  
       radius = 35,  
   },  
   {   
       x2d = 1008,   
       y2d = 558,  
       radius = 12,  
   },  
   {   
       x2d = 1001,   
       y2d = 651,  
       radius = 5,  
   },  
   {   
       x2d = 1038,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 1038,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 1038,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 1038,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 1038,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 1001,   
       y2d = 1301,  
       radius = 5,  
   },  
   {   
       x2d = 1066,   
       y2d = 516,  
       radius = 20,  
   },  
   {   
       x2d = 1088,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 1073,   
       y2d = 1323,  
       radius = 27,  
   },  
   {   
       x2d = 1101,   
       y2d = 401,  
       radius = 5,  
   },  
   {   
       x2d = 1101,   
       y2d = 451,  
       radius = 5,  
   },  
   {   
       x2d = 1116,   
       y2d = 516,  
       radius = 20,  
   },  
   {   
       x2d = 1138,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 1138,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 1138,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 1138,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 1138,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 1138,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 1181,   
       y2d = 581,  
       radius = 35,  
   },  
   {   
       x2d = 1188,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 1151,   
       y2d = 1451,  
       radius = 5,  
   },  
   {   
       x2d = 1238,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 1238,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 1238,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 1238,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 1238,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 1238,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 1223,   
       y2d = 1373,  
       radius = 27,  
   },  
   {   
       x2d = 1288,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 1338,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 1338,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 1338,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 1338,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 1338,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 1338,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 1323,   
       y2d = 1373,  
       radius = 27,  
   },  
   {   
       x2d = 1388,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 1438,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 1438,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 1438,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 1438,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 1438,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 1438,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 1401,   
       y2d = 1351,  
       radius = 5,  
   },  
   {   
       x2d = 1488,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 1538,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 1538,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 1538,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 1538,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 1538,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 1538,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 1531,   
       y2d = 1031,  
       radius = 35,  
   },  
   {   
       x2d = 1516,   
       y2d = 1266,  
       radius = 20,  
   },  
   {   
       x2d = 1516,   
       y2d = 1316,  
       radius = 20,  
   },  
   {   
       x2d = 1566,   
       y2d = 1116,  
       radius = 20,  
   },  
   {   
       x2d = 1551,   
       y2d = 1351,  
       radius = 5,  
   },  
   {   
       x2d = 1638,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 1638,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 1638,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 1638,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 1616,   
       y2d = 866,  
       radius = 20,  
   },  
   {   
       x2d = 1638,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 1638,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 1638,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 1601,   
       y2d = 1351,  
       radius = 5,  
   },  
   {   
       x2d = 1688,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 1688,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 1738,   
       y2d = 388,  
       radius = 42,  
   },  
   {   
       x2d = 1738,   
       y2d = 488,  
       radius = 42,  
   },  
   {   
       x2d = 1738,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 1738,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 1723,   
       y2d = 923,  
       radius = 27,  
   },  
   {   
       x2d = 1738,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 1738,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 1738,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 1788,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 1781,   
       y2d = 1281,  
       radius = 35,  
   },  
   {   
       x2d = 1758,   
       y2d = 1358,  
       radius = 12,  
   },  
   {   
       x2d = 1838,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 1838,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 1823,   
       y2d = 623,  
       radius = 27,  
   },  
   {   
       x2d = 1838,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 1838,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 1838,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 1838,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 1888,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 1873,   
       y2d = 1273,  
       radius = 27,  
   },  
   {   
       x2d = 1938,   
       y2d = 388,  
       radius = 42,  
   },  
   {   
       x2d = 1938,   
       y2d = 488,  
       radius = 42,  
   },  
   {   
       x2d = 1938,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 1938,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 1938,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 1938,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 1988,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 1973,   
       y2d = 773,  
       radius = 27,  
   },  
   {   
       x2d = 1951,   
       y2d = 1001,  
       radius = 5,  
   },  
   {   
       x2d = 2038,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 2038,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 2023,   
       y2d = 873,  
       radius = 27,  
   },  
   {   
       x2d = 2016,   
       y2d = 966,  
       radius = 20,  
   },  
   {   
       x2d = 2038,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 2031,   
       y2d = 1231,  
       radius = 35,  
   },  
   {   
       x2d = 2001,   
       y2d = 1301,  
       radius = 5,  
   },  
   {   
       x2d = 2088,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 2051,   
       y2d = 751,  
       radius = 5,  
   },  
   {   
       x2d = 2058,   
       y2d = 808,  
       radius = 12,  
   },  
   {   
       x2d = 2051,   
       y2d = 1001,  
       radius = 5,  
   },  
   {   
       x2d = 2138,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 2131,   
       y2d = 531,  
       radius = 35,  
   },  
   {   
       x2d = 2108,   
       y2d = 1208,  
       radius = 12,  
   },  
   {   
       x2d = 2151,   
       y2d = 701,  
       radius = 5,  
   },  
   {   
       x2d = 2238,   
       y2d = 488,  
       radius = 42,  
   },  
   {   
       x2d = 2273,   
       y2d = 573,  
       radius = 27,  
   },  
   {   
       x2d = 2323,   
       y2d = 423,  
       radius = 27,  
   },  
   {   
       x2d = 2331,   
       y2d = 481,  
       radius = 35,  
   },  
   {   
       x2d = 2366,   
       y2d = 566,  
       radius = 20,  
   },  
   {   
       x2d = 2408,   
       y2d = 508,  
       radius = 12,  
   },  
   {   
       x2d = 2408,   
       y2d = 958,  
       radius = 12,  
   },  
   {   
       x2d = 2488,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 2501,   
       y2d = 601,  
       radius = 5,  
   },  
   {   
       x2d = 2508,   
       y2d = 908,  
       radius = 12,  
   },  
   {   
       x2d = 2588,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 2651,   
       y2d = 451,  
       radius = 5,  
   },  
   {   
       x2d = 2658,   
       y2d = 558,  
       radius = 12,  
   },  
   {   
       x2d = 2651,   
       y2d = 851,  
       radius = 5,  
   },  
   {   
       x2d = 2688,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 2688,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 2738,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 2723,   
       y2d = 623,  
       radius = 27,  
   },  
   {   
       x2d = 2788,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 2773,   
       y2d = 873,  
       radius = 27,  
   },  
   {   
       x2d = 2788,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 2788,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 2838,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 2866,   
       y2d = 616,  
       radius = 20,  
   },  
   {   
       x2d = 2851,   
       y2d = 801,  
       radius = 5,  
   },  
   {   
       x2d = 2888,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 2866,   
       y2d = 1066,  
       radius = 20,  
   },  
   {   
       x2d = 2916,   
       y2d = 516,  
       radius = 20,  
   },  
   {   
       x2d = 2916,   
       y2d = 1066,  
       radius = 20,  
   },  
   {   
       x2d = 2973,   
       y2d = 523,  
       radius = 27,  
   },  
   {   
       x2d = 2951,   
       y2d = 601,  
       radius = 5,  
   },  
   {   
       x2d = 2988,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 2958,   
       y2d = 1058,  
       radius = 12,  
   },  
   {   
       x2d = 3031,   
       y2d = 531,  
       radius = 35,  
   },  
   {   
       x2d = 3016,   
       y2d = 616,  
       radius = 20,  
   },  
   {   
       x2d = 3001,   
       y2d = 951,  
       radius = 5,  
   },  
   {   
       x2d = 3001,   
       y2d = 1051,  
       radius = 5,  
   },  
   {   
       x2d = 3088,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 3088,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 3088,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 3123,   
       y2d = 923,  
       radius = 27,  
   },  
   {   
       x2d = 3151,   
       y2d = 551,  
       radius = 5,  
   },  
   {   
       x2d = 3188,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 3201,   
       y2d = 551,  
       radius = 5,  
   },  
   {   
       x2d = 3201,   
       y2d = 701,  
       radius = 5,  
   },  
   {   
       x2d = 3208,   
       y2d = 1258,  
       radius = 12,  
   },  
   {   
       x2d = 3266,   
       y2d = 816,  
       radius = 20,  
   },  
   {   
       x2d = 3258,   
       y2d = 958,  
       radius = 12,  
   },  
   {   
       x2d = 3316,   
       y2d = 616,  
       radius = 20,  
   },  
   {   
       x2d = 3308,   
       y2d = 808,  
       radius = 12,  
   },  
   {   
       x2d = 3316,   
       y2d = 966,  
       radius = 20,  
   },  
   {   
       x2d = 3301,   
       y2d = 1151,  
       radius = 5,  
   },  
   {   
       x2d = 3301,   
       y2d = 1251,  
       radius = 5,  
   },  
   {   
       x2d = 3301,   
       y2d = 1301,  
       radius = 5,  
   },  
   {   
       x2d = 3358,   
       y2d = 608,  
       radius = 12,  
   },  
   {   
       x2d = 3351,   
       y2d = 801,  
       radius = 5,  
   },  
   {   
       x2d = 3351,   
       y2d = 851,  
       radius = 5,  
   },  
   {   
       x2d = 3388,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 3366,   
       y2d = 1116,  
       radius = 20,  
   },  
   {   
       x2d = 3388,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 3408,   
       y2d = 608,  
       radius = 12,  
   },  
   {   
       x2d = 3408,   
       y2d = 708,  
       radius = 12,  
   },  
   {   
       x2d = 3408,   
       y2d = 758,  
       radius = 12,  
   },  
   {   
       x2d = 3408,   
       y2d = 808,  
       radius = 12,  
   },  
   {   
       x2d = 3431,   
       y2d = 1031,  
       radius = 35,  
   },  
   {   
       x2d = 3401,   
       y2d = 1351,  
       radius = 5,  
   },  
   {   
       x2d = 3451,   
       y2d = 701,  
       radius = 5,  
   },  
   {   
       x2d = 3458,   
       y2d = 808,  
       radius = 12,  
   },  
   {   
       x2d = 3473,   
       y2d = 923,  
       radius = 27,  
   },  
   {   
       x2d = 3488,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 3538,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 3508,   
       y2d = 1008,  
       radius = 12,  
   },  
   {   
       x2d = 3573,   
       y2d = 623,  
       radius = 27,  
   },  
   {   
       x2d = 3588,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 3566,   
       y2d = 1066,  
       radius = 20,  
   },  
   {   
       x2d = 3558,   
       y2d = 1208,  
       radius = 12,  
   },  
   {   
       x2d = 3608,   
       y2d = 708,  
       radius = 12,  
   },  
   {   
       x2d = 3608,   
       y2d = 1108,  
       radius = 12,  
   },  
   {   
       x2d = 3608,   
       y2d = 1308,  
       radius = 12,  
   },  
   {   
       x2d = 3616,   
       y2d = 1366,  
       radius = 20,  
   },  
   {   
       x2d = 3658,   
       y2d = 658,  
       radius = 12,  
   },  
   {   
       x2d = 3673,   
       y2d = 773,  
       radius = 27,  
   },  
   {   
       x2d = 3651,   
       y2d = 851,  
       radius = 5,  
   },  
   {   
       x2d = 3681,   
       y2d = 931,  
       radius = 35,  
   },  
   {   
       x2d = 3681,   
       y2d = 1031,  
       radius = 35,  
   },  
   {   
       x2d = 3673,   
       y2d = 1123,  
       radius = 27,  
   },  
   {   
       x2d = 3688,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 3651,   
       y2d = 1301,  
       radius = 5,  
   },  
   {   
       x2d = 3681,   
       y2d = 1481,  
       radius = 35,  
   },  
   {   
       x2d = 3658,   
       y2d = 1658,  
       radius = 12,  
   },  
   {   
       x2d = 3651,   
       y2d = 1701,  
       radius = 5,  
   },  
   {   
       x2d = 3651,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 3708,   
       y2d = 608,  
       radius = 12,  
   },  
   {   
       x2d = 3701,   
       y2d = 651,  
       radius = 5,  
   },  
   {   
       x2d = 3738,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 3723,   
       y2d = 1273,  
       radius = 27,  
   },  
   {   
       x2d = 3738,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 3701,   
       y2d = 1551,  
       radius = 5,  
   },  
   {   
       x2d = 3708,   
       y2d = 1658,  
       radius = 12,  
   },  
   {   
       x2d = 3758,   
       y2d = 558,  
       radius = 12,  
   },  
   {   
       x2d = 3766,   
       y2d = 966,  
       radius = 20,  
   },  
   {   
       x2d = 3758,   
       y2d = 1008,  
       radius = 12,  
   },  
   {   
       x2d = 3751,   
       y2d = 1051,  
       radius = 5,  
   },  
   {   
       x2d = 3781,   
       y2d = 1181,  
       radius = 35,  
   },  
   {   
       x2d = 3788,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 3758,   
       y2d = 1658,  
       radius = 12,  
   },  
   {   
       x2d = 3751,   
       y2d = 1701,  
       radius = 5,  
   },  
   {   
       x2d = 3758,   
       y2d = 1758,  
       radius = 12,  
   },  
   {   
       x2d = 3758,   
       y2d = 1808,  
       radius = 12,  
   },  
   {   
       x2d = 3781,   
       y2d = 1881,  
       radius = 35,  
   },  
   {   
       x2d = 3816,   
       y2d = 566,  
       radius = 20,  
   },  
   {   
       x2d = 3838,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 3808,   
       y2d = 1058,  
       radius = 12,  
   },  
   {   
       x2d = 3801,   
       y2d = 1301,  
       radius = 5,  
   },  
   {   
       x2d = 3831,   
       y2d = 1381,  
       radius = 35,  
   },  
   {   
       x2d = 3808,   
       y2d = 1608,  
       radius = 12,  
   },  
   {   
       x2d = 3816,   
       y2d = 1666,  
       radius = 20,  
   },  
   {   
       x2d = 3808,   
       y2d = 1808,  
       radius = 12,  
   },  
   {   
       x2d = 3816,   
       y2d = 1966,  
       radius = 20,  
   },  
   {   
       x2d = 3866,   
       y2d = 516,  
       radius = 20,  
   },  
   {   
       x2d = 3851,   
       y2d = 601,  
       radius = 5,  
   },  
   {   
       x2d = 3866,   
       y2d = 1116,  
       radius = 20,  
   },  
   {   
       x2d = 3858,   
       y2d = 1158,  
       radius = 12,  
   },  
   {   
       x2d = 3858,   
       y2d = 1208,  
       radius = 12,  
   },  
   {   
       x2d = 3851,   
       y2d = 1251,  
       radius = 5,  
   },  
   {   
       x2d = 3866,   
       y2d = 1566,  
       radius = 20,  
   },  
   {   
       x2d = 3851,   
       y2d = 1701,  
       radius = 5,  
   },  
   {   
       x2d = 3851,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 3851,   
       y2d = 1901,  
       radius = 5,  
   },  
   {   
       x2d = 3888,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 3938,   
       y2d = 488,  
       radius = 42,  
   },  
   {   
       x2d = 3916,   
       y2d = 666,  
       radius = 20,  
   },  
   {   
       x2d = 3938,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 3931,   
       y2d = 1031,  
       radius = 35,  
   },  
   {   
       x2d = 3901,   
       y2d = 1151,  
       radius = 5,  
   },  
   {   
       x2d = 3901,   
       y2d = 1201,  
       radius = 5,  
   },  
   {   
       x2d = 3901,   
       y2d = 1251,  
       radius = 5,  
   },  
   {   
       x2d = 3916,   
       y2d = 1366,  
       radius = 20,  
   },  
   {   
       x2d = 3938,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 3931,   
       y2d = 1681,  
       radius = 35,  
   },  
   {   
       x2d = 3916,   
       y2d = 1816,  
       radius = 20,  
   },  
   {   
       x2d = 3901,   
       y2d = 1901,  
       radius = 5,  
   },  
   {   
       x2d = 3966,   
       y2d = 666,  
       radius = 20,  
   },  
   {   
       x2d = 3958,   
       y2d = 708,  
       radius = 12,  
   },  
   {   
       x2d = 3966,   
       y2d = 1116,  
       radius = 20,  
   },  
   {   
       x2d = 3951,   
       y2d = 1201,  
       radius = 5,  
   },  
   {   
       x2d = 3951,   
       y2d = 1251,  
       radius = 5,  
   },  
   {   
       x2d = 3958,   
       y2d = 1358,  
       radius = 12,  
   },  
   {   
       x2d = 3951,   
       y2d = 1401,  
       radius = 5,  
   },  
   {   
       x2d = 3951,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 3951,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 3988,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 4038,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 4038,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 4038,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 4031,   
       y2d = 331,  
       radius = 35,  
   },  
   {   
       x2d = 4008,   
       y2d = 408,  
       radius = 12,  
   },  
   {   
       x2d = 4001,   
       y2d = 551,  
       radius = 5,  
   },  
   {   
       x2d = 4038,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 4038,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 4038,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 4001,   
       y2d = 1201,  
       radius = 5,  
   },  
   {   
       x2d = 4023,   
       y2d = 1273,  
       radius = 27,  
   },  
   {   
       x2d = 4008,   
       y2d = 1408,  
       radius = 12,  
   },  
   {   
       x2d = 4008,   
       y2d = 1458,  
       radius = 12,  
   },  
   {   
       x2d = 4008,   
       y2d = 1608,  
       radius = 12,  
   },  
   {   
       x2d = 4001,   
       y2d = 1651,  
       radius = 5,  
   },  
   {   
       x2d = 4001,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 4051,   
       y2d = 401,  
       radius = 5,  
   },  
   {   
       x2d = 4051,   
       y2d = 451,  
       radius = 5,  
   },  
   {   
       x2d = 4073,   
       y2d = 1123,  
       radius = 27,  
   },  
   {   
       x2d = 4051,   
       y2d = 1401,  
       radius = 5,  
   },  
   {   
       x2d = 4058,   
       y2d = 1508,  
       radius = 12,  
   },  
   {   
       x2d = 4073,   
       y2d = 1623,  
       radius = 27,  
   },  
   {   
       x2d = 4066,   
       y2d = 1716,  
       radius = 20,  
   },  
   {   
       x2d = 4058,   
       y2d = 1808,  
       radius = 12,  
   },  
   {   
       x2d = 4051,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 4051,   
       y2d = 1901,  
       radius = 5,  
   },  
   {   
       x2d = 4051,   
       y2d = 2101,  
       radius = 5,  
   },  
   {   
       x2d = 4138,   
       y2d = 88,  
       radius = 42,  
   },  
   {   
       x2d = 4138,   
       y2d = 288,  
       radius = 42,  
   },  
   {   
       x2d = 4101,   
       y2d = 451,  
       radius = 5,  
   },  
   {   
       x2d = 4101,   
       y2d = 501,  
       radius = 5,  
   },  
   {   
       x2d = 4138,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 4138,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 4131,   
       y2d = 831,  
       radius = 35,  
   },  
   {   
       x2d = 4101,   
       y2d = 1551,  
       radius = 5,  
   },  
   {   
       x2d = 4101,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 4101,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 4116,   
       y2d = 2016,  
       radius = 20,  
   },  
   {   
       x2d = 4108,   
       y2d = 2108,  
       radius = 12,  
   },  
   {   
       x2d = 4173,   
       y2d = 173,  
       radius = 27,  
   },  
   {   
       x2d = 4173,   
       y2d = 373,  
       radius = 27,  
   },  
   {   
       x2d = 4151,   
       y2d = 451,  
       radius = 5,  
   },  
   {   
       x2d = 4158,   
       y2d = 1008,  
       radius = 12,  
   },  
   {   
       x2d = 4158,   
       y2d = 1108,  
       radius = 12,  
   },  
   {   
       x2d = 4151,   
       y2d = 1151,  
       radius = 5,  
   },  
   {   
       x2d = 4151,   
       y2d = 1201,  
       radius = 5,  
   },  
   {   
       x2d = 4151,   
       y2d = 1301,  
       radius = 5,  
   },  
   {   
       x2d = 4151,   
       y2d = 1351,  
       radius = 5,  
   },  
   {   
       x2d = 4151,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 4151,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 4166,   
       y2d = 1866,  
       radius = 20,  
   },  
   {   
       x2d = 4173,   
       y2d = 1923,  
       radius = 27,  
   },  
   {   
       x2d = 4238,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 4238,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 4238,   
       y2d = 288,  
       radius = 42,  
   },  
   {   
       x2d = 4238,   
       y2d = 488,  
       radius = 42,  
   },  
   {   
       x2d = 4238,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 4238,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 4238,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 4238,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 4231,   
       y2d = 1031,  
       radius = 35,  
   },  
   {   
       x2d = 4208,   
       y2d = 1158,  
       radius = 12,  
   },  
   {   
       x2d = 4231,   
       y2d = 1231,  
       radius = 35,  
   },  
   {   
       x2d = 4201,   
       y2d = 1301,  
       radius = 5,  
   },  
   {   
       x2d = 4201,   
       y2d = 1351,  
       radius = 5,  
   },  
   {   
       x2d = 4201,   
       y2d = 1401,  
       radius = 5,  
   },  
   {   
       x2d = 4201,   
       y2d = 1651,  
       radius = 5,  
   },  
   {   
       x2d = 4201,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 4208,   
       y2d = 2008,  
       radius = 12,  
   },  
   {   
       x2d = 4201,   
       y2d = 2051,  
       radius = 5,  
   },  
   {   
       x2d = 4201,   
       y2d = 2101,  
       radius = 5,  
   },  
   {   
       x2d = 4288,   
       y2d = 388,  
       radius = 42,  
   },  
   {   
       x2d = 4251,   
       y2d = 1101,  
       radius = 5,  
   },  
   {   
       x2d = 4258,   
       y2d = 1308,  
       radius = 12,  
   },  
   {   
       x2d = 4251,   
       y2d = 1351,  
       radius = 5,  
   },  
   {   
       x2d = 4266,   
       y2d = 1416,  
       radius = 20,  
   },  
   {   
       x2d = 4251,   
       y2d = 1501,  
       radius = 5,  
   },  
   {   
       x2d = 4251,   
       y2d = 1701,  
       radius = 5,  
   },  
   {   
       x2d = 4251,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 4251,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 4251,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 4251,   
       y2d = 1951,  
       radius = 5,  
   },  
   {   
       x2d = 4251,   
       y2d = 2101,  
       radius = 5,  
   },  
   {   
       x2d = 4338,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 4316,   
       y2d = 266,  
       radius = 20,  
   },  
   {   
       x2d = 4338,   
       y2d = 488,  
       radius = 42,  
   },  
   {   
       x2d = 4338,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 4338,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 4338,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 4316,   
       y2d = 916,  
       radius = 20,  
   },  
   {   
       x2d = 4331,   
       y2d = 1031,  
       radius = 35,  
   },  
   {   
       x2d = 4301,   
       y2d = 1251,  
       radius = 5,  
   },  
   {   
       x2d = 4308,   
       y2d = 1358,  
       radius = 12,  
   },  
   {   
       x2d = 4308,   
       y2d = 1408,  
       radius = 12,  
   },  
   {   
       x2d = 4308,   
       y2d = 1808,  
       radius = 12,  
   },  
   {   
       x2d = 4301,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 4301,   
       y2d = 2001,  
       radius = 5,  
   },  
   {   
       x2d = 4388,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 4366,   
       y2d = 266,  
       radius = 20,  
   },  
   {   
       x2d = 4358,   
       y2d = 958,  
       radius = 12,  
   },  
   {   
       x2d = 4351,   
       y2d = 1101,  
       radius = 5,  
   },  
   {   
       x2d = 4366,   
       y2d = 1266,  
       radius = 20,  
   },  
   {   
       x2d = 4358,   
       y2d = 1358,  
       radius = 12,  
   },  
   {   
       x2d = 4351,   
       y2d = 1401,  
       radius = 5,  
   },  
   {   
       x2d = 4366,   
       y2d = 1466,  
       radius = 20,  
   },  
   {   
       x2d = 4351,   
       y2d = 1551,  
       radius = 5,  
   },  
   {   
       x2d = 4351,   
       y2d = 1601,  
       radius = 5,  
   },  
   {   
       x2d = 4351,   
       y2d = 1651,  
       radius = 5,  
   },  
   {   
       x2d = 4358,   
       y2d = 1858,  
       radius = 12,  
   },  
   {   
       x2d = 4351,   
       y2d = 2051,  
       radius = 5,  
   },  
   {   
       x2d = 4438,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 4423,   
       y2d = 273,  
       radius = 27,  
   },  
   {   
       x2d = 4438,   
       y2d = 388,  
       radius = 42,  
   },  
   {   
       x2d = 4438,   
       y2d = 488,  
       radius = 42,  
   },  
   {   
       x2d = 4438,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 4438,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 4423,   
       y2d = 773,  
       radius = 27,  
   },  
   {   
       x2d = 4431,   
       y2d = 831,  
       radius = 35,  
   },  
   {   
       x2d = 4416,   
       y2d = 916,  
       radius = 20,  
   },  
   {   
       x2d = 4431,   
       y2d = 981,  
       radius = 35,  
   },  
   {   
       x2d = 4423,   
       y2d = 1073,  
       radius = 27,  
   },  
   {   
       x2d = 4401,   
       y2d = 1201,  
       radius = 5,  
   },  
   {   
       x2d = 4408,   
       y2d = 1258,  
       radius = 12,  
   },  
   {   
       x2d = 4408,   
       y2d = 1308,  
       radius = 12,  
   },  
   {   
       x2d = 4416,   
       y2d = 1366,  
       radius = 20,  
   },  
   {   
       x2d = 4401,   
       y2d = 1501,  
       radius = 5,  
   },  
   {   
       x2d = 4401,   
       y2d = 1601,  
       radius = 5,  
   },  
   {   
       x2d = 4401,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 4401,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 4408,   
       y2d = 2108,  
       radius = 12,  
   },  
   {   
       x2d = 4488,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 4488,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 4458,   
       y2d = 908,  
       radius = 12,  
   },  
   {   
       x2d = 4488,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 4473,   
       y2d = 1223,  
       radius = 27,  
   },  
   {   
       x2d = 4451,   
       y2d = 1401,  
       radius = 5,  
   },  
   {   
       x2d = 4458,   
       y2d = 1458,  
       radius = 12,  
   },  
   {   
       x2d = 4473,   
       y2d = 1523,  
       radius = 27,  
   },  
   {   
       x2d = 4451,   
       y2d = 1651,  
       radius = 5,  
   },  
   {   
       x2d = 4458,   
       y2d = 1708,  
       radius = 12,  
   },  
   {   
       x2d = 4451,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 4458,   
       y2d = 1858,  
       radius = 12,  
   },  
   {   
       x2d = 4458,   
       y2d = 1908,  
       radius = 12,  
   },  
   {   
       x2d = 4531,   
       y2d = 31,  
       radius = 35,  
   },  
   {   
       x2d = 4538,   
       y2d = 388,  
       radius = 42,  
   },  
   {   
       x2d = 4538,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 4538,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 4501,   
       y2d = 751,  
       radius = 5,  
   },  
   {   
       x2d = 4531,   
       y2d = 881,  
       radius = 35,  
   },  
   {   
       x2d = 4508,   
       y2d = 958,  
       radius = 12,  
   },  
   {   
       x2d = 4501,   
       y2d = 1401,  
       radius = 5,  
   },  
   {   
       x2d = 4538,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 4501,   
       y2d = 1651,  
       radius = 5,  
   },  
   {   
       x2d = 4501,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 4501,   
       y2d = 1951,  
       radius = 5,  
   },  
   {   
       x2d = 4588,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 4588,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 4573,   
       y2d = 723,  
       radius = 27,  
   },  
   {   
       x2d = 4558,   
       y2d = 958,  
       radius = 12,  
   },  
   {   
       x2d = 4588,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 4581,   
       y2d = 1131,  
       radius = 35,  
   },  
   {   
       x2d = 4551,   
       y2d = 1351,  
       radius = 5,  
   },  
   {   
       x2d = 4558,   
       y2d = 1408,  
       radius = 12,  
   },  
   {   
       x2d = 4551,   
       y2d = 1451,  
       radius = 5,  
   },  
   {   
       x2d = 4551,   
       y2d = 1651,  
       radius = 5,  
   },  
   {   
       x2d = 4551,   
       y2d = 1701,  
       radius = 5,  
   },  
   {   
       x2d = 4551,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 4551,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 4558,   
       y2d = 2008,  
       radius = 12,  
   },  
   {   
       x2d = 4616,   
       y2d = 16,  
       radius = 20,  
   },  
   {   
       x2d = 4638,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 4638,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 4638,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 4638,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 4638,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 4638,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 4601,   
       y2d = 1201,  
       radius = 5,  
   },  
   {   
       x2d = 4638,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 4631,   
       y2d = 1481,  
       radius = 35,  
   },  
   {   
       x2d = 4623,   
       y2d = 1573,  
       radius = 27,  
   },  
   {   
       x2d = 4608,   
       y2d = 1658,  
       radius = 12,  
   },  
   {   
       x2d = 4601,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 4601,   
       y2d = 2001,  
       radius = 5,  
   },  
   {   
       x2d = 4608,   
       y2d = 2058,  
       radius = 12,  
   },  
   {   
       x2d = 4658,   
       y2d = 8,  
       radius = 12,  
   },  
   {   
       x2d = 4688,   
       y2d = 88,  
       radius = 42,  
   },  
   {   
       x2d = 4688,   
       y2d = 188,  
       radius = 42,  
   },  
   {   
       x2d = 4688,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 4688,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 4651,   
       y2d = 1201,  
       radius = 5,  
   },  
   {   
       x2d = 4658,   
       y2d = 1408,  
       radius = 12,  
   },  
   {   
       x2d = 4651,   
       y2d = 1651,  
       radius = 5,  
   },  
   {   
       x2d = 4651,   
       y2d = 1701,  
       radius = 5,  
   },  
   {   
       x2d = 4651,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 4673,   
       y2d = 2073,  
       radius = 27,  
   },  
   {   
       x2d = 4651,   
       y2d = 2151,  
       radius = 5,  
   },  
   {   
       x2d = 4651,   
       y2d = 2201,  
       radius = 5,  
   },  
   {   
       x2d = 4723,   
       y2d = 273,  
       radius = 27,  
   },  
   {   
       x2d = 4738,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 4723,   
       y2d = 423,  
       radius = 27,  
   },  
   {   
       x2d = 4731,   
       y2d = 581,  
       radius = 35,  
   },  
   {   
       x2d = 4738,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 4738,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 4731,   
       y2d = 881,  
       radius = 35,  
   },  
   {   
       x2d = 4723,   
       y2d = 1173,  
       radius = 27,  
   },  
   {   
       x2d = 4738,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 4701,   
       y2d = 1551,  
       radius = 5,  
   },  
   {   
       x2d = 4708,   
       y2d = 1608,  
       radius = 12,  
   },  
   {   
       x2d = 4708,   
       y2d = 1658,  
       radius = 12,  
   },  
   {   
       x2d = 4701,   
       y2d = 1701,  
       radius = 5,  
   },  
   {   
       x2d = 4701,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 4701,   
       y2d = 1901,  
       radius = 5,  
   },  
   {   
       x2d = 4701,   
       y2d = 2151,  
       radius = 5,  
   },  
   {   
       x2d = 4701,   
       y2d = 2201,  
       radius = 5,  
   },  
   {   
       x2d = 4751,   
       y2d = 1,  
       radius = 5,  
   },  
   {   
       x2d = 4788,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 4781,   
       y2d = 231,  
       radius = 35,  
   },  
   {   
       x2d = 4781,   
       y2d = 481,  
       radius = 35,  
   },  
   {   
       x2d = 4773,   
       y2d = 1023,  
       radius = 27,  
   },  
   {   
       x2d = 4766,   
       y2d = 1116,  
       radius = 20,  
   },  
   {   
       x2d = 4766,   
       y2d = 1366,  
       radius = 20,  
   },  
   {   
       x2d = 4751,   
       y2d = 1701,  
       radius = 5,  
   },  
   {   
       x2d = 4751,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 4758,   
       y2d = 2108,  
       radius = 12,  
   },  
   {   
       x2d = 4751,   
       y2d = 2251,  
       radius = 5,  
   },  
   {   
       x2d = 4831,   
       y2d = 31,  
       radius = 35,  
   },  
   {   
       x2d = 4831,   
       y2d = 331,  
       radius = 35,  
   },  
   {   
       x2d = 4801,   
       y2d = 551,  
       radius = 5,  
   },  
   {   
       x2d = 4816,   
       y2d = 616,  
       radius = 20,  
   },  
   {   
       x2d = 4823,   
       y2d = 723,  
       radius = 27,  
   },  
   {   
       x2d = 4838,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 4801,   
       y2d = 901,  
       radius = 5,  
   },  
   {   
       x2d = 4808,   
       y2d = 958,  
       radius = 12,  
   },  
   {   
       x2d = 4838,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 4823,   
       y2d = 1423,  
       radius = 27,  
   },  
   {   
       x2d = 4801,   
       y2d = 1551,  
       radius = 5,  
   },  
   {   
       x2d = 4808,   
       y2d = 1608,  
       radius = 12,  
   },  
   {   
       x2d = 4808,   
       y2d = 2158,  
       radius = 12,  
   },  
   {   
       x2d = 4808,   
       y2d = 2208,  
       radius = 12,  
   },  
   {   
       x2d = 4801,   
       y2d = 2251,  
       radius = 5,  
   },  
   {   
       x2d = 4888,   
       y2d = 188,  
       radius = 42,  
   },  
   {   
       x2d = 4888,   
       y2d = 288,  
       radius = 42,  
   },  
   {   
       x2d = 4888,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 4873,   
       y2d = 523,  
       radius = 27,  
   },  
   {   
       x2d = 4851,   
       y2d = 951,  
       radius = 5,  
   },  
   {   
       x2d = 4858,   
       y2d = 1358,  
       radius = 12,  
   },  
   {   
       x2d = 4881,   
       y2d = 1481,  
       radius = 35,  
   },  
   {   
       x2d = 4851,   
       y2d = 1601,  
       radius = 5,  
   },  
   {   
       x2d = 4851,   
       y2d = 1651,  
       radius = 5,  
   },  
   {   
       x2d = 4858,   
       y2d = 2108,  
       radius = 12,  
   },  
   {   
       x2d = 4851,   
       y2d = 2151,  
       radius = 5,  
   },  
   {   
       x2d = 4858,   
       y2d = 2208,  
       radius = 12,  
   },  
   {   
       x2d = 4851,   
       y2d = 2251,  
       radius = 5,  
   },  
   {   
       x2d = 4916,   
       y2d = 16,  
       radius = 20,  
   },  
   {   
       x2d = 4931,   
       y2d = 81,  
       radius = 35,  
   },  
   {   
       x2d = 4931,   
       y2d = 531,  
       radius = 35,  
   },  
   {   
       x2d = 4901,   
       y2d = 651,  
       radius = 5,  
   },  
   {   
       x2d = 4931,   
       y2d = 831,  
       radius = 35,  
   },  
   {   
       x2d = 4938,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 4908,   
       y2d = 1208,  
       radius = 12,  
   },  
   {   
       x2d = 4938,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 4916,   
       y2d = 1566,  
       radius = 20,  
   },  
   {   
       x2d = 4901,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 4901,   
       y2d = 2201,  
       radius = 5,  
   },  
   {   
       x2d = 4908,   
       y2d = 2258,  
       radius = 12,  
   },  
   {   
       x2d = 4966,   
       y2d = 16,  
       radius = 20,  
   },  
   {   
       x2d = 4988,   
       y2d = 188,  
       radius = 42,  
   },  
   {   
       x2d = 4988,   
       y2d = 288,  
       radius = 42,  
   },  
   {   
       x2d = 4988,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 4958,   
       y2d = 608,  
       radius = 12,  
   },  
   {   
       x2d = 4973,   
       y2d = 773,  
       radius = 27,  
   },  
   {   
       x2d = 4951,   
       y2d = 901,  
       radius = 5,  
   },  
   {   
       x2d = 4966,   
       y2d = 1516,  
       radius = 20,  
   },  
   {   
       x2d = 4958,   
       y2d = 1558,  
       radius = 12,  
   },  
   {   
       x2d = 4958,   
       y2d = 1608,  
       radius = 12,  
   },  
   {   
       x2d = 4981,   
       y2d = 1681,  
       radius = 35,  
   },  
   {   
       x2d = 4951,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 4951,   
       y2d = 2051,  
       radius = 5,  
   },  
   {   
       x2d = 5038,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 5038,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 5008,   
       y2d = 658,  
       radius = 12,  
   },  
   {   
       x2d = 5016,   
       y2d = 716,  
       radius = 20,  
   },  
   {   
       x2d = 5016,   
       y2d = 816,  
       radius = 20,  
   },  
   {   
       x2d = 5008,   
       y2d = 858,  
       radius = 12,  
   },  
   {   
       x2d = 5008,   
       y2d = 908,  
       radius = 12,  
   },  
   {   
       x2d = 5038,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 5001,   
       y2d = 1151,  
       radius = 5,  
   },  
   {   
       x2d = 5038,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 5031,   
       y2d = 1481,  
       radius = 35,  
   },  
   {   
       x2d = 5001,   
       y2d = 2101,  
       radius = 5,  
   },  
   {   
       x2d = 5001,   
       y2d = 2151,  
       radius = 5,  
   },  
   {   
       x2d = 5008,   
       y2d = 2308,  
       radius = 12,  
   },  
   {   
       x2d = 5008,   
       y2d = 2358,  
       radius = 12,  
   },  
   {   
       x2d = 5001,   
       y2d = 2401,  
       radius = 5,  
   },  
   {   
       x2d = 5001,   
       y2d = 2451,  
       radius = 5,  
   },  
   {   
       x2d = 5088,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 5088,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 5073,   
       y2d = 323,  
       radius = 27,  
   },  
   {   
       x2d = 5088,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 5081,   
       y2d = 1081,  
       radius = 35,  
   },  
   {   
       x2d = 5058,   
       y2d = 1158,  
       radius = 12,  
   },  
   {   
       x2d = 5066,   
       y2d = 1266,  
       radius = 20,  
   },  
   {   
       x2d = 5051,   
       y2d = 1551,  
       radius = 5,  
   },  
   {   
       x2d = 5073,   
       y2d = 1673,  
       radius = 27,  
   },  
   {   
       x2d = 5051,   
       y2d = 1901,  
       radius = 5,  
   },  
   {   
       x2d = 5058,   
       y2d = 2508,  
       radius = 12,  
   },  
   {   
       x2d = 5138,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 5131,   
       y2d = 381,  
       radius = 35,  
   },  
   {   
       x2d = 5138,   
       y2d = 488,  
       radius = 42,  
   },  
   {   
       x2d = 5123,   
       y2d = 573,  
       radius = 27,  
   },  
   {   
       x2d = 5101,   
       y2d = 851,  
       radius = 5,  
   },  
   {   
       x2d = 5138,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 5138,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 5108,   
       y2d = 1158,  
       radius = 12,  
   },  
   {   
       x2d = 5131,   
       y2d = 1231,  
       radius = 35,  
   },  
   {   
       x2d = 5138,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 5138,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 5138,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 5138,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 5101,   
       y2d = 2201,  
       radius = 5,  
   },  
   {   
       x2d = 5101,   
       y2d = 2301,  
       radius = 5,  
   },  
   {   
       x2d = 5101,   
       y2d = 2401,  
       radius = 5,  
   },  
   {   
       x2d = 5101,   
       y2d = 2451,  
       radius = 5,  
   },  
   {   
       x2d = 5188,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 5173,   
       y2d = 223,  
       radius = 27,  
   },  
   {   
       x2d = 5151,   
       y2d = 301,  
       radius = 5,  
   },  
   {   
       x2d = 5188,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 5173,   
       y2d = 773,  
       radius = 27,  
   },  
   {   
       x2d = 5188,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 5151,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 5151,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 5151,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 5151,   
       y2d = 2101,  
       radius = 5,  
   },  
   {   
       x2d = 5158,   
       y2d = 2208,  
       radius = 12,  
   },  
   {   
       x2d = 5151,   
       y2d = 2251,  
       radius = 5,  
   },  
   {   
       x2d = 5158,   
       y2d = 2458,  
       radius = 12,  
   },  
   {   
       x2d = 5158,   
       y2d = 2508,  
       radius = 12,  
   },  
   {   
       x2d = 5151,   
       y2d = 2551,  
       radius = 5,  
   },  
   {   
       x2d = 5151,   
       y2d = 2601,  
       radius = 5,  
   },  
   {   
       x2d = 5238,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 5238,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 5238,   
       y2d = 488,  
       radius = 42,  
   },  
   {   
       x2d = 5216,   
       y2d = 816,  
       radius = 20,  
   },  
   {   
       x2d = 5231,   
       y2d = 981,  
       radius = 35,  
   },  
   {   
       x2d = 5223,   
       y2d = 1273,  
       radius = 27,  
   },  
   {   
       x2d = 5238,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 5238,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 5216,   
       y2d = 1566,  
       radius = 20,  
   },  
   {   
       x2d = 5208,   
       y2d = 1708,  
       radius = 12,  
   },  
   {   
       x2d = 5201,   
       y2d = 1901,  
       radius = 5,  
   },  
   {   
       x2d = 5201,   
       y2d = 2201,  
       radius = 5,  
   },  
   {   
       x2d = 5208,   
       y2d = 2258,  
       radius = 12,  
   },  
   {   
       x2d = 5208,   
       y2d = 2458,  
       radius = 12,  
   },  
   {   
       x2d = 5216,   
       y2d = 2516,  
       radius = 20,  
   },  
   {   
       x2d = 5208,   
       y2d = 2558,  
       radius = 12,  
   },  
   {   
       x2d = 5201,   
       y2d = 2601,  
       radius = 5,  
   },  
   {   
       x2d = 5201,   
       y2d = 2651,  
       radius = 5,  
   },  
   {   
       x2d = 5288,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 5288,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 5288,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 5251,   
       y2d = 901,  
       radius = 5,  
   },  
   {   
       x2d = 5288,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 5251,   
       y2d = 1201,  
       radius = 5,  
   },  
   {   
       x2d = 5273,   
       y2d = 1523,  
       radius = 27,  
   },  
   {   
       x2d = 5251,   
       y2d = 1701,  
       radius = 5,  
   },  
   {   
       x2d = 5251,   
       y2d = 2201,  
       radius = 5,  
   },  
   {   
       x2d = 5251,   
       y2d = 2251,  
       radius = 5,  
   },  
   {   
       x2d = 5251,   
       y2d = 2301,  
       radius = 5,  
   },  
   {   
       x2d = 5251,   
       y2d = 2351,  
       radius = 5,  
   },  
   {   
       x2d = 5251,   
       y2d = 2551,  
       radius = 5,  
   },  
   {   
       x2d = 5251,   
       y2d = 2651,  
       radius = 5,  
   },  
   {   
       x2d = 5338,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 5338,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 5338,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 5338,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 5301,   
       y2d = 851,  
       radius = 5,  
   },  
   {   
       x2d = 5301,   
       y2d = 901,  
       radius = 5,  
   },  
   {   
       x2d = 5338,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 5338,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 5323,   
       y2d = 1673,  
       radius = 27,  
   },  
   {   
       x2d = 5308,   
       y2d = 1758,  
       radius = 12,  
   },  
   {   
       x2d = 5323,   
       y2d = 2473,  
       radius = 27,  
   },  
   {   
       x2d = 5331,   
       y2d = 2531,  
       radius = 35,  
   },  
   {   
       x2d = 5301,   
       y2d = 2651,  
       radius = 5,  
   },  
   {   
       x2d = 5388,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 5366,   
       y2d = 566,  
       radius = 20,  
   },  
   {   
       x2d = 5388,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 5373,   
       y2d = 773,  
       radius = 27,  
   },  
   {   
       x2d = 5351,   
       y2d = 851,  
       radius = 5,  
   },  
   {   
       x2d = 5351,   
       y2d = 951,  
       radius = 5,  
   },  
   {   
       x2d = 5351,   
       y2d = 1001,  
       radius = 5,  
   },  
   {   
       x2d = 5388,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 5373,   
       y2d = 1223,  
       radius = 27,  
   },  
   {   
       x2d = 5358,   
       y2d = 1608,  
       radius = 12,  
   },  
   {   
       x2d = 5351,   
       y2d = 2601,  
       radius = 5,  
   },  
   {   
       x2d = 5438,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 5438,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 5438,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 5438,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 5408,   
       y2d = 558,  
       radius = 12,  
   },  
   {   
       x2d = 5438,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 5438,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 5423,   
       y2d = 1473,  
       radius = 27,  
   },  
   {   
       x2d = 5401,   
       y2d = 1551,  
       radius = 5,  
   },  
   {   
       x2d = 5423,   
       y2d = 1723,  
       radius = 27,  
   },  
   {   
       x2d = 5401,   
       y2d = 2651,  
       radius = 5,  
   },  
   {   
       x2d = 5488,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 5473,   
       y2d = 523,  
       radius = 27,  
   },  
   {   
       x2d = 5488,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 5488,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 5451,   
       y2d = 1001,  
       radius = 5,  
   },  
   {   
       x2d = 5481,   
       y2d = 1531,  
       radius = 35,  
   },  
   {   
       x2d = 5451,   
       y2d = 1601,  
       radius = 5,  
   },  
   {   
       x2d = 5458,   
       y2d = 1658,  
       radius = 12,  
   },  
   {   
       x2d = 5451,   
       y2d = 2101,  
       radius = 5,  
   },  
   {   
       x2d = 5451,   
       y2d = 2601,  
       radius = 5,  
   },  
   {   
       x2d = 5451,   
       y2d = 2651,  
       radius = 5,  
   },  
   {   
       x2d = 5451,   
       y2d = 2701,  
       radius = 5,  
   },  
   {   
       x2d = 5538,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 5538,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 5538,   
       y2d = 388,  
       radius = 42,  
   },  
   {   
       x2d = 5538,   
       y2d = 488,  
       radius = 42,  
   },  
   {   
       x2d = 5501,   
       y2d = 651,  
       radius = 5,  
   },  
   {   
       x2d = 5531,   
       y2d = 931,  
       radius = 35,  
   },  
   {   
       x2d = 5538,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 5516,   
       y2d = 1316,  
       radius = 20,  
   },  
   {   
       x2d = 5508,   
       y2d = 1458,  
       radius = 12,  
   },  
   {   
       x2d = 5508,   
       y2d = 1608,  
       radius = 12,  
   },  
   {   
       x2d = 5531,   
       y2d = 1681,  
       radius = 35,  
   },  
   {   
       x2d = 5501,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 5501,   
       y2d = 2401,  
       radius = 5,  
   },  
   {   
       x2d = 5501,   
       y2d = 2701,  
       radius = 5,  
   },  
   {   
       x2d = 5588,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 5588,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 5581,   
       y2d = 681,  
       radius = 35,  
   },  
   {   
       x2d = 5581,   
       y2d = 781,  
       radius = 35,  
   },  
   {   
       x2d = 5551,   
       y2d = 1001,  
       radius = 5,  
   },  
   {   
       x2d = 5551,   
       y2d = 1351,  
       radius = 5,  
   },  
   {   
       x2d = 5558,   
       y2d = 1458,  
       radius = 12,  
   },  
   {   
       x2d = 5558,   
       y2d = 1558,  
       radius = 12,  
   },  
   {   
       x2d = 5551,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 5551,   
       y2d = 2401,  
       radius = 5,  
   },  
   {   
       x2d = 5638,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 5638,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 5638,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 5638,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 5638,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 5601,   
       y2d = 1001,  
       radius = 5,  
   },  
   {   
       x2d = 5616,   
       y2d = 1116,  
       radius = 20,  
   },  
   {   
       x2d = 5601,   
       y2d = 1201,  
       radius = 5,  
   },  
   {   
       x2d = 5601,   
       y2d = 1251,  
       radius = 5,  
   },  
   {   
       x2d = 5601,   
       y2d = 1401,  
       radius = 5,  
   },  
   {   
       x2d = 5623,   
       y2d = 1523,  
       radius = 27,  
   },  
   {   
       x2d = 5601,   
       y2d = 1701,  
       radius = 5,  
   },  
   {   
       x2d = 5608,   
       y2d = 1758,  
       radius = 12,  
   },  
   {   
       x2d = 5688,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 5688,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 5688,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 5688,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 5651,   
       y2d = 1351,  
       radius = 5,  
   },  
   {   
       x2d = 5658,   
       y2d = 1408,  
       radius = 12,  
   },  
   {   
       x2d = 5673,   
       y2d = 1473,  
       radius = 27,  
   },  
   {   
       x2d = 5651,   
       y2d = 1601,  
       radius = 5,  
   },  
   {   
       x2d = 5658,   
       y2d = 1658,  
       radius = 12,  
   },  
   {   
       x2d = 5651,   
       y2d = 1701,  
       radius = 5,  
   },  
   {   
       x2d = 5666,   
       y2d = 1766,  
       radius = 20,  
   },  
   {   
       x2d = 5651,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 5651,   
       y2d = 2501,  
       radius = 5,  
   },  
   {   
       x2d = 5738,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 5738,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 5738,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 5731,   
       y2d = 431,  
       radius = 35,  
   },  
   {   
       x2d = 5738,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 5701,   
       y2d = 1301,  
       radius = 5,  
   },  
   {   
       x2d = 5701,   
       y2d = 1351,  
       radius = 5,  
   },  
   {   
       x2d = 5701,   
       y2d = 1401,  
       radius = 5,  
   },  
   {   
       x2d = 5701,   
       y2d = 1551,  
       radius = 5,  
   },  
   {   
       x2d = 5701,   
       y2d = 1701,  
       radius = 5,  
   },  
   {   
       x2d = 5716,   
       y2d = 1766,  
       radius = 20,  
   },  
   {   
       x2d = 5701,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 5701,   
       y2d = 2601,  
       radius = 5,  
   },  
   {   
       x2d = 5788,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 5766,   
       y2d = 516,  
       radius = 20,  
   },  
   {   
       x2d = 5788,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 5788,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 5781,   
       y2d = 781,  
       radius = 35,  
   },  
   {   
       x2d = 5766,   
       y2d = 1116,  
       radius = 20,  
   },  
   {   
       x2d = 5773,   
       y2d = 1173,  
       radius = 27,  
   },  
   {   
       x2d = 5773,   
       y2d = 1323,  
       radius = 27,  
   },  
   {   
       x2d = 5788,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 5788,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 5758,   
       y2d = 1608,  
       radius = 12,  
   },  
   {   
       x2d = 5773,   
       y2d = 1673,  
       radius = 27,  
   },  
   {   
       x2d = 5758,   
       y2d = 1808,  
       radius = 12,  
   },  
   {   
       x2d = 5751,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 5751,   
       y2d = 2601,  
       radius = 5,  
   },  
   {   
       x2d = 5751,   
       y2d = 2701,  
       radius = 5,  
   },  
   {   
       x2d = 5751,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 5838,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 5838,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 5838,   
       y2d = 388,  
       radius = 42,  
   },  
   {   
       x2d = 5838,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 5808,   
       y2d = 1058,  
       radius = 12,  
   },  
   {   
       x2d = 5831,   
       y2d = 1181,  
       radius = 35,  
   },  
   {   
       x2d = 5816,   
       y2d = 1616,  
       radius = 20,  
   },  
   {   
       x2d = 5801,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 5808,   
       y2d = 2758,  
       radius = 12,  
   },  
   {   
       x2d = 5888,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 5888,   
       y2d = 488,  
       radius = 42,  
   },  
   {   
       x2d = 5888,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 5888,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 5888,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 5873,   
       y2d = 973,  
       radius = 27,  
   },  
   {   
       x2d = 5866,   
       y2d = 1116,  
       radius = 20,  
   },  
   {   
       x2d = 5851,   
       y2d = 1251,  
       radius = 5,  
   },  
   {   
       x2d = 5888,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 5888,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 5866,   
       y2d = 1716,  
       radius = 20,  
   },  
   {   
       x2d = 5858,   
       y2d = 1758,  
       radius = 12,  
   },  
   {   
       x2d = 5851,   
       y2d = 1901,  
       radius = 5,  
   },  
   {   
       x2d = 5858,   
       y2d = 2758,  
       radius = 12,  
   },  
   {   
       x2d = 5851,   
       y2d = 2801,  
       radius = 5,  
   },  
   {   
       x2d = 5938,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 5938,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 5938,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 5938,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 5938,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 5938,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 5916,   
       y2d = 1666,  
       radius = 20,  
   },  
   {   
       x2d = 5923,   
       y2d = 1723,  
       radius = 27,  
   },  
   {   
       x2d = 5901,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 5901,   
       y2d = 2551,  
       radius = 5,  
   },  
   {   
       x2d = 5901,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 5988,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 5988,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 5988,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 5988,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 5966,   
       y2d = 1316,  
       radius = 20,  
   },  
   {   
       x2d = 5966,   
       y2d = 1366,  
       radius = 20,  
   },  
   {   
       x2d = 5966,   
       y2d = 1416,  
       radius = 20,  
   },  
   {   
       x2d = 5988,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 5958,   
       y2d = 2808,  
       radius = 12,  
   },  
   {   
       x2d = 6038,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 6038,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 6038,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 6038,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 6038,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 6008,   
       y2d = 1258,  
       radius = 12,  
   },  
   {   
       x2d = 6031,   
       y2d = 1681,  
       radius = 35,  
   },  
   {   
       x2d = 6001,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 6001,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 6001,   
       y2d = 2801,  
       radius = 5,  
   },  
   {   
       x2d = 6001,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 6088,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 6081,   
       y2d = 431,  
       radius = 35,  
   },  
   {   
       x2d = 6073,   
       y2d = 673,  
       radius = 27,  
   },  
   {   
       x2d = 6066,   
       y2d = 766,  
       radius = 20,  
   },  
   {   
       x2d = 6073,   
       y2d = 1173,  
       radius = 27,  
   },  
   {   
       x2d = 6088,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 6088,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 6081,   
       y2d = 1631,  
       radius = 35,  
   },  
   {   
       x2d = 6051,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 6051,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 6051,   
       y2d = 2051,  
       radius = 5,  
   },  
   {   
       x2d = 6051,   
       y2d = 2701,  
       radius = 5,  
   },  
   {   
       x2d = 6058,   
       y2d = 2858,  
       radius = 12,  
   },  
   {   
       x2d = 6138,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 6138,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 6138,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 6101,   
       y2d = 501,  
       radius = 5,  
   },  
   {   
       x2d = 6101,   
       y2d = 601,  
       radius = 5,  
   },  
   {   
       x2d = 6108,   
       y2d = 758,  
       radius = 12,  
   },  
   {   
       x2d = 6138,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 6138,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 6131,   
       y2d = 1031,  
       radius = 35,  
   },  
   {   
       x2d = 6101,   
       y2d = 1351,  
       radius = 5,  
   },  
   {   
       x2d = 6101,   
       y2d = 1951,  
       radius = 5,  
   },  
   {   
       x2d = 6101,   
       y2d = 2351,  
       radius = 5,  
   },  
   {   
       x2d = 6108,   
       y2d = 2808,  
       radius = 12,  
   },  
   {   
       x2d = 6188,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 6181,   
       y2d = 431,  
       radius = 35,  
   },  
   {   
       x2d = 6188,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 6188,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 6158,   
       y2d = 1108,  
       radius = 12,  
   },  
   {   
       x2d = 6151,   
       y2d = 1151,  
       radius = 5,  
   },  
   {   
       x2d = 6151,   
       y2d = 1651,  
       radius = 5,  
   },  
   {   
       x2d = 6151,   
       y2d = 1701,  
       radius = 5,  
   },  
   {   
       x2d = 6151,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 6151,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 6151,   
       y2d = 2251,  
       radius = 5,  
   },  
   {   
       x2d = 6238,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 6238,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 6238,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 6238,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 6216,   
       y2d = 966,  
       radius = 20,  
   },  
   {   
       x2d = 6201,   
       y2d = 1051,  
       radius = 5,  
   },  
   {   
       x2d = 6201,   
       y2d = 1101,  
       radius = 5,  
   },  
   {   
       x2d = 6208,   
       y2d = 1158,  
       radius = 12,  
   },  
   {   
       x2d = 6238,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 6208,   
       y2d = 1358,  
       radius = 12,  
   },  
   {   
       x2d = 6208,   
       y2d = 1408,  
       radius = 12,  
   },  
   {   
       x2d = 6216,   
       y2d = 1466,  
       radius = 20,  
   },  
   {   
       x2d = 6201,   
       y2d = 1601,  
       radius = 5,  
   },  
   {   
       x2d = 6201,   
       y2d = 1651,  
       radius = 5,  
   },  
   {   
       x2d = 6201,   
       y2d = 1701,  
       radius = 5,  
   },  
   {   
       x2d = 6208,   
       y2d = 1758,  
       radius = 12,  
   },  
   {   
       x2d = 6201,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 6201,   
       y2d = 2051,  
       radius = 5,  
   },  
   {   
       x2d = 6288,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 6288,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 6281,   
       y2d = 531,  
       radius = 35,  
   },  
   {   
       x2d = 6258,   
       y2d = 608,  
       radius = 12,  
   },  
   {   
       x2d = 6258,   
       y2d = 908,  
       radius = 12,  
   },  
   {   
       x2d = 6251,   
       y2d = 1001,  
       radius = 5,  
   },  
   {   
       x2d = 6251,   
       y2d = 1401,  
       radius = 5,  
   },  
   {   
       x2d = 6281,   
       y2d = 1481,  
       radius = 35,  
   },  
   {   
       x2d = 6258,   
       y2d = 1558,  
       radius = 12,  
   },  
   {   
       x2d = 6273,   
       y2d = 1673,  
       radius = 27,  
   },  
   {   
       x2d = 6251,   
       y2d = 1951,  
       radius = 5,  
   },  
   {   
       x2d = 6251,   
       y2d = 2951,  
       radius = 5,  
   },  
   {   
       x2d = 6338,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 6338,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 6338,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 6301,   
       y2d = 601,  
       radius = 5,  
   },  
   {   
       x2d = 6316,   
       y2d = 716,  
       radius = 20,  
   },  
   {   
       x2d = 6331,   
       y2d = 781,  
       radius = 35,  
   },  
   {   
       x2d = 6301,   
       y2d = 851,  
       radius = 5,  
   },  
   {   
       x2d = 6301,   
       y2d = 1001,  
       radius = 5,  
   },  
   {   
       x2d = 6323,   
       y2d = 1323,  
       radius = 27,  
   },  
   {   
       x2d = 6301,   
       y2d = 1401,  
       radius = 5,  
   },  
   {   
       x2d = 6338,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 6388,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 6388,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 6381,   
       y2d = 531,  
       radius = 35,  
   },  
   {   
       x2d = 6388,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 6381,   
       y2d = 1681,  
       radius = 35,  
   },  
   {   
       x2d = 6351,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 6351,   
       y2d = 2901,  
       radius = 5,  
   },  
   {   
       x2d = 6351,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 6438,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 6438,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 6401,   
       y2d = 601,  
       radius = 5,  
   },  
   {   
       x2d = 6423,   
       y2d = 723,  
       radius = 27,  
   },  
   {   
       x2d = 6401,   
       y2d = 851,  
       radius = 5,  
   },  
   {   
       x2d = 6408,   
       y2d = 1408,  
       radius = 12,  
   },  
   {   
       x2d = 6416,   
       y2d = 1466,  
       radius = 20,  
   },  
   {   
       x2d = 6438,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 6401,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 6488,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 6488,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 6488,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 6488,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 6451,   
       y2d = 651,  
       radius = 5,  
   },  
   {   
       x2d = 6488,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 6473,   
       y2d = 923,  
       radius = 27,  
   },  
   {   
       x2d = 6481,   
       y2d = 1031,  
       radius = 35,  
   },  
   {   
       x2d = 6481,   
       y2d = 1381,  
       radius = 35,  
   },  
   {   
       x2d = 6473,   
       y2d = 1473,  
       radius = 27,  
   },  
   {   
       x2d = 6481,   
       y2d = 1681,  
       radius = 35,  
   },  
   {   
       x2d = 6538,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 6538,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 6508,   
       y2d = 658,  
       radius = 12,  
   },  
   {   
       x2d = 6516,   
       y2d = 966,  
       radius = 20,  
   },  
   {   
       x2d = 6501,   
       y2d = 1201,  
       radius = 5,  
   },  
   {   
       x2d = 6538,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 6516,   
       y2d = 1566,  
       radius = 20,  
   },  
   {   
       x2d = 6501,   
       y2d = 2051,  
       radius = 5,  
   },  
   {   
       x2d = 6588,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 6588,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 6573,   
       y2d = 473,  
       radius = 27,  
   },  
   {   
       x2d = 6588,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 6588,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 6588,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 6581,   
       y2d = 1031,  
       radius = 35,  
   },  
   {   
       x2d = 6558,   
       y2d = 1508,  
       radius = 12,  
   },  
   {   
       x2d = 6551,   
       y2d = 1601,  
       radius = 5,  
   },  
   {   
       x2d = 6551,   
       y2d = 1651,  
       radius = 5,  
   },  
   {   
       x2d = 6551,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 6551,   
       y2d = 2701,  
       radius = 5,  
   },  
   {   
       x2d = 6638,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 6638,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 6638,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 6601,   
       y2d = 1151,  
       radius = 5,  
   },  
   {   
       x2d = 6631,   
       y2d = 1381,  
       radius = 35,  
   },  
   {   
       x2d = 6631,   
       y2d = 1531,  
       radius = 35,  
   },  
   {   
       x2d = 6601,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 6688,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 6688,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 6673,   
       y2d = 423,  
       radius = 27,  
   },  
   {   
       x2d = 6673,   
       y2d = 623,  
       radius = 27,  
   },  
   {   
       x2d = 6688,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 6658,   
       y2d = 1108,  
       radius = 12,  
   },  
   {   
       x2d = 6658,   
       y2d = 1458,  
       radius = 12,  
   },  
   {   
       x2d = 6651,   
       y2d = 1651,  
       radius = 5,  
   },  
   {   
       x2d = 6651,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 6651,   
       y2d = 1901,  
       radius = 5,  
   },  
   {   
       x2d = 6651,   
       y2d = 1951,  
       radius = 5,  
   },  
   {   
       x2d = 6651,   
       y2d = 2001,  
       radius = 5,  
   },  
   {   
       x2d = 6738,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 6738,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 6708,   
       y2d = 508,  
       radius = 12,  
   },  
   {   
       x2d = 6708,   
       y2d = 558,  
       radius = 12,  
   },  
   {   
       x2d = 6738,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 6708,   
       y2d = 1058,  
       radius = 12,  
   },  
   {   
       x2d = 6708,   
       y2d = 1108,  
       radius = 12,  
   },  
   {   
       x2d = 6708,   
       y2d = 1458,  
       radius = 12,  
   },  
   {   
       x2d = 6701,   
       y2d = 1501,  
       radius = 5,  
   },  
   {   
       x2d = 6738,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 6701,   
       y2d = 1901,  
       radius = 5,  
   },  
   {   
       x2d = 6701,   
       y2d = 2001,  
       radius = 5,  
   },  
   {   
       x2d = 6701,   
       y2d = 2251,  
       radius = 5,  
   },  
   {   
       x2d = 6788,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 6788,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 6788,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 6773,   
       y2d = 823,  
       radius = 27,  
   },  
   {   
       x2d = 6773,   
       y2d = 1673,  
       radius = 27,  
   },  
   {   
       x2d = 6751,   
       y2d = 1951,  
       radius = 5,  
   },  
   {   
       x2d = 6838,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 6838,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 6808,   
       y2d = 658,  
       radius = 12,  
   },  
   {   
       x2d = 6831,   
       y2d = 731,  
       radius = 35,  
   },  
   {   
       x2d = 6838,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 6801,   
       y2d = 1101,  
       radius = 5,  
   },  
   {   
       x2d = 6823,   
       y2d = 1473,  
       radius = 27,  
   },  
   {   
       x2d = 6838,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 6808,   
       y2d = 1908,  
       radius = 12,  
   },  
   {   
       x2d = 6801,   
       y2d = 1951,  
       radius = 5,  
   },  
   {   
       x2d = 6801,   
       y2d = 3201,  
       radius = 5,  
   },  
   {   
       x2d = 6801,   
       y2d = 3251,  
       radius = 5,  
   },  
   {   
       x2d = 6801,   
       y2d = 3401,  
       radius = 5,  
   },  
   {   
       x2d = 6888,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 6888,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 6873,   
       y2d = 423,  
       radius = 27,  
   },  
   {   
       x2d = 6888,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 6866,   
       y2d = 666,  
       radius = 20,  
   },  
   {   
       x2d = 6851,   
       y2d = 801,  
       radius = 5,  
   },  
   {   
       x2d = 6858,   
       y2d = 1008,  
       radius = 12,  
   },  
   {   
       x2d = 6851,   
       y2d = 1351,  
       radius = 5,  
   },  
   {   
       x2d = 6851,   
       y2d = 1401,  
       radius = 5,  
   },  
   {   
       x2d = 6851,   
       y2d = 1551,  
       radius = 5,  
   },  
   {   
       x2d = 6858,   
       y2d = 1808,  
       radius = 12,  
   },  
   {   
       x2d = 6851,   
       y2d = 1901,  
       radius = 5,  
   },  
   {   
       x2d = 6851,   
       y2d = 1951,  
       radius = 5,  
   },  
   {   
       x2d = 6851,   
       y2d = 3351,  
       radius = 5,  
   },  
   {   
       x2d = 6938,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 6938,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 6916,   
       y2d = 716,  
       radius = 20,  
   },  
   {   
       x2d = 6938,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 6923,   
       y2d = 923,  
       radius = 27,  
   },  
   {   
       x2d = 6901,   
       y2d = 1301,  
       radius = 5,  
   },  
   {   
       x2d = 6931,   
       y2d = 1381,  
       radius = 35,  
   },  
   {   
       x2d = 6938,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 6901,   
       y2d = 1701,  
       radius = 5,  
   },  
   {   
       x2d = 6908,   
       y2d = 1808,  
       radius = 12,  
   },  
   {   
       x2d = 6901,   
       y2d = 1901,  
       radius = 5,  
   },  
   {   
       x2d = 6901,   
       y2d = 2151,  
       radius = 5,  
   },  
   {   
       x2d = 6901,   
       y2d = 2201,  
       radius = 5,  
   },  
   {   
       x2d = 6901,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 6988,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 6988,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 6988,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 6988,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 6966,   
       y2d = 966,  
       radius = 20,  
   },  
   {   
       x2d = 6966,   
       y2d = 1316,  
       radius = 20,  
   },  
   {   
       x2d = 6981,   
       y2d = 2081,  
       radius = 35,  
   },  
   {   
       x2d = 6958,   
       y2d = 2158,  
       radius = 12,  
   },  
   {   
       x2d = 6951,   
       y2d = 2201,  
       radius = 5,  
   },  
   {   
       x2d = 6951,   
       y2d = 2251,  
       radius = 5,  
   },  
   {   
       x2d = 6951,   
       y2d = 3501,  
       radius = 5,  
   },  
   {   
       x2d = 6951,   
       y2d = 3551,  
       radius = 5,  
   },  
   {   
       x2d = 7038,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 7038,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 7038,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 7038,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 7016,   
       y2d = 916,  
       radius = 20,  
   },  
   {   
       x2d = 7016,   
       y2d = 1316,  
       radius = 20,  
   },  
   {   
       x2d = 7016,   
       y2d = 1366,  
       radius = 20,  
   },  
   {   
       x2d = 7016,   
       y2d = 1416,  
       radius = 20,  
   },  
   {   
       x2d = 7023,   
       y2d = 1473,  
       radius = 27,  
   },  
   {   
       x2d = 7016,   
       y2d = 1616,  
       radius = 20,  
   },  
   {   
       x2d = 7008,   
       y2d = 1858,  
       radius = 12,  
   },  
   {   
       x2d = 7001,   
       y2d = 1951,  
       radius = 5,  
   },  
   {   
       x2d = 7038,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 7001,   
       y2d = 2151,  
       radius = 5,  
   },  
   {   
       x2d = 7001,   
       y2d = 2251,  
       radius = 5,  
   },  
   {   
       x2d = 7001,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 7088,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 7088,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 7073,   
       y2d = 423,  
       radius = 27,  
   },  
   {   
       x2d = 7088,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 7058,   
       y2d = 1208,  
       radius = 12,  
   },  
   {   
       x2d = 7051,   
       y2d = 1551,  
       radius = 5,  
   },  
   {   
       x2d = 7051,   
       y2d = 1651,  
       radius = 5,  
   },  
   {   
       x2d = 7066,   
       y2d = 1916,  
       radius = 20,  
   },  
   {   
       x2d = 7088,   
       y2d = 2188,  
       radius = 42,  
   },  
   {   
       x2d = 7051,   
       y2d = 2651,  
       radius = 5,  
   },  
   {   
       x2d = 7051,   
       y2d = 2701,  
       radius = 5,  
   },  
   {   
       x2d = 7058,   
       y2d = 2758,  
       radius = 12,  
   },  
   {   
       x2d = 7051,   
       y2d = 3351,  
       radius = 5,  
   },  
   {   
       x2d = 7138,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 7138,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 7138,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 7123,   
       y2d = 1223,  
       radius = 27,  
   },  
   {   
       x2d = 7101,   
       y2d = 1301,  
       radius = 5,  
   },  
   {   
       x2d = 7138,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 7108,   
       y2d = 1558,  
       radius = 12,  
   },  
   {   
       x2d = 7101,   
       y2d = 1601,  
       radius = 5,  
   },  
   {   
       x2d = 7101,   
       y2d = 1651,  
       radius = 5,  
   },  
   {   
       x2d = 7101,   
       y2d = 1701,  
       radius = 5,  
   },  
   {   
       x2d = 7101,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 7101,   
       y2d = 1951,  
       radius = 5,  
   },  
   {   
       x2d = 7138,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 7108,   
       y2d = 2708,  
       radius = 12,  
   },  
   {   
       x2d = 7101,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 7116,   
       y2d = 3466,  
       radius = 20,  
   },  
   {   
       x2d = 7101,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 7188,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 7188,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 7188,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 7173,   
       y2d = 723,  
       radius = 27,  
   },  
   {   
       x2d = 7151,   
       y2d = 801,  
       radius = 5,  
   },  
   {   
       x2d = 7188,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 7188,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 7158,   
       y2d = 1558,  
       radius = 12,  
   },  
   {   
       x2d = 7151,   
       y2d = 1651,  
       radius = 5,  
   },  
   {   
       x2d = 7158,   
       y2d = 1758,  
       radius = 12,  
   },  
   {   
       x2d = 7158,   
       y2d = 1808,  
       radius = 12,  
   },  
   {   
       x2d = 7151,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 7151,   
       y2d = 1901,  
       radius = 5,  
   },  
   {   
       x2d = 7166,   
       y2d = 2166,  
       radius = 20,  
   },  
   {   
       x2d = 7151,   
       y2d = 3301,  
       radius = 5,  
   },  
   {   
       x2d = 7151,   
       y2d = 3351,  
       radius = 5,  
   },  
   {   
       x2d = 7151,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 7238,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 7238,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 7238,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 7201,   
       y2d = 1001,  
       radius = 5,  
   },  
   {   
       x2d = 7201,   
       y2d = 1051,  
       radius = 5,  
   },  
   {   
       x2d = 7223,   
       y2d = 1123,  
       radius = 27,  
   },  
   {   
       x2d = 7208,   
       y2d = 1558,  
       radius = 12,  
   },  
   {   
       x2d = 7238,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 7201,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 7208,   
       y2d = 1858,  
       radius = 12,  
   },  
   {   
       x2d = 7216,   
       y2d = 1916,  
       radius = 20,  
   },  
   {   
       x2d = 7238,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 7231,   
       y2d = 2081,  
       radius = 35,  
   },  
   {   
       x2d = 7201,   
       y2d = 3101,  
       radius = 5,  
   },  
   {   
       x2d = 7208,   
       y2d = 3608,  
       radius = 12,  
   },  
   {   
       x2d = 7201,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 7288,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 7288,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 7258,   
       y2d = 708,  
       radius = 12,  
   },  
   {   
       x2d = 7258,   
       y2d = 958,  
       radius = 12,  
   },  
   {   
       x2d = 7266,   
       y2d = 1066,  
       radius = 20,  
   },  
   {   
       x2d = 7288,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 7266,   
       y2d = 1316,  
       radius = 20,  
   },  
   {   
       x2d = 7288,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 7266,   
       y2d = 1566,  
       radius = 20,  
   },  
   {   
       x2d = 7251,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 7251,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 7251,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 7251,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 7251,   
       y2d = 3801,  
       radius = 5,  
   },  
   {   
       x2d = 7338,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 7331,   
       y2d = 331,  
       radius = 35,  
   },  
   {   
       x2d = 7338,   
       y2d = 488,  
       radius = 42,  
   },  
   {   
       x2d = 7301,   
       y2d = 851,  
       radius = 5,  
   },  
   {   
       x2d = 7316,   
       y2d = 916,  
       radius = 20,  
   },  
   {   
       x2d = 7316,   
       y2d = 966,  
       radius = 20,  
   },  
   {   
       x2d = 7301,   
       y2d = 1251,  
       radius = 5,  
   },  
   {   
       x2d = 7316,   
       y2d = 1316,  
       radius = 20,  
   },  
   {   
       x2d = 7308,   
       y2d = 1558,  
       radius = 12,  
   },  
   {   
       x2d = 7316,   
       y2d = 1616,  
       radius = 20,  
   },  
   {   
       x2d = 7308,   
       y2d = 1758,  
       radius = 12,  
   },  
   {   
       x2d = 7301,   
       y2d = 3801,  
       radius = 5,  
   },  
   {   
       x2d = 7301,   
       y2d = 3851,  
       radius = 5,  
   },  
   {   
       x2d = 7388,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 7388,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 7351,   
       y2d = 401,  
       radius = 5,  
   },  
   {   
       x2d = 7381,   
       y2d = 581,  
       radius = 35,  
   },  
   {   
       x2d = 7366,   
       y2d = 666,  
       radius = 20,  
   },  
   {   
       x2d = 7358,   
       y2d = 808,  
       radius = 12,  
   },  
   {   
       x2d = 7366,   
       y2d = 866,  
       radius = 20,  
   },  
   {   
       x2d = 7358,   
       y2d = 908,  
       radius = 12,  
   },  
   {   
       x2d = 7388,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 7351,   
       y2d = 1201,  
       radius = 5,  
   },  
   {   
       x2d = 7388,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 7381,   
       y2d = 1481,  
       radius = 35,  
   },  
   {   
       x2d = 7351,   
       y2d = 1651,  
       radius = 5,  
   },  
   {   
       x2d = 7351,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 7351,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 7351,   
       y2d = 2451,  
       radius = 5,  
   },  
   {   
       x2d = 7351,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 7438,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 7438,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 7438,   
       y2d = 488,  
       radius = 42,  
   },  
   {   
       x2d = 7416,   
       y2d = 666,  
       radius = 20,  
   },  
   {   
       x2d = 7423,   
       y2d = 723,  
       radius = 27,  
   },  
   {   
       x2d = 7416,   
       y2d = 816,  
       radius = 20,  
   },  
   {   
       x2d = 7408,   
       y2d = 858,  
       radius = 12,  
   },  
   {   
       x2d = 7416,   
       y2d = 966,  
       radius = 20,  
   },  
   {   
       x2d = 7408,   
       y2d = 1258,  
       radius = 12,  
   },  
   {   
       x2d = 7401,   
       y2d = 1551,  
       radius = 5,  
   },  
   {   
       x2d = 7408,   
       y2d = 1808,  
       radius = 12,  
   },  
   {   
       x2d = 7401,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 7401,   
       y2d = 1901,  
       radius = 5,  
   },  
   {   
       x2d = 7401,   
       y2d = 2201,  
       radius = 5,  
   },  
   {   
       x2d = 7401,   
       y2d = 3801,  
       radius = 5,  
   },  
   {   
       x2d = 7488,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 7488,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 7458,   
       y2d = 858,  
       radius = 12,  
   },  
   {   
       x2d = 7473,   
       y2d = 923,  
       radius = 27,  
   },  
   {   
       x2d = 7473,   
       y2d = 1123,  
       radius = 27,  
   },  
   {   
       x2d = 7481,   
       y2d = 1181,  
       radius = 35,  
   },  
   {   
       x2d = 7481,   
       y2d = 1281,  
       radius = 35,  
   },  
   {   
       x2d = 7481,   
       y2d = 1531,  
       radius = 35,  
   },  
   {   
       x2d = 7473,   
       y2d = 1623,  
       radius = 27,  
   },  
   {   
       x2d = 7451,   
       y2d = 2051,  
       radius = 5,  
   },  
   {   
       x2d = 7451,   
       y2d = 2101,  
       radius = 5,  
   },  
   {   
       x2d = 7451,   
       y2d = 2451,  
       radius = 5,  
   },  
   {   
       x2d = 7458,   
       y2d = 2508,  
       radius = 12,  
   },  
   {   
       x2d = 7451,   
       y2d = 3201,  
       radius = 5,  
   },  
   {   
       x2d = 7458,   
       y2d = 3308,  
       radius = 12,  
   },  
   {   
       x2d = 7451,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 7451,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 7451,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 7451,   
       y2d = 3801,  
       radius = 5,  
   },  
   {   
       x2d = 7451,   
       y2d = 3851,  
       radius = 5,  
   },  
   {   
       x2d = 7451,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 7451,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 7538,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 7538,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 7523,   
       y2d = 473,  
       radius = 27,  
   },  
   {   
       x2d = 7538,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 7523,   
       y2d = 773,  
       radius = 27,  
   },  
   {   
       x2d = 7508,   
       y2d = 858,  
       radius = 12,  
   },  
   {   
       x2d = 7501,   
       y2d = 1051,  
       radius = 5,  
   },  
   {   
       x2d = 7501,   
       y2d = 1351,  
       radius = 5,  
   },  
   {   
       x2d = 7508,   
       y2d = 1458,  
       radius = 12,  
   },  
   {   
       x2d = 7508,   
       y2d = 1758,  
       radius = 12,  
   },  
   {   
       x2d = 7516,   
       y2d = 1816,  
       radius = 20,  
   },  
   {   
       x2d = 7501,   
       y2d = 2501,  
       radius = 5,  
   },  
   {   
       x2d = 7501,   
       y2d = 3201,  
       radius = 5,  
   },  
   {   
       x2d = 7501,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 7501,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 7501,   
       y2d = 3801,  
       radius = 5,  
   },  
   {   
       x2d = 7508,   
       y2d = 3908,  
       radius = 12,  
   },  
   {   
       x2d = 7501,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 7588,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 7588,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 7588,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 7566,   
       y2d = 916,  
       radius = 20,  
   },  
   {   
       x2d = 7551,   
       y2d = 1001,  
       radius = 5,  
   },  
   {   
       x2d = 7551,   
       y2d = 1251,  
       radius = 5,  
   },  
   {   
       x2d = 7588,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 7551,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 7551,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 7558,   
       y2d = 1908,  
       radius = 12,  
   },  
   {   
       x2d = 7558,   
       y2d = 1958,  
       radius = 12,  
   },  
   {   
       x2d = 7551,   
       y2d = 2001,  
       radius = 5,  
   },  
   {   
       x2d = 7551,   
       y2d = 2351,  
       radius = 5,  
   },  
   {   
       x2d = 7551,   
       y2d = 2401,  
       radius = 5,  
   },  
   {   
       x2d = 7551,   
       y2d = 2601,  
       radius = 5,  
   },  
   {   
       x2d = 7558,   
       y2d = 2658,  
       radius = 12,  
   },  
   {   
       x2d = 7566,   
       y2d = 2716,  
       radius = 20,  
   },  
   {   
       x2d = 7551,   
       y2d = 3101,  
       radius = 5,  
   },  
   {   
       x2d = 7551,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 7551,   
       y2d = 3201,  
       radius = 5,  
   },  
   {   
       x2d = 7558,   
       y2d = 3758,  
       radius = 12,  
   },  
   {   
       x2d = 7551,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 7551,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 7551,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 7551,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 7638,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 7638,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 7631,   
       y2d = 531,  
       radius = 35,  
   },  
   {   
       x2d = 7638,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 7616,   
       y2d = 816,  
       radius = 20,  
   },  
   {   
       x2d = 7616,   
       y2d = 916,  
       radius = 20,  
   },  
   {   
       x2d = 7601,   
       y2d = 1001,  
       radius = 5,  
   },  
   {   
       x2d = 7601,   
       y2d = 1051,  
       radius = 5,  
   },  
   {   
       x2d = 7601,   
       y2d = 1101,  
       radius = 5,  
   },  
   {   
       x2d = 7601,   
       y2d = 1151,  
       radius = 5,  
   },  
   {   
       x2d = 7631,   
       y2d = 1431,  
       radius = 35,  
   },  
   {   
       x2d = 7608,   
       y2d = 1558,  
       radius = 12,  
   },  
   {   
       x2d = 7623,   
       y2d = 1723,  
       radius = 27,  
   },  
   {   
       x2d = 7601,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 7601,   
       y2d = 2151,  
       radius = 5,  
   },  
   {   
       x2d = 7601,   
       y2d = 2401,  
       radius = 5,  
   },  
   {   
       x2d = 7616,   
       y2d = 2466,  
       radius = 20,  
   },  
   {   
       x2d = 7601,   
       y2d = 3551,  
       radius = 5,  
   },  
   {   
       x2d = 7601,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 7601,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 7601,   
       y2d = 3851,  
       radius = 5,  
   },  
   {   
       x2d = 7601,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 7608,   
       y2d = 3958,  
       radius = 12,  
   },  
   {   
       x2d = 7608,   
       y2d = 4008,  
       radius = 12,  
   },  
   {   
       x2d = 7601,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 7688,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 7688,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 7688,   
       y2d = 488,  
       radius = 42,  
   },  
   {   
       x2d = 7666,   
       y2d = 816,  
       radius = 20,  
   },  
   {   
       x2d = 7688,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 7681,   
       y2d = 1131,  
       radius = 35,  
   },  
   {   
       x2d = 7681,   
       y2d = 1531,  
       radius = 35,  
   },  
   {   
       x2d = 7666,   
       y2d = 1616,  
       radius = 20,  
   },  
   {   
       x2d = 7673,   
       y2d = 1673,  
       radius = 27,  
   },  
   {   
       x2d = 7651,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 7651,   
       y2d = 1901,  
       radius = 5,  
   },  
   {   
       x2d = 7651,   
       y2d = 2001,  
       radius = 5,  
   },  
   {   
       x2d = 7651,   
       y2d = 2201,  
       radius = 5,  
   },  
   {   
       x2d = 7651,   
       y2d = 2251,  
       radius = 5,  
   },  
   {   
       x2d = 7651,   
       y2d = 2401,  
       radius = 5,  
   },  
   {   
       x2d = 7651,   
       y2d = 3551,  
       radius = 5,  
   },  
   {   
       x2d = 7651,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 7651,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 7651,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 7738,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 7738,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 7731,   
       y2d = 581,  
       radius = 35,  
   },  
   {   
       x2d = 7731,   
       y2d = 731,  
       radius = 35,  
   },  
   {   
       x2d = 7708,   
       y2d = 808,  
       radius = 12,  
   },  
   {   
       x2d = 7731,   
       y2d = 881,  
       radius = 35,  
   },  
   {   
       x2d = 7738,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 7716,   
       y2d = 1216,  
       radius = 20,  
   },  
   {   
       x2d = 7701,   
       y2d = 1301,  
       radius = 5,  
   },  
   {   
       x2d = 7701,   
       y2d = 1451,  
       radius = 5,  
   },  
   {   
       x2d = 7716,   
       y2d = 1616,  
       radius = 20,  
   },  
   {   
       x2d = 7701,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 7701,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 7701,   
       y2d = 2051,  
       radius = 5,  
   },  
   {   
       x2d = 7708,   
       y2d = 2508,  
       radius = 12,  
   },  
   {   
       x2d = 7723,   
       y2d = 3073,  
       radius = 27,  
   },  
   {   
       x2d = 7731,   
       y2d = 3131,  
       radius = 35,  
   },  
   {   
       x2d = 7701,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 7701,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 7701,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 7701,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 7701,   
       y2d = 4201,  
       radius = 5,  
   },  
   {   
       x2d = 7701,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 7788,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 7788,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 7788,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 7751,   
       y2d = 651,  
       radius = 5,  
   },  
   {   
       x2d = 7788,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 7781,   
       y2d = 1281,  
       radius = 35,  
   },  
   {   
       x2d = 7751,   
       y2d = 1351,  
       radius = 5,  
   },  
   {   
       x2d = 7751,   
       y2d = 1551,  
       radius = 5,  
   },  
   {   
       x2d = 7758,   
       y2d = 1608,  
       radius = 12,  
   },  
   {   
       x2d = 7766,   
       y2d = 1666,  
       radius = 20,  
   },  
   {   
       x2d = 7758,   
       y2d = 1808,  
       radius = 12,  
   },  
   {   
       x2d = 7758,   
       y2d = 1858,  
       radius = 12,  
   },  
   {   
       x2d = 7751,   
       y2d = 1901,  
       radius = 5,  
   },  
   {   
       x2d = 7751,   
       y2d = 1951,  
       radius = 5,  
   },  
   {   
       x2d = 7788,   
       y2d = 2988,  
       radius = 42,  
   },  
   {   
       x2d = 7758,   
       y2d = 3208,  
       radius = 12,  
   },  
   {   
       x2d = 7751,   
       y2d = 3251,  
       radius = 5,  
   },  
   {   
       x2d = 7751,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 7758,   
       y2d = 3708,  
       radius = 12,  
   },  
   {   
       x2d = 7751,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 7751,   
       y2d = 3851,  
       radius = 5,  
   },  
   {   
       x2d = 7751,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 7838,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 7838,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 7838,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 7801,   
       y2d = 801,  
       radius = 5,  
   },  
   {   
       x2d = 7831,   
       y2d = 931,  
       radius = 35,  
   },  
   {   
       x2d = 7801,   
       y2d = 1351,  
       radius = 5,  
   },  
   {   
       x2d = 7838,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 7823,   
       y2d = 1523,  
       radius = 27,  
   },  
   {   
       x2d = 7801,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 7808,   
       y2d = 1858,  
       radius = 12,  
   },  
   {   
       x2d = 7801,   
       y2d = 2051,  
       radius = 5,  
   },  
   {   
       x2d = 7801,   
       y2d = 2401,  
       radius = 5,  
   },  
   {   
       x2d = 7801,   
       y2d = 2451,  
       radius = 5,  
   },  
   {   
       x2d = 7801,   
       y2d = 2551,  
       radius = 5,  
   },  
   {   
       x2d = 7838,   
       y2d = 3088,  
       radius = 42,  
   },  
   {   
       x2d = 7838,   
       y2d = 3188,  
       radius = 42,  
   },  
   {   
       x2d = 7808,   
       y2d = 3308,  
       radius = 12,  
   },  
   {   
       x2d = 7801,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 7801,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 7801,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 7808,   
       y2d = 3808,  
       radius = 12,  
   },  
   {   
       x2d = 7801,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 7801,   
       y2d = 4201,  
       radius = 5,  
   },  
   {   
       x2d = 7888,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 7888,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 7858,   
       y2d = 358,  
       radius = 12,  
   },  
   {   
       x2d = 7866,   
       y2d = 466,  
       radius = 20,  
   },  
   {   
       x2d = 7873,   
       y2d = 873,  
       radius = 27,  
   },  
   {   
       x2d = 7873,   
       y2d = 1023,  
       radius = 27,  
   },  
   {   
       x2d = 7873,   
       y2d = 1223,  
       radius = 27,  
   },  
   {   
       x2d = 7851,   
       y2d = 1701,  
       radius = 5,  
   },  
   {   
       x2d = 7851,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 7851,   
       y2d = 2501,  
       radius = 5,  
   },  
   {   
       x2d = 7873,   
       y2d = 2873,  
       radius = 27,  
   },  
   {   
       x2d = 7873,   
       y2d = 2973,  
       radius = 27,  
   },  
   {   
       x2d = 7873,   
       y2d = 3273,  
       radius = 27,  
   },  
   {   
       x2d = 7851,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 7851,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 7938,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 7938,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 7916,   
       y2d = 466,  
       radius = 20,  
   },  
   {   
       x2d = 7938,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 7931,   
       y2d = 731,  
       radius = 35,  
   },  
   {   
       x2d = 7901,   
       y2d = 951,  
       radius = 5,  
   },  
   {   
       x2d = 7931,   
       y2d = 1131,  
       radius = 35,  
   },  
   {   
       x2d = 7931,   
       y2d = 1231,  
       radius = 35,  
   },  
   {   
       x2d = 7923,   
       y2d = 1323,  
       radius = 27,  
   },  
   {   
       x2d = 7938,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 7938,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 7901,   
       y2d = 1701,  
       radius = 5,  
   },  
   {   
       x2d = 7908,   
       y2d = 1758,  
       radius = 12,  
   },  
   {   
       x2d = 7901,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 7901,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 7901,   
       y2d = 2651,  
       radius = 5,  
   },  
   {   
       x2d = 7901,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 7916,   
       y2d = 3016,  
       radius = 20,  
   },  
   {   
       x2d = 7916,   
       y2d = 3066,  
       radius = 20,  
   },  
   {   
       x2d = 7938,   
       y2d = 3188,  
       radius = 42,  
   },  
   {   
       x2d = 7931,   
       y2d = 3281,  
       radius = 35,  
   },  
   {   
       x2d = 7901,   
       y2d = 3801,  
       radius = 5,  
   },  
   {   
       x2d = 7908,   
       y2d = 3858,  
       radius = 12,  
   },  
   {   
       x2d = 7916,   
       y2d = 4066,  
       radius = 20,  
   },  
   {   
       x2d = 7901,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 7908,   
       y2d = 4208,  
       radius = 12,  
   },  
   {   
       x2d = 7908,   
       y2d = 4258,  
       radius = 12,  
   },  
   {   
       x2d = 7988,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 7988,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 7951,   
       y2d = 801,  
       radius = 5,  
   },  
   {   
       x2d = 7973,   
       y2d = 873,  
       radius = 27,  
   },  
   {   
       x2d = 7951,   
       y2d = 951,  
       radius = 5,  
   },  
   {   
       x2d = 7958,   
       y2d = 1008,  
       radius = 12,  
   },  
   {   
       x2d = 7951,   
       y2d = 1701,  
       radius = 5,  
   },  
   {   
       x2d = 7958,   
       y2d = 1758,  
       radius = 12,  
   },  
   {   
       x2d = 7951,   
       y2d = 1901,  
       radius = 5,  
   },  
   {   
       x2d = 7951,   
       y2d = 2001,  
       radius = 5,  
   },  
   {   
       x2d = 7951,   
       y2d = 2601,  
       radius = 5,  
   },  
   {   
       x2d = 7951,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 7988,   
       y2d = 3788,  
       radius = 42,  
   },  
   {   
       x2d = 7951,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 7958,   
       y2d = 4208,  
       radius = 12,  
   },  
   {   
       x2d = 7951,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 7951,   
       y2d = 4901,  
       radius = 5,  
   },  
   {   
       x2d = 8038,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 8038,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 8001,   
       y2d = 451,  
       radius = 5,  
   },  
   {   
       x2d = 8016,   
       y2d = 516,  
       radius = 20,  
   },  
   {   
       x2d = 8038,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 8001,   
       y2d = 801,  
       radius = 5,  
   },  
   {   
       x2d = 8038,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 8008,   
       y2d = 1008,  
       radius = 12,  
   },  
   {   
       x2d = 8001,   
       y2d = 1051,  
       radius = 5,  
   },  
   {   
       x2d = 8008,   
       y2d = 1208,  
       radius = 12,  
   },  
   {   
       x2d = 8038,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 8023,   
       y2d = 1373,  
       radius = 27,  
   },  
   {   
       x2d = 8001,   
       y2d = 1601,  
       radius = 5,  
   },  
   {   
       x2d = 8038,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 8001,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 8001,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 8038,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 8038,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 8001,   
       y2d = 3451,  
       radius = 5,  
   },  
   {   
       x2d = 8008,   
       y2d = 4058,  
       radius = 12,  
   },  
   {   
       x2d = 8001,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 8001,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 8008,   
       y2d = 4258,  
       radius = 12,  
   },  
   {   
       x2d = 8016,   
       y2d = 4316,  
       radius = 20,  
   },  
   {   
       x2d = 8088,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 8088,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 8066,   
       y2d = 516,  
       radius = 20,  
   },  
   {   
       x2d = 8066,   
       y2d = 1116,  
       radius = 20,  
   },  
   {   
       x2d = 8088,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 8058,   
       y2d = 1558,  
       radius = 12,  
   },  
   {   
       x2d = 8051,   
       y2d = 2451,  
       radius = 5,  
   },  
   {   
       x2d = 8051,   
       y2d = 2551,  
       radius = 5,  
   },  
   {   
       x2d = 8058,   
       y2d = 3108,  
       radius = 12,  
   },  
   {   
       x2d = 8081,   
       y2d = 3431,  
       radius = 35,  
   },  
   {   
       x2d = 8073,   
       y2d = 3773,  
       radius = 27,  
   },  
   {   
       x2d = 8058,   
       y2d = 4008,  
       radius = 12,  
   },  
   {   
       x2d = 8058,   
       y2d = 4108,  
       radius = 12,  
   },  
   {   
       x2d = 8058,   
       y2d = 4208,  
       radius = 12,  
   },  
   {   
       x2d = 8051,   
       y2d = 4401,  
       radius = 5,  
   },  
   {   
       x2d = 8051,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 8138,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 8138,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 8123,   
       y2d = 523,  
       radius = 27,  
   },  
   {   
       x2d = 8138,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 8123,   
       y2d = 723,  
       radius = 27,  
   },  
   {   
       x2d = 8123,   
       y2d = 873,  
       radius = 27,  
   },  
   {   
       x2d = 8101,   
       y2d = 951,  
       radius = 5,  
   },  
   {   
       x2d = 8138,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 8138,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 8138,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 8138,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 8138,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 8101,   
       y2d = 2401,  
       radius = 5,  
   },  
   {   
       x2d = 8101,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 8123,   
       y2d = 3523,  
       radius = 27,  
   },  
   {   
       x2d = 8116,   
       y2d = 3966,  
       radius = 20,  
   },  
   {   
       x2d = 8131,   
       y2d = 4081,  
       radius = 35,  
   },  
   {   
       x2d = 8101,   
       y2d = 4201,  
       radius = 5,  
   },  
   {   
       x2d = 8101,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 8101,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 8101,   
       y2d = 4351,  
       radius = 5,  
   },  
   {   
       x2d = 8101,   
       y2d = 4401,  
       radius = 5,  
   },  
   {   
       x2d = 8101,   
       y2d = 4451,  
       radius = 5,  
   },  
   {   
       x2d = 8101,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 8188,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 8188,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 8188,   
       y2d = 488,  
       radius = 42,  
   },  
   {   
       x2d = 8151,   
       y2d = 801,  
       radius = 5,  
   },  
   {   
       x2d = 8181,   
       y2d = 881,  
       radius = 35,  
   },  
   {   
       x2d = 8173,   
       y2d = 1223,  
       radius = 27,  
   },  
   {   
       x2d = 8151,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 8173,   
       y2d = 1923,  
       radius = 27,  
   },  
   {   
       x2d = 8151,   
       y2d = 2501,  
       radius = 5,  
   },  
   {   
       x2d = 8188,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 8188,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 8188,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 8151,   
       y2d = 3801,  
       radius = 5,  
   },  
   {   
       x2d = 8166,   
       y2d = 4016,  
       radius = 20,  
   },  
   {   
       x2d = 8151,   
       y2d = 4351,  
       radius = 5,  
   },  
   {   
       x2d = 8151,   
       y2d = 4451,  
       radius = 5,  
   },  
   {   
       x2d = 8238,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 8238,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 8238,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 8223,   
       y2d = 723,  
       radius = 27,  
   },  
   {   
       x2d = 8238,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 8223,   
       y2d = 1173,  
       radius = 27,  
   },  
   {   
       x2d = 8231,   
       y2d = 1231,  
       radius = 35,  
   },  
   {   
       x2d = 8231,   
       y2d = 1481,  
       radius = 35,  
   },  
   {   
       x2d = 8238,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 8238,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 8223,   
       y2d = 1823,  
       radius = 27,  
   },  
   {   
       x2d = 8231,   
       y2d = 1881,  
       radius = 35,  
   },  
   {   
       x2d = 8201,   
       y2d = 2301,  
       radius = 5,  
   },  
   {   
       x2d = 8201,   
       y2d = 2451,  
       radius = 5,  
   },  
   {   
       x2d = 8201,   
       y2d = 2951,  
       radius = 5,  
   },  
   {   
       x2d = 8208,   
       y2d = 3008,  
       radius = 12,  
   },  
   {   
       x2d = 8201,   
       y2d = 3101,  
       radius = 5,  
   },  
   {   
       x2d = 8201,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 8201,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 8201,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 8201,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 8288,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 8288,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 8281,   
       y2d = 481,  
       radius = 35,  
   },  
   {   
       x2d = 8288,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 8281,   
       y2d = 1081,  
       radius = 35,  
   },  
   {   
       x2d = 8281,   
       y2d = 1331,  
       radius = 35,  
   },  
   {   
       x2d = 8258,   
       y2d = 2158,  
       radius = 12,  
   },  
   {   
       x2d = 8251,   
       y2d = 2201,  
       radius = 5,  
   },  
   {   
       x2d = 8251,   
       y2d = 2251,  
       radius = 5,  
   },  
   {   
       x2d = 8258,   
       y2d = 2408,  
       radius = 12,  
   },  
   {   
       x2d = 8251,   
       y2d = 2551,  
       radius = 5,  
   },  
   {   
       x2d = 8288,   
       y2d = 2988,  
       radius = 42,  
   },  
   {   
       x2d = 8273,   
       y2d = 3073,  
       radius = 27,  
   },  
   {   
       x2d = 8251,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 8266,   
       y2d = 3216,  
       radius = 20,  
   },  
   {   
       x2d = 8266,   
       y2d = 3266,  
       radius = 20,  
   },  
   {   
       x2d = 8281,   
       y2d = 3331,  
       radius = 35,  
   },  
   {   
       x2d = 8258,   
       y2d = 3558,  
       radius = 12,  
   },  
   {   
       x2d = 8251,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 8251,   
       y2d = 4451,  
       radius = 5,  
   },  
   {   
       x2d = 8251,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 8266,   
       y2d = 4616,  
       radius = 20,  
   },  
   {   
       x2d = 8258,   
       y2d = 4658,  
       radius = 12,  
   },  
   {   
       x2d = 8338,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 8338,   
       y2d = 388,  
       radius = 42,  
   },  
   {   
       x2d = 8301,   
       y2d = 701,  
       radius = 5,  
   },  
   {   
       x2d = 8338,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 8316,   
       y2d = 1166,  
       radius = 20,  
   },  
   {   
       x2d = 8316,   
       y2d = 1216,  
       radius = 20,  
   },  
   {   
       x2d = 8323,   
       y2d = 1273,  
       radius = 27,  
   },  
   {   
       x2d = 8331,   
       y2d = 1431,  
       radius = 35,  
   },  
   {   
       x2d = 8338,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 8323,   
       y2d = 1773,  
       radius = 27,  
   },  
   {   
       x2d = 8301,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 8301,   
       y2d = 2101,  
       radius = 5,  
   },  
   {   
       x2d = 8308,   
       y2d = 2158,  
       radius = 12,  
   },  
   {   
       x2d = 8308,   
       y2d = 3908,  
       radius = 12,  
   },  
   {   
       x2d = 8301,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 8301,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 8301,   
       y2d = 4351,  
       radius = 5,  
   },  
   {   
       x2d = 8301,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 8301,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 8301,   
       y2d = 4651,  
       radius = 5,  
   },  
   {   
       x2d = 8301,   
       y2d = 4751,  
       radius = 5,  
   },  
   {   
       x2d = 8388,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 8388,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 8381,   
       y2d = 481,  
       radius = 35,  
   },  
   {   
       x2d = 8388,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 8351,   
       y2d = 751,  
       radius = 5,  
   },  
   {   
       x2d = 8366,   
       y2d = 816,  
       radius = 20,  
   },  
   {   
       x2d = 8366,   
       y2d = 1116,  
       radius = 20,  
   },  
   {   
       x2d = 8366,   
       y2d = 1316,  
       radius = 20,  
   },  
   {   
       x2d = 8358,   
       y2d = 1358,  
       radius = 12,  
   },  
   {   
       x2d = 8351,   
       y2d = 2051,  
       radius = 5,  
   },  
   {   
       x2d = 8351,   
       y2d = 2351,  
       radius = 5,  
   },  
   {   
       x2d = 8351,   
       y2d = 3101,  
       radius = 5,  
   },  
   {   
       x2d = 8351,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 8351,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 8351,   
       y2d = 4701,  
       radius = 5,  
   },  
   {   
       x2d = 8438,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 8438,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 8438,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 8401,   
       y2d = 551,  
       radius = 5,  
   },  
   {   
       x2d = 8423,   
       y2d = 773,  
       radius = 27,  
   },  
   {   
       x2d = 8438,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 8438,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 8416,   
       y2d = 1216,  
       radius = 20,  
   },  
   {   
       x2d = 8408,   
       y2d = 1408,  
       radius = 12,  
   },  
   {   
       x2d = 8401,   
       y2d = 1451,  
       radius = 5,  
   },  
   {   
       x2d = 8401,   
       y2d = 1501,  
       radius = 5,  
   },  
   {   
       x2d = 8431,   
       y2d = 1581,  
       radius = 35,  
   },  
   {   
       x2d = 8423,   
       y2d = 1673,  
       radius = 27,  
   },  
   {   
       x2d = 8431,   
       y2d = 1781,  
       radius = 35,  
   },  
   {   
       x2d = 8423,   
       y2d = 1873,  
       radius = 27,  
   },  
   {   
       x2d = 8408,   
       y2d = 1958,  
       radius = 12,  
   },  
   {   
       x2d = 8401,   
       y2d = 2001,  
       radius = 5,  
   },  
   {   
       x2d = 8401,   
       y2d = 2201,  
       radius = 5,  
   },  
   {   
       x2d = 8401,   
       y2d = 2301,  
       radius = 5,  
   },  
   {   
       x2d = 8401,   
       y2d = 3851,  
       radius = 5,  
   },  
   {   
       x2d = 8401,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 8401,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 8431,   
       y2d = 4631,  
       radius = 35,  
   },  
   {   
       x2d = 8488,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 8488,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 8488,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 8488,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 8473,   
       y2d = 923,  
       radius = 27,  
   },  
   {   
       x2d = 8473,   
       y2d = 1173,  
       radius = 27,  
   },  
   {   
       x2d = 8488,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 8466,   
       y2d = 1416,  
       radius = 20,  
   },  
   {   
       x2d = 8481,   
       y2d = 1531,  
       radius = 35,  
   },  
   {   
       x2d = 8451,   
       y2d = 2101,  
       radius = 5,  
   },  
   {   
       x2d = 8451,   
       y2d = 2251,  
       radius = 5,  
   },  
   {   
       x2d = 8451,   
       y2d = 2401,  
       radius = 5,  
   },  
   {   
       x2d = 8451,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 8451,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 8458,   
       y2d = 3858,  
       radius = 12,  
   },  
   {   
       x2d = 8451,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 8451,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 8451,   
       y2d = 4701,  
       radius = 5,  
   },  
   {   
       x2d = 8451,   
       y2d = 4751,  
       radius = 5,  
   },  
   {   
       x2d = 8538,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 8538,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 8538,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 8501,   
       y2d = 751,  
       radius = 5,  
   },  
   {   
       x2d = 8516,   
       y2d = 816,  
       radius = 20,  
   },  
   {   
       x2d = 8516,   
       y2d = 866,  
       radius = 20,  
   },  
   {   
       x2d = 8531,   
       y2d = 931,  
       radius = 35,  
   },  
   {   
       x2d = 8516,   
       y2d = 1066,  
       radius = 20,  
   },  
   {   
       x2d = 8538,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 8538,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 8531,   
       y2d = 1631,  
       radius = 35,  
   },  
   {   
       x2d = 8508,   
       y2d = 1708,  
       radius = 12,  
   },  
   {   
       x2d = 8516,   
       y2d = 1766,  
       radius = 20,  
   },  
   {   
       x2d = 8501,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 8508,   
       y2d = 1908,  
       radius = 12,  
   },  
   {   
       x2d = 8501,   
       y2d = 2251,  
       radius = 5,  
   },  
   {   
       x2d = 8501,   
       y2d = 2301,  
       radius = 5,  
   },  
   {   
       x2d = 8501,   
       y2d = 2351,  
       radius = 5,  
   },  
   {   
       x2d = 8508,   
       y2d = 2408,  
       radius = 12,  
   },  
   {   
       x2d = 8501,   
       y2d = 2451,  
       radius = 5,  
   },  
   {   
       x2d = 8501,   
       y2d = 2501,  
       radius = 5,  
   },  
   {   
       x2d = 8508,   
       y2d = 2858,  
       radius = 12,  
   },  
   {   
       x2d = 8501,   
       y2d = 2901,  
       radius = 5,  
   },  
   {   
       x2d = 8501,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 8501,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 8501,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 8501,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 8501,   
       y2d = 4601,  
       radius = 5,  
   },  
   {   
       x2d = 8501,   
       y2d = 4651,  
       radius = 5,  
   },  
   {   
       x2d = 8516,   
       y2d = 4766,  
       radius = 20,  
   },  
   {   
       x2d = 8508,   
       y2d = 4808,  
       radius = 12,  
   },  
   {   
       x2d = 8588,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 8588,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 8573,   
       y2d = 573,  
       radius = 27,  
   },  
   {   
       x2d = 8588,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 8551,   
       y2d = 751,  
       radius = 5,  
   },  
   {   
       x2d = 8551,   
       y2d = 1001,  
       radius = 5,  
   },  
   {   
       x2d = 8588,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 8588,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 8558,   
       y2d = 1708,  
       radius = 12,  
   },  
   {   
       x2d = 8558,   
       y2d = 1808,  
       radius = 12,  
   },  
   {   
       x2d = 8558,   
       y2d = 1858,  
       radius = 12,  
   },  
   {   
       x2d = 8566,   
       y2d = 2366,  
       radius = 20,  
   },  
   {   
       x2d = 8558,   
       y2d = 2508,  
       radius = 12,  
   },  
   {   
       x2d = 8551,   
       y2d = 2551,  
       radius = 5,  
   },  
   {   
       x2d = 8551,   
       y2d = 2651,  
       radius = 5,  
   },  
   {   
       x2d = 8551,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 8551,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 8566,   
       y2d = 3666,  
       radius = 20,  
   },  
   {   
       x2d = 8551,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 8551,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 8551,   
       y2d = 4351,  
       radius = 5,  
   },  
   {   
       x2d = 8551,   
       y2d = 4451,  
       radius = 5,  
   },  
   {   
       x2d = 8551,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 8551,   
       y2d = 4701,  
       radius = 5,  
   },  
   {   
       x2d = 8558,   
       y2d = 4758,  
       radius = 12,  
   },  
   {   
       x2d = 8551,   
       y2d = 4801,  
       radius = 5,  
   },  
   {   
       x2d = 8638,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 8638,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 8638,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 8638,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 8631,   
       y2d = 831,  
       radius = 35,  
   },  
   {   
       x2d = 8601,   
       y2d = 901,  
       radius = 5,  
   },  
   {   
       x2d = 8601,   
       y2d = 951,  
       radius = 5,  
   },  
   {   
       x2d = 8601,   
       y2d = 1001,  
       radius = 5,  
   },  
   {   
       x2d = 8638,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 8601,   
       y2d = 1651,  
       radius = 5,  
   },  
   {   
       x2d = 8608,   
       y2d = 1708,  
       radius = 12,  
   },  
   {   
       x2d = 8608,   
       y2d = 1758,  
       radius = 12,  
   },  
   {   
       x2d = 8608,   
       y2d = 1808,  
       radius = 12,  
   },  
   {   
       x2d = 8608,   
       y2d = 2508,  
       radius = 12,  
   },  
   {   
       x2d = 8608,   
       y2d = 2708,  
       radius = 12,  
   },  
   {   
       x2d = 8608,   
       y2d = 3658,  
       radius = 12,  
   },  
   {   
       x2d = 8608,   
       y2d = 3758,  
       radius = 12,  
   },  
   {   
       x2d = 8623,   
       y2d = 3823,  
       radius = 27,  
   },  
   {   
       x2d = 8601,   
       y2d = 4201,  
       radius = 5,  
   },  
   {   
       x2d = 8608,   
       y2d = 4508,  
       radius = 12,  
   },  
   {   
       x2d = 8601,   
       y2d = 4701,  
       radius = 5,  
   },  
   {   
       x2d = 8601,   
       y2d = 4751,  
       radius = 5,  
   },  
   {   
       x2d = 8608,   
       y2d = 4808,  
       radius = 12,  
   },  
   {   
       x2d = 8608,   
       y2d = 4858,  
       radius = 12,  
   },  
   {   
       x2d = 8688,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 8688,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 8688,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 8688,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 8666,   
       y2d = 966,  
       radius = 20,  
   },  
   {   
       x2d = 8673,   
       y2d = 1073,  
       radius = 27,  
   },  
   {   
       x2d = 8666,   
       y2d = 1166,  
       radius = 20,  
   },  
   {   
       x2d = 8688,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 8688,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 8688,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 8651,   
       y2d = 2401,  
       radius = 5,  
   },  
   {   
       x2d = 8658,   
       y2d = 2808,  
       radius = 12,  
   },  
   {   
       x2d = 8651,   
       y2d = 3051,  
       radius = 5,  
   },  
   {   
       x2d = 8688,   
       y2d = 3838,  
       radius = 42,  
   },  
   {   
       x2d = 8658,   
       y2d = 4508,  
       radius = 12,  
   },  
   {   
       x2d = 8651,   
       y2d = 4651,  
       radius = 5,  
   },  
   {   
       x2d = 8658,   
       y2d = 4708,  
       radius = 12,  
   },  
   {   
       x2d = 8658,   
       y2d = 4808,  
       radius = 12,  
   },  
   {   
       x2d = 8651,   
       y2d = 4851,  
       radius = 5,  
   },  
   {   
       x2d = 8738,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 8738,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 8738,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 8738,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 8731,   
       y2d = 881,  
       radius = 35,  
   },  
   {   
       x2d = 8738,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 8738,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 8701,   
       y2d = 1251,  
       radius = 5,  
   },  
   {   
       x2d = 8738,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 8701,   
       y2d = 1801,  
       radius = 5,  
   },  
   {   
       x2d = 8701,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 8701,   
       y2d = 2601,  
       radius = 5,  
   },  
   {   
       x2d = 8701,   
       y2d = 3201,  
       radius = 5,  
   },  
   {   
       x2d = 8701,   
       y2d = 3351,  
       radius = 5,  
   },  
   {   
       x2d = 8723,   
       y2d = 3673,  
       radius = 27,  
   },  
   {   
       x2d = 8701,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 8701,   
       y2d = 4601,  
       radius = 5,  
   },  
   {   
       x2d = 8701,   
       y2d = 4751,  
       radius = 5,  
   },  
   {   
       x2d = 8788,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 8788,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 8788,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 8788,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 8788,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 8773,   
       y2d = 1423,  
       radius = 27,  
   },  
   {   
       x2d = 8788,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 8773,   
       y2d = 1623,  
       radius = 27,  
   },  
   {   
       x2d = 8751,   
       y2d = 1751,  
       radius = 5,  
   },  
   {   
       x2d = 8788,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 8751,   
       y2d = 2501,  
       radius = 5,  
   },  
   {   
       x2d = 8751,   
       y2d = 2651,  
       radius = 5,  
   },  
   {   
       x2d = 8751,   
       y2d = 3401,  
       radius = 5,  
   },  
   {   
       x2d = 8751,   
       y2d = 3451,  
       radius = 5,  
   },  
   {   
       x2d = 8751,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 8751,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 8751,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 8751,   
       y2d = 4651,  
       radius = 5,  
   },  
   {   
       x2d = 8751,   
       y2d = 4951,  
       radius = 5,  
   },  
   {   
       x2d = 8838,   
       y2d = 288,  
       radius = 42,  
   },  
   {   
       x2d = 8838,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 8838,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 8838,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 8831,   
       y2d = 931,  
       radius = 35,  
   },  
   {   
       x2d = 8831,   
       y2d = 1131,  
       radius = 35,  
   },  
   {   
       x2d = 8838,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 8838,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 8838,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 8801,   
       y2d = 2451,  
       radius = 5,  
   },  
   {   
       x2d = 8808,   
       y2d = 2558,  
       radius = 12,  
   },  
   {   
       x2d = 8801,   
       y2d = 2601,  
       radius = 5,  
   },  
   {   
       x2d = 8816,   
       y2d = 3716,  
       radius = 20,  
   },  
   {   
       x2d = 8823,   
       y2d = 3873,  
       radius = 27,  
   },  
   {   
       x2d = 8801,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 8801,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 8801,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 8801,   
       y2d = 4601,  
       radius = 5,  
   },  
   {   
       x2d = 8801,   
       y2d = 4901,  
       radius = 5,  
   },  
   {   
       x2d = 8888,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 8888,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 8888,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 8888,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 8858,   
       y2d = 1008,  
       radius = 12,  
   },  
   {   
       x2d = 8858,   
       y2d = 1058,  
       radius = 12,  
   },  
   {   
       x2d = 8888,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 8888,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 8888,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 8888,   
       y2d = 1888,  
       radius = 42,  
   },  
   {   
       x2d = 8888,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 8851,   
       y2d = 2301,  
       radius = 5,  
   },  
   {   
       x2d = 8873,   
       y2d = 2523,  
       radius = 27,  
   },  
   {   
       x2d = 8851,   
       y2d = 2601,  
       radius = 5,  
   },  
   {   
       x2d = 8866,   
       y2d = 3816,  
       radius = 20,  
   },  
   {   
       x2d = 8851,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 8851,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 8888,   
       y2d = 4538,  
       radius = 42,  
   },  
   {   
       x2d = 8858,   
       y2d = 4758,  
       radius = 12,  
   },  
   {   
       x2d = 8851,   
       y2d = 4901,  
       radius = 5,  
   },  
   {   
       x2d = 8851,   
       y2d = 4951,  
       radius = 5,  
   },  
   {   
       x2d = 8938,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 8938,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 8938,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 8938,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 8938,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 8938,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 8901,   
       y2d = 1051,  
       radius = 5,  
   },  
   {   
       x2d = 8901,   
       y2d = 1101,  
       radius = 5,  
   },  
   {   
       x2d = 8901,   
       y2d = 1151,  
       radius = 5,  
   },  
   {   
       x2d = 8938,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 8938,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 8938,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 8901,   
       y2d = 2601,  
       radius = 5,  
   },  
   {   
       x2d = 8901,   
       y2d = 2951,  
       radius = 5,  
   },  
   {   
       x2d = 8901,   
       y2d = 3301,  
       radius = 5,  
   },  
   {   
       x2d = 8908,   
       y2d = 3908,  
       radius = 12,  
   },  
   {   
       x2d = 8916,   
       y2d = 4666,  
       radius = 20,  
   },  
   {   
       x2d = 8938,   
       y2d = 4738,  
       radius = 42,  
   },  
   {   
       x2d = 8901,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 8988,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 8988,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 8988,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 8988,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 8973,   
       y2d = 1023,  
       radius = 27,  
   },  
   {   
       x2d = 8973,   
       y2d = 1123,  
       radius = 27,  
   },  
   {   
       x2d = 8981,   
       y2d = 1431,  
       radius = 35,  
   },  
   {   
       x2d = 8973,   
       y2d = 1723,  
       radius = 27,  
   },  
   {   
       x2d = 8988,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 8981,   
       y2d = 1931,  
       radius = 35,  
   },  
   {   
       x2d = 8988,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 8951,   
       y2d = 2501,  
       radius = 5,  
   },  
   {   
       x2d = 8951,   
       y2d = 2551,  
       radius = 5,  
   },  
   {   
       x2d = 8958,   
       y2d = 2608,  
       radius = 12,  
   },  
   {   
       x2d = 8951,   
       y2d = 3301,  
       radius = 5,  
   },  
   {   
       x2d = 8973,   
       y2d = 3573,  
       radius = 27,  
   },  
   {   
       x2d = 8951,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 8966,   
       y2d = 3816,  
       radius = 20,  
   },  
   {   
       x2d = 8958,   
       y2d = 3858,  
       radius = 12,  
   },  
   {   
       x2d = 8958,   
       y2d = 3908,  
       radius = 12,  
   },  
   {   
       x2d = 8951,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 8951,   
       y2d = 4351,  
       radius = 5,  
   },  
   {   
       x2d = 8951,   
       y2d = 4851,  
       radius = 5,  
   },  
   {   
       x2d = 8966,   
       y2d = 5116,  
       radius = 20,  
   },  
   {   
       x2d = 9038,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 9038,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 9038,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 9038,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 9038,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 9038,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 9038,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 9038,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 9001,   
       y2d = 1251,  
       radius = 5,  
   },  
   {   
       x2d = 9023,   
       y2d = 1323,  
       radius = 27,  
   },  
   {   
       x2d = 9031,   
       y2d = 1381,  
       radius = 35,  
   },  
   {   
       x2d = 9038,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 9038,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 9008,   
       y2d = 2458,  
       radius = 12,  
   },  
   {   
       x2d = 9001,   
       y2d = 2501,  
       radius = 5,  
   },  
   {   
       x2d = 9001,   
       y2d = 2551,  
       radius = 5,  
   },  
   {   
       x2d = 9001,   
       y2d = 2601,  
       radius = 5,  
   },  
   {   
       x2d = 9001,   
       y2d = 3251,  
       radius = 5,  
   },  
   {   
       x2d = 9031,   
       y2d = 3531,  
       radius = 35,  
   },  
   {   
       x2d = 9016,   
       y2d = 3616,  
       radius = 20,  
   },  
   {   
       x2d = 9016,   
       y2d = 3666,  
       radius = 20,  
   },  
   {   
       x2d = 9008,   
       y2d = 3708,  
       radius = 12,  
   },  
   {   
       x2d = 9008,   
       y2d = 3808,  
       radius = 12,  
   },  
   {   
       x2d = 9001,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 9008,   
       y2d = 4008,  
       radius = 12,  
   },  
   {   
       x2d = 9001,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 9001,   
       y2d = 4451,  
       radius = 5,  
   },  
   {   
       x2d = 9001,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 9001,   
       y2d = 4601,  
       radius = 5,  
   },  
   {   
       x2d = 9038,   
       y2d = 4688,  
       radius = 42,  
   },  
   {   
       x2d = 9031,   
       y2d = 4781,  
       radius = 35,  
   },  
   {   
       x2d = 9001,   
       y2d = 4851,  
       radius = 5,  
   },  
   {   
       x2d = 9001,   
       y2d = 4901,  
       radius = 5,  
   },  
   {   
       x2d = 9001,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 9016,   
       y2d = 5316,  
       radius = 20,  
   },  
   {   
       x2d = 9088,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 9088,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 9088,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 9088,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 9081,   
       y2d = 1231,  
       radius = 35,  
   },  
   {   
       x2d = 9088,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 9088,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 9088,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 9088,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 9058,   
       y2d = 2158,  
       radius = 12,  
   },  
   {   
       x2d = 9051,   
       y2d = 2201,  
       radius = 5,  
   },  
   {   
       x2d = 9051,   
       y2d = 2501,  
       radius = 5,  
   },  
   {   
       x2d = 9051,   
       y2d = 2651,  
       radius = 5,  
   },  
   {   
       x2d = 9051,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 9051,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 9051,   
       y2d = 3051,  
       radius = 5,  
   },  
   {   
       x2d = 9051,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 9051,   
       y2d = 3201,  
       radius = 5,  
   },  
   {   
       x2d = 9058,   
       y2d = 3358,  
       radius = 12,  
   },  
   {   
       x2d = 9058,   
       y2d = 3658,  
       radius = 12,  
   },  
   {   
       x2d = 9058,   
       y2d = 3758,  
       radius = 12,  
   },  
   {   
       x2d = 9051,   
       y2d = 3801,  
       radius = 5,  
   },  
   {   
       x2d = 9058,   
       y2d = 3908,  
       radius = 12,  
   },  
   {   
       x2d = 9073,   
       y2d = 4023,  
       radius = 27,  
   },  
   {   
       x2d = 9058,   
       y2d = 4358,  
       radius = 12,  
   },  
   {   
       x2d = 9058,   
       y2d = 5258,  
       radius = 12,  
   },  
   {   
       x2d = 9138,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 9138,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 9138,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 9138,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 9138,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 9138,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 9138,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 9123,   
       y2d = 1323,  
       radius = 27,  
   },  
   {   
       x2d = 9101,   
       y2d = 1401,  
       radius = 5,  
   },  
   {   
       x2d = 9123,   
       y2d = 1473,  
       radius = 27,  
   },  
   {   
       x2d = 9131,   
       y2d = 1531,  
       radius = 35,  
   },  
   {   
       x2d = 9138,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 9123,   
       y2d = 2173,  
       radius = 27,  
   },  
   {   
       x2d = 9138,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 9108,   
       y2d = 2658,  
       radius = 12,  
   },  
   {   
       x2d = 9101,   
       y2d = 3201,  
       radius = 5,  
   },  
   {   
       x2d = 9101,   
       y2d = 3401,  
       radius = 5,  
   },  
   {   
       x2d = 9101,   
       y2d = 3451,  
       radius = 5,  
   },  
   {   
       x2d = 9101,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 9131,   
       y2d = 3931,  
       radius = 35,  
   },  
   {   
       x2d = 9116,   
       y2d = 4066,  
       radius = 20,  
   },  
   {   
       x2d = 9116,   
       y2d = 4116,  
       radius = 20,  
   },  
   {   
       x2d = 9108,   
       y2d = 4158,  
       radius = 12,  
   },  
   {   
       x2d = 9116,   
       y2d = 4366,  
       radius = 20,  
   },  
   {   
       x2d = 9108,   
       y2d = 4408,  
       radius = 12,  
   },  
   {   
       x2d = 9116,   
       y2d = 4666,  
       radius = 20,  
   },  
   {   
       x2d = 9101,   
       y2d = 4801,  
       radius = 5,  
   },  
   {   
       x2d = 9101,   
       y2d = 4951,  
       radius = 5,  
   },  
   {   
       x2d = 9101,   
       y2d = 5051,  
       radius = 5,  
   },  
   {   
       x2d = 9188,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 9188,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 9188,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 9188,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 9188,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 9188,   
       y2d = 1888,  
       radius = 42,  
   },  
   {   
       x2d = 9188,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 9188,   
       y2d = 2088,  
       radius = 42,  
   },  
   {   
       x2d = 9151,   
       y2d = 2251,  
       radius = 5,  
   },  
   {   
       x2d = 9151,   
       y2d = 2301,  
       radius = 5,  
   },  
   {   
       x2d = 9151,   
       y2d = 2351,  
       radius = 5,  
   },  
   {   
       x2d = 9151,   
       y2d = 2401,  
       radius = 5,  
   },  
   {   
       x2d = 9151,   
       y2d = 2651,  
       radius = 5,  
   },  
   {   
       x2d = 9151,   
       y2d = 3201,  
       radius = 5,  
   },  
   {   
       x2d = 9151,   
       y2d = 3401,  
       radius = 5,  
   },  
   {   
       x2d = 9151,   
       y2d = 3801,  
       radius = 5,  
   },  
   {   
       x2d = 9158,   
       y2d = 3858,  
       radius = 12,  
   },  
   {   
       x2d = 9151,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 9181,   
       y2d = 4181,  
       radius = 35,  
   },  
   {   
       x2d = 9151,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 9166,   
       y2d = 5216,  
       radius = 20,  
   },  
   {   
       x2d = 9173,   
       y2d = 5273,  
       radius = 27,  
   },  
   {   
       x2d = 9238,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 9238,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 9238,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 9238,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 9238,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 9238,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 9238,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 9238,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 9238,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 9231,   
       y2d = 1481,  
       radius = 35,  
   },  
   {   
       x2d = 9201,   
       y2d = 1551,  
       radius = 5,  
   },  
   {   
       x2d = 9201,   
       y2d = 2201,  
       radius = 5,  
   },  
   {   
       x2d = 9208,   
       y2d = 2258,  
       radius = 12,  
   },  
   {   
       x2d = 9201,   
       y2d = 2351,  
       radius = 5,  
   },  
   {   
       x2d = 9201,   
       y2d = 2401,  
       radius = 5,  
   },  
   {   
       x2d = 9216,   
       y2d = 2516,  
       radius = 20,  
   },  
   {   
       x2d = 9231,   
       y2d = 2631,  
       radius = 35,  
   },  
   {   
       x2d = 9201,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 9201,   
       y2d = 3301,  
       radius = 5,  
   },  
   {   
       x2d = 9208,   
       y2d = 3358,  
       radius = 12,  
   },  
   {   
       x2d = 9201,   
       y2d = 3451,  
       radius = 5,  
   },  
   {   
       x2d = 9216,   
       y2d = 3766,  
       radius = 20,  
   },  
   {   
       x2d = 9223,   
       y2d = 3823,  
       radius = 27,  
   },  
   {   
       x2d = 9223,   
       y2d = 3923,  
       radius = 27,  
   },  
   {   
       x2d = 9201,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 9201,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 9208,   
       y2d = 4108,  
       radius = 12,  
   },  
   {   
       x2d = 9201,   
       y2d = 4351,  
       radius = 5,  
   },  
   {   
       x2d = 9238,   
       y2d = 4438,  
       radius = 42,  
   },  
   {   
       x2d = 9201,   
       y2d = 4751,  
       radius = 5,  
   },  
   {   
       x2d = 9201,   
       y2d = 4901,  
       radius = 5,  
   },  
   {   
       x2d = 9238,   
       y2d = 5188,  
       radius = 42,  
   },  
   {   
       x2d = 9288,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 9288,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 9288,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 9281,   
       y2d = 1181,  
       radius = 35,  
   },  
   {   
       x2d = 9273,   
       y2d = 1273,  
       radius = 27,  
   },  
   {   
       x2d = 9288,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 9288,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 9288,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 9288,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 9288,   
       y2d = 2188,  
       radius = 42,  
   },  
   {   
       x2d = 9288,   
       y2d = 2288,  
       radius = 42,  
   },  
   {   
       x2d = 9281,   
       y2d = 2431,  
       radius = 35,  
   },  
   {   
       x2d = 9266,   
       y2d = 2516,  
       radius = 20,  
   },  
   {   
       x2d = 9251,   
       y2d = 2901,  
       radius = 5,  
   },  
   {   
       x2d = 9251,   
       y2d = 3501,  
       radius = 5,  
   },  
   {   
       x2d = 9251,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 9266,   
       y2d = 3966,  
       radius = 20,  
   },  
   {   
       x2d = 9258,   
       y2d = 4008,  
       radius = 12,  
   },  
   {   
       x2d = 9251,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 9266,   
       y2d = 4166,  
       radius = 20,  
   },  
   {   
       x2d = 9273,   
       y2d = 4223,  
       radius = 27,  
   },  
   {   
       x2d = 9251,   
       y2d = 4601,  
       radius = 5,  
   },  
   {   
       x2d = 9266,   
       y2d = 4966,  
       radius = 20,  
   },  
   {   
       x2d = 9251,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 9251,   
       y2d = 5351,  
       radius = 5,  
   },  
   {   
       x2d = 9338,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 9338,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 9338,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 9338,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 9338,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 9338,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 9338,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 9338,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 9338,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 9331,   
       y2d = 1281,  
       radius = 35,  
   },  
   {   
       x2d = 9338,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 9338,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 9338,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 9338,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 9316,   
       y2d = 2516,  
       radius = 20,  
   },  
   {   
       x2d = 9308,   
       y2d = 2608,  
       radius = 12,  
   },  
   {   
       x2d = 9338,   
       y2d = 2688,  
       radius = 42,  
   },  
   {   
       x2d = 9301,   
       y2d = 2901,  
       radius = 5,  
   },  
   {   
       x2d = 9301,   
       y2d = 3401,  
       radius = 5,  
   },  
   {   
       x2d = 9301,   
       y2d = 3501,  
       radius = 5,  
   },  
   {   
       x2d = 9308,   
       y2d = 3558,  
       radius = 12,  
   },  
   {   
       x2d = 9323,   
       y2d = 3623,  
       radius = 27,  
   },  
   {   
       x2d = 9301,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 9308,   
       y2d = 3858,  
       radius = 12,  
   },  
   {   
       x2d = 9301,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 9316,   
       y2d = 4116,  
       radius = 20,  
   },  
   {   
       x2d = 9338,   
       y2d = 4938,  
       radius = 42,  
   },  
   {   
       x2d = 9301,   
       y2d = 5101,  
       radius = 5,  
   },  
   {   
       x2d = 9301,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 9388,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 9388,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 9381,   
       y2d = 531,  
       radius = 35,  
   },  
   {   
       x2d = 9388,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 9388,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 9388,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 9373,   
       y2d = 1873,  
       radius = 27,  
   },  
   {   
       x2d = 9388,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 9388,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 9388,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 9388,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 9373,   
       y2d = 2473,  
       radius = 27,  
   },  
   {   
       x2d = 9358,   
       y2d = 2558,  
       radius = 12,  
   },  
   {   
       x2d = 9351,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 9351,   
       y2d = 3551,  
       radius = 5,  
   },  
   {   
       x2d = 9366,   
       y2d = 3666,  
       radius = 20,  
   },  
   {   
       x2d = 9358,   
       y2d = 3708,  
       radius = 12,  
   },  
   {   
       x2d = 9351,   
       y2d = 3851,  
       radius = 5,  
   },  
   {   
       x2d = 9351,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 9366,   
       y2d = 4066,  
       radius = 20,  
   },  
   {   
       x2d = 9373,   
       y2d = 4123,  
       radius = 27,  
   },  
   {   
       x2d = 9366,   
       y2d = 4266,  
       radius = 20,  
   },  
   {   
       x2d = 9358,   
       y2d = 4308,  
       radius = 12,  
   },  
   {   
       x2d = 9366,   
       y2d = 4466,  
       radius = 20,  
   },  
   {   
       x2d = 9351,   
       y2d = 5101,  
       radius = 5,  
   },  
   {   
       x2d = 9351,   
       y2d = 5201,  
       radius = 5,  
   },  
   {   
       x2d = 9351,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 9351,   
       y2d = 5351,  
       radius = 5,  
   },  
   {   
       x2d = 9438,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 9438,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 9438,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 9438,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 9438,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 9438,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 9438,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 9431,   
       y2d = 1031,  
       radius = 35,  
   },  
   {   
       x2d = 9438,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 9438,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 9438,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 9438,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 9438,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 9438,   
       y2d = 2488,  
       radius = 42,  
   },  
   {   
       x2d = 9438,   
       y2d = 2588,  
       radius = 42,  
   },  
   {   
       x2d = 9431,   
       y2d = 2681,  
       radius = 35,  
   },  
   {   
       x2d = 9408,   
       y2d = 2808,  
       radius = 12,  
   },  
   {   
       x2d = 9401,   
       y2d = 3251,  
       radius = 5,  
   },  
   {   
       x2d = 9401,   
       y2d = 3301,  
       radius = 5,  
   },  
   {   
       x2d = 9401,   
       y2d = 3351,  
       radius = 5,  
   },  
   {   
       x2d = 9408,   
       y2d = 3608,  
       radius = 12,  
   },  
   {   
       x2d = 9401,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 9416,   
       y2d = 4166,  
       radius = 20,  
   },  
   {   
       x2d = 9408,   
       y2d = 4208,  
       radius = 12,  
   },  
   {   
       x2d = 9431,   
       y2d = 4281,  
       radius = 35,  
   },  
   {   
       x2d = 9416,   
       y2d = 4366,  
       radius = 20,  
   },  
   {   
       x2d = 9401,   
       y2d = 4601,  
       radius = 5,  
   },  
   {   
       x2d = 9408,   
       y2d = 4858,  
       radius = 12,  
   },  
   {   
       x2d = 9438,   
       y2d = 4938,  
       radius = 42,  
   },  
   {   
       x2d = 9408,   
       y2d = 5108,  
       radius = 12,  
   },  
   {   
       x2d = 9401,   
       y2d = 5201,  
       radius = 5,  
   },  
   {   
       x2d = 9401,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 9408,   
       y2d = 5308,  
       radius = 12,  
   },  
   {   
       x2d = 9466,   
       y2d = 16,  
       radius = 20,  
   },  
   {   
       x2d = 9488,   
       y2d = 88,  
       radius = 42,  
   },  
   {   
       x2d = 9488,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 9488,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 9488,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 9488,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 9451,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 9458,   
       y2d = 2958,  
       radius = 12,  
   },  
   {   
       x2d = 9451,   
       y2d = 3201,  
       radius = 5,  
   },  
   {   
       x2d = 9488,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 9473,   
       y2d = 3973,  
       radius = 27,  
   },  
   {   
       x2d = 9458,   
       y2d = 4058,  
       radius = 12,  
   },  
   {   
       x2d = 9481,   
       y2d = 4231,  
       radius = 35,  
   },  
   {   
       x2d = 9451,   
       y2d = 4601,  
       radius = 5,  
   },  
   {   
       x2d = 9451,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 9451,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 9451,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 9451,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 9538,   
       y2d = 188,  
       radius = 42,  
   },  
   {   
       x2d = 9538,   
       y2d = 288,  
       radius = 42,  
   },  
   {   
       x2d = 9538,   
       y2d = 388,  
       radius = 42,  
   },  
   {   
       x2d = 9538,   
       y2d = 488,  
       radius = 42,  
   },  
   {   
       x2d = 9538,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 9538,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 9538,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 9538,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 9538,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 9538,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 9538,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 9538,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 9538,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 9531,   
       y2d = 2031,  
       radius = 35,  
   },  
   {   
       x2d = 9538,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 9538,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 9501,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 9523,   
       y2d = 3323,  
       radius = 27,  
   },  
   {   
       x2d = 9538,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 9516,   
       y2d = 3916,  
       radius = 20,  
   },  
   {   
       x2d = 9538,   
       y2d = 4038,  
       radius = 42,  
   },  
   {   
       x2d = 9501,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 9516,   
       y2d = 4316,  
       radius = 20,  
   },  
   {   
       x2d = 9516,   
       y2d = 4366,  
       radius = 20,  
   },  
   {   
       x2d = 9501,   
       y2d = 4751,  
       radius = 5,  
   },  
   {   
       x2d = 9538,   
       y2d = 4888,  
       radius = 42,  
   },  
   {   
       x2d = 9501,   
       y2d = 5001,  
       radius = 5,  
   },  
   {   
       x2d = 9501,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 9501,   
       y2d = 5201,  
       radius = 5,  
   },  
   {   
       x2d = 9508,   
       y2d = 5358,  
       radius = 12,  
   },  
   {   
       x2d = 9501,   
       y2d = 10351,  
       radius = 5,  
   },  
   {   
       x2d = 9588,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 9588,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 9588,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 9588,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 9573,   
       y2d = 1823,  
       radius = 27,  
   },  
   {   
       x2d = 9573,   
       y2d = 1923,  
       radius = 27,  
   },  
   {   
       x2d = 9588,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 9573,   
       y2d = 2173,  
       radius = 27,  
   },  
   {   
       x2d = 9581,   
       y2d = 2231,  
       radius = 35,  
   },  
   {   
       x2d = 9588,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 9551,   
       y2d = 2701,  
       radius = 5,  
   },  
   {   
       x2d = 9551,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 9551,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 9558,   
       y2d = 2908,  
       radius = 12,  
   },  
   {   
       x2d = 9566,   
       y2d = 2966,  
       radius = 20,  
   },  
   {   
       x2d = 9558,   
       y2d = 3008,  
       radius = 12,  
   },  
   {   
       x2d = 9551,   
       y2d = 3051,  
       radius = 5,  
   },  
   {   
       x2d = 9551,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 9588,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 9588,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 9588,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 9573,   
       y2d = 3623,  
       radius = 27,  
   },  
   {   
       x2d = 9573,   
       y2d = 3723,  
       radius = 27,  
   },  
   {   
       x2d = 9581,   
       y2d = 3831,  
       radius = 35,  
   },  
   {   
       x2d = 9551,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 9566,   
       y2d = 4166,  
       radius = 20,  
   },  
   {   
       x2d = 9558,   
       y2d = 4208,  
       radius = 12,  
   },  
   {   
       x2d = 9558,   
       y2d = 4408,  
       radius = 12,  
   },  
   {   
       x2d = 9551,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 9558,   
       y2d = 5258,  
       radius = 12,  
   },  
   {   
       x2d = 9573,   
       y2d = 5323,  
       radius = 27,  
   },  
   {   
       x2d = 9638,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 9638,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 9638,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 9638,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 9638,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 9638,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 9638,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 9638,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 9631,   
       y2d = 931,  
       radius = 35,  
   },  
   {   
       x2d = 9638,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 9638,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 9638,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 9638,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 9638,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 9638,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 9631,   
       y2d = 2631,  
       radius = 35,  
   },  
   {   
       x2d = 9601,   
       y2d = 2701,  
       radius = 5,  
   },  
   {   
       x2d = 9601,   
       y2d = 2801,  
       radius = 5,  
   },  
   {   
       x2d = 9601,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 9616,   
       y2d = 2916,  
       radius = 20,  
   },  
   {   
       x2d = 9608,   
       y2d = 2958,  
       radius = 12,  
   },  
   {   
       x2d = 9638,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 9638,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 9608,   
       y2d = 3908,  
       radius = 12,  
   },  
   {   
       x2d = 9631,   
       y2d = 4231,  
       radius = 35,  
   },  
   {   
       x2d = 9623,   
       y2d = 4323,  
       radius = 27,  
   },  
   {   
       x2d = 9608,   
       y2d = 4408,  
       radius = 12,  
   },  
   {   
       x2d = 9601,   
       y2d = 4451,  
       radius = 5,  
   },  
   {   
       x2d = 9601,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 9608,   
       y2d = 4608,  
       radius = 12,  
   },  
   {   
       x2d = 9616,   
       y2d = 4866,  
       radius = 20,  
   },  
   {   
       x2d = 9608,   
       y2d = 5008,  
       radius = 12,  
   },  
   {   
       x2d = 9601,   
       y2d = 5201,  
       radius = 5,  
   },  
   {   
       x2d = 9601,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 9601,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 9688,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 9688,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 9688,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 9688,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 9688,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 9666,   
       y2d = 2316,  
       radius = 20,  
   },  
   {   
       x2d = 9651,   
       y2d = 2401,  
       radius = 5,  
   },  
   {   
       x2d = 9666,   
       y2d = 2516,  
       radius = 20,  
   },  
   {   
       x2d = 9673,   
       y2d = 2573,  
       radius = 27,  
   },  
   {   
       x2d = 9651,   
       y2d = 2701,  
       radius = 5,  
   },  
   {   
       x2d = 9658,   
       y2d = 2808,  
       radius = 12,  
   },  
   {   
       x2d = 9658,   
       y2d = 3008,  
       radius = 12,  
   },  
   {   
       x2d = 9688,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 9651,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 9658,   
       y2d = 3708,  
       radius = 12,  
   },  
   {   
       x2d = 9651,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 9651,   
       y2d = 3801,  
       radius = 5,  
   },  
   {   
       x2d = 9666,   
       y2d = 3866,  
       radius = 20,  
   },  
   {   
       x2d = 9666,   
       y2d = 3916,  
       radius = 20,  
   },  
   {   
       x2d = 9673,   
       y2d = 4123,  
       radius = 27,  
   },  
   {   
       x2d = 9666,   
       y2d = 4416,  
       radius = 20,  
   },  
   {   
       x2d = 9651,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 9651,   
       y2d = 4601,  
       radius = 5,  
   },  
   {   
       x2d = 9651,   
       y2d = 4701,  
       radius = 5,  
   },  
   {   
       x2d = 9673,   
       y2d = 4823,  
       radius = 27,  
   },  
   {   
       x2d = 9666,   
       y2d = 4966,  
       radius = 20,  
   },  
   {   
       x2d = 9666,   
       y2d = 5016,  
       radius = 20,  
   },  
   {   
       x2d = 9651,   
       y2d = 5201,  
       radius = 5,  
   },  
   {   
       x2d = 9666,   
       y2d = 5316,  
       radius = 20,  
   },  
   {   
       x2d = 9658,   
       y2d = 5408,  
       radius = 12,  
   },  
   {   
       x2d = 9738,   
       y2d = 188,  
       radius = 42,  
   },  
   {   
       x2d = 9738,   
       y2d = 288,  
       radius = 42,  
   },  
   {   
       x2d = 9738,   
       y2d = 388,  
       radius = 42,  
   },  
   {   
       x2d = 9723,   
       y2d = 473,  
       radius = 27,  
   },  
   {   
       x2d = 9738,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 9738,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 9738,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 9738,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 9738,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 9738,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 9738,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 9738,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 9738,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 9738,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 9738,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 9708,   
       y2d = 2758,  
       radius = 12,  
   },  
   {   
       x2d = 9701,   
       y2d = 2801,  
       radius = 5,  
   },  
   {   
       x2d = 9708,   
       y2d = 2908,  
       radius = 12,  
   },  
   {   
       x2d = 9701,   
       y2d = 2951,  
       radius = 5,  
   },  
   {   
       x2d = 9716,   
       y2d = 3066,  
       radius = 20,  
   },  
   {   
       x2d = 9723,   
       y2d = 3323,  
       radius = 27,  
   },  
   {   
       x2d = 9738,   
       y2d = 3388,  
       radius = 42,  
   },  
   {   
       x2d = 9723,   
       y2d = 3473,  
       radius = 27,  
   },  
   {   
       x2d = 9701,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 9716,   
       y2d = 3766,  
       radius = 20,  
   },  
   {   
       x2d = 9701,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 9701,   
       y2d = 4201,  
       radius = 5,  
   },  
   {   
       x2d = 9701,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 9716,   
       y2d = 4466,  
       radius = 20,  
   },  
   {   
       x2d = 9701,   
       y2d = 4651,  
       radius = 5,  
   },  
   {   
       x2d = 9708,   
       y2d = 4958,  
       radius = 12,  
   },  
   {   
       x2d = 9701,   
       y2d = 5051,  
       radius = 5,  
   },  
   {   
       x2d = 9701,   
       y2d = 5201,  
       radius = 5,  
   },  
   {   
       x2d = 9701,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 9731,   
       y2d = 5381,  
       radius = 35,  
   },  
   {   
       x2d = 9701,   
       y2d = 10301,  
       radius = 5,  
   },  
   {   
       x2d = 9731,   
       y2d = 10381,  
       radius = 35,  
   },  
   {   
       x2d = 9788,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 9788,   
       y2d = 488,  
       radius = 42,  
   },  
   {   
       x2d = 9788,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 9788,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 9788,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 9773,   
       y2d = 1923,  
       radius = 27,  
   },  
   {   
       x2d = 9788,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 9781,   
       y2d = 2431,  
       radius = 35,  
   },  
   {   
       x2d = 9758,   
       y2d = 2508,  
       radius = 12,  
   },  
   {   
       x2d = 9758,   
       y2d = 2658,  
       radius = 12,  
   },  
   {   
       x2d = 9758,   
       y2d = 2908,  
       radius = 12,  
   },  
   {   
       x2d = 9758,   
       y2d = 2958,  
       radius = 12,  
   },  
   {   
       x2d = 9751,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 9758,   
       y2d = 3058,  
       radius = 12,  
   },  
   {   
       x2d = 9773,   
       y2d = 3123,  
       radius = 27,  
   },  
   {   
       x2d = 9758,   
       y2d = 3608,  
       radius = 12,  
   },  
   {   
       x2d = 9758,   
       y2d = 4308,  
       radius = 12,  
   },  
   {   
       x2d = 9781,   
       y2d = 4381,  
       radius = 35,  
   },  
   {   
       x2d = 9758,   
       y2d = 4508,  
       radius = 12,  
   },  
   {   
       x2d = 9751,   
       y2d = 4851,  
       radius = 5,  
   },  
   {   
       x2d = 9766,   
       y2d = 10316,  
       radius = 20,  
   },  
   {   
       x2d = 9838,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 9838,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 9838,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 9838,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 9838,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 9838,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 9823,   
       y2d = 873,  
       radius = 27,  
   },  
   {   
       x2d = 9838,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 9838,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 9838,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 9838,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 9838,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 9838,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 9838,   
       y2d = 2088,  
       radius = 42,  
   },  
   {   
       x2d = 9838,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 9801,   
       y2d = 2551,  
       radius = 5,  
   },  
   {   
       x2d = 9801,   
       y2d = 2601,  
       radius = 5,  
   },  
   {   
       x2d = 9801,   
       y2d = 2651,  
       radius = 5,  
   },  
   {   
       x2d = 9801,   
       y2d = 2801,  
       radius = 5,  
   },  
   {   
       x2d = 9801,   
       y2d = 2901,  
       radius = 5,  
   },  
   {   
       x2d = 9801,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 9838,   
       y2d = 3088,  
       radius = 42,  
   },  
   {   
       x2d = 9808,   
       y2d = 3208,  
       radius = 12,  
   },  
   {   
       x2d = 9831,   
       y2d = 3281,  
       radius = 35,  
   },  
   {   
       x2d = 9831,   
       y2d = 3381,  
       radius = 35,  
   },  
   {   
       x2d = 9801,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 9838,   
       y2d = 3838,  
       radius = 42,  
   },  
   {   
       x2d = 9838,   
       y2d = 3938,  
       radius = 42,  
   },  
   {   
       x2d = 9823,   
       y2d = 4023,  
       radius = 27,  
   },  
   {   
       x2d = 9801,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 9801,   
       y2d = 4201,  
       radius = 5,  
   },  
   {   
       x2d = 9816,   
       y2d = 4316,  
       radius = 20,  
   },  
   {   
       x2d = 9808,   
       y2d = 4508,  
       radius = 12,  
   },  
   {   
       x2d = 9801,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 9831,   
       y2d = 10331,  
       radius = 35,  
   },  
   {   
       x2d = 9888,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 9888,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 9888,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 9888,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 9888,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 9888,   
       y2d = 1888,  
       radius = 42,  
   },  
   {   
       x2d = 9881,   
       y2d = 1981,  
       radius = 35,  
   },  
   {   
       x2d = 9888,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 9851,   
       y2d = 2501,  
       radius = 5,  
   },  
   {   
       x2d = 9873,   
       y2d = 2573,  
       radius = 27,  
   },  
   {   
       x2d = 9858,   
       y2d = 2708,  
       radius = 12,  
   },  
   {   
       x2d = 9851,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 9851,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 9858,   
       y2d = 4258,  
       radius = 12,  
   },  
   {   
       x2d = 9881,   
       y2d = 4481,  
       radius = 35,  
   },  
   {   
       x2d = 9851,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 9851,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 9938,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 9938,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 9938,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 9938,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 9938,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 9938,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 9938,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 9938,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 9938,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 9938,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 9938,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 9938,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 9938,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 9938,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 9938,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 9923,   
       y2d = 2473,  
       radius = 27,  
   },  
   {   
       x2d = 9916,   
       y2d = 2616,  
       radius = 20,  
   },  
   {   
       x2d = 9916,   
       y2d = 2666,  
       radius = 20,  
   },  
   {   
       x2d = 9901,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 9901,   
       y2d = 3301,  
       radius = 5,  
   },  
   {   
       x2d = 9931,   
       y2d = 3981,  
       radius = 35,  
   },  
   {   
       x2d = 9938,   
       y2d = 4088,  
       radius = 42,  
   },  
   {   
       x2d = 9938,   
       y2d = 4388,  
       radius = 42,  
   },  
   {   
       x2d = 9916,   
       y2d = 4566,  
       radius = 20,  
   },  
   {   
       x2d = 9901,   
       y2d = 5351,  
       radius = 5,  
   },  
   {   
       x2d = 9931,   
       y2d = 10331,  
       radius = 35,  
   },  
   {   
       x2d = 9988,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 9988,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 9988,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 9988,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 9988,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 9988,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 9951,   
       y2d = 1951,  
       radius = 5,  
   },  
   {   
       x2d = 9951,   
       y2d = 2001,  
       radius = 5,  
   },  
   {   
       x2d = 9988,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 9988,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 9966,   
       y2d = 2566,  
       radius = 20,  
   },  
   {   
       x2d = 9958,   
       y2d = 2608,  
       radius = 12,  
   },  
   {   
       x2d = 9958,   
       y2d = 2708,  
       radius = 12,  
   },  
   {   
       x2d = 9958,   
       y2d = 2758,  
       radius = 12,  
   },  
   {   
       x2d = 9951,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 9951,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 9951,   
       y2d = 3201,  
       radius = 5,  
   },  
   {   
       x2d = 9951,   
       y2d = 3251,  
       radius = 5,  
   },  
   {   
       x2d = 9951,   
       y2d = 3301,  
       radius = 5,  
   },  
   {   
       x2d = 9958,   
       y2d = 3858,  
       radius = 12,  
   },  
   {   
       x2d = 9951,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 9973,   
       y2d = 4173,  
       radius = 27,  
   },  
   {   
       x2d = 9951,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 9981,   
       y2d = 4531,  
       radius = 35,  
   },  
   {   
       x2d = 9958,   
       y2d = 4608,  
       radius = 12,  
   },  
   {   
       x2d = 9951,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 9951,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 9988,   
       y2d = 10288,  
       radius = 42,  
   },  
   {   
       x2d = 10038,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 10038,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 10038,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 10023,   
       y2d = 523,  
       radius = 27,  
   },  
   {   
       x2d = 10038,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 10038,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 10038,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 10038,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 10038,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 10038,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 10023,   
       y2d = 1623,  
       radius = 27,  
   },  
   {   
       x2d = 10038,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 10038,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 10038,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 10038,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 10038,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 10008,   
       y2d = 2658,  
       radius = 12,  
   },  
   {   
       x2d = 10008,   
       y2d = 2708,  
       radius = 12,  
   },  
   {   
       x2d = 10001,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 10008,   
       y2d = 2808,  
       radius = 12,  
   },  
   {   
       x2d = 10023,   
       y2d = 3223,  
       radius = 27,  
   },  
   {   
       x2d = 10001,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 10001,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 10001,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 10016,   
       y2d = 3966,  
       radius = 20,  
   },  
   {   
       x2d = 10008,   
       y2d = 4008,  
       radius = 12,  
   },  
   {   
       x2d = 10016,   
       y2d = 4116,  
       radius = 20,  
   },  
   {   
       x2d = 10008,   
       y2d = 4608,  
       radius = 12,  
   },  
   {   
       x2d = 10008,   
       y2d = 4758,  
       radius = 12,  
   },  
   {   
       x2d = 10001,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 10001,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 10001,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 10088,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 10073,   
       y2d = 423,  
       radius = 27,  
   },  
   {   
       x2d = 10088,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 10088,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 10088,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 10088,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 10088,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 10088,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 10073,   
       y2d = 2623,  
       radius = 27,  
   },  
   {   
       x2d = 10051,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 10051,   
       y2d = 2801,  
       radius = 5,  
   },  
   {   
       x2d = 10051,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 10058,   
       y2d = 2908,  
       radius = 12,  
   },  
   {   
       x2d = 10051,   
       y2d = 2951,  
       radius = 5,  
   },  
   {   
       x2d = 10051,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 10051,   
       y2d = 3101,  
       radius = 5,  
   },  
   {   
       x2d = 10088,   
       y2d = 3188,  
       radius = 42,  
   },  
   {   
       x2d = 10051,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 10051,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 10051,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 10058,   
       y2d = 4058,  
       radius = 12,  
   },  
   {   
       x2d = 10066,   
       y2d = 4166,  
       radius = 20,  
   },  
   {   
       x2d = 10073,   
       y2d = 4473,  
       radius = 27,  
   },  
   {   
       x2d = 10073,   
       y2d = 4573,  
       radius = 27,  
   },  
   {   
       x2d = 10058,   
       y2d = 4708,  
       radius = 12,  
   },  
   {   
       x2d = 10058,   
       y2d = 4758,  
       radius = 12,  
   },  
   {   
       x2d = 10051,   
       y2d = 5351,  
       radius = 5,  
   },  
   {   
       x2d = 10081,   
       y2d = 10231,  
       radius = 35,  
   },  
   {   
       x2d = 10051,   
       y2d = 10351,  
       radius = 5,  
   },  
   {   
       x2d = 10138,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 10138,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 10138,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 10138,   
       y2d = 488,  
       radius = 42,  
   },  
   {   
       x2d = 10138,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 10138,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 10138,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 10123,   
       y2d = 873,  
       radius = 27,  
   },  
   {   
       x2d = 10138,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 10138,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 10138,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 10138,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 10138,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 10138,   
       y2d = 1888,  
       radius = 42,  
   },  
   {   
       x2d = 10123,   
       y2d = 1973,  
       radius = 27,  
   },  
   {   
       x2d = 10138,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 10138,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 10108,   
       y2d = 2858,  
       radius = 12,  
   },  
   {   
       x2d = 10101,   
       y2d = 2901,  
       radius = 5,  
   },  
   {   
       x2d = 10123,   
       y2d = 2973,  
       radius = 27,  
   },  
   {   
       x2d = 10101,   
       y2d = 3051,  
       radius = 5,  
   },  
   {   
       x2d = 10101,   
       y2d = 3101,  
       radius = 5,  
   },  
   {   
       x2d = 10101,   
       y2d = 3301,  
       radius = 5,  
   },  
   {   
       x2d = 10101,   
       y2d = 3351,  
       radius = 5,  
   },  
   {   
       x2d = 10101,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 10101,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 10101,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 10101,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 10138,   
       y2d = 4138,  
       radius = 42,  
   },  
   {   
       x2d = 10108,   
       y2d = 4308,  
       radius = 12,  
   },  
   {   
       x2d = 10108,   
       y2d = 4358,  
       radius = 12,  
   },  
   {   
       x2d = 10116,   
       y2d = 4516,  
       radius = 20,  
   },  
   {   
       x2d = 10101,   
       y2d = 4651,  
       radius = 5,  
   },  
   {   
       x2d = 10101,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 10101,   
       y2d = 10351,  
       radius = 5,  
   },  
   {   
       x2d = 10188,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 10188,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 10181,   
       y2d = 1131,  
       radius = 35,  
   },  
   {   
       x2d = 10188,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 10188,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 10188,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 10188,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 10188,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 10173,   
       y2d = 2573,  
       radius = 27,  
   },  
   {   
       x2d = 10151,   
       y2d = 2801,  
       radius = 5,  
   },  
   {   
       x2d = 10151,   
       y2d = 3051,  
       radius = 5,  
   },  
   {   
       x2d = 10173,   
       y2d = 3123,  
       radius = 27,  
   },  
   {   
       x2d = 10188,   
       y2d = 3188,  
       radius = 42,  
   },  
   {   
       x2d = 10158,   
       y2d = 3308,  
       radius = 12,  
   },  
   {   
       x2d = 10151,   
       y2d = 3351,  
       radius = 5,  
   },  
   {   
       x2d = 10166,   
       y2d = 4016,  
       radius = 20,  
   },  
   {   
       x2d = 10173,   
       y2d = 4373,  
       radius = 27,  
   },  
   {   
       x2d = 10151,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 10166,   
       y2d = 4616,  
       radius = 20,  
   },  
   {   
       x2d = 10166,   
       y2d = 4666,  
       radius = 20,  
   },  
   {   
       x2d = 10151,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 10166,   
       y2d = 10166,  
       radius = 20,  
   },  
   {   
       x2d = 10166,   
       y2d = 10216,  
       radius = 20,  
   },  
   {   
       x2d = 10238,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 10238,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 10238,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 10238,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 10238,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 10238,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 10238,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 10238,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 10231,   
       y2d = 1231,  
       radius = 35,  
   },  
   {   
       x2d = 10238,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 10238,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 10238,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 10238,   
       y2d = 1888,  
       radius = 42,  
   },  
   {   
       x2d = 10238,   
       y2d = 2088,  
       radius = 42,  
   },  
   {   
       x2d = 10238,   
       y2d = 2188,  
       radius = 42,  
   },  
   {   
       x2d = 10238,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 10201,   
       y2d = 2701,  
       radius = 5,  
   },  
   {   
       x2d = 10201,   
       y2d = 2901,  
       radius = 5,  
   },  
   {   
       x2d = 10201,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 10201,   
       y2d = 3051,  
       radius = 5,  
   },  
   {   
       x2d = 10238,   
       y2d = 3288,  
       radius = 42,  
   },  
   {   
       x2d = 10201,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 10238,   
       y2d = 4088,  
       radius = 42,  
   },  
   {   
       x2d = 10208,   
       y2d = 4208,  
       radius = 12,  
   },  
   {   
       x2d = 10238,   
       y2d = 4438,  
       radius = 42,  
   },  
   {   
       x2d = 10223,   
       y2d = 4573,  
       radius = 27,  
   },  
   {   
       x2d = 10208,   
       y2d = 4658,  
       radius = 12,  
   },  
   {   
       x2d = 10223,   
       y2d = 4873,  
       radius = 27,  
   },  
   {   
       x2d = 10201,   
       y2d = 5501,  
       radius = 5,  
   },  
   {   
       x2d = 10208,   
       y2d = 10208,  
       radius = 12,  
   },  
   {   
       x2d = 10208,   
       y2d = 10258,  
       radius = 12,  
   },  
   {   
       x2d = 10288,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 10288,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 10288,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 10288,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 10288,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 10288,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 10273,   
       y2d = 2623,  
       radius = 27,  
   },  
   {   
       x2d = 10258,   
       y2d = 2708,  
       radius = 12,  
   },  
   {   
       x2d = 10251,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 10251,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 10288,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 10251,   
       y2d = 3401,  
       radius = 5,  
   },  
   {   
       x2d = 10251,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 10251,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 10281,   
       y2d = 4181,  
       radius = 35,  
   },  
   {   
       x2d = 10288,   
       y2d = 4338,  
       radius = 42,  
   },  
   {   
       x2d = 10288,   
       y2d = 4538,  
       radius = 42,  
   },  
   {   
       x2d = 10266,   
       y2d = 4666,  
       radius = 20,  
   },  
   {   
       x2d = 10251,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 10251,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 10266,   
       y2d = 10066,  
       radius = 20,  
   },  
   {   
       x2d = 10251,   
       y2d = 10151,  
       radius = 5,  
   },  
   {   
       x2d = 10251,   
       y2d = 10201,  
       radius = 5,  
   },  
   {   
       x2d = 10251,   
       y2d = 10251,  
       radius = 5,  
   },  
   {   
       x2d = 10251,   
       y2d = 10301,  
       radius = 5,  
   },  
   {   
       x2d = 10258,   
       y2d = 10358,  
       radius = 12,  
   },  
   {   
       x2d = 10338,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 10338,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 10338,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 10338,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 10338,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 10338,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 10338,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 10338,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 10338,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 10338,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 10338,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 10338,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 10338,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 10338,   
       y2d = 2088,  
       radius = 42,  
   },  
   {   
       x2d = 10338,   
       y2d = 2188,  
       radius = 42,  
   },  
   {   
       x2d = 10338,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 10323,   
       y2d = 2523,  
       radius = 27,  
   },  
   {   
       x2d = 10338,   
       y2d = 2588,  
       radius = 42,  
   },  
   {   
       x2d = 10323,   
       y2d = 2673,  
       radius = 27,  
   },  
   {   
       x2d = 10301,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 10301,   
       y2d = 2801,  
       radius = 5,  
   },  
   {   
       x2d = 10301,   
       y2d = 2951,  
       radius = 5,  
   },  
   {   
       x2d = 10301,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 10301,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 10308,   
       y2d = 3958,  
       radius = 12,  
   },  
   {   
       x2d = 10301,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 10316,   
       y2d = 4116,  
       radius = 20,  
   },  
   {   
       x2d = 10301,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 10301,   
       y2d = 4701,  
       radius = 5,  
   },  
   {   
       x2d = 10316,   
       y2d = 4866,  
       radius = 20,  
   },  
   {   
       x2d = 10308,   
       y2d = 4908,  
       radius = 12,  
   },  
   {   
       x2d = 10301,   
       y2d = 4951,  
       radius = 5,  
   },  
   {   
       x2d = 10301,   
       y2d = 9951,  
       radius = 5,  
   },  
   {   
       x2d = 10301,   
       y2d = 10101,  
       radius = 5,  
   },  
   {   
       x2d = 10388,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 10388,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 10388,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 10388,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 10388,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 10388,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 10388,   
       y2d = 2288,  
       radius = 42,  
   },  
   {   
       x2d = 10351,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 10373,   
       y2d = 2823,  
       radius = 27,  
   },  
   {   
       x2d = 10351,   
       y2d = 2901,  
       radius = 5,  
   },  
   {   
       x2d = 10351,   
       y2d = 2951,  
       radius = 5,  
   },  
   {   
       x2d = 10373,   
       y2d = 3023,  
       radius = 27,  
   },  
   {   
       x2d = 10366,   
       y2d = 3116,  
       radius = 20,  
   },  
   {   
       x2d = 10388,   
       y2d = 3288,  
       radius = 42,  
   },  
   {   
       x2d = 10351,   
       y2d = 3451,  
       radius = 5,  
   },  
   {   
       x2d = 10351,   
       y2d = 3851,  
       radius = 5,  
   },  
   {   
       x2d = 10351,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 10388,   
       y2d = 4038,  
       radius = 42,  
   },  
   {   
       x2d = 10366,   
       y2d = 4166,  
       radius = 20,  
   },  
   {   
       x2d = 10366,   
       y2d = 4366,  
       radius = 20,  
   },  
   {   
       x2d = 10366,   
       y2d = 4416,  
       radius = 20,  
   },  
   {   
       x2d = 10358,   
       y2d = 4458,  
       radius = 12,  
   },  
   {   
       x2d = 10381,   
       y2d = 4581,  
       radius = 35,  
   },  
   {   
       x2d = 10366,   
       y2d = 4666,  
       radius = 20,  
   },  
   {   
       x2d = 10351,   
       y2d = 4751,  
       radius = 5,  
   },  
   {   
       x2d = 10358,   
       y2d = 4858,  
       radius = 12,  
   },  
   {   
       x2d = 10351,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 10351,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 10438,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 10438,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 10438,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 10438,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 10438,   
       y2d = 488,  
       radius = 42,  
   },  
   {   
       x2d = 10438,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 10438,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 10438,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 10423,   
       y2d = 1223,  
       radius = 27,  
   },  
   {   
       x2d = 10438,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 10438,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 10438,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 10438,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 10438,   
       y2d = 2088,  
       radius = 42,  
   },  
   {   
       x2d = 10438,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 10431,   
       y2d = 2481,  
       radius = 35,  
   },  
   {   
       x2d = 10438,   
       y2d = 2588,  
       radius = 42,  
   },  
   {   
       x2d = 10431,   
       y2d = 2781,  
       radius = 35,  
   },  
   {   
       x2d = 10401,   
       y2d = 2901,  
       radius = 5,  
   },  
   {   
       x2d = 10401,   
       y2d = 2951,  
       radius = 5,  
   },  
   {   
       x2d = 10438,   
       y2d = 4138,  
       radius = 42,  
   },  
   {   
       x2d = 10423,   
       y2d = 4223,  
       radius = 27,  
   },  
   {   
       x2d = 10438,   
       y2d = 4388,  
       radius = 42,  
   },  
   {   
       x2d = 10438,   
       y2d = 4488,  
       radius = 42,  
   },  
   {   
       x2d = 10401,   
       y2d = 4751,  
       radius = 5,  
   },  
   {   
       x2d = 10431,   
       y2d = 4931,  
       radius = 35,  
   },  
   {   
       x2d = 10416,   
       y2d = 5066,  
       radius = 20,  
   },  
   {   
       x2d = 10401,   
       y2d = 5551,  
       radius = 5,  
   },  
   {   
       x2d = 10401,   
       y2d = 5651,  
       radius = 5,  
   },  
   {   
       x2d = 10416,   
       y2d = 5716,  
       radius = 20,  
   },  
   {   
       x2d = 10408,   
       y2d = 5808,  
       radius = 12,  
   },  
   {   
       x2d = 10401,   
       y2d = 5901,  
       radius = 5,  
   },  
   {   
       x2d = 10431,   
       y2d = 9931,  
       radius = 35,  
   },  
   {   
       x2d = 10401,   
       y2d = 10051,  
       radius = 5,  
   },  
   {   
       x2d = 10488,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 10488,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 10488,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 10488,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 10488,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 10488,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 10488,   
       y2d = 1888,  
       radius = 42,  
   },  
   {   
       x2d = 10488,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 10488,   
       y2d = 2188,  
       radius = 42,  
   },  
   {   
       x2d = 10488,   
       y2d = 2288,  
       radius = 42,  
   },  
   {   
       x2d = 10481,   
       y2d = 2931,  
       radius = 35,  
   },  
   {   
       x2d = 10451,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 10451,   
       y2d = 3051,  
       radius = 5,  
   },  
   {   
       x2d = 10488,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 10473,   
       y2d = 3323,  
       radius = 27,  
   },  
   {   
       x2d = 10451,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 10451,   
       y2d = 3851,  
       radius = 5,  
   },  
   {   
       x2d = 10488,   
       y2d = 4588,  
       radius = 42,  
   },  
   {   
       x2d = 10488,   
       y2d = 4688,  
       radius = 42,  
   },  
   {   
       x2d = 10458,   
       y2d = 4858,  
       radius = 12,  
   },  
   {   
       x2d = 10451,   
       y2d = 5001,  
       radius = 5,  
   },  
   {   
       x2d = 10451,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 10451,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 10451,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 10451,   
       y2d = 5901,  
       radius = 5,  
   },  
   {   
       x2d = 10451,   
       y2d = 5951,  
       radius = 5,  
   },  
   {   
       x2d = 10451,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 10451,   
       y2d = 10051,  
       radius = 5,  
   },  
   {   
       x2d = 10451,   
       y2d = 10151,  
       radius = 5,  
   },  
   {   
       x2d = 10451,   
       y2d = 10201,  
       radius = 5,  
   },  
   {   
       x2d = 10538,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 10538,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 10538,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 10538,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 10538,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 10538,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 10538,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 10538,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 10538,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 10538,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 10531,   
       y2d = 1781,  
       radius = 35,  
   },  
   {   
       x2d = 10538,   
       y2d = 2088,  
       radius = 42,  
   },  
   {   
       x2d = 10538,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 10538,   
       y2d = 2488,  
       radius = 42,  
   },  
   {   
       x2d = 10501,   
       y2d = 2701,  
       radius = 5,  
   },  
   {   
       x2d = 10516,   
       y2d = 3016,  
       radius = 20,  
   },  
   {   
       x2d = 10501,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 10531,   
       y2d = 3331,  
       radius = 35,  
   },  
   {   
       x2d = 10501,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 10508,   
       y2d = 3808,  
       radius = 12,  
   },  
   {   
       x2d = 10501,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 10508,   
       y2d = 4058,  
       radius = 12,  
   },  
   {   
       x2d = 10531,   
       y2d = 4131,  
       radius = 35,  
   },  
   {   
       x2d = 10501,   
       y2d = 4201,  
       radius = 5,  
   },  
   {   
       x2d = 10538,   
       y2d = 4438,  
       radius = 42,  
   },  
   {   
       x2d = 10523,   
       y2d = 4873,  
       radius = 27,  
   },  
   {   
       x2d = 10501,   
       y2d = 5751,  
       radius = 5,  
   },  
   {   
       x2d = 10501,   
       y2d = 5851,  
       radius = 5,  
   },  
   {   
       x2d = 10538,   
       y2d = 9938,  
       radius = 42,  
   },  
   {   
       x2d = 10501,   
       y2d = 10101,  
       radius = 5,  
   },  
   {   
       x2d = 10588,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 10588,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 10588,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 10588,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 10588,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 10588,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 10588,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 10588,   
       y2d = 1888,  
       radius = 42,  
   },  
   {   
       x2d = 10588,   
       y2d = 2188,  
       radius = 42,  
   },  
   {   
       x2d = 10588,   
       y2d = 2288,  
       radius = 42,  
   },  
   {   
       x2d = 10566,   
       y2d = 2666,  
       radius = 20,  
   },  
   {   
       x2d = 10551,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 10566,   
       y2d = 2916,  
       radius = 20,  
   },  
   {   
       x2d = 10551,   
       y2d = 3401,  
       radius = 5,  
   },  
   {   
       x2d = 10551,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 10551,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 10588,   
       y2d = 4288,  
       radius = 42,  
   },  
   {   
       x2d = 10588,   
       y2d = 4538,  
       radius = 42,  
   },  
   {   
       x2d = 10588,   
       y2d = 4638,  
       radius = 42,  
   },  
   {   
       x2d = 10558,   
       y2d = 4758,  
       radius = 12,  
   },  
   {   
       x2d = 10558,   
       y2d = 4958,  
       radius = 12,  
   },  
   {   
       x2d = 10551,   
       y2d = 5001,  
       radius = 5,  
   },  
   {   
       x2d = 10551,   
       y2d = 5751,  
       radius = 5,  
   },  
   {   
       x2d = 10566,   
       y2d = 6016,  
       radius = 20,  
   },  
   {   
       x2d = 10638,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 10638,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 10638,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 10638,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 10638,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 10638,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 10638,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 10638,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 10638,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 10638,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 10638,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 10638,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 10631,   
       y2d = 2481,  
       radius = 35,  
   },  
   {   
       x2d = 10601,   
       y2d = 2551,  
       radius = 5,  
   },  
   {   
       x2d = 10608,   
       y2d = 2658,  
       radius = 12,  
   },  
   {   
       x2d = 10601,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 10616,   
       y2d = 2966,  
       radius = 20,  
   },  
   {   
       x2d = 10616,   
       y2d = 3016,  
       radius = 20,  
   },  
   {   
       x2d = 10631,   
       y2d = 3231,  
       radius = 35,  
   },  
   {   
       x2d = 10616,   
       y2d = 3316,  
       radius = 20,  
   },  
   {   
       x2d = 10608,   
       y2d = 3408,  
       radius = 12,  
   },  
   {   
       x2d = 10601,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 10616,   
       y2d = 4066,  
       radius = 20,  
   },  
   {   
       x2d = 10608,   
       y2d = 4158,  
       radius = 12,  
   },  
   {   
       x2d = 10638,   
       y2d = 4388,  
       radius = 42,  
   },  
   {   
       x2d = 10638,   
       y2d = 4738,  
       radius = 42,  
   },  
   {   
       x2d = 10601,   
       y2d = 4851,  
       radius = 5,  
   },  
   {   
       x2d = 10601,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 10601,   
       y2d = 5501,  
       radius = 5,  
   },  
   {   
       x2d = 10623,   
       y2d = 5773,  
       radius = 27,  
   },  
   {   
       x2d = 10601,   
       y2d = 5851,  
       radius = 5,  
   },  
   {   
       x2d = 10616,   
       y2d = 5916,  
       radius = 20,  
   },  
   {   
       x2d = 10638,   
       y2d = 9888,  
       radius = 42,  
   },  
   {   
       x2d = 10688,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 10688,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 10688,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 10688,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 10688,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 10688,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 10688,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 10688,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 10688,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 10688,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 10688,   
       y2d = 2288,  
       radius = 42,  
   },  
   {   
       x2d = 10658,   
       y2d = 2608,  
       radius = 12,  
   },  
   {   
       x2d = 10651,   
       y2d = 2651,  
       radius = 5,  
   },  
   {   
       x2d = 10681,   
       y2d = 2781,  
       radius = 35,  
   },  
   {   
       x2d = 10681,   
       y2d = 3031,  
       radius = 35,  
   },  
   {   
       x2d = 10658,   
       y2d = 3158,  
       radius = 12,  
   },  
   {   
       x2d = 10666,   
       y2d = 3316,  
       radius = 20,  
   },  
   {   
       x2d = 10658,   
       y2d = 3358,  
       radius = 12,  
   },  
   {   
       x2d = 10688,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 10658,   
       y2d = 4008,  
       radius = 12,  
   },  
   {   
       x2d = 10651,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 10651,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 10681,   
       y2d = 4281,  
       radius = 35,  
   },  
   {   
       x2d = 10673,   
       y2d = 4473,  
       radius = 27,  
   },  
   {   
       x2d = 10666,   
       y2d = 4566,  
       radius = 20,  
   },  
   {   
       x2d = 10651,   
       y2d = 5101,  
       radius = 5,  
   },  
   {   
       x2d = 10658,   
       y2d = 5708,  
       radius = 12,  
   },  
   {   
       x2d = 10658,   
       y2d = 10058,  
       radius = 12,  
   },  
   {   
       x2d = 10651,   
       y2d = 10101,  
       radius = 5,  
   },  
   {   
       x2d = 10738,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 10738,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 10738,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 10738,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 10738,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 10738,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 10738,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 10738,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 10738,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 10738,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 10716,   
       y2d = 2416,  
       radius = 20,  
   },  
   {   
       x2d = 10723,   
       y2d = 2473,  
       radius = 27,  
   },  
   {   
       x2d = 10716,   
       y2d = 2566,  
       radius = 20,  
   },  
   {   
       x2d = 10738,   
       y2d = 2688,  
       radius = 42,  
   },  
   {   
       x2d = 10701,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 10701,   
       y2d = 2901,  
       radius = 5,  
   },  
   {   
       x2d = 10708,   
       y2d = 2958,  
       radius = 12,  
   },  
   {   
       x2d = 10708,   
       y2d = 3108,  
       radius = 12,  
   },  
   {   
       x2d = 10708,   
       y2d = 3158,  
       radius = 12,  
   },  
   {   
       x2d = 10731,   
       y2d = 3331,  
       radius = 35,  
   },  
   {   
       x2d = 10708,   
       y2d = 3558,  
       radius = 12,  
   },  
   {   
       x2d = 10708,   
       y2d = 3608,  
       radius = 12,  
   },  
   {   
       x2d = 10738,   
       y2d = 4238,  
       radius = 42,  
   },  
   {   
       x2d = 10723,   
       y2d = 4373,  
       radius = 27,  
   },  
   {   
       x2d = 10716,   
       y2d = 4516,  
       radius = 20,  
   },  
   {   
       x2d = 10723,   
       y2d = 4573,  
       radius = 27,  
   },  
   {   
       x2d = 10716,   
       y2d = 4716,  
       radius = 20,  
   },  
   {   
       x2d = 10716,   
       y2d = 4816,  
       radius = 20,  
   },  
   {   
       x2d = 10738,   
       y2d = 4938,  
       radius = 42,  
   },  
   {   
       x2d = 10701,   
       y2d = 5651,  
       radius = 5,  
   },  
   {   
       x2d = 10701,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 10731,   
       y2d = 5981,  
       radius = 35,  
   },  
   {   
       x2d = 10701,   
       y2d = 9801,  
       radius = 5,  
   },  
   {   
       x2d = 10723,   
       y2d = 9973,  
       radius = 27,  
   },  
   {   
       x2d = 10701,   
       y2d = 10051,  
       radius = 5,  
   },  
   {   
       x2d = 10788,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 10788,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 10788,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 10788,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 10773,   
       y2d = 1473,  
       radius = 27,  
   },  
   {   
       x2d = 10788,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 10788,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 10788,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 10788,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 10788,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 10788,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 10788,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 10788,   
       y2d = 2288,  
       radius = 42,  
   },  
   {   
       x2d = 10788,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 10751,   
       y2d = 2801,  
       radius = 5,  
   },  
   {   
       x2d = 10788,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 10758,   
       y2d = 3258,  
       radius = 12,  
   },  
   {   
       x2d = 10751,   
       y2d = 3501,  
       radius = 5,  
   },  
   {   
       x2d = 10751,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 10781,   
       y2d = 4031,  
       radius = 35,  
   },  
   {   
       x2d = 10773,   
       y2d = 4123,  
       radius = 27,  
   },  
   {   
       x2d = 10751,   
       y2d = 4651,  
       radius = 5,  
   },  
   {   
       x2d = 10781,   
       y2d = 4731,  
       radius = 35,  
   },  
   {   
       x2d = 10751,   
       y2d = 5501,  
       radius = 5,  
   },  
   {   
       x2d = 10758,   
       y2d = 5858,  
       radius = 12,  
   },  
   {   
       x2d = 10751,   
       y2d = 6051,  
       radius = 5,  
   },  
   {   
       x2d = 10751,   
       y2d = 9751,  
       radius = 5,  
   },  
   {   
       x2d = 10751,   
       y2d = 9801,  
       radius = 5,  
   },  
   {   
       x2d = 10838,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 10838,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 10838,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 10838,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 10838,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 10838,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 10838,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 10831,   
       y2d = 731,  
       radius = 35,  
   },  
   {   
       x2d = 10838,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 10838,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 10838,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 10801,   
       y2d = 2501,  
       radius = 5,  
   },  
   {   
       x2d = 10831,   
       y2d = 2581,  
       radius = 35,  
   },  
   {   
       x2d = 10816,   
       y2d = 2666,  
       radius = 20,  
   },  
   {   
       x2d = 10801,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 10816,   
       y2d = 2916,  
       radius = 20,  
   },  
   {   
       x2d = 10808,   
       y2d = 3158,  
       radius = 12,  
   },  
   {   
       x2d = 10808,   
       y2d = 3208,  
       radius = 12,  
   },  
   {   
       x2d = 10816,   
       y2d = 3266,  
       radius = 20,  
   },  
   {   
       x2d = 10838,   
       y2d = 3388,  
       radius = 42,  
   },  
   {   
       x2d = 10816,   
       y2d = 3516,  
       radius = 20,  
   },  
   {   
       x2d = 10808,   
       y2d = 3558,  
       radius = 12,  
   },  
   {   
       x2d = 10801,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 10801,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 10808,   
       y2d = 4308,  
       radius = 12,  
   },  
   {   
       x2d = 10831,   
       y2d = 4431,  
       radius = 35,  
   },  
   {   
       x2d = 10838,   
       y2d = 4538,  
       radius = 42,  
   },  
   {   
       x2d = 10838,   
       y2d = 4638,  
       radius = 42,  
   },  
   {   
       x2d = 10808,   
       y2d = 4808,  
       radius = 12,  
   },  
   {   
       x2d = 10816,   
       y2d = 4966,  
       radius = 20,  
   },  
   {   
       x2d = 10808,   
       y2d = 5008,  
       radius = 12,  
   },  
   {   
       x2d = 10801,   
       y2d = 5051,  
       radius = 5,  
   },  
   {   
       x2d = 10801,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 10801,   
       y2d = 5901,  
       radius = 5,  
   },  
   {   
       x2d = 10808,   
       y2d = 5958,  
       radius = 12,  
   },  
   {   
       x2d = 10801,   
       y2d = 6051,  
       radius = 5,  
   },  
   {   
       x2d = 10801,   
       y2d = 9701,  
       radius = 5,  
   },  
   {   
       x2d = 10801,   
       y2d = 9751,  
       radius = 5,  
   },  
   {   
       x2d = 10801,   
       y2d = 9951,  
       radius = 5,  
   },  
   {   
       x2d = 10801,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 10801,   
       y2d = 10051,  
       radius = 5,  
   },  
   {   
       x2d = 10801,   
       y2d = 10201,  
       radius = 5,  
   },  
   {   
       x2d = 10888,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 10888,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 10888,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 10888,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 10888,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 10888,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 10888,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 10888,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 10888,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 10888,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 10888,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 10881,   
       y2d = 2431,  
       radius = 35,  
   },  
   {   
       x2d = 10851,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 10881,   
       y2d = 2981,  
       radius = 35,  
   },  
   {   
       x2d = 10881,   
       y2d = 3081,  
       radius = 35,  
   },  
   {   
       x2d = 10851,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 10858,   
       y2d = 3208,  
       radius = 12,  
   },  
   {   
       x2d = 10851,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 10851,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 10851,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 10873,   
       y2d = 4373,  
       radius = 27,  
   },  
   {   
       x2d = 10888,   
       y2d = 4788,  
       radius = 42,  
   },  
   {   
       x2d = 10858,   
       y2d = 4958,  
       radius = 12,  
   },  
   {   
       x2d = 10866,   
       y2d = 5066,  
       radius = 20,  
   },  
   {   
       x2d = 10858,   
       y2d = 5608,  
       radius = 12,  
   },  
   {   
       x2d = 10851,   
       y2d = 5901,  
       radius = 5,  
   },  
   {   
       x2d = 10858,   
       y2d = 9658,  
       radius = 12,  
   },  
   {   
       x2d = 10858,   
       y2d = 9758,  
       radius = 12,  
   },  
   {   
       x2d = 10851,   
       y2d = 9951,  
       radius = 5,  
   },  
   {   
       x2d = 10938,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 10938,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 10938,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 10938,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 10938,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 10938,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 10938,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 10938,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 10938,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 10938,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 10923,   
       y2d = 1373,  
       radius = 27,  
   },  
   {   
       x2d = 10938,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 10938,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 10938,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 10908,   
       y2d = 2708,  
       radius = 12,  
   },  
   {   
       x2d = 10901,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 10901,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 10938,   
       y2d = 3288,  
       radius = 42,  
   },  
   {   
       x2d = 10908,   
       y2d = 3658,  
       radius = 12,  
   },  
   {   
       x2d = 10901,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 10908,   
       y2d = 4058,  
       radius = 12,  
   },  
   {   
       x2d = 10908,   
       y2d = 4158,  
       radius = 12,  
   },  
   {   
       x2d = 10908,   
       y2d = 4208,  
       radius = 12,  
   },  
   {   
       x2d = 10931,   
       y2d = 4281,  
       radius = 35,  
   },  
   {   
       x2d = 10916,   
       y2d = 4416,  
       radius = 20,  
   },  
   {   
       x2d = 10901,   
       y2d = 4701,  
       radius = 5,  
   },  
   {   
       x2d = 10908,   
       y2d = 5058,  
       radius = 12,  
   },  
   {   
       x2d = 10901,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 10908,   
       y2d = 5558,  
       radius = 12,  
   },  
   {   
       x2d = 10908,   
       y2d = 5608,  
       radius = 12,  
   },  
   {   
       x2d = 10931,   
       y2d = 5831,  
       radius = 35,  
   },  
   {   
       x2d = 10901,   
       y2d = 5951,  
       radius = 5,  
   },  
   {   
       x2d = 10901,   
       y2d = 6001,  
       radius = 5,  
   },  
   {   
       x2d = 10916,   
       y2d = 9616,  
       radius = 20,  
   },  
   {   
       x2d = 10901,   
       y2d = 9701,  
       radius = 5,  
   },  
   {   
       x2d = 10901,   
       y2d = 9751,  
       radius = 5,  
   },  
   {   
       x2d = 10908,   
       y2d = 10058,  
       radius = 12,  
   },  
   {   
       x2d = 10901,   
       y2d = 10201,  
       radius = 5,  
   },  
   {   
       x2d = 10988,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 10988,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 10981,   
       y2d = 1031,  
       radius = 35,  
   },  
   {   
       x2d = 10988,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 10988,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 10988,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 10988,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 10988,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 10973,   
       y2d = 2223,  
       radius = 27,  
   },  
   {   
       x2d = 10988,   
       y2d = 2288,  
       radius = 42,  
   },  
   {   
       x2d = 10966,   
       y2d = 2416,  
       radius = 20,  
   },  
   {   
       x2d = 10988,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 10966,   
       y2d = 2816,  
       radius = 20,  
   },  
   {   
       x2d = 10951,   
       y2d = 2951,  
       radius = 5,  
   },  
   {   
       x2d = 10951,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 10951,   
       y2d = 3051,  
       radius = 5,  
   },  
   {   
       x2d = 10951,   
       y2d = 3101,  
       radius = 5,  
   },  
   {   
       x2d = 10951,   
       y2d = 3451,  
       radius = 5,  
   },  
   {   
       x2d = 10958,   
       y2d = 3508,  
       radius = 12,  
   },  
   {   
       x2d = 10966,   
       y2d = 3566,  
       radius = 20,  
   },  
   {   
       x2d = 10951,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 10951,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 10966,   
       y2d = 4216,  
       radius = 20,  
   },  
   {   
       x2d = 10951,   
       y2d = 4351,  
       radius = 5,  
   },  
   {   
       x2d = 10951,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 10973,   
       y2d = 4623,  
       radius = 27,  
   },  
   {   
       x2d = 10988,   
       y2d = 4788,  
       radius = 42,  
   },  
   {   
       x2d = 10973,   
       y2d = 5123,  
       radius = 27,  
   },  
   {   
       x2d = 10966,   
       y2d = 5616,  
       radius = 20,  
   },  
   {   
       x2d = 10951,   
       y2d = 5901,  
       radius = 5,  
   },  
   {   
       x2d = 10958,   
       y2d = 5958,  
       radius = 12,  
   },  
   {   
       x2d = 10951,   
       y2d = 6001,  
       radius = 5,  
   },  
   {   
       x2d = 10951,   
       y2d = 6051,  
       radius = 5,  
   },  
   {   
       x2d = 10951,   
       y2d = 10301,  
       radius = 5,  
   },  
   {   
       x2d = 11038,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 11038,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 11038,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 11038,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 11038,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 11038,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 11038,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 11038,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 11038,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 11038,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 11038,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 11038,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 11038,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 11001,   
       y2d = 2451,  
       radius = 5,  
   },  
   {   
       x2d = 11023,   
       y2d = 2523,  
       radius = 27,  
   },  
   {   
       x2d = 11023,   
       y2d = 2773,  
       radius = 27,  
   },  
   {   
       x2d = 11001,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 11001,   
       y2d = 2901,  
       radius = 5,  
   },  
   {   
       x2d = 11023,   
       y2d = 3073,  
       radius = 27,  
   },  
   {   
       x2d = 11038,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 11001,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 11023,   
       y2d = 4123,  
       radius = 27,  
   },  
   {   
       x2d = 11001,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 11008,   
       y2d = 4458,  
       radius = 12,  
   },  
   {   
       x2d = 11016,   
       y2d = 4516,  
       radius = 20,  
   },  
   {   
       x2d = 11008,   
       y2d = 4558,  
       radius = 12,  
   },  
   {   
       x2d = 11031,   
       y2d = 4881,  
       radius = 35,  
   },  
   {   
       x2d = 11001,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 11001,   
       y2d = 5651,  
       radius = 5,  
   },  
   {   
       x2d = 11001,   
       y2d = 9651,  
       radius = 5,  
   },  
   {   
       x2d = 11001,   
       y2d = 9951,  
       radius = 5,  
   },  
   {   
       x2d = 11001,   
       y2d = 10101,  
       radius = 5,  
   },  
   {   
       x2d = 11001,   
       y2d = 10151,  
       radius = 5,  
   },  
   {   
       x2d = 11023,   
       y2d = 10223,  
       radius = 27,  
   },  
   {   
       x2d = 11038,   
       y2d = 10288,  
       radius = 42,  
   },  
   {   
       x2d = 11088,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 11088,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 11088,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 11088,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 11088,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 11088,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 11088,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 11088,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 11088,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 11088,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 11051,   
       y2d = 2451,  
       radius = 5,  
   },  
   {   
       x2d = 11081,   
       y2d = 2581,  
       radius = 35,  
   },  
   {   
       x2d = 11066,   
       y2d = 2666,  
       radius = 20,  
   },  
   {   
       x2d = 11066,   
       y2d = 2716,  
       radius = 20,  
   },  
   {   
       x2d = 11073,   
       y2d = 2873,  
       radius = 27,  
   },  
   {   
       x2d = 11058,   
       y2d = 2958,  
       radius = 12,  
   },  
   {   
       x2d = 11051,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 11088,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 11051,   
       y2d = 3551,  
       radius = 5,  
   },  
   {   
       x2d = 11051,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 11051,   
       y2d = 4351,  
       radius = 5,  
   },  
   {   
       x2d = 11051,   
       y2d = 4401,  
       radius = 5,  
   },  
   {   
       x2d = 11088,   
       y2d = 4488,  
       radius = 42,  
   },  
   {   
       x2d = 11088,   
       y2d = 4588,  
       radius = 42,  
   },  
   {   
       x2d = 11073,   
       y2d = 4673,  
       radius = 27,  
   },  
   {   
       x2d = 11066,   
       y2d = 4766,  
       radius = 20,  
   },  
   {   
       x2d = 11051,   
       y2d = 5101,  
       radius = 5,  
   },  
   {   
       x2d = 11058,   
       y2d = 5258,  
       radius = 12,  
   },  
   {   
       x2d = 11058,   
       y2d = 5558,  
       radius = 12,  
   },  
   {   
       x2d = 11051,   
       y2d = 5601,  
       radius = 5,  
   },  
   {   
       x2d = 11051,   
       y2d = 6151,  
       radius = 5,  
   },  
   {   
       x2d = 11051,   
       y2d = 9501,  
       radius = 5,  
   },  
   {   
       x2d = 11051,   
       y2d = 9951,  
       radius = 5,  
   },  
   {   
       x2d = 11058,   
       y2d = 10108,  
       radius = 12,  
   },  
   {   
       x2d = 11058,   
       y2d = 10158,  
       radius = 12,  
   },  
   {   
       x2d = 11088,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 11138,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 11138,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 11138,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 11138,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 11138,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 11138,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 11138,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 11138,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 11138,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 11138,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 11138,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 11138,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 11138,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 11116,   
       y2d = 2466,  
       radius = 20,  
   },  
   {   
       x2d = 11108,   
       y2d = 2508,  
       radius = 12,  
   },  
   {   
       x2d = 11108,   
       y2d = 2808,  
       radius = 12,  
   },  
   {   
       x2d = 11101,   
       y2d = 2951,  
       radius = 5,  
   },  
   {   
       x2d = 11101,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 11138,   
       y2d = 3188,  
       radius = 42,  
   },  
   {   
       x2d = 11138,   
       y2d = 3288,  
       radius = 42,  
   },  
   {   
       x2d = 11138,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 11101,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 11101,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 11101,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 11116,   
       y2d = 4366,  
       radius = 20,  
   },  
   {   
       x2d = 11138,   
       y2d = 4688,  
       radius = 42,  
   },  
   {   
       x2d = 11123,   
       y2d = 4873,  
       radius = 27,  
   },  
   {   
       x2d = 11138,   
       y2d = 4938,  
       radius = 42,  
   },  
   {   
       x2d = 11101,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 11101,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 11101,   
       y2d = 5601,  
       radius = 5,  
   },  
   {   
       x2d = 11116,   
       y2d = 6066,  
       radius = 20,  
   },  
   {   
       x2d = 11108,   
       y2d = 6108,  
       radius = 12,  
   },  
   {   
       x2d = 11101,   
       y2d = 6151,  
       radius = 5,  
   },  
   {   
       x2d = 11116,   
       y2d = 9466,  
       radius = 20,  
   },  
   {   
       x2d = 11101,   
       y2d = 9551,  
       radius = 5,  
   },  
   {   
       x2d = 11101,   
       y2d = 9801,  
       radius = 5,  
   },  
   {   
       x2d = 11101,   
       y2d = 9901,  
       radius = 5,  
   },  
   {   
       x2d = 11101,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 11108,   
       y2d = 10058,  
       radius = 12,  
   },  
   {   
       x2d = 11101,   
       y2d = 10101,  
       radius = 5,  
   },  
   {   
       x2d = 11108,   
       y2d = 10158,  
       radius = 12,  
   },  
   {   
       x2d = 11138,   
       y2d = 10238,  
       radius = 42,  
   },  
   {   
       x2d = 11188,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 11188,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 11188,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 11188,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 11188,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 11188,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 11188,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 11188,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 11188,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 11173,   
       y2d = 2373,  
       radius = 27,  
   },  
   {   
       x2d = 11151,   
       y2d = 2501,  
       radius = 5,  
   },  
   {   
       x2d = 11188,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 11173,   
       y2d = 2773,  
       radius = 27,  
   },  
   {   
       x2d = 11188,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 11151,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 11166,   
       y2d = 4266,  
       radius = 20,  
   },  
   {   
       x2d = 11188,   
       y2d = 4488,  
       radius = 42,  
   },  
   {   
       x2d = 11158,   
       y2d = 5608,  
       radius = 12,  
   },  
   {   
       x2d = 11151,   
       y2d = 5651,  
       radius = 5,  
   },  
   {   
       x2d = 11151,   
       y2d = 5851,  
       radius = 5,  
   },  
   {   
       x2d = 11173,   
       y2d = 5923,  
       radius = 27,  
   },  
   {   
       x2d = 11158,   
       y2d = 6008,  
       radius = 12,  
   },  
   {   
       x2d = 11151,   
       y2d = 6101,  
       radius = 5,  
   },  
   {   
       x2d = 11151,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 11151,   
       y2d = 6251,  
       radius = 5,  
   },  
   {   
       x2d = 11151,   
       y2d = 9401,  
       radius = 5,  
   },  
   {   
       x2d = 11151,   
       y2d = 9651,  
       radius = 5,  
   },  
   {   
       x2d = 11151,   
       y2d = 9851,  
       radius = 5,  
   },  
   {   
       x2d = 11166,   
       y2d = 9916,  
       radius = 20,  
   },  
   {   
       x2d = 11188,   
       y2d = 9988,  
       radius = 42,  
   },  
   {   
       x2d = 11151,   
       y2d = 10101,  
       radius = 5,  
   },  
   {   
       x2d = 11188,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 11238,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 11238,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 11238,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 11238,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 11238,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 11238,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 11238,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 11238,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 11238,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 11238,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 11238,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 11238,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 11238,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 11223,   
       y2d = 2323,  
       radius = 27,  
   },  
   {   
       x2d = 11238,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 11201,   
       y2d = 2551,  
       radius = 5,  
   },  
   {   
       x2d = 11238,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 11201,   
       y2d = 2951,  
       radius = 5,  
   },  
   {   
       x2d = 11238,   
       y2d = 3288,  
       radius = 42,  
   },  
   {   
       x2d = 11201,   
       y2d = 3401,  
       radius = 5,  
   },  
   {   
       x2d = 11201,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 11201,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 11201,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 11201,   
       y2d = 4201,  
       radius = 5,  
   },  
   {   
       x2d = 11216,   
       y2d = 4266,  
       radius = 20,  
   },  
   {   
       x2d = 11216,   
       y2d = 4316,  
       radius = 20,  
   },  
   {   
       x2d = 11201,   
       y2d = 4601,  
       radius = 5,  
   },  
   {   
       x2d = 11201,   
       y2d = 4751,  
       radius = 5,  
   },  
   {   
       x2d = 11231,   
       y2d = 4981,  
       radius = 35,  
   },  
   {   
       x2d = 11201,   
       y2d = 5201,  
       radius = 5,  
   },  
   {   
       x2d = 11201,   
       y2d = 6001,  
       radius = 5,  
   },  
   {   
       x2d = 11201,   
       y2d = 6151,  
       radius = 5,  
   },  
   {   
       x2d = 11201,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 11201,   
       y2d = 6501,  
       radius = 5,  
   },  
   {   
       x2d = 11201,   
       y2d = 9451,  
       radius = 5,  
   },  
   {   
       x2d = 11201,   
       y2d = 9851,  
       radius = 5,  
   },  
   {   
       x2d = 11216,   
       y2d = 10116,  
       radius = 20,  
   },  
   {   
       x2d = 11238,   
       y2d = 10188,  
       radius = 42,  
   },  
   {   
       x2d = 11288,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 11288,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 11288,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 11288,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 11288,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 11273,   
       y2d = 1823,  
       radius = 27,  
   },  
   {   
       x2d = 11288,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 11273,   
       y2d = 2223,  
       radius = 27,  
   },  
   {   
       x2d = 11288,   
       y2d = 2288,  
       radius = 42,  
   },  
   {   
       x2d = 11281,   
       y2d = 2531,  
       radius = 35,  
   },  
   {   
       x2d = 11273,   
       y2d = 2823,  
       radius = 27,  
   },  
   {   
       x2d = 11258,   
       y2d = 2958,  
       radius = 12,  
   },  
   {   
       x2d = 11251,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 11281,   
       y2d = 3381,  
       radius = 35,  
   },  
   {   
       x2d = 11281,   
       y2d = 3531,  
       radius = 35,  
   },  
   {   
       x2d = 11258,   
       y2d = 3908,  
       radius = 12,  
   },  
   {   
       x2d = 11251,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 11258,   
       y2d = 4208,  
       radius = 12,  
   },  
   {   
       x2d = 11251,   
       y2d = 4351,  
       radius = 5,  
   },  
   {   
       x2d = 11258,   
       y2d = 4558,  
       radius = 12,  
   },  
   {   
       x2d = 11258,   
       y2d = 4808,  
       radius = 12,  
   },  
   {   
       x2d = 11281,   
       y2d = 4931,  
       radius = 35,  
   },  
   {   
       x2d = 11251,   
       y2d = 5051,  
       radius = 5,  
   },  
   {   
       x2d = 11251,   
       y2d = 5551,  
       radius = 5,  
   },  
   {   
       x2d = 11251,   
       y2d = 5651,  
       radius = 5,  
   },  
   {   
       x2d = 11266,   
       y2d = 5966,  
       radius = 20,  
   },  
   {   
       x2d = 11251,   
       y2d = 6151,  
       radius = 5,  
   },  
   {   
       x2d = 11251,   
       y2d = 6251,  
       radius = 5,  
   },  
   {   
       x2d = 11251,   
       y2d = 9551,  
       radius = 5,  
   },  
   {   
       x2d = 11251,   
       y2d = 9751,  
       radius = 5,  
   },  
   {   
       x2d = 11251,   
       y2d = 9801,  
       radius = 5,  
   },  
   {   
       x2d = 11251,   
       y2d = 9851,  
       radius = 5,  
   },  
   {   
       x2d = 11258,   
       y2d = 9908,  
       radius = 12,  
   },  
   {   
       x2d = 11288,   
       y2d = 10038,  
       radius = 42,  
   },  
   {   
       x2d = 11281,   
       y2d = 10331,  
       radius = 35,  
   },  
   {   
       x2d = 11338,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 11338,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 11338,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 11338,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 11338,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 11338,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 11338,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 11338,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 11338,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 11338,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 11338,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 11323,   
       y2d = 1873,  
       radius = 27,  
   },  
   {   
       x2d = 11338,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 11338,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 11338,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 11338,   
       y2d = 2488,  
       radius = 42,  
   },  
   {   
       x2d = 11338,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 11331,   
       y2d = 2731,  
       radius = 35,  
   },  
   {   
       x2d = 11323,   
       y2d = 3023,  
       radius = 27,  
   },  
   {   
       x2d = 11323,   
       y2d = 3323,  
       radius = 27,  
   },  
   {   
       x2d = 11316,   
       y2d = 3466,  
       radius = 20,  
   },  
   {   
       x2d = 11301,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 11301,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 11301,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 11308,   
       y2d = 4158,  
       radius = 12,  
   },  
   {   
       x2d = 11301,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 11301,   
       y2d = 4801,  
       radius = 5,  
   },  
   {   
       x2d = 11308,   
       y2d = 5008,  
       radius = 12,  
   },  
   {   
       x2d = 11308,   
       y2d = 5058,  
       radius = 12,  
   },  
   {   
       x2d = 11316,   
       y2d = 6166,  
       radius = 20,  
   },  
   {   
       x2d = 11301,   
       y2d = 6251,  
       radius = 5,  
   },  
   {   
       x2d = 11301,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 11301,   
       y2d = 6601,  
       radius = 5,  
   },  
   {   
       x2d = 11301,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 11323,   
       y2d = 6773,  
       radius = 27,  
   },  
   {   
       x2d = 11301,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 11301,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 11301,   
       y2d = 9401,  
       radius = 5,  
   },  
   {   
       x2d = 11301,   
       y2d = 9551,  
       radius = 5,  
   },  
   {   
       x2d = 11308,   
       y2d = 9708,  
       radius = 12,  
   },  
   {   
       x2d = 11301,   
       y2d = 9801,  
       radius = 5,  
   },  
   {   
       x2d = 11338,   
       y2d = 9938,  
       radius = 42,  
   },  
   {   
       x2d = 11338,   
       y2d = 10288,  
       radius = 42,  
   },  
   {   
       x2d = 11388,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 11388,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 11388,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 11388,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 11388,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 11388,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 11388,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 11388,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 11388,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 11358,   
       y2d = 2908,  
       radius = 12,  
   },  
   {   
       x2d = 11366,   
       y2d = 2966,  
       radius = 20,  
   },  
   {   
       x2d = 11358,   
       y2d = 3108,  
       radius = 12,  
   },  
   {   
       x2d = 11388,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 11366,   
       y2d = 3466,  
       radius = 20,  
   },  
   {   
       x2d = 11351,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 11351,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 11351,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 11351,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 11351,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 11358,   
       y2d = 4658,  
       radius = 12,  
   },  
   {   
       x2d = 11358,   
       y2d = 4708,  
       radius = 12,  
   },  
   {   
       x2d = 11381,   
       y2d = 4831,  
       radius = 35,  
   },  
   {   
       x2d = 11388,   
       y2d = 4938,  
       radius = 42,  
   },  
   {   
       x2d = 11373,   
       y2d = 5023,  
       radius = 27,  
   },  
   {   
       x2d = 11351,   
       y2d = 5101,  
       radius = 5,  
   },  
   {   
       x2d = 11351,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 11358,   
       y2d = 5558,  
       radius = 12,  
   },  
   {   
       x2d = 11366,   
       y2d = 5816,  
       radius = 20,  
   },  
   {   
       x2d = 11358,   
       y2d = 6158,  
       radius = 12,  
   },  
   {   
       x2d = 11358,   
       y2d = 6308,  
       radius = 12,  
   },  
   {   
       x2d = 11351,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 11388,   
       y2d = 6438,  
       radius = 42,  
   },  
   {   
       x2d = 11351,   
       y2d = 6701,  
       radius = 5,  
   },  
   {   
       x2d = 11358,   
       y2d = 6858,  
       radius = 12,  
   },  
   {   
       x2d = 11351,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 11351,   
       y2d = 9201,  
       radius = 5,  
   },  
   {   
       x2d = 11351,   
       y2d = 9301,  
       radius = 5,  
   },  
   {   
       x2d = 11351,   
       y2d = 9651,  
       radius = 5,  
   },  
   {   
       x2d = 11351,   
       y2d = 9701,  
       radius = 5,  
   },  
   {   
       x2d = 11388,   
       y2d = 9788,  
       radius = 42,  
   },  
   {   
       x2d = 11388,   
       y2d = 10038,  
       radius = 42,  
   },  
   {   
       x2d = 11388,   
       y2d = 10138,  
       radius = 42,  
   },  
   {   
       x2d = 11438,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 11438,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 11438,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 11438,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 11423,   
       y2d = 523,  
       radius = 27,  
   },  
   {   
       x2d = 11438,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 11438,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 11438,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 11438,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 11438,   
       y2d = 1888,  
       radius = 42,  
   },  
   {   
       x2d = 11438,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 11438,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 11438,   
       y2d = 2488,  
       radius = 42,  
   },  
   {   
       x2d = 11438,   
       y2d = 2788,  
       radius = 42,  
   },  
   {   
       x2d = 11408,   
       y2d = 3058,  
       radius = 12,  
   },  
   {   
       x2d = 11408,   
       y2d = 3158,  
       radius = 12,  
   },  
   {   
       x2d = 11423,   
       y2d = 3423,  
       radius = 27,  
   },  
   {   
       x2d = 11431,   
       y2d = 3481,  
       radius = 35,  
   },  
   {   
       x2d = 11401,   
       y2d = 3551,  
       radius = 5,  
   },  
   {   
       x2d = 11416,   
       y2d = 3866,  
       radius = 20,  
   },  
   {   
       x2d = 11408,   
       y2d = 4008,  
       radius = 12,  
   },  
   {   
       x2d = 11401,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 11401,   
       y2d = 4201,  
       radius = 5,  
   },  
   {   
       x2d = 11401,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 11423,   
       y2d = 4573,  
       radius = 27,  
   },  
   {   
       x2d = 11408,   
       y2d = 4658,  
       radius = 12,  
   },  
   {   
       x2d = 11408,   
       y2d = 4708,  
       radius = 12,  
   },  
   {   
       x2d = 11401,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 11416,   
       y2d = 5466,  
       radius = 20,  
   },  
   {   
       x2d = 11416,   
       y2d = 5516,  
       radius = 20,  
   },  
   {   
       x2d = 11408,   
       y2d = 5558,  
       radius = 12,  
   },  
   {   
       x2d = 11401,   
       y2d = 6001,  
       radius = 5,  
   },  
   {   
       x2d = 11408,   
       y2d = 6258,  
       radius = 12,  
   },  
   {   
       x2d = 11401,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 11401,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 11401,   
       y2d = 6601,  
       radius = 5,  
   },  
   {   
       x2d = 11408,   
       y2d = 6658,  
       radius = 12,  
   },  
   {   
       x2d = 11416,   
       y2d = 6766,  
       radius = 20,  
   },  
   {   
       x2d = 11408,   
       y2d = 6808,  
       radius = 12,  
   },  
   {   
       x2d = 11401,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 11408,   
       y2d = 9208,  
       radius = 12,  
   },  
   {   
       x2d = 11401,   
       y2d = 9301,  
       radius = 5,  
   },  
   {   
       x2d = 11401,   
       y2d = 9451,  
       radius = 5,  
   },  
   {   
       x2d = 11438,   
       y2d = 9938,  
       radius = 42,  
   },  
   {   
       x2d = 11438,   
       y2d = 10238,  
       radius = 42,  
   },  
   {   
       x2d = 11408,   
       y2d = 10358,  
       radius = 12,  
   },  
   {   
       x2d = 11488,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 11488,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 11488,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 11488,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 11488,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 11488,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 11488,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 11488,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 11488,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 11488,   
       y2d = 2088,  
       radius = 42,  
   },  
   {   
       x2d = 11488,   
       y2d = 2188,  
       radius = 42,  
   },  
   {   
       x2d = 11473,   
       y2d = 2573,  
       radius = 27,  
   },  
   {   
       x2d = 11488,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 11488,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 11488,   
       y2d = 3188,  
       radius = 42,  
   },  
   {   
       x2d = 11481,   
       y2d = 3431,  
       radius = 35,  
   },  
   {   
       x2d = 11458,   
       y2d = 3558,  
       radius = 12,  
   },  
   {   
       x2d = 11451,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 11451,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 11466,   
       y2d = 4016,  
       radius = 20,  
   },  
   {   
       x2d = 11451,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 11473,   
       y2d = 4623,  
       radius = 27,  
   },  
   {   
       x2d = 11466,   
       y2d = 4716,  
       radius = 20,  
   },  
   {   
       x2d = 11458,   
       y2d = 4758,  
       radius = 12,  
   },  
   {   
       x2d = 11466,   
       y2d = 4916,  
       radius = 20,  
   },  
   {   
       x2d = 11458,   
       y2d = 5008,  
       radius = 12,  
   },  
   {   
       x2d = 11466,   
       y2d = 5566,  
       radius = 20,  
   },  
   {   
       x2d = 11451,   
       y2d = 6151,  
       radius = 5,  
   },  
   {   
       x2d = 11451,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 11466,   
       y2d = 6416,  
       radius = 20,  
   },  
   {   
       x2d = 11451,   
       y2d = 6501,  
       radius = 5,  
   },  
   {   
       x2d = 11473,   
       y2d = 6573,  
       radius = 27,  
   },  
   {   
       x2d = 11451,   
       y2d = 6701,  
       radius = 5,  
   },  
   {   
       x2d = 11488,   
       y2d = 6938,  
       radius = 42,  
   },  
   {   
       x2d = 11473,   
       y2d = 7023,  
       radius = 27,  
   },  
   {   
       x2d = 11458,   
       y2d = 7108,  
       radius = 12,  
   },  
   {   
       x2d = 11451,   
       y2d = 9301,  
       radius = 5,  
   },  
   {   
       x2d = 11451,   
       y2d = 9351,  
       radius = 5,  
   },  
   {   
       x2d = 11458,   
       y2d = 9408,  
       radius = 12,  
   },  
   {   
       x2d = 11458,   
       y2d = 9458,  
       radius = 12,  
   },  
   {   
       x2d = 11451,   
       y2d = 9551,  
       radius = 5,  
   },  
   {   
       x2d = 11451,   
       y2d = 9651,  
       radius = 5,  
   },  
   {   
       x2d = 11458,   
       y2d = 9708,  
       radius = 12,  
   },  
   {   
       x2d = 11473,   
       y2d = 10023,  
       radius = 27,  
   },  
   {   
       x2d = 11488,   
       y2d = 10088,  
       radius = 42,  
   },  
   {   
       x2d = 11538,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 11538,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 11538,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 11538,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 11538,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 11538,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 11538,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 11538,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 11538,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 11538,   
       y2d = 1888,  
       radius = 42,  
   },  
   {   
       x2d = 11538,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 11538,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 11538,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 11531,   
       y2d = 2731,  
       radius = 35,  
   },  
   {   
       x2d = 11501,   
       y2d = 3301,  
       radius = 5,  
   },  
   {   
       x2d = 11508,   
       y2d = 3508,  
       radius = 12,  
   },  
   {   
       x2d = 11516,   
       y2d = 3566,  
       radius = 20,  
   },  
   {   
       x2d = 11508,   
       y2d = 3608,  
       radius = 12,  
   },  
   {   
       x2d = 11516,   
       y2d = 3916,  
       radius = 20,  
   },  
   {   
       x2d = 11516,   
       y2d = 4016,  
       radius = 20,  
   },  
   {   
       x2d = 11501,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 11516,   
       y2d = 4466,  
       radius = 20,  
   },  
   {   
       x2d = 11523,   
       y2d = 4523,  
       radius = 27,  
   },  
   {   
       x2d = 11538,   
       y2d = 4638,  
       radius = 42,  
   },  
   {   
       x2d = 11516,   
       y2d = 4766,  
       radius = 20,  
   },  
   {   
       x2d = 11508,   
       y2d = 4858,  
       radius = 12,  
   },  
   {   
       x2d = 11508,   
       y2d = 4908,  
       radius = 12,  
   },  
   {   
       x2d = 11531,   
       y2d = 4981,  
       radius = 35,  
   },  
   {   
       x2d = 11523,   
       y2d = 5523,  
       radius = 27,  
   },  
   {   
       x2d = 11501,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 11538,   
       y2d = 6438,  
       radius = 42,  
   },  
   {   
       x2d = 11508,   
       y2d = 7158,  
       radius = 12,  
   },  
   {   
       x2d = 11508,   
       y2d = 7308,  
       radius = 12,  
   },  
   {   
       x2d = 11501,   
       y2d = 7401,  
       radius = 5,  
   },  
   {   
       x2d = 11501,   
       y2d = 8951,  
       radius = 5,  
   },  
   {   
       x2d = 11501,   
       y2d = 9351,  
       radius = 5,  
   },  
   {   
       x2d = 11501,   
       y2d = 9451,  
       radius = 5,  
   },  
   {   
       x2d = 11501,   
       y2d = 9751,  
       radius = 5,  
   },  
   {   
       x2d = 11501,   
       y2d = 9801,  
       radius = 5,  
   },  
   {   
       x2d = 11501,   
       y2d = 9851,  
       radius = 5,  
   },  
   {   
       x2d = 11538,   
       y2d = 10188,  
       radius = 42,  
   },  
   {   
       x2d = 11501,   
       y2d = 10351,  
       radius = 5,  
   },  
   {   
       x2d = 11588,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 11588,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 11588,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 11588,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 11573,   
       y2d = 1373,  
       radius = 27,  
   },  
   {   
       x2d = 11581,   
       y2d = 1431,  
       radius = 35,  
   },  
   {   
       x2d = 11588,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 11588,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 11588,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 11588,   
       y2d = 2088,  
       radius = 42,  
   },  
   {   
       x2d = 11566,   
       y2d = 2216,  
       radius = 20,  
   },  
   {   
       x2d = 11588,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 11551,   
       y2d = 2801,  
       radius = 5,  
   },  
   {   
       x2d = 11551,   
       y2d = 2901,  
       radius = 5,  
   },  
   {   
       x2d = 11566,   
       y2d = 3016,  
       radius = 20,  
   },  
   {   
       x2d = 11566,   
       y2d = 3166,  
       radius = 20,  
   },  
   {   
       x2d = 11551,   
       y2d = 3251,  
       radius = 5,  
   },  
   {   
       x2d = 11558,   
       y2d = 3308,  
       radius = 12,  
   },  
   {   
       x2d = 11551,   
       y2d = 3351,  
       radius = 5,  
   },  
   {   
       x2d = 11551,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 11558,   
       y2d = 3808,  
       radius = 12,  
   },  
   {   
       x2d = 11551,   
       y2d = 3851,  
       radius = 5,  
   },  
   {   
       x2d = 11551,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 11558,   
       y2d = 4308,  
       radius = 12,  
   },  
   {   
       x2d = 11551,   
       y2d = 4401,  
       radius = 5,  
   },  
   {   
       x2d = 11573,   
       y2d = 4773,  
       radius = 27,  
   },  
   {   
       x2d = 11581,   
       y2d = 5081,  
       radius = 35,  
   },  
   {   
       x2d = 11573,   
       y2d = 5573,  
       radius = 27,  
   },  
   {   
       x2d = 11558,   
       y2d = 5658,  
       radius = 12,  
   },  
   {   
       x2d = 11558,   
       y2d = 6258,  
       radius = 12,  
   },  
   {   
       x2d = 11551,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 11558,   
       y2d = 6558,  
       radius = 12,  
   },  
   {   
       x2d = 11551,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 11558,   
       y2d = 6858,  
       radius = 12,  
   },  
   {   
       x2d = 11566,   
       y2d = 7016,  
       radius = 20,  
   },  
   {   
       x2d = 11551,   
       y2d = 7151,  
       radius = 5,  
   },  
   {   
       x2d = 11551,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 11558,   
       y2d = 7358,  
       radius = 12,  
   },  
   {   
       x2d = 11551,   
       y2d = 7401,  
       radius = 5,  
   },  
   {   
       x2d = 11551,   
       y2d = 9201,  
       radius = 5,  
   },  
   {   
       x2d = 11551,   
       y2d = 9251,  
       radius = 5,  
   },  
   {   
       x2d = 11558,   
       y2d = 9458,  
       radius = 12,  
   },  
   {   
       x2d = 11551,   
       y2d = 9501,  
       radius = 5,  
   },  
   {   
       x2d = 11566,   
       y2d = 9566,  
       radius = 20,  
   },  
   {   
       x2d = 11558,   
       y2d = 9608,  
       radius = 12,  
   },  
   {   
       x2d = 11551,   
       y2d = 9851,  
       radius = 5,  
   },  
   {   
       x2d = 11581,   
       y2d = 9931,  
       radius = 35,  
   },  
   {   
       x2d = 11558,   
       y2d = 10008,  
       radius = 12,  
   },  
   {   
       x2d = 11588,   
       y2d = 10088,  
       radius = 42,  
   },  
   {   
       x2d = 11588,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 11638,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 11638,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 11638,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 11638,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 11638,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 11638,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 11638,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 11638,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 11638,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 11638,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 11638,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 11601,   
       y2d = 2251,  
       radius = 5,  
   },  
   {   
       x2d = 11616,   
       y2d = 2316,  
       radius = 20,  
   },  
   {   
       x2d = 11623,   
       y2d = 2373,  
       radius = 27,  
   },  
   {   
       x2d = 11601,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 11608,   
       y2d = 3108,  
       radius = 12,  
   },  
   {   
       x2d = 11601,   
       y2d = 3251,  
       radius = 5,  
   },  
   {   
       x2d = 11608,   
       y2d = 3358,  
       radius = 12,  
   },  
   {   
       x2d = 11601,   
       y2d = 3401,  
       radius = 5,  
   },  
   {   
       x2d = 11601,   
       y2d = 3451,  
       radius = 5,  
   },  
   {   
       x2d = 11638,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 11601,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 11631,   
       y2d = 4281,  
       radius = 35,  
   },  
   {   
       x2d = 11638,   
       y2d = 4388,  
       radius = 42,  
   },  
   {   
       x2d = 11638,   
       y2d = 4488,  
       radius = 42,  
   },  
   {   
       x2d = 11623,   
       y2d = 4573,  
       radius = 27,  
   },  
   {   
       x2d = 11616,   
       y2d = 4716,  
       radius = 20,  
   },  
   {   
       x2d = 11638,   
       y2d = 4788,  
       radius = 42,  
   },  
   {   
       x2d = 11623,   
       y2d = 4873,  
       radius = 27,  
   },  
   {   
       x2d = 11601,   
       y2d = 4951,  
       radius = 5,  
   },  
   {   
       x2d = 11623,   
       y2d = 5473,  
       radius = 27,  
   },  
   {   
       x2d = 11631,   
       y2d = 5531,  
       radius = 35,  
   },  
   {   
       x2d = 11601,   
       y2d = 6101,  
       radius = 5,  
   },  
   {   
       x2d = 11601,   
       y2d = 6251,  
       radius = 5,  
   },  
   {   
       x2d = 11616,   
       y2d = 6466,  
       radius = 20,  
   },  
   {   
       x2d = 11616,   
       y2d = 6516,  
       radius = 20,  
   },  
   {   
       x2d = 11601,   
       y2d = 6601,  
       radius = 5,  
   },  
   {   
       x2d = 11601,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 11608,   
       y2d = 7008,  
       radius = 12,  
   },  
   {   
       x2d = 11601,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 11601,   
       y2d = 7301,  
       radius = 5,  
   },  
   {   
       x2d = 11608,   
       y2d = 7408,  
       radius = 12,  
   },  
   {   
       x2d = 11601,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 11601,   
       y2d = 8751,  
       radius = 5,  
   },  
   {   
       x2d = 11608,   
       y2d = 9258,  
       radius = 12,  
   },  
   {   
       x2d = 11601,   
       y2d = 9451,  
       radius = 5,  
   },  
   {   
       x2d = 11608,   
       y2d = 9608,  
       radius = 12,  
   },  
   {   
       x2d = 11688,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 11688,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 11688,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 11688,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 11688,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 11688,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 11688,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 11688,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 11688,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 11673,   
       y2d = 2123,  
       radius = 27,  
   },  
   {   
       x2d = 11666,   
       y2d = 2216,  
       radius = 20,  
   },  
   {   
       x2d = 11673,   
       y2d = 2673,  
       radius = 27,  
   },  
   {   
       x2d = 11651,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 11688,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 11673,   
       y2d = 2973,  
       radius = 27,  
   },  
   {   
       x2d = 11651,   
       y2d = 3101,  
       radius = 5,  
   },  
   {   
       x2d = 11651,   
       y2d = 3251,  
       radius = 5,  
   },  
   {   
       x2d = 11666,   
       y2d = 3316,  
       radius = 20,  
   },  
   {   
       x2d = 11658,   
       y2d = 3358,  
       radius = 12,  
   },  
   {   
       x2d = 11651,   
       y2d = 3401,  
       radius = 5,  
   },  
   {   
       x2d = 11651,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 11673,   
       y2d = 4673,  
       radius = 27,  
   },  
   {   
       x2d = 11681,   
       y2d = 4881,  
       radius = 35,  
   },  
   {   
       x2d = 11658,   
       y2d = 4958,  
       radius = 12,  
   },  
   {   
       x2d = 11658,   
       y2d = 5008,  
       radius = 12,  
   },  
   {   
       x2d = 11651,   
       y2d = 5351,  
       radius = 5,  
   },  
   {   
       x2d = 11651,   
       y2d = 5951,  
       radius = 5,  
   },  
   {   
       x2d = 11651,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 11658,   
       y2d = 6458,  
       radius = 12,  
   },  
   {   
       x2d = 11651,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 11666,   
       y2d = 6866,  
       radius = 20,  
   },  
   {   
       x2d = 11673,   
       y2d = 6923,  
       radius = 27,  
   },  
   {   
       x2d = 11658,   
       y2d = 7058,  
       radius = 12,  
   },  
   {   
       x2d = 11651,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 11651,   
       y2d = 7501,  
       radius = 5,  
   },  
   {   
       x2d = 11651,   
       y2d = 9051,  
       radius = 5,  
   },  
   {   
       x2d = 11658,   
       y2d = 9258,  
       radius = 12,  
   },  
   {   
       x2d = 11651,   
       y2d = 9451,  
       radius = 5,  
   },  
   {   
       x2d = 11651,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 11673,   
       y2d = 10073,  
       radius = 27,  
   },  
   {   
       x2d = 11688,   
       y2d = 10138,  
       radius = 42,  
   },  
   {   
       x2d = 11658,   
       y2d = 10258,  
       radius = 12,  
   },  
   {   
       x2d = 11673,   
       y2d = 10323,  
       radius = 27,  
   },  
   {   
       x2d = 11738,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 11738,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 11738,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 11738,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 11738,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 11738,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 11738,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 11738,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 11738,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 11738,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 11738,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 11738,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 11731,   
       y2d = 2281,  
       radius = 35,  
   },  
   {   
       x2d = 11708,   
       y2d = 3058,  
       radius = 12,  
   },  
   {   
       x2d = 11701,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 11701,   
       y2d = 3351,  
       radius = 5,  
   },  
   {   
       x2d = 11716,   
       y2d = 3416,  
       radius = 20,  
   },  
   {   
       x2d = 11701,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 11731,   
       y2d = 4281,  
       radius = 35,  
   },  
   {   
       x2d = 11716,   
       y2d = 4416,  
       radius = 20,  
   },  
   {   
       x2d = 11738,   
       y2d = 4588,  
       radius = 42,  
   },  
   {   
       x2d = 11731,   
       y2d = 4731,  
       radius = 35,  
   },  
   {   
       x2d = 11716,   
       y2d = 4816,  
       radius = 20,  
   },  
   {   
       x2d = 11701,   
       y2d = 4951,  
       radius = 5,  
   },  
   {   
       x2d = 11701,   
       y2d = 5001,  
       radius = 5,  
   },  
   {   
       x2d = 11716,   
       y2d = 5066,  
       radius = 20,  
   },  
   {   
       x2d = 11708,   
       y2d = 5458,  
       radius = 12,  
   },  
   {   
       x2d = 11723,   
       y2d = 5523,  
       radius = 27,  
   },  
   {   
       x2d = 11701,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 11701,   
       y2d = 6601,  
       radius = 5,  
   },  
   {   
       x2d = 11701,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 11708,   
       y2d = 6708,  
       radius = 12,  
   },  
   {   
       x2d = 11708,   
       y2d = 7008,  
       radius = 12,  
   },  
   {   
       x2d = 11708,   
       y2d = 7058,  
       radius = 12,  
   },  
   {   
       x2d = 11701,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 11701,   
       y2d = 7501,  
       radius = 5,  
   },  
   {   
       x2d = 11701,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 11701,   
       y2d = 8851,  
       radius = 5,  
   },  
   {   
       x2d = 11701,   
       y2d = 9001,  
       radius = 5,  
   },  
   {   
       x2d = 11716,   
       y2d = 9666,  
       radius = 20,  
   },  
   {   
       x2d = 11723,   
       y2d = 9723,  
       radius = 27,  
   },  
   {   
       x2d = 11701,   
       y2d = 10251,  
       radius = 5,  
   },  
   {   
       x2d = 11731,   
       y2d = 10331,  
       radius = 35,  
   },  
   {   
       x2d = 11788,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 11788,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 11788,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 11788,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 11788,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 11788,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 11788,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 11788,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 11788,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 11773,   
       y2d = 2223,  
       radius = 27,  
   },  
   {   
       x2d = 11766,   
       y2d = 2366,  
       radius = 20,  
   },  
   {   
       x2d = 11758,   
       y2d = 2408,  
       radius = 12,  
   },  
   {   
       x2d = 11766,   
       y2d = 2466,  
       radius = 20,  
   },  
   {   
       x2d = 11751,   
       y2d = 2651,  
       radius = 5,  
   },  
   {   
       x2d = 11751,   
       y2d = 2701,  
       radius = 5,  
   },  
   {   
       x2d = 11751,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 11766,   
       y2d = 2816,  
       radius = 20,  
   },  
   {   
       x2d = 11781,   
       y2d = 3031,  
       radius = 35,  
   },  
   {   
       x2d = 11751,   
       y2d = 3251,  
       radius = 5,  
   },  
   {   
       x2d = 11751,   
       y2d = 3301,  
       radius = 5,  
   },  
   {   
       x2d = 11751,   
       y2d = 3451,  
       radius = 5,  
   },  
   {   
       x2d = 11758,   
       y2d = 3508,  
       radius = 12,  
   },  
   {   
       x2d = 11788,   
       y2d = 4888,  
       radius = 42,  
   },  
   {   
       x2d = 11766,   
       y2d = 5016,  
       radius = 20,  
   },  
   {   
       x2d = 11758,   
       y2d = 5058,  
       radius = 12,  
   },  
   {   
       x2d = 11751,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 11751,   
       y2d = 6401,  
       radius = 5,  
   },  
   {   
       x2d = 11751,   
       y2d = 6451,  
       radius = 5,  
   },  
   {   
       x2d = 11751,   
       y2d = 6501,  
       radius = 5,  
   },  
   {   
       x2d = 11751,   
       y2d = 6801,  
       radius = 5,  
   },  
   {   
       x2d = 11758,   
       y2d = 6958,  
       radius = 12,  
   },  
   {   
       x2d = 11766,   
       y2d = 7016,  
       radius = 20,  
   },  
   {   
       x2d = 11758,   
       y2d = 7158,  
       radius = 12,  
   },  
   {   
       x2d = 11751,   
       y2d = 7401,  
       radius = 5,  
   },  
   {   
       x2d = 11751,   
       y2d = 7501,  
       radius = 5,  
   },  
   {   
       x2d = 11751,   
       y2d = 7551,  
       radius = 5,  
   },  
   {   
       x2d = 11751,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 11773,   
       y2d = 7673,  
       radius = 27,  
   },  
   {   
       x2d = 11751,   
       y2d = 7801,  
       radius = 5,  
   },  
   {   
       x2d = 11751,   
       y2d = 8901,  
       radius = 5,  
   },  
   {   
       x2d = 11766,   
       y2d = 9266,  
       radius = 20,  
   },  
   {   
       x2d = 11751,   
       y2d = 9351,  
       radius = 5,  
   },  
   {   
       x2d = 11758,   
       y2d = 9658,  
       radius = 12,  
   },  
   {   
       x2d = 11838,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 11838,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 11838,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 11838,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 11838,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 11838,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 11838,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 11838,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 11838,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 11838,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 11838,   
       y2d = 1888,  
       radius = 42,  
   },  
   {   
       x2d = 11838,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 11838,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 11816,   
       y2d = 2466,  
       radius = 20,  
   },  
   {   
       x2d = 11831,   
       y2d = 2581,  
       radius = 35,  
   },  
   {   
       x2d = 11838,   
       y2d = 2688,  
       radius = 42,  
   },  
   {   
       x2d = 11801,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 11801,   
       y2d = 2951,  
       radius = 5,  
   },  
   {   
       x2d = 11808,   
       y2d = 3108,  
       radius = 12,  
   },  
   {   
       x2d = 11816,   
       y2d = 3166,  
       radius = 20,  
   },  
   {   
       x2d = 11801,   
       y2d = 3251,  
       radius = 5,  
   },  
   {   
       x2d = 11801,   
       y2d = 3351,  
       radius = 5,  
   },  
   {   
       x2d = 11808,   
       y2d = 3458,  
       radius = 12,  
   },  
   {   
       x2d = 11801,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 11801,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 11801,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 11808,   
       y2d = 4408,  
       radius = 12,  
   },  
   {   
       x2d = 11808,   
       y2d = 4658,  
       radius = 12,  
   },  
   {   
       x2d = 11808,   
       y2d = 5008,  
       radius = 12,  
   },  
   {   
       x2d = 11816,   
       y2d = 5166,  
       radius = 20,  
   },  
   {   
       x2d = 11816,   
       y2d = 5516,  
       radius = 20,  
   },  
   {   
       x2d = 11823,   
       y2d = 5723,  
       radius = 27,  
   },  
   {   
       x2d = 11801,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 11801,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 11808,   
       y2d = 6758,  
       radius = 12,  
   },  
   {   
       x2d = 11816,   
       y2d = 7116,  
       radius = 20,  
   },  
   {   
       x2d = 11808,   
       y2d = 7258,  
       radius = 12,  
   },  
   {   
       x2d = 11816,   
       y2d = 7316,  
       radius = 20,  
   },  
   {   
       x2d = 11801,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 11808,   
       y2d = 7758,  
       radius = 12,  
   },  
   {   
       x2d = 11801,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 11816,   
       y2d = 7966,  
       radius = 20,  
   },  
   {   
       x2d = 11801,   
       y2d = 8051,  
       radius = 5,  
   },  
   {   
       x2d = 11801,   
       y2d = 8451,  
       radius = 5,  
   },  
   {   
       x2d = 11801,   
       y2d = 8601,  
       radius = 5,  
   },  
   {   
       x2d = 11801,   
       y2d = 8901,  
       radius = 5,  
   },  
   {   
       x2d = 11801,   
       y2d = 9051,  
       radius = 5,  
   },  
   {   
       x2d = 11801,   
       y2d = 9301,  
       radius = 5,  
   },  
   {   
       x2d = 11801,   
       y2d = 9351,  
       radius = 5,  
   },  
   {   
       x2d = 11801,   
       y2d = 10051,  
       radius = 5,  
   },  
   {   
       x2d = 11801,   
       y2d = 10351,  
       radius = 5,  
   },  
   {   
       x2d = 11888,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 11873,   
       y2d = 623,  
       radius = 27,  
   },  
   {   
       x2d = 11888,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 11888,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 11888,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 11888,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 11888,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 11888,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 11888,   
       y2d = 2088,  
       radius = 42,  
   },  
   {   
       x2d = 11888,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 11888,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 11851,   
       y2d = 2801,  
       radius = 5,  
   },  
   {   
       x2d = 11851,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 11851,   
       y2d = 3101,  
       radius = 5,  
   },  
   {   
       x2d = 11851,   
       y2d = 3201,  
       radius = 5,  
   },  
   {   
       x2d = 11858,   
       y2d = 3458,  
       radius = 12,  
   },  
   {   
       x2d = 11851,   
       y2d = 3501,  
       radius = 5,  
   },  
   {   
       x2d = 11851,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 11851,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 11858,   
       y2d = 4358,  
       radius = 12,  
   },  
   {   
       x2d = 11851,   
       y2d = 4401,  
       radius = 5,  
   },  
   {   
       x2d = 11858,   
       y2d = 4508,  
       radius = 12,  
   },  
   {   
       x2d = 11858,   
       y2d = 4758,  
       radius = 12,  
   },  
   {   
       x2d = 11851,   
       y2d = 4801,  
       radius = 5,  
   },  
   {   
       x2d = 11866,   
       y2d = 4916,  
       radius = 20,  
   },  
   {   
       x2d = 11888,   
       y2d = 5088,  
       radius = 42,  
   },  
   {   
       x2d = 11851,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 11851,   
       y2d = 6251,  
       radius = 5,  
   },  
   {   
       x2d = 11858,   
       y2d = 6308,  
       radius = 12,  
   },  
   {   
       x2d = 11858,   
       y2d = 6358,  
       radius = 12,  
   },  
   {   
       x2d = 11851,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 11866,   
       y2d = 7066,  
       radius = 20,  
   },  
   {   
       x2d = 11858,   
       y2d = 7108,  
       radius = 12,  
   },  
   {   
       x2d = 11851,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 11851,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 11851,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 11851,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 11858,   
       y2d = 7658,  
       radius = 12,  
   },  
   {   
       x2d = 11851,   
       y2d = 7851,  
       radius = 5,  
   },  
   {   
       x2d = 11858,   
       y2d = 8058,  
       radius = 12,  
   },  
   {   
       x2d = 11873,   
       y2d = 8123,  
       radius = 27,  
   },  
   {   
       x2d = 11858,   
       y2d = 8208,  
       radius = 12,  
   },  
   {   
       x2d = 11851,   
       y2d = 8851,  
       radius = 5,  
   },  
   {   
       x2d = 11851,   
       y2d = 9051,  
       radius = 5,  
   },  
   {   
       x2d = 11851,   
       y2d = 9101,  
       radius = 5,  
   },  
   {   
       x2d = 11858,   
       y2d = 9408,  
       radius = 12,  
   },  
   {   
       x2d = 11851,   
       y2d = 10251,  
       radius = 5,  
   },  
   {   
       x2d = 11938,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 11938,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 11938,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 11938,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 11931,   
       y2d = 531,  
       radius = 35,  
   },  
   {   
       x2d = 11938,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 11938,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 11938,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 11931,   
       y2d = 1081,  
       radius = 35,  
   },  
   {   
       x2d = 11938,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 11938,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 11938,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 11938,   
       y2d = 2188,  
       radius = 42,  
   },  
   {   
       x2d = 11938,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 11938,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 11931,   
       y2d = 2731,  
       radius = 35,  
   },  
   {   
       x2d = 11901,   
       y2d = 2801,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 2951,  
       radius = 5,  
   },  
   {   
       x2d = 11908,   
       y2d = 3058,  
       radius = 12,  
   },  
   {   
       x2d = 11901,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 3401,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 3451,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 11908,   
       y2d = 4308,  
       radius = 12,  
   },  
   {   
       x2d = 11901,   
       y2d = 4351,  
       radius = 5,  
   },  
   {   
       x2d = 11916,   
       y2d = 4466,  
       radius = 20,  
   },  
   {   
       x2d = 11938,   
       y2d = 4538,  
       radius = 42,  
   },  
   {   
       x2d = 11916,   
       y2d = 4666,  
       radius = 20,  
   },  
   {   
       x2d = 11916,   
       y2d = 4766,  
       radius = 20,  
   },  
   {   
       x2d = 11938,   
       y2d = 4888,  
       radius = 42,  
   },  
   {   
       x2d = 11938,   
       y2d = 4988,  
       radius = 42,  
   },  
   {   
       x2d = 11901,   
       y2d = 5351,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 5501,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 5551,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 5951,  
       radius = 5,  
   },  
   {   
       x2d = 11908,   
       y2d = 6108,  
       radius = 12,  
   },  
   {   
       x2d = 11901,   
       y2d = 6501,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 11938,   
       y2d = 7238,  
       radius = 42,  
   },  
   {   
       x2d = 11901,   
       y2d = 7751,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 7851,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 8001,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 8051,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 8201,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 8451,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 8801,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 9101,  
       radius = 5,  
   },  
   {   
       x2d = 11908,   
       y2d = 9458,  
       radius = 12,  
   },  
   {   
       x2d = 11901,   
       y2d = 10051,  
       radius = 5,  
   },  
   {   
       x2d = 11901,   
       y2d = 10101,  
       radius = 5,  
   },  
   {   
       x2d = 11988,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 11988,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 11988,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 11988,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 11988,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 11988,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 11988,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 11966,   
       y2d = 2516,  
       radius = 20,  
   },  
   {   
       x2d = 11951,   
       y2d = 2801,  
       radius = 5,  
   },  
   {   
       x2d = 11951,   
       y2d = 2951,  
       radius = 5,  
   },  
   {   
       x2d = 11951,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 11973,   
       y2d = 3073,  
       radius = 27,  
   },  
   {   
       x2d = 11951,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 11951,   
       y2d = 3301,  
       radius = 5,  
   },  
   {   
       x2d = 11951,   
       y2d = 3351,  
       radius = 5,  
   },  
   {   
       x2d = 11951,   
       y2d = 3451,  
       radius = 5,  
   },  
   {   
       x2d = 11951,   
       y2d = 3501,  
       radius = 5,  
   },  
   {   
       x2d = 11951,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 11958,   
       y2d = 4308,  
       radius = 12,  
   },  
   {   
       x2d = 11988,   
       y2d = 4688,  
       radius = 42,  
   },  
   {   
       x2d = 11988,   
       y2d = 4788,  
       radius = 42,  
   },  
   {   
       x2d = 11958,   
       y2d = 5258,  
       radius = 12,  
   },  
   {   
       x2d = 11958,   
       y2d = 6308,  
       radius = 12,  
   },  
   {   
       x2d = 11951,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 11958,   
       y2d = 6808,  
       radius = 12,  
   },  
   {   
       x2d = 11951,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 11966,   
       y2d = 7116,  
       radius = 20,  
   },  
   {   
       x2d = 11958,   
       y2d = 7608,  
       radius = 12,  
   },  
   {   
       x2d = 11951,   
       y2d = 7701,  
       radius = 5,  
   },  
   {   
       x2d = 11958,   
       y2d = 8008,  
       radius = 12,  
   },  
   {   
       x2d = 11951,   
       y2d = 8101,  
       radius = 5,  
   },  
   {   
       x2d = 11951,   
       y2d = 8151,  
       radius = 5,  
   },  
   {   
       x2d = 11958,   
       y2d = 8608,  
       radius = 12,  
   },  
   {   
       x2d = 11951,   
       y2d = 8701,  
       radius = 5,  
   },  
   {   
       x2d = 11951,   
       y2d = 9101,  
       radius = 5,  
   },  
   {   
       x2d = 11951,   
       y2d = 9151,  
       radius = 5,  
   },  
   {   
       x2d = 11951,   
       y2d = 9251,  
       radius = 5,  
   },  
   {   
       x2d = 11951,   
       y2d = 9301,  
       radius = 5,  
   },  
   {   
       x2d = 11966,   
       y2d = 9516,  
       radius = 20,  
   },  
   {   
       x2d = 11951,   
       y2d = 10051,  
       radius = 5,  
   },  
   {   
       x2d = 11951,   
       y2d = 10151,  
       radius = 5,  
   },  
   {   
       x2d = 11951,   
       y2d = 10201,  
       radius = 5,  
   },  
   {   
       x2d = 11958,   
       y2d = 10258,  
       radius = 12,  
   },  
   {   
       x2d = 11973,   
       y2d = 10323,  
       radius = 27,  
   },  
   {   
       x2d = 11988,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 12038,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 12038,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 12038,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 12038,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 12038,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 12038,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 12038,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 12038,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 12038,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 12038,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 12038,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 12031,   
       y2d = 1631,  
       radius = 35,  
   },  
   {   
       x2d = 12038,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 12038,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 12038,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 12038,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 12023,   
       y2d = 2723,  
       radius = 27,  
   },  
   {   
       x2d = 12001,   
       y2d = 2801,  
       radius = 5,  
   },  
   {   
       x2d = 12001,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 12001,   
       y2d = 2951,  
       radius = 5,  
   },  
   {   
       x2d = 12038,   
       y2d = 3088,  
       radius = 42,  
   },  
   {   
       x2d = 12023,   
       y2d = 3373,  
       radius = 27,  
   },  
   {   
       x2d = 12001,   
       y2d = 3451,  
       radius = 5,  
   },  
   {   
       x2d = 12023,   
       y2d = 3523,  
       radius = 27,  
   },  
   {   
       x2d = 12001,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 12001,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 12038,   
       y2d = 4888,  
       radius = 42,  
   },  
   {   
       x2d = 12031,   
       y2d = 4981,  
       radius = 35,  
   },  
   {   
       x2d = 12023,   
       y2d = 5173,  
       radius = 27,  
   },  
   {   
       x2d = 12038,   
       y2d = 5238,  
       radius = 42,  
   },  
   {   
       x2d = 12001,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 12001,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 12001,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 12008,   
       y2d = 6808,  
       radius = 12,  
   },  
   {   
       x2d = 12016,   
       y2d = 7166,  
       radius = 20,  
   },  
   {   
       x2d = 12008,   
       y2d = 7308,  
       radius = 12,  
   },  
   {   
       x2d = 12001,   
       y2d = 7351,  
       radius = 5,  
   },  
   {   
       x2d = 12016,   
       y2d = 7566,  
       radius = 20,  
   },  
   {   
       x2d = 12001,   
       y2d = 7851,  
       radius = 5,  
   },  
   {   
       x2d = 12001,   
       y2d = 8051,  
       radius = 5,  
   },  
   {   
       x2d = 12008,   
       y2d = 8408,  
       radius = 12,  
   },  
   {   
       x2d = 12001,   
       y2d = 8451,  
       radius = 5,  
   },  
   {   
       x2d = 12008,   
       y2d = 8608,  
       radius = 12,  
   },  
   {   
       x2d = 12008,   
       y2d = 8708,  
       radius = 12,  
   },  
   {   
       x2d = 12001,   
       y2d = 8751,  
       radius = 5,  
   },  
   {   
       x2d = 12001,   
       y2d = 9001,  
       radius = 5,  
   },  
   {   
       x2d = 12001,   
       y2d = 9151,  
       radius = 5,  
   },  
   {   
       x2d = 12008,   
       y2d = 9908,  
       radius = 12,  
   },  
   {   
       x2d = 12001,   
       y2d = 9951,  
       radius = 5,  
   },  
   {   
       x2d = 12023,   
       y2d = 10123,  
       radius = 27,  
   },  
   {   
       x2d = 12008,   
       y2d = 10208,  
       radius = 12,  
   },  
   {   
       x2d = 12023,   
       y2d = 10273,  
       radius = 27,  
   },  
   {   
       x2d = 12088,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 12088,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 12088,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 12088,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 12088,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 12088,   
       y2d = 1888,  
       radius = 42,  
   },  
   {   
       x2d = 12088,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 12081,   
       y2d = 2781,  
       radius = 35,  
   },  
   {   
       x2d = 12058,   
       y2d = 2858,  
       radius = 12,  
   },  
   {   
       x2d = 12073,   
       y2d = 2973,  
       radius = 27,  
   },  
   {   
       x2d = 12066,   
       y2d = 3216,  
       radius = 20,  
   },  
   {   
       x2d = 12058,   
       y2d = 3258,  
       radius = 12,  
   },  
   {   
       x2d = 12088,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 12088,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 12088,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 12088,   
       y2d = 3688,  
       radius = 42,  
   },  
   {   
       x2d = 12051,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 12051,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 12051,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 12081,   
       y2d = 4331,  
       radius = 35,  
   },  
   {   
       x2d = 12058,   
       y2d = 4458,  
       radius = 12,  
   },  
   {   
       x2d = 12058,   
       y2d = 4508,  
       radius = 12,  
   },  
   {   
       x2d = 12066,   
       y2d = 4566,  
       radius = 20,  
   },  
   {   
       x2d = 12073,   
       y2d = 4623,  
       radius = 27,  
   },  
   {   
       x2d = 12088,   
       y2d = 4688,  
       radius = 42,  
   },  
   {   
       x2d = 12088,   
       y2d = 4788,  
       radius = 42,  
   },  
   {   
       x2d = 12088,   
       y2d = 5138,  
       radius = 42,  
   },  
   {   
       x2d = 12051,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 12051,   
       y2d = 6251,  
       radius = 5,  
   },  
   {   
       x2d = 12051,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 12051,   
       y2d = 6401,  
       radius = 5,  
   },  
   {   
       x2d = 12051,   
       y2d = 6451,  
       radius = 5,  
   },  
   {   
       x2d = 12066,   
       y2d = 6516,  
       radius = 20,  
   },  
   {   
       x2d = 12051,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 12051,   
       y2d = 6701,  
       radius = 5,  
   },  
   {   
       x2d = 12051,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 12066,   
       y2d = 6916,  
       radius = 20,  
   },  
   {   
       x2d = 12066,   
       y2d = 7016,  
       radius = 20,  
   },  
   {   
       x2d = 12058,   
       y2d = 7158,  
       radius = 12,  
   },  
   {   
       x2d = 12058,   
       y2d = 7258,  
       radius = 12,  
   },  
   {   
       x2d = 12058,   
       y2d = 7308,  
       radius = 12,  
   },  
   {   
       x2d = 12081,   
       y2d = 7531,  
       radius = 35,  
   },  
   {   
       x2d = 12051,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 12058,   
       y2d = 7658,  
       radius = 12,  
   },  
   {   
       x2d = 12051,   
       y2d = 7851,  
       radius = 5,  
   },  
   {   
       x2d = 12051,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 12073,   
       y2d = 7973,  
       radius = 27,  
   },  
   {   
       x2d = 12051,   
       y2d = 8951,  
       radius = 5,  
   },  
   {   
       x2d = 12051,   
       y2d = 9201,  
       radius = 5,  
   },  
   {   
       x2d = 12051,   
       y2d = 9451,  
       radius = 5,  
   },  
   {   
       x2d = 12058,   
       y2d = 9708,  
       radius = 12,  
   },  
   {   
       x2d = 12058,   
       y2d = 9758,  
       radius = 12,  
   },  
   {   
       x2d = 12066,   
       y2d = 9966,  
       radius = 20,  
   },  
   {   
       x2d = 12066,   
       y2d = 10016,  
       radius = 20,  
   },  
   {   
       x2d = 12088,   
       y2d = 10088,  
       radius = 42,  
   },  
   {   
       x2d = 12051,   
       y2d = 10201,  
       radius = 5,  
   },  
   {   
       x2d = 12088,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 12138,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 12138,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 12138,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 12138,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 12138,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 12138,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 12138,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 12123,   
       y2d = 923,  
       radius = 27,  
   },  
   {   
       x2d = 12138,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 12131,   
       y2d = 1231,  
       radius = 35,  
   },  
   {   
       x2d = 12138,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 12138,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 12138,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 12138,   
       y2d = 2088,  
       radius = 42,  
   },  
   {   
       x2d = 12138,   
       y2d = 2188,  
       radius = 42,  
   },  
   {   
       x2d = 12138,   
       y2d = 2288,  
       radius = 42,  
   },  
   {   
       x2d = 12101,   
       y2d = 2401,  
       radius = 5,  
   },  
   {   
       x2d = 12116,   
       y2d = 2566,  
       radius = 20,  
   },  
   {   
       x2d = 12138,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 12101,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 12123,   
       y2d = 3073,  
       radius = 27,  
   },  
   {   
       x2d = 12108,   
       y2d = 3158,  
       radius = 12,  
   },  
   {   
       x2d = 12108,   
       y2d = 3208,  
       radius = 12,  
   },  
   {   
       x2d = 12101,   
       y2d = 3851,  
       radius = 5,  
   },  
   {   
       x2d = 12101,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 12108,   
       y2d = 4508,  
       radius = 12,  
   },  
   {   
       x2d = 12108,   
       y2d = 4558,  
       radius = 12,  
   },  
   {   
       x2d = 12138,   
       y2d = 4888,  
       radius = 42,  
   },  
   {   
       x2d = 12138,   
       y2d = 5038,  
       radius = 42,  
   },  
   {   
       x2d = 12101,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 12101,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 12101,   
       y2d = 6051,  
       radius = 5,  
   },  
   {   
       x2d = 12108,   
       y2d = 6208,  
       radius = 12,  
   },  
   {   
       x2d = 12116,   
       y2d = 6266,  
       radius = 20,  
   },  
   {   
       x2d = 12101,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 12108,   
       y2d = 6458,  
       radius = 12,  
   },  
   {   
       x2d = 12101,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 12108,   
       y2d = 6758,  
       radius = 12,  
   },  
   {   
       x2d = 12101,   
       y2d = 6801,  
       radius = 5,  
   },  
   {   
       x2d = 12101,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 12101,   
       y2d = 7301,  
       radius = 5,  
   },  
   {   
       x2d = 12108,   
       y2d = 7358,  
       radius = 12,  
   },  
   {   
       x2d = 12101,   
       y2d = 7851,  
       radius = 5,  
   },  
   {   
       x2d = 12108,   
       y2d = 8108,  
       radius = 12,  
   },  
   {   
       x2d = 12101,   
       y2d = 8151,  
       radius = 5,  
   },  
   {   
       x2d = 12101,   
       y2d = 8901,  
       radius = 5,  
   },  
   {   
       x2d = 12101,   
       y2d = 8951,  
       radius = 5,  
   },  
   {   
       x2d = 12101,   
       y2d = 9251,  
       radius = 5,  
   },  
   {   
       x2d = 12101,   
       y2d = 9301,  
       radius = 5,  
   },  
   {   
       x2d = 12131,   
       y2d = 9681,  
       radius = 35,  
   },  
   {   
       x2d = 12101,   
       y2d = 9751,  
       radius = 5,  
   },  
   {   
       x2d = 12108,   
       y2d = 10208,  
       radius = 12,  
   },  
   {   
       x2d = 12108,   
       y2d = 10258,  
       radius = 12,  
   },  
   {   
       x2d = 12181,   
       y2d = 431,  
       radius = 35,  
   },  
   {   
       x2d = 12188,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 12188,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 12188,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 12173,   
       y2d = 1773,  
       radius = 27,  
   },  
   {   
       x2d = 12188,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 12173,   
       y2d = 1973,  
       radius = 27,  
   },  
   {   
       x2d = 12151,   
       y2d = 2401,  
       radius = 5,  
   },  
   {   
       x2d = 12166,   
       y2d = 2566,  
       radius = 20,  
   },  
   {   
       x2d = 12151,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 12188,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 12181,   
       y2d = 3331,  
       radius = 35,  
   },  
   {   
       x2d = 12181,   
       y2d = 3431,  
       radius = 35,  
   },  
   {   
       x2d = 12188,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 12188,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 12151,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 12166,   
       y2d = 3816,  
       radius = 20,  
   },  
   {   
       x2d = 12158,   
       y2d = 4008,  
       radius = 12,  
   },  
   {   
       x2d = 12158,   
       y2d = 4258,  
       radius = 12,  
   },  
   {   
       x2d = 12173,   
       y2d = 4323,  
       radius = 27,  
   },  
   {   
       x2d = 12151,   
       y2d = 4451,  
       radius = 5,  
   },  
   {   
       x2d = 12151,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 12151,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 12158,   
       y2d = 5208,  
       radius = 12,  
   },  
   {   
       x2d = 12151,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 12181,   
       y2d = 5731,  
       radius = 35,  
   },  
   {   
       x2d = 12151,   
       y2d = 6101,  
       radius = 5,  
   },  
   {   
       x2d = 12151,   
       y2d = 6451,  
       radius = 5,  
   },  
   {   
       x2d = 12151,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 12151,   
       y2d = 6701,  
       radius = 5,  
   },  
   {   
       x2d = 12151,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 12151,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 12151,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 12173,   
       y2d = 7273,  
       radius = 27,  
   },  
   {   
       x2d = 12188,   
       y2d = 7438,  
       radius = 42,  
   },  
   {   
       x2d = 12173,   
       y2d = 7523,  
       radius = 27,  
   },  
   {   
       x2d = 12151,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 12151,   
       y2d = 7651,  
       radius = 5,  
   },  
   {   
       x2d = 12151,   
       y2d = 7801,  
       radius = 5,  
   },  
   {   
       x2d = 12166,   
       y2d = 7866,  
       radius = 20,  
   },  
   {   
       x2d = 12151,   
       y2d = 8051,  
       radius = 5,  
   },  
   {   
       x2d = 12151,   
       y2d = 9201,  
       radius = 5,  
   },  
   {   
       x2d = 12151,   
       y2d = 9601,  
       radius = 5,  
   },  
   {   
       x2d = 12166,   
       y2d = 9766,  
       radius = 20,  
   },  
   {   
       x2d = 12188,   
       y2d = 9888,  
       radius = 42,  
   },  
   {   
       x2d = 12188,   
       y2d = 10138,  
       radius = 42,  
   },  
   {   
       x2d = 12158,   
       y2d = 10258,  
       radius = 12,  
   },  
   {   
       x2d = 12158,   
       y2d = 10308,  
       radius = 12,  
   },  
   {   
       x2d = 12188,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 12238,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 12238,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 12238,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 12238,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 12238,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 12238,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 12238,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 12238,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 12238,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 12238,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 12238,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 12238,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 12238,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 12216,   
       y2d = 2166,  
       radius = 20,  
   },  
   {   
       x2d = 12231,   
       y2d = 2231,  
       radius = 35,  
   },  
   {   
       x2d = 12231,   
       y2d = 2331,  
       radius = 35,  
   },  
   {   
       x2d = 12238,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 12238,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 12231,   
       y2d = 2831,  
       radius = 35,  
   },  
   {   
       x2d = 12201,   
       y2d = 2951,  
       radius = 5,  
   },  
   {   
       x2d = 12223,   
       y2d = 3023,  
       radius = 27,  
   },  
   {   
       x2d = 12201,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 12201,   
       y2d = 4451,  
       radius = 5,  
   },  
   {   
       x2d = 12238,   
       y2d = 4688,  
       radius = 42,  
   },  
   {   
       x2d = 12223,   
       y2d = 4823,  
       radius = 27,  
   },  
   {   
       x2d = 12238,   
       y2d = 4888,  
       radius = 42,  
   },  
   {   
       x2d = 12223,   
       y2d = 5023,  
       radius = 27,  
   },  
   {   
       x2d = 12201,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 12201,   
       y2d = 5501,  
       radius = 5,  
   },  
   {   
       x2d = 12201,   
       y2d = 5551,  
       radius = 5,  
   },  
   {   
       x2d = 12201,   
       y2d = 6151,  
       radius = 5,  
   },  
   {   
       x2d = 12201,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 12216,   
       y2d = 6266,  
       radius = 20,  
   },  
   {   
       x2d = 12208,   
       y2d = 6358,  
       radius = 12,  
   },  
   {   
       x2d = 12223,   
       y2d = 6423,  
       radius = 27,  
   },  
   {   
       x2d = 12216,   
       y2d = 6516,  
       radius = 20,  
   },  
   {   
       x2d = 12201,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 12208,   
       y2d = 6808,  
       radius = 12,  
   },  
   {   
       x2d = 12201,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 12201,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 12208,   
       y2d = 6958,  
       radius = 12,  
   },  
   {   
       x2d = 12201,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 12201,   
       y2d = 7651,  
       radius = 5,  
   },  
   {   
       x2d = 12201,   
       y2d = 8051,  
       radius = 5,  
   },  
   {   
       x2d = 12201,   
       y2d = 8801,  
       radius = 5,  
   },  
   {   
       x2d = 12201,   
       y2d = 9001,  
       radius = 5,  
   },  
   {   
       x2d = 12208,   
       y2d = 9158,  
       radius = 12,  
   },  
   {   
       x2d = 12208,   
       y2d = 9458,  
       radius = 12,  
   },  
   {   
       x2d = 12208,   
       y2d = 9508,  
       radius = 12,  
   },  
   {   
       x2d = 12288,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 12288,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 12288,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 12288,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 12288,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 12273,   
       y2d = 2023,  
       radius = 27,  
   },  
   {   
       x2d = 12281,   
       y2d = 2681,  
       radius = 35,  
   },  
   {   
       x2d = 12266,   
       y2d = 2766,  
       radius = 20,  
   },  
   {   
       x2d = 12281,   
       y2d = 3031,  
       radius = 35,  
   },  
   {   
       x2d = 12258,   
       y2d = 3158,  
       radius = 12,  
   },  
   {   
       x2d = 12281,   
       y2d = 3231,  
       radius = 35,  
   },  
   {   
       x2d = 12258,   
       y2d = 3308,  
       radius = 12,  
   },  
   {   
       x2d = 12251,   
       y2d = 3351,  
       radius = 5,  
   },  
   {   
       x2d = 12266,   
       y2d = 3466,  
       radius = 20,  
   },  
   {   
       x2d = 12288,   
       y2d = 3688,  
       radius = 42,  
   },  
   {   
       x2d = 12281,   
       y2d = 4031,  
       radius = 35,  
   },  
   {   
       x2d = 12251,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 12251,   
       y2d = 4201,  
       radius = 5,  
   },  
   {   
       x2d = 12258,   
       y2d = 4308,  
       radius = 12,  
   },  
   {   
       x2d = 12258,   
       y2d = 4358,  
       radius = 12,  
   },  
   {   
       x2d = 12281,   
       y2d = 4481,  
       radius = 35,  
   },  
   {   
       x2d = 12273,   
       y2d = 4573,  
       radius = 27,  
   },  
   {   
       x2d = 12288,   
       y2d = 4788,  
       radius = 42,  
   },  
   {   
       x2d = 12281,   
       y2d = 5781,  
       radius = 35,  
   },  
   {   
       x2d = 12251,   
       y2d = 6151,  
       radius = 5,  
   },  
   {   
       x2d = 12273,   
       y2d = 6273,  
       radius = 27,  
   },  
   {   
       x2d = 12258,   
       y2d = 6358,  
       radius = 12,  
   },  
   {   
       x2d = 12251,   
       y2d = 6701,  
       radius = 5,  
   },  
   {   
       x2d = 12251,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 12251,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 12251,   
       y2d = 7301,  
       radius = 5,  
   },  
   {   
       x2d = 12258,   
       y2d = 7358,  
       radius = 12,  
   },  
   {   
       x2d = 12288,   
       y2d = 7438,  
       radius = 42,  
   },  
   {   
       x2d = 12251,   
       y2d = 7651,  
       radius = 5,  
   },  
   {   
       x2d = 12251,   
       y2d = 7801,  
       radius = 5,  
   },  
   {   
       x2d = 12258,   
       y2d = 7858,  
       radius = 12,  
   },  
   {   
       x2d = 12251,   
       y2d = 9201,  
       radius = 5,  
   },  
   {   
       x2d = 12281,   
       y2d = 9331,  
       radius = 35,  
   },  
   {   
       x2d = 12258,   
       y2d = 9458,  
       radius = 12,  
   },  
   {   
       x2d = 12258,   
       y2d = 9808,  
       radius = 12,  
   },  
   {   
       x2d = 12338,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 12338,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 12338,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 12338,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 12338,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 12338,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 12338,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 12338,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 12338,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 12338,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 12338,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 12338,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 12338,   
       y2d = 2088,  
       radius = 42,  
   },  
   {   
       x2d = 12331,   
       y2d = 2231,  
       radius = 35,  
   },  
   {   
       x2d = 12338,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 12338,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 12338,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 12316,   
       y2d = 2816,  
       radius = 20,  
   },  
   {   
       x2d = 12301,   
       y2d = 3101,  
       radius = 5,  
   },  
   {   
       x2d = 12338,   
       y2d = 3188,  
       radius = 42,  
   },  
   {   
       x2d = 12338,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 12331,   
       y2d = 3431,  
       radius = 35,  
   },  
   {   
       x2d = 12316,   
       y2d = 3516,  
       radius = 20,  
   },  
   {   
       x2d = 12338,   
       y2d = 3588,  
       radius = 42,  
   },  
   {   
       x2d = 12301,   
       y2d = 3801,  
       radius = 5,  
   },  
   {   
       x2d = 12301,   
       y2d = 3851,  
       radius = 5,  
   },  
   {   
       x2d = 12308,   
       y2d = 3908,  
       radius = 12,  
   },  
   {   
       x2d = 12301,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 12301,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 12301,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 12316,   
       y2d = 4316,  
       radius = 20,  
   },  
   {   
       x2d = 12316,   
       y2d = 4366,  
       radius = 20,  
   },  
   {   
       x2d = 12331,   
       y2d = 4581,  
       radius = 35,  
   },  
   {   
       x2d = 12338,   
       y2d = 4888,  
       radius = 42,  
   },  
   {   
       x2d = 12308,   
       y2d = 5008,  
       radius = 12,  
   },  
   {   
       x2d = 12301,   
       y2d = 5051,  
       radius = 5,  
   },  
   {   
       x2d = 12301,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 12301,   
       y2d = 6451,  
       radius = 5,  
   },  
   {   
       x2d = 12301,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 12301,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 12301,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 12323,   
       y2d = 7323,  
       radius = 27,  
   },  
   {   
       x2d = 12323,   
       y2d = 7523,  
       radius = 27,  
   },  
   {   
       x2d = 12301,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 12301,   
       y2d = 7701,  
       radius = 5,  
   },  
   {   
       x2d = 12301,   
       y2d = 8751,  
       radius = 5,  
   },  
   {   
       x2d = 12308,   
       y2d = 9258,  
       radius = 12,  
   },  
   {   
       x2d = 12331,   
       y2d = 9431,  
       radius = 35,  
   },  
   {   
       x2d = 12301,   
       y2d = 9551,  
       radius = 5,  
   },  
   {   
       x2d = 12338,   
       y2d = 9788,  
       radius = 42,  
   },  
   {   
       x2d = 12301,   
       y2d = 10101,  
       radius = 5,  
   },  
   {   
       x2d = 12301,   
       y2d = 10151,  
       radius = 5,  
   },  
   {   
       x2d = 12338,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 12388,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 12373,   
       y2d = 623,  
       radius = 27,  
   },  
   {   
       x2d = 12388,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 12388,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 12388,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 12388,   
       y2d = 1888,  
       radius = 42,  
   },  
   {   
       x2d = 12381,   
       y2d = 2181,  
       radius = 35,  
   },  
   {   
       x2d = 12373,   
       y2d = 2623,  
       radius = 27,  
   },  
   {   
       x2d = 12381,   
       y2d = 2831,  
       radius = 35,  
   },  
   {   
       x2d = 12351,   
       y2d = 2951,  
       radius = 5,  
   },  
   {   
       x2d = 12351,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 12373,   
       y2d = 3073,  
       radius = 27,  
   },  
   {   
       x2d = 12351,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 12366,   
       y2d = 3816,  
       radius = 20,  
   },  
   {   
       x2d = 12388,   
       y2d = 3938,  
       radius = 42,  
   },  
   {   
       x2d = 12358,   
       y2d = 4058,  
       radius = 12,  
   },  
   {   
       x2d = 12351,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 12351,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 12351,   
       y2d = 4201,  
       radius = 5,  
   },  
   {   
       x2d = 12351,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 12388,   
       y2d = 4338,  
       radius = 42,  
   },  
   {   
       x2d = 12351,   
       y2d = 4451,  
       radius = 5,  
   },  
   {   
       x2d = 12381,   
       y2d = 4531,  
       radius = 35,  
   },  
   {   
       x2d = 12351,   
       y2d = 4651,  
       radius = 5,  
   },  
   {   
       x2d = 12381,   
       y2d = 4731,  
       radius = 35,  
   },  
   {   
       x2d = 12351,   
       y2d = 5001,  
       radius = 5,  
   },  
   {   
       x2d = 12388,   
       y2d = 5138,  
       radius = 42,  
   },  
   {   
       x2d = 12381,   
       y2d = 5231,  
       radius = 35,  
   },  
   {   
       x2d = 12388,   
       y2d = 5838,  
       radius = 42,  
   },  
   {   
       x2d = 12381,   
       y2d = 5981,  
       radius = 35,  
   },  
   {   
       x2d = 12351,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 12366,   
       y2d = 6316,  
       radius = 20,  
   },  
   {   
       x2d = 12351,   
       y2d = 6401,  
       radius = 5,  
   },  
   {   
       x2d = 12351,   
       y2d = 6451,  
       radius = 5,  
   },  
   {   
       x2d = 12358,   
       y2d = 6508,  
       radius = 12,  
   },  
   {   
       x2d = 12366,   
       y2d = 6566,  
       radius = 20,  
   },  
   {   
       x2d = 12351,   
       y2d = 6701,  
       radius = 5,  
   },  
   {   
       x2d = 12351,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 12351,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 12381,   
       y2d = 7431,  
       radius = 35,  
   },  
   {   
       x2d = 12351,   
       y2d = 9201,  
       radius = 5,  
   },  
   {   
       x2d = 12373,   
       y2d = 9273,  
       radius = 27,  
   },  
   {   
       x2d = 12381,   
       y2d = 9381,  
       radius = 35,  
   },  
   {   
       x2d = 12351,   
       y2d = 9551,  
       radius = 5,  
   },  
   {   
       x2d = 12358,   
       y2d = 9608,  
       radius = 12,  
   },  
   {   
       x2d = 12358,   
       y2d = 9658,  
       radius = 12,  
   },  
   {   
       x2d = 12366,   
       y2d = 9966,  
       radius = 20,  
   },  
   {   
       x2d = 12351,   
       y2d = 10201,  
       radius = 5,  
   },  
   {   
       x2d = 12438,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 12438,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 12438,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 12438,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 12438,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 12438,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 12438,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 12438,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 12438,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 12438,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 12438,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 12438,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 12438,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 12438,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 12438,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 12431,   
       y2d = 2281,  
       radius = 35,  
   },  
   {   
       x2d = 12438,   
       y2d = 2488,  
       radius = 42,  
   },  
   {   
       x2d = 12438,   
       y2d = 2588,  
       radius = 42,  
   },  
   {   
       x2d = 12438,   
       y2d = 2788,  
       radius = 42,  
   },  
   {   
       x2d = 12416,   
       y2d = 3016,  
       radius = 20,  
   },  
   {   
       x2d = 12431,   
       y2d = 3081,  
       radius = 35,  
   },  
   {   
       x2d = 12438,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 12438,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 12401,   
       y2d = 3501,  
       radius = 5,  
   },  
   {   
       x2d = 12416,   
       y2d = 3816,  
       radius = 20,  
   },  
   {   
       x2d = 12423,   
       y2d = 4223,  
       radius = 27,  
   },  
   {   
       x2d = 12438,   
       y2d = 4438,  
       radius = 42,  
   },  
   {   
       x2d = 12401,   
       y2d = 4601,  
       radius = 5,  
   },  
   {   
       x2d = 12401,   
       y2d = 4651,  
       radius = 5,  
   },  
   {   
       x2d = 12438,   
       y2d = 4838,  
       radius = 42,  
   },  
   {   
       x2d = 12423,   
       y2d = 5023,  
       radius = 27,  
   },  
   {   
       x2d = 12416,   
       y2d = 5516,  
       radius = 20,  
   },  
   {   
       x2d = 12431,   
       y2d = 5931,  
       radius = 35,  
   },  
   {   
       x2d = 12401,   
       y2d = 6051,  
       radius = 5,  
   },  
   {   
       x2d = 12401,   
       y2d = 6251,  
       radius = 5,  
   },  
   {   
       x2d = 12401,   
       y2d = 6401,  
       radius = 5,  
   },  
   {   
       x2d = 12401,   
       y2d = 6501,  
       radius = 5,  
   },  
   {   
       x2d = 12401,   
       y2d = 6601,  
       radius = 5,  
   },  
   {   
       x2d = 12401,   
       y2d = 6801,  
       radius = 5,  
   },  
   {   
       x2d = 12401,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 12401,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 12401,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 12416,   
       y2d = 7166,  
       radius = 20,  
   },  
   {   
       x2d = 12401,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 12401,   
       y2d = 7351,  
       radius = 5,  
   },  
   {   
       x2d = 12416,   
       y2d = 7516,  
       radius = 20,  
   },  
   {   
       x2d = 12416,   
       y2d = 7816,  
       radius = 20,  
   },  
   {   
       x2d = 12401,   
       y2d = 8851,  
       radius = 5,  
   },  
   {   
       x2d = 12416,   
       y2d = 9116,  
       radius = 20,  
   },  
   {   
       x2d = 12431,   
       y2d = 9231,  
       radius = 35,  
   },  
   {   
       x2d = 12401,   
       y2d = 9651,  
       radius = 5,  
   },  
   {   
       x2d = 12416,   
       y2d = 9966,  
       radius = 20,  
   },  
   {   
       x2d = 12408,   
       y2d = 10008,  
       radius = 12,  
   },  
   {   
       x2d = 12438,   
       y2d = 10288,  
       radius = 42,  
   },  
   {   
       x2d = 12438,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 12488,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 12488,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 12488,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 12488,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 12488,   
       y2d = 2088,  
       radius = 42,  
   },  
   {   
       x2d = 12488,   
       y2d = 2188,  
       radius = 42,  
   },  
   {   
       x2d = 12488,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 12451,   
       y2d = 2901,  
       radius = 5,  
   },  
   {   
       x2d = 12451,   
       y2d = 2951,  
       radius = 5,  
   },  
   {   
       x2d = 12451,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 12488,   
       y2d = 3688,  
       radius = 42,  
   },  
   {   
       x2d = 12488,   
       y2d = 3888,  
       radius = 42,  
   },  
   {   
       x2d = 12488,   
       y2d = 3988,  
       radius = 42,  
   },  
   {   
       x2d = 12488,   
       y2d = 4188,  
       radius = 42,  
   },  
   {   
       x2d = 12488,   
       y2d = 4288,  
       radius = 42,  
   },  
   {   
       x2d = 12451,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 12488,   
       y2d = 4638,  
       radius = 42,  
   },  
   {   
       x2d = 12488,   
       y2d = 4738,  
       radius = 42,  
   },  
   {   
       x2d = 12481,   
       y2d = 4981,  
       radius = 35,  
   },  
   {   
       x2d = 12481,   
       y2d = 5081,  
       radius = 35,  
   },  
   {   
       x2d = 12473,   
       y2d = 5173,  
       radius = 27,  
   },  
   {   
       x2d = 12451,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 12458,   
       y2d = 5558,  
       radius = 12,  
   },  
   {   
       x2d = 12451,   
       y2d = 5601,  
       radius = 5,  
   },  
   {   
       x2d = 12488,   
       y2d = 5788,  
       radius = 42,  
   },  
   {   
       x2d = 12451,   
       y2d = 6001,  
       radius = 5,  
   },  
   {   
       x2d = 12466,   
       y2d = 6316,  
       radius = 20,  
   },  
   {   
       x2d = 12451,   
       y2d = 6401,  
       radius = 5,  
   },  
   {   
       x2d = 12451,   
       y2d = 6451,  
       radius = 5,  
   },  
   {   
       x2d = 12458,   
       y2d = 6508,  
       radius = 12,  
   },  
   {   
       x2d = 12451,   
       y2d = 6601,  
       radius = 5,  
   },  
   {   
       x2d = 12451,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 12451,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 12473,   
       y2d = 6973,  
       radius = 27,  
   },  
   {   
       x2d = 12458,   
       y2d = 7058,  
       radius = 12,  
   },  
   {   
       x2d = 12451,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 12451,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 12458,   
       y2d = 7508,  
       radius = 12,  
   },  
   {   
       x2d = 12451,   
       y2d = 7551,  
       radius = 5,  
   },  
   {   
       x2d = 12458,   
       y2d = 7708,  
       radius = 12,  
   },  
   {   
       x2d = 12451,   
       y2d = 8951,  
       radius = 5,  
   },  
   {   
       x2d = 12488,   
       y2d = 9188,  
       radius = 42,  
   },  
   {   
       x2d = 12451,   
       y2d = 9301,  
       radius = 5,  
   },  
   {   
       x2d = 12451,   
       y2d = 9601,  
       radius = 5,  
   },  
   {   
       x2d = 12488,   
       y2d = 9788,  
       radius = 42,  
   },  
   {   
       x2d = 12473,   
       y2d = 9923,  
       radius = 27,  
   },  
   {   
       x2d = 12451,   
       y2d = 10201,  
       radius = 5,  
   },  
   {   
       x2d = 12538,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 12538,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 12538,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 12538,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 12538,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 12538,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 12538,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 12538,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 12538,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 12538,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 12538,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 12538,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 12538,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 12538,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 12538,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 12538,   
       y2d = 2288,  
       radius = 42,  
   },  
   {   
       x2d = 12538,   
       y2d = 2488,  
       radius = 42,  
   },  
   {   
       x2d = 12523,   
       y2d = 2573,  
       radius = 27,  
   },  
   {   
       x2d = 12531,   
       y2d = 2731,  
       radius = 35,  
   },  
   {   
       x2d = 12501,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 12501,   
       y2d = 2901,  
       radius = 5,  
   },  
   {   
       x2d = 12538,   
       y2d = 2988,  
       radius = 42,  
   },  
   {   
       x2d = 12516,   
       y2d = 3116,  
       radius = 20,  
   },  
   {   
       x2d = 12508,   
       y2d = 3158,  
       radius = 12,  
   },  
   {   
       x2d = 12538,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 12538,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 12523,   
       y2d = 3523,  
       radius = 27,  
   },  
   {   
       x2d = 12523,   
       y2d = 4073,  
       radius = 27,  
   },  
   {   
       x2d = 12538,   
       y2d = 4388,  
       radius = 42,  
   },  
   {   
       x2d = 12538,   
       y2d = 4488,  
       radius = 42,  
   },  
   {   
       x2d = 12523,   
       y2d = 4823,  
       radius = 27,  
   },  
   {   
       x2d = 12538,   
       y2d = 4938,  
       radius = 42,  
   },  
   {   
       x2d = 12501,   
       y2d = 5551,  
       radius = 5,  
   },  
   {   
       x2d = 12501,   
       y2d = 5651,  
       radius = 5,  
   },  
   {   
       x2d = 12501,   
       y2d = 5901,  
       radius = 5,  
   },  
   {   
       x2d = 12501,   
       y2d = 6151,  
       radius = 5,  
   },  
   {   
       x2d = 12508,   
       y2d = 6308,  
       radius = 12,  
   },  
   {   
       x2d = 12501,   
       y2d = 6401,  
       radius = 5,  
   },  
   {   
       x2d = 12501,   
       y2d = 6451,  
       radius = 5,  
   },  
   {   
       x2d = 12508,   
       y2d = 6658,  
       radius = 12,  
   },  
   {   
       x2d = 12501,   
       y2d = 6701,  
       radius = 5,  
   },  
   {   
       x2d = 12501,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 12508,   
       y2d = 6808,  
       radius = 12,  
   },  
   {   
       x2d = 12501,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 12501,   
       y2d = 7051,  
       radius = 5,  
   },  
   {   
       x2d = 12501,   
       y2d = 7151,  
       radius = 5,  
   },  
   {   
       x2d = 12501,   
       y2d = 7301,  
       radius = 5,  
   },  
   {   
       x2d = 12508,   
       y2d = 7358,  
       radius = 12,  
   },  
   {   
       x2d = 12508,   
       y2d = 7408,  
       radius = 12,  
   },  
   {   
       x2d = 12523,   
       y2d = 7473,  
       radius = 27,  
   },  
   {   
       x2d = 12501,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 12501,   
       y2d = 7751,  
       radius = 5,  
   },  
   {   
       x2d = 12501,   
       y2d = 8701,  
       radius = 5,  
   },  
   {   
       x2d = 12501,   
       y2d = 8851,  
       radius = 5,  
   },  
   {   
       x2d = 12501,   
       y2d = 9551,  
       radius = 5,  
   },  
   {   
       x2d = 12501,   
       y2d = 9651,  
       radius = 5,  
   },  
   {   
       x2d = 12523,   
       y2d = 9873,  
       radius = 27,  
   },  
   {   
       x2d = 12508,   
       y2d = 10008,  
       radius = 12,  
   },  
   {   
       x2d = 12508,   
       y2d = 10058,  
       radius = 12,  
   },  
   {   
       x2d = 12538,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 12588,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 12588,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 12588,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 12588,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 12588,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 12588,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 12588,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 12588,   
       y2d = 2588,  
       radius = 42,  
   },  
   {   
       x2d = 12588,   
       y2d = 2688,  
       radius = 42,  
   },  
   {   
       x2d = 12566,   
       y2d = 3216,  
       radius = 20,  
   },  
   {   
       x2d = 12588,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 12581,   
       y2d = 3631,  
       radius = 35,  
   },  
   {   
       x2d = 12573,   
       y2d = 3723,  
       radius = 27,  
   },  
   {   
       x2d = 12588,   
       y2d = 3838,  
       radius = 42,  
   },  
   {   
       x2d = 12588,   
       y2d = 3938,  
       radius = 42,  
   },  
   {   
       x2d = 12588,   
       y2d = 4038,  
       radius = 42,  
   },  
   {   
       x2d = 12573,   
       y2d = 4123,  
       radius = 27,  
   },  
   {   
       x2d = 12588,   
       y2d = 4188,  
       radius = 42,  
   },  
   {   
       x2d = 12581,   
       y2d = 4281,  
       radius = 35,  
   },  
   {   
       x2d = 12588,   
       y2d = 4588,  
       radius = 42,  
   },  
   {   
       x2d = 12588,   
       y2d = 4688,  
       radius = 42,  
   },  
   {   
       x2d = 12573,   
       y2d = 4773,  
       radius = 27,  
   },  
   {   
       x2d = 12551,   
       y2d = 5051,  
       radius = 5,  
   },  
   {   
       x2d = 12573,   
       y2d = 5573,  
       radius = 27,  
   },  
   {   
       x2d = 12566,   
       y2d = 5766,  
       radius = 20,  
   },  
   {   
       x2d = 12551,   
       y2d = 5851,  
       radius = 5,  
   },  
   {   
       x2d = 12551,   
       y2d = 6251,  
       radius = 5,  
   },  
   {   
       x2d = 12551,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 12551,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 12551,   
       y2d = 6401,  
       radius = 5,  
   },  
   {   
       x2d = 12551,   
       y2d = 6501,  
       radius = 5,  
   },  
   {   
       x2d = 12551,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 12551,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 12566,   
       y2d = 6766,  
       radius = 20,  
   },  
   {   
       x2d = 12558,   
       y2d = 6858,  
       radius = 12,  
   },  
   {   
       x2d = 12551,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 12551,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 12551,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 12551,   
       y2d = 7301,  
       radius = 5,  
   },  
   {   
       x2d = 12566,   
       y2d = 7416,  
       radius = 20,  
   },  
   {   
       x2d = 12566,   
       y2d = 7516,  
       radius = 20,  
   },  
   {   
       x2d = 12551,   
       y2d = 7751,  
       radius = 5,  
   },  
   {   
       x2d = 12566,   
       y2d = 8766,  
       radius = 20,  
   },  
   {   
       x2d = 12558,   
       y2d = 8808,  
       radius = 12,  
   },  
   {   
       x2d = 12551,   
       y2d = 9051,  
       radius = 5,  
   },  
   {   
       x2d = 12566,   
       y2d = 9166,  
       radius = 20,  
   },  
   {   
       x2d = 12551,   
       y2d = 9251,  
       radius = 5,  
   },  
   {   
       x2d = 12551,   
       y2d = 9301,  
       radius = 5,  
   },  
   {   
       x2d = 12566,   
       y2d = 9616,  
       radius = 20,  
   },  
   {   
       x2d = 12551,   
       y2d = 9701,  
       radius = 5,  
   },  
   {   
       x2d = 12573,   
       y2d = 9773,  
       radius = 27,  
   },  
   {   
       x2d = 12551,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 12558,   
       y2d = 10208,  
       radius = 12,  
   },  
   {   
       x2d = 12638,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 12638,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 12638,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 12638,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 12638,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 12631,   
       y2d = 681,  
       radius = 35,  
   },  
   {   
       x2d = 12638,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 12638,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 12638,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 12638,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 12616,   
       y2d = 1566,  
       radius = 20,  
   },  
   {   
       x2d = 12638,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 12638,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 12638,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 12638,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 12638,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 12638,   
       y2d = 2888,  
       radius = 42,  
   },  
   {   
       x2d = 12638,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 12638,   
       y2d = 3188,  
       radius = 42,  
   },  
   {   
       x2d = 12638,   
       y2d = 3288,  
       radius = 42,  
   },  
   {   
       x2d = 12638,   
       y2d = 3388,  
       radius = 42,  
   },  
   {   
       x2d = 12638,   
       y2d = 4438,  
       radius = 42,  
   },  
   {   
       x2d = 12638,   
       y2d = 4788,  
       radius = 42,  
   },  
   {   
       x2d = 12631,   
       y2d = 4881,  
       radius = 35,  
   },  
   {   
       x2d = 12601,   
       y2d = 5001,  
       radius = 5,  
   },  
   {   
       x2d = 12608,   
       y2d = 5408,  
       radius = 12,  
   },  
   {   
       x2d = 12608,   
       y2d = 5458,  
       radius = 12,  
   },  
   {   
       x2d = 12608,   
       y2d = 5508,  
       radius = 12,  
   },  
   {   
       x2d = 12616,   
       y2d = 5616,  
       radius = 20,  
   },  
   {   
       x2d = 12623,   
       y2d = 5673,  
       radius = 27,  
   },  
   {   
       x2d = 12608,   
       y2d = 5758,  
       radius = 12,  
   },  
   {   
       x2d = 12601,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 12601,   
       y2d = 5951,  
       radius = 5,  
   },  
   {   
       x2d = 12601,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 12616,   
       y2d = 6416,  
       radius = 20,  
   },  
   {   
       x2d = 12601,   
       y2d = 6701,  
       radius = 5,  
   },  
   {   
       x2d = 12608,   
       y2d = 7008,  
       radius = 12,  
   },  
   {   
       x2d = 12601,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 12601,   
       y2d = 7301,  
       radius = 5,  
   },  
   {   
       x2d = 12608,   
       y2d = 7458,  
       radius = 12,  
   },  
   {   
       x2d = 12601,   
       y2d = 8651,  
       radius = 5,  
   },  
   {   
       x2d = 12608,   
       y2d = 8708,  
       radius = 12,  
   },  
   {   
       x2d = 12601,   
       y2d = 8901,  
       radius = 5,  
   },  
   {   
       x2d = 12608,   
       y2d = 9108,  
       radius = 12,  
   },  
   {   
       x2d = 12601,   
       y2d = 9201,  
       radius = 5,  
   },  
   {   
       x2d = 12601,   
       y2d = 9251,  
       radius = 5,  
   },  
   {   
       x2d = 12601,   
       y2d = 9451,  
       radius = 5,  
   },  
   {   
       x2d = 12608,   
       y2d = 9608,  
       radius = 12,  
   },  
   {   
       x2d = 12601,   
       y2d = 9851,  
       radius = 5,  
   },  
   {   
       x2d = 12608,   
       y2d = 10008,  
       radius = 12,  
   },  
   {   
       x2d = 12601,   
       y2d = 10101,  
       radius = 5,  
   },  
   {   
       x2d = 12616,   
       y2d = 10166,  
       radius = 20,  
   },  
   {   
       x2d = 12623,   
       y2d = 10273,  
       radius = 27,  
   },  
   {   
       x2d = 12638,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 12681,   
       y2d = 431,  
       radius = 35,  
   },  
   {   
       x2d = 12688,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 12688,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 12688,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 12688,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 12688,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 12688,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 12688,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 12673,   
       y2d = 2423,  
       radius = 27,  
   },  
   {   
       x2d = 12658,   
       y2d = 2508,  
       radius = 12,  
   },  
   {   
       x2d = 12688,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 12658,   
       y2d = 2758,  
       radius = 12,  
   },  
   {   
       x2d = 12688,   
       y2d = 3488,  
       radius = 42,  
   },  
   {   
       x2d = 12688,   
       y2d = 3588,  
       radius = 42,  
   },  
   {   
       x2d = 12658,   
       y2d = 3758,  
       radius = 12,  
   },  
   {   
       x2d = 12673,   
       y2d = 3823,  
       radius = 27,  
   },  
   {   
       x2d = 12681,   
       y2d = 3931,  
       radius = 35,  
   },  
   {   
       x2d = 12673,   
       y2d = 4023,  
       radius = 27,  
   },  
   {   
       x2d = 12658,   
       y2d = 4108,  
       radius = 12,  
   },  
   {   
       x2d = 12681,   
       y2d = 4331,  
       radius = 35,  
   },  
   {   
       x2d = 12688,   
       y2d = 4588,  
       radius = 42,  
   },  
   {   
       x2d = 12673,   
       y2d = 4673,  
       radius = 27,  
   },  
   {   
       x2d = 12688,   
       y2d = 4988,  
       radius = 42,  
   },  
   {   
       x2d = 12658,   
       y2d = 5108,  
       radius = 12,  
   },  
   {   
       x2d = 12651,   
       y2d = 5201,  
       radius = 5,  
   },  
   {   
       x2d = 12651,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 12651,   
       y2d = 5501,  
       radius = 5,  
   },  
   {   
       x2d = 12658,   
       y2d = 5608,  
       radius = 12,  
   },  
   {   
       x2d = 12651,   
       y2d = 5751,  
       radius = 5,  
   },  
   {   
       x2d = 12651,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 12658,   
       y2d = 5858,  
       radius = 12,  
   },  
   {   
       x2d = 12651,   
       y2d = 5901,  
       radius = 5,  
   },  
   {   
       x2d = 12651,   
       y2d = 5951,  
       radius = 5,  
   },  
   {   
       x2d = 12651,   
       y2d = 6101,  
       radius = 5,  
   },  
   {   
       x2d = 12651,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 12651,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 12658,   
       y2d = 7008,  
       radius = 12,  
   },  
   {   
       x2d = 12651,   
       y2d = 7151,  
       radius = 5,  
   },  
   {   
       x2d = 12651,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 12651,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 12651,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 12651,   
       y2d = 8401,  
       radius = 5,  
   },  
   {   
       x2d = 12666,   
       y2d = 8716,  
       radius = 20,  
   },  
   {   
       x2d = 12673,   
       y2d = 8923,  
       radius = 27,  
   },  
   {   
       x2d = 12651,   
       y2d = 9101,  
       radius = 5,  
   },  
   {   
       x2d = 12651,   
       y2d = 9401,  
       radius = 5,  
   },  
   {   
       x2d = 12666,   
       y2d = 9466,  
       radius = 20,  
   },  
   {   
       x2d = 12658,   
       y2d = 9608,  
       radius = 12,  
   },  
   {   
       x2d = 12651,   
       y2d = 9651,  
       radius = 5,  
   },  
   {   
       x2d = 12651,   
       y2d = 9801,  
       radius = 5,  
   },  
   {   
       x2d = 12651,   
       y2d = 9851,  
       radius = 5,  
   },  
   {   
       x2d = 12651,   
       y2d = 9901,  
       radius = 5,  
   },  
   {   
       x2d = 12688,   
       y2d = 10188,  
       radius = 42,  
   },  
   {   
       x2d = 12738,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 12738,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 12738,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 12738,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 12738,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 12738,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 12738,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 12738,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 12738,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 12738,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 12738,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 12731,   
       y2d = 1781,  
       radius = 35,  
   },  
   {   
       x2d = 12738,   
       y2d = 1888,  
       radius = 42,  
   },  
   {   
       x2d = 12738,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 12701,   
       y2d = 2551,  
       radius = 5,  
   },  
   {   
       x2d = 12701,   
       y2d = 2801,  
       radius = 5,  
   },  
   {   
       x2d = 12731,   
       y2d = 2881,  
       radius = 35,  
   },  
   {   
       x2d = 12708,   
       y2d = 2958,  
       radius = 12,  
   },  
   {   
       x2d = 12731,   
       y2d = 3031,  
       radius = 35,  
   },  
   {   
       x2d = 12738,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 12738,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 12738,   
       y2d = 3788,  
       radius = 42,  
   },  
   {   
       x2d = 12701,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 12708,   
       y2d = 4158,  
       radius = 12,  
   },  
   {   
       x2d = 12723,   
       y2d = 4273,  
       radius = 27,  
   },  
   {   
       x2d = 12738,   
       y2d = 4438,  
       radius = 42,  
   },  
   {   
       x2d = 12738,   
       y2d = 4688,  
       radius = 42,  
   },  
   {   
       x2d = 12738,   
       y2d = 4788,  
       radius = 42,  
   },  
   {   
       x2d = 12738,   
       y2d = 4888,  
       radius = 42,  
   },  
   {   
       x2d = 12701,   
       y2d = 5601,  
       radius = 5,  
   },  
   {   
       x2d = 12701,   
       y2d = 5651,  
       radius = 5,  
   },  
   {   
       x2d = 12716,   
       y2d = 5866,  
       radius = 20,  
   },  
   {   
       x2d = 12708,   
       y2d = 5908,  
       radius = 12,  
   },  
   {   
       x2d = 12723,   
       y2d = 5973,  
       radius = 27,  
   },  
   {   
       x2d = 12708,   
       y2d = 6058,  
       radius = 12,  
   },  
   {   
       x2d = 12716,   
       y2d = 6416,  
       radius = 20,  
   },  
   {   
       x2d = 12701,   
       y2d = 6501,  
       radius = 5,  
   },  
   {   
       x2d = 12701,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 12701,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 12701,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 12701,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 12708,   
       y2d = 7058,  
       radius = 12,  
   },  
   {   
       x2d = 12701,   
       y2d = 7351,  
       radius = 5,  
   },  
   {   
       x2d = 12708,   
       y2d = 7458,  
       radius = 12,  
   },  
   {   
       x2d = 12701,   
       y2d = 8651,  
       radius = 5,  
   },  
   {   
       x2d = 12708,   
       y2d = 8758,  
       radius = 12,  
   },  
   {   
       x2d = 12701,   
       y2d = 9251,  
       radius = 5,  
   },  
   {   
       x2d = 12731,   
       y2d = 9681,  
       radius = 35,  
   },  
   {   
       x2d = 12701,   
       y2d = 9751,  
       radius = 5,  
   },  
   {   
       x2d = 12701,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 12701,   
       y2d = 10051,  
       radius = 5,  
   },  
   {   
       x2d = 12788,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 12773,   
       y2d = 973,  
       radius = 27,  
   },  
   {   
       x2d = 12788,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 12788,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 12788,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 12788,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 12788,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 12788,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 12788,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 12788,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 12788,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 12781,   
       y2d = 2831,  
       radius = 35,  
   },  
   {   
       x2d = 12773,   
       y2d = 2973,  
       radius = 27,  
   },  
   {   
       x2d = 12781,   
       y2d = 3381,  
       radius = 35,  
   },  
   {   
       x2d = 12781,   
       y2d = 3481,  
       radius = 35,  
   },  
   {   
       x2d = 12788,   
       y2d = 3588,  
       radius = 42,  
   },  
   {   
       x2d = 12751,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 12773,   
       y2d = 3873,  
       radius = 27,  
   },  
   {   
       x2d = 12751,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 12758,   
       y2d = 4058,  
       radius = 12,  
   },  
   {   
       x2d = 12758,   
       y2d = 4108,  
       radius = 12,  
   },  
   {   
       x2d = 12788,   
       y2d = 4538,  
       radius = 42,  
   },  
   {   
       x2d = 12788,   
       y2d = 5038,  
       radius = 42,  
   },  
   {   
       x2d = 12773,   
       y2d = 5123,  
       radius = 27,  
   },  
   {   
       x2d = 12751,   
       y2d = 5201,  
       radius = 5,  
   },  
   {   
       x2d = 12766,   
       y2d = 5366,  
       radius = 20,  
   },  
   {   
       x2d = 12758,   
       y2d = 5458,  
       radius = 12,  
   },  
   {   
       x2d = 12751,   
       y2d = 5501,  
       radius = 5,  
   },  
   {   
       x2d = 12758,   
       y2d = 5558,  
       radius = 12,  
   },  
   {   
       x2d = 12773,   
       y2d = 5623,  
       radius = 27,  
   },  
   {   
       x2d = 12751,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 12758,   
       y2d = 5858,  
       radius = 12,  
   },  
   {   
       x2d = 12758,   
       y2d = 5908,  
       radius = 12,  
   },  
   {   
       x2d = 12751,   
       y2d = 6051,  
       radius = 5,  
   },  
   {   
       x2d = 12758,   
       y2d = 6508,  
       radius = 12,  
   },  
   {   
       x2d = 12751,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 12751,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 12751,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 12766,   
       y2d = 6966,  
       radius = 20,  
   },  
   {   
       x2d = 12766,   
       y2d = 7016,  
       radius = 20,  
   },  
   {   
       x2d = 12751,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 12751,   
       y2d = 7401,  
       radius = 5,  
   },  
   {   
       x2d = 12751,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 12751,   
       y2d = 8401,  
       radius = 5,  
   },  
   {   
       x2d = 12758,   
       y2d = 9108,  
       radius = 12,  
   },  
   {   
       x2d = 12751,   
       y2d = 9251,  
       radius = 5,  
   },  
   {   
       x2d = 12751,   
       y2d = 9301,  
       radius = 5,  
   },  
   {   
       x2d = 12766,   
       y2d = 9416,  
       radius = 20,  
   },  
   {   
       x2d = 12773,   
       y2d = 9773,  
       radius = 27,  
   },  
   {   
       x2d = 12751,   
       y2d = 10101,  
       radius = 5,  
   },  
   {   
       x2d = 12766,   
       y2d = 10166,  
       radius = 20,  
   },  
   {   
       x2d = 12751,   
       y2d = 10351,  
       radius = 5,  
   },  
   {   
       x2d = 12838,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 12838,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 12838,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 12838,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 12838,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 12838,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 12838,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 12838,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 12838,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 12831,   
       y2d = 1131,  
       radius = 35,  
   },  
   {   
       x2d = 12838,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 12838,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 12838,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 12838,   
       y2d = 1888,  
       radius = 42,  
   },  
   {   
       x2d = 12838,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 12838,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 12801,   
       y2d = 2901,  
       radius = 5,  
   },  
   {   
       x2d = 12823,   
       y2d = 3023,  
       radius = 27,  
   },  
   {   
       x2d = 12816,   
       y2d = 3116,  
       radius = 20,  
   },  
   {   
       x2d = 12801,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 12823,   
       y2d = 3823,  
       radius = 27,  
   },  
   {   
       x2d = 12801,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 12801,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 12801,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 12838,   
       y2d = 4438,  
       radius = 42,  
   },  
   {   
       x2d = 12838,   
       y2d = 4638,  
       radius = 42,  
   },  
   {   
       x2d = 12838,   
       y2d = 4838,  
       radius = 42,  
   },  
   {   
       x2d = 12801,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 12838,   
       y2d = 5488,  
       radius = 42,  
   },  
   {   
       x2d = 12808,   
       y2d = 5908,  
       radius = 12,  
   },  
   {   
       x2d = 12801,   
       y2d = 6451,  
       radius = 5,  
   },  
   {   
       x2d = 12801,   
       y2d = 6501,  
       radius = 5,  
   },  
   {   
       x2d = 12801,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 12801,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 12801,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 12801,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 12801,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 12823,   
       y2d = 7373,  
       radius = 27,  
   },  
   {   
       x2d = 12801,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 12801,   
       y2d = 8601,  
       radius = 5,  
   },  
   {   
       x2d = 12801,   
       y2d = 8751,  
       radius = 5,  
   },  
   {   
       x2d = 12801,   
       y2d = 8901,  
       radius = 5,  
   },  
   {   
       x2d = 12801,   
       y2d = 8951,  
       radius = 5,  
   },  
   {   
       x2d = 12801,   
       y2d = 9101,  
       radius = 5,  
   },  
   {   
       x2d = 12808,   
       y2d = 9258,  
       radius = 12,  
   },  
   {   
       x2d = 12808,   
       y2d = 9408,  
       radius = 12,  
   },  
   {   
       x2d = 12808,   
       y2d = 9558,  
       radius = 12,  
   },  
   {   
       x2d = 12816,   
       y2d = 9616,  
       radius = 20,  
   },  
   {   
       x2d = 12838,   
       y2d = 9738,  
       radius = 42,  
   },  
   {   
       x2d = 12838,   
       y2d = 9888,  
       radius = 42,  
   },  
   {   
       x2d = 12823,   
       y2d = 10023,  
       radius = 27,  
   },  
   {   
       x2d = 12831,   
       y2d = 10181,  
       radius = 35,  
   },  
   {   
       x2d = 12838,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 12888,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 12888,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 12888,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 12888,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 12888,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 12888,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 12888,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 12881,   
       y2d = 2331,  
       radius = 35,  
   },  
   {   
       x2d = 12873,   
       y2d = 2423,  
       radius = 27,  
   },  
   {   
       x2d = 12888,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 12888,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 12881,   
       y2d = 2881,  
       radius = 35,  
   },  
   {   
       x2d = 12858,   
       y2d = 3158,  
       radius = 12,  
   },  
   {   
       x2d = 12851,   
       y2d = 3251,  
       radius = 5,  
   },  
   {   
       x2d = 12873,   
       y2d = 3323,  
       radius = 27,  
   },  
   {   
       x2d = 12888,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 12888,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 12881,   
       y2d = 3631,  
       radius = 35,  
   },  
   {   
       x2d = 12866,   
       y2d = 3766,  
       radius = 20,  
   },  
   {   
       x2d = 12851,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 12851,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 12873,   
       y2d = 4073,  
       radius = 27,  
   },  
   {   
       x2d = 12888,   
       y2d = 4138,  
       radius = 42,  
   },  
   {   
       x2d = 12888,   
       y2d = 4238,  
       radius = 42,  
   },  
   {   
       x2d = 12881,   
       y2d = 4531,  
       radius = 35,  
   },  
   {   
       x2d = 12881,   
       y2d = 4931,  
       radius = 35,  
   },  
   {   
       x2d = 12888,   
       y2d = 5038,  
       radius = 42,  
   },  
   {   
       x2d = 12851,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 12851,   
       y2d = 5201,  
       radius = 5,  
   },  
   {   
       x2d = 12851,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 12851,   
       y2d = 5751,  
       radius = 5,  
   },  
   {   
       x2d = 12851,   
       y2d = 5901,  
       radius = 5,  
   },  
   {   
       x2d = 12851,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 12851,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 12851,   
       y2d = 6451,  
       radius = 5,  
   },  
   {   
       x2d = 12851,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 12851,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 12851,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 12851,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 12851,   
       y2d = 7301,  
       radius = 5,  
   },  
   {   
       x2d = 12851,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 12851,   
       y2d = 8701,  
       radius = 5,  
   },  
   {   
       x2d = 12858,   
       y2d = 8908,  
       radius = 12,  
   },  
   {   
       x2d = 12858,   
       y2d = 8958,  
       radius = 12,  
   },  
   {   
       x2d = 12851,   
       y2d = 9001,  
       radius = 5,  
   },  
   {   
       x2d = 12851,   
       y2d = 9101,  
       radius = 5,  
   },  
   {   
       x2d = 12851,   
       y2d = 9201,  
       radius = 5,  
   },  
   {   
       x2d = 12851,   
       y2d = 9501,  
       radius = 5,  
   },  
   {   
       x2d = 12851,   
       y2d = 10101,  
       radius = 5,  
   },  
   {   
       x2d = 12938,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 12938,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 12938,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 12938,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 12938,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 12938,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 12938,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 12938,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 12938,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 12938,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 12938,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 12938,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 12923,   
       y2d = 1823,  
       radius = 27,  
   },  
   {   
       x2d = 12938,   
       y2d = 1888,  
       radius = 42,  
   },  
   {   
       x2d = 12938,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 12938,   
       y2d = 2488,  
       radius = 42,  
   },  
   {   
       x2d = 12923,   
       y2d = 2823,  
       radius = 27,  
   },  
   {   
       x2d = 12931,   
       y2d = 2981,  
       radius = 35,  
   },  
   {   
       x2d = 12901,   
       y2d = 3051,  
       radius = 5,  
   },  
   {   
       x2d = 12901,   
       y2d = 3251,  
       radius = 5,  
   },  
   {   
       x2d = 12931,   
       y2d = 3331,  
       radius = 35,  
   },  
   {   
       x2d = 12916,   
       y2d = 3716,  
       radius = 20,  
   },  
   {   
       x2d = 12901,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 12908,   
       y2d = 4008,  
       radius = 12,  
   },  
   {   
       x2d = 12938,   
       y2d = 4338,  
       radius = 42,  
   },  
   {   
       x2d = 12931,   
       y2d = 4631,  
       radius = 35,  
   },  
   {   
       x2d = 12901,   
       y2d = 4701,  
       radius = 5,  
   },  
   {   
       x2d = 12901,   
       y2d = 4751,  
       radius = 5,  
   },  
   {   
       x2d = 12938,   
       y2d = 4838,  
       radius = 42,  
   },  
   {   
       x2d = 12901,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 12901,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 12923,   
       y2d = 5473,  
       radius = 27,  
   },  
   {   
       x2d = 12908,   
       y2d = 5558,  
       radius = 12,  
   },  
   {   
       x2d = 12908,   
       y2d = 5758,  
       radius = 12,  
   },  
   {   
       x2d = 12908,   
       y2d = 6058,  
       radius = 12,  
   },  
   {   
       x2d = 12938,   
       y2d = 6288,  
       radius = 42,  
   },  
   {   
       x2d = 12901,   
       y2d = 6401,  
       radius = 5,  
   },  
   {   
       x2d = 12908,   
       y2d = 6858,  
       radius = 12,  
   },  
   {   
       x2d = 12901,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 12908,   
       y2d = 7258,  
       radius = 12,  
   },  
   {   
       x2d = 12901,   
       y2d = 7301,  
       radius = 5,  
   },  
   {   
       x2d = 12908,   
       y2d = 7358,  
       radius = 12,  
   },  
   {   
       x2d = 12901,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 12901,   
       y2d = 8701,  
       radius = 5,  
   },  
   {   
       x2d = 12901,   
       y2d = 8951,  
       radius = 5,  
   },  
   {   
       x2d = 12908,   
       y2d = 9008,  
       radius = 12,  
   },  
   {   
       x2d = 12916,   
       y2d = 9316,  
       radius = 20,  
   },  
   {   
       x2d = 12901,   
       y2d = 9401,  
       radius = 5,  
   },  
   {   
       x2d = 12916,   
       y2d = 9516,  
       radius = 20,  
   },  
   {   
       x2d = 12938,   
       y2d = 9788,  
       radius = 42,  
   },  
   {   
       x2d = 12938,   
       y2d = 9888,  
       radius = 42,  
   },  
   {   
       x2d = 12916,   
       y2d = 10116,  
       radius = 20,  
   },  
   {   
       x2d = 12938,   
       y2d = 10238,  
       radius = 42,  
   },  
   {   
       x2d = 12923,   
       y2d = 10323,  
       radius = 27,  
   },  
   {   
       x2d = 12988,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 12988,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 12988,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 12988,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 12988,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 12988,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 12973,   
       y2d = 2073,  
       radius = 27,  
   },  
   {   
       x2d = 12988,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 12951,   
       y2d = 2351,  
       radius = 5,  
   },  
   {   
       x2d = 12988,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 12973,   
       y2d = 2773,  
       radius = 27,  
   },  
   {   
       x2d = 12966,   
       y2d = 2916,  
       radius = 20,  
   },  
   {   
       x2d = 12951,   
       y2d = 3051,  
       radius = 5,  
   },  
   {   
       x2d = 12988,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 12988,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 12958,   
       y2d = 3658,  
       radius = 12,  
   },  
   {   
       x2d = 12951,   
       y2d = 3801,  
       radius = 5,  
   },  
   {   
       x2d = 12951,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 12988,   
       y2d = 3988,  
       radius = 42,  
   },  
   {   
       x2d = 12973,   
       y2d = 4073,  
       radius = 27,  
   },  
   {   
       x2d = 12988,   
       y2d = 4138,  
       radius = 42,  
   },  
   {   
       x2d = 12981,   
       y2d = 4481,  
       radius = 35,  
   },  
   {   
       x2d = 12966,   
       y2d = 4566,  
       radius = 20,  
   },  
   {   
       x2d = 12951,   
       y2d = 4701,  
       radius = 5,  
   },  
   {   
       x2d = 12951,   
       y2d = 4751,  
       radius = 5,  
   },  
   {   
       x2d = 12988,   
       y2d = 4938,  
       radius = 42,  
   },  
   {   
       x2d = 12981,   
       y2d = 5031,  
       radius = 35,  
   },  
   {   
       x2d = 12951,   
       y2d = 5101,  
       radius = 5,  
   },  
   {   
       x2d = 12988,   
       y2d = 5538,  
       radius = 42,  
   },  
   {   
       x2d = 12973,   
       y2d = 6023,  
       radius = 27,  
   },  
   {   
       x2d = 12951,   
       y2d = 6101,  
       radius = 5,  
   },  
   {   
       x2d = 12951,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 12951,   
       y2d = 6601,  
       radius = 5,  
   },  
   {   
       x2d = 12958,   
       y2d = 6858,  
       radius = 12,  
   },  
   {   
       x2d = 12966,   
       y2d = 6916,  
       radius = 20,  
   },  
   {   
       x2d = 12988,   
       y2d = 7238,  
       radius = 42,  
   },  
   {   
       x2d = 12958,   
       y2d = 7358,  
       radius = 12,  
   },  
   {   
       x2d = 12958,   
       y2d = 7408,  
       radius = 12,  
   },  
   {   
       x2d = 12951,   
       y2d = 9001,  
       radius = 5,  
   },  
   {   
       x2d = 12951,   
       y2d = 9201,  
       radius = 5,  
   },  
   {   
       x2d = 12958,   
       y2d = 9258,  
       radius = 12,  
   },  
   {   
       x2d = 12966,   
       y2d = 9316,  
       radius = 20,  
   },  
   {   
       x2d = 12958,   
       y2d = 9358,  
       radius = 12,  
   },  
   {   
       x2d = 12958,   
       y2d = 9458,  
       radius = 12,  
   },  
   {   
       x2d = 12951,   
       y2d = 9651,  
       radius = 5,  
   },  
   {   
       x2d = 12973,   
       y2d = 9973,  
       radius = 27,  
   },  
   {   
       x2d = 12951,   
       y2d = 10051,  
       radius = 5,  
   },  
   {   
       x2d = 12988,   
       y2d = 10138,  
       radius = 42,  
   },  
   {   
       x2d = 13038,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 13038,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 13038,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 13038,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 13031,   
       y2d = 531,  
       radius = 35,  
   },  
   {   
       x2d = 13038,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 13038,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 13038,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 13038,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 13038,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 13038,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 13038,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 13038,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 13038,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 13038,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 13038,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 13038,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 13031,   
       y2d = 2531,  
       radius = 35,  
   },  
   {   
       x2d = 13008,   
       y2d = 2958,  
       radius = 12,  
   },  
   {   
       x2d = 13001,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 13001,   
       y2d = 3201,  
       radius = 5,  
   },  
   {   
       x2d = 13001,   
       y2d = 3251,  
       radius = 5,  
   },  
   {   
       x2d = 13001,   
       y2d = 3301,  
       radius = 5,  
   },  
   {   
       x2d = 13001,   
       y2d = 3351,  
       radius = 5,  
   },  
   {   
       x2d = 13001,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 13001,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 13038,   
       y2d = 3888,  
       radius = 42,  
   },  
   {   
       x2d = 13008,   
       y2d = 4258,  
       radius = 12,  
   },  
   {   
       x2d = 13038,   
       y2d = 4388,  
       radius = 42,  
   },  
   {   
       x2d = 13031,   
       y2d = 4581,  
       radius = 35,  
   },  
   {   
       x2d = 13001,   
       y2d = 4651,  
       radius = 5,  
   },  
   {   
       x2d = 13001,   
       y2d = 4751,  
       radius = 5,  
   },  
   {   
       x2d = 13001,   
       y2d = 5101,  
       radius = 5,  
   },  
   {   
       x2d = 13001,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 13023,   
       y2d = 5673,  
       radius = 27,  
   },  
   {   
       x2d = 13001,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 13038,   
       y2d = 6238,  
       radius = 42,  
   },  
   {   
       x2d = 13038,   
       y2d = 6338,  
       radius = 42,  
   },  
   {   
       x2d = 13001,   
       y2d = 6701,  
       radius = 5,  
   },  
   {   
       x2d = 13001,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 13016,   
       y2d = 7116,  
       radius = 20,  
   },  
   {   
       x2d = 13001,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 13001,   
       y2d = 8251,  
       radius = 5,  
   },  
   {   
       x2d = 13008,   
       y2d = 9358,  
       radius = 12,  
   },  
   {   
       x2d = 13038,   
       y2d = 9738,  
       radius = 42,  
   },  
   {   
       x2d = 13031,   
       y2d = 9881,  
       radius = 35,  
   },  
   {   
       x2d = 13031,   
       y2d = 10031,  
       radius = 35,  
   },  
   {   
       x2d = 13023,   
       y2d = 10223,  
       radius = 27,  
   },  
   {   
       x2d = 13008,   
       y2d = 10308,  
       radius = 12,  
   },  
   {   
       x2d = 13008,   
       y2d = 10358,  
       radius = 12,  
   },  
   {   
       x2d = 13088,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 13088,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 13088,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 13088,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 13088,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 13088,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 13088,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 13088,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 13073,   
       y2d = 2623,  
       radius = 27,  
   },  
   {   
       x2d = 13088,   
       y2d = 2688,  
       radius = 42,  
   },  
   {   
       x2d = 13051,   
       y2d = 2801,  
       radius = 5,  
   },  
   {   
       x2d = 13051,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 13081,   
       y2d = 2931,  
       radius = 35,  
   },  
   {   
       x2d = 13051,   
       y2d = 3051,  
       radius = 5,  
   },  
   {   
       x2d = 13051,   
       y2d = 3101,  
       radius = 5,  
   },  
   {   
       x2d = 13088,   
       y2d = 3188,  
       radius = 42,  
   },  
   {   
       x2d = 13088,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 13081,   
       y2d = 3531,  
       radius = 35,  
   },  
   {   
       x2d = 13051,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 13051,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 13073,   
       y2d = 3973,  
       radius = 27,  
   },  
   {   
       x2d = 13051,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 13088,   
       y2d = 4238,  
       radius = 42,  
   },  
   {   
       x2d = 13081,   
       y2d = 4531,  
       radius = 35,  
   },  
   {   
       x2d = 13081,   
       y2d = 4731,  
       radius = 35,  
   },  
   {   
       x2d = 13088,   
       y2d = 4838,  
       radius = 42,  
   },  
   {   
       x2d = 13088,   
       y2d = 4988,  
       radius = 42,  
   },  
   {   
       x2d = 13066,   
       y2d = 5116,  
       radius = 20,  
   },  
   {   
       x2d = 13058,   
       y2d = 5158,  
       radius = 12,  
   },  
   {   
       x2d = 13088,   
       y2d = 5538,  
       radius = 42,  
   },  
   {   
       x2d = 13051,   
       y2d = 6001,  
       radius = 5,  
   },  
   {   
       x2d = 13058,   
       y2d = 6058,  
       radius = 12,  
   },  
   {   
       x2d = 13058,   
       y2d = 6558,  
       radius = 12,  
   },  
   {   
       x2d = 13051,   
       y2d = 6601,  
       radius = 5,  
   },  
   {   
       x2d = 13051,   
       y2d = 6701,  
       radius = 5,  
   },  
   {   
       x2d = 13051,   
       y2d = 6801,  
       radius = 5,  
   },  
   {   
       x2d = 13058,   
       y2d = 6858,  
       radius = 12,  
   },  
   {   
       x2d = 13051,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 13058,   
       y2d = 6958,  
       radius = 12,  
   },  
   {   
       x2d = 13058,   
       y2d = 7008,  
       radius = 12,  
   },  
   {   
       x2d = 13051,   
       y2d = 7051,  
       radius = 5,  
   },  
   {   
       x2d = 13051,   
       y2d = 7151,  
       radius = 5,  
   },  
   {   
       x2d = 13081,   
       y2d = 7281,  
       radius = 35,  
   },  
   {   
       x2d = 13051,   
       y2d = 7401,  
       radius = 5,  
   },  
   {   
       x2d = 13051,   
       y2d = 8451,  
       radius = 5,  
   },  
   {   
       x2d = 13051,   
       y2d = 8701,  
       radius = 5,  
   },  
   {   
       x2d = 13051,   
       y2d = 9051,  
       radius = 5,  
   },  
   {   
       x2d = 13051,   
       y2d = 9201,  
       radius = 5,  
   },  
   {   
       x2d = 13051,   
       y2d = 9351,  
       radius = 5,  
   },  
   {   
       x2d = 13066,   
       y2d = 9516,  
       radius = 20,  
   },  
   {   
       x2d = 13088,   
       y2d = 9838,  
       radius = 42,  
   },  
   {   
       x2d = 13051,   
       y2d = 9951,  
       radius = 5,  
   },  
   {   
       x2d = 13073,   
       y2d = 10323,  
       radius = 27,  
   },  
   {   
       x2d = 13088,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 13138,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 13138,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 13138,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 13138,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 13138,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 13123,   
       y2d = 673,  
       radius = 27,  
   },  
   {   
       x2d = 13138,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 13138,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 13138,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 13138,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 13138,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 13138,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 13138,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 13138,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 13138,   
       y2d = 2488,  
       radius = 42,  
   },  
   {   
       x2d = 13101,   
       y2d = 3301,  
       radius = 5,  
   },  
   {   
       x2d = 13108,   
       y2d = 3658,  
       radius = 12,  
   },  
   {   
       x2d = 13101,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 13138,   
       y2d = 3788,  
       radius = 42,  
   },  
   {   
       x2d = 13123,   
       y2d = 3923,  
       radius = 27,  
   },  
   {   
       x2d = 13101,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 13138,   
       y2d = 4388,  
       radius = 42,  
   },  
   {   
       x2d = 13116,   
       y2d = 4666,  
       radius = 20,  
   },  
   {   
       x2d = 13131,   
       y2d = 5081,  
       radius = 35,  
   },  
   {   
       x2d = 13101,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 13101,   
       y2d = 5701,  
       radius = 5,  
   },  
   {   
       x2d = 13116,   
       y2d = 6016,  
       radius = 20,  
   },  
   {   
       x2d = 13131,   
       y2d = 6231,  
       radius = 35,  
   },  
   {   
       x2d = 13138,   
       y2d = 6338,  
       radius = 42,  
   },  
   {   
       x2d = 13123,   
       y2d = 6423,  
       radius = 27,  
   },  
   {   
       x2d = 13108,   
       y2d = 6508,  
       radius = 12,  
   },  
   {   
       x2d = 13101,   
       y2d = 6801,  
       radius = 5,  
   },  
   {   
       x2d = 13101,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 13101,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 13101,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 13101,   
       y2d = 7351,  
       radius = 5,  
   },  
   {   
       x2d = 13101,   
       y2d = 7401,  
       radius = 5,  
   },  
   {   
       x2d = 13101,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 13108,   
       y2d = 8908,  
       radius = 12,  
   },  
   {   
       x2d = 13101,   
       y2d = 9051,  
       radius = 5,  
   },  
   {   
       x2d = 13101,   
       y2d = 9201,  
       radius = 5,  
   },  
   {   
       x2d = 13101,   
       y2d = 9401,  
       radius = 5,  
   },  
   {   
       x2d = 13101,   
       y2d = 9451,  
       radius = 5,  
   },  
   {   
       x2d = 13101,   
       y2d = 9601,  
       radius = 5,  
   },  
   {   
       x2d = 13138,   
       y2d = 9688,  
       radius = 42,  
   },  
   {   
       x2d = 13131,   
       y2d = 9931,  
       radius = 35,  
   },  
   {   
       x2d = 13101,   
       y2d = 10151,  
       radius = 5,  
   },  
   {   
       x2d = 13101,   
       y2d = 10201,  
       radius = 5,  
   },  
   {   
       x2d = 13138,   
       y2d = 10288,  
       radius = 42,  
   },  
   {   
       x2d = 13188,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 13158,   
       y2d = 958,  
       radius = 12,  
   },  
   {   
       x2d = 13188,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 13188,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 13173,   
       y2d = 1323,  
       radius = 27,  
   },  
   {   
       x2d = 13188,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 13188,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 13188,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 13151,   
       y2d = 2351,  
       radius = 5,  
   },  
   {   
       x2d = 13188,   
       y2d = 2588,  
       radius = 42,  
   },  
   {   
       x2d = 13173,   
       y2d = 2723,  
       radius = 27,  
   },  
   {   
       x2d = 13188,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 13173,   
       y2d = 3073,  
       radius = 27,  
   },  
   {   
       x2d = 13151,   
       y2d = 3251,  
       radius = 5,  
   },  
   {   
       x2d = 13173,   
       y2d = 3323,  
       radius = 27,  
   },  
   {   
       x2d = 13188,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 13181,   
       y2d = 3531,  
       radius = 35,  
   },  
   {   
       x2d = 13151,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 13151,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 13181,   
       y2d = 4031,  
       radius = 35,  
   },  
   {   
       x2d = 13151,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 13158,   
       y2d = 4158,  
       radius = 12,  
   },  
   {   
       x2d = 13173,   
       y2d = 4223,  
       radius = 27,  
   },  
   {   
       x2d = 13173,   
       y2d = 4473,  
       radius = 27,  
   },  
   {   
       x2d = 13173,   
       y2d = 4723,  
       radius = 27,  
   },  
   {   
       x2d = 13188,   
       y2d = 4788,  
       radius = 42,  
   },  
   {   
       x2d = 13188,   
       y2d = 4888,  
       radius = 42,  
   },  
   {   
       x2d = 13151,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 13181,   
       y2d = 5631,  
       radius = 35,  
   },  
   {   
       x2d = 13151,   
       y2d = 5951,  
       radius = 5,  
   },  
   {   
       x2d = 13166,   
       y2d = 6016,  
       radius = 20,  
   },  
   {   
       x2d = 13158,   
       y2d = 6058,  
       radius = 12,  
   },  
   {   
       x2d = 13158,   
       y2d = 7008,  
       radius = 12,  
   },  
   {   
       x2d = 13166,   
       y2d = 7116,  
       radius = 20,  
   },  
   {   
       x2d = 13166,   
       y2d = 7266,  
       radius = 20,  
   },  
   {   
       x2d = 13166,   
       y2d = 7416,  
       radius = 20,  
   },  
   {   
       x2d = 13158,   
       y2d = 7458,  
       radius = 12,  
   },  
   {   
       x2d = 13158,   
       y2d = 8608,  
       radius = 12,  
   },  
   {   
       x2d = 13151,   
       y2d = 8751,  
       radius = 5,  
   },  
   {   
       x2d = 13188,   
       y2d = 8938,  
       radius = 42,  
   },  
   {   
       x2d = 13151,   
       y2d = 9051,  
       radius = 5,  
   },  
   {   
       x2d = 13158,   
       y2d = 9208,  
       radius = 12,  
   },  
   {   
       x2d = 13188,   
       y2d = 9588,  
       radius = 42,  
   },  
   {   
       x2d = 13188,   
       y2d = 9788,  
       radius = 42,  
   },  
   {   
       x2d = 13188,   
       y2d = 9888,  
       radius = 42,  
   },  
   {   
       x2d = 13188,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 13238,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 13238,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 13238,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 13238,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 13238,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 13231,   
       y2d = 631,  
       radius = 35,  
   },  
   {   
       x2d = 13238,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 13238,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 13238,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 13238,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 13238,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 13238,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 13238,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 13231,   
       y2d = 2131,  
       radius = 35,  
   },  
   {   
       x2d = 13238,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 13216,   
       y2d = 2416,  
       radius = 20,  
   },  
   {   
       x2d = 13238,   
       y2d = 2688,  
       radius = 42,  
   },  
   {   
       x2d = 13216,   
       y2d = 2816,  
       radius = 20,  
   },  
   {   
       x2d = 13201,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 13216,   
       y2d = 3216,  
       radius = 20,  
   },  
   {   
       x2d = 13238,   
       y2d = 3288,  
       radius = 42,  
   },  
   {   
       x2d = 13201,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 13201,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 13238,   
       y2d = 3788,  
       radius = 42,  
   },  
   {   
       x2d = 13201,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 13201,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 13208,   
       y2d = 4108,  
       radius = 12,  
   },  
   {   
       x2d = 13231,   
       y2d = 4181,  
       radius = 35,  
   },  
   {   
       x2d = 13238,   
       y2d = 4388,  
       radius = 42,  
   },  
   {   
       x2d = 13231,   
       y2d = 4631,  
       radius = 35,  
   },  
   {   
       x2d = 13201,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 13201,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 13201,   
       y2d = 5501,  
       radius = 5,  
   },  
   {   
       x2d = 13208,   
       y2d = 5558,  
       radius = 12,  
   },  
   {   
       x2d = 13201,   
       y2d = 5701,  
       radius = 5,  
   },  
   {   
       x2d = 13208,   
       y2d = 5958,  
       radius = 12,  
   },  
   {   
       x2d = 13208,   
       y2d = 6008,  
       radius = 12,  
   },  
   {   
       x2d = 13201,   
       y2d = 6251,  
       radius = 5,  
   },  
   {   
       x2d = 13201,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 13201,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 13208,   
       y2d = 7008,  
       radius = 12,  
   },  
   {   
       x2d = 13201,   
       y2d = 7151,  
       radius = 5,  
   },  
   {   
       x2d = 13201,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 13208,   
       y2d = 7258,  
       radius = 12,  
   },  
   {   
       x2d = 13201,   
       y2d = 8051,  
       radius = 5,  
   },  
   {   
       x2d = 13201,   
       y2d = 8551,  
       radius = 5,  
   },  
   {   
       x2d = 13216,   
       y2d = 8616,  
       radius = 20,  
   },  
   {   
       x2d = 13216,   
       y2d = 8716,  
       radius = 20,  
   },  
   {   
       x2d = 13238,   
       y2d = 9038,  
       radius = 42,  
   },  
   {   
       x2d = 13201,   
       y2d = 9151,  
       radius = 5,  
   },  
   {   
       x2d = 13201,   
       y2d = 9201,  
       radius = 5,  
   },  
   {   
       x2d = 13208,   
       y2d = 10008,  
       radius = 12,  
   },  
   {   
       x2d = 13238,   
       y2d = 10238,  
       radius = 42,  
   },  
   {   
       x2d = 13288,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 13281,   
       y2d = 931,  
       radius = 35,  
   },  
   {   
       x2d = 13288,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 13288,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 13288,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 13288,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 13288,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 13281,   
       y2d = 2331,  
       radius = 35,  
   },  
   {   
       x2d = 13266,   
       y2d = 2416,  
       radius = 20,  
   },  
   {   
       x2d = 13266,   
       y2d = 2516,  
       radius = 20,  
   },  
   {   
       x2d = 13281,   
       y2d = 2781,  
       radius = 35,  
   },  
   {   
       x2d = 13251,   
       y2d = 2851,  
       radius = 5,  
   },  
   {   
       x2d = 13266,   
       y2d = 2916,  
       radius = 20,  
   },  
   {   
       x2d = 13288,   
       y2d = 2988,  
       radius = 42,  
   },  
   {   
       x2d = 13251,   
       y2d = 3101,  
       radius = 5,  
   },  
   {   
       x2d = 13251,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 13288,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 13273,   
       y2d = 3523,  
       radius = 27,  
   },  
   {   
       x2d = 13251,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 13251,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 13251,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 13251,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 13251,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 13288,   
       y2d = 4088,  
       radius = 42,  
   },  
   {   
       x2d = 13251,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 13251,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 13258,   
       y2d = 4708,  
       radius = 12,  
   },  
   {   
       x2d = 13288,   
       y2d = 4788,  
       radius = 42,  
   },  
   {   
       x2d = 13281,   
       y2d = 4881,  
       radius = 35,  
   },  
   {   
       x2d = 13288,   
       y2d = 4988,  
       radius = 42,  
   },  
   {   
       x2d = 13251,   
       y2d = 5101,  
       radius = 5,  
   },  
   {   
       x2d = 13258,   
       y2d = 5158,  
       radius = 12,  
   },  
   {   
       x2d = 13251,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 13266,   
       y2d = 5416,  
       radius = 20,  
   },  
   {   
       x2d = 13266,   
       y2d = 5466,  
       radius = 20,  
   },  
   {   
       x2d = 13281,   
       y2d = 5531,  
       radius = 35,  
   },  
   {   
       x2d = 13258,   
       y2d = 5608,  
       radius = 12,  
   },  
   {   
       x2d = 13251,   
       y2d = 6151,  
       radius = 5,  
   },  
   {   
       x2d = 13251,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 13251,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 13258,   
       y2d = 7258,  
       radius = 12,  
   },  
   {   
       x2d = 13251,   
       y2d = 8801,  
       radius = 5,  
   },  
   {   
       x2d = 13273,   
       y2d = 8873,  
       radius = 27,  
   },  
   {   
       x2d = 13281,   
       y2d = 9131,  
       radius = 35,  
   },  
   {   
       x2d = 13288,   
       y2d = 9538,  
       radius = 42,  
   },  
   {   
       x2d = 13288,   
       y2d = 9638,  
       radius = 42,  
   },  
   {   
       x2d = 13281,   
       y2d = 9781,  
       radius = 35,  
   },  
   {   
       x2d = 13273,   
       y2d = 9873,  
       radius = 27,  
   },  
   {   
       x2d = 13251,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 13281,   
       y2d = 10081,  
       radius = 35,  
   },  
   {   
       x2d = 13288,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 13338,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 13338,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 13338,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 13338,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 13338,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 13338,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 13338,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 13338,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 13338,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 13338,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 13338,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 13338,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 13338,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 13338,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 13338,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 13323,   
       y2d = 2223,  
       radius = 27,  
   },  
   {   
       x2d = 13323,   
       y2d = 2423,  
       radius = 27,  
   },  
   {   
       x2d = 13301,   
       y2d = 2551,  
       radius = 5,  
   },  
   {   
       x2d = 13331,   
       y2d = 3231,  
       radius = 35,  
   },  
   {   
       x2d = 13323,   
       y2d = 3323,  
       radius = 27,  
   },  
   {   
       x2d = 13338,   
       y2d = 3588,  
       radius = 42,  
   },  
   {   
       x2d = 13338,   
       y2d = 3688,  
       radius = 42,  
   },  
   {   
       x2d = 13338,   
       y2d = 3788,  
       radius = 42,  
   },  
   {   
       x2d = 13301,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 13331,   
       y2d = 3981,  
       radius = 35,  
   },  
   {   
       x2d = 13301,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 13338,   
       y2d = 4338,  
       radius = 42,  
   },  
   {   
       x2d = 13301,   
       y2d = 4451,  
       radius = 5,  
   },  
   {   
       x2d = 13338,   
       y2d = 4588,  
       radius = 42,  
   },  
   {   
       x2d = 13331,   
       y2d = 4681,  
       radius = 35,  
   },  
   {   
       x2d = 13316,   
       y2d = 5116,  
       radius = 20,  
   },  
   {   
       x2d = 13301,   
       y2d = 5201,  
       radius = 5,  
   },  
   {   
       x2d = 13301,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 13308,   
       y2d = 5358,  
       radius = 12,  
   },  
   {   
       x2d = 13301,   
       y2d = 6101,  
       radius = 5,  
   },  
   {   
       x2d = 13301,   
       y2d = 6151,  
       radius = 5,  
   },  
   {   
       x2d = 13301,   
       y2d = 6451,  
       radius = 5,  
   },  
   {   
       x2d = 13308,   
       y2d = 7158,  
       radius = 12,  
   },  
   {   
       x2d = 13301,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 13301,   
       y2d = 7401,  
       radius = 5,  
   },  
   {   
       x2d = 13301,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 13316,   
       y2d = 7966,  
       radius = 20,  
   },  
   {   
       x2d = 13323,   
       y2d = 8623,  
       radius = 27,  
   },  
   {   
       x2d = 13301,   
       y2d = 8701,  
       radius = 5,  
   },  
   {   
       x2d = 13323,   
       y2d = 8773,  
       radius = 27,  
   },  
   {   
       x2d = 13338,   
       y2d = 8838,  
       radius = 42,  
   },  
   {   
       x2d = 13331,   
       y2d = 8981,  
       radius = 35,  
   },  
   {   
       x2d = 13316,   
       y2d = 9216,  
       radius = 20,  
   },  
   {   
       x2d = 13308,   
       y2d = 9258,  
       radius = 12,  
   },  
   {   
       x2d = 13301,   
       y2d = 9301,  
       radius = 5,  
   },  
   {   
       x2d = 13338,   
       y2d = 9388,  
       radius = 42,  
   },  
   {   
       x2d = 13338,   
       y2d = 9738,  
       radius = 42,  
   },  
   {   
       x2d = 13331,   
       y2d = 9881,  
       radius = 35,  
   },  
   {   
       x2d = 13316,   
       y2d = 10016,  
       radius = 20,  
   },  
   {   
       x2d = 13338,   
       y2d = 10238,  
       radius = 42,  
   },  
   {   
       x2d = 13381,   
       y2d = 431,  
       radius = 35,  
   },  
   {   
       x2d = 13388,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 13388,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 13388,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 13388,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 13388,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 13373,   
       y2d = 2373,  
       radius = 27,  
   },  
   {   
       x2d = 13351,   
       y2d = 2501,  
       radius = 5,  
   },  
   {   
       x2d = 13351,   
       y2d = 2651,  
       radius = 5,  
   },  
   {   
       x2d = 13351,   
       y2d = 2701,  
       radius = 5,  
   },  
   {   
       x2d = 13373,   
       y2d = 2873,  
       radius = 27,  
   },  
   {   
       x2d = 13373,   
       y2d = 3073,  
       radius = 27,  
   },  
   {   
       x2d = 13381,   
       y2d = 3331,  
       radius = 35,  
   },  
   {   
       x2d = 13373,   
       y2d = 3473,  
       radius = 27,  
   },  
   {   
       x2d = 13366,   
       y2d = 3916,  
       radius = 20,  
   },  
   {   
       x2d = 13373,   
       y2d = 4123,  
       radius = 27,  
   },  
   {   
       x2d = 13351,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 13388,   
       y2d = 4788,  
       radius = 42,  
   },  
   {   
       x2d = 13388,   
       y2d = 4888,  
       radius = 42,  
   },  
   {   
       x2d = 13388,   
       y2d = 4988,  
       radius = 42,  
   },  
   {   
       x2d = 13373,   
       y2d = 5073,  
       radius = 27,  
   },  
   {   
       x2d = 13358,   
       y2d = 5208,  
       radius = 12,  
   },  
   {   
       x2d = 13351,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 13358,   
       y2d = 5358,  
       radius = 12,  
   },  
   {   
       x2d = 13358,   
       y2d = 5408,  
       radius = 12,  
   },  
   {   
       x2d = 13351,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 13358,   
       y2d = 5508,  
       radius = 12,  
   },  
   {   
       x2d = 13351,   
       y2d = 6151,  
       radius = 5,  
   },  
   {   
       x2d = 13351,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 13351,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 13351,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 13351,   
       y2d = 7351,  
       radius = 5,  
   },  
   {   
       x2d = 13351,   
       y2d = 7801,  
       radius = 5,  
   },  
   {   
       x2d = 13373,   
       y2d = 7873,  
       radius = 27,  
   },  
   {   
       x2d = 13381,   
       y2d = 7931,  
       radius = 35,  
   },  
   {   
       x2d = 13388,   
       y2d = 8738,  
       radius = 42,  
   },  
   {   
       x2d = 13381,   
       y2d = 9131,  
       radius = 35,  
   },  
   {   
       x2d = 13388,   
       y2d = 9288,  
       radius = 42,  
   },  
   {   
       x2d = 13388,   
       y2d = 9488,  
       radius = 42,  
   },  
   {   
       x2d = 13381,   
       y2d = 9581,  
       radius = 35,  
   },  
   {   
       x2d = 13358,   
       y2d = 10008,  
       radius = 12,  
   },  
   {   
       x2d = 13388,   
       y2d = 10138,  
       radius = 42,  
   },  
   {   
       x2d = 13388,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 13438,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 13438,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 13438,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 13438,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 13438,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 13438,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 13438,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 13438,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 13438,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 13438,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 13438,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 13438,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 13438,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 13438,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 13438,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 13423,   
       y2d = 2223,  
       radius = 27,  
   },  
   {   
       x2d = 13401,   
       y2d = 2301,  
       radius = 5,  
   },  
   {   
       x2d = 13416,   
       y2d = 2466,  
       radius = 20,  
   },  
   {   
       x2d = 13431,   
       y2d = 3281,  
       radius = 35,  
   },  
   {   
       x2d = 13408,   
       y2d = 3408,  
       radius = 12,  
   },  
   {   
       x2d = 13416,   
       y2d = 3516,  
       radius = 20,  
   },  
   {   
       x2d = 13438,   
       y2d = 3588,  
       radius = 42,  
   },  
   {   
       x2d = 13438,   
       y2d = 3688,  
       radius = 42,  
   },  
   {   
       x2d = 13431,   
       y2d = 3781,  
       radius = 35,  
   },  
   {   
       x2d = 13401,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 13438,   
       y2d = 4088,  
       radius = 42,  
   },  
   {   
       x2d = 13416,   
       y2d = 4216,  
       radius = 20,  
   },  
   {   
       x2d = 13408,   
       y2d = 4258,  
       radius = 12,  
   },  
   {   
       x2d = 13438,   
       y2d = 4488,  
       radius = 42,  
   },  
   {   
       x2d = 13438,   
       y2d = 4588,  
       radius = 42,  
   },  
   {   
       x2d = 13438,   
       y2d = 4688,  
       radius = 42,  
   },  
   {   
       x2d = 13401,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 13401,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 13401,   
       y2d = 5501,  
       radius = 5,  
   },  
   {   
       x2d = 13408,   
       y2d = 6858,  
       radius = 12,  
   },  
   {   
       x2d = 13401,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 13401,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 13401,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 13408,   
       y2d = 7058,  
       radius = 12,  
   },  
   {   
       x2d = 13408,   
       y2d = 7208,  
       radius = 12,  
   },  
   {   
       x2d = 13423,   
       y2d = 7773,  
       radius = 27,  
   },  
   {   
       x2d = 13401,   
       y2d = 8401,  
       radius = 5,  
   },  
   {   
       x2d = 13416,   
       y2d = 8616,  
       radius = 20,  
   },  
   {   
       x2d = 13408,   
       y2d = 8958,  
       radius = 12,  
   },  
   {   
       x2d = 13438,   
       y2d = 9388,  
       radius = 42,  
   },  
   {   
       x2d = 13401,   
       y2d = 9651,  
       radius = 5,  
   },  
   {   
       x2d = 13416,   
       y2d = 9716,  
       radius = 20,  
   },  
   {   
       x2d = 13438,   
       y2d = 9788,  
       radius = 42,  
   },  
   {   
       x2d = 13423,   
       y2d = 9873,  
       radius = 27,  
   },  
   {   
       x2d = 13423,   
       y2d = 10023,  
       radius = 27,  
   },  
   {   
       x2d = 13438,   
       y2d = 10238,  
       radius = 42,  
   },  
   {   
       x2d = 13488,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 13488,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 13488,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 13488,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 13488,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 13488,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 13451,   
       y2d = 2351,  
       radius = 5,  
   },  
   {   
       x2d = 13451,   
       y2d = 2401,  
       radius = 5,  
   },  
   {   
       x2d = 13473,   
       y2d = 2873,  
       radius = 27,  
   },  
   {   
       x2d = 13488,   
       y2d = 2988,  
       radius = 42,  
   },  
   {   
       x2d = 13466,   
       y2d = 3116,  
       radius = 20,  
   },  
   {   
       x2d = 13451,   
       y2d = 3201,  
       radius = 5,  
   },  
   {   
       x2d = 13481,   
       y2d = 3431,  
       radius = 35,  
   },  
   {   
       x2d = 13458,   
       y2d = 3908,  
       radius = 12,  
   },  
   {   
       x2d = 13458,   
       y2d = 4208,  
       radius = 12,  
   },  
   {   
       x2d = 13488,   
       y2d = 4788,  
       radius = 42,  
   },  
   {   
       x2d = 13481,   
       y2d = 4931,  
       radius = 35,  
   },  
   {   
       x2d = 13481,   
       y2d = 5031,  
       radius = 35,  
   },  
   {   
       x2d = 13451,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 13458,   
       y2d = 5458,  
       radius = 12,  
   },  
   {   
       x2d = 13458,   
       y2d = 5508,  
       radius = 12,  
   },  
   {   
       x2d = 13473,   
       y2d = 5773,  
       radius = 27,  
   },  
   {   
       x2d = 13451,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 13451,   
       y2d = 6501,  
       radius = 5,  
   },  
   {   
       x2d = 13451,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 13451,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 13451,   
       y2d = 7151,  
       radius = 5,  
   },  
   {   
       x2d = 13466,   
       y2d = 7216,  
       radius = 20,  
   },  
   {   
       x2d = 13458,   
       y2d = 8608,  
       radius = 12,  
   },  
   {   
       x2d = 13473,   
       y2d = 8723,  
       radius = 27,  
   },  
   {   
       x2d = 13451,   
       y2d = 8801,  
       radius = 5,  
   },  
   {   
       x2d = 13451,   
       y2d = 8901,  
       radius = 5,  
   },  
   {   
       x2d = 13451,   
       y2d = 8951,  
       radius = 5,  
   },  
   {   
       x2d = 13466,   
       y2d = 9216,  
       radius = 20,  
   },  
   {   
       x2d = 13488,   
       y2d = 9488,  
       radius = 42,  
   },  
   {   
       x2d = 13481,   
       y2d = 9581,  
       radius = 35,  
   },  
   {   
       x2d = 13473,   
       y2d = 9673,  
       radius = 27,  
   },  
   {   
       x2d = 13481,   
       y2d = 9881,  
       radius = 35,  
   },  
   {   
       x2d = 13458,   
       y2d = 9958,  
       radius = 12,  
   },  
   {   
       x2d = 13481,   
       y2d = 10081,  
       radius = 35,  
   },  
   {   
       x2d = 13488,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 13538,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 13538,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 13538,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 13538,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 13538,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 13538,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 13538,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 13538,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 13538,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 13538,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 13538,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 13538,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 13538,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 13538,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 13508,   
       y2d = 2408,  
       radius = 12,  
   },  
   {   
       x2d = 13501,   
       y2d = 2551,  
       radius = 5,  
   },  
   {   
       x2d = 13516,   
       y2d = 3116,  
       radius = 20,  
   },  
   {   
       x2d = 13508,   
       y2d = 3158,  
       radius = 12,  
   },  
   {   
       x2d = 13501,   
       y2d = 3201,  
       radius = 5,  
   },  
   {   
       x2d = 13538,   
       y2d = 3288,  
       radius = 42,  
   },  
   {   
       x2d = 13538,   
       y2d = 3388,  
       radius = 42,  
   },  
   {   
       x2d = 13516,   
       y2d = 3566,  
       radius = 20,  
   },  
   {   
       x2d = 13516,   
       y2d = 3616,  
       radius = 20,  
   },  
   {   
       x2d = 13516,   
       y2d = 3666,  
       radius = 20,  
   },  
   {   
       x2d = 13523,   
       y2d = 3723,  
       radius = 27,  
   },  
   {   
       x2d = 13523,   
       y2d = 3823,  
       radius = 27,  
   },  
   {   
       x2d = 13501,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 13508,   
       y2d = 3958,  
       radius = 12,  
   },  
   {   
       x2d = 13501,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 13538,   
       y2d = 4088,  
       radius = 42,  
   },  
   {   
       x2d = 13501,   
       y2d = 4201,  
       radius = 5,  
   },  
   {   
       x2d = 13501,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 13531,   
       y2d = 4531,  
       radius = 35,  
   },  
   {   
       x2d = 13538,   
       y2d = 4638,  
       radius = 42,  
   },  
   {   
       x2d = 13523,   
       y2d = 4873,  
       radius = 27,  
   },  
   {   
       x2d = 13508,   
       y2d = 5108,  
       radius = 12,  
   },  
   {   
       x2d = 13501,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 13501,   
       y2d = 5201,  
       radius = 5,  
   },  
   {   
       x2d = 13501,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 13501,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 13501,   
       y2d = 5351,  
       radius = 5,  
   },  
   {   
       x2d = 13501,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 13508,   
       y2d = 5508,  
       radius = 12,  
   },  
   {   
       x2d = 13501,   
       y2d = 5901,  
       radius = 5,  
   },  
   {   
       x2d = 13501,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 13501,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 13508,   
       y2d = 7158,  
       radius = 12,  
   },  
   {   
       x2d = 13508,   
       y2d = 7208,  
       radius = 12,  
   },  
   {   
       x2d = 13501,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 13501,   
       y2d = 7301,  
       radius = 5,  
   },  
   {   
       x2d = 13501,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 13516,   
       y2d = 8766,  
       radius = 20,  
   },  
   {   
       x2d = 13501,   
       y2d = 8901,  
       radius = 5,  
   },  
   {   
       x2d = 13501,   
       y2d = 9001,  
       radius = 5,  
   },  
   {   
       x2d = 13501,   
       y2d = 9051,  
       radius = 5,  
   },  
   {   
       x2d = 13516,   
       y2d = 9116,  
       radius = 20,  
   },  
   {   
       x2d = 13508,   
       y2d = 9158,  
       radius = 12,  
   },  
   {   
       x2d = 13508,   
       y2d = 9258,  
       radius = 12,  
   },  
   {   
       x2d = 13538,   
       y2d = 9338,  
       radius = 42,  
   },  
   {   
       x2d = 13531,   
       y2d = 9681,  
       radius = 35,  
   },  
   {   
       x2d = 13538,   
       y2d = 9838,  
       radius = 42,  
   },  
   {   
       x2d = 13501,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 13538,   
       y2d = 10188,  
       radius = 42,  
   },  
   {   
       x2d = 13573,   
       y2d = 423,  
       radius = 27,  
   },  
   {   
       x2d = 13588,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 13588,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 13588,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 13588,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 13588,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 13566,   
       y2d = 2266,  
       radius = 20,  
   },  
   {   
       x2d = 13558,   
       y2d = 2558,  
       radius = 12,  
   },  
   {   
       x2d = 13588,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 13551,   
       y2d = 2751,  
       radius = 5,  
   },  
   {   
       x2d = 13588,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 13558,   
       y2d = 3108,  
       radius = 12,  
   },  
   {   
       x2d = 13551,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 13558,   
       y2d = 3558,  
       radius = 12,  
   },  
   {   
       x2d = 13551,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 13558,   
       y2d = 4308,  
       radius = 12,  
   },  
   {   
       x2d = 13551,   
       y2d = 4401,  
       radius = 5,  
   },  
   {   
       x2d = 13581,   
       y2d = 4481,  
       radius = 35,  
   },  
   {   
       x2d = 13573,   
       y2d = 4723,  
       radius = 27,  
   },  
   {   
       x2d = 13581,   
       y2d = 4831,  
       radius = 35,  
   },  
   {   
       x2d = 13588,   
       y2d = 4938,  
       radius = 42,  
   },  
   {   
       x2d = 13588,   
       y2d = 5038,  
       radius = 42,  
   },  
   {   
       x2d = 13588,   
       y2d = 5138,  
       radius = 42,  
   },  
   {   
       x2d = 13581,   
       y2d = 5231,  
       radius = 35,  
   },  
   {   
       x2d = 13558,   
       y2d = 5358,  
       radius = 12,  
   },  
   {   
       x2d = 13551,   
       y2d = 5551,  
       radius = 5,  
   },  
   {   
       x2d = 13551,   
       y2d = 5751,  
       radius = 5,  
   },  
   {   
       x2d = 13558,   
       y2d = 5808,  
       radius = 12,  
   },  
   {   
       x2d = 13551,   
       y2d = 5851,  
       radius = 5,  
   },  
   {   
       x2d = 13551,   
       y2d = 6151,  
       radius = 5,  
   },  
   {   
       x2d = 13551,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 13551,   
       y2d = 6501,  
       radius = 5,  
   },  
   {   
       x2d = 13551,   
       y2d = 6801,  
       radius = 5,  
   },  
   {   
       x2d = 13551,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 13558,   
       y2d = 7158,  
       radius = 12,  
   },  
   {   
       x2d = 13558,   
       y2d = 7208,  
       radius = 12,  
   },  
   {   
       x2d = 13558,   
       y2d = 8458,  
       radius = 12,  
   },  
   {   
       x2d = 13551,   
       y2d = 8701,  
       radius = 5,  
   },  
   {   
       x2d = 13551,   
       y2d = 8801,  
       radius = 5,  
   },  
   {   
       x2d = 13551,   
       y2d = 9001,  
       radius = 5,  
   },  
   {   
       x2d = 13566,   
       y2d = 9166,  
       radius = 20,  
   },  
   {   
       x2d = 13588,   
       y2d = 9488,  
       radius = 42,  
   },  
   {   
       x2d = 13588,   
       y2d = 9588,  
       radius = 42,  
   },  
   {   
       x2d = 13581,   
       y2d = 9931,  
       radius = 35,  
   },  
   {   
       x2d = 13551,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 13588,   
       y2d = 10288,  
       radius = 42,  
   },  
   {   
       x2d = 13588,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 13638,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 13638,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 13638,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 13638,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 13638,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 13638,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 13638,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 13638,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 13638,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 13638,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 13638,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 13638,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 13638,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 13638,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 13638,   
       y2d = 2188,  
       radius = 42,  
   },  
   {   
       x2d = 13601,   
       y2d = 2351,  
       radius = 5,  
   },  
   {   
       x2d = 13616,   
       y2d = 2416,  
       radius = 20,  
   },  
   {   
       x2d = 13638,   
       y2d = 2488,  
       radius = 42,  
   },  
   {   
       x2d = 13638,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 13616,   
       y2d = 3066,  
       radius = 20,  
   },  
   {   
       x2d = 13608,   
       y2d = 3108,  
       radius = 12,  
   },  
   {   
       x2d = 13631,   
       y2d = 3181,  
       radius = 35,  
   },  
   {   
       x2d = 13616,   
       y2d = 3266,  
       radius = 20,  
   },  
   {   
       x2d = 13616,   
       y2d = 3366,  
       radius = 20,  
   },  
   {   
       x2d = 13608,   
       y2d = 3458,  
       radius = 12,  
   },  
   {   
       x2d = 13608,   
       y2d = 3558,  
       radius = 12,  
   },  
   {   
       x2d = 13601,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 13601,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 13601,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 13608,   
       y2d = 3808,  
       radius = 12,  
   },  
   {   
       x2d = 13601,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 13623,   
       y2d = 4023,  
       radius = 27,  
   },  
   {   
       x2d = 13608,   
       y2d = 4208,  
       radius = 12,  
   },  
   {   
       x2d = 13601,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 13601,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 13601,   
       y2d = 4351,  
       radius = 5,  
   },  
   {   
       x2d = 13608,   
       y2d = 4408,  
       radius = 12,  
   },  
   {   
       x2d = 13638,   
       y2d = 4588,  
       radius = 42,  
   },  
   {   
       x2d = 13638,   
       y2d = 4688,  
       radius = 42,  
   },  
   {   
       x2d = 13616,   
       y2d = 5316,  
       radius = 20,  
   },  
   {   
       x2d = 13608,   
       y2d = 5408,  
       radius = 12,  
   },  
   {   
       x2d = 13608,   
       y2d = 5558,  
       radius = 12,  
   },  
   {   
       x2d = 13601,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 13601,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 13601,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 13601,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 13601,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 13601,   
       y2d = 6801,  
       radius = 5,  
   },  
   {   
       x2d = 13601,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 13601,   
       y2d = 7051,  
       radius = 5,  
   },  
   {   
       x2d = 13608,   
       y2d = 7158,  
       radius = 12,  
   },  
   {   
       x2d = 13608,   
       y2d = 8458,  
       radius = 12,  
   },  
   {   
       x2d = 13608,   
       y2d = 8508,  
       radius = 12,  
   },  
   {   
       x2d = 13601,   
       y2d = 8801,  
       radius = 5,  
   },  
   {   
       x2d = 13631,   
       y2d = 8881,  
       radius = 35,  
   },  
   {   
       x2d = 13638,   
       y2d = 8988,  
       radius = 42,  
   },  
   {   
       x2d = 13616,   
       y2d = 9166,  
       radius = 20,  
   },  
   {   
       x2d = 13631,   
       y2d = 9231,  
       radius = 35,  
   },  
   {   
       x2d = 13638,   
       y2d = 9338,  
       radius = 42,  
   },  
   {   
       x2d = 13638,   
       y2d = 9688,  
       radius = 42,  
   },  
   {   
       x2d = 13623,   
       y2d = 9823,  
       radius = 27,  
   },  
   {   
       x2d = 13601,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 13601,   
       y2d = 10051,  
       radius = 5,  
   },  
   {   
       x2d = 13688,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 13688,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 13688,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 13688,   
       y2d = 1888,  
       radius = 42,  
   },  
   {   
       x2d = 13688,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 13688,   
       y2d = 2088,  
       radius = 42,  
   },  
   {   
       x2d = 13658,   
       y2d = 2358,  
       radius = 12,  
   },  
   {   
       x2d = 13658,   
       y2d = 3058,  
       radius = 12,  
   },  
   {   
       x2d = 13666,   
       y2d = 3366,  
       radius = 20,  
   },  
   {   
       x2d = 13666,   
       y2d = 3466,  
       radius = 20,  
   },  
   {   
       x2d = 13666,   
       y2d = 3816,  
       radius = 20,  
   },  
   {   
       x2d = 13666,   
       y2d = 4216,  
       radius = 20,  
   },  
   {   
       x2d = 13651,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 13651,   
       y2d = 4401,  
       radius = 5,  
   },  
   {   
       x2d = 13681,   
       y2d = 4481,  
       radius = 35,  
   },  
   {   
       x2d = 13651,   
       y2d = 4801,  
       radius = 5,  
   },  
   {   
       x2d = 13651,   
       y2d = 4851,  
       radius = 5,  
   },  
   {   
       x2d = 13688,   
       y2d = 4938,  
       radius = 42,  
   },  
   {   
       x2d = 13688,   
       y2d = 5088,  
       radius = 42,  
   },  
   {   
       x2d = 13651,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 13658,   
       y2d = 5308,  
       radius = 12,  
   },  
   {   
       x2d = 13688,   
       y2d = 5388,  
       radius = 42,  
   },  
   {   
       x2d = 13666,   
       y2d = 5516,  
       radius = 20,  
   },  
   {   
       x2d = 13651,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 13651,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 13651,   
       y2d = 6601,  
       radius = 5,  
   },  
   {   
       x2d = 13666,   
       y2d = 7216,  
       radius = 20,  
   },  
   {   
       x2d = 13651,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 13658,   
       y2d = 7958,  
       radius = 12,  
   },  
   {   
       x2d = 13673,   
       y2d = 8473,  
       radius = 27,  
   },  
   {   
       x2d = 13651,   
       y2d = 8551,  
       radius = 5,  
   },  
   {   
       x2d = 13651,   
       y2d = 8651,  
       radius = 5,  
   },  
   {   
       x2d = 13651,   
       y2d = 9101,  
       radius = 5,  
   },  
   {   
       x2d = 13688,   
       y2d = 9438,  
       radius = 42,  
   },  
   {   
       x2d = 13688,   
       y2d = 9538,  
       radius = 42,  
   },  
   {   
       x2d = 13688,   
       y2d = 9788,  
       radius = 42,  
   },  
   {   
       x2d = 13658,   
       y2d = 9958,  
       radius = 12,  
   },  
   {   
       x2d = 13651,   
       y2d = 10101,  
       radius = 5,  
   },  
   {   
       x2d = 13681,   
       y2d = 10181,  
       radius = 35,  
   },  
   {   
       x2d = 13688,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 13738,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 13738,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 13738,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 13738,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 13738,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 13738,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 13738,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 13738,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 13738,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 13738,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 13738,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 13738,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 13738,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 13738,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 13738,   
       y2d = 2188,  
       radius = 42,  
   },  
   {   
       x2d = 13716,   
       y2d = 2316,  
       radius = 20,  
   },  
   {   
       x2d = 13738,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 13738,   
       y2d = 2488,  
       radius = 42,  
   },  
   {   
       x2d = 13708,   
       y2d = 2608,  
       radius = 12,  
   },  
   {   
       x2d = 13701,   
       y2d = 2651,  
       radius = 5,  
   },  
   {   
       x2d = 13701,   
       y2d = 2701,  
       radius = 5,  
   },  
   {   
       x2d = 13738,   
       y2d = 2788,  
       radius = 42,  
   },  
   {   
       x2d = 13738,   
       y2d = 2888,  
       radius = 42,  
   },  
   {   
       x2d = 13708,   
       y2d = 3058,  
       radius = 12,  
   },  
   {   
       x2d = 13723,   
       y2d = 3173,  
       radius = 27,  
   },  
   {   
       x2d = 13716,   
       y2d = 3266,  
       radius = 20,  
   },  
   {   
       x2d = 13723,   
       y2d = 3323,  
       radius = 27,  
   },  
   {   
       x2d = 13708,   
       y2d = 3408,  
       radius = 12,  
   },  
   {   
       x2d = 13716,   
       y2d = 3466,  
       radius = 20,  
   },  
   {   
       x2d = 13708,   
       y2d = 3558,  
       radius = 12,  
   },  
   {   
       x2d = 13701,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 13708,   
       y2d = 4008,  
       radius = 12,  
   },  
   {   
       x2d = 13701,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 13723,   
       y2d = 4273,  
       radius = 27,  
   },  
   {   
       x2d = 13708,   
       y2d = 4358,  
       radius = 12,  
   },  
   {   
       x2d = 13716,   
       y2d = 4566,  
       radius = 20,  
   },  
   {   
       x2d = 13716,   
       y2d = 4616,  
       radius = 20,  
   },  
   {   
       x2d = 13723,   
       y2d = 4673,  
       radius = 27,  
   },  
   {   
       x2d = 13738,   
       y2d = 5188,  
       radius = 42,  
   },  
   {   
       x2d = 13738,   
       y2d = 5288,  
       radius = 42,  
   },  
   {   
       x2d = 13708,   
       y2d = 5508,  
       radius = 12,  
   },  
   {   
       x2d = 13701,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 13701,   
       y2d = 6001,  
       radius = 5,  
   },  
   {   
       x2d = 13701,   
       y2d = 6051,  
       radius = 5,  
   },  
   {   
       x2d = 13701,   
       y2d = 6701,  
       radius = 5,  
   },  
   {   
       x2d = 13701,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 13708,   
       y2d = 7158,  
       radius = 12,  
   },  
   {   
       x2d = 13701,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 13701,   
       y2d = 8551,  
       radius = 5,  
   },  
   {   
       x2d = 13738,   
       y2d = 8838,  
       radius = 42,  
   },  
   {   
       x2d = 13738,   
       y2d = 8938,  
       radius = 42,  
   },  
   {   
       x2d = 13701,   
       y2d = 9151,  
       radius = 5,  
   },  
   {   
       x2d = 13723,   
       y2d = 9273,  
       radius = 27,  
   },  
   {   
       x2d = 13723,   
       y2d = 9623,  
       radius = 27,  
   },  
   {   
       x2d = 13701,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 13738,   
       y2d = 10088,  
       radius = 42,  
   },  
   {   
       x2d = 13708,   
       y2d = 10258,  
       radius = 12,  
   },  
   {   
       x2d = 13788,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 13788,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 13788,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 13788,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 13788,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 13788,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 13788,   
       y2d = 2688,  
       radius = 42,  
   },  
   {   
       x2d = 13788,   
       y2d = 2988,  
       radius = 42,  
   },  
   {   
       x2d = 13766,   
       y2d = 3116,  
       radius = 20,  
   },  
   {   
       x2d = 13788,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 13751,   
       y2d = 3501,  
       radius = 5,  
   },  
   {   
       x2d = 13758,   
       y2d = 3558,  
       radius = 12,  
   },  
   {   
       x2d = 13751,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 13751,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 13751,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 13751,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 13751,   
       y2d = 3801,  
       radius = 5,  
   },  
   {   
       x2d = 13788,   
       y2d = 4288,  
       radius = 42,  
   },  
   {   
       x2d = 13751,   
       y2d = 4401,  
       radius = 5,  
   },  
   {   
       x2d = 13788,   
       y2d = 4538,  
       radius = 42,  
   },  
   {   
       x2d = 13773,   
       y2d = 4773,  
       radius = 27,  
   },  
   {   
       x2d = 13788,   
       y2d = 4888,  
       radius = 42,  
   },  
   {   
       x2d = 13788,   
       y2d = 4988,  
       radius = 42,  
   },  
   {   
       x2d = 13788,   
       y2d = 5088,  
       radius = 42,  
   },  
   {   
       x2d = 13751,   
       y2d = 5601,  
       radius = 5,  
   },  
   {   
       x2d = 13766,   
       y2d = 5666,  
       radius = 20,  
   },  
   {   
       x2d = 13751,   
       y2d = 5851,  
       radius = 5,  
   },  
   {   
       x2d = 13751,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 13751,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 13788,   
       y2d = 8338,  
       radius = 42,  
   },  
   {   
       x2d = 13751,   
       y2d = 8501,  
       radius = 5,  
   },  
   {   
       x2d = 13751,   
       y2d = 8551,  
       radius = 5,  
   },  
   {   
       x2d = 13751,   
       y2d = 8651,  
       radius = 5,  
   },  
   {   
       x2d = 13773,   
       y2d = 8723,  
       radius = 27,  
   },  
   {   
       x2d = 13788,   
       y2d = 9038,  
       radius = 42,  
   },  
   {   
       x2d = 13788,   
       y2d = 9138,  
       radius = 42,  
   },  
   {   
       x2d = 13788,   
       y2d = 9238,  
       radius = 42,  
   },  
   {   
       x2d = 13788,   
       y2d = 9338,  
       radius = 42,  
   },  
   {   
       x2d = 13751,   
       y2d = 9701,  
       radius = 5,  
   },  
   {   
       x2d = 13766,   
       y2d = 9766,  
       radius = 20,  
   },  
   {   
       x2d = 13758,   
       y2d = 9908,  
       radius = 12,  
   },  
   {   
       x2d = 13781,   
       y2d = 10181,  
       radius = 35,  
   },  
   {   
       x2d = 13751,   
       y2d = 10301,  
       radius = 5,  
   },  
   {   
       x2d = 13788,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 13838,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 13838,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 13838,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 13838,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 13838,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 13838,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 13838,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 13838,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 13838,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 13838,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 13838,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 13838,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 13838,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 13838,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 13823,   
       y2d = 2223,  
       radius = 27,  
   },  
   {   
       x2d = 13838,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 13838,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 13838,   
       y2d = 2788,  
       radius = 42,  
   },  
   {   
       x2d = 13823,   
       y2d = 3073,  
       radius = 27,  
   },  
   {   
       x2d = 13801,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 13838,   
       y2d = 3488,  
       radius = 42,  
   },  
   {   
       x2d = 13816,   
       y2d = 3766,  
       radius = 20,  
   },  
   {   
       x2d = 13808,   
       y2d = 4408,  
       radius = 12,  
   },  
   {   
       x2d = 13801,   
       y2d = 4451,  
       radius = 5,  
   },  
   {   
       x2d = 13801,   
       y2d = 4651,  
       radius = 5,  
   },  
   {   
       x2d = 13838,   
       y2d = 4788,  
       radius = 42,  
   },  
   {   
       x2d = 13838,   
       y2d = 5188,  
       radius = 42,  
   },  
   {   
       x2d = 13838,   
       y2d = 5288,  
       radius = 42,  
   },  
   {   
       x2d = 13808,   
       y2d = 5408,  
       radius = 12,  
   },  
   {   
       x2d = 13808,   
       y2d = 5558,  
       radius = 12,  
   },  
   {   
       x2d = 13831,   
       y2d = 5631,  
       radius = 35,  
   },  
   {   
       x2d = 13801,   
       y2d = 5851,  
       radius = 5,  
   },  
   {   
       x2d = 13816,   
       y2d = 7266,  
       radius = 20,  
   },  
   {   
       x2d = 13801,   
       y2d = 8001,  
       radius = 5,  
   },  
   {   
       x2d = 13838,   
       y2d = 8438,  
       radius = 42,  
   },  
   {   
       x2d = 13823,   
       y2d = 8523,  
       radius = 27,  
   },  
   {   
       x2d = 13838,   
       y2d = 8788,  
       radius = 42,  
   },  
   {   
       x2d = 13823,   
       y2d = 8923,  
       radius = 27,  
   },  
   {   
       x2d = 13823,   
       y2d = 9423,  
       radius = 27,  
   },  
   {   
       x2d = 13816,   
       y2d = 9766,  
       radius = 20,  
   },  
   {   
       x2d = 13801,   
       y2d = 9951,  
       radius = 5,  
   },  
   {   
       x2d = 13801,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 13838,   
       y2d = 10138,  
       radius = 42,  
   },  
   {   
       x2d = 13808,   
       y2d = 10258,  
       radius = 12,  
   },  
   {   
       x2d = 13888,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 13873,   
       y2d = 1173,  
       radius = 27,  
   },  
   {   
       x2d = 13888,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 13873,   
       y2d = 1773,  
       radius = 27,  
   },  
   {   
       x2d = 13881,   
       y2d = 1881,  
       radius = 35,  
   },  
   {   
       x2d = 13888,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 13851,   
       y2d = 2551,  
       radius = 5,  
   },  
   {   
       x2d = 13858,   
       y2d = 2608,  
       radius = 12,  
   },  
   {   
       x2d = 13888,   
       y2d = 2688,  
       radius = 42,  
   },  
   {   
       x2d = 13888,   
       y2d = 2888,  
       radius = 42,  
   },  
   {   
       x2d = 13873,   
       y2d = 2973,  
       radius = 27,  
   },  
   {   
       x2d = 13888,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 13866,   
       y2d = 3766,  
       radius = 20,  
   },  
   {   
       x2d = 13858,   
       y2d = 4158,  
       radius = 12,  
   },  
   {   
       x2d = 13858,   
       y2d = 4208,  
       radius = 12,  
   },  
   {   
       x2d = 13851,   
       y2d = 4601,  
       radius = 5,  
   },  
   {   
       x2d = 13866,   
       y2d = 4916,  
       radius = 20,  
   },  
   {   
       x2d = 13888,   
       y2d = 4988,  
       radius = 42,  
   },  
   {   
       x2d = 13888,   
       y2d = 5088,  
       radius = 42,  
   },  
   {   
       x2d = 13881,   
       y2d = 5381,  
       radius = 35,  
   },  
   {   
       x2d = 13888,   
       y2d = 5488,  
       radius = 42,  
   },  
   {   
       x2d = 13888,   
       y2d = 5588,  
       radius = 42,  
   },  
   {   
       x2d = 13851,   
       y2d = 5951,  
       radius = 5,  
   },  
   {   
       x2d = 13851,   
       y2d = 6251,  
       radius = 5,  
   },  
   {   
       x2d = 13851,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 13851,   
       y2d = 6701,  
       radius = 5,  
   },  
   {   
       x2d = 13851,   
       y2d = 7701,  
       radius = 5,  
   },  
   {   
       x2d = 13851,   
       y2d = 7951,  
       radius = 5,  
   },  
   {   
       x2d = 13858,   
       y2d = 8008,  
       radius = 12,  
   },  
   {   
       x2d = 13888,   
       y2d = 8338,  
       radius = 42,  
   },  
   {   
       x2d = 13873,   
       y2d = 9123,  
       radius = 27,  
   },  
   {   
       x2d = 13866,   
       y2d = 9266,  
       radius = 20,  
   },  
   {   
       x2d = 13866,   
       y2d = 9466,  
       radius = 20,  
   },  
   {   
       x2d = 13866,   
       y2d = 9616,  
       radius = 20,  
   },  
   {   
       x2d = 13858,   
       y2d = 9708,  
       radius = 12,  
   },  
   {   
       x2d = 13888,   
       y2d = 9788,  
       radius = 42,  
   },  
   {   
       x2d = 13866,   
       y2d = 10316,  
       radius = 20,  
   },  
   {   
       x2d = 13938,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 13938,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 13938,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 13938,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 13938,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 13938,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 13938,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 13938,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 13938,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 13938,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 13938,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 13938,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 13938,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 13931,   
       y2d = 1631,  
       radius = 35,  
   },  
   {   
       x2d = 13938,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 13938,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 13938,   
       y2d = 2088,  
       radius = 42,  
   },  
   {   
       x2d = 13931,   
       y2d = 2181,  
       radius = 35,  
   },  
   {   
       x2d = 13938,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 13923,   
       y2d = 2473,  
       radius = 27,  
   },  
   {   
       x2d = 13901,   
       y2d = 2551,  
       radius = 5,  
   },  
   {   
       x2d = 13938,   
       y2d = 2788,  
       radius = 42,  
   },  
   {   
       x2d = 13938,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 13901,   
       y2d = 3401,  
       radius = 5,  
   },  
   {   
       x2d = 13923,   
       y2d = 3473,  
       radius = 27,  
   },  
   {   
       x2d = 13901,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 13908,   
       y2d = 3758,  
       radius = 12,  
   },  
   {   
       x2d = 13901,   
       y2d = 3801,  
       radius = 5,  
   },  
   {   
       x2d = 13901,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 13908,   
       y2d = 4158,  
       radius = 12,  
   },  
   {   
       x2d = 13908,   
       y2d = 4258,  
       radius = 12,  
   },  
   {   
       x2d = 13901,   
       y2d = 4451,  
       radius = 5,  
   },  
   {   
       x2d = 13931,   
       y2d = 4781,  
       radius = 35,  
   },  
   {   
       x2d = 13938,   
       y2d = 5188,  
       radius = 42,  
   },  
   {   
       x2d = 13938,   
       y2d = 5288,  
       radius = 42,  
   },  
   {   
       x2d = 13931,   
       y2d = 5881,  
       radius = 35,  
   },  
   {   
       x2d = 13901,   
       y2d = 6251,  
       radius = 5,  
   },  
   {   
       x2d = 13908,   
       y2d = 7208,  
       radius = 12,  
   },  
   {   
       x2d = 13901,   
       y2d = 7751,  
       radius = 5,  
   },  
   {   
       x2d = 13901,   
       y2d = 8001,  
       radius = 5,  
   },  
   {   
       x2d = 13901,   
       y2d = 8551,  
       radius = 5,  
   },  
   {   
       x2d = 13916,   
       y2d = 8766,  
       radius = 20,  
   },  
   {   
       x2d = 13908,   
       y2d = 8908,  
       radius = 12,  
   },  
   {   
       x2d = 13908,   
       y2d = 8958,  
       radius = 12,  
   },  
   {   
       x2d = 13901,   
       y2d = 9351,  
       radius = 5,  
   },  
   {   
       x2d = 13908,   
       y2d = 9508,  
       radius = 12,  
   },  
   {   
       x2d = 13923,   
       y2d = 9573,  
       radius = 27,  
   },  
   {   
       x2d = 13931,   
       y2d = 9681,  
       radius = 35,  
   },  
   {   
       x2d = 13901,   
       y2d = 9901,  
       radius = 5,  
   },  
   {   
       x2d = 13938,   
       y2d = 9988,  
       radius = 42,  
   },  
   {   
       x2d = 13938,   
       y2d = 10088,  
       radius = 42,  
   },  
   {   
       x2d = 13901,   
       y2d = 10201,  
       radius = 5,  
   },  
   {   
       x2d = 13908,   
       y2d = 10258,  
       radius = 12,  
   },  
   {   
       x2d = 13908,   
       y2d = 10308,  
       radius = 12,  
   },  
   {   
       x2d = 13938,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 13988,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 13988,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 13988,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 13988,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 13981,   
       y2d = 2881,  
       radius = 35,  
   },  
   {   
       x2d = 13981,   
       y2d = 2981,  
       radius = 35,  
   },  
   {   
       x2d = 13981,   
       y2d = 3381,  
       radius = 35,  
   },  
   {   
       x2d = 13958,   
       y2d = 3708,  
       radius = 12,  
   },  
   {   
       x2d = 13988,   
       y2d = 4388,  
       radius = 42,  
   },  
   {   
       x2d = 13988,   
       y2d = 4538,  
       radius = 42,  
   },  
   {   
       x2d = 13988,   
       y2d = 4688,  
       radius = 42,  
   },  
   {   
       x2d = 13988,   
       y2d = 4938,  
       radius = 42,  
   },  
   {   
       x2d = 13988,   
       y2d = 5038,  
       radius = 42,  
   },  
   {   
       x2d = 13988,   
       y2d = 5438,  
       radius = 42,  
   },  
   {   
       x2d = 13966,   
       y2d = 5616,  
       radius = 20,  
   },  
   {   
       x2d = 13988,   
       y2d = 5688,  
       radius = 42,  
   },  
   {   
       x2d = 13966,   
       y2d = 5966,  
       radius = 20,  
   },  
   {   
       x2d = 13958,   
       y2d = 6008,  
       radius = 12,  
   },  
   {   
       x2d = 13958,   
       y2d = 6058,  
       radius = 12,  
   },  
   {   
       x2d = 13951,   
       y2d = 6251,  
       radius = 5,  
   },  
   {   
       x2d = 13951,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 13951,   
       y2d = 6451,  
       radius = 5,  
   },  
   {   
       x2d = 13951,   
       y2d = 6601,  
       radius = 5,  
   },  
   {   
       x2d = 13951,   
       y2d = 6801,  
       radius = 5,  
   },  
   {   
       x2d = 13951,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 13958,   
       y2d = 6958,  
       radius = 12,  
   },  
   {   
       x2d = 13951,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 13951,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 13951,   
       y2d = 7401,  
       radius = 5,  
   },  
   {   
       x2d = 13966,   
       y2d = 7966,  
       radius = 20,  
   },  
   {   
       x2d = 13951,   
       y2d = 8251,  
       radius = 5,  
   },  
   {   
       x2d = 13988,   
       y2d = 8338,  
       radius = 42,  
   },  
   {   
       x2d = 13951,   
       y2d = 8501,  
       radius = 5,  
   },  
   {   
       x2d = 13966,   
       y2d = 8716,  
       radius = 20,  
   },  
   {   
       x2d = 13958,   
       y2d = 8908,  
       radius = 12,  
   },  
   {   
       x2d = 13951,   
       y2d = 8951,  
       radius = 5,  
   },  
   {   
       x2d = 13951,   
       y2d = 9101,  
       radius = 5,  
   },  
   {   
       x2d = 13951,   
       y2d = 9151,  
       radius = 5,  
   },  
   {   
       x2d = 13958,   
       y2d = 9508,  
       radius = 12,  
   },  
   {   
       x2d = 13988,   
       y2d = 9788,  
       radius = 42,  
   },  
   {   
       x2d = 13958,   
       y2d = 10208,  
       radius = 12,  
   },  
   {   
       x2d = 13951,   
       y2d = 10301,  
       radius = 5,  
   },  
   {   
       x2d = 14038,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 14016,   
       y2d = 2366,  
       radius = 20,  
   },  
   {   
       x2d = 14023,   
       y2d = 2423,  
       radius = 27,  
   },  
   {   
       x2d = 14038,   
       y2d = 2788,  
       radius = 42,  
   },  
   {   
       x2d = 14016,   
       y2d = 3066,  
       radius = 20,  
   },  
   {   
       x2d = 14038,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 14008,   
       y2d = 3308,  
       radius = 12,  
   },  
   {   
       x2d = 14001,   
       y2d = 3451,  
       radius = 5,  
   },  
   {   
       x2d = 14001,   
       y2d = 3551,  
       radius = 5,  
   },  
   {   
       x2d = 14008,   
       y2d = 3608,  
       radius = 12,  
   },  
   {   
       x2d = 14001,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 14001,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 14001,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 14001,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 14001,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 14031,   
       y2d = 5131,  
       radius = 35,  
   },  
   {   
       x2d = 14038,   
       y2d = 5238,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 5338,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 5538,  
       radius = 42,  
   },  
   {   
       x2d = 14001,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 14008,   
       y2d = 5858,  
       radius = 12,  
   },  
   {   
       x2d = 14016,   
       y2d = 5916,  
       radius = 20,  
   },  
   {   
       x2d = 14001,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 14001,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 14001,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 14001,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 14001,   
       y2d = 7351,  
       radius = 5,  
   },  
   {   
       x2d = 14001,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 14008,   
       y2d = 7958,  
       radius = 12,  
   },  
   {   
       x2d = 14001,   
       y2d = 8251,  
       radius = 5,  
   },  
   {   
       x2d = 14008,   
       y2d = 8458,  
       radius = 12,  
   },  
   {   
       x2d = 14008,   
       y2d = 8658,  
       radius = 12,  
   },  
   {   
       x2d = 14016,   
       y2d = 8916,  
       radius = 20,  
   },  
   {   
       x2d = 14023,   
       y2d = 9073,  
       radius = 27,  
   },  
   {   
       x2d = 14008,   
       y2d = 9308,  
       radius = 12,  
   },  
   {   
       x2d = 14038,   
       y2d = 9438,  
       radius = 42,  
   },  
   {   
       x2d = 14001,   
       y2d = 9601,  
       radius = 5,  
   },  
   {   
       x2d = 14023,   
       y2d = 9873,  
       radius = 27,  
   },  
   {   
       x2d = 14031,   
       y2d = 9931,  
       radius = 35,  
   },  
   {   
       x2d = 14038,   
       y2d = 10088,  
       radius = 42,  
   },  
   {   
       x2d = 14038,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 14088,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 14088,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 14088,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 14088,   
       y2d = 1888,  
       radius = 42,  
   },  
   {   
       x2d = 14088,   
       y2d = 2588,  
       radius = 42,  
   },  
   {   
       x2d = 14088,   
       y2d = 2688,  
       radius = 42,  
   },  
   {   
       x2d = 14088,   
       y2d = 2888,  
       radius = 42,  
   },  
   {   
       x2d = 14088,   
       y2d = 2988,  
       radius = 42,  
   },  
   {   
       x2d = 14088,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 14081,   
       y2d = 3481,  
       radius = 35,  
   },  
   {   
       x2d = 14051,   
       y2d = 3551,  
       radius = 5,  
   },  
   {   
       x2d = 14066,   
       y2d = 3616,  
       radius = 20,  
   },  
   {   
       x2d = 14058,   
       y2d = 3658,  
       radius = 12,  
   },  
   {   
       x2d = 14051,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 14088,   
       y2d = 4288,  
       radius = 42,  
   },  
   {   
       x2d = 14088,   
       y2d = 4388,  
       radius = 42,  
   },  
   {   
       x2d = 14088,   
       y2d = 4488,  
       radius = 42,  
   },  
   {   
       x2d = 14088,   
       y2d = 4588,  
       radius = 42,  
   },  
   {   
       x2d = 14081,   
       y2d = 4831,  
       radius = 35,  
   },  
   {   
       x2d = 14088,   
       y2d = 4938,  
       radius = 42,  
   },  
   {   
       x2d = 14088,   
       y2d = 5038,  
       radius = 42,  
   },  
   {   
       x2d = 14088,   
       y2d = 5688,  
       radius = 42,  
   },  
   {   
       x2d = 14088,   
       y2d = 5888,  
       radius = 42,  
   },  
   {   
       x2d = 14051,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 14058,   
       y2d = 6508,  
       radius = 12,  
   },  
   {   
       x2d = 14051,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 14051,   
       y2d = 7051,  
       radius = 5,  
   },  
   {   
       x2d = 14051,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 14051,   
       y2d = 7151,  
       radius = 5,  
   },  
   {   
       x2d = 14073,   
       y2d = 8323,  
       radius = 27,  
   },  
   {   
       x2d = 14066,   
       y2d = 8466,  
       radius = 20,  
   },  
   {   
       x2d = 14066,   
       y2d = 8966,  
       radius = 20,  
   },  
   {   
       x2d = 14088,   
       y2d = 9088,  
       radius = 42,  
   },  
   {   
       x2d = 14058,   
       y2d = 9258,  
       radius = 12,  
   },  
   {   
       x2d = 14051,   
       y2d = 9301,  
       radius = 5,  
   },  
   {   
       x2d = 14073,   
       y2d = 9523,  
       radius = 27,  
   },  
   {   
       x2d = 14088,   
       y2d = 9788,  
       radius = 42,  
   },  
   {   
       x2d = 14066,   
       y2d = 10216,  
       radius = 20,  
   },  
   {   
       x2d = 14138,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 14138,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 14138,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 14138,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 14138,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 14138,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 14138,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 14138,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 14138,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 14138,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 14138,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 14138,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 14138,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 14131,   
       y2d = 1731,  
       radius = 35,  
   },  
   {   
       x2d = 14138,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 14138,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 14123,   
       y2d = 2223,  
       radius = 27,  
   },  
   {   
       x2d = 14101,   
       y2d = 2301,  
       radius = 5,  
   },  
   {   
       x2d = 14138,   
       y2d = 2788,  
       radius = 42,  
   },  
   {   
       x2d = 14123,   
       y2d = 3323,  
       radius = 27,  
   },  
   {   
       x2d = 14101,   
       y2d = 3401,  
       radius = 5,  
   },  
   {   
       x2d = 14101,   
       y2d = 3551,  
       radius = 5,  
   },  
   {   
       x2d = 14108,   
       y2d = 3608,  
       radius = 12,  
   },  
   {   
       x2d = 14108,   
       y2d = 3708,  
       radius = 12,  
   },  
   {   
       x2d = 14101,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 14101,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 14101,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 14101,   
       y2d = 4751,  
       radius = 5,  
   },  
   {   
       x2d = 14131,   
       y2d = 5181,  
       radius = 35,  
   },  
   {   
       x2d = 14138,   
       y2d = 5288,  
       radius = 42,  
   },  
   {   
       x2d = 14138,   
       y2d = 5388,  
       radius = 42,  
   },  
   {   
       x2d = 14138,   
       y2d = 5488,  
       radius = 42,  
   },  
   {   
       x2d = 14123,   
       y2d = 5573,  
       radius = 27,  
   },  
   {   
       x2d = 14101,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 14101,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 14101,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 14101,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 14101,   
       y2d = 7151,  
       radius = 5,  
   },  
   {   
       x2d = 14101,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 14108,   
       y2d = 7308,  
       radius = 12,  
   },  
   {   
       x2d = 14108,   
       y2d = 7358,  
       radius = 12,  
   },  
   {   
       x2d = 14101,   
       y2d = 7951,  
       radius = 5,  
   },  
   {   
       x2d = 14116,   
       y2d = 8266,  
       radius = 20,  
   },  
   {   
       x2d = 14138,   
       y2d = 8338,  
       radius = 42,  
   },  
   {   
       x2d = 14108,   
       y2d = 8558,  
       radius = 12,  
   },  
   {   
       x2d = 14116,   
       y2d = 8816,  
       radius = 20,  
   },  
   {   
       x2d = 14123,   
       y2d = 8873,  
       radius = 27,  
   },  
   {   
       x2d = 14116,   
       y2d = 9216,  
       radius = 20,  
   },  
   {   
       x2d = 14108,   
       y2d = 9258,  
       radius = 12,  
   },  
   {   
       x2d = 14138,   
       y2d = 9338,  
       radius = 42,  
   },  
   {   
       x2d = 14131,   
       y2d = 9431,  
       radius = 35,  
   },  
   {   
       x2d = 14131,   
       y2d = 9531,  
       radius = 35,  
   },  
   {   
       x2d = 14123,   
       y2d = 9623,  
       radius = 27,  
   },  
   {   
       x2d = 14101,   
       y2d = 9901,  
       radius = 5,  
   },  
   {   
       x2d = 14101,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 14138,   
       y2d = 10088,  
       radius = 42,  
   },  
   {   
       x2d = 14131,   
       y2d = 10181,  
       radius = 35,  
   },  
   {   
       x2d = 14138,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 14188,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 14188,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 14188,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 14188,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 14188,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 14188,   
       y2d = 2588,  
       radius = 42,  
   },  
   {   
       x2d = 14188,   
       y2d = 2688,  
       radius = 42,  
   },  
   {   
       x2d = 14188,   
       y2d = 2888,  
       radius = 42,  
   },  
   {   
       x2d = 14188,   
       y2d = 2988,  
       radius = 42,  
   },  
   {   
       x2d = 14188,   
       y2d = 3188,  
       radius = 42,  
   },  
   {   
       x2d = 14151,   
       y2d = 3451,  
       radius = 5,  
   },  
   {   
       x2d = 14173,   
       y2d = 3523,  
       radius = 27,  
   },  
   {   
       x2d = 14188,   
       y2d = 4288,  
       radius = 42,  
   },  
   {   
       x2d = 14188,   
       y2d = 4388,  
       radius = 42,  
   },  
   {   
       x2d = 14173,   
       y2d = 4473,  
       radius = 27,  
   },  
   {   
       x2d = 14166,   
       y2d = 4566,  
       radius = 20,  
   },  
   {   
       x2d = 14158,   
       y2d = 4758,  
       radius = 12,  
   },  
   {   
       x2d = 14181,   
       y2d = 4831,  
       radius = 35,  
   },  
   {   
       x2d = 14188,   
       y2d = 4938,  
       radius = 42,  
   },  
   {   
       x2d = 14181,   
       y2d = 5031,  
       radius = 35,  
   },  
   {   
       x2d = 14181,   
       y2d = 5631,  
       radius = 35,  
   },  
   {   
       x2d = 14173,   
       y2d = 5723,  
       radius = 27,  
   },  
   {   
       x2d = 14151,   
       y2d = 5951,  
       radius = 5,  
   },  
   {   
       x2d = 14151,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 14151,   
       y2d = 6451,  
       radius = 5,  
   },  
   {   
       x2d = 14158,   
       y2d = 6858,  
       radius = 12,  
   },  
   {   
       x2d = 14151,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 14151,   
       y2d = 7151,  
       radius = 5,  
   },  
   {   
       x2d = 14151,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 14158,   
       y2d = 7508,  
       radius = 12,  
   },  
   {   
       x2d = 14151,   
       y2d = 7951,  
       radius = 5,  
   },  
   {   
       x2d = 14151,   
       y2d = 8451,  
       radius = 5,  
   },  
   {   
       x2d = 14151,   
       y2d = 8551,  
       radius = 5,  
   },  
   {   
       x2d = 14166,   
       y2d = 8916,  
       radius = 20,  
   },  
   {   
       x2d = 14158,   
       y2d = 8958,  
       radius = 12,  
   },  
   {   
       x2d = 14173,   
       y2d = 9023,  
       radius = 27,  
   },  
   {   
       x2d = 14166,   
       y2d = 9116,  
       radius = 20,  
   },  
   {   
       x2d = 14188,   
       y2d = 9738,  
       radius = 42,  
   },  
   {   
       x2d = 14173,   
       y2d = 9823,  
       radius = 27,  
   },  
   {   
       x2d = 14173,   
       y2d = 9973,  
       radius = 27,  
   },  
   {   
       x2d = 14238,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 14238,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 14238,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 14238,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 14238,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 14238,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 14238,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 14238,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 14238,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 14238,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 14238,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 14238,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 14238,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 14238,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 14238,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 14223,   
       y2d = 2123,  
       radius = 27,  
   },  
   {   
       x2d = 14201,   
       y2d = 2251,  
       radius = 5,  
   },  
   {   
       x2d = 14238,   
       y2d = 2488,  
       radius = 42,  
   },  
   {   
       x2d = 14238,   
       y2d = 2788,  
       radius = 42,  
   },  
   {   
       x2d = 14223,   
       y2d = 3273,  
       radius = 27,  
   },  
   {   
       x2d = 14238,   
       y2d = 3388,  
       radius = 42,  
   },  
   {   
       x2d = 14231,   
       y2d = 3481,  
       radius = 35,  
   },  
   {   
       x2d = 14208,   
       y2d = 3608,  
       radius = 12,  
   },  
   {   
       x2d = 14201,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 14231,   
       y2d = 4781,  
       radius = 35,  
   },  
   {   
       x2d = 14238,   
       y2d = 5338,  
       radius = 42,  
   },  
   {   
       x2d = 14231,   
       y2d = 5481,  
       radius = 35,  
   },  
   {   
       x2d = 14223,   
       y2d = 5573,  
       radius = 27,  
   },  
   {   
       x2d = 14201,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 14201,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 14201,   
       y2d = 6701,  
       radius = 5,  
   },  
   {   
       x2d = 14201,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 14201,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 14201,   
       y2d = 7351,  
       radius = 5,  
   },  
   {   
       x2d = 14201,   
       y2d = 7501,  
       radius = 5,  
   },  
   {   
       x2d = 14201,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 14201,   
       y2d = 7801,  
       radius = 5,  
   },  
   {   
       x2d = 14208,   
       y2d = 7858,  
       radius = 12,  
   },  
   {   
       x2d = 14201,   
       y2d = 7951,  
       radius = 5,  
   },  
   {   
       x2d = 14208,   
       y2d = 8258,  
       radius = 12,  
   },  
   {   
       x2d = 14216,   
       y2d = 8316,  
       radius = 20,  
   },  
   {   
       x2d = 14238,   
       y2d = 8388,  
       radius = 42,  
   },  
   {   
       x2d = 14238,   
       y2d = 8488,  
       radius = 42,  
   },  
   {   
       x2d = 14201,   
       y2d = 8601,  
       radius = 5,  
   },  
   {   
       x2d = 14223,   
       y2d = 8923,  
       radius = 27,  
   },  
   {   
       x2d = 14231,   
       y2d = 9031,  
       radius = 35,  
   },  
   {   
       x2d = 14216,   
       y2d = 9116,  
       radius = 20,  
   },  
   {   
       x2d = 14231,   
       y2d = 9181,  
       radius = 35,  
   },  
   {   
       x2d = 14238,   
       y2d = 9288,  
       radius = 42,  
   },  
   {   
       x2d = 14238,   
       y2d = 9488,  
       radius = 42,  
   },  
   {   
       x2d = 14238,   
       y2d = 9588,  
       radius = 42,  
   },  
   {   
       x2d = 14238,   
       y2d = 10088,  
       radius = 42,  
   },  
   {   
       x2d = 14201,   
       y2d = 10201,  
       radius = 5,  
   },  
   {   
       x2d = 14216,   
       y2d = 10266,  
       radius = 20,  
   },  
   {   
       x2d = 14216,   
       y2d = 10316,  
       radius = 20,  
   },  
   {   
       x2d = 14238,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 14288,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 14288,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 14288,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 14288,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 14288,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 14251,   
       y2d = 2351,  
       radius = 5,  
   },  
   {   
       x2d = 14288,   
       y2d = 2588,  
       radius = 42,  
   },  
   {   
       x2d = 14273,   
       y2d = 2673,  
       radius = 27,  
   },  
   {   
       x2d = 14288,   
       y2d = 2888,  
       radius = 42,  
   },  
   {   
       x2d = 14273,   
       y2d = 3123,  
       radius = 27,  
   },  
   {   
       x2d = 14288,   
       y2d = 3188,  
       radius = 42,  
   },  
   {   
       x2d = 14251,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 14288,   
       y2d = 4288,  
       radius = 42,  
   },  
   {   
       x2d = 14288,   
       y2d = 4388,  
       radius = 42,  
   },  
   {   
       x2d = 14258,   
       y2d = 4658,  
       radius = 12,  
   },  
   {   
       x2d = 14266,   
       y2d = 4866,  
       radius = 20,  
   },  
   {   
       x2d = 14273,   
       y2d = 4923,  
       radius = 27,  
   },  
   {   
       x2d = 14251,   
       y2d = 5001,  
       radius = 5,  
   },  
   {   
       x2d = 14288,   
       y2d = 5138,  
       radius = 42,  
   },  
   {   
       x2d = 14266,   
       y2d = 5666,  
       radius = 20,  
   },  
   {   
       x2d = 14258,   
       y2d = 5758,  
       radius = 12,  
   },  
   {   
       x2d = 14251,   
       y2d = 6101,  
       radius = 5,  
   },  
   {   
       x2d = 14251,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 14251,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 14251,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 14251,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 14251,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 14251,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 14251,   
       y2d = 7501,  
       radius = 5,  
   },  
   {   
       x2d = 14273,   
       y2d = 8223,  
       radius = 27,  
   },  
   {   
       x2d = 14251,   
       y2d = 8601,  
       radius = 5,  
   },  
   {   
       x2d = 14281,   
       y2d = 8981,  
       radius = 35,  
   },  
   {   
       x2d = 14288,   
       y2d = 9688,  
       radius = 42,  
   },  
   {   
       x2d = 14288,   
       y2d = 9788,  
       radius = 42,  
   },  
   {   
       x2d = 14288,   
       y2d = 9888,  
       radius = 42,  
   },  
   {   
       x2d = 14288,   
       y2d = 9988,  
       radius = 42,  
   },  
   {   
       x2d = 14266,   
       y2d = 10266,  
       radius = 20,  
   },  
   {   
       x2d = 14338,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 14338,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 14338,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 14338,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 14338,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 14338,   
       y2d = 588,  
       radius = 42,  
   },  
   {   
       x2d = 14338,   
       y2d = 688,  
       radius = 42,  
   },  
   {   
       x2d = 14331,   
       y2d = 781,  
       radius = 35,  
   },  
   {   
       x2d = 14338,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 14338,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 14338,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 14338,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 14338,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 14338,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 14323,   
       y2d = 2173,  
       radius = 27,  
   },  
   {   
       x2d = 14338,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 14338,   
       y2d = 2488,  
       radius = 42,  
   },  
   {   
       x2d = 14316,   
       y2d = 2766,  
       radius = 20,  
   },  
   {   
       x2d = 14338,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 14338,   
       y2d = 3288,  
       radius = 42,  
   },  
   {   
       x2d = 14338,   
       y2d = 3388,  
       radius = 42,  
   },  
   {   
       x2d = 14301,   
       y2d = 3501,  
       radius = 5,  
   },  
   {   
       x2d = 14301,   
       y2d = 3551,  
       radius = 5,  
   },  
   {   
       x2d = 14323,   
       y2d = 3623,  
       radius = 27,  
   },  
   {   
       x2d = 14301,   
       y2d = 3801,  
       radius = 5,  
   },  
   {   
       x2d = 14301,   
       y2d = 4201,  
       radius = 5,  
   },  
   {   
       x2d = 14331,   
       y2d = 4731,  
       radius = 35,  
   },  
   {   
       x2d = 14301,   
       y2d = 4801,  
       radius = 5,  
   },  
   {   
       x2d = 14308,   
       y2d = 5258,  
       radius = 12,  
   },  
   {   
       x2d = 14316,   
       y2d = 5316,  
       radius = 20,  
   },  
   {   
       x2d = 14338,   
       y2d = 5388,  
       radius = 42,  
   },  
   {   
       x2d = 14301,   
       y2d = 5501,  
       radius = 5,  
   },  
   {   
       x2d = 14308,   
       y2d = 5558,  
       radius = 12,  
   },  
   {   
       x2d = 14316,   
       y2d = 5616,  
       radius = 20,  
   },  
   {   
       x2d = 14308,   
       y2d = 5708,  
       radius = 12,  
   },  
   {   
       x2d = 14308,   
       y2d = 5758,  
       radius = 12,  
   },  
   {   
       x2d = 14301,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 14301,   
       y2d = 6101,  
       radius = 5,  
   },  
   {   
       x2d = 14301,   
       y2d = 6701,  
       radius = 5,  
   },  
   {   
       x2d = 14301,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 14301,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 14301,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 14301,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 14301,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 14301,   
       y2d = 7051,  
       radius = 5,  
   },  
   {   
       x2d = 14316,   
       y2d = 8266,  
       radius = 20,  
   },  
   {   
       x2d = 14308,   
       y2d = 8308,  
       radius = 12,  
   },  
   {   
       x2d = 14331,   
       y2d = 8381,  
       radius = 35,  
   },  
   {   
       x2d = 14338,   
       y2d = 8488,  
       radius = 42,  
   },  
   {   
       x2d = 14316,   
       y2d = 8816,  
       radius = 20,  
   },  
   {   
       x2d = 14316,   
       y2d = 8916,  
       radius = 20,  
   },  
   {   
       x2d = 14338,   
       y2d = 9138,  
       radius = 42,  
   },  
   {   
       x2d = 14338,   
       y2d = 9238,  
       radius = 42,  
   },  
   {   
       x2d = 14331,   
       y2d = 9331,  
       radius = 35,  
   },  
   {   
       x2d = 14301,   
       y2d = 9401,  
       radius = 5,  
   },  
   {   
       x2d = 14338,   
       y2d = 9488,  
       radius = 42,  
   },  
   {   
       x2d = 14338,   
       y2d = 9588,  
       radius = 42,  
   },  
   {   
       x2d = 14338,   
       y2d = 10088,  
       radius = 42,  
   },  
   {   
       x2d = 14331,   
       y2d = 10281,  
       radius = 35,  
   },  
   {   
       x2d = 14338,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 14388,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 14388,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 14388,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 14388,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 14388,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 14373,   
       y2d = 2573,  
       radius = 27,  
   },  
   {   
       x2d = 14373,   
       y2d = 2773,  
       radius = 27,  
   },  
   {   
       x2d = 14388,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 14388,   
       y2d = 3688,  
       radius = 42,  
   },  
   {   
       x2d = 14381,   
       y2d = 3781,  
       radius = 35,  
   },  
   {   
       x2d = 14351,   
       y2d = 3851,  
       radius = 5,  
   },  
   {   
       x2d = 14351,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 14388,   
       y2d = 4238,  
       radius = 42,  
   },  
   {   
       x2d = 14388,   
       y2d = 4338,  
       radius = 42,  
   },  
   {   
       x2d = 14366,   
       y2d = 4816,  
       radius = 20,  
   },  
   {   
       x2d = 14351,   
       y2d = 4901,  
       radius = 5,  
   },  
   {   
       x2d = 14366,   
       y2d = 5066,  
       radius = 20,  
   },  
   {   
       x2d = 14388,   
       y2d = 5138,  
       radius = 42,  
   },  
   {   
       x2d = 14388,   
       y2d = 5238,  
       radius = 42,  
   },  
   {   
       x2d = 14373,   
       y2d = 5473,  
       radius = 27,  
   },  
   {   
       x2d = 14351,   
       y2d = 5651,  
       radius = 5,  
   },  
   {   
       x2d = 14351,   
       y2d = 5701,  
       radius = 5,  
   },  
   {   
       x2d = 14351,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 14351,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 14351,   
       y2d = 6801,  
       radius = 5,  
   },  
   {   
       x2d = 14351,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 14358,   
       y2d = 6958,  
       radius = 12,  
   },  
   {   
       x2d = 14351,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 14351,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 14351,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 14358,   
       y2d = 8208,  
       radius = 12,  
   },  
   {   
       x2d = 14351,   
       y2d = 8651,  
       radius = 5,  
   },  
   {   
       x2d = 14366,   
       y2d = 8716,  
       radius = 20,  
   },  
   {   
       x2d = 14351,   
       y2d = 8851,  
       radius = 5,  
   },  
   {   
       x2d = 14358,   
       y2d = 8958,  
       radius = 12,  
   },  
   {   
       x2d = 14351,   
       y2d = 9001,  
       radius = 5,  
   },  
   {   
       x2d = 14351,   
       y2d = 9051,  
       radius = 5,  
   },  
   {   
       x2d = 14388,   
       y2d = 9688,  
       radius = 42,  
   },  
   {   
       x2d = 14366,   
       y2d = 9966,  
       radius = 20,  
   },  
   {   
       x2d = 14388,   
       y2d = 10188,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 14401,   
       y2d = 2201,  
       radius = 5,  
   },  
   {   
       x2d = 14431,   
       y2d = 2281,  
       radius = 35,  
   },  
   {   
       x2d = 14408,   
       y2d = 2408,  
       radius = 12,  
   },  
   {   
       x2d = 14416,   
       y2d = 2516,  
       radius = 20,  
   },  
   {   
       x2d = 14438,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 14408,   
       y2d = 3458,  
       radius = 12,  
   },  
   {   
       x2d = 14401,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 14401,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 14401,   
       y2d = 4751,  
       radius = 5,  
   },  
   {   
       x2d = 14401,   
       y2d = 5001,  
       radius = 5,  
   },  
   {   
       x2d = 14438,   
       y2d = 5388,  
       radius = 42,  
   },  
   {   
       x2d = 14401,   
       y2d = 5551,  
       radius = 5,  
   },  
   {   
       x2d = 14401,   
       y2d = 5601,  
       radius = 5,  
   },  
   {   
       x2d = 14401,   
       y2d = 5701,  
       radius = 5,  
   },  
   {   
       x2d = 14401,   
       y2d = 5751,  
       radius = 5,  
   },  
   {   
       x2d = 14401,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 14401,   
       y2d = 6401,  
       radius = 5,  
   },  
   {   
       x2d = 14408,   
       y2d = 6908,  
       radius = 12,  
   },  
   {   
       x2d = 14401,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 14416,   
       y2d = 7066,  
       radius = 20,  
   },  
   {   
       x2d = 14408,   
       y2d = 7158,  
       radius = 12,  
   },  
   {   
       x2d = 14408,   
       y2d = 7308,  
       radius = 12,  
   },  
   {   
       x2d = 14401,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 14438,   
       y2d = 8438,  
       radius = 42,  
   },  
   {   
       x2d = 14423,   
       y2d = 8523,  
       radius = 27,  
   },  
   {   
       x2d = 14416,   
       y2d = 8666,  
       radius = 20,  
   },  
   {   
       x2d = 14416,   
       y2d = 8766,  
       radius = 20,  
   },  
   {   
       x2d = 14416,   
       y2d = 8966,  
       radius = 20,  
   },  
   {   
       x2d = 14408,   
       y2d = 9058,  
       radius = 12,  
   },  
   {   
       x2d = 14438,   
       y2d = 9238,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 9338,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 9438,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 9588,  
       radius = 42,  
   },  
   {   
       x2d = 14401,   
       y2d = 9901,  
       radius = 5,  
   },  
   {   
       x2d = 14416,   
       y2d = 9966,  
       radius = 20,  
   },  
   {   
       x2d = 14438,   
       y2d = 10088,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 10288,  
       radius = 42,  
   },  
   {   
       x2d = 14438,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 14488,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 14488,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 14488,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 14488,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 14488,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 14488,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 14458,   
       y2d = 2158,  
       radius = 12,  
   },  
   {   
       x2d = 14451,   
       y2d = 2401,  
       radius = 5,  
   },  
   {   
       x2d = 14488,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 14488,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 14481,   
       y2d = 3431,  
       radius = 35,  
   },  
   {   
       x2d = 14488,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 14451,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 14451,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 14488,   
       y2d = 4188,  
       radius = 42,  
   },  
   {   
       x2d = 14488,   
       y2d = 4288,  
       radius = 42,  
   },  
   {   
       x2d = 14488,   
       y2d = 4388,  
       radius = 42,  
   },  
   {   
       x2d = 14451,   
       y2d = 4651,  
       radius = 5,  
   },  
   {   
       x2d = 14451,   
       y2d = 4701,  
       radius = 5,  
   },  
   {   
       x2d = 14451,   
       y2d = 4851,  
       radius = 5,  
   },  
   {   
       x2d = 14473,   
       y2d = 5023,  
       radius = 27,  
   },  
   {   
       x2d = 14488,   
       y2d = 5088,  
       radius = 42,  
   },  
   {   
       x2d = 14473,   
       y2d = 5173,  
       radius = 27,  
   },  
   {   
       x2d = 14488,   
       y2d = 5238,  
       radius = 42,  
   },  
   {   
       x2d = 14451,   
       y2d = 5601,  
       radius = 5,  
   },  
   {   
       x2d = 14451,   
       y2d = 5651,  
       radius = 5,  
   },  
   {   
       x2d = 14451,   
       y2d = 5701,  
       radius = 5,  
   },  
   {   
       x2d = 14466,   
       y2d = 5766,  
       radius = 20,  
   },  
   {   
       x2d = 14466,   
       y2d = 5816,  
       radius = 20,  
   },  
   {   
       x2d = 14458,   
       y2d = 6408,  
       radius = 12,  
   },  
   {   
       x2d = 14451,   
       y2d = 6701,  
       radius = 5,  
   },  
   {   
       x2d = 14451,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 14451,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 14458,   
       y2d = 7058,  
       radius = 12,  
   },  
   {   
       x2d = 14451,   
       y2d = 8051,  
       radius = 5,  
   },  
   {   
       x2d = 14488,   
       y2d = 8538,  
       radius = 42,  
   },  
   {   
       x2d = 14488,   
       y2d = 8638,  
       radius = 42,  
   },  
   {   
       x2d = 14451,   
       y2d = 8801,  
       radius = 5,  
   },  
   {   
       x2d = 14458,   
       y2d = 8908,  
       radius = 12,  
   },  
   {   
       x2d = 14488,   
       y2d = 8988,  
       radius = 42,  
   },  
   {   
       x2d = 14488,   
       y2d = 9138,  
       radius = 42,  
   },  
   {   
       x2d = 14458,   
       y2d = 9808,  
       radius = 12,  
   },  
   {   
       x2d = 14451,   
       y2d = 9851,  
       radius = 5,  
   },  
   {   
       x2d = 14488,   
       y2d = 9938,  
       radius = 42,  
   },  
   {   
       x2d = 14488,   
       y2d = 10188,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 14508,   
       y2d = 2158,  
       radius = 12,  
   },  
   {   
       x2d = 14501,   
       y2d = 2251,  
       radius = 5,  
   },  
   {   
       x2d = 14538,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 14531,   
       y2d = 3181,  
       radius = 35,  
   },  
   {   
       x2d = 14538,   
       y2d = 3288,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 3388,  
       radius = 42,  
   },  
   {   
       x2d = 14516,   
       y2d = 3516,  
       radius = 20,  
   },  
   {   
       x2d = 14523,   
       y2d = 3823,  
       radius = 27,  
   },  
   {   
       x2d = 14508,   
       y2d = 3908,  
       radius = 12,  
   },  
   {   
       x2d = 14501,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 14531,   
       y2d = 4831,  
       radius = 35,  
   },  
   {   
       x2d = 14501,   
       y2d = 4951,  
       radius = 5,  
   },  
   {   
       x2d = 14523,   
       y2d = 5423,  
       radius = 27,  
   },  
   {   
       x2d = 14531,   
       y2d = 5481,  
       radius = 35,  
   },  
   {   
       x2d = 14508,   
       y2d = 5558,  
       radius = 12,  
   },  
   {   
       x2d = 14501,   
       y2d = 5701,  
       radius = 5,  
   },  
   {   
       x2d = 14508,   
       y2d = 6758,  
       radius = 12,  
   },  
   {   
       x2d = 14501,   
       y2d = 6801,  
       radius = 5,  
   },  
   {   
       x2d = 14508,   
       y2d = 6858,  
       radius = 12,  
   },  
   {   
       x2d = 14501,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 14508,   
       y2d = 7058,  
       radius = 12,  
   },  
   {   
       x2d = 14501,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 14501,   
       y2d = 8051,  
       radius = 5,  
   },  
   {   
       x2d = 14508,   
       y2d = 8158,  
       radius = 12,  
   },  
   {   
       x2d = 14523,   
       y2d = 8423,  
       radius = 27,  
   },  
   {   
       x2d = 14501,   
       y2d = 8751,  
       radius = 5,  
   },  
   {   
       x2d = 14516,   
       y2d = 8816,  
       radius = 20,  
   },  
   {   
       x2d = 14508,   
       y2d = 8858,  
       radius = 12,  
   },  
   {   
       x2d = 14501,   
       y2d = 8901,  
       radius = 5,  
   },  
   {   
       x2d = 14538,   
       y2d = 9238,  
       radius = 42,  
   },  
   {   
       x2d = 14516,   
       y2d = 9516,  
       radius = 20,  
   },  
   {   
       x2d = 14538,   
       y2d = 9588,  
       radius = 42,  
   },  
   {   
       x2d = 14501,   
       y2d = 9701,  
       radius = 5,  
   },  
   {   
       x2d = 14538,   
       y2d = 10038,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 10288,  
       radius = 42,  
   },  
   {   
       x2d = 14538,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 14588,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 14588,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 14588,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 14588,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 14588,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 14581,   
       y2d = 1881,  
       radius = 35,  
   },  
   {   
       x2d = 14573,   
       y2d = 2023,  
       radius = 27,  
   },  
   {   
       x2d = 14588,   
       y2d = 2188,  
       radius = 42,  
   },  
   {   
       x2d = 14588,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 14588,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 14588,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 14573,   
       y2d = 3523,  
       radius = 27,  
   },  
   {   
       x2d = 14588,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 14588,   
       y2d = 3788,  
       radius = 42,  
   },  
   {   
       x2d = 14566,   
       y2d = 4216,  
       radius = 20,  
   },  
   {   
       x2d = 14581,   
       y2d = 4281,  
       radius = 35,  
   },  
   {   
       x2d = 14551,   
       y2d = 4701,  
       radius = 5,  
   },  
   {   
       x2d = 14558,   
       y2d = 4758,  
       radius = 12,  
   },  
   {   
       x2d = 14588,   
       y2d = 4988,  
       radius = 42,  
   },  
   {   
       x2d = 14588,   
       y2d = 5088,  
       radius = 42,  
   },  
   {   
       x2d = 14581,   
       y2d = 5181,  
       radius = 35,  
   },  
   {   
       x2d = 14581,   
       y2d = 5281,  
       radius = 35,  
   },  
   {   
       x2d = 14558,   
       y2d = 5358,  
       radius = 12,  
   },  
   {   
       x2d = 14551,   
       y2d = 5751,  
       radius = 5,  
   },  
   {   
       x2d = 14551,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 14566,   
       y2d = 5866,  
       radius = 20,  
   },  
   {   
       x2d = 14558,   
       y2d = 6308,  
       radius = 12,  
   },  
   {   
       x2d = 14551,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 14551,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 14551,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 14566,   
       y2d = 8616,  
       radius = 20,  
   },  
   {   
       x2d = 14588,   
       y2d = 8688,  
       radius = 42,  
   },  
   {   
       x2d = 14566,   
       y2d = 8816,  
       radius = 20,  
   },  
   {   
       x2d = 14588,   
       y2d = 8988,  
       radius = 42,  
   },  
   {   
       x2d = 14588,   
       y2d = 9088,  
       radius = 42,  
   },  
   {   
       x2d = 14551,   
       y2d = 9451,  
       radius = 5,  
   },  
   {   
       x2d = 14573,   
       y2d = 9873,  
       radius = 27,  
   },  
   {   
       x2d = 14588,   
       y2d = 9938,  
       radius = 42,  
   },  
   {   
       x2d = 14588,   
       y2d = 10188,  
       radius = 42,  
   },  
   {   
       x2d = 14638,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 14638,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 14638,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 14638,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 14638,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 14638,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 14638,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 14638,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 14638,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 14623,   
       y2d = 1473,  
       radius = 27,  
   },  
   {   
       x2d = 14638,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 14638,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 14623,   
       y2d = 1723,  
       radius = 27,  
   },  
   {   
       x2d = 14616,   
       y2d = 1966,  
       radius = 20,  
   },  
   {   
       x2d = 14638,   
       y2d = 2288,  
       radius = 42,  
   },  
   {   
       x2d = 14638,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 14638,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 14631,   
       y2d = 2731,  
       radius = 35,  
   },  
   {   
       x2d = 14638,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 14638,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 14638,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 14638,   
       y2d = 3388,  
       radius = 42,  
   },  
   {   
       x2d = 14601,   
       y2d = 4601,  
       radius = 5,  
   },  
   {   
       x2d = 14601,   
       y2d = 4801,  
       radius = 5,  
   },  
   {   
       x2d = 14608,   
       y2d = 5358,  
       radius = 12,  
   },  
   {   
       x2d = 14638,   
       y2d = 5438,  
       radius = 42,  
   },  
   {   
       x2d = 14601,   
       y2d = 5601,  
       radius = 5,  
   },  
   {   
       x2d = 14601,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 14623,   
       y2d = 5873,  
       radius = 27,  
   },  
   {   
       x2d = 14601,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 14601,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 14601,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 14601,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 14601,   
       y2d = 8401,  
       radius = 5,  
   },  
   {   
       x2d = 14638,   
       y2d = 8788,  
       radius = 42,  
   },  
   {   
       x2d = 14601,   
       y2d = 8901,  
       radius = 5,  
   },  
   {   
       x2d = 14638,   
       y2d = 9188,  
       radius = 42,  
   },  
   {   
       x2d = 14623,   
       y2d = 9323,  
       radius = 27,  
   },  
   {   
       x2d = 14608,   
       y2d = 9408,  
       radius = 12,  
   },  
   {   
       x2d = 14638,   
       y2d = 9538,  
       radius = 42,  
   },  
   {   
       x2d = 14601,   
       y2d = 9651,  
       radius = 5,  
   },  
   {   
       x2d = 14638,   
       y2d = 10038,  
       radius = 42,  
   },  
   {   
       x2d = 14638,   
       y2d = 10288,  
       radius = 42,  
   },  
   {   
       x2d = 14638,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 14688,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 14688,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 14688,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 14688,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 14688,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 14651,   
       y2d = 1851,  
       radius = 5,  
   },  
   {   
       x2d = 14681,   
       y2d = 1931,  
       radius = 35,  
   },  
   {   
       x2d = 14688,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 14688,   
       y2d = 2488,  
       radius = 42,  
   },  
   {   
       x2d = 14673,   
       y2d = 3473,  
       radius = 27,  
   },  
   {   
       x2d = 14688,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 14658,   
       y2d = 3858,  
       radius = 12,  
   },  
   {   
       x2d = 14658,   
       y2d = 3958,  
       radius = 12,  
   },  
   {   
       x2d = 14658,   
       y2d = 4008,  
       radius = 12,  
   },  
   {   
       x2d = 14651,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 14651,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 14673,   
       y2d = 4873,  
       radius = 27,  
   },  
   {   
       x2d = 14681,   
       y2d = 4981,  
       radius = 35,  
   },  
   {   
       x2d = 14688,   
       y2d = 5188,  
       radius = 42,  
   },  
   {   
       x2d = 14688,   
       y2d = 5288,  
       radius = 42,  
   },  
   {   
       x2d = 14651,   
       y2d = 5701,  
       radius = 5,  
   },  
   {   
       x2d = 14651,   
       y2d = 5951,  
       radius = 5,  
   },  
   {   
       x2d = 14651,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 14651,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 14651,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 14651,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 14651,   
       y2d = 7551,  
       radius = 5,  
   },  
   {   
       x2d = 14651,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 14651,   
       y2d = 8151,  
       radius = 5,  
   },  
   {   
       x2d = 14688,   
       y2d = 8638,  
       radius = 42,  
   },  
   {   
       x2d = 14688,   
       y2d = 8888,  
       radius = 42,  
   },  
   {   
       x2d = 14688,   
       y2d = 8988,  
       radius = 42,  
   },  
   {   
       x2d = 14688,   
       y2d = 9088,  
       radius = 42,  
   },  
   {   
       x2d = 14651,   
       y2d = 9401,  
       radius = 5,  
   },  
   {   
       x2d = 14688,   
       y2d = 10138,  
       radius = 42,  
   },  
   {   
       x2d = 14738,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 14738,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 14738,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 14738,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 14738,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 14738,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 14738,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 14738,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 14738,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 14738,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 14738,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 14738,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 14738,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 14723,   
       y2d = 2373,  
       radius = 27,  
   },  
   {   
       x2d = 14738,   
       y2d = 2588,  
       radius = 42,  
   },  
   {   
       x2d = 14723,   
       y2d = 2673,  
       radius = 27,  
   },  
   {   
       x2d = 14738,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 14738,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 14738,   
       y2d = 3088,  
       radius = 42,  
   },  
   {   
       x2d = 14701,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 14701,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 14701,   
       y2d = 3851,  
       radius = 5,  
   },  
   {   
       x2d = 14701,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 14708,   
       y2d = 4358,  
       radius = 12,  
   },  
   {   
       x2d = 14723,   
       y2d = 5073,  
       radius = 27,  
   },  
   {   
       x2d = 14738,   
       y2d = 5438,  
       radius = 42,  
   },  
   {   
       x2d = 14738,   
       y2d = 5538,  
       radius = 42,  
   },  
   {   
       x2d = 14701,   
       y2d = 5851,  
       radius = 5,  
   },  
   {   
       x2d = 14701,   
       y2d = 7051,  
       radius = 5,  
   },  
   {   
       x2d = 14701,   
       y2d = 7851,  
       radius = 5,  
   },  
   {   
       x2d = 14701,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 14738,   
       y2d = 8738,  
       radius = 42,  
   },  
   {   
       x2d = 14738,   
       y2d = 9188,  
       radius = 42,  
   },  
   {   
       x2d = 14708,   
       y2d = 9308,  
       radius = 12,  
   },  
   {   
       x2d = 14701,   
       y2d = 9351,  
       radius = 5,  
   },  
   {   
       x2d = 14738,   
       y2d = 9488,  
       radius = 42,  
   },  
   {   
       x2d = 14731,   
       y2d = 9581,  
       radius = 35,  
   },  
   {   
       x2d = 14701,   
       y2d = 9651,  
       radius = 5,  
   },  
   {   
       x2d = 14738,   
       y2d = 10238,  
       radius = 42,  
   },  
   {   
       x2d = 14738,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 14788,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 14788,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 14788,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 14788,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 14788,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 14788,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 14773,   
       y2d = 1873,  
       radius = 27,  
   },  
   {   
       x2d = 14788,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 14788,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 14788,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 14788,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 14766,   
       y2d = 3216,  
       radius = 20,  
   },  
   {   
       x2d = 14766,   
       y2d = 3316,  
       radius = 20,  
   },  
   {   
       x2d = 14788,   
       y2d = 3388,  
       radius = 42,  
   },  
   {   
       x2d = 14751,   
       y2d = 3501,  
       radius = 5,  
   },  
   {   
       x2d = 14751,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 14766,   
       y2d = 3766,  
       radius = 20,  
   },  
   {   
       x2d = 14758,   
       y2d = 3908,  
       radius = 12,  
   },  
   {   
       x2d = 14751,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 14758,   
       y2d = 4158,  
       radius = 12,  
   },  
   {   
       x2d = 14751,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 14751,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 14758,   
       y2d = 4358,  
       radius = 12,  
   },  
   {   
       x2d = 14751,   
       y2d = 4401,  
       radius = 5,  
   },  
   {   
       x2d = 14751,   
       y2d = 4451,  
       radius = 5,  
   },  
   {   
       x2d = 14758,   
       y2d = 4508,  
       radius = 12,  
   },  
   {   
       x2d = 14751,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 14758,   
       y2d = 4858,  
       radius = 12,  
   },  
   {   
       x2d = 14751,   
       y2d = 4901,  
       radius = 5,  
   },  
   {   
       x2d = 14766,   
       y2d = 4966,  
       radius = 20,  
   },  
   {   
       x2d = 14788,   
       y2d = 5038,  
       radius = 42,  
   },  
   {   
       x2d = 14766,   
       y2d = 5166,  
       radius = 20,  
   },  
   {   
       x2d = 14788,   
       y2d = 5288,  
       radius = 42,  
   },  
   {   
       x2d = 14758,   
       y2d = 5658,  
       radius = 12,  
   },  
   {   
       x2d = 14751,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 14751,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 14751,   
       y2d = 7401,  
       radius = 5,  
   },  
   {   
       x2d = 14758,   
       y2d = 8458,  
       radius = 12,  
   },  
   {   
       x2d = 14788,   
       y2d = 8538,  
       radius = 42,  
   },  
   {   
       x2d = 14788,   
       y2d = 8638,  
       radius = 42,  
   },  
   {   
       x2d = 14788,   
       y2d = 8838,  
       radius = 42,  
   },  
   {   
       x2d = 14788,   
       y2d = 8938,  
       radius = 42,  
   },  
   {   
       x2d = 14788,   
       y2d = 9038,  
       radius = 42,  
   },  
   {   
       x2d = 14751,   
       y2d = 9301,  
       radius = 5,  
   },  
   {   
       x2d = 14773,   
       y2d = 9673,  
       radius = 27,  
   },  
   {   
       x2d = 14773,   
       y2d = 9823,  
       radius = 27,  
   },  
   {   
       x2d = 14788,   
       y2d = 9938,  
       radius = 42,  
   },  
   {   
       x2d = 14788,   
       y2d = 10038,  
       radius = 42,  
   },  
   {   
       x2d = 14788,   
       y2d = 10138,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 14831,   
       y2d = 2631,  
       radius = 35,  
   },  
   {   
       x2d = 14838,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 14816,   
       y2d = 3066,  
       radius = 20,  
   },  
   {   
       x2d = 14801,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 14823,   
       y2d = 3473,  
       radius = 27,  
   },  
   {   
       x2d = 14801,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 14808,   
       y2d = 3858,  
       radius = 12,  
   },  
   {   
       x2d = 14801,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 14801,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 14801,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 14801,   
       y2d = 4901,  
       radius = 5,  
   },  
   {   
       x2d = 14838,   
       y2d = 5438,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 5538,  
       radius = 42,  
   },  
   {   
       x2d = 14823,   
       y2d = 5623,  
       radius = 27,  
   },  
   {   
       x2d = 14808,   
       y2d = 5708,  
       radius = 12,  
   },  
   {   
       x2d = 14831,   
       y2d = 5931,  
       radius = 35,  
   },  
   {   
       x2d = 14801,   
       y2d = 6251,  
       radius = 5,  
   },  
   {   
       x2d = 14801,   
       y2d = 6401,  
       radius = 5,  
   },  
   {   
       x2d = 14801,   
       y2d = 6801,  
       radius = 5,  
   },  
   {   
       x2d = 14801,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 14801,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 14801,   
       y2d = 7551,  
       radius = 5,  
   },  
   {   
       x2d = 14808,   
       y2d = 7958,  
       radius = 12,  
   },  
   {   
       x2d = 14801,   
       y2d = 8001,  
       radius = 5,  
   },  
   {   
       x2d = 14801,   
       y2d = 8151,  
       radius = 5,  
   },  
   {   
       x2d = 14816,   
       y2d = 8316,  
       radius = 20,  
   },  
   {   
       x2d = 14838,   
       y2d = 8738,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 9138,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 9238,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 9488,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 9588,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 9688,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 10238,  
       radius = 42,  
   },  
   {   
       x2d = 14838,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 14888,   
       y2d = 788,  
       radius = 42,  
   },  
   {   
       x2d = 14888,   
       y2d = 888,  
       radius = 42,  
   },  
   {   
       x2d = 14888,   
       y2d = 988,  
       radius = 42,  
   },  
   {   
       x2d = 14888,   
       y2d = 1088,  
       radius = 42,  
   },  
   {   
       x2d = 14888,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 14888,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 14888,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 14888,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 14888,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 14888,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 14888,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 14851,   
       y2d = 3101,  
       radius = 5,  
   },  
   {   
       x2d = 14858,   
       y2d = 3208,  
       radius = 12,  
   },  
   {   
       x2d = 14866,   
       y2d = 3266,  
       radius = 20,  
   },  
   {   
       x2d = 14866,   
       y2d = 3366,  
       radius = 20,  
   },  
   {   
       x2d = 14888,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 14866,   
       y2d = 3616,  
       radius = 20,  
   },  
   {   
       x2d = 14858,   
       y2d = 3658,  
       radius = 12,  
   },  
   {   
       x2d = 14851,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 14881,   
       y2d = 3831,  
       radius = 35,  
   },  
   {   
       x2d = 14858,   
       y2d = 3908,  
       radius = 12,  
   },  
   {   
       x2d = 14866,   
       y2d = 3966,  
       radius = 20,  
   },  
   {   
       x2d = 14866,   
       y2d = 4166,  
       radius = 20,  
   },  
   {   
       x2d = 14866,   
       y2d = 4216,  
       radius = 20,  
   },  
   {   
       x2d = 14866,   
       y2d = 4966,  
       radius = 20,  
   },  
   {   
       x2d = 14888,   
       y2d = 5038,  
       radius = 42,  
   },  
   {   
       x2d = 14873,   
       y2d = 5123,  
       radius = 27,  
   },  
   {   
       x2d = 14858,   
       y2d = 5208,  
       radius = 12,  
   },  
   {   
       x2d = 14888,   
       y2d = 5688,  
       radius = 42,  
   },  
   {   
       x2d = 14858,   
       y2d = 6008,  
       radius = 12,  
   },  
   {   
       x2d = 14851,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 14858,   
       y2d = 6258,  
       radius = 12,  
   },  
   {   
       x2d = 14866,   
       y2d = 6416,  
       radius = 20,  
   },  
   {   
       x2d = 14858,   
       y2d = 6458,  
       radius = 12,  
   },  
   {   
       x2d = 14851,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 14851,   
       y2d = 7051,  
       radius = 5,  
   },  
   {   
       x2d = 14851,   
       y2d = 7351,  
       radius = 5,  
   },  
   {   
       x2d = 14851,   
       y2d = 7551,  
       radius = 5,  
   },  
   {   
       x2d = 14851,   
       y2d = 7951,  
       radius = 5,  
   },  
   {   
       x2d = 14866,   
       y2d = 8066,  
       radius = 20,  
   },  
   {   
       x2d = 14888,   
       y2d = 8388,  
       radius = 42,  
   },  
   {   
       x2d = 14888,   
       y2d = 8488,  
       radius = 42,  
   },  
   {   
       x2d = 14888,   
       y2d = 8588,  
       radius = 42,  
   },  
   {   
       x2d = 14888,   
       y2d = 8838,  
       radius = 42,  
   },  
   {   
       x2d = 14888,   
       y2d = 8938,  
       radius = 42,  
   },  
   {   
       x2d = 14888,   
       y2d = 9038,  
       radius = 42,  
   },  
   {   
       x2d = 14888,   
       y2d = 9888,  
       radius = 42,  
   },  
   {   
       x2d = 14888,   
       y2d = 9988,  
       radius = 42,  
   },  
   {   
       x2d = 14888,   
       y2d = 10088,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 1188,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 1288,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 1388,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 1488,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 1588,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 14931,   
       y2d = 3031,  
       radius = 35,  
   },  
   {   
       x2d = 14938,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 14916,   
       y2d = 3266,  
       radius = 20,  
   },  
   {   
       x2d = 14908,   
       y2d = 3308,  
       radius = 12,  
   },  
   {   
       x2d = 14908,   
       y2d = 3708,  
       radius = 12,  
   },  
   {   
       x2d = 14908,   
       y2d = 3758,  
       radius = 12,  
   },  
   {   
       x2d = 14916,   
       y2d = 3916,  
       radius = 20,  
   },  
   {   
       x2d = 14908,   
       y2d = 3958,  
       radius = 12,  
   },  
   {   
       x2d = 14908,   
       y2d = 4008,  
       radius = 12,  
   },  
   {   
       x2d = 14901,   
       y2d = 4901,  
       radius = 5,  
   },  
   {   
       x2d = 14901,   
       y2d = 5201,  
       radius = 5,  
   },  
   {   
       x2d = 14938,   
       y2d = 5388,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 5488,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 5588,  
       radius = 42,  
   },  
   {   
       x2d = 14931,   
       y2d = 5931,  
       radius = 35,  
   },  
   {   
       x2d = 14901,   
       y2d = 6001,  
       radius = 5,  
   },  
   {   
       x2d = 14908,   
       y2d = 6058,  
       radius = 12,  
   },  
   {   
       x2d = 14901,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 14901,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 14908,   
       y2d = 6408,  
       radius = 12,  
   },  
   {   
       x2d = 14901,   
       y2d = 7051,  
       radius = 5,  
   },  
   {   
       x2d = 14901,   
       y2d = 7301,  
       radius = 5,  
   },  
   {   
       x2d = 14908,   
       y2d = 7358,  
       radius = 12,  
   },  
   {   
       x2d = 14923,   
       y2d = 7473,  
       radius = 27,  
   },  
   {   
       x2d = 14901,   
       y2d = 7551,  
       radius = 5,  
   },  
   {   
       x2d = 14908,   
       y2d = 8058,  
       radius = 12,  
   },  
   {   
       x2d = 14931,   
       y2d = 8681,  
       radius = 35,  
   },  
   {   
       x2d = 14938,   
       y2d = 9138,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 9238,  
       radius = 42,  
   },  
   {   
       x2d = 14916,   
       y2d = 9466,  
       radius = 20,  
   },  
   {   
       x2d = 14923,   
       y2d = 9523,  
       radius = 27,  
   },  
   {   
       x2d = 14923,   
       y2d = 9723,  
       radius = 27,  
   },  
   {   
       x2d = 14938,   
       y2d = 9788,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 10188,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 10288,  
       radius = 42,  
   },  
   {   
       x2d = 14938,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 14988,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 14988,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 14988,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 14988,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 14988,   
       y2d = 1688,  
       radius = 42,  
   },  
   {   
       x2d = 14988,   
       y2d = 1788,  
       radius = 42,  
   },  
   {   
       x2d = 14988,   
       y2d = 1888,  
       radius = 42,  
   },  
   {   
       x2d = 14988,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 14988,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 14988,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 14988,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 14958,   
       y2d = 3308,  
       radius = 12,  
   },  
   {   
       x2d = 14981,   
       y2d = 3431,  
       radius = 35,  
   },  
   {   
       x2d = 14951,   
       y2d = 3501,  
       radius = 5,  
   },  
   {   
       x2d = 14951,   
       y2d = 3551,  
       radius = 5,  
   },  
   {   
       x2d = 14973,   
       y2d = 3673,  
       radius = 27,  
   },  
   {   
       x2d = 14966,   
       y2d = 3816,  
       radius = 20,  
   },  
   {   
       x2d = 14973,   
       y2d = 4023,  
       radius = 27,  
   },  
   {   
       x2d = 14958,   
       y2d = 4458,  
       radius = 12,  
   },  
   {   
       x2d = 14951,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 14951,   
       y2d = 4951,  
       radius = 5,  
   },  
   {   
       x2d = 14988,   
       y2d = 5038,  
       radius = 42,  
   },  
   {   
       x2d = 14988,   
       y2d = 5288,  
       radius = 42,  
   },  
   {   
       x2d = 14973,   
       y2d = 5673,  
       radius = 27,  
   },  
   {   
       x2d = 14951,   
       y2d = 5751,  
       radius = 5,  
   },  
   {   
       x2d = 14951,   
       y2d = 6051,  
       radius = 5,  
   },  
   {   
       x2d = 14981,   
       y2d = 6381,  
       radius = 35,  
   },  
   {   
       x2d = 14951,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 14951,   
       y2d = 7301,  
       radius = 5,  
   },  
   {   
       x2d = 14951,   
       y2d = 7401,  
       radius = 5,  
   },  
   {   
       x2d = 14951,   
       y2d = 7951,  
       radius = 5,  
   },  
   {   
       x2d = 14973,   
       y2d = 8223,  
       radius = 27,  
   },  
   {   
       x2d = 14988,   
       y2d = 8388,  
       radius = 42,  
   },  
   {   
       x2d = 14988,   
       y2d = 8488,  
       radius = 42,  
   },  
   {   
       x2d = 14988,   
       y2d = 8588,  
       radius = 42,  
   },  
   {   
       x2d = 14981,   
       y2d = 8781,  
       radius = 35,  
   },  
   {   
       x2d = 14988,   
       y2d = 8888,  
       radius = 42,  
   },  
   {   
       x2d = 14988,   
       y2d = 9038,  
       radius = 42,  
   },  
   {   
       x2d = 14981,   
       y2d = 9331,  
       radius = 35,  
   },  
   {   
       x2d = 14951,   
       y2d = 9601,  
       radius = 5,  
   },  
   {   
       x2d = 14988,   
       y2d = 9938,  
       radius = 42,  
   },  
   {   
       x2d = 14988,   
       y2d = 10038,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 2688,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 2788,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 2888,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 2988,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 3088,  
       radius = 42,  
   },  
   {   
       x2d = 15016,   
       y2d = 3216,  
       radius = 20,  
   },  
   {   
       x2d = 15038,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 15001,   
       y2d = 3551,  
       radius = 5,  
   },  
   {   
       x2d = 15038,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 15001,   
       y2d = 3851,  
       radius = 5,  
   },  
   {   
       x2d = 15016,   
       y2d = 4516,  
       radius = 20,  
   },  
   {   
       x2d = 15001,   
       y2d = 5201,  
       radius = 5,  
   },  
   {   
       x2d = 15038,   
       y2d = 5388,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 5488,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 5588,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 5688,  
       radius = 42,  
   },  
   {   
       x2d = 15008,   
       y2d = 5808,  
       radius = 12,  
   },  
   {   
       x2d = 15001,   
       y2d = 5851,  
       radius = 5,  
   },  
   {   
       x2d = 15023,   
       y2d = 5923,  
       radius = 27,  
   },  
   {   
       x2d = 15038,   
       y2d = 5988,  
       radius = 42,  
   },  
   {   
       x2d = 15001,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 15001,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 15001,   
       y2d = 6501,  
       radius = 5,  
   },  
   {   
       x2d = 15023,   
       y2d = 7323,  
       radius = 27,  
   },  
   {   
       x2d = 15038,   
       y2d = 7388,  
       radius = 42,  
   },  
   {   
       x2d = 15001,   
       y2d = 7551,  
       radius = 5,  
   },  
   {   
       x2d = 15038,   
       y2d = 8688,  
       radius = 42,  
   },  
   {   
       x2d = 15008,   
       y2d = 9408,  
       radius = 12,  
   },  
   {   
       x2d = 15001,   
       y2d = 9551,  
       radius = 5,  
   },  
   {   
       x2d = 15001,   
       y2d = 9651,  
       radius = 5,  
   },  
   {   
       x2d = 15008,   
       y2d = 9708,  
       radius = 12,  
   },  
   {   
       x2d = 15038,   
       y2d = 9838,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 10138,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 10238,  
       radius = 42,  
   },  
   {   
       x2d = 15038,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 15088,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 15088,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 15088,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 15088,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 15088,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 15088,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 15088,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 15088,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 15088,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 15088,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 15088,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 15088,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 15066,   
       y2d = 3216,  
       radius = 20,  
   },  
   {   
       x2d = 15058,   
       y2d = 3508,  
       radius = 12,  
   },  
   {   
       x2d = 15073,   
       y2d = 3723,  
       radius = 27,  
   },  
   {   
       x2d = 15081,   
       y2d = 3781,  
       radius = 35,  
   },  
   {   
       x2d = 15058,   
       y2d = 3858,  
       radius = 12,  
   },  
   {   
       x2d = 15088,   
       y2d = 3938,  
       radius = 42,  
   },  
   {   
       x2d = 15088,   
       y2d = 4038,  
       radius = 42,  
   },  
   {   
       x2d = 15058,   
       y2d = 4308,  
       radius = 12,  
   },  
   {   
       x2d = 15066,   
       y2d = 4516,  
       radius = 20,  
   },  
   {   
       x2d = 15051,   
       y2d = 4951,  
       radius = 5,  
   },  
   {   
       x2d = 15066,   
       y2d = 5066,  
       radius = 20,  
   },  
   {   
       x2d = 15088,   
       y2d = 5138,  
       radius = 42,  
   },  
   {   
       x2d = 15081,   
       y2d = 6081,  
       radius = 35,  
   },  
   {   
       x2d = 15051,   
       y2d = 6401,  
       radius = 5,  
   },  
   {   
       x2d = 15051,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 15051,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 15066,   
       y2d = 7516,  
       radius = 20,  
   },  
   {   
       x2d = 15051,   
       y2d = 8201,  
       radius = 5,  
   },  
   {   
       x2d = 15051,   
       y2d = 8301,  
       radius = 5,  
   },  
   {   
       x2d = 15088,   
       y2d = 8438,  
       radius = 42,  
   },  
   {   
       x2d = 15073,   
       y2d = 8523,  
       radius = 27,  
   },  
   {   
       x2d = 15066,   
       y2d = 8816,  
       radius = 20,  
   },  
   {   
       x2d = 15066,   
       y2d = 8866,  
       radius = 20,  
   },  
   {   
       x2d = 15088,   
       y2d = 8938,  
       radius = 42,  
   },  
   {   
       x2d = 15081,   
       y2d = 9031,  
       radius = 35,  
   },  
   {   
       x2d = 15081,   
       y2d = 9131,  
       radius = 35,  
   },  
   {   
       x2d = 15066,   
       y2d = 9316,  
       radius = 20,  
   },  
   {   
       x2d = 15066,   
       y2d = 9366,  
       radius = 20,  
   },  
   {   
       x2d = 15088,   
       y2d = 9938,  
       radius = 42,  
   },  
   {   
       x2d = 15088,   
       y2d = 10038,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 2988,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 3088,  
       radius = 42,  
   },  
   {   
       x2d = 15123,   
       y2d = 3173,  
       radius = 27,  
   },  
   {   
       x2d = 15108,   
       y2d = 3258,  
       radius = 12,  
   },  
   {   
       x2d = 15131,   
       y2d = 3331,  
       radius = 35,  
   },  
   {   
       x2d = 15123,   
       y2d = 3473,  
       radius = 27,  
   },  
   {   
       x2d = 15138,   
       y2d = 3588,  
       radius = 42,  
   },  
   {   
       x2d = 15131,   
       y2d = 3681,  
       radius = 35,  
   },  
   {   
       x2d = 15138,   
       y2d = 4138,  
       radius = 42,  
   },  
   {   
       x2d = 15101,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 15101,   
       y2d = 5001,  
       radius = 5,  
   },  
   {   
       x2d = 15138,   
       y2d = 5338,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 5488,  
       radius = 42,  
   },  
   {   
       x2d = 15123,   
       y2d = 5573,  
       radius = 27,  
   },  
   {   
       x2d = 15131,   
       y2d = 5631,  
       radius = 35,  
   },  
   {   
       x2d = 15138,   
       y2d = 5788,  
       radius = 42,  
   },  
   {   
       x2d = 15123,   
       y2d = 5873,  
       radius = 27,  
   },  
   {   
       x2d = 15138,   
       y2d = 5938,  
       radius = 42,  
   },  
   {   
       x2d = 15138,   
       y2d = 6038,  
       radius = 42,  
   },  
   {   
       x2d = 15108,   
       y2d = 6158,  
       radius = 12,  
   },  
   {   
       x2d = 15108,   
       y2d = 6258,  
       radius = 12,  
   },  
   {   
       x2d = 15108,   
       y2d = 6308,  
       radius = 12,  
   },  
   {   
       x2d = 15108,   
       y2d = 6608,  
       radius = 12,  
   },  
   {   
       x2d = 15101,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 15101,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 15101,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 15101,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 15101,   
       y2d = 7151,  
       radius = 5,  
   },  
   {   
       x2d = 15108,   
       y2d = 7208,  
       radius = 12,  
   },  
   {   
       x2d = 15108,   
       y2d = 7258,  
       radius = 12,  
   },  
   {   
       x2d = 15101,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 15101,   
       y2d = 8101,  
       radius = 5,  
   },  
   {   
       x2d = 15138,   
       y2d = 8538,  
       radius = 42,  
   },  
   {   
       x2d = 15131,   
       y2d = 8631,  
       radius = 35,  
   },  
   {   
       x2d = 15123,   
       y2d = 8723,  
       radius = 27,  
   },  
   {   
       x2d = 15116,   
       y2d = 8816,  
       radius = 20,  
   },  
   {   
       x2d = 15108,   
       y2d = 9308,  
       radius = 12,  
   },  
   {   
       x2d = 15131,   
       y2d = 9431,  
       radius = 35,  
   },  
   {   
       x2d = 15116,   
       y2d = 9516,  
       radius = 20,  
   },  
   {   
       x2d = 15123,   
       y2d = 9823,  
       radius = 27,  
   },  
   {   
       x2d = 15138,   
       y2d = 10138,  
       radius = 42,  
   },  
   {   
       x2d = 15123,   
       y2d = 10273,  
       radius = 27,  
   },  
   {   
       x2d = 15138,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 15188,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 15188,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 15188,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 15188,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 15188,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 15188,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 15188,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 15188,   
       y2d = 1988,  
       radius = 42,  
   },  
   {   
       x2d = 15188,   
       y2d = 2088,  
       radius = 42,  
   },  
   {   
       x2d = 15188,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 15188,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 15173,   
       y2d = 3273,  
       radius = 27,  
   },  
   {   
       x2d = 15181,   
       y2d = 3781,  
       radius = 35,  
   },  
   {   
       x2d = 15188,   
       y2d = 3888,  
       radius = 42,  
   },  
   {   
       x2d = 15188,   
       y2d = 3988,  
       radius = 42,  
   },  
   {   
       x2d = 15151,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 15151,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 15151,   
       y2d = 4601,  
       radius = 5,  
   },  
   {   
       x2d = 15151,   
       y2d = 5051,  
       radius = 5,  
   },  
   {   
       x2d = 15173,   
       y2d = 5123,  
       radius = 27,  
   },  
   {   
       x2d = 15181,   
       y2d = 5181,  
       radius = 35,  
   },  
   {   
       x2d = 15188,   
       y2d = 5588,  
       radius = 42,  
   },  
   {   
       x2d = 15158,   
       y2d = 6408,  
       radius = 12,  
   },  
   {   
       x2d = 15158,   
       y2d = 6558,  
       radius = 12,  
   },  
   {   
       x2d = 15151,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 15151,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 15181,   
       y2d = 6931,  
       radius = 35,  
   },  
   {   
       x2d = 15158,   
       y2d = 7158,  
       radius = 12,  
   },  
   {   
       x2d = 15151,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 15151,   
       y2d = 7301,  
       radius = 5,  
   },  
   {   
       x2d = 15151,   
       y2d = 7351,  
       radius = 5,  
   },  
   {   
       x2d = 15173,   
       y2d = 7423,  
       radius = 27,  
   },  
   {   
       x2d = 15151,   
       y2d = 7501,  
       radius = 5,  
   },  
   {   
       x2d = 15151,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 15151,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 15151,   
       y2d = 7951,  
       radius = 5,  
   },  
   {   
       x2d = 15166,   
       y2d = 8216,  
       radius = 20,  
   },  
   {   
       x2d = 15188,   
       y2d = 8388,  
       radius = 42,  
   },  
   {   
       x2d = 15181,   
       y2d = 8831,  
       radius = 35,  
   },  
   {   
       x2d = 15173,   
       y2d = 8923,  
       radius = 27,  
   },  
   {   
       x2d = 15188,   
       y2d = 9088,  
       radius = 42,  
   },  
   {   
       x2d = 15188,   
       y2d = 9188,  
       radius = 42,  
   },  
   {   
       x2d = 15151,   
       y2d = 9351,  
       radius = 5,  
   },  
   {   
       x2d = 15188,   
       y2d = 9538,  
       radius = 42,  
   },  
   {   
       x2d = 15151,   
       y2d = 9651,  
       radius = 5,  
   },  
   {   
       x2d = 15151,   
       y2d = 9701,  
       radius = 5,  
   },  
   {   
       x2d = 15188,   
       y2d = 9888,  
       radius = 42,  
   },  
   {   
       x2d = 15188,   
       y2d = 9988,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 15231,   
       y2d = 2181,  
       radius = 35,  
   },  
   {   
       x2d = 15238,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 3088,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 15201,   
       y2d = 3451,  
       radius = 5,  
   },  
   {   
       x2d = 15238,   
       y2d = 3588,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 4088,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 4188,  
       radius = 42,  
   },  
   {   
       x2d = 15216,   
       y2d = 4466,  
       radius = 20,  
   },  
   {   
       x2d = 15208,   
       y2d = 4508,  
       radius = 12,  
   },  
   {   
       x2d = 15201,   
       y2d = 4601,  
       radius = 5,  
   },  
   {   
       x2d = 15238,   
       y2d = 5288,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 5388,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 5488,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 5688,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 5788,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 5988,  
       radius = 42,  
   },  
   {   
       x2d = 15201,   
       y2d = 6101,  
       radius = 5,  
   },  
   {   
       x2d = 15223,   
       y2d = 6223,  
       radius = 27,  
   },  
   {   
       x2d = 15208,   
       y2d = 6308,  
       radius = 12,  
   },  
   {   
       x2d = 15201,   
       y2d = 6401,  
       radius = 5,  
   },  
   {   
       x2d = 15238,   
       y2d = 6788,  
       radius = 42,  
   },  
   {   
       x2d = 15223,   
       y2d = 7023,  
       radius = 27,  
   },  
   {   
       x2d = 15216,   
       y2d = 7166,  
       radius = 20,  
   },  
   {   
       x2d = 15216,   
       y2d = 7216,  
       radius = 20,  
   },  
   {   
       x2d = 15238,   
       y2d = 7288,  
       radius = 42,  
   },  
   {   
       x2d = 15201,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 15201,   
       y2d = 7951,  
       radius = 5,  
   },  
   {   
       x2d = 15238,   
       y2d = 8288,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 8488,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 8588,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 8788,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 8988,  
       radius = 42,  
   },  
   {   
       x2d = 15201,   
       y2d = 9451,  
       radius = 5,  
   },  
   {   
       x2d = 15223,   
       y2d = 9623,  
       radius = 27,  
   },  
   {   
       x2d = 15208,   
       y2d = 9708,  
       radius = 12,  
   },  
   {   
       x2d = 15238,   
       y2d = 10088,  
       radius = 42,  
   },  
   {   
       x2d = 15223,   
       y2d = 10173,  
       radius = 27,  
   },  
   {   
       x2d = 15238,   
       y2d = 10238,  
       radius = 42,  
   },  
   {   
       x2d = 15238,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 15288,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 15288,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 15288,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 15288,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 15288,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 15288,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 15288,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 15288,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 15288,   
       y2d = 2088,  
       radius = 42,  
   },  
   {   
       x2d = 15288,   
       y2d = 2288,  
       radius = 42,  
   },  
   {   
       x2d = 15288,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 15251,   
       y2d = 3201,  
       radius = 5,  
   },  
   {   
       x2d = 15258,   
       y2d = 3458,  
       radius = 12,  
   },  
   {   
       x2d = 15251,   
       y2d = 3501,  
       radius = 5,  
   },  
   {   
       x2d = 15281,   
       y2d = 3731,  
       radius = 35,  
   },  
   {   
       x2d = 15266,   
       y2d = 3816,  
       radius = 20,  
   },  
   {   
       x2d = 15273,   
       y2d = 4273,  
       radius = 27,  
   },  
   {   
       x2d = 15251,   
       y2d = 4401,  
       radius = 5,  
   },  
   {   
       x2d = 15273,   
       y2d = 4623,  
       radius = 27,  
   },  
   {   
       x2d = 15251,   
       y2d = 5101,  
       radius = 5,  
   },  
   {   
       x2d = 15273,   
       y2d = 5173,  
       radius = 27,  
   },  
   {   
       x2d = 15288,   
       y2d = 5888,  
       radius = 42,  
   },  
   {   
       x2d = 15288,   
       y2d = 6188,  
       radius = 42,  
   },  
   {   
       x2d = 15251,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 15258,   
       y2d = 6358,  
       radius = 12,  
   },  
   {   
       x2d = 15251,   
       y2d = 6401,  
       radius = 5,  
   },  
   {   
       x2d = 15251,   
       y2d = 6501,  
       radius = 5,  
   },  
   {   
       x2d = 15251,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 15266,   
       y2d = 6966,  
       radius = 20,  
   },  
   {   
       x2d = 15258,   
       y2d = 7108,  
       radius = 12,  
   },  
   {   
       x2d = 15258,   
       y2d = 7158,  
       radius = 12,  
   },  
   {   
       x2d = 15273,   
       y2d = 7423,  
       radius = 27,  
   },  
   {   
       x2d = 15251,   
       y2d = 7551,  
       radius = 5,  
   },  
   {   
       x2d = 15251,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 15251,   
       y2d = 8101,  
       radius = 5,  
   },  
   {   
       x2d = 15288,   
       y2d = 8188,  
       radius = 42,  
   },  
   {   
       x2d = 15288,   
       y2d = 8388,  
       radius = 42,  
   },  
   {   
       x2d = 15288,   
       y2d = 8688,  
       radius = 42,  
   },  
   {   
       x2d = 15288,   
       y2d = 9088,  
       radius = 42,  
   },  
   {   
       x2d = 15273,   
       y2d = 9173,  
       radius = 27,  
   },  
   {   
       x2d = 15251,   
       y2d = 9251,  
       radius = 5,  
   },  
   {   
       x2d = 15251,   
       y2d = 9451,  
       radius = 5,  
   },  
   {   
       x2d = 15273,   
       y2d = 9573,  
       radius = 27,  
   },  
   {   
       x2d = 15251,   
       y2d = 9701,  
       radius = 5,  
   },  
   {   
       x2d = 15288,   
       y2d = 9788,  
       radius = 42,  
   },  
   {   
       x2d = 15288,   
       y2d = 9888,  
       radius = 42,  
   },  
   {   
       x2d = 15288,   
       y2d = 9988,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 2188,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 2488,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 2588,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 2688,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 2788,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 2888,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 2988,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 3088,  
       radius = 42,  
   },  
   {   
       x2d = 15323,   
       y2d = 3223,  
       radius = 27,  
   },  
   {   
       x2d = 15323,   
       y2d = 3373,  
       radius = 27,  
   },  
   {   
       x2d = 15316,   
       y2d = 3616,  
       radius = 20,  
   },  
   {   
       x2d = 15308,   
       y2d = 3808,  
       radius = 12,  
   },  
   {   
       x2d = 15308,   
       y2d = 3858,  
       radius = 12,  
   },  
   {   
       x2d = 15308,   
       y2d = 3908,  
       radius = 12,  
   },  
   {   
       x2d = 15301,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 15308,   
       y2d = 4008,  
       radius = 12,  
   },  
   {   
       x2d = 15323,   
       y2d = 4123,  
       radius = 27,  
   },  
   {   
       x2d = 15338,   
       y2d = 4238,  
       radius = 42,  
   },  
   {   
       x2d = 15331,   
       y2d = 4331,  
       radius = 35,  
   },  
   {   
       x2d = 15301,   
       y2d = 4451,  
       radius = 5,  
   },  
   {   
       x2d = 15308,   
       y2d = 4558,  
       radius = 12,  
   },  
   {   
       x2d = 15338,   
       y2d = 4638,  
       radius = 42,  
   },  
   {   
       x2d = 15301,   
       y2d = 5101,  
       radius = 5,  
   },  
   {   
       x2d = 15338,   
       y2d = 5238,  
       radius = 42,  
   },  
   {   
       x2d = 15331,   
       y2d = 5331,  
       radius = 35,  
   },  
   {   
       x2d = 15316,   
       y2d = 5416,  
       radius = 20,  
   },  
   {   
       x2d = 15316,   
       y2d = 5466,  
       radius = 20,  
   },  
   {   
       x2d = 15338,   
       y2d = 5588,  
       radius = 42,  
   },  
   {   
       x2d = 15331,   
       y2d = 5731,  
       radius = 35,  
   },  
   {   
       x2d = 15338,   
       y2d = 5988,  
       radius = 42,  
   },  
   {   
       x2d = 15301,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 15301,   
       y2d = 6401,  
       radius = 5,  
   },  
   {   
       x2d = 15323,   
       y2d = 6723,  
       radius = 27,  
   },  
   {   
       x2d = 15301,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 15301,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 15301,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 15338,   
       y2d = 7088,  
       radius = 42,  
   },  
   {   
       x2d = 15323,   
       y2d = 7173,  
       radius = 27,  
   },  
   {   
       x2d = 15338,   
       y2d = 7388,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 8288,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 8488,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 8788,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 8938,  
       radius = 42,  
   },  
   {   
       x2d = 15316,   
       y2d = 9266,  
       radius = 20,  
   },  
   {   
       x2d = 15301,   
       y2d = 9351,  
       radius = 5,  
   },  
   {   
       x2d = 15308,   
       y2d = 9458,  
       radius = 12,  
   },  
   {   
       x2d = 15338,   
       y2d = 10088,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 10188,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 10288,  
       radius = 42,  
   },  
   {   
       x2d = 15338,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 15388,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 15388,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 15388,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 15388,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 15388,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 15388,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 15388,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 15388,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 15388,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 15388,   
       y2d = 2288,  
       radius = 42,  
   },  
   {   
       x2d = 15388,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 15358,   
       y2d = 3308,  
       radius = 12,  
   },  
   {   
       x2d = 15366,   
       y2d = 3566,  
       radius = 20,  
   },  
   {   
       x2d = 15358,   
       y2d = 3608,  
       radius = 12,  
   },  
   {   
       x2d = 15351,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 15351,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 15358,   
       y2d = 3908,  
       radius = 12,  
   },  
   {   
       x2d = 15358,   
       y2d = 3958,  
       radius = 12,  
   },  
   {   
       x2d = 15351,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 15358,   
       y2d = 4458,  
       radius = 12,  
   },  
   {   
       x2d = 15351,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 15351,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 15358,   
       y2d = 5458,  
       radius = 12,  
   },  
   {   
       x2d = 15388,   
       y2d = 5888,  
       radius = 42,  
   },  
   {   
       x2d = 15388,   
       y2d = 6138,  
       radius = 42,  
   },  
   {   
       x2d = 15381,   
       y2d = 6231,  
       radius = 35,  
   },  
   {   
       x2d = 15358,   
       y2d = 6308,  
       radius = 12,  
   },  
   {   
       x2d = 15351,   
       y2d = 6401,  
       radius = 5,  
   },  
   {   
       x2d = 15358,   
       y2d = 6808,  
       radius = 12,  
   },  
   {   
       x2d = 15381,   
       y2d = 6881,  
       radius = 35,  
   },  
   {   
       x2d = 15351,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 15388,   
       y2d = 7188,  
       radius = 42,  
   },  
   {   
       x2d = 15351,   
       y2d = 7501,  
       radius = 5,  
   },  
   {   
       x2d = 15351,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 15351,   
       y2d = 8101,  
       radius = 5,  
   },  
   {   
       x2d = 15373,   
       y2d = 8173,  
       radius = 27,  
   },  
   {   
       x2d = 15388,   
       y2d = 8388,  
       radius = 42,  
   },  
   {   
       x2d = 15388,   
       y2d = 8588,  
       radius = 42,  
   },  
   {   
       x2d = 15388,   
       y2d = 8688,  
       radius = 42,  
   },  
   {   
       x2d = 15381,   
       y2d = 9081,  
       radius = 35,  
   },  
   {   
       x2d = 15366,   
       y2d = 9166,  
       radius = 20,  
   },  
   {   
       x2d = 15366,   
       y2d = 9266,  
       radius = 20,  
   },  
   {   
       x2d = 15351,   
       y2d = 9351,  
       radius = 5,  
   },  
   {   
       x2d = 15351,   
       y2d = 9501,  
       radius = 5,  
   },  
   {   
       x2d = 15358,   
       y2d = 9558,  
       radius = 12,  
   },  
   {   
       x2d = 15373,   
       y2d = 9723,  
       radius = 27,  
   },  
   {   
       x2d = 15388,   
       y2d = 9988,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 2488,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 2588,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 2688,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 2788,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 2988,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 3088,  
       radius = 42,  
   },  
   {   
       x2d = 15423,   
       y2d = 3223,  
       radius = 27,  
   },  
   {   
       x2d = 15416,   
       y2d = 3316,  
       radius = 20,  
   },  
   {   
       x2d = 15401,   
       y2d = 3401,  
       radius = 5,  
   },  
   {   
       x2d = 15431,   
       y2d = 3481,  
       radius = 35,  
   },  
   {   
       x2d = 15416,   
       y2d = 3566,  
       radius = 20,  
   },  
   {   
       x2d = 15408,   
       y2d = 3658,  
       radius = 12,  
   },  
   {   
       x2d = 15408,   
       y2d = 3708,  
       radius = 12,  
   },  
   {   
       x2d = 15401,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 15401,   
       y2d = 3801,  
       radius = 5,  
   },  
   {   
       x2d = 15416,   
       y2d = 3866,  
       radius = 20,  
   },  
   {   
       x2d = 15401,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 15438,   
       y2d = 4088,  
       radius = 42,  
   },  
   {   
       x2d = 15431,   
       y2d = 4181,  
       radius = 35,  
   },  
   {   
       x2d = 15423,   
       y2d = 4273,  
       radius = 27,  
   },  
   {   
       x2d = 15416,   
       y2d = 4666,  
       radius = 20,  
   },  
   {   
       x2d = 15401,   
       y2d = 4851,  
       radius = 5,  
   },  
   {   
       x2d = 15438,   
       y2d = 5238,  
       radius = 42,  
   },  
   {   
       x2d = 15401,   
       y2d = 5351,  
       radius = 5,  
   },  
   {   
       x2d = 15401,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 15401,   
       y2d = 5651,  
       radius = 5,  
   },  
   {   
       x2d = 15401,   
       y2d = 5701,  
       radius = 5,  
   },  
   {   
       x2d = 15438,   
       y2d = 5988,  
       radius = 42,  
   },  
   {   
       x2d = 15401,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 15401,   
       y2d = 6451,  
       radius = 5,  
   },  
   {   
       x2d = 15401,   
       y2d = 6601,  
       radius = 5,  
   },  
   {   
       x2d = 15401,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 15401,   
       y2d = 6701,  
       radius = 5,  
   },  
   {   
       x2d = 15401,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 15438,   
       y2d = 6838,  
       radius = 42,  
   },  
   {   
       x2d = 15408,   
       y2d = 6958,  
       radius = 12,  
   },  
   {   
       x2d = 15401,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 15416,   
       y2d = 7066,  
       radius = 20,  
   },  
   {   
       x2d = 15438,   
       y2d = 7338,  
       radius = 42,  
   },  
   {   
       x2d = 15401,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 15401,   
       y2d = 7551,  
       radius = 5,  
   },  
   {   
       x2d = 15401,   
       y2d = 7751,  
       radius = 5,  
   },  
   {   
       x2d = 15416,   
       y2d = 7916,  
       radius = 20,  
   },  
   {   
       x2d = 15401,   
       y2d = 8001,  
       radius = 5,  
   },  
   {   
       x2d = 15408,   
       y2d = 8058,  
       radius = 12,  
   },  
   {   
       x2d = 15438,   
       y2d = 8488,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 8788,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 8938,  
       radius = 42,  
   },  
   {   
       x2d = 15408,   
       y2d = 9208,  
       radius = 12,  
   },  
   {   
       x2d = 15408,   
       y2d = 9258,  
       radius = 12,  
   },  
   {   
       x2d = 15423,   
       y2d = 9323,  
       radius = 27,  
   },  
   {   
       x2d = 15408,   
       y2d = 9508,  
       radius = 12,  
   },  
   {   
       x2d = 15438,   
       y2d = 9638,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 9738,  
       radius = 42,  
   },  
   {   
       x2d = 15416,   
       y2d = 9866,  
       radius = 20,  
   },  
   {   
       x2d = 15438,   
       y2d = 10088,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 10188,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 10288,  
       radius = 42,  
   },  
   {   
       x2d = 15438,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 15488,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 15488,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 15488,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 15488,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 15488,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 15488,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 15488,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 15488,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 15488,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 15488,   
       y2d = 2288,  
       radius = 42,  
   },  
   {   
       x2d = 15488,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 15488,   
       y2d = 2888,  
       radius = 42,  
   },  
   {   
       x2d = 15466,   
       y2d = 3416,  
       radius = 20,  
   },  
   {   
       x2d = 15488,   
       y2d = 3588,  
       radius = 42,  
   },  
   {   
       x2d = 15473,   
       y2d = 3723,  
       radius = 27,  
   },  
   {   
       x2d = 15451,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 15451,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 15473,   
       y2d = 4723,  
       radius = 27,  
   },  
   {   
       x2d = 15451,   
       y2d = 4801,  
       radius = 5,  
   },  
   {   
       x2d = 15451,   
       y2d = 4851,  
       radius = 5,  
   },  
   {   
       x2d = 15451,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 15458,   
       y2d = 5358,  
       radius = 12,  
   },  
   {   
       x2d = 15451,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 15451,   
       y2d = 5601,  
       radius = 5,  
   },  
   {   
       x2d = 15451,   
       y2d = 5651,  
       radius = 5,  
   },  
   {   
       x2d = 15473,   
       y2d = 5723,  
       radius = 27,  
   },  
   {   
       x2d = 15466,   
       y2d = 5816,  
       radius = 20,  
   },  
   {   
       x2d = 15488,   
       y2d = 6138,  
       radius = 42,  
   },  
   {   
       x2d = 15458,   
       y2d = 6258,  
       radius = 12,  
   },  
   {   
       x2d = 15458,   
       y2d = 6308,  
       radius = 12,  
   },  
   {   
       x2d = 15451,   
       y2d = 6601,  
       radius = 5,  
   },  
   {   
       x2d = 15458,   
       y2d = 6658,  
       radius = 12,  
   },  
   {   
       x2d = 15466,   
       y2d = 6716,  
       radius = 20,  
   },  
   {   
       x2d = 15488,   
       y2d = 6988,  
       radius = 42,  
   },  
   {   
       x2d = 15458,   
       y2d = 7108,  
       radius = 12,  
   },  
   {   
       x2d = 15451,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 15451,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 15451,   
       y2d = 7551,  
       radius = 5,  
   },  
   {   
       x2d = 15458,   
       y2d = 8008,  
       radius = 12,  
   },  
   {   
       x2d = 15451,   
       y2d = 8101,  
       radius = 5,  
   },  
   {   
       x2d = 15451,   
       y2d = 8301,  
       radius = 5,  
   },  
   {   
       x2d = 15473,   
       y2d = 8573,  
       radius = 27,  
   },  
   {   
       x2d = 15466,   
       y2d = 9116,  
       radius = 20,  
   },  
   {   
       x2d = 15473,   
       y2d = 9373,  
       radius = 27,  
   },  
   {   
       x2d = 15451,   
       y2d = 9501,  
       radius = 5,  
   },  
   {   
       x2d = 15488,   
       y2d = 9838,  
       radius = 42,  
   },  
   {   
       x2d = 15488,   
       y2d = 9938,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 15516,   
       y2d = 3016,  
       radius = 20,  
   },  
   {   
       x2d = 15538,   
       y2d = 3088,  
       radius = 42,  
   },  
   {   
       x2d = 15516,   
       y2d = 3216,  
       radius = 20,  
   },  
   {   
       x2d = 15501,   
       y2d = 3301,  
       radius = 5,  
   },  
   {   
       x2d = 15508,   
       y2d = 3358,  
       radius = 12,  
   },  
   {   
       x2d = 15531,   
       y2d = 3431,  
       radius = 35,  
   },  
   {   
       x2d = 15516,   
       y2d = 3816,  
       radius = 20,  
   },  
   {   
       x2d = 15508,   
       y2d = 3908,  
       radius = 12,  
   },  
   {   
       x2d = 15501,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 15523,   
       y2d = 4073,  
       radius = 27,  
   },  
   {   
       x2d = 15508,   
       y2d = 4158,  
       radius = 12,  
   },  
   {   
       x2d = 15508,   
       y2d = 4208,  
       radius = 12,  
   },  
   {   
       x2d = 15501,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 15501,   
       y2d = 4451,  
       radius = 5,  
   },  
   {   
       x2d = 15501,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 15538,   
       y2d = 5238,  
       radius = 42,  
   },  
   {   
       x2d = 15501,   
       y2d = 5351,  
       radius = 5,  
   },  
   {   
       x2d = 15501,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 15538,   
       y2d = 5538,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 5638,  
       radius = 42,  
   },  
   {   
       x2d = 15508,   
       y2d = 5858,  
       radius = 12,  
   },  
   {   
       x2d = 15538,   
       y2d = 6038,  
       radius = 42,  
   },  
   {   
       x2d = 15523,   
       y2d = 6223,  
       radius = 27,  
   },  
   {   
       x2d = 15501,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 15508,   
       y2d = 6608,  
       radius = 12,  
   },  
   {   
       x2d = 15508,   
       y2d = 6708,  
       radius = 12,  
   },  
   {   
       x2d = 15516,   
       y2d = 6766,  
       radius = 20,  
   },  
   {   
       x2d = 15508,   
       y2d = 7108,  
       radius = 12,  
   },  
   {   
       x2d = 15508,   
       y2d = 7158,  
       radius = 12,  
   },  
   {   
       x2d = 15531,   
       y2d = 7281,  
       radius = 35,  
   },  
   {   
       x2d = 15508,   
       y2d = 7408,  
       radius = 12,  
   },  
   {   
       x2d = 15508,   
       y2d = 7458,  
       radius = 12,  
   },  
   {   
       x2d = 15501,   
       y2d = 7551,  
       radius = 5,  
   },  
   {   
       x2d = 15501,   
       y2d = 8001,  
       radius = 5,  
   },  
   {   
       x2d = 15508,   
       y2d = 8308,  
       radius = 12,  
   },  
   {   
       x2d = 15508,   
       y2d = 8358,  
       radius = 12,  
   },  
   {   
       x2d = 15508,   
       y2d = 8408,  
       radius = 12,  
   },  
   {   
       x2d = 15523,   
       y2d = 8473,  
       radius = 27,  
   },  
   {   
       x2d = 15538,   
       y2d = 8888,  
       radius = 42,  
   },  
   {   
       x2d = 15508,   
       y2d = 9058,  
       radius = 12,  
   },  
   {   
       x2d = 15501,   
       y2d = 9201,  
       radius = 5,  
   },  
   {   
       x2d = 15508,   
       y2d = 9258,  
       radius = 12,  
   },  
   {   
       x2d = 15516,   
       y2d = 9316,  
       radius = 20,  
   },  
   {   
       x2d = 15523,   
       y2d = 9473,  
       radius = 27,  
   },  
   {   
       x2d = 15501,   
       y2d = 9551,  
       radius = 5,  
   },  
   {   
       x2d = 15538,   
       y2d = 9638,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 9738,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 10038,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 10138,  
       radius = 42,  
   },  
   {   
       x2d = 15538,   
       y2d = 10238,  
       radius = 42,  
   },  
   {   
       x2d = 15531,   
       y2d = 10331,  
       radius = 35,  
   },  
   {   
       x2d = 15588,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 15588,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 15588,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 15588,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 15588,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 15588,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 15588,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 15581,   
       y2d = 1931,  
       radius = 35,  
   },  
   {   
       x2d = 15588,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 15588,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 15588,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 15588,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 15588,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 15588,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 15588,   
       y2d = 3388,  
       radius = 42,  
   },  
   {   
       x2d = 15588,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 15551,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 15573,   
       y2d = 3723,  
       radius = 27,  
   },  
   {   
       x2d = 15558,   
       y2d = 3858,  
       radius = 12,  
   },  
   {   
       x2d = 15566,   
       y2d = 3916,  
       radius = 20,  
   },  
   {   
       x2d = 15558,   
       y2d = 3958,  
       radius = 12,  
   },  
   {   
       x2d = 15558,   
       y2d = 4008,  
       radius = 12,  
   },  
   {   
       x2d = 15551,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 15566,   
       y2d = 4366,  
       radius = 20,  
   },  
   {   
       x2d = 15558,   
       y2d = 4408,  
       radius = 12,  
   },  
   {   
       x2d = 15551,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 15551,   
       y2d = 4701,  
       radius = 5,  
   },  
   {   
       x2d = 15573,   
       y2d = 4773,  
       radius = 27,  
   },  
   {   
       x2d = 15558,   
       y2d = 5408,  
       radius = 12,  
   },  
   {   
       x2d = 15573,   
       y2d = 5723,  
       radius = 27,  
   },  
   {   
       x2d = 15551,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 15551,   
       y2d = 5851,  
       radius = 5,  
   },  
   {   
       x2d = 15588,   
       y2d = 5938,  
       radius = 42,  
   },  
   {   
       x2d = 15573,   
       y2d = 6123,  
       radius = 27,  
   },  
   {   
       x2d = 15551,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 15558,   
       y2d = 6708,  
       radius = 12,  
   },  
   {   
       x2d = 15573,   
       y2d = 7023,  
       radius = 27,  
   },  
   {   
       x2d = 15551,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 15558,   
       y2d = 7158,  
       radius = 12,  
   },  
   {   
       x2d = 15588,   
       y2d = 7238,  
       radius = 42,  
   },  
   {   
       x2d = 15551,   
       y2d = 7351,  
       radius = 5,  
   },  
   {   
       x2d = 15551,   
       y2d = 7401,  
       radius = 5,  
   },  
   {   
       x2d = 15551,   
       y2d = 7701,  
       radius = 5,  
   },  
   {   
       x2d = 15558,   
       y2d = 7958,  
       radius = 12,  
   },  
   {   
       x2d = 15588,   
       y2d = 8038,  
       radius = 42,  
   },  
   {   
       x2d = 15551,   
       y2d = 8151,  
       radius = 5,  
   },  
   {   
       x2d = 15558,   
       y2d = 8258,  
       radius = 12,  
   },  
   {   
       x2d = 15566,   
       y2d = 8366,  
       radius = 20,  
   },  
   {   
       x2d = 15551,   
       y2d = 8551,  
       radius = 5,  
   },  
   {   
       x2d = 15551,   
       y2d = 9051,  
       radius = 5,  
   },  
   {   
       x2d = 15558,   
       y2d = 9158,  
       radius = 12,  
   },  
   {   
       x2d = 15573,   
       y2d = 9273,  
       radius = 27,  
   },  
   {   
       x2d = 15551,   
       y2d = 9401,  
       radius = 5,  
   },  
   {   
       x2d = 15588,   
       y2d = 9488,  
       radius = 42,  
   },  
   {   
       x2d = 15588,   
       y2d = 9838,  
       radius = 42,  
   },  
   {   
       x2d = 15588,   
       y2d = 9938,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 3688,  
       radius = 42,  
   },  
   {   
       x2d = 15608,   
       y2d = 3808,  
       radius = 12,  
   },  
   {   
       x2d = 15608,   
       y2d = 3908,  
       radius = 12,  
   },  
   {   
       x2d = 15623,   
       y2d = 3973,  
       radius = 27,  
   },  
   {   
       x2d = 15601,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 15601,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 15601,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 15601,   
       y2d = 4701,  
       radius = 5,  
   },  
   {   
       x2d = 15631,   
       y2d = 5281,  
       radius = 35,  
   },  
   {   
       x2d = 15608,   
       y2d = 5358,  
       radius = 12,  
   },  
   {   
       x2d = 15608,   
       y2d = 5458,  
       radius = 12,  
   },  
   {   
       x2d = 15638,   
       y2d = 5588,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 5788,  
       radius = 42,  
   },  
   {   
       x2d = 15601,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 15616,   
       y2d = 6816,  
       radius = 20,  
   },  
   {   
       x2d = 15608,   
       y2d = 6958,  
       radius = 12,  
   },  
   {   
       x2d = 15623,   
       y2d = 7073,  
       radius = 27,  
   },  
   {   
       x2d = 15623,   
       y2d = 7373,  
       radius = 27,  
   },  
   {   
       x2d = 15601,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 15601,   
       y2d = 7501,  
       radius = 5,  
   },  
   {   
       x2d = 15608,   
       y2d = 8208,  
       radius = 12,  
   },  
   {   
       x2d = 15608,   
       y2d = 8258,  
       radius = 12,  
   },  
   {   
       x2d = 15601,   
       y2d = 8401,  
       radius = 5,  
   },  
   {   
       x2d = 15638,   
       y2d = 8588,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 8688,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 8788,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 8988,  
       radius = 42,  
   },  
   {   
       x2d = 15601,   
       y2d = 9101,  
       radius = 5,  
   },  
   {   
       x2d = 15638,   
       y2d = 9188,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 9588,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 9688,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 10038,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 10138,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 10238,  
       radius = 42,  
   },  
   {   
       x2d = 15638,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 15688,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 15688,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 15688,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 15688,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 15688,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 15688,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 15688,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 15688,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 15688,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 15688,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 15688,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 15688,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 15688,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 15681,   
       y2d = 3231,  
       radius = 35,  
   },  
   {   
       x2d = 15651,   
       y2d = 3301,  
       radius = 5,  
   },  
   {   
       x2d = 15688,   
       y2d = 3488,  
       radius = 42,  
   },  
   {   
       x2d = 15688,   
       y2d = 3588,  
       radius = 42,  
   },  
   {   
       x2d = 15681,   
       y2d = 3781,  
       radius = 35,  
   },  
   {   
       x2d = 15688,   
       y2d = 3938,  
       radius = 42,  
   },  
   {   
       x2d = 15688,   
       y2d = 4038,  
       radius = 42,  
   },  
   {   
       x2d = 15673,   
       y2d = 4123,  
       radius = 27,  
   },  
   {   
       x2d = 15651,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 15658,   
       y2d = 4358,  
       radius = 12,  
   },  
   {   
       x2d = 15651,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 15651,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 15651,   
       y2d = 4751,  
       radius = 5,  
   },  
   {   
       x2d = 15651,   
       y2d = 4801,  
       radius = 5,  
   },  
   {   
       x2d = 15658,   
       y2d = 4858,  
       radius = 12,  
   },  
   {   
       x2d = 15651,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 15673,   
       y2d = 5223,  
       radius = 27,  
   },  
   {   
       x2d = 15651,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 15651,   
       y2d = 6101,  
       radius = 5,  
   },  
   {   
       x2d = 15651,   
       y2d = 6151,  
       radius = 5,  
   },  
   {   
       x2d = 15651,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 15651,   
       y2d = 6401,  
       radius = 5,  
   },  
   {   
       x2d = 15651,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 15658,   
       y2d = 6608,  
       radius = 12,  
   },  
   {   
       x2d = 15651,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 15658,   
       y2d = 6758,  
       radius = 12,  
   },  
   {   
       x2d = 15658,   
       y2d = 6858,  
       radius = 12,  
   },  
   {   
       x2d = 15658,   
       y2d = 6908,  
       radius = 12,  
   },  
   {   
       x2d = 15681,   
       y2d = 7131,  
       radius = 35,  
   },  
   {   
       x2d = 15688,   
       y2d = 7238,  
       radius = 42,  
   },  
   {   
       x2d = 15651,   
       y2d = 7551,  
       radius = 5,  
   },  
   {   
       x2d = 15651,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 15688,   
       y2d = 7988,  
       radius = 42,  
   },  
   {   
       x2d = 15651,   
       y2d = 8101,  
       radius = 5,  
   },  
   {   
       x2d = 15658,   
       y2d = 8158,  
       radius = 12,  
   },  
   {   
       x2d = 15666,   
       y2d = 8216,  
       radius = 20,  
   },  
   {   
       x2d = 15658,   
       y2d = 8258,  
       radius = 12,  
   },  
   {   
       x2d = 15651,   
       y2d = 8401,  
       radius = 5,  
   },  
   {   
       x2d = 15651,   
       y2d = 8451,  
       radius = 5,  
   },  
   {   
       x2d = 15681,   
       y2d = 8881,  
       radius = 35,  
   },  
   {   
       x2d = 15651,   
       y2d = 9101,  
       radius = 5,  
   },  
   {   
       x2d = 15688,   
       y2d = 9288,  
       radius = 42,  
   },  
   {   
       x2d = 15651,   
       y2d = 9401,  
       radius = 5,  
   },  
   {   
       x2d = 15688,   
       y2d = 9488,  
       radius = 42,  
   },  
   {   
       x2d = 15673,   
       y2d = 9823,  
       radius = 27,  
   },  
   {   
       x2d = 15688,   
       y2d = 9888,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 3688,  
       radius = 42,  
   },  
   {   
       x2d = 15701,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 15701,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 15701,   
       y2d = 4451,  
       radius = 5,  
   },  
   {   
       x2d = 15701,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 15708,   
       y2d = 4608,  
       radius = 12,  
   },  
   {   
       x2d = 15738,   
       y2d = 4688,  
       radius = 42,  
   },  
   {   
       x2d = 15723,   
       y2d = 4773,  
       radius = 27,  
   },  
   {   
       x2d = 15701,   
       y2d = 4851,  
       radius = 5,  
   },  
   {   
       x2d = 15701,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 15701,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 15701,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 15731,   
       y2d = 5531,  
       radius = 35,  
   },  
   {   
       x2d = 15738,   
       y2d = 5638,  
       radius = 42,  
   },  
   {   
       x2d = 15731,   
       y2d = 5731,  
       radius = 35,  
   },  
   {   
       x2d = 15723,   
       y2d = 5873,  
       radius = 27,  
   },  
   {   
       x2d = 15701,   
       y2d = 5951,  
       radius = 5,  
   },  
   {   
       x2d = 15701,   
       y2d = 6001,  
       radius = 5,  
   },  
   {   
       x2d = 15701,   
       y2d = 6251,  
       radius = 5,  
   },  
   {   
       x2d = 15701,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 15701,   
       y2d = 6401,  
       radius = 5,  
   },  
   {   
       x2d = 15701,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 15701,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 15708,   
       y2d = 6808,  
       radius = 12,  
   },  
   {   
       x2d = 15708,   
       y2d = 6858,  
       radius = 12,  
   },  
   {   
       x2d = 15701,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 15708,   
       y2d = 7008,  
       radius = 12,  
   },  
   {   
       x2d = 15708,   
       y2d = 7058,  
       radius = 12,  
   },  
   {   
       x2d = 15701,   
       y2d = 7351,  
       radius = 5,  
   },  
   {   
       x2d = 15708,   
       y2d = 7408,  
       radius = 12,  
   },  
   {   
       x2d = 15701,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 15701,   
       y2d = 7651,  
       radius = 5,  
   },  
   {   
       x2d = 15708,   
       y2d = 8208,  
       radius = 12,  
   },  
   {   
       x2d = 15701,   
       y2d = 8351,  
       radius = 5,  
   },  
   {   
       x2d = 15701,   
       y2d = 8401,  
       radius = 5,  
   },  
   {   
       x2d = 15701,   
       y2d = 8451,  
       radius = 5,  
   },  
   {   
       x2d = 15701,   
       y2d = 8501,  
       radius = 5,  
   },  
   {   
       x2d = 15738,   
       y2d = 8588,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 8688,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 8788,  
       radius = 42,  
   },  
   {   
       x2d = 15723,   
       y2d = 8973,  
       radius = 27,  
   },  
   {   
       x2d = 15731,   
       y2d = 9031,  
       radius = 35,  
   },  
   {   
       x2d = 15738,   
       y2d = 9138,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 9588,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 9688,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 9988,  
       radius = 42,  
   },  
   {   
       x2d = 15738,   
       y2d = 10088,  
       radius = 42,  
   },  
   {   
       x2d = 15723,   
       y2d = 10223,  
       radius = 27,  
   },  
   {   
       x2d = 15738,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 15788,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 15788,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 15788,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 15788,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 15788,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 15788,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 15788,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 15788,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 15788,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 15788,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 15788,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 15788,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 15788,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 15773,   
       y2d = 3223,  
       radius = 27,  
   },  
   {   
       x2d = 15751,   
       y2d = 3301,  
       radius = 5,  
   },  
   {   
       x2d = 15788,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 15788,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 15773,   
       y2d = 3773,  
       radius = 27,  
   },  
   {   
       x2d = 15788,   
       y2d = 3938,  
       radius = 42,  
   },  
   {   
       x2d = 15773,   
       y2d = 4023,  
       radius = 27,  
   },  
   {   
       x2d = 15751,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 15751,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 15758,   
       y2d = 4458,  
       radius = 12,  
   },  
   {   
       x2d = 15758,   
       y2d = 4508,  
       radius = 12,  
   },  
   {   
       x2d = 15751,   
       y2d = 4901,  
       radius = 5,  
   },  
   {   
       x2d = 15751,   
       y2d = 5001,  
       radius = 5,  
   },  
   {   
       x2d = 15758,   
       y2d = 5208,  
       radius = 12,  
   },  
   {   
       x2d = 15758,   
       y2d = 5258,  
       radius = 12,  
   },  
   {   
       x2d = 15751,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 15758,   
       y2d = 5358,  
       radius = 12,  
   },  
   {   
       x2d = 15758,   
       y2d = 5458,  
       radius = 12,  
   },  
   {   
       x2d = 15773,   
       y2d = 5923,  
       radius = 27,  
   },  
   {   
       x2d = 15751,   
       y2d = 6001,  
       radius = 5,  
   },  
   {   
       x2d = 15766,   
       y2d = 6166,  
       radius = 20,  
   },  
   {   
       x2d = 15773,   
       y2d = 6373,  
       radius = 27,  
   },  
   {   
       x2d = 15751,   
       y2d = 6701,  
       radius = 5,  
   },  
   {   
       x2d = 15751,   
       y2d = 6801,  
       radius = 5,  
   },  
   {   
       x2d = 15751,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 15751,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 15751,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 15758,   
       y2d = 7058,  
       radius = 12,  
   },  
   {   
       x2d = 15773,   
       y2d = 7173,  
       radius = 27,  
   },  
   {   
       x2d = 15766,   
       y2d = 7366,  
       radius = 20,  
   },  
   {   
       x2d = 15751,   
       y2d = 7501,  
       radius = 5,  
   },  
   {   
       x2d = 15751,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 15751,   
       y2d = 7751,  
       radius = 5,  
   },  
   {   
       x2d = 15773,   
       y2d = 7873,  
       radius = 27,  
   },  
   {   
       x2d = 15766,   
       y2d = 8016,  
       radius = 20,  
   },  
   {   
       x2d = 15751,   
       y2d = 8301,  
       radius = 5,  
   },  
   {   
       x2d = 15781,   
       y2d = 8481,  
       radius = 35,  
   },  
   {   
       x2d = 15788,   
       y2d = 8888,  
       radius = 42,  
   },  
   {   
       x2d = 15788,   
       y2d = 9238,  
       radius = 42,  
   },  
   {   
       x2d = 15781,   
       y2d = 9331,  
       radius = 35,  
   },  
   {   
       x2d = 15773,   
       y2d = 9423,  
       radius = 27,  
   },  
   {   
       x2d = 15788,   
       y2d = 9488,  
       radius = 42,  
   },  
   {   
       x2d = 15751,   
       y2d = 9801,  
       radius = 5,  
   },  
   {   
       x2d = 15788,   
       y2d = 9888,  
       radius = 42,  
   },  
   {   
       x2d = 15788,   
       y2d = 10238,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 3088,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 3188,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 15823,   
       y2d = 3723,  
       radius = 27,  
   },  
   {   
       x2d = 15823,   
       y2d = 3823,  
       radius = 27,  
   },  
   {   
       x2d = 15801,   
       y2d = 4201,  
       radius = 5,  
   },  
   {   
       x2d = 15801,   
       y2d = 4401,  
       radius = 5,  
   },  
   {   
       x2d = 15831,   
       y2d = 4481,  
       radius = 35,  
   },  
   {   
       x2d = 15808,   
       y2d = 4608,  
       radius = 12,  
   },  
   {   
       x2d = 15831,   
       y2d = 4731,  
       radius = 35,  
   },  
   {   
       x2d = 15816,   
       y2d = 4816,  
       radius = 20,  
   },  
   {   
       x2d = 15801,   
       y2d = 4901,  
       radius = 5,  
   },  
   {   
       x2d = 15808,   
       y2d = 5158,  
       radius = 12,  
   },  
   {   
       x2d = 15801,   
       y2d = 5201,  
       radius = 5,  
   },  
   {   
       x2d = 15816,   
       y2d = 5266,  
       radius = 20,  
   },  
   {   
       x2d = 15808,   
       y2d = 5358,  
       radius = 12,  
   },  
   {   
       x2d = 15808,   
       y2d = 5408,  
       radius = 12,  
   },  
   {   
       x2d = 15823,   
       y2d = 5523,  
       radius = 27,  
   },  
   {   
       x2d = 15823,   
       y2d = 5623,  
       radius = 27,  
   },  
   {   
       x2d = 15823,   
       y2d = 5723,  
       radius = 27,  
   },  
   {   
       x2d = 15808,   
       y2d = 5808,  
       radius = 12,  
   },  
   {   
       x2d = 15816,   
       y2d = 5866,  
       radius = 20,  
   },  
   {   
       x2d = 15816,   
       y2d = 6316,  
       radius = 20,  
   },  
   {   
       x2d = 15801,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 15808,   
       y2d = 6808,  
       radius = 12,  
   },  
   {   
       x2d = 15808,   
       y2d = 6858,  
       radius = 12,  
   },  
   {   
       x2d = 15816,   
       y2d = 7016,  
       radius = 20,  
   },  
   {   
       x2d = 15801,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 15801,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 15808,   
       y2d = 7308,  
       radius = 12,  
   },  
   {   
       x2d = 15808,   
       y2d = 7358,  
       radius = 12,  
   },  
   {   
       x2d = 15801,   
       y2d = 7401,  
       radius = 5,  
   },  
   {   
       x2d = 15808,   
       y2d = 7558,  
       radius = 12,  
   },  
   {   
       x2d = 15801,   
       y2d = 7701,  
       radius = 5,  
   },  
   {   
       x2d = 15816,   
       y2d = 7966,  
       radius = 20,  
   },  
   {   
       x2d = 15816,   
       y2d = 8016,  
       radius = 20,  
   },  
   {   
       x2d = 15823,   
       y2d = 8173,  
       radius = 27,  
   },  
   {   
       x2d = 15801,   
       y2d = 8251,  
       radius = 5,  
   },  
   {   
       x2d = 15808,   
       y2d = 8358,  
       radius = 12,  
   },  
   {   
       x2d = 15801,   
       y2d = 8401,  
       radius = 5,  
   },  
   {   
       x2d = 15838,   
       y2d = 8688,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 8788,  
       radius = 42,  
   },  
   {   
       x2d = 15801,   
       y2d = 9051,  
       radius = 5,  
   },  
   {   
       x2d = 15838,   
       y2d = 9138,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 9588,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 9688,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 9788,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 9988,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 10088,  
       radius = 42,  
   },  
   {   
       x2d = 15838,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 15888,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 15888,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 15888,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 15888,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 15888,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 15888,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 15888,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 15888,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 15888,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 15888,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 15888,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 15888,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 15881,   
       y2d = 2931,  
       radius = 35,  
   },  
   {   
       x2d = 15851,   
       y2d = 3301,  
       radius = 5,  
   },  
   {   
       x2d = 15873,   
       y2d = 3373,  
       radius = 27,  
   },  
   {   
       x2d = 15888,   
       y2d = 3488,  
       radius = 42,  
   },  
   {   
       x2d = 15866,   
       y2d = 3866,  
       radius = 20,  
   },  
   {   
       x2d = 15866,   
       y2d = 3916,  
       radius = 20,  
   },  
   {   
       x2d = 15851,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 15851,   
       y2d = 4201,  
       radius = 5,  
   },  
   {   
       x2d = 15851,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 15851,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 15851,   
       y2d = 4351,  
       radius = 5,  
   },  
   {   
       x2d = 15866,   
       y2d = 4566,  
       radius = 20,  
   },  
   {   
       x2d = 15858,   
       y2d = 4608,  
       radius = 12,  
   },  
   {   
       x2d = 15858,   
       y2d = 4858,  
       radius = 12,  
   },  
   {   
       x2d = 15851,   
       y2d = 5101,  
       radius = 5,  
   },  
   {   
       x2d = 15866,   
       y2d = 5316,  
       radius = 20,  
   },  
   {   
       x2d = 15858,   
       y2d = 5358,  
       radius = 12,  
   },  
   {   
       x2d = 15851,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 15851,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 15888,   
       y2d = 5888,  
       radius = 42,  
   },  
   {   
       x2d = 15858,   
       y2d = 6008,  
       radius = 12,  
   },  
   {   
       x2d = 15858,   
       y2d = 6108,  
       radius = 12,  
   },  
   {   
       x2d = 15851,   
       y2d = 6151,  
       radius = 5,  
   },  
   {   
       x2d = 15851,   
       y2d = 6251,  
       radius = 5,  
   },  
   {   
       x2d = 15873,   
       y2d = 6373,  
       radius = 27,  
   },  
   {   
       x2d = 15851,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 15851,   
       y2d = 7051,  
       radius = 5,  
   },  
   {   
       x2d = 15858,   
       y2d = 7108,  
       radius = 12,  
   },  
   {   
       x2d = 15858,   
       y2d = 7208,  
       radius = 12,  
   },  
   {   
       x2d = 15851,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 15851,   
       y2d = 7401,  
       radius = 5,  
   },  
   {   
       x2d = 15858,   
       y2d = 7808,  
       radius = 12,  
   },  
   {   
       x2d = 15866,   
       y2d = 7966,  
       radius = 20,  
   },  
   {   
       x2d = 15866,   
       y2d = 8316,  
       radius = 20,  
   },  
   {   
       x2d = 15851,   
       y2d = 8501,  
       radius = 5,  
   },  
   {   
       x2d = 15866,   
       y2d = 8916,  
       radius = 20,  
   },  
   {   
       x2d = 15858,   
       y2d = 8958,  
       radius = 12,  
   },  
   {   
       x2d = 15858,   
       y2d = 9008,  
       radius = 12,  
   },  
   {   
       x2d = 15888,   
       y2d = 9238,  
       radius = 42,  
   },  
   {   
       x2d = 15851,   
       y2d = 9351,  
       radius = 5,  
   },  
   {   
       x2d = 15888,   
       y2d = 9488,  
       radius = 42,  
   },  
   {   
       x2d = 15888,   
       y2d = 9888,  
       radius = 42,  
   },  
   {   
       x2d = 15888,   
       y2d = 10188,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 15916,   
       y2d = 3166,  
       radius = 20,  
   },  
   {   
       x2d = 15916,   
       y2d = 3216,  
       radius = 20,  
   },  
   {   
       x2d = 15901,   
       y2d = 3301,  
       radius = 5,  
   },  
   {   
       x2d = 15908,   
       y2d = 3708,  
       radius = 12,  
   },  
   {   
       x2d = 15931,   
       y2d = 3781,  
       radius = 35,  
   },  
   {   
       x2d = 15916,   
       y2d = 3866,  
       radius = 20,  
   },  
   {   
       x2d = 15901,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 15901,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 15908,   
       y2d = 4208,  
       radius = 12,  
   },  
   {   
       x2d = 15901,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 15901,   
       y2d = 4351,  
       radius = 5,  
   },  
   {   
       x2d = 15901,   
       y2d = 4401,  
       radius = 5,  
   },  
   {   
       x2d = 15901,   
       y2d = 4451,  
       radius = 5,  
   },  
   {   
       x2d = 15901,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 15931,   
       y2d = 4731,  
       radius = 35,  
   },  
   {   
       x2d = 15901,   
       y2d = 5101,  
       radius = 5,  
   },  
   {   
       x2d = 15923,   
       y2d = 5273,  
       radius = 27,  
   },  
   {   
       x2d = 15901,   
       y2d = 5351,  
       radius = 5,  
   },  
   {   
       x2d = 15923,   
       y2d = 5523,  
       radius = 27,  
   },  
   {   
       x2d = 15901,   
       y2d = 5601,  
       radius = 5,  
   },  
   {   
       x2d = 15931,   
       y2d = 5681,  
       radius = 35,  
   },  
   {   
       x2d = 15908,   
       y2d = 5758,  
       radius = 12,  
   },  
   {   
       x2d = 15916,   
       y2d = 6216,  
       radius = 20,  
   },  
   {   
       x2d = 15901,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 15938,   
       y2d = 6538,  
       radius = 42,  
   },  
   {   
       x2d = 15901,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 15901,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 15908,   
       y2d = 6958,  
       radius = 12,  
   },  
   {   
       x2d = 15923,   
       y2d = 7023,  
       radius = 27,  
   },  
   {   
       x2d = 15901,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 15908,   
       y2d = 7258,  
       radius = 12,  
   },  
   {   
       x2d = 15901,   
       y2d = 7301,  
       radius = 5,  
   },  
   {   
       x2d = 15908,   
       y2d = 7458,  
       radius = 12,  
   },  
   {   
       x2d = 15901,   
       y2d = 7501,  
       radius = 5,  
   },  
   {   
       x2d = 15908,   
       y2d = 7558,  
       radius = 12,  
   },  
   {   
       x2d = 15901,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 15901,   
       y2d = 7701,  
       radius = 5,  
   },  
   {   
       x2d = 15916,   
       y2d = 7816,  
       radius = 20,  
   },  
   {   
       x2d = 15916,   
       y2d = 7966,  
       radius = 20,  
   },  
   {   
       x2d = 15908,   
       y2d = 8108,  
       radius = 12,  
   },  
   {   
       x2d = 15901,   
       y2d = 8201,  
       radius = 5,  
   },  
   {   
       x2d = 15901,   
       y2d = 8351,  
       radius = 5,  
   },  
   {   
       x2d = 15901,   
       y2d = 8401,  
       radius = 5,  
   },  
   {   
       x2d = 15916,   
       y2d = 8516,  
       radius = 20,  
   },  
   {   
       x2d = 15938,   
       y2d = 8688,  
       radius = 42,  
   },  
   {   
       x2d = 15923,   
       y2d = 8873,  
       radius = 27,  
   },  
   {   
       x2d = 15901,   
       y2d = 9001,  
       radius = 5,  
   },  
   {   
       x2d = 15938,   
       y2d = 9088,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 9338,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 9588,  
       radius = 42,  
   },  
   {   
       x2d = 15923,   
       y2d = 9673,  
       radius = 27,  
   },  
   {   
       x2d = 15916,   
       y2d = 9766,  
       radius = 20,  
   },  
   {   
       x2d = 15938,   
       y2d = 9988,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 10088,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 10288,  
       radius = 42,  
   },  
   {   
       x2d = 15938,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 15988,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 15988,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 15988,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 15988,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 15988,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 15988,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 15988,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 15988,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 15988,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 15988,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 15988,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 15988,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 15988,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 15988,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 15951,   
       y2d = 3301,  
       radius = 5,  
   },  
   {   
       x2d = 15988,   
       y2d = 3388,  
       radius = 42,  
   },  
   {   
       x2d = 15988,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 15981,   
       y2d = 3681,  
       radius = 35,  
   },  
   {   
       x2d = 15951,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 15966,   
       y2d = 4216,  
       radius = 20,  
   },  
   {   
       x2d = 15951,   
       y2d = 4351,  
       radius = 5,  
   },  
   {   
       x2d = 15958,   
       y2d = 4408,  
       radius = 12,  
   },  
   {   
       x2d = 15966,   
       y2d = 4466,  
       radius = 20,  
   },  
   {   
       x2d = 15958,   
       y2d = 4508,  
       radius = 12,  
   },  
   {   
       x2d = 15988,   
       y2d = 4638,  
       radius = 42,  
   },  
   {   
       x2d = 15958,   
       y2d = 4808,  
       radius = 12,  
   },  
   {   
       x2d = 15951,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 15988,   
       y2d = 5588,  
       radius = 42,  
   },  
   {   
       x2d = 15951,   
       y2d = 5751,  
       radius = 5,  
   },  
   {   
       x2d = 15988,   
       y2d = 5888,  
       radius = 42,  
   },  
   {   
       x2d = 15951,   
       y2d = 6001,  
       radius = 5,  
   },  
   {   
       x2d = 15951,   
       y2d = 6251,  
       radius = 5,  
   },  
   {   
       x2d = 15958,   
       y2d = 6308,  
       radius = 12,  
   },  
   {   
       x2d = 15951,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 15966,   
       y2d = 6416,  
       radius = 20,  
   },  
   {   
       x2d = 15951,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 15951,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 15958,   
       y2d = 7158,  
       radius = 12,  
   },  
   {   
       x2d = 15951,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 15988,   
       y2d = 7338,  
       radius = 42,  
   },  
   {   
       x2d = 15958,   
       y2d = 7508,  
       radius = 12,  
   },  
   {   
       x2d = 15958,   
       y2d = 7608,  
       radius = 12,  
   },  
   {   
       x2d = 15966,   
       y2d = 7816,  
       radius = 20,  
   },  
   {   
       x2d = 15958,   
       y2d = 7958,  
       radius = 12,  
   },  
   {   
       x2d = 15958,   
       y2d = 8058,  
       radius = 12,  
   },  
   {   
       x2d = 15973,   
       y2d = 8123,  
       radius = 27,  
   },  
   {   
       x2d = 15966,   
       y2d = 8316,  
       radius = 20,  
   },  
   {   
       x2d = 15951,   
       y2d = 8401,  
       radius = 5,  
   },  
   {   
       x2d = 15981,   
       y2d = 8781,  
       radius = 35,  
   },  
   {   
       x2d = 15951,   
       y2d = 8951,  
       radius = 5,  
   },  
   {   
       x2d = 15951,   
       y2d = 9001,  
       radius = 5,  
   },  
   {   
       x2d = 15966,   
       y2d = 9216,  
       radius = 20,  
   },  
   {   
       x2d = 15988,   
       y2d = 9838,  
       radius = 42,  
   },  
   {   
       x2d = 15988,   
       y2d = 10188,  
       radius = 42,  
   },  
   {   
       x2d = 16038,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 16038,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 16038,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 16038,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 16038,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 16038,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 16038,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 16038,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 16038,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 16038,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 16038,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 16038,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 16038,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 16038,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 16038,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 16038,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 16038,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 16038,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 16008,   
       y2d = 3758,  
       radius = 12,  
   },  
   {   
       x2d = 16001,   
       y2d = 3801,  
       radius = 5,  
   },  
   {   
       x2d = 16038,   
       y2d = 4188,  
       radius = 42,  
   },  
   {   
       x2d = 16016,   
       y2d = 4366,  
       radius = 20,  
   },  
   {   
       x2d = 16001,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 16038,   
       y2d = 4738,  
       radius = 42,  
   },  
   {   
       x2d = 16008,   
       y2d = 5308,  
       radius = 12,  
   },  
   {   
       x2d = 16001,   
       y2d = 5701,  
       radius = 5,  
   },  
   {   
       x2d = 16008,   
       y2d = 6158,  
       radius = 12,  
   },  
   {   
       x2d = 16001,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 16023,   
       y2d = 6473,  
       radius = 27,  
   },  
   {   
       x2d = 16001,   
       y2d = 6601,  
       radius = 5,  
   },  
   {   
       x2d = 16001,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 16001,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 16001,   
       y2d = 7151,  
       radius = 5,  
   },  
   {   
       x2d = 16008,   
       y2d = 7208,  
       radius = 12,  
   },  
   {   
       x2d = 16023,   
       y2d = 7473,  
       radius = 27,  
   },  
   {   
       x2d = 16001,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 16001,   
       y2d = 7651,  
       radius = 5,  
   },  
   {   
       x2d = 16001,   
       y2d = 7701,  
       radius = 5,  
   },  
   {   
       x2d = 16031,   
       y2d = 7781,  
       radius = 35,  
   },  
   {   
       x2d = 16016,   
       y2d = 7966,  
       radius = 20,  
   },  
   {   
       x2d = 16016,   
       y2d = 8316,  
       radius = 20,  
   },  
   {   
       x2d = 16016,   
       y2d = 8366,  
       radius = 20,  
   },  
   {   
       x2d = 16008,   
       y2d = 8858,  
       radius = 12,  
   },  
   {   
       x2d = 16001,   
       y2d = 8951,  
       radius = 5,  
   },  
   {   
       x2d = 16016,   
       y2d = 9066,  
       radius = 20,  
   },  
   {   
       x2d = 16001,   
       y2d = 9151,  
       radius = 5,  
   },  
   {   
       x2d = 16023,   
       y2d = 9223,  
       radius = 27,  
   },  
   {   
       x2d = 16008,   
       y2d = 9408,  
       radius = 12,  
   },  
   {   
       x2d = 16001,   
       y2d = 9451,  
       radius = 5,  
   },  
   {   
       x2d = 16008,   
       y2d = 9508,  
       radius = 12,  
   },  
   {   
       x2d = 16001,   
       y2d = 9751,  
       radius = 5,  
   },  
   {   
       x2d = 16023,   
       y2d = 9923,  
       radius = 27,  
   },  
   {   
       x2d = 16038,   
       y2d = 10038,  
       radius = 42,  
   },  
   {   
       x2d = 16038,   
       y2d = 10288,  
       radius = 42,  
   },  
   {   
       x2d = 16031,   
       y2d = 10381,  
       radius = 35,  
   },  
   {   
       x2d = 16088,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 16088,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 16088,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 16088,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 16088,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 16088,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 16088,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 16088,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 16088,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 16088,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 16088,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 16088,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 16073,   
       y2d = 3123,  
       radius = 27,  
   },  
   {   
       x2d = 16051,   
       y2d = 3251,  
       radius = 5,  
   },  
   {   
       x2d = 16088,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 16088,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 16081,   
       y2d = 3531,  
       radius = 35,  
   },  
   {   
       x2d = 16088,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 16051,   
       y2d = 3751,  
       radius = 5,  
   },  
   {   
       x2d = 16051,   
       y2d = 3851,  
       radius = 5,  
   },  
   {   
       x2d = 16051,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 16051,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 16058,   
       y2d = 4358,  
       radius = 12,  
   },  
   {   
       x2d = 16081,   
       y2d = 4431,  
       radius = 35,  
   },  
   {   
       x2d = 16051,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 16051,   
       y2d = 4551,  
       radius = 5,  
   },  
   {   
       x2d = 16051,   
       y2d = 4851,  
       radius = 5,  
   },  
   {   
       x2d = 16051,   
       y2d = 4901,  
       radius = 5,  
   },  
   {   
       x2d = 16051,   
       y2d = 4951,  
       radius = 5,  
   },  
   {   
       x2d = 16058,   
       y2d = 5308,  
       radius = 12,  
   },  
   {   
       x2d = 16058,   
       y2d = 5458,  
       radius = 12,  
   },  
   {   
       x2d = 16058,   
       y2d = 5508,  
       radius = 12,  
   },  
   {   
       x2d = 16088,   
       y2d = 5688,  
       radius = 42,  
   },  
   {   
       x2d = 16073,   
       y2d = 5923,  
       radius = 27,  
   },  
   {   
       x2d = 16088,   
       y2d = 6038,  
       radius = 42,  
   },  
   {   
       x2d = 16088,   
       y2d = 6238,  
       radius = 42,  
   },  
   {   
       x2d = 16088,   
       y2d = 6388,  
       radius = 42,  
   },  
   {   
       x2d = 16051,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 16058,   
       y2d = 7158,  
       radius = 12,  
   },  
   {   
       x2d = 16073,   
       y2d = 7273,  
       radius = 27,  
   },  
   {   
       x2d = 16066,   
       y2d = 7366,  
       radius = 20,  
   },  
   {   
       x2d = 16058,   
       y2d = 7608,  
       radius = 12,  
   },  
   {   
       x2d = 16051,   
       y2d = 7701,  
       radius = 5,  
   },  
   {   
       x2d = 16058,   
       y2d = 7958,  
       radius = 12,  
   },  
   {   
       x2d = 16051,   
       y2d = 8051,  
       radius = 5,  
   },  
   {   
       x2d = 16051,   
       y2d = 8151,  
       radius = 5,  
   },  
   {   
       x2d = 16051,   
       y2d = 8251,  
       radius = 5,  
   },  
   {   
       x2d = 16051,   
       y2d = 8501,  
       radius = 5,  
   },  
   {   
       x2d = 16058,   
       y2d = 8558,  
       radius = 12,  
   },  
   {   
       x2d = 16051,   
       y2d = 8601,  
       radius = 5,  
   },  
   {   
       x2d = 16058,   
       y2d = 8658,  
       radius = 12,  
   },  
   {   
       x2d = 16051,   
       y2d = 8751,  
       radius = 5,  
   },  
   {   
       x2d = 16066,   
       y2d = 8866,  
       radius = 20,  
   },  
   {   
       x2d = 16058,   
       y2d = 9008,  
       radius = 12,  
   },  
   {   
       x2d = 16051,   
       y2d = 9151,  
       radius = 5,  
   },  
   {   
       x2d = 16051,   
       y2d = 9301,  
       radius = 5,  
   },  
   {   
       x2d = 16066,   
       y2d = 9416,  
       radius = 20,  
   },  
   {   
       x2d = 16088,   
       y2d = 9838,  
       radius = 42,  
   },  
   {   
       x2d = 16138,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 16138,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 16138,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 16138,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 16138,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 16138,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 16138,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 16138,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 16138,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 16138,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 16138,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 16138,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 16131,   
       y2d = 2131,  
       radius = 35,  
   },  
   {   
       x2d = 16131,   
       y2d = 2531,  
       radius = 35,  
   },  
   {   
       x2d = 16138,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 16138,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 16131,   
       y2d = 2831,  
       radius = 35,  
   },  
   {   
       x2d = 16101,   
       y2d = 2901,  
       radius = 5,  
   },  
   {   
       x2d = 16123,   
       y2d = 2973,  
       radius = 27,  
   },  
   {   
       x2d = 16123,   
       y2d = 3723,  
       radius = 27,  
   },  
   {   
       x2d = 16101,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 16138,   
       y2d = 4138,  
       radius = 42,  
   },  
   {   
       x2d = 16138,   
       y2d = 4238,  
       radius = 42,  
   },  
   {   
       x2d = 16108,   
       y2d = 4358,  
       radius = 12,  
   },  
   {   
       x2d = 16138,   
       y2d = 4538,  
       radius = 42,  
   },  
   {   
       x2d = 16116,   
       y2d = 4716,  
       radius = 20,  
   },  
   {   
       x2d = 16131,   
       y2d = 4781,  
       radius = 35,  
   },  
   {   
       x2d = 16123,   
       y2d = 5273,  
       radius = 27,  
   },  
   {   
       x2d = 16101,   
       y2d = 5351,  
       radius = 5,  
   },  
   {   
       x2d = 16138,   
       y2d = 5538,  
       radius = 42,  
   },  
   {   
       x2d = 16108,   
       y2d = 5858,  
       radius = 12,  
   },  
   {   
       x2d = 16138,   
       y2d = 6138,  
       radius = 42,  
   },  
   {   
       x2d = 16101,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 16101,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 16138,   
       y2d = 7188,  
       radius = 42,  
   },  
   {   
       x2d = 16138,   
       y2d = 7338,  
       radius = 42,  
   },  
   {   
       x2d = 16131,   
       y2d = 7481,  
       radius = 35,  
   },  
   {   
       x2d = 16108,   
       y2d = 7558,  
       radius = 12,  
   },  
   {   
       x2d = 16101,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 16116,   
       y2d = 7666,  
       radius = 20,  
   },  
   {   
       x2d = 16116,   
       y2d = 7766,  
       radius = 20,  
   },  
   {   
       x2d = 16101,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 16101,   
       y2d = 8051,  
       radius = 5,  
   },  
   {   
       x2d = 16101,   
       y2d = 8151,  
       radius = 5,  
   },  
   {   
       x2d = 16116,   
       y2d = 8516,  
       radius = 20,  
   },  
   {   
       x2d = 16101,   
       y2d = 8651,  
       radius = 5,  
   },  
   {   
       x2d = 16131,   
       y2d = 8731,  
       radius = 35,  
   },  
   {   
       x2d = 16101,   
       y2d = 8801,  
       radius = 5,  
   },  
   {   
       x2d = 16123,   
       y2d = 8873,  
       radius = 27,  
   },  
   {   
       x2d = 16101,   
       y2d = 8951,  
       radius = 5,  
   },  
   {   
       x2d = 16123,   
       y2d = 9223,  
       radius = 27,  
   },  
   {   
       x2d = 16116,   
       y2d = 9366,  
       radius = 20,  
   },  
   {   
       x2d = 16108,   
       y2d = 9458,  
       radius = 12,  
   },  
   {   
       x2d = 16101,   
       y2d = 9751,  
       radius = 5,  
   },  
   {   
       x2d = 16138,   
       y2d = 10038,  
       radius = 42,  
   },  
   {   
       x2d = 16138,   
       y2d = 10138,  
       radius = 42,  
   },  
   {   
       x2d = 16138,   
       y2d = 10288,  
       radius = 42,  
   },  
   {   
       x2d = 16138,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 16188,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 16188,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 16188,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 16188,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 16188,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 16188,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 16188,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 16188,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 16188,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 16188,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 16188,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 16188,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 16188,   
       y2d = 2988,  
       radius = 42,  
   },  
   {   
       x2d = 16173,   
       y2d = 3123,  
       radius = 27,  
   },  
   {   
       x2d = 16188,   
       y2d = 3288,  
       radius = 42,  
   },  
   {   
       x2d = 16188,   
       y2d = 3388,  
       radius = 42,  
   },  
   {   
       x2d = 16158,   
       y2d = 3508,  
       radius = 12,  
   },  
   {   
       x2d = 16151,   
       y2d = 3551,  
       radius = 5,  
   },  
   {   
       x2d = 16151,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 16158,   
       y2d = 4008,  
       radius = 12,  
   },  
   {   
       x2d = 16151,   
       y2d = 4451,  
       radius = 5,  
   },  
   {   
       x2d = 16158,   
       y2d = 4658,  
       radius = 12,  
   },  
   {   
       x2d = 16188,   
       y2d = 4738,  
       radius = 42,  
   },  
   {   
       x2d = 16151,   
       y2d = 4851,  
       radius = 5,  
   },  
   {   
       x2d = 16173,   
       y2d = 5223,  
       radius = 27,  
   },  
   {   
       x2d = 16173,   
       y2d = 5673,  
       radius = 27,  
   },  
   {   
       x2d = 16158,   
       y2d = 5758,  
       radius = 12,  
   },  
   {   
       x2d = 16151,   
       y2d = 5851,  
       radius = 5,  
   },  
   {   
       x2d = 16158,   
       y2d = 5908,  
       radius = 12,  
   },  
   {   
       x2d = 16188,   
       y2d = 5988,  
       radius = 42,  
   },  
   {   
       x2d = 16173,   
       y2d = 6273,  
       radius = 27,  
   },  
   {   
       x2d = 16151,   
       y2d = 6501,  
       radius = 5,  
   },  
   {   
       x2d = 16151,   
       y2d = 7051,  
       radius = 5,  
   },  
   {   
       x2d = 16188,   
       y2d = 7438,  
       radius = 42,  
   },  
   {   
       x2d = 16151,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 16166,   
       y2d = 8116,  
       radius = 20,  
   },  
   {   
       x2d = 16151,   
       y2d = 8201,  
       radius = 5,  
   },  
   {   
       x2d = 16151,   
       y2d = 8551,  
       radius = 5,  
   },  
   {   
       x2d = 16151,   
       y2d = 8601,  
       radius = 5,  
   },  
   {   
       x2d = 16151,   
       y2d = 8651,  
       radius = 5,  
   },  
   {   
       x2d = 16151,   
       y2d = 8801,  
       radius = 5,  
   },  
   {   
       x2d = 16181,   
       y2d = 8881,  
       radius = 35,  
   },  
   {   
       x2d = 16151,   
       y2d = 9001,  
       radius = 5,  
   },  
   {   
       x2d = 16188,   
       y2d = 9188,  
       radius = 42,  
   },  
   {   
       x2d = 16151,   
       y2d = 9451,  
       radius = 5,  
   },  
   {   
       x2d = 16151,   
       y2d = 9501,  
       radius = 5,  
   },  
   {   
       x2d = 16166,   
       y2d = 9816,  
       radius = 20,  
   },  
   {   
       x2d = 16166,   
       y2d = 9866,  
       radius = 20,  
   },  
   {   
       x2d = 16238,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 16238,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 16238,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 16238,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 16238,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 16238,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 16238,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 16238,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 16238,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 16238,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 16238,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 16238,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 16238,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 16238,   
       y2d = 2588,  
       radius = 42,  
   },  
   {   
       x2d = 16238,   
       y2d = 2688,  
       radius = 42,  
   },  
   {   
       x2d = 16238,   
       y2d = 2788,  
       radius = 42,  
   },  
   {   
       x2d = 16238,   
       y2d = 3488,  
       radius = 42,  
   },  
   {   
       x2d = 16201,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 16201,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 16201,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 16216,   
       y2d = 4066,  
       radius = 20,  
   },  
   {   
       x2d = 16238,   
       y2d = 4138,  
       radius = 42,  
   },  
   {   
       x2d = 16238,   
       y2d = 4238,  
       radius = 42,  
   },  
   {   
       x2d = 16201,   
       y2d = 4401,  
       radius = 5,  
   },  
   {   
       x2d = 16223,   
       y2d = 4523,  
       radius = 27,  
   },  
   {   
       x2d = 16201,   
       y2d = 4601,  
       radius = 5,  
   },  
   {   
       x2d = 16201,   
       y2d = 4651,  
       radius = 5,  
   },  
   {   
       x2d = 16216,   
       y2d = 5266,  
       radius = 20,  
   },  
   {   
       x2d = 16216,   
       y2d = 5516,  
       radius = 20,  
   },  
   {   
       x2d = 16238,   
       y2d = 5588,  
       radius = 42,  
   },  
   {   
       x2d = 16201,   
       y2d = 5851,  
       radius = 5,  
   },  
   {   
       x2d = 16238,   
       y2d = 6088,  
       radius = 42,  
   },  
   {   
       x2d = 16223,   
       y2d = 6223,  
       radius = 27,  
   },  
   {   
       x2d = 16223,   
       y2d = 6323,  
       radius = 27,  
   },  
   {   
       x2d = 16201,   
       y2d = 6451,  
       radius = 5,  
   },  
   {   
       x2d = 16201,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 16201,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 16201,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 16223,   
       y2d = 7523,  
       radius = 27,  
   },  
   {   
       x2d = 16201,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 16201,   
       y2d = 7651,  
       radius = 5,  
   },  
   {   
       x2d = 16201,   
       y2d = 8051,  
       radius = 5,  
   },  
   {   
       x2d = 16208,   
       y2d = 8108,  
       radius = 12,  
   },  
   {   
       x2d = 16216,   
       y2d = 8216,  
       radius = 20,  
   },  
   {   
       x2d = 16201,   
       y2d = 8551,  
       radius = 5,  
   },  
   {   
       x2d = 16201,   
       y2d = 8651,  
       radius = 5,  
   },  
   {   
       x2d = 16201,   
       y2d = 8801,  
       radius = 5,  
   },  
   {   
       x2d = 16201,   
       y2d = 8951,  
       radius = 5,  
   },  
   {   
       x2d = 16201,   
       y2d = 9001,  
       radius = 5,  
   },  
   {   
       x2d = 16216,   
       y2d = 9316,  
       radius = 20,  
   },  
   {   
       x2d = 16201,   
       y2d = 9601,  
       radius = 5,  
   },  
   {   
       x2d = 16201,   
       y2d = 9651,  
       radius = 5,  
   },  
   {   
       x2d = 16216,   
       y2d = 9866,  
       radius = 20,  
   },  
   {   
       x2d = 16231,   
       y2d = 10031,  
       radius = 35,  
   },  
   {   
       x2d = 16238,   
       y2d = 10138,  
       radius = 42,  
   },  
   {   
       x2d = 16223,   
       y2d = 10223,  
       radius = 27,  
   },  
   {   
       x2d = 16238,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 16288,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 16288,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 16288,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 16288,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 16288,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 16288,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 16288,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 16288,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 16288,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 16288,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 16288,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 16288,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 16288,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 16251,   
       y2d = 3051,  
       radius = 5,  
   },  
   {   
       x2d = 16251,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 16266,   
       y2d = 3266,  
       radius = 20,  
   },  
   {   
       x2d = 16281,   
       y2d = 3331,  
       radius = 35,  
   },  
   {   
       x2d = 16251,   
       y2d = 3601,  
       radius = 5,  
   },  
   {   
       x2d = 16251,   
       y2d = 3701,  
       radius = 5,  
   },  
   {   
       x2d = 16251,   
       y2d = 4351,  
       radius = 5,  
   },  
   {   
       x2d = 16273,   
       y2d = 4573,  
       radius = 27,  
   },  
   {   
       x2d = 16281,   
       y2d = 4731,  
       radius = 35,  
   },  
   {   
       x2d = 16251,   
       y2d = 4801,  
       radius = 5,  
   },  
   {   
       x2d = 16251,   
       y2d = 5201,  
       radius = 5,  
   },  
   {   
       x2d = 16266,   
       y2d = 5266,  
       radius = 20,  
   },  
   {   
       x2d = 16251,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 16266,   
       y2d = 5466,  
       radius = 20,  
   },  
   {   
       x2d = 16288,   
       y2d = 5688,  
       radius = 42,  
   },  
   {   
       x2d = 16273,   
       y2d = 5773,  
       radius = 27,  
   },  
   {   
       x2d = 16251,   
       y2d = 5851,  
       radius = 5,  
   },  
   {   
       x2d = 16251,   
       y2d = 5901,  
       radius = 5,  
   },  
   {   
       x2d = 16251,   
       y2d = 6701,  
       radius = 5,  
   },  
   {   
       x2d = 16251,   
       y2d = 7151,  
       radius = 5,  
   },  
   {   
       x2d = 16251,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 16266,   
       y2d = 7266,  
       radius = 20,  
   },  
   {   
       x2d = 16288,   
       y2d = 7338,  
       radius = 42,  
   },  
   {   
       x2d = 16251,   
       y2d = 8101,  
       radius = 5,  
   },  
   {   
       x2d = 16258,   
       y2d = 8208,  
       radius = 12,  
   },  
   {   
       x2d = 16251,   
       y2d = 8451,  
       radius = 5,  
   },  
   {   
       x2d = 16266,   
       y2d = 8866,  
       radius = 20,  
   },  
   {   
       x2d = 16251,   
       y2d = 9001,  
       radius = 5,  
   },  
   {   
       x2d = 16266,   
       y2d = 9066,  
       radius = 20,  
   },  
   {   
       x2d = 16288,   
       y2d = 9188,  
       radius = 42,  
   },  
   {   
       x2d = 16251,   
       y2d = 9401,  
       radius = 5,  
   },  
   {   
       x2d = 16251,   
       y2d = 9451,  
       radius = 5,  
   },  
   {   
       x2d = 16258,   
       y2d = 9508,  
       radius = 12,  
   },  
   {   
       x2d = 16251,   
       y2d = 9601,  
       radius = 5,  
   },  
   {   
       x2d = 16273,   
       y2d = 9773,  
       radius = 27,  
   },  
   {   
       x2d = 16288,   
       y2d = 9938,  
       radius = 42,  
   },  
   {   
       x2d = 16338,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 16338,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 16338,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 16338,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 16338,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 16338,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 16338,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 16338,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 16338,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 16338,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 16338,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 16338,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 16338,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 16338,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 16338,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 16338,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 16338,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 16301,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 16338,   
       y2d = 3288,  
       radius = 42,  
   },  
   {   
       x2d = 16338,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 16323,   
       y2d = 3523,  
       radius = 27,  
   },  
   {   
       x2d = 16338,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 16331,   
       y2d = 3781,  
       radius = 35,  
   },  
   {   
       x2d = 16316,   
       y2d = 3966,  
       radius = 20,  
   },  
   {   
       x2d = 16308,   
       y2d = 4008,  
       radius = 12,  
   },  
   {   
       x2d = 16308,   
       y2d = 4058,  
       radius = 12,  
   },  
   {   
       x2d = 16338,   
       y2d = 4188,  
       radius = 42,  
   },  
   {   
       x2d = 16301,   
       y2d = 4351,  
       radius = 5,  
   },  
   {   
       x2d = 16301,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 16338,   
       y2d = 4588,  
       radius = 42,  
   },  
   {   
       x2d = 16301,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 16308,   
       y2d = 5208,  
       radius = 12,  
   },  
   {   
       x2d = 16316,   
       y2d = 5266,  
       radius = 20,  
   },  
   {   
       x2d = 16338,   
       y2d = 5588,  
       radius = 42,  
   },  
   {   
       x2d = 16316,   
       y2d = 5916,  
       radius = 20,  
   },  
   {   
       x2d = 16338,   
       y2d = 5988,  
       radius = 42,  
   },  
   {   
       x2d = 16308,   
       y2d = 6208,  
       radius = 12,  
   },  
   {   
       x2d = 16301,   
       y2d = 6251,  
       radius = 5,  
   },  
   {   
       x2d = 16301,   
       y2d = 7151,  
       radius = 5,  
   },  
   {   
       x2d = 16301,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 16323,   
       y2d = 7523,  
       radius = 27,  
   },  
   {   
       x2d = 16323,   
       y2d = 7623,  
       radius = 27,  
   },  
   {   
       x2d = 16301,   
       y2d = 8101,  
       radius = 5,  
   },  
   {   
       x2d = 16323,   
       y2d = 8173,  
       radius = 27,  
   },  
   {   
       x2d = 16301,   
       y2d = 8901,  
       radius = 5,  
   },  
   {   
       x2d = 16316,   
       y2d = 8966,  
       radius = 20,  
   },  
   {   
       x2d = 16316,   
       y2d = 9016,  
       radius = 20,  
   },  
   {   
       x2d = 16308,   
       y2d = 9358,  
       radius = 12,  
   },  
   {   
       x2d = 16301,   
       y2d = 9551,  
       radius = 5,  
   },  
   {   
       x2d = 16323,   
       y2d = 9623,  
       radius = 27,  
   },  
   {   
       x2d = 16323,   
       y2d = 9723,  
       radius = 27,  
   },  
   {   
       x2d = 16316,   
       y2d = 9816,  
       radius = 20,  
   },  
   {   
       x2d = 16331,   
       y2d = 10031,  
       radius = 35,  
   },  
   {   
       x2d = 16316,   
       y2d = 10216,  
       radius = 20,  
   },  
   {   
       x2d = 16338,   
       y2d = 10338,  
       radius = 42,  
   },  
   {   
       x2d = 16388,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 16388,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 16388,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 16388,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 16388,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 16388,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 16388,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 16388,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 16388,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 16388,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 16388,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 16381,   
       y2d = 2431,  
       radius = 35,  
   },  
   {   
       x2d = 16381,   
       y2d = 2931,  
       radius = 35,  
   },  
   {   
       x2d = 16351,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 16358,   
       y2d = 3158,  
       radius = 12,  
   },  
   {   
       x2d = 16388,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 16351,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 16351,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 16373,   
       y2d = 4373,  
       radius = 27,  
   },  
   {   
       x2d = 16388,   
       y2d = 4438,  
       radius = 42,  
   },  
   {   
       x2d = 16366,   
       y2d = 4866,  
       radius = 20,  
   },  
   {   
       x2d = 16358,   
       y2d = 5158,  
       radius = 12,  
   },  
   {   
       x2d = 16358,   
       y2d = 5258,  
       radius = 12,  
   },  
   {   
       x2d = 16351,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 16388,   
       y2d = 5488,  
       radius = 42,  
   },  
   {   
       x2d = 16388,   
       y2d = 5688,  
       radius = 42,  
   },  
   {   
       x2d = 16373,   
       y2d = 5773,  
       radius = 27,  
   },  
   {   
       x2d = 16366,   
       y2d = 6116,  
       radius = 20,  
   },  
   {   
       x2d = 16351,   
       y2d = 6601,  
       radius = 5,  
   },  
   {   
       x2d = 16351,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 16351,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 16388,   
       y2d = 7388,  
       radius = 42,  
   },  
   {   
       x2d = 16388,   
       y2d = 7538,  
       radius = 42,  
   },  
   {   
       x2d = 16358,   
       y2d = 7808,  
       radius = 12,  
   },  
   {   
       x2d = 16351,   
       y2d = 7951,  
       radius = 5,  
   },  
   {   
       x2d = 16358,   
       y2d = 8808,  
       radius = 12,  
   },  
   {   
       x2d = 16388,   
       y2d = 8888,  
       radius = 42,  
   },  
   {   
       x2d = 16373,   
       y2d = 9173,  
       radius = 27,  
   },  
   {   
       x2d = 16351,   
       y2d = 9251,  
       radius = 5,  
   },  
   {   
       x2d = 16351,   
       y2d = 9301,  
       radius = 5,  
   },  
   {   
       x2d = 16388,   
       y2d = 9938,  
       radius = 42,  
   },  
   {   
       x2d = 16381,   
       y2d = 10131,  
       radius = 35,  
   },  
   {   
       x2d = 16438,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 16438,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 16438,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 16438,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 16438,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 16438,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 16438,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 16438,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 16438,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 16438,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 16438,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 16438,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 16438,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 16438,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 16438,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 16438,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 16438,   
       y2d = 2888,  
       radius = 42,  
   },  
   {   
       x2d = 16423,   
       y2d = 3023,  
       radius = 27,  
   },  
   {   
       x2d = 16438,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 16438,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 16416,   
       y2d = 3466,  
       radius = 20,  
   },  
   {   
       x2d = 16416,   
       y2d = 3516,  
       radius = 20,  
   },  
   {   
       x2d = 16423,   
       y2d = 3623,  
       radius = 27,  
   },  
   {   
       x2d = 16438,   
       y2d = 3838,  
       radius = 42,  
   },  
   {   
       x2d = 16423,   
       y2d = 3973,  
       radius = 27,  
   },  
   {   
       x2d = 16416,   
       y2d = 4066,  
       radius = 20,  
   },  
   {   
       x2d = 16438,   
       y2d = 4238,  
       radius = 42,  
   },  
   {   
       x2d = 16438,   
       y2d = 4538,  
       radius = 42,  
   },  
   {   
       x2d = 16408,   
       y2d = 4658,  
       radius = 12,  
   },  
   {   
       x2d = 16408,   
       y2d = 4708,  
       radius = 12,  
   },  
   {   
       x2d = 16401,   
       y2d = 4751,  
       radius = 5,  
   },  
   {   
       x2d = 16401,   
       y2d = 5101,  
       radius = 5,  
   },  
   {   
       x2d = 16438,   
       y2d = 5188,  
       radius = 42,  
   },  
   {   
       x2d = 16423,   
       y2d = 5373,  
       radius = 27,  
   },  
   {   
       x2d = 16423,   
       y2d = 5573,  
       radius = 27,  
   },  
   {   
       x2d = 16438,   
       y2d = 5788,  
       radius = 42,  
   },  
   {   
       x2d = 16401,   
       y2d = 5901,  
       radius = 5,  
   },  
   {   
       x2d = 16401,   
       y2d = 6051,  
       radius = 5,  
   },  
   {   
       x2d = 16401,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 16401,   
       y2d = 6451,  
       radius = 5,  
   },  
   {   
       x2d = 16401,   
       y2d = 6601,  
       radius = 5,  
   },  
   {   
       x2d = 16408,   
       y2d = 7208,  
       radius = 12,  
   },  
   {   
       x2d = 16401,   
       y2d = 7801,  
       radius = 5,  
   },  
   {   
       x2d = 16401,   
       y2d = 7851,  
       radius = 5,  
   },  
   {   
       x2d = 16401,   
       y2d = 7951,  
       radius = 5,  
   },  
   {   
       x2d = 16408,   
       y2d = 8258,  
       radius = 12,  
   },  
   {   
       x2d = 16416,   
       y2d = 8366,  
       radius = 20,  
   },  
   {   
       x2d = 16416,   
       y2d = 9016,  
       radius = 20,  
   },  
   {   
       x2d = 16423,   
       y2d = 9223,  
       radius = 27,  
   },  
   {   
       x2d = 16401,   
       y2d = 9501,  
       radius = 5,  
   },  
   {   
       x2d = 16401,   
       y2d = 9751,  
       radius = 5,  
   },  
   {   
       x2d = 16416,   
       y2d = 10266,  
       radius = 20,  
   },  
   {   
       x2d = 16438,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 16488,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 16488,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 16488,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 16488,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 16488,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 16488,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 16488,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 16488,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 16473,   
       y2d = 2023,  
       radius = 27,  
   },  
   {   
       x2d = 16488,   
       y2d = 2288,  
       radius = 42,  
   },  
   {   
       x2d = 16488,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 16481,   
       y2d = 2981,  
       radius = 35,  
   },  
   {   
       x2d = 16458,   
       y2d = 3108,  
       radius = 12,  
   },  
   {   
       x2d = 16451,   
       y2d = 3551,  
       radius = 5,  
   },  
   {   
       x2d = 16473,   
       y2d = 3673,  
       radius = 27,  
   },  
   {   
       x2d = 16481,   
       y2d = 3731,  
       radius = 35,  
   },  
   {   
       x2d = 16458,   
       y2d = 4108,  
       radius = 12,  
   },  
   {   
       x2d = 16458,   
       y2d = 4358,  
       radius = 12,  
   },  
   {   
       x2d = 16473,   
       y2d = 4423,  
       radius = 27,  
   },  
   {   
       x2d = 16451,   
       y2d = 4701,  
       radius = 5,  
   },  
   {   
       x2d = 16451,   
       y2d = 4801,  
       radius = 5,  
   },  
   {   
       x2d = 16473,   
       y2d = 5473,  
       radius = 27,  
   },  
   {   
       x2d = 16481,   
       y2d = 5681,  
       radius = 35,  
   },  
   {   
       x2d = 16458,   
       y2d = 5908,  
       radius = 12,  
   },  
   {   
       x2d = 16451,   
       y2d = 6001,  
       radius = 5,  
   },  
   {   
       x2d = 16458,   
       y2d = 6058,  
       radius = 12,  
   },  
   {   
       x2d = 16451,   
       y2d = 6101,  
       radius = 5,  
   },  
   {   
       x2d = 16451,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 16451,   
       y2d = 6401,  
       radius = 5,  
   },  
   {   
       x2d = 16451,   
       y2d = 6451,  
       radius = 5,  
   },  
   {   
       x2d = 16458,   
       y2d = 6508,  
       radius = 12,  
   },  
   {   
       x2d = 16451,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 16458,   
       y2d = 7258,  
       radius = 12,  
   },  
   {   
       x2d = 16451,   
       y2d = 7301,  
       radius = 5,  
   },  
   {   
       x2d = 16488,   
       y2d = 7538,  
       radius = 42,  
   },  
   {   
       x2d = 16451,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 16458,   
       y2d = 7958,  
       radius = 12,  
   },  
   {   
       x2d = 16451,   
       y2d = 8201,  
       radius = 5,  
   },  
   {   
       x2d = 16451,   
       y2d = 8251,  
       radius = 5,  
   },  
   {   
       x2d = 16451,   
       y2d = 8401,  
       radius = 5,  
   },  
   {   
       x2d = 16451,   
       y2d = 8651,  
       radius = 5,  
   },  
   {   
       x2d = 16466,   
       y2d = 8816,  
       radius = 20,  
   },  
   {   
       x2d = 16451,   
       y2d = 8951,  
       radius = 5,  
   },  
   {   
       x2d = 16451,   
       y2d = 9101,  
       radius = 5,  
   },  
   {   
       x2d = 16488,   
       y2d = 9288,  
       radius = 42,  
   },  
   {   
       x2d = 16488,   
       y2d = 9388,  
       radius = 42,  
   },  
   {   
       x2d = 16451,   
       y2d = 9551,  
       radius = 5,  
   },  
   {   
       x2d = 16458,   
       y2d = 9708,  
       radius = 12,  
   },  
   {   
       x2d = 16473,   
       y2d = 9773,  
       radius = 27,  
   },  
   {   
       x2d = 16481,   
       y2d = 9831,  
       radius = 35,  
   },  
   {   
       x2d = 16481,   
       y2d = 9981,  
       radius = 35,  
   },  
   {   
       x2d = 16458,   
       y2d = 10058,  
       radius = 12,  
   },  
   {   
       x2d = 16451,   
       y2d = 10101,  
       radius = 5,  
   },  
   {   
       x2d = 16538,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 16538,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 16538,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 16538,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 16538,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 16538,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 16538,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 16538,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 16538,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 16538,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 16538,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 16538,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 16538,   
       y2d = 2088,  
       radius = 42,  
   },  
   {   
       x2d = 16538,   
       y2d = 2188,  
       radius = 42,  
   },  
   {   
       x2d = 16531,   
       y2d = 2531,  
       radius = 35,  
   },  
   {   
       x2d = 16538,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 16538,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 16538,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 16508,   
       y2d = 3058,  
       radius = 12,  
   },  
   {   
       x2d = 16501,   
       y2d = 3101,  
       radius = 5,  
   },  
   {   
       x2d = 16516,   
       y2d = 3216,  
       radius = 20,  
   },  
   {   
       x2d = 16538,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 16516,   
       y2d = 3816,  
       radius = 20,  
   },  
   {   
       x2d = 16501,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 16501,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 16516,   
       y2d = 4316,  
       radius = 20,  
   },  
   {   
       x2d = 16523,   
       y2d = 4573,  
       radius = 27,  
   },  
   {   
       x2d = 16501,   
       y2d = 4651,  
       radius = 5,  
   },  
   {   
       x2d = 16501,   
       y2d = 4801,  
       radius = 5,  
   },  
   {   
       x2d = 16501,   
       y2d = 4851,  
       radius = 5,  
   },  
   {   
       x2d = 16501,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 16501,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 16501,   
       y2d = 5601,  
       radius = 5,  
   },  
   {   
       x2d = 16508,   
       y2d = 5908,  
       radius = 12,  
   },  
   {   
       x2d = 16523,   
       y2d = 6023,  
       radius = 27,  
   },  
   {   
       x2d = 16508,   
       y2d = 6108,  
       radius = 12,  
   },  
   {   
       x2d = 16501,   
       y2d = 6251,  
       radius = 5,  
   },  
   {   
       x2d = 16501,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 16501,   
       y2d = 6501,  
       radius = 5,  
   },  
   {   
       x2d = 16501,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 16501,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 16501,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 16516,   
       y2d = 7216,  
       radius = 20,  
   },  
   {   
       x2d = 16516,   
       y2d = 7416,  
       radius = 20,  
   },  
   {   
       x2d = 16501,   
       y2d = 7651,  
       radius = 5,  
   },  
   {   
       x2d = 16501,   
       y2d = 7801,  
       radius = 5,  
   },  
   {   
       x2d = 16501,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 16501,   
       y2d = 8001,  
       radius = 5,  
   },  
   {   
       x2d = 16501,   
       y2d = 8501,  
       radius = 5,  
   },  
   {   
       x2d = 16508,   
       y2d = 8608,  
       radius = 12,  
   },  
   {   
       x2d = 16501,   
       y2d = 8651,  
       radius = 5,  
   },  
   {   
       x2d = 16501,   
       y2d = 8701,  
       radius = 5,  
   },  
   {   
       x2d = 16501,   
       y2d = 9051,  
       radius = 5,  
   },  
   {   
       x2d = 16501,   
       y2d = 9151,  
       radius = 5,  
   },  
   {   
       x2d = 16538,   
       y2d = 9488,  
       radius = 42,  
   },  
   {   
       x2d = 16501,   
       y2d = 9601,  
       radius = 5,  
   },  
   {   
       x2d = 16501,   
       y2d = 9651,  
       radius = 5,  
   },  
   {   
       x2d = 16538,   
       y2d = 9938,  
       radius = 42,  
   },  
   {   
       x2d = 16508,   
       y2d = 10058,  
       radius = 12,  
   },  
   {   
       x2d = 16501,   
       y2d = 10201,  
       radius = 5,  
   },  
   {   
       x2d = 16531,   
       y2d = 10381,  
       radius = 35,  
   },  
   {   
       x2d = 16588,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 16588,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 16588,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 16588,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 16588,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 16588,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 16588,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 16588,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 16588,   
       y2d = 2288,  
       radius = 42,  
   },  
   {   
       x2d = 16588,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 16588,   
       y2d = 2488,  
       radius = 42,  
   },  
   {   
       x2d = 16588,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 16566,   
       y2d = 3066,  
       radius = 20,  
   },  
   {   
       x2d = 16573,   
       y2d = 3673,  
       radius = 27,  
   },  
   {   
       x2d = 16588,   
       y2d = 3788,  
       radius = 42,  
   },  
   {   
       x2d = 16551,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 16551,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 16581,   
       y2d = 4181,  
       radius = 35,  
   },  
   {   
       x2d = 16566,   
       y2d = 4266,  
       radius = 20,  
   },  
   {   
       x2d = 16558,   
       y2d = 4308,  
       radius = 12,  
   },  
   {   
       x2d = 16551,   
       y2d = 4351,  
       radius = 5,  
   },  
   {   
       x2d = 16566,   
       y2d = 4616,  
       radius = 20,  
   },  
   {   
       x2d = 16558,   
       y2d = 4658,  
       radius = 12,  
   },  
   {   
       x2d = 16551,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 16551,   
       y2d = 5201,  
       radius = 5,  
   },  
   {   
       x2d = 16551,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 16551,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 16551,   
       y2d = 5501,  
       radius = 5,  
   },  
   {   
       x2d = 16551,   
       y2d = 5551,  
       radius = 5,  
   },  
   {   
       x2d = 16573,   
       y2d = 5723,  
       radius = 27,  
   },  
   {   
       x2d = 16558,   
       y2d = 5958,  
       radius = 12,  
   },  
   {   
       x2d = 16551,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 16558,   
       y2d = 6358,  
       radius = 12,  
   },  
   {   
       x2d = 16551,   
       y2d = 6501,  
       radius = 5,  
   },  
   {   
       x2d = 16573,   
       y2d = 6573,  
       radius = 27,  
   },  
   {   
       x2d = 16551,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 16551,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 16566,   
       y2d = 7166,  
       radius = 20,  
   },  
   {   
       x2d = 16573,   
       y2d = 7323,  
       radius = 27,  
   },  
   {   
       x2d = 16558,   
       y2d = 7408,  
       radius = 12,  
   },  
   {   
       x2d = 16566,   
       y2d = 7466,  
       radius = 20,  
   },  
   {   
       x2d = 16573,   
       y2d = 7523,  
       radius = 27,  
   },  
   {   
       x2d = 16551,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 16551,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 16551,   
       y2d = 7951,  
       radius = 5,  
   },  
   {   
       x2d = 16551,   
       y2d = 8001,  
       radius = 5,  
   },  
   {   
       x2d = 16573,   
       y2d = 8573,  
       radius = 27,  
   },  
   {   
       x2d = 16551,   
       y2d = 8751,  
       radius = 5,  
   },  
   {   
       x2d = 16558,   
       y2d = 9108,  
       radius = 12,  
   },  
   {   
       x2d = 16588,   
       y2d = 9238,  
       radius = 42,  
   },  
   {   
       x2d = 16588,   
       y2d = 9338,  
       radius = 42,  
   },  
   {   
       x2d = 16588,   
       y2d = 9588,  
       radius = 42,  
   },  
   {   
       x2d = 16551,   
       y2d = 9701,  
       radius = 5,  
   },  
   {   
       x2d = 16551,   
       y2d = 9751,  
       radius = 5,  
   },  
   {   
       x2d = 16558,   
       y2d = 10258,  
       radius = 12,  
   },  
   {   
       x2d = 16551,   
       y2d = 10301,  
       radius = 5,  
   },  
   {   
       x2d = 16638,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 16638,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 16638,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 16638,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 16638,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 16638,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 16638,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 16638,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 16638,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 16638,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 16638,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 16638,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 16638,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 16638,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 16638,   
       y2d = 2588,  
       radius = 42,  
   },  
   {   
       x2d = 16638,   
       y2d = 2688,  
       radius = 42,  
   },  
   {   
       x2d = 16638,   
       y2d = 2788,  
       radius = 42,  
   },  
   {   
       x2d = 16638,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 16601,   
       y2d = 3251,  
       radius = 5,  
   },  
   {   
       x2d = 16638,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 16616,   
       y2d = 3616,  
       radius = 20,  
   },  
   {   
       x2d = 16638,   
       y2d = 3688,  
       radius = 42,  
   },  
   {   
       x2d = 16601,   
       y2d = 3901,  
       radius = 5,  
   },  
   {   
       x2d = 16608,   
       y2d = 4258,  
       radius = 12,  
   },  
   {   
       x2d = 16623,   
       y2d = 4473,  
       radius = 27,  
   },  
   {   
       x2d = 16616,   
       y2d = 4566,  
       radius = 20,  
   },  
   {   
       x2d = 16616,   
       y2d = 4666,  
       radius = 20,  
   },  
   {   
       x2d = 16601,   
       y2d = 4751,  
       radius = 5,  
   },  
   {   
       x2d = 16623,   
       y2d = 5173,  
       radius = 27,  
   },  
   {   
       x2d = 16601,   
       y2d = 5351,  
       radius = 5,  
   },  
   {   
       x2d = 16601,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 16616,   
       y2d = 5466,  
       radius = 20,  
   },  
   {   
       x2d = 16601,   
       y2d = 5551,  
       radius = 5,  
   },  
   {   
       x2d = 16601,   
       y2d = 5601,  
       radius = 5,  
   },  
   {   
       x2d = 16616,   
       y2d = 5866,  
       radius = 20,  
   },  
   {   
       x2d = 16608,   
       y2d = 5908,  
       radius = 12,  
   },  
   {   
       x2d = 16601,   
       y2d = 6101,  
       radius = 5,  
   },  
   {   
       x2d = 16601,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 16608,   
       y2d = 6358,  
       radius = 12,  
   },  
   {   
       x2d = 16601,   
       y2d = 6501,  
       radius = 5,  
   },  
   {   
       x2d = 16601,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 16601,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 16601,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 16601,   
       y2d = 7101,  
       radius = 5,  
   },  
   {   
       x2d = 16601,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 16623,   
       y2d = 7423,  
       radius = 27,  
   },  
   {   
       x2d = 16631,   
       y2d = 7481,  
       radius = 35,  
   },  
   {   
       x2d = 16623,   
       y2d = 7573,  
       radius = 27,  
   },  
   {   
       x2d = 16601,   
       y2d = 7651,  
       radius = 5,  
   },  
   {   
       x2d = 16608,   
       y2d = 8008,  
       radius = 12,  
   },  
   {   
       x2d = 16608,   
       y2d = 8058,  
       radius = 12,  
   },  
   {   
       x2d = 16601,   
       y2d = 8101,  
       radius = 5,  
   },  
   {   
       x2d = 16601,   
       y2d = 8351,  
       radius = 5,  
   },  
   {   
       x2d = 16631,   
       y2d = 8431,  
       radius = 35,  
   },  
   {   
       x2d = 16616,   
       y2d = 8616,  
       radius = 20,  
   },  
   {   
       x2d = 16616,   
       y2d = 8666,  
       radius = 20,  
   },  
   {   
       x2d = 16601,   
       y2d = 8851,  
       radius = 5,  
   },  
   {   
       x2d = 16638,   
       y2d = 9438,  
       radius = 42,  
   },  
   {   
       x2d = 16623,   
       y2d = 9923,  
       radius = 27,  
   },  
   {   
       x2d = 16601,   
       y2d = 10201,  
       radius = 5,  
   },  
   {   
       x2d = 16601,   
       y2d = 10301,  
       radius = 5,  
   },  
   {   
       x2d = 16688,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 16688,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 16688,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 16688,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 16688,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 16688,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 16688,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 16688,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 16688,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 16688,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 16688,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 16688,   
       y2d = 2888,  
       radius = 42,  
   },  
   {   
       x2d = 16688,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 16651,   
       y2d = 3251,  
       radius = 5,  
   },  
   {   
       x2d = 16688,   
       y2d = 3788,  
       radius = 42,  
   },  
   {   
       x2d = 16658,   
       y2d = 4008,  
       radius = 12,  
   },  
   {   
       x2d = 16651,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 16658,   
       y2d = 4208,  
       radius = 12,  
   },  
   {   
       x2d = 16673,   
       y2d = 4423,  
       radius = 27,  
   },  
   {   
       x2d = 16688,   
       y2d = 4488,  
       radius = 42,  
   },  
   {   
       x2d = 16681,   
       y2d = 4581,  
       radius = 35,  
   },  
   {   
       x2d = 16651,   
       y2d = 4751,  
       radius = 5,  
   },  
   {   
       x2d = 16651,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 16666,   
       y2d = 5466,  
       radius = 20,  
   },  
   {   
       x2d = 16651,   
       y2d = 5551,  
       radius = 5,  
   },  
   {   
       x2d = 16651,   
       y2d = 5601,  
       radius = 5,  
   },  
   {   
       x2d = 16651,   
       y2d = 5651,  
       radius = 5,  
   },  
   {   
       x2d = 16651,   
       y2d = 5751,  
       radius = 5,  
   },  
   {   
       x2d = 16651,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 16658,   
       y2d = 5958,  
       radius = 12,  
   },  
   {   
       x2d = 16666,   
       y2d = 6066,  
       radius = 20,  
   },  
   {   
       x2d = 16658,   
       y2d = 6108,  
       radius = 12,  
   },  
   {   
       x2d = 16651,   
       y2d = 6251,  
       radius = 5,  
   },  
   {   
       x2d = 16651,   
       y2d = 6451,  
       radius = 5,  
   },  
   {   
       x2d = 16651,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 16651,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 16651,   
       y2d = 7051,  
       radius = 5,  
   },  
   {   
       x2d = 16658,   
       y2d = 7208,  
       radius = 12,  
   },  
   {   
       x2d = 16673,   
       y2d = 7323,  
       radius = 27,  
   },  
   {   
       x2d = 16666,   
       y2d = 7616,  
       radius = 20,  
   },  
   {   
       x2d = 16658,   
       y2d = 7808,  
       radius = 12,  
   },  
   {   
       x2d = 16666,   
       y2d = 7866,  
       radius = 20,  
   },  
   {   
       x2d = 16658,   
       y2d = 7908,  
       radius = 12,  
   },  
   {   
       x2d = 16658,   
       y2d = 7958,  
       radius = 12,  
   },  
   {   
       x2d = 16651,   
       y2d = 8001,  
       radius = 5,  
   },  
   {   
       x2d = 16658,   
       y2d = 8058,  
       radius = 12,  
   },  
   {   
       x2d = 16666,   
       y2d = 8116,  
       radius = 20,  
   },  
   {   
       x2d = 16658,   
       y2d = 8208,  
       radius = 12,  
   },  
   {   
       x2d = 16651,   
       y2d = 8251,  
       radius = 5,  
   },  
   {   
       x2d = 16651,   
       y2d = 8301,  
       radius = 5,  
   },  
   {   
       x2d = 16688,   
       y2d = 8538,  
       radius = 42,  
   },  
   {   
       x2d = 16651,   
       y2d = 8701,  
       radius = 5,  
   },  
   {   
       x2d = 16651,   
       y2d = 8751,  
       radius = 5,  
   },  
   {   
       x2d = 16651,   
       y2d = 8801,  
       radius = 5,  
   },  
   {   
       x2d = 16651,   
       y2d = 8951,  
       radius = 5,  
   },  
   {   
       x2d = 16651,   
       y2d = 9001,  
       radius = 5,  
   },  
   {   
       x2d = 16658,   
       y2d = 9158,  
       radius = 12,  
   },  
   {   
       x2d = 16688,   
       y2d = 9338,  
       radius = 42,  
   },  
   {   
       x2d = 16688,   
       y2d = 9538,  
       radius = 42,  
   },  
   {   
       x2d = 16673,   
       y2d = 9673,  
       radius = 27,  
   },  
   {   
       x2d = 16681,   
       y2d = 9931,  
       radius = 35,  
   },  
   {   
       x2d = 16658,   
       y2d = 10008,  
       radius = 12,  
   },  
   {   
       x2d = 16651,   
       y2d = 10151,  
       radius = 5,  
   },  
   {   
       x2d = 16681,   
       y2d = 10331,  
       radius = 35,  
   },  
   {   
       x2d = 16738,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 16738,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 16738,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 16738,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 16738,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 16738,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 16738,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 16738,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 16738,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 16738,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 16738,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 16738,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 16738,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 16738,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 16738,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 16738,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 16738,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 16723,   
       y2d = 2973,  
       radius = 27,  
   },  
   {   
       x2d = 16738,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 16738,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 16723,   
       y2d = 3673,  
       radius = 27,  
   },  
   {   
       x2d = 16723,   
       y2d = 4023,  
       radius = 27,  
   },  
   {   
       x2d = 16708,   
       y2d = 4108,  
       radius = 12,  
   },  
   {   
       x2d = 16701,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 16701,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 16723,   
       y2d = 4673,  
       radius = 27,  
   },  
   {   
       x2d = 16701,   
       y2d = 4801,  
       radius = 5,  
   },  
   {   
       x2d = 16701,   
       y2d = 4951,  
       radius = 5,  
   },  
   {   
       x2d = 16701,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 16716,   
       y2d = 5216,  
       radius = 20,  
   },  
   {   
       x2d = 16716,   
       y2d = 5266,  
       radius = 20,  
   },  
   {   
       x2d = 16708,   
       y2d = 5408,  
       radius = 12,  
   },  
   {   
       x2d = 16723,   
       y2d = 5473,  
       radius = 27,  
   },  
   {   
       x2d = 16701,   
       y2d = 5551,  
       radius = 5,  
   },  
   {   
       x2d = 16731,   
       y2d = 5631,  
       radius = 35,  
   },  
   {   
       x2d = 16701,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 16701,   
       y2d = 5851,  
       radius = 5,  
   },  
   {   
       x2d = 16701,   
       y2d = 5901,  
       radius = 5,  
   },  
   {   
       x2d = 16708,   
       y2d = 6008,  
       radius = 12,  
   },  
   {   
       x2d = 16723,   
       y2d = 6573,  
       radius = 27,  
   },  
   {   
       x2d = 16701,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 16716,   
       y2d = 7116,  
       radius = 20,  
   },  
   {   
       x2d = 16708,   
       y2d = 7208,  
       radius = 12,  
   },  
   {   
       x2d = 16708,   
       y2d = 7458,  
       radius = 12,  
   },  
   {   
       x2d = 16708,   
       y2d = 7508,  
       radius = 12,  
   },  
   {   
       x2d = 16701,   
       y2d = 7551,  
       radius = 5,  
   },  
   {   
       x2d = 16701,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 16716,   
       y2d = 7966,  
       radius = 20,  
   },  
   {   
       x2d = 16708,   
       y2d = 8008,  
       radius = 12,  
   },  
   {   
       x2d = 16738,   
       y2d = 8088,  
       radius = 42,  
   },  
   {   
       x2d = 16701,   
       y2d = 8251,  
       radius = 5,  
   },  
   {   
       x2d = 16701,   
       y2d = 8351,  
       radius = 5,  
   },  
   {   
       x2d = 16708,   
       y2d = 8408,  
       radius = 12,  
   },  
   {   
       x2d = 16716,   
       y2d = 8766,  
       radius = 20,  
   },  
   {   
       x2d = 16708,   
       y2d = 8858,  
       radius = 12,  
   },  
   {   
       x2d = 16701,   
       y2d = 8901,  
       radius = 5,  
   },  
   {   
       x2d = 16701,   
       y2d = 9101,  
       radius = 5,  
   },  
   {   
       x2d = 16731,   
       y2d = 9231,  
       radius = 35,  
   },  
   {   
       x2d = 16738,   
       y2d = 9638,  
       radius = 42,  
   },  
   {   
       x2d = 16701,   
       y2d = 10101,  
       radius = 5,  
   },  
   {   
       x2d = 16788,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 16788,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 16788,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 16788,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 16788,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 16788,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 16788,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 16788,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 16788,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 16788,   
       y2d = 2388,  
       radius = 42,  
   },  
   {   
       x2d = 16788,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 16788,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 16773,   
       y2d = 3123,  
       radius = 27,  
   },  
   {   
       x2d = 16788,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 16773,   
       y2d = 3823,  
       radius = 27,  
   },  
   {   
       x2d = 16751,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 16773,   
       y2d = 4073,  
       radius = 27,  
   },  
   {   
       x2d = 16751,   
       y2d = 4401,  
       radius = 5,  
   },  
   {   
       x2d = 16758,   
       y2d = 4558,  
       radius = 12,  
   },  
   {   
       x2d = 16751,   
       y2d = 4601,  
       radius = 5,  
   },  
   {   
       x2d = 16751,   
       y2d = 5101,  
       radius = 5,  
   },  
   {   
       x2d = 16788,   
       y2d = 5488,  
       radius = 42,  
   },  
   {   
       x2d = 16758,   
       y2d = 5708,  
       radius = 12,  
   },  
   {   
       x2d = 16751,   
       y2d = 5801,  
       radius = 5,  
   },  
   {   
       x2d = 16758,   
       y2d = 6008,  
       radius = 12,  
   },  
   {   
       x2d = 16751,   
       y2d = 6051,  
       radius = 5,  
   },  
   {   
       x2d = 16751,   
       y2d = 6101,  
       radius = 5,  
   },  
   {   
       x2d = 16751,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 16751,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 16751,   
       y2d = 6451,  
       radius = 5,  
   },  
   {   
       x2d = 16751,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 16758,   
       y2d = 7108,  
       radius = 12,  
   },  
   {   
       x2d = 16758,   
       y2d = 7158,  
       radius = 12,  
   },  
   {   
       x2d = 16751,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 16781,   
       y2d = 7381,  
       radius = 35,  
   },  
   {   
       x2d = 16788,   
       y2d = 7488,  
       radius = 42,  
   },  
   {   
       x2d = 16758,   
       y2d = 7608,  
       radius = 12,  
   },  
   {   
       x2d = 16751,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 16788,   
       y2d = 8188,  
       radius = 42,  
   },  
   {   
       x2d = 16788,   
       y2d = 8388,  
       radius = 42,  
   },  
   {   
       x2d = 16773,   
       y2d = 8473,  
       radius = 27,  
   },  
   {   
       x2d = 16788,   
       y2d = 8538,  
       radius = 42,  
   },  
   {   
       x2d = 16751,   
       y2d = 8701,  
       radius = 5,  
   },  
   {   
       x2d = 16758,   
       y2d = 8758,  
       radius = 12,  
   },  
   {   
       x2d = 16751,   
       y2d = 8851,  
       radius = 5,  
   },  
   {   
       x2d = 16751,   
       y2d = 9001,  
       radius = 5,  
   },  
   {   
       x2d = 16781,   
       y2d = 9331,  
       radius = 35,  
   },  
   {   
       x2d = 16788,   
       y2d = 9488,  
       radius = 42,  
   },  
   {   
       x2d = 16751,   
       y2d = 9751,  
       radius = 5,  
   },  
   {   
       x2d = 16766,   
       y2d = 9966,  
       radius = 20,  
   },  
   {   
       x2d = 16838,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 16838,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 16838,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 16838,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 16838,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 16838,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 16838,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 16838,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 16838,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 16838,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 16838,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 16838,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 16838,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 16838,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 16838,   
       y2d = 2488,  
       radius = 42,  
   },  
   {   
       x2d = 16838,   
       y2d = 2588,  
       radius = 42,  
   },  
   {   
       x2d = 16838,   
       y2d = 2688,  
       radius = 42,  
   },  
   {   
       x2d = 16823,   
       y2d = 3023,  
       radius = 27,  
   },  
   {   
       x2d = 16831,   
       y2d = 3081,  
       radius = 35,  
   },  
   {   
       x2d = 16816,   
       y2d = 3216,  
       radius = 20,  
   },  
   {   
       x2d = 16838,   
       y2d = 3288,  
       radius = 42,  
   },  
   {   
       x2d = 16801,   
       y2d = 3401,  
       radius = 5,  
   },  
   {   
       x2d = 16816,   
       y2d = 4016,  
       radius = 20,  
   },  
   {   
       x2d = 16801,   
       y2d = 4201,  
       radius = 5,  
   },  
   {   
       x2d = 16816,   
       y2d = 5166,  
       radius = 20,  
   },  
   {   
       x2d = 16808,   
       y2d = 5208,  
       radius = 12,  
   },  
   {   
       x2d = 16808,   
       y2d = 5258,  
       radius = 12,  
   },  
   {   
       x2d = 16801,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 16801,   
       y2d = 5601,  
       radius = 5,  
   },  
   {   
       x2d = 16808,   
       y2d = 5658,  
       radius = 12,  
   },  
   {   
       x2d = 16816,   
       y2d = 5716,  
       radius = 20,  
   },  
   {   
       x2d = 16808,   
       y2d = 5758,  
       radius = 12,  
   },  
   {   
       x2d = 16801,   
       y2d = 6051,  
       radius = 5,  
   },  
   {   
       x2d = 16801,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 16801,   
       y2d = 6601,  
       radius = 5,  
   },  
   {   
       x2d = 16808,   
       y2d = 7058,  
       radius = 12,  
   },  
   {   
       x2d = 16808,   
       y2d = 7108,  
       radius = 12,  
   },  
   {   
       x2d = 16808,   
       y2d = 7258,  
       radius = 12,  
   },  
   {   
       x2d = 16801,   
       y2d = 7301,  
       radius = 5,  
   },  
   {   
       x2d = 16808,   
       y2d = 7908,  
       radius = 12,  
   },  
   {   
       x2d = 16801,   
       y2d = 7951,  
       radius = 5,  
   },  
   {   
       x2d = 16808,   
       y2d = 8008,  
       radius = 12,  
   },  
   {   
       x2d = 16838,   
       y2d = 8638,  
       radius = 42,  
   },  
   {   
       x2d = 16801,   
       y2d = 8751,  
       radius = 5,  
   },  
   {   
       x2d = 16808,   
       y2d = 8908,  
       radius = 12,  
   },  
   {   
       x2d = 16801,   
       y2d = 9001,  
       radius = 5,  
   },  
   {   
       x2d = 16831,   
       y2d = 9281,  
       radius = 35,  
   },  
   {   
       x2d = 16823,   
       y2d = 9573,  
       radius = 27,  
   },  
   {   
       x2d = 16823,   
       y2d = 9673,  
       radius = 27,  
   },  
   {   
       x2d = 16808,   
       y2d = 9858,  
       radius = 12,  
   },  
   {   
       x2d = 16801,   
       y2d = 9901,  
       radius = 5,  
   },  
   {   
       x2d = 16801,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 16801,   
       y2d = 10201,  
       radius = 5,  
   },  
   {   
       x2d = 16888,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 16888,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 16888,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 16888,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 16888,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 16888,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 16888,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 16888,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 16888,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 16888,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 16888,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 16888,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 16858,   
       y2d = 3158,  
       radius = 12,  
   },  
   {   
       x2d = 16851,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 16888,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 16858,   
       y2d = 3858,  
       radius = 12,  
   },  
   {   
       x2d = 16851,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 16851,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 16858,   
       y2d = 5208,  
       radius = 12,  
   },  
   {   
       x2d = 16858,   
       y2d = 5258,  
       radius = 12,  
   },  
   {   
       x2d = 16858,   
       y2d = 5608,  
       radius = 12,  
   },  
   {   
       x2d = 16851,   
       y2d = 5651,  
       radius = 5,  
   },  
   {   
       x2d = 16866,   
       y2d = 5716,  
       radius = 20,  
   },  
   {   
       x2d = 16866,   
       y2d = 5966,  
       radius = 20,  
   },  
   {   
       x2d = 16851,   
       y2d = 6451,  
       radius = 5,  
   },  
   {   
       x2d = 16851,   
       y2d = 6801,  
       radius = 5,  
   },  
   {   
       x2d = 16851,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 16858,   
       y2d = 6958,  
       radius = 12,  
   },  
   {   
       x2d = 16866,   
       y2d = 7066,  
       radius = 20,  
   },  
   {   
       x2d = 16881,   
       y2d = 7281,  
       radius = 35,  
   },  
   {   
       x2d = 16851,   
       y2d = 7351,  
       radius = 5,  
   },  
   {   
       x2d = 16873,   
       y2d = 7423,  
       radius = 27,  
   },  
   {   
       x2d = 16851,   
       y2d = 7551,  
       radius = 5,  
   },  
   {   
       x2d = 16851,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 16851,   
       y2d = 7851,  
       radius = 5,  
   },  
   {   
       x2d = 16851,   
       y2d = 8051,  
       radius = 5,  
   },  
   {   
       x2d = 16851,   
       y2d = 8101,  
       radius = 5,  
   },  
   {   
       x2d = 16888,   
       y2d = 8188,  
       radius = 42,  
   },  
   {   
       x2d = 16873,   
       y2d = 8323,  
       radius = 27,  
   },  
   {   
       x2d = 16888,   
       y2d = 8388,  
       radius = 42,  
   },  
   {   
       x2d = 16888,   
       y2d = 8488,  
       radius = 42,  
   },  
   {   
       x2d = 16851,   
       y2d = 8851,  
       radius = 5,  
   },  
   {   
       x2d = 16888,   
       y2d = 9388,  
       radius = 42,  
   },  
   {   
       x2d = 16888,   
       y2d = 9488,  
       radius = 42,  
   },  
   {   
       x2d = 16851,   
       y2d = 9751,  
       radius = 5,  
   },  
   {   
       x2d = 16851,   
       y2d = 9901,  
       radius = 5,  
   },  
   {   
       x2d = 16851,   
       y2d = 9951,  
       radius = 5,  
   },  
   {   
       x2d = 16858,   
       y2d = 10008,  
       radius = 12,  
   },  
   {   
       x2d = 16888,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 16938,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 16923,   
       y2d = 3323,  
       radius = 27,  
   },  
   {   
       x2d = 16908,   
       y2d = 3858,  
       radius = 12,  
   },  
   {   
       x2d = 16901,   
       y2d = 3951,  
       radius = 5,  
   },  
   {   
       x2d = 16901,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 16901,   
       y2d = 4051,  
       radius = 5,  
   },  
   {   
       x2d = 16901,   
       y2d = 4101,  
       radius = 5,  
   },  
   {   
       x2d = 16901,   
       y2d = 4201,  
       radius = 5,  
   },  
   {   
       x2d = 16931,   
       y2d = 5181,  
       radius = 35,  
   },  
   {   
       x2d = 16901,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 16901,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 16901,   
       y2d = 5751,  
       radius = 5,  
   },  
   {   
       x2d = 16901,   
       y2d = 5851,  
       radius = 5,  
   },  
   {   
       x2d = 16908,   
       y2d = 5908,  
       radius = 12,  
   },  
   {   
       x2d = 16901,   
       y2d = 6101,  
       radius = 5,  
   },  
   {   
       x2d = 16901,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 16901,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 16908,   
       y2d = 6958,  
       radius = 12,  
   },  
   {   
       x2d = 16923,   
       y2d = 7123,  
       radius = 27,  
   },  
   {   
       x2d = 16908,   
       y2d = 7358,  
       radius = 12,  
   },  
   {   
       x2d = 16901,   
       y2d = 7501,  
       radius = 5,  
   },  
   {   
       x2d = 16916,   
       y2d = 7866,  
       radius = 20,  
   },  
   {   
       x2d = 16938,   
       y2d = 8638,  
       radius = 42,  
   },  
   {   
       x2d = 16901,   
       y2d = 8751,  
       radius = 5,  
   },  
   {   
       x2d = 16908,   
       y2d = 8858,  
       radius = 12,  
   },  
   {   
       x2d = 16901,   
       y2d = 8951,  
       radius = 5,  
   },  
   {   
       x2d = 16908,   
       y2d = 9108,  
       radius = 12,  
   },  
   {   
       x2d = 16901,   
       y2d = 9601,  
       radius = 5,  
   },  
   {   
       x2d = 16901,   
       y2d = 9851,  
       radius = 5,  
   },  
   {   
       x2d = 16901,   
       y2d = 9901,  
       radius = 5,  
   },  
   {   
       x2d = 16988,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 16988,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 16988,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 16988,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 16988,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 16988,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 16988,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 16988,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 16988,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 16988,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 16988,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 16973,   
       y2d = 2923,  
       radius = 27,  
   },  
   {   
       x2d = 16981,   
       y2d = 3031,  
       radius = 35,  
   },  
   {   
       x2d = 16951,   
       y2d = 3651,  
       radius = 5,  
   },  
   {   
       x2d = 16973,   
       y2d = 3723,  
       radius = 27,  
   },  
   {   
       x2d = 16966,   
       y2d = 3916,  
       radius = 20,  
   },  
   {   
       x2d = 16958,   
       y2d = 3958,  
       radius = 12,  
   },  
   {   
       x2d = 16951,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 16951,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 16958,   
       y2d = 5108,  
       radius = 12,  
   },  
   {   
       x2d = 16958,   
       y2d = 5358,  
       radius = 12,  
   },  
   {   
       x2d = 16951,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 16966,   
       y2d = 5616,  
       radius = 20,  
   },  
   {   
       x2d = 16958,   
       y2d = 5758,  
       radius = 12,  
   },  
   {   
       x2d = 16958,   
       y2d = 5858,  
       radius = 12,  
   },  
   {   
       x2d = 16958,   
       y2d = 5908,  
       radius = 12,  
   },  
   {   
       x2d = 16951,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 16951,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 16966,   
       y2d = 7366,  
       radius = 20,  
   },  
   {   
       x2d = 16966,   
       y2d = 7416,  
       radius = 20,  
   },  
   {   
       x2d = 16958,   
       y2d = 7458,  
       radius = 12,  
   },  
   {   
       x2d = 16958,   
       y2d = 7708,  
       radius = 12,  
   },  
   {   
       x2d = 16958,   
       y2d = 7808,  
       radius = 12,  
   },  
   {   
       x2d = 16966,   
       y2d = 7866,  
       radius = 20,  
   },  
   {   
       x2d = 16951,   
       y2d = 7951,  
       radius = 5,  
   },  
   {   
       x2d = 16951,   
       y2d = 8001,  
       radius = 5,  
   },  
   {   
       x2d = 16988,   
       y2d = 8238,  
       radius = 42,  
   },  
   {   
       x2d = 16966,   
       y2d = 8366,  
       radius = 20,  
   },  
   {   
       x2d = 16988,   
       y2d = 8488,  
       radius = 42,  
   },  
   {   
       x2d = 16981,   
       y2d = 8731,  
       radius = 35,  
   },  
   {   
       x2d = 16966,   
       y2d = 8816,  
       radius = 20,  
   },  
   {   
       x2d = 16973,   
       y2d = 9023,  
       radius = 27,  
   },  
   {   
       x2d = 16988,   
       y2d = 9288,  
       radius = 42,  
   },  
   {   
       x2d = 16988,   
       y2d = 9588,  
       radius = 42,  
   },  
   {   
       x2d = 16951,   
       y2d = 9701,  
       radius = 5,  
   },  
   {   
       x2d = 16951,   
       y2d = 9751,  
       radius = 5,  
   },  
   {   
       x2d = 16951,   
       y2d = 9801,  
       radius = 5,  
   },  
   {   
       x2d = 16966,   
       y2d = 10016,  
       radius = 20,  
   },  
   {   
       x2d = 16958,   
       y2d = 10308,  
       radius = 12,  
   },  
   {   
       x2d = 17038,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 17038,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 17038,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 17038,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 17038,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 17038,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 17038,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 17038,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 17038,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 17038,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 17038,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 17038,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 17038,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 17038,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 17038,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 17038,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 17038,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 17038,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 17016,   
       y2d = 3166,  
       radius = 20,  
   },  
   {   
       x2d = 17038,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 17023,   
       y2d = 3323,  
       radius = 27,  
   },  
   {   
       x2d = 17016,   
       y2d = 3666,  
       radius = 20,  
   },  
   {   
       x2d = 17038,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 17023,   
       y2d = 3823,  
       radius = 27,  
   },  
   {   
       x2d = 17016,   
       y2d = 3966,  
       radius = 20,  
   },  
   {   
       x2d = 17016,   
       y2d = 4116,  
       radius = 20,  
   },  
   {   
       x2d = 17008,   
       y2d = 4158,  
       radius = 12,  
   },  
   {   
       x2d = 17016,   
       y2d = 4366,  
       radius = 20,  
   },  
   {   
       x2d = 17001,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 17001,   
       y2d = 5101,  
       radius = 5,  
   },  
   {   
       x2d = 17016,   
       y2d = 5216,  
       radius = 20,  
   },  
   {   
       x2d = 17023,   
       y2d = 5423,  
       radius = 27,  
   },  
   {   
       x2d = 17016,   
       y2d = 5516,  
       radius = 20,  
   },  
   {   
       x2d = 17008,   
       y2d = 5558,  
       radius = 12,  
   },  
   {   
       x2d = 17023,   
       y2d = 5773,  
       radius = 27,  
   },  
   {   
       x2d = 17001,   
       y2d = 6151,  
       radius = 5,  
   },  
   {   
       x2d = 17001,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 17001,   
       y2d = 6951,  
       radius = 5,  
   },  
   {   
       x2d = 17008,   
       y2d = 7008,  
       radius = 12,  
   },  
   {   
       x2d = 17001,   
       y2d = 7051,  
       radius = 5,  
   },  
   {   
       x2d = 17008,   
       y2d = 7258,  
       radius = 12,  
   },  
   {   
       x2d = 17016,   
       y2d = 7366,  
       radius = 20,  
   },  
   {   
       x2d = 17001,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 17023,   
       y2d = 7673,  
       radius = 27,  
   },  
   {   
       x2d = 17031,   
       y2d = 7781,  
       radius = 35,  
   },  
   {   
       x2d = 17001,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 17038,   
       y2d = 8338,  
       radius = 42,  
   },  
   {   
       x2d = 17038,   
       y2d = 8588,  
       radius = 42,  
   },  
   {   
       x2d = 17016,   
       y2d = 9416,  
       radius = 20,  
   },  
   {   
       x2d = 17001,   
       y2d = 9751,  
       radius = 5,  
   },  
   {   
       x2d = 17001,   
       y2d = 9951,  
       radius = 5,  
   },  
   {   
       x2d = 17001,   
       y2d = 10251,  
       radius = 5,  
   },  
   {   
       x2d = 17001,   
       y2d = 10301,  
       radius = 5,  
   },  
   {   
       x2d = 17088,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 17088,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 17088,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 17088,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 17088,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 17088,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 17088,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 17088,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 17088,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 17088,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 17088,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 17088,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 17081,   
       y2d = 3081,  
       radius = 35,  
   },  
   {   
       x2d = 17058,   
       y2d = 3458,  
       radius = 12,  
   },  
   {   
       x2d = 17088,   
       y2d = 3838,  
       radius = 42,  
   },  
   {   
       x2d = 17051,   
       y2d = 4001,  
       radius = 5,  
   },  
   {   
       x2d = 17051,   
       y2d = 4201,  
       radius = 5,  
   },  
   {   
       x2d = 17058,   
       y2d = 4258,  
       radius = 12,  
   },  
   {   
       x2d = 17051,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 17051,   
       y2d = 4451,  
       radius = 5,  
   },  
   {   
       x2d = 17051,   
       y2d = 5701,  
       radius = 5,  
   },  
   {   
       x2d = 17088,   
       y2d = 5788,  
       radius = 42,  
   },  
   {   
       x2d = 17058,   
       y2d = 6758,  
       radius = 12,  
   },  
   {   
       x2d = 17088,   
       y2d = 6838,  
       radius = 42,  
   },  
   {   
       x2d = 17088,   
       y2d = 6938,  
       radius = 42,  
   },  
   {   
       x2d = 17073,   
       y2d = 7073,  
       radius = 27,  
   },  
   {   
       x2d = 17058,   
       y2d = 7258,  
       radius = 12,  
   },  
   {   
       x2d = 17051,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 17051,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 17051,   
       y2d = 8051,  
       radius = 5,  
   },  
   {   
       x2d = 17081,   
       y2d = 8131,  
       radius = 35,  
   },  
   {   
       x2d = 17088,   
       y2d = 8238,  
       radius = 42,  
   },  
   {   
       x2d = 17058,   
       y2d = 8758,  
       radius = 12,  
   },  
   {   
       x2d = 17051,   
       y2d = 8801,  
       radius = 5,  
   },  
   {   
       x2d = 17066,   
       y2d = 8916,  
       radius = 20,  
   },  
   {   
       x2d = 17073,   
       y2d = 8973,  
       radius = 27,  
   },  
   {   
       x2d = 17073,   
       y2d = 9223,  
       radius = 27,  
   },  
   {   
       x2d = 17088,   
       y2d = 9288,  
       radius = 42,  
   },  
   {   
       x2d = 17073,   
       y2d = 9423,  
       radius = 27,  
   },  
   {   
       x2d = 17051,   
       y2d = 9501,  
       radius = 5,  
   },  
   {   
       x2d = 17051,   
       y2d = 9751,  
       radius = 5,  
   },  
   {   
       x2d = 17058,   
       y2d = 10358,  
       radius = 12,  
   },  
   {   
       x2d = 17138,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 17101,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 17123,   
       y2d = 3223,  
       radius = 27,  
   },  
   {   
       x2d = 17131,   
       y2d = 3281,  
       radius = 35,  
   },  
   {   
       x2d = 17108,   
       y2d = 3358,  
       radius = 12,  
   },  
   {   
       x2d = 17138,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 17131,   
       y2d = 3531,  
       radius = 35,  
   },  
   {   
       x2d = 17138,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 17116,   
       y2d = 3966,  
       radius = 20,  
   },  
   {   
       x2d = 17108,   
       y2d = 4058,  
       radius = 12,  
   },  
   {   
       x2d = 17123,   
       y2d = 4123,  
       radius = 27,  
   },  
   {   
       x2d = 17101,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 17101,   
       y2d = 4701,  
       radius = 5,  
   },  
   {   
       x2d = 17108,   
       y2d = 5208,  
       radius = 12,  
   },  
   {   
       x2d = 17101,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 17101,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 17108,   
       y2d = 5558,  
       radius = 12,  
   },  
   {   
       x2d = 17116,   
       y2d = 5616,  
       radius = 20,  
   },  
   {   
       x2d = 17138,   
       y2d = 5688,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 6638,  
       radius = 42,  
   },  
   {   
       x2d = 17123,   
       y2d = 6723,  
       radius = 27,  
   },  
   {   
       x2d = 17138,   
       y2d = 7088,  
       radius = 42,  
   },  
   {   
       x2d = 17108,   
       y2d = 7358,  
       radius = 12,  
   },  
   {   
       x2d = 17116,   
       y2d = 7416,  
       radius = 20,  
   },  
   {   
       x2d = 17108,   
       y2d = 7558,  
       radius = 12,  
   },  
   {   
       x2d = 17108,   
       y2d = 7608,  
       radius = 12,  
   },  
   {   
       x2d = 17116,   
       y2d = 7666,  
       radius = 20,  
   },  
   {   
       x2d = 17101,   
       y2d = 7801,  
       radius = 5,  
   },  
   {   
       x2d = 17101,   
       y2d = 7951,  
       radius = 5,  
   },  
   {   
       x2d = 17138,   
       y2d = 8088,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 8338,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 8538,  
       radius = 42,  
   },  
   {   
       x2d = 17138,   
       y2d = 8638,  
       radius = 42,  
   },  
   {   
       x2d = 17101,   
       y2d = 9151,  
       radius = 5,  
   },  
   {   
       x2d = 17116,   
       y2d = 9516,  
       radius = 20,  
   },  
   {   
       x2d = 17123,   
       y2d = 9573,  
       radius = 27,  
   },  
   {   
       x2d = 17108,   
       y2d = 9658,  
       radius = 12,  
   },  
   {   
       x2d = 17101,   
       y2d = 9751,  
       radius = 5,  
   },  
   {   
       x2d = 17101,   
       y2d = 9801,  
       radius = 5,  
   },  
   {   
       x2d = 17101,   
       y2d = 10051,  
       radius = 5,  
   },  
   {   
       x2d = 17101,   
       y2d = 10101,  
       radius = 5,  
   },  
   {   
       x2d = 17101,   
       y2d = 10301,  
       radius = 5,  
   },  
   {   
       x2d = 17188,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 17188,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 17188,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 17188,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 17188,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 17188,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 17188,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 17188,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 17188,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 17188,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 17188,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 17188,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 17151,   
       y2d = 3051,  
       radius = 5,  
   },  
   {   
       x2d = 17166,   
       y2d = 3166,  
       radius = 20,  
   },  
   {   
       x2d = 17188,   
       y2d = 3838,  
       radius = 42,  
   },  
   {   
       x2d = 17181,   
       y2d = 3931,  
       radius = 35,  
   },  
   {   
       x2d = 17188,   
       y2d = 4088,  
       radius = 42,  
   },  
   {   
       x2d = 17151,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 17188,   
       y2d = 5788,  
       radius = 42,  
   },  
   {   
       x2d = 17151,   
       y2d = 5951,  
       radius = 5,  
   },  
   {   
       x2d = 17181,   
       y2d = 6481,  
       radius = 35,  
   },  
   {   
       x2d = 17181,   
       y2d = 6731,  
       radius = 35,  
   },  
   {   
       x2d = 17181,   
       y2d = 6831,  
       radius = 35,  
   },  
   {   
       x2d = 17166,   
       y2d = 6916,  
       radius = 20,  
   },  
   {   
       x2d = 17158,   
       y2d = 7408,  
       radius = 12,  
   },  
   {   
       x2d = 17151,   
       y2d = 7551,  
       radius = 5,  
   },  
   {   
       x2d = 17151,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 17151,   
       y2d = 7951,  
       radius = 5,  
   },  
   {   
       x2d = 17188,   
       y2d = 8188,  
       radius = 42,  
   },  
   {   
       x2d = 17151,   
       y2d = 8751,  
       radius = 5,  
   },  
   {   
       x2d = 17151,   
       y2d = 8801,  
       radius = 5,  
   },  
   {   
       x2d = 17173,   
       y2d = 8873,  
       radius = 27,  
   },  
   {   
       x2d = 17188,   
       y2d = 8988,  
       radius = 42,  
   },  
   {   
       x2d = 17173,   
       y2d = 9073,  
       radius = 27,  
   },  
   {   
       x2d = 17151,   
       y2d = 9351,  
       radius = 5,  
   },  
   {   
       x2d = 17151,   
       y2d = 9701,  
       radius = 5,  
   },  
   {   
       x2d = 17151,   
       y2d = 9801,  
       radius = 5,  
   },  
   {   
       x2d = 17151,   
       y2d = 10051,  
       radius = 5,  
   },  
   {   
       x2d = 17151,   
       y2d = 10201,  
       radius = 5,  
   },  
   {   
       x2d = 17173,   
       y2d = 10323,  
       radius = 27,  
   },  
   {   
       x2d = 17188,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 17208,   
       y2d = 3058,  
       radius = 12,  
   },  
   {   
       x2d = 17238,   
       y2d = 3288,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 3488,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 4238,  
       radius = 42,  
   },  
   {   
       x2d = 17201,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 17208,   
       y2d = 5308,  
       radius = 12,  
   },  
   {   
       x2d = 17208,   
       y2d = 5358,  
       radius = 12,  
   },  
   {   
       x2d = 17208,   
       y2d = 5408,  
       radius = 12,  
   },  
   {   
       x2d = 17201,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 17238,   
       y2d = 5688,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 5888,  
       radius = 42,  
   },  
   {   
       x2d = 17216,   
       y2d = 6016,  
       radius = 20,  
   },  
   {   
       x2d = 17208,   
       y2d = 6058,  
       radius = 12,  
   },  
   {   
       x2d = 17201,   
       y2d = 6101,  
       radius = 5,  
   },  
   {   
       x2d = 17238,   
       y2d = 6188,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 6288,  
       radius = 42,  
   },  
   {   
       x2d = 17201,   
       y2d = 6401,  
       radius = 5,  
   },  
   {   
       x2d = 17201,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 17238,   
       y2d = 6638,  
       radius = 42,  
   },  
   {   
       x2d = 17208,   
       y2d = 6908,  
       radius = 12,  
   },  
   {   
       x2d = 17238,   
       y2d = 6988,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 7088,  
       radius = 42,  
   },  
   {   
       x2d = 17208,   
       y2d = 7358,  
       radius = 12,  
   },  
   {   
       x2d = 17201,   
       y2d = 7401,  
       radius = 5,  
   },  
   {   
       x2d = 17208,   
       y2d = 7558,  
       radius = 12,  
   },  
   {   
       x2d = 17201,   
       y2d = 7751,  
       radius = 5,  
   },  
   {   
       x2d = 17201,   
       y2d = 7951,  
       radius = 5,  
   },  
   {   
       x2d = 17223,   
       y2d = 8023,  
       radius = 27,  
   },  
   {   
       x2d = 17231,   
       y2d = 8281,  
       radius = 35,  
   },  
   {   
       x2d = 17201,   
       y2d = 8401,  
       radius = 5,  
   },  
   {   
       x2d = 17238,   
       y2d = 8488,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 8588,  
       radius = 42,  
   },  
   {   
       x2d = 17238,   
       y2d = 8688,  
       radius = 42,  
   },  
   {   
       x2d = 17231,   
       y2d = 8781,  
       radius = 35,  
   },  
   {   
       x2d = 17216,   
       y2d = 9166,  
       radius = 20,  
   },  
   {   
       x2d = 17223,   
       y2d = 9273,  
       radius = 27,  
   },  
   {   
       x2d = 17208,   
       y2d = 9358,  
       radius = 12,  
   },  
   {   
       x2d = 17201,   
       y2d = 9501,  
       radius = 5,  
   },  
   {   
       x2d = 17208,   
       y2d = 9608,  
       radius = 12,  
   },  
   {   
       x2d = 17201,   
       y2d = 9651,  
       radius = 5,  
   },  
   {   
       x2d = 17201,   
       y2d = 9701,  
       radius = 5,  
   },  
   {   
       x2d = 17201,   
       y2d = 9751,  
       radius = 5,  
   },  
   {   
       x2d = 17288,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 17288,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 17288,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 17288,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 17288,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 17288,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 17288,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 17288,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 17288,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 17288,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 17288,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 17281,   
       y2d = 2931,  
       radius = 35,  
   },  
   {   
       x2d = 17251,   
       y2d = 3001,  
       radius = 5,  
   },  
   {   
       x2d = 17251,   
       y2d = 3051,  
       radius = 5,  
   },  
   {   
       x2d = 17258,   
       y2d = 3108,  
       radius = 12,  
   },  
   {   
       x2d = 17251,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 17273,   
       y2d = 3373,  
       radius = 27,  
   },  
   {   
       x2d = 17288,   
       y2d = 3888,  
       radius = 42,  
   },  
   {   
       x2d = 17258,   
       y2d = 4008,  
       radius = 12,  
   },  
   {   
       x2d = 17281,   
       y2d = 4081,  
       radius = 35,  
   },  
   {   
       x2d = 17251,   
       y2d = 4401,  
       radius = 5,  
   },  
   {   
       x2d = 17251,   
       y2d = 5351,  
       radius = 5,  
   },  
   {   
       x2d = 17258,   
       y2d = 5508,  
       radius = 12,  
   },  
   {   
       x2d = 17288,   
       y2d = 5788,  
       radius = 42,  
   },  
   {   
       x2d = 17258,   
       y2d = 6008,  
       radius = 12,  
   },  
   {   
       x2d = 17288,   
       y2d = 6088,  
       radius = 42,  
   },  
   {   
       x2d = 17288,   
       y2d = 6438,  
       radius = 42,  
   },  
   {   
       x2d = 17288,   
       y2d = 6538,  
       radius = 42,  
   },  
   {   
       x2d = 17288,   
       y2d = 6788,  
       radius = 42,  
   },  
   {   
       x2d = 17266,   
       y2d = 7216,  
       radius = 20,  
   },  
   {   
       x2d = 17258,   
       y2d = 7558,  
       radius = 12,  
   },  
   {   
       x2d = 17266,   
       y2d = 7616,  
       radius = 20,  
   },  
   {   
       x2d = 17251,   
       y2d = 7701,  
       radius = 5,  
   },  
   {   
       x2d = 17281,   
       y2d = 8081,  
       radius = 35,  
   },  
   {   
       x2d = 17266,   
       y2d = 8216,  
       radius = 20,  
   },  
   {   
       x2d = 17251,   
       y2d = 8351,  
       radius = 5,  
   },  
   {   
       x2d = 17288,   
       y2d = 8888,  
       radius = 42,  
   },  
   {   
       x2d = 17273,   
       y2d = 8973,  
       radius = 27,  
   },  
   {   
       x2d = 17251,   
       y2d = 9051,  
       radius = 5,  
   },  
   {   
       x2d = 17258,   
       y2d = 9558,  
       radius = 12,  
   },  
   {   
       x2d = 17258,   
       y2d = 9608,  
       radius = 12,  
   },  
   {   
       x2d = 17258,   
       y2d = 9658,  
       radius = 12,  
   },  
   {   
       x2d = 17251,   
       y2d = 10051,  
       radius = 5,  
   },  
   {   
       x2d = 17251,   
       y2d = 10151,  
       radius = 5,  
   },  
   {   
       x2d = 17338,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 17323,   
       y2d = 3273,  
       radius = 27,  
   },  
   {   
       x2d = 17331,   
       y2d = 3331,  
       radius = 35,  
   },  
   {   
       x2d = 17323,   
       y2d = 3423,  
       radius = 27,  
   },  
   {   
       x2d = 17338,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 17323,   
       y2d = 3973,  
       radius = 27,  
   },  
   {   
       x2d = 17301,   
       y2d = 4151,  
       radius = 5,  
   },  
   {   
       x2d = 17301,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 17301,   
       y2d = 4401,  
       radius = 5,  
   },  
   {   
       x2d = 17301,   
       y2d = 5101,  
       radius = 5,  
   },  
   {   
       x2d = 17308,   
       y2d = 5158,  
       radius = 12,  
   },  
   {   
       x2d = 17308,   
       y2d = 5408,  
       radius = 12,  
   },  
   {   
       x2d = 17301,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 17308,   
       y2d = 5608,  
       radius = 12,  
   },  
   {   
       x2d = 17331,   
       y2d = 5681,  
       radius = 35,  
   },  
   {   
       x2d = 17338,   
       y2d = 5888,  
       radius = 42,  
   },  
   {   
       x2d = 17323,   
       y2d = 5973,  
       radius = 27,  
   },  
   {   
       x2d = 17338,   
       y2d = 6238,  
       radius = 42,  
   },  
   {   
       x2d = 17338,   
       y2d = 6338,  
       radius = 42,  
   },  
   {   
       x2d = 17323,   
       y2d = 6623,  
       radius = 27,  
   },  
   {   
       x2d = 17301,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 17316,   
       y2d = 6966,  
       radius = 20,  
   },  
   {   
       x2d = 17338,   
       y2d = 7088,  
       radius = 42,  
   },  
   {   
       x2d = 17323,   
       y2d = 7223,  
       radius = 27,  
   },  
   {   
       x2d = 17301,   
       y2d = 7501,  
       radius = 5,  
   },  
   {   
       x2d = 17316,   
       y2d = 7616,  
       radius = 20,  
   },  
   {   
       x2d = 17338,   
       y2d = 7688,  
       radius = 42,  
   },  
   {   
       x2d = 17331,   
       y2d = 7781,  
       radius = 35,  
   },  
   {   
       x2d = 17331,   
       y2d = 7981,  
       radius = 35,  
   },  
   {   
       x2d = 17338,   
       y2d = 8238,  
       radius = 42,  
   },  
   {   
       x2d = 17323,   
       y2d = 8623,  
       radius = 27,  
   },  
   {   
       x2d = 17338,   
       y2d = 8688,  
       radius = 42,  
   },  
   {   
       x2d = 17301,   
       y2d = 8801,  
       radius = 5,  
   },  
   {   
       x2d = 17338,   
       y2d = 8988,  
       radius = 42,  
   },  
   {   
       x2d = 17301,   
       y2d = 9101,  
       radius = 5,  
   },  
   {   
       x2d = 17316,   
       y2d = 9166,  
       radius = 20,  
   },  
   {   
       x2d = 17301,   
       y2d = 9251,  
       radius = 5,  
   },  
   {   
       x2d = 17308,   
       y2d = 9408,  
       radius = 12,  
   },  
   {   
       x2d = 17308,   
       y2d = 9558,  
       radius = 12,  
   },  
   {   
       x2d = 17301,   
       y2d = 9851,  
       radius = 5,  
   },  
   {   
       x2d = 17301,   
       y2d = 10101,  
       radius = 5,  
   },  
   {   
       x2d = 17388,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 17388,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 17388,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 17388,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 17388,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 17388,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 17388,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 17388,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 17388,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 17388,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 17388,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 17373,   
       y2d = 2923,  
       radius = 27,  
   },  
   {   
       x2d = 17388,   
       y2d = 3838,  
       radius = 42,  
   },  
   {   
       x2d = 17388,   
       y2d = 3938,  
       radius = 42,  
   },  
   {   
       x2d = 17373,   
       y2d = 4073,  
       radius = 27,  
   },  
   {   
       x2d = 17381,   
       y2d = 4131,  
       radius = 35,  
   },  
   {   
       x2d = 17351,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 17358,   
       y2d = 5158,  
       radius = 12,  
   },  
   {   
       x2d = 17351,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 17351,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 17351,   
       y2d = 5451,  
       radius = 5,  
   },  
   {   
       x2d = 17351,   
       y2d = 5551,  
       radius = 5,  
   },  
   {   
       x2d = 17388,   
       y2d = 5788,  
       radius = 42,  
   },  
   {   
       x2d = 17388,   
       y2d = 5988,  
       radius = 42,  
   },  
   {   
       x2d = 17381,   
       y2d = 6081,  
       radius = 35,  
   },  
   {   
       x2d = 17373,   
       y2d = 6473,  
       radius = 27,  
   },  
   {   
       x2d = 17351,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 17373,   
       y2d = 7173,  
       radius = 27,  
   },  
   {   
       x2d = 17351,   
       y2d = 7301,  
       radius = 5,  
   },  
   {   
       x2d = 17351,   
       y2d = 7401,  
       radius = 5,  
   },  
   {   
       x2d = 17366,   
       y2d = 8066,  
       radius = 20,  
   },  
   {   
       x2d = 17366,   
       y2d = 8116,  
       radius = 20,  
   },  
   {   
       x2d = 17373,   
       y2d = 8323,  
       radius = 27,  
   },  
   {   
       x2d = 17351,   
       y2d = 8401,  
       radius = 5,  
   },  
   {   
       x2d = 17351,   
       y2d = 8451,  
       radius = 5,  
   },  
   {   
       x2d = 17388,   
       y2d = 8538,  
       radius = 42,  
   },  
   {   
       x2d = 17388,   
       y2d = 8838,  
       radius = 42,  
   },  
   {   
       x2d = 17351,   
       y2d = 9101,  
       radius = 5,  
   },  
   {   
       x2d = 17366,   
       y2d = 9166,  
       radius = 20,  
   },  
   {   
       x2d = 17351,   
       y2d = 9351,  
       radius = 5,  
   },  
   {   
       x2d = 17351,   
       y2d = 9451,  
       radius = 5,  
   },  
   {   
       x2d = 17351,   
       y2d = 9551,  
       radius = 5,  
   },  
   {   
       x2d = 17351,   
       y2d = 9801,  
       radius = 5,  
   },  
   {   
       x2d = 17388,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 17431,   
       y2d = 3131,  
       radius = 35,  
   },  
   {   
       x2d = 17431,   
       y2d = 3331,  
       radius = 35,  
   },  
   {   
       x2d = 17438,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 3588,  
       radius = 42,  
   },  
   {   
       x2d = 17423,   
       y2d = 3673,  
       radius = 27,  
   },  
   {   
       x2d = 17438,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 17431,   
       y2d = 4231,  
       radius = 35,  
   },  
   {   
       x2d = 17401,   
       y2d = 4851,  
       radius = 5,  
   },  
   {   
       x2d = 17423,   
       y2d = 5123,  
       radius = 27,  
   },  
   {   
       x2d = 17401,   
       y2d = 5351,  
       radius = 5,  
   },  
   {   
       x2d = 17408,   
       y2d = 5408,  
       radius = 12,  
   },  
   {   
       x2d = 17416,   
       y2d = 5666,  
       radius = 20,  
   },  
   {   
       x2d = 17438,   
       y2d = 5888,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 6188,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 6288,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 6388,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 6888,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 6988,  
       radius = 42,  
   },  
   {   
       x2d = 17431,   
       y2d = 7181,  
       radius = 35,  
   },  
   {   
       x2d = 17401,   
       y2d = 7301,  
       radius = 5,  
   },  
   {   
       x2d = 17423,   
       y2d = 7623,  
       radius = 27,  
   },  
   {   
       x2d = 17431,   
       y2d = 7781,  
       radius = 35,  
   },  
   {   
       x2d = 17401,   
       y2d = 7851,  
       radius = 5,  
   },  
   {   
       x2d = 17423,   
       y2d = 8173,  
       radius = 27,  
   },  
   {   
       x2d = 17438,   
       y2d = 8238,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 8338,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 8638,  
       radius = 42,  
   },  
   {   
       x2d = 17438,   
       y2d = 8938,  
       radius = 42,  
   },  
   {   
       x2d = 17408,   
       y2d = 9108,  
       radius = 12,  
   },  
   {   
       x2d = 17416,   
       y2d = 9166,  
       radius = 20,  
   },  
   {   
       x2d = 17416,   
       y2d = 9266,  
       radius = 20,  
   },  
   {   
       x2d = 17438,   
       y2d = 9488,  
       radius = 42,  
   },  
   {   
       x2d = 17423,   
       y2d = 9623,  
       radius = 27,  
   },  
   {   
       x2d = 17401,   
       y2d = 9701,  
       radius = 5,  
   },  
   {   
       x2d = 17408,   
       y2d = 9858,  
       radius = 12,  
   },  
   {   
       x2d = 17401,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 17408,   
       y2d = 10058,  
       radius = 12,  
   },  
   {   
       x2d = 17401,   
       y2d = 10101,  
       radius = 5,  
   },  
   {   
       x2d = 17401,   
       y2d = 10201,  
       radius = 5,  
   },  
   {   
       x2d = 17488,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 17488,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 17488,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 17488,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 17488,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 17488,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 17488,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 17488,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 17488,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 17488,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 17488,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 17481,   
       y2d = 3281,  
       radius = 35,  
   },  
   {   
       x2d = 17488,   
       y2d = 3838,  
       radius = 42,  
   },  
   {   
       x2d = 17488,   
       y2d = 3988,  
       radius = 42,  
   },  
   {   
       x2d = 17481,   
       y2d = 4181,  
       radius = 35,  
   },  
   {   
       x2d = 17451,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 17488,   
       y2d = 4388,  
       radius = 42,  
   },  
   {   
       x2d = 17488,   
       y2d = 4488,  
       radius = 42,  
   },  
   {   
       x2d = 17473,   
       y2d = 4573,  
       radius = 27,  
   },  
   {   
       x2d = 17451,   
       y2d = 4851,  
       radius = 5,  
   },  
   {   
       x2d = 17451,   
       y2d = 5001,  
       radius = 5,  
   },  
   {   
       x2d = 17451,   
       y2d = 5051,  
       radius = 5,  
   },  
   {   
       x2d = 17451,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 17451,   
       y2d = 5501,  
       radius = 5,  
   },  
   {   
       x2d = 17451,   
       y2d = 5601,  
       radius = 5,  
   },  
   {   
       x2d = 17488,   
       y2d = 5738,  
       radius = 42,  
   },  
   {   
       x2d = 17481,   
       y2d = 6081,  
       radius = 35,  
   },  
   {   
       x2d = 17473,   
       y2d = 7073,  
       radius = 27,  
   },  
   {   
       x2d = 17458,   
       y2d = 7258,  
       radius = 12,  
   },  
   {   
       x2d = 17458,   
       y2d = 7708,  
       radius = 12,  
   },  
   {   
       x2d = 17466,   
       y2d = 8016,  
       radius = 20,  
   },  
   {   
       x2d = 17488,   
       y2d = 8788,  
       radius = 42,  
   },  
   {   
       x2d = 17488,   
       y2d = 9088,  
       radius = 42,  
   },  
   {   
       x2d = 17473,   
       y2d = 9173,  
       radius = 27,  
   },  
   {   
       x2d = 17451,   
       y2d = 9351,  
       radius = 5,  
   },  
   {   
       x2d = 17451,   
       y2d = 9701,  
       radius = 5,  
   },  
   {   
       x2d = 17466,   
       y2d = 10016,  
       radius = 20,  
   },  
   {   
       x2d = 17488,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 17523,   
       y2d = 3223,  
       radius = 27,  
   },  
   {   
       x2d = 17531,   
       y2d = 3431,  
       radius = 35,  
   },  
   {   
       x2d = 17501,   
       y2d = 3501,  
       radius = 5,  
   },  
   {   
       x2d = 17523,   
       y2d = 3573,  
       radius = 27,  
   },  
   {   
       x2d = 17538,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 17516,   
       y2d = 4116,  
       radius = 20,  
   },  
   {   
       x2d = 17501,   
       y2d = 4251,  
       radius = 5,  
   },  
   {   
       x2d = 17508,   
       y2d = 5008,  
       radius = 12,  
   },  
   {   
       x2d = 17508,   
       y2d = 5058,  
       radius = 12,  
   },  
   {   
       x2d = 17501,   
       y2d = 5101,  
       radius = 5,  
   },  
   {   
       x2d = 17501,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 17501,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 17508,   
       y2d = 5458,  
       radius = 12,  
   },  
   {   
       x2d = 17538,   
       y2d = 5838,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 5938,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 6038,  
       radius = 42,  
   },  
   {   
       x2d = 17523,   
       y2d = 6173,  
       radius = 27,  
   },  
   {   
       x2d = 17538,   
       y2d = 6238,  
       radius = 42,  
   },  
   {   
       x2d = 17501,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 17538,   
       y2d = 6838,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 6938,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 7038,  
       radius = 42,  
   },  
   {   
       x2d = 17501,   
       y2d = 7201,  
       radius = 5,  
   },  
   {   
       x2d = 17501,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 17501,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 17516,   
       y2d = 7716,  
       radius = 20,  
   },  
   {   
       x2d = 17501,   
       y2d = 7851,  
       radius = 5,  
   },  
   {   
       x2d = 17508,   
       y2d = 7958,  
       radius = 12,  
   },  
   {   
       x2d = 17501,   
       y2d = 8051,  
       radius = 5,  
   },  
   {   
       x2d = 17508,   
       y2d = 8108,  
       radius = 12,  
   },  
   {   
       x2d = 17508,   
       y2d = 8158,  
       radius = 12,  
   },  
   {   
       x2d = 17538,   
       y2d = 8288,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 8388,  
       radius = 42,  
   },  
   {   
       x2d = 17508,   
       y2d = 8508,  
       radius = 12,  
   },  
   {   
       x2d = 17538,   
       y2d = 8588,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 8888,  
       radius = 42,  
   },  
   {   
       x2d = 17538,   
       y2d = 8988,  
       radius = 42,  
   },  
   {   
       x2d = 17516,   
       y2d = 9266,  
       radius = 20,  
   },  
   {   
       x2d = 17516,   
       y2d = 9466,  
       radius = 20,  
   },  
   {   
       x2d = 17501,   
       y2d = 9651,  
       radius = 5,  
   },  
   {   
       x2d = 17501,   
       y2d = 9901,  
       radius = 5,  
   },  
   {   
       x2d = 17516,   
       y2d = 9966,  
       radius = 20,  
   },  
   {   
       x2d = 17508,   
       y2d = 10008,  
       radius = 12,  
   },  
   {   
       x2d = 17588,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 17588,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 17588,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 17588,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 17588,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 17588,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 17588,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 17588,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 17588,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 17588,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 17588,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 17551,   
       y2d = 3151,  
       radius = 5,  
   },  
   {   
       x2d = 17588,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 17588,   
       y2d = 3838,  
       radius = 42,  
   },  
   {   
       x2d = 17573,   
       y2d = 3973,  
       radius = 27,  
   },  
   {   
       x2d = 17566,   
       y2d = 4166,  
       radius = 20,  
   },  
   {   
       x2d = 17588,   
       y2d = 4238,  
       radius = 42,  
   },  
   {   
       x2d = 17566,   
       y2d = 4366,  
       radius = 20,  
   },  
   {   
       x2d = 17573,   
       y2d = 4423,  
       radius = 27,  
   },  
   {   
       x2d = 17566,   
       y2d = 5016,  
       radius = 20,  
   },  
   {   
       x2d = 17558,   
       y2d = 5058,  
       radius = 12,  
   },  
   {   
       x2d = 17588,   
       y2d = 5738,  
       radius = 42,  
   },  
   {   
       x2d = 17551,   
       y2d = 6351,  
       radius = 5,  
   },  
   {   
       x2d = 17573,   
       y2d = 7123,  
       radius = 27,  
   },  
   {   
       x2d = 17588,   
       y2d = 7188,  
       radius = 42,  
   },  
   {   
       x2d = 17551,   
       y2d = 7551,  
       radius = 5,  
   },  
   {   
       x2d = 17551,   
       y2d = 7751,  
       radius = 5,  
   },  
   {   
       x2d = 17573,   
       y2d = 7823,  
       radius = 27,  
   },  
   {   
       x2d = 17551,   
       y2d = 7901,  
       radius = 5,  
   },  
   {   
       x2d = 17551,   
       y2d = 8001,  
       radius = 5,  
   },  
   {   
       x2d = 17551,   
       y2d = 8051,  
       radius = 5,  
   },  
   {   
       x2d = 17551,   
       y2d = 8101,  
       radius = 5,  
   },  
   {   
       x2d = 17551,   
       y2d = 8201,  
       radius = 5,  
   },  
   {   
       x2d = 17588,   
       y2d = 8688,  
       radius = 42,  
   },  
   {   
       x2d = 17588,   
       y2d = 8788,  
       radius = 42,  
   },  
   {   
       x2d = 17551,   
       y2d = 9501,  
       radius = 5,  
   },  
   {   
       x2d = 17558,   
       y2d = 9758,  
       radius = 12,  
   },  
   {   
       x2d = 17551,   
       y2d = 9801,  
       radius = 5,  
   },  
   {   
       x2d = 17566,   
       y2d = 10366,  
       radius = 20,  
   },  
   {   
       x2d = 17638,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 17601,   
       y2d = 3201,  
       radius = 5,  
   },  
   {   
       x2d = 17638,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 17631,   
       y2d = 3531,  
       radius = 35,  
   },  
   {   
       x2d = 17638,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 3938,  
       radius = 42,  
   },  
   {   
       x2d = 17616,   
       y2d = 4366,  
       radius = 20,  
   },  
   {   
       x2d = 17608,   
       y2d = 4808,  
       radius = 12,  
   },  
   {   
       x2d = 17608,   
       y2d = 4958,  
       radius = 12,  
   },  
   {   
       x2d = 17601,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 17601,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 17601,   
       y2d = 5351,  
       radius = 5,  
   },  
   {   
       x2d = 17638,   
       y2d = 5838,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 5988,  
       radius = 42,  
   },  
   {   
       x2d = 17601,   
       y2d = 6151,  
       radius = 5,  
   },  
   {   
       x2d = 17616,   
       y2d = 6216,  
       radius = 20,  
   },  
   {   
       x2d = 17616,   
       y2d = 6266,  
       radius = 20,  
   },  
   {   
       x2d = 17616,   
       y2d = 6966,  
       radius = 20,  
   },  
   {   
       x2d = 17638,   
       y2d = 7038,  
       radius = 42,  
   },  
   {   
       x2d = 17601,   
       y2d = 7551,  
       radius = 5,  
   },  
   {   
       x2d = 17601,   
       y2d = 7601,  
       radius = 5,  
   },  
   {   
       x2d = 17608,   
       y2d = 7708,  
       radius = 12,  
   },  
   {   
       x2d = 17638,   
       y2d = 7788,  
       radius = 42,  
   },  
   {   
       x2d = 17623,   
       y2d = 7873,  
       radius = 27,  
   },  
   {   
       x2d = 17608,   
       y2d = 7958,  
       radius = 12,  
   },  
   {   
       x2d = 17608,   
       y2d = 8008,  
       radius = 12,  
   },  
   {   
       x2d = 17601,   
       y2d = 8051,  
       radius = 5,  
   },  
   {   
       x2d = 17601,   
       y2d = 8151,  
       radius = 5,  
   },  
   {   
       x2d = 17638,   
       y2d = 8388,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 8488,  
       radius = 42,  
   },  
   {   
       x2d = 17638,   
       y2d = 8888,  
       radius = 42,  
   },  
   {   
       x2d = 17601,   
       y2d = 9051,  
       radius = 5,  
   },  
   {   
       x2d = 17601,   
       y2d = 9601,  
       radius = 5,  
   },  
   {   
       x2d = 17616,   
       y2d = 9666,  
       radius = 20,  
   },  
   {   
       x2d = 17608,   
       y2d = 9758,  
       radius = 12,  
   },  
   {   
       x2d = 17601,   
       y2d = 9801,  
       radius = 5,  
   },  
   {   
       x2d = 17616,   
       y2d = 9866,  
       radius = 20,  
   },  
   {   
       x2d = 17608,   
       y2d = 9908,  
       radius = 12,  
   },  
   {   
       x2d = 17608,   
       y2d = 10308,  
       radius = 12,  
   },  
   {   
       x2d = 17688,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 17688,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 17688,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 17688,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 17688,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 17688,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 17688,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 17688,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 17688,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 17688,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 17688,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 17688,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 17666,   
       y2d = 3316,  
       radius = 20,  
   },  
   {   
       x2d = 17681,   
       y2d = 3831,  
       radius = 35,  
   },  
   {   
       x2d = 17666,   
       y2d = 4166,  
       radius = 20,  
   },  
   {   
       x2d = 17651,   
       y2d = 4301,  
       radius = 5,  
   },  
   {   
       x2d = 17651,   
       y2d = 4851,  
       radius = 5,  
   },  
   {   
       x2d = 17658,   
       y2d = 4958,  
       radius = 12,  
   },  
   {   
       x2d = 17651,   
       y2d = 5051,  
       radius = 5,  
   },  
   {   
       x2d = 17658,   
       y2d = 5358,  
       radius = 12,  
   },  
   {   
       x2d = 17651,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 17688,   
       y2d = 5738,  
       radius = 42,  
   },  
   {   
       x2d = 17658,   
       y2d = 6258,  
       radius = 12,  
   },  
   {   
       x2d = 17688,   
       y2d = 7138,  
       radius = 42,  
   },  
   {   
       x2d = 17688,   
       y2d = 7238,  
       radius = 42,  
   },  
   {   
       x2d = 17681,   
       y2d = 7631,  
       radius = 35,  
   },  
   {   
       x2d = 17658,   
       y2d = 7958,  
       radius = 12,  
   },  
   {   
       x2d = 17673,   
       y2d = 8073,  
       radius = 27,  
   },  
   {   
       x2d = 17688,   
       y2d = 8588,  
       radius = 42,  
   },  
   {   
       x2d = 17688,   
       y2d = 8688,  
       radius = 42,  
   },  
   {   
       x2d = 17688,   
       y2d = 8788,  
       radius = 42,  
   },  
   {   
       x2d = 17673,   
       y2d = 8973,  
       radius = 27,  
   },  
   {   
       x2d = 17666,   
       y2d = 9066,  
       radius = 20,  
   },  
   {   
       x2d = 17651,   
       y2d = 9551,  
       radius = 5,  
   },  
   {   
       x2d = 17658,   
       y2d = 9708,  
       radius = 12,  
   },  
   {   
       x2d = 17666,   
       y2d = 9766,  
       radius = 20,  
   },  
   {   
       x2d = 17681,   
       y2d = 9881,  
       radius = 35,  
   },  
   {   
       x2d = 17651,   
       y2d = 10351,  
       radius = 5,  
   },  
   {   
       x2d = 17738,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 17738,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 17738,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 17738,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 17738,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 17738,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 17738,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 17738,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 17738,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 17738,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 17738,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 17738,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 17738,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 17738,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 17738,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 17738,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 17738,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 17738,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 17723,   
       y2d = 2923,  
       radius = 27,  
   },  
   {   
       x2d = 17738,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 17738,   
       y2d = 3388,  
       radius = 42,  
   },  
   {   
       x2d = 17723,   
       y2d = 3473,  
       radius = 27,  
   },  
   {   
       x2d = 17738,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 17731,   
       y2d = 3631,  
       radius = 35,  
   },  
   {   
       x2d = 17738,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 17738,   
       y2d = 3938,  
       radius = 42,  
   },  
   {   
       x2d = 17723,   
       y2d = 4373,  
       radius = 27,  
   },  
   {   
       x2d = 17708,   
       y2d = 4458,  
       radius = 12,  
   },  
   {   
       x2d = 17701,   
       y2d = 5051,  
       radius = 5,  
   },  
   {   
       x2d = 17701,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 17701,   
       y2d = 5351,  
       radius = 5,  
   },  
   {   
       x2d = 17723,   
       y2d = 5823,  
       radius = 27,  
   },  
   {   
       x2d = 17738,   
       y2d = 5938,  
       radius = 42,  
   },  
   {   
       x2d = 17701,   
       y2d = 7401,  
       radius = 5,  
   },  
   {   
       x2d = 17708,   
       y2d = 7708,  
       radius = 12,  
   },  
   {   
       x2d = 17738,   
       y2d = 7838,  
       radius = 42,  
   },  
   {   
       x2d = 17731,   
       y2d = 7931,  
       radius = 35,  
   },  
   {   
       x2d = 17738,   
       y2d = 8038,  
       radius = 42,  
   },  
   {   
       x2d = 17701,   
       y2d = 8151,  
       radius = 5,  
   },  
   {   
       x2d = 17708,   
       y2d = 8308,  
       radius = 12,  
   },  
   {   
       x2d = 17731,   
       y2d = 8381,  
       radius = 35,  
   },  
   {   
       x2d = 17716,   
       y2d = 9066,  
       radius = 20,  
   },  
   {   
       x2d = 17708,   
       y2d = 9658,  
       radius = 12,  
   },  
   {   
       x2d = 17701,   
       y2d = 9701,  
       radius = 5,  
   },  
   {   
       x2d = 17716,   
       y2d = 9766,  
       radius = 20,  
   },  
   {   
       x2d = 17701,   
       y2d = 10201,  
       radius = 5,  
   },  
   {   
       x2d = 17708,   
       y2d = 10258,  
       radius = 12,  
   },  
   {   
       x2d = 17701,   
       y2d = 10301,  
       radius = 5,  
   },  
   {   
       x2d = 17701,   
       y2d = 10351,  
       radius = 5,  
   },  
   {   
       x2d = 17788,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 17788,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 17788,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 17788,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 17788,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 17788,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 17788,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 17788,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 17788,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 17788,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 17788,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 17788,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 17788,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 17788,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 17788,   
       y2d = 4038,  
       radius = 42,  
   },  
   {   
       x2d = 17788,   
       y2d = 4138,  
       radius = 42,  
   },  
   {   
       x2d = 17781,   
       y2d = 4231,  
       radius = 35,  
   },  
   {   
       x2d = 17766,   
       y2d = 4316,  
       radius = 20,  
   },  
   {   
       x2d = 17758,   
       y2d = 4458,  
       radius = 12,  
   },  
   {   
       x2d = 17758,   
       y2d = 4958,  
       radius = 12,  
   },  
   {   
       x2d = 17751,   
       y2d = 5051,  
       radius = 5,  
   },  
   {   
       x2d = 17758,   
       y2d = 5308,  
       radius = 12,  
   },  
   {   
       x2d = 17751,   
       y2d = 5351,  
       radius = 5,  
   },  
   {   
       x2d = 17751,   
       y2d = 5501,  
       radius = 5,  
   },  
   {   
       x2d = 17751,   
       y2d = 5551,  
       radius = 5,  
   },  
   {   
       x2d = 17751,   
       y2d = 5601,  
       radius = 5,  
   },  
   {   
       x2d = 17766,   
       y2d = 5666,  
       radius = 20,  
   },  
   {   
       x2d = 17788,   
       y2d = 5738,  
       radius = 42,  
   },  
   {   
       x2d = 17751,   
       y2d = 6801,  
       radius = 5,  
   },  
   {   
       x2d = 17788,   
       y2d = 6938,  
       radius = 42,  
   },  
   {   
       x2d = 17788,   
       y2d = 7038,  
       radius = 42,  
   },  
   {   
       x2d = 17788,   
       y2d = 7188,  
       radius = 42,  
   },  
   {   
       x2d = 17788,   
       y2d = 7288,  
       radius = 42,  
   },  
   {   
       x2d = 17773,   
       y2d = 7373,  
       radius = 27,  
   },  
   {   
       x2d = 17751,   
       y2d = 7501,  
       radius = 5,  
   },  
   {   
       x2d = 17758,   
       y2d = 7608,  
       radius = 12,  
   },  
   {   
       x2d = 17758,   
       y2d = 7658,  
       radius = 12,  
   },  
   {   
       x2d = 17751,   
       y2d = 7701,  
       radius = 5,  
   },  
   {   
       x2d = 17758,   
       y2d = 8208,  
       radius = 12,  
   },  
   {   
       x2d = 17751,   
       y2d = 8301,  
       radius = 5,  
   },  
   {   
       x2d = 17773,   
       y2d = 8473,  
       radius = 27,  
   },  
   {   
       x2d = 17781,   
       y2d = 8531,  
       radius = 35,  
   },  
   {   
       x2d = 17781,   
       y2d = 8681,  
       radius = 35,  
   },  
   {   
       x2d = 17788,   
       y2d = 8788,  
       radius = 42,  
   },  
   {   
       x2d = 17788,   
       y2d = 8888,  
       radius = 42,  
   },  
   {   
       x2d = 17781,   
       y2d = 8981,  
       radius = 35,  
   },  
   {   
       x2d = 17766,   
       y2d = 9066,  
       radius = 20,  
   },  
   {   
       x2d = 17758,   
       y2d = 9758,  
       radius = 12,  
   },  
   {   
       x2d = 17773,   
       y2d = 9923,  
       radius = 27,  
   },  
   {   
       x2d = 17751,   
       y2d = 10251,  
       radius = 5,  
   },  
   {   
       x2d = 17838,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 3838,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 3938,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 4338,  
       radius = 42,  
   },  
   {   
       x2d = 17838,   
       y2d = 4438,  
       radius = 42,  
   },  
   {   
       x2d = 17801,   
       y2d = 4951,  
       radius = 5,  
   },  
   {   
       x2d = 17801,   
       y2d = 5101,  
       radius = 5,  
   },  
   {   
       x2d = 17801,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 17808,   
       y2d = 6008,  
       radius = 12,  
   },  
   {   
       x2d = 17816,   
       y2d = 7566,  
       radius = 20,  
   },  
   {   
       x2d = 17808,   
       y2d = 7608,  
       radius = 12,  
   },  
   {   
       x2d = 17808,   
       y2d = 7658,  
       radius = 12,  
   },  
   {   
       x2d = 17801,   
       y2d = 7751,  
       radius = 5,  
   },  
   {   
       x2d = 17816,   
       y2d = 7916,  
       radius = 20,  
   },  
   {   
       x2d = 17838,   
       y2d = 8088,  
       radius = 42,  
   },  
   {   
       x2d = 17831,   
       y2d = 8181,  
       radius = 35,  
   },  
   {   
       x2d = 17823,   
       y2d = 8273,  
       radius = 27,  
   },  
   {   
       x2d = 17808,   
       y2d = 8408,  
       radius = 12,  
   },  
   {   
       x2d = 17801,   
       y2d = 8601,  
       radius = 5,  
   },  
   {   
       x2d = 17801,   
       y2d = 9151,  
       radius = 5,  
   },  
   {   
       x2d = 17801,   
       y2d = 9601,  
       radius = 5,  
   },  
   {   
       x2d = 17801,   
       y2d = 9701,  
       radius = 5,  
   },  
   {   
       x2d = 17801,   
       y2d = 9851,  
       radius = 5,  
   },  
   {   
       x2d = 17838,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 4038,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 4138,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 4238,  
       radius = 42,  
   },  
   {   
       x2d = 17851,   
       y2d = 4801,  
       radius = 5,  
   },  
   {   
       x2d = 17873,   
       y2d = 4923,  
       radius = 27,  
   },  
   {   
       x2d = 17851,   
       y2d = 5151,  
       radius = 5,  
   },  
   {   
       x2d = 17851,   
       y2d = 5551,  
       radius = 5,  
   },  
   {   
       x2d = 17851,   
       y2d = 5601,  
       radius = 5,  
   },  
   {   
       x2d = 17873,   
       y2d = 5723,  
       radius = 27,  
   },  
   {   
       x2d = 17866,   
       y2d = 5816,  
       radius = 20,  
   },  
   {   
       x2d = 17851,   
       y2d = 5901,  
       radius = 5,  
   },  
   {   
       x2d = 17858,   
       y2d = 5958,  
       radius = 12,  
   },  
   {   
       x2d = 17881,   
       y2d = 6031,  
       radius = 35,  
   },  
   {   
       x2d = 17851,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 17866,   
       y2d = 6766,  
       radius = 20,  
   },  
   {   
       x2d = 17858,   
       y2d = 6808,  
       radius = 12,  
   },  
   {   
       x2d = 17888,   
       y2d = 6988,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 7088,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 7188,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 7288,  
       radius = 42,  
   },  
   {   
       x2d = 17881,   
       y2d = 7381,  
       radius = 35,  
   },  
   {   
       x2d = 17866,   
       y2d = 7566,  
       radius = 20,  
   },  
   {   
       x2d = 17858,   
       y2d = 7708,  
       radius = 12,  
   },  
   {   
       x2d = 17888,   
       y2d = 7888,  
       radius = 42,  
   },  
   {   
       x2d = 17888,   
       y2d = 8288,  
       radius = 42,  
   },  
   {   
       x2d = 17881,   
       y2d = 8381,  
       radius = 35,  
   },  
   {   
       x2d = 17851,   
       y2d = 8501,  
       radius = 5,  
   },  
   {   
       x2d = 17851,   
       y2d = 8551,  
       radius = 5,  
   },  
   {   
       x2d = 17866,   
       y2d = 8716,  
       radius = 20,  
   },  
   {   
       x2d = 17881,   
       y2d = 8781,  
       radius = 35,  
   },  
   {   
       x2d = 17881,   
       y2d = 8881,  
       radius = 35,  
   },  
   {   
       x2d = 17851,   
       y2d = 8951,  
       radius = 5,  
   },  
   {   
       x2d = 17858,   
       y2d = 9008,  
       radius = 12,  
   },  
   {   
       x2d = 17851,   
       y2d = 9151,  
       radius = 5,  
   },  
   {   
       x2d = 17888,   
       y2d = 9238,  
       radius = 42,  
   },  
   {   
       x2d = 17873,   
       y2d = 9673,  
       radius = 27,  
   },  
   {   
       x2d = 17858,   
       y2d = 9808,  
       radius = 12,  
   },  
   {   
       x2d = 17858,   
       y2d = 9858,  
       radius = 12,  
   },  
   {   
       x2d = 17858,   
       y2d = 9908,  
       radius = 12,  
   },  
   {   
       x2d = 17851,   
       y2d = 10251,  
       radius = 5,  
   },  
   {   
       x2d = 17938,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 17931,   
       y2d = 3631,  
       radius = 35,  
   },  
   {   
       x2d = 17938,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 3838,  
       radius = 42,  
   },  
   {   
       x2d = 17931,   
       y2d = 3931,  
       radius = 35,  
   },  
   {   
       x2d = 17938,   
       y2d = 4388,  
       radius = 42,  
   },  
   {   
       x2d = 17901,   
       y2d = 5001,  
       radius = 5,  
   },  
   {   
       x2d = 17901,   
       y2d = 5101,  
       radius = 5,  
   },  
   {   
       x2d = 17931,   
       y2d = 5531,  
       radius = 35,  
   },  
   {   
       x2d = 17923,   
       y2d = 5623,  
       radius = 27,  
   },  
   {   
       x2d = 17916,   
       y2d = 5816,  
       radius = 20,  
   },  
   {   
       x2d = 17923,   
       y2d = 5923,  
       radius = 27,  
   },  
   {   
       x2d = 17901,   
       y2d = 6651,  
       radius = 5,  
   },  
   {   
       x2d = 17916,   
       y2d = 6716,  
       radius = 20,  
   },  
   {   
       x2d = 17901,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 17916,   
       y2d = 7566,  
       radius = 20,  
   },  
   {   
       x2d = 17931,   
       y2d = 7731,  
       radius = 35,  
   },  
   {   
       x2d = 17916,   
       y2d = 8016,  
       radius = 20,  
   },  
   {   
       x2d = 17938,   
       y2d = 8188,  
       radius = 42,  
   },  
   {   
       x2d = 17938,   
       y2d = 8488,  
       radius = 42,  
   },  
   {   
       x2d = 17931,   
       y2d = 8631,  
       radius = 35,  
   },  
   {   
       x2d = 17931,   
       y2d = 8981,  
       radius = 35,  
   },  
   {   
       x2d = 17901,   
       y2d = 9051,  
       radius = 5,  
   },  
   {   
       x2d = 17901,   
       y2d = 9801,  
       radius = 5,  
   },  
   {   
       x2d = 17901,   
       y2d = 9851,  
       radius = 5,  
   },  
   {   
       x2d = 17938,   
       y2d = 10388,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 4088,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 4188,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 4288,  
       radius = 42,  
   },  
   {   
       x2d = 17951,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 17966,   
       y2d = 4966,  
       radius = 20,  
   },  
   {   
       x2d = 17973,   
       y2d = 5123,  
       radius = 27,  
   },  
   {   
       x2d = 17973,   
       y2d = 5473,  
       radius = 27,  
   },  
   {   
       x2d = 17958,   
       y2d = 5808,  
       radius = 12,  
   },  
   {   
       x2d = 17988,   
       y2d = 5888,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 5988,  
       radius = 42,  
   },  
   {   
       x2d = 17951,   
       y2d = 6101,  
       radius = 5,  
   },  
   {   
       x2d = 17951,   
       y2d = 6151,  
       radius = 5,  
   },  
   {   
       x2d = 17951,   
       y2d = 6601,  
       radius = 5,  
   },  
   {   
       x2d = 17958,   
       y2d = 6708,  
       radius = 12,  
   },  
   {   
       x2d = 17951,   
       y2d = 6901,  
       radius = 5,  
   },  
   {   
       x2d = 17966,   
       y2d = 6966,  
       radius = 20,  
   },  
   {   
       x2d = 17988,   
       y2d = 7038,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 7138,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 7238,  
       radius = 42,  
   },  
   {   
       x2d = 17988,   
       y2d = 7338,  
       radius = 42,  
   },  
   {   
       x2d = 17981,   
       y2d = 7581,  
       radius = 35,  
   },  
   {   
       x2d = 17988,   
       y2d = 7838,  
       radius = 42,  
   },  
   {   
       x2d = 17973,   
       y2d = 7923,  
       radius = 27,  
   },  
   {   
       x2d = 17958,   
       y2d = 8058,  
       radius = 12,  
   },  
   {   
       x2d = 17981,   
       y2d = 8331,  
       radius = 35,  
   },  
   {   
       x2d = 17988,   
       y2d = 8588,  
       radius = 42,  
   },  
   {   
       x2d = 17951,   
       y2d = 8701,  
       radius = 5,  
   },  
   {   
       x2d = 17981,   
       y2d = 8831,  
       radius = 35,  
   },  
   {   
       x2d = 17951,   
       y2d = 9151,  
       radius = 5,  
   },  
   {   
       x2d = 17988,   
       y2d = 9288,  
       radius = 42,  
   },  
   {   
       x2d = 17951,   
       y2d = 9551,  
       radius = 5,  
   },  
   {   
       x2d = 17951,   
       y2d = 9651,  
       radius = 5,  
   },  
   {   
       x2d = 17951,   
       y2d = 9901,  
       radius = 5,  
   },  
   {   
       x2d = 18038,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 3838,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 3938,  
       radius = 42,  
   },  
   {   
       x2d = 18031,   
       y2d = 4381,  
       radius = 35,  
   },  
   {   
       x2d = 18023,   
       y2d = 4473,  
       radius = 27,  
   },  
   {   
       x2d = 18008,   
       y2d = 4708,  
       radius = 12,  
   },  
   {   
       x2d = 18001,   
       y2d = 5051,  
       radius = 5,  
   },  
   {   
       x2d = 18001,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 18001,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 18016,   
       y2d = 5516,  
       radius = 20,  
   },  
   {   
       x2d = 18016,   
       y2d = 5616,  
       radius = 20,  
   },  
   {   
       x2d = 18038,   
       y2d = 5688,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 5788,  
       radius = 42,  
   },  
   {   
       x2d = 18001,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 18001,   
       y2d = 6701,  
       radius = 5,  
   },  
   {   
       x2d = 18001,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 18038,   
       y2d = 7488,  
       radius = 42,  
   },  
   {   
       x2d = 18001,   
       y2d = 7651,  
       radius = 5,  
   },  
   {   
       x2d = 18008,   
       y2d = 7708,  
       radius = 12,  
   },  
   {   
       x2d = 18001,   
       y2d = 7751,  
       radius = 5,  
   },  
   {   
       x2d = 18038,   
       y2d = 8088,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 8288,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 8688,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 8938,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 9138,  
       radius = 42,  
   },  
   {   
       x2d = 18038,   
       y2d = 9388,  
       radius = 42,  
   },  
   {   
       x2d = 18008,   
       y2d = 9658,  
       radius = 12,  
   },  
   {   
       x2d = 18031,   
       y2d = 10381,  
       radius = 35,  
   },  
   {   
       x2d = 18088,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 18088,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 18088,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 18088,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 18088,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 18088,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 18088,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 18088,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 18088,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 18088,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 18088,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 18088,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 18088,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 18088,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 18088,   
       y2d = 4188,  
       radius = 42,  
   },  
   {   
       x2d = 18058,   
       y2d = 5158,  
       radius = 12,  
   },  
   {   
       x2d = 18051,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 18051,   
       y2d = 5551,  
       radius = 5,  
   },  
   {   
       x2d = 18088,   
       y2d = 5888,  
       radius = 42,  
   },  
   {   
       x2d = 18066,   
       y2d = 6016,  
       radius = 20,  
   },  
   {   
       x2d = 18051,   
       y2d = 6151,  
       radius = 5,  
   },  
   {   
       x2d = 18058,   
       y2d = 6408,  
       radius = 12,  
   },  
   {   
       x2d = 18058,   
       y2d = 6808,  
       radius = 12,  
   },  
   {   
       x2d = 18073,   
       y2d = 6873,  
       radius = 27,  
   },  
   {   
       x2d = 18088,   
       y2d = 6938,  
       radius = 42,  
   },  
   {   
       x2d = 18088,   
       y2d = 7038,  
       radius = 42,  
   },  
   {   
       x2d = 18088,   
       y2d = 7138,  
       radius = 42,  
   },  
   {   
       x2d = 18088,   
       y2d = 7238,  
       radius = 42,  
   },  
   {   
       x2d = 18088,   
       y2d = 7338,  
       radius = 42,  
   },  
   {   
       x2d = 18066,   
       y2d = 7616,  
       radius = 20,  
   },  
   {   
       x2d = 18088,   
       y2d = 7838,  
       radius = 42,  
   },  
   {   
       x2d = 18073,   
       y2d = 7923,  
       radius = 27,  
   },  
   {   
       x2d = 18088,   
       y2d = 8188,  
       radius = 42,  
   },  
   {   
       x2d = 18073,   
       y2d = 8373,  
       radius = 27,  
   },  
   {   
       x2d = 18088,   
       y2d = 8538,  
       radius = 42,  
   },  
   {   
       x2d = 18073,   
       y2d = 9273,  
       radius = 27,  
   },  
   {   
       x2d = 18081,   
       y2d = 9481,  
       radius = 35,  
   },  
   {   
       x2d = 18051,   
       y2d = 9551,  
       radius = 5,  
   },  
   {   
       x2d = 18051,   
       y2d = 9601,  
       radius = 5,  
   },  
   {   
       x2d = 18081,   
       y2d = 9681,  
       radius = 35,  
   },  
   {   
       x2d = 18073,   
       y2d = 9773,  
       radius = 27,  
   },  
   {   
       x2d = 18138,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 3838,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 3938,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 4288,  
       radius = 42,  
   },  
   {   
       x2d = 18131,   
       y2d = 4431,  
       radius = 35,  
   },  
   {   
       x2d = 18101,   
       y2d = 4501,  
       radius = 5,  
   },  
   {   
       x2d = 18108,   
       y2d = 4608,  
       radius = 12,  
   },  
   {   
       x2d = 18108,   
       y2d = 4758,  
       radius = 12,  
   },  
   {   
       x2d = 18116,   
       y2d = 5016,  
       radius = 20,  
   },  
   {   
       x2d = 18101,   
       y2d = 5201,  
       radius = 5,  
   },  
   {   
       x2d = 18108,   
       y2d = 5258,  
       radius = 12,  
   },  
   {   
       x2d = 18108,   
       y2d = 5308,  
       radius = 12,  
   },  
   {   
       x2d = 18101,   
       y2d = 5351,  
       radius = 5,  
   },  
   {   
       x2d = 18138,   
       y2d = 5488,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 5588,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 5688,  
       radius = 42,  
   },  
   {   
       x2d = 18131,   
       y2d = 5781,  
       radius = 35,  
   },  
   {   
       x2d = 18101,   
       y2d = 6101,  
       radius = 5,  
   },  
   {   
       x2d = 18101,   
       y2d = 6151,  
       radius = 5,  
   },  
   {   
       x2d = 18101,   
       y2d = 6201,  
       radius = 5,  
   },  
   {   
       x2d = 18108,   
       y2d = 6258,  
       radius = 12,  
   },  
   {   
       x2d = 18101,   
       y2d = 6301,  
       radius = 5,  
   },  
   {   
       x2d = 18138,   
       y2d = 6388,  
       radius = 42,  
   },  
   {   
       x2d = 18101,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 18131,   
       y2d = 7431,  
       radius = 35,  
   },  
   {   
       x2d = 18131,   
       y2d = 7531,  
       radius = 35,  
   },  
   {   
       x2d = 18108,   
       y2d = 7608,  
       radius = 12,  
   },  
   {   
       x2d = 18101,   
       y2d = 7701,  
       radius = 5,  
   },  
   {   
       x2d = 18101,   
       y2d = 7751,  
       radius = 5,  
   },  
   {   
       x2d = 18138,   
       y2d = 8088,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 8288,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 8388,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 8638,  
       radius = 42,  
   },  
   {   
       x2d = 18108,   
       y2d = 8758,  
       radius = 12,  
   },  
   {   
       x2d = 18108,   
       y2d = 8808,  
       radius = 12,  
   },  
   {   
       x2d = 18138,   
       y2d = 8888,  
       radius = 42,  
   },  
   {   
       x2d = 18123,   
       y2d = 8973,  
       radius = 27,  
   },  
   {   
       x2d = 18138,   
       y2d = 9138,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 9238,  
       radius = 42,  
   },  
   {   
       x2d = 18138,   
       y2d = 9338,  
       radius = 42,  
   },  
   {   
       x2d = 18131,   
       y2d = 9431,  
       radius = 35,  
   },  
   {   
       x2d = 18108,   
       y2d = 9558,  
       radius = 12,  
   },  
   {   
       x2d = 18116,   
       y2d = 9616,  
       radius = 20,  
   },  
   {   
       x2d = 18101,   
       y2d = 9851,  
       radius = 5,  
   },  
   {   
       x2d = 18188,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 18188,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 18188,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 18188,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 18188,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 18188,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 18188,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 18188,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 18188,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 18188,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 18188,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 18188,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 18188,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 18188,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 18173,   
       y2d = 4023,  
       radius = 27,  
   },  
   {   
       x2d = 18188,   
       y2d = 4388,  
       radius = 42,  
   },  
   {   
       x2d = 18173,   
       y2d = 4573,  
       radius = 27,  
   },  
   {   
       x2d = 18158,   
       y2d = 4658,  
       radius = 12,  
   },  
   {   
       x2d = 18158,   
       y2d = 4858,  
       radius = 12,  
   },  
   {   
       x2d = 18188,   
       y2d = 4938,  
       radius = 42,  
   },  
   {   
       x2d = 18158,   
       y2d = 5058,  
       radius = 12,  
   },  
   {   
       x2d = 18151,   
       y2d = 5251,  
       radius = 5,  
   },  
   {   
       x2d = 18151,   
       y2d = 5301,  
       radius = 5,  
   },  
   {   
       x2d = 18151,   
       y2d = 5351,  
       radius = 5,  
   },  
   {   
       x2d = 18151,   
       y2d = 5401,  
       radius = 5,  
   },  
   {   
       x2d = 18166,   
       y2d = 5966,  
       radius = 20,  
   },  
   {   
       x2d = 18158,   
       y2d = 6008,  
       radius = 12,  
   },  
   {   
       x2d = 18158,   
       y2d = 6058,  
       radius = 12,  
   },  
   {   
       x2d = 18181,   
       y2d = 6131,  
       radius = 35,  
   },  
   {   
       x2d = 18173,   
       y2d = 6223,  
       radius = 27,  
   },  
   {   
       x2d = 18188,   
       y2d = 6288,  
       radius = 42,  
   },  
   {   
       x2d = 18151,   
       y2d = 6551,  
       radius = 5,  
   },  
   {   
       x2d = 18188,   
       y2d = 6638,  
       radius = 42,  
   },  
   {   
       x2d = 18151,   
       y2d = 6751,  
       radius = 5,  
   },  
   {   
       x2d = 18188,   
       y2d = 6888,  
       radius = 42,  
   },  
   {   
       x2d = 18188,   
       y2d = 7038,  
       radius = 42,  
   },  
   {   
       x2d = 18188,   
       y2d = 7238,  
       radius = 42,  
   },  
   {   
       x2d = 18188,   
       y2d = 7338,  
       radius = 42,  
   },  
   {   
       x2d = 18158,   
       y2d = 7608,  
       radius = 12,  
   },  
   {   
       x2d = 18151,   
       y2d = 7751,  
       radius = 5,  
   },  
   {   
       x2d = 18166,   
       y2d = 7916,  
       radius = 20,  
   },  
   {   
       x2d = 18188,   
       y2d = 8188,  
       radius = 42,  
   },  
   {   
       x2d = 18188,   
       y2d = 8488,  
       radius = 42,  
   },  
   {   
       x2d = 18151,   
       y2d = 8751,  
       radius = 5,  
   },  
   {   
       x2d = 18188,   
       y2d = 8988,  
       radius = 42,  
   },  
   {   
       x2d = 18151,   
       y2d = 9501,  
       radius = 5,  
   },  
   {   
       x2d = 18151,   
       y2d = 10101,  
       radius = 5,  
   },  
   {   
       x2d = 18166,   
       y2d = 10316,  
       radius = 20,  
   },  
   {   
       x2d = 18238,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 3488,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 3588,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 3688,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 3788,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 3888,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 3988,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 4088,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 4188,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 4288,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 4488,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 4588,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 4688,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 4788,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 5038,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 5138,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 5238,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 5338,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 5438,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 5538,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 5638,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 5738,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 5838,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 5938,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 6038,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 6388,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 6488,  
       radius = 42,  
   },  
   {   
       x2d = 18223,   
       y2d = 6723,  
       radius = 27,  
   },  
   {   
       x2d = 18201,   
       y2d = 7551,  
       radius = 5,  
   },  
   {   
       x2d = 18238,   
       y2d = 7788,  
       radius = 42,  
   },  
   {   
       x2d = 18208,   
       y2d = 7908,  
       radius = 12,  
   },  
   {   
       x2d = 18208,   
       y2d = 7958,  
       radius = 12,  
   },  
   {   
       x2d = 18238,   
       y2d = 8038,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 8288,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 8588,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 8688,  
       radius = 42,  
   },  
   {   
       x2d = 18201,   
       y2d = 8801,  
       radius = 5,  
   },  
   {   
       x2d = 18238,   
       y2d = 8888,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 9088,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 9188,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 9288,  
       radius = 42,  
   },  
   {   
       x2d = 18238,   
       y2d = 9388,  
       radius = 42,  
   },  
   {   
       x2d = 18208,   
       y2d = 9658,  
       radius = 12,  
   },  
   {   
       x2d = 18201,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 18201,   
       y2d = 10051,  
       radius = 5,  
   },  
   {   
       x2d = 18208,   
       y2d = 10108,  
       radius = 12,  
   },  
   {   
       x2d = 18201,   
       y2d = 10151,  
       radius = 5,  
   },  
   {   
       x2d = 18288,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 18288,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 18288,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 18288,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 18288,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 18288,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 18288,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 18288,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 18288,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 18288,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 18288,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 18288,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 18288,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 18288,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 18288,   
       y2d = 4388,  
       radius = 42,  
   },  
   {   
       x2d = 18288,   
       y2d = 4888,  
       radius = 42,  
   },  
   {   
       x2d = 18288,   
       y2d = 6138,  
       radius = 42,  
   },  
   {   
       x2d = 18288,   
       y2d = 6238,  
       radius = 42,  
   },  
   {   
       x2d = 18266,   
       y2d = 6616,  
       radius = 20,  
   },  
   {   
       x2d = 18288,   
       y2d = 6688,  
       radius = 42,  
   },  
   {   
       x2d = 18251,   
       y2d = 6801,  
       radius = 5,  
   },  
   {   
       x2d = 18288,   
       y2d = 6888,  
       radius = 42,  
   },  
   {   
       x2d = 18288,   
       y2d = 7038,  
       radius = 42,  
   },  
   {   
       x2d = 18273,   
       y2d = 7123,  
       radius = 27,  
   },  
   {   
       x2d = 18288,   
       y2d = 7238,  
       radius = 42,  
   },  
   {   
       x2d = 18281,   
       y2d = 7331,  
       radius = 35,  
   },  
   {   
       x2d = 18251,   
       y2d = 7401,  
       radius = 5,  
   },  
   {   
       x2d = 18288,   
       y2d = 8138,  
       radius = 42,  
   },  
   {   
       x2d = 18288,   
       y2d = 8388,  
       radius = 42,  
   },  
   {   
       x2d = 18273,   
       y2d = 8473,  
       radius = 27,  
   },  
   {   
       x2d = 18288,   
       y2d = 8988,  
       radius = 42,  
   },  
   {   
       x2d = 18251,   
       y2d = 9751,  
       radius = 5,  
   },  
   {   
       x2d = 18251,   
       y2d = 9901,  
       radius = 5,  
   },  
   {   
       x2d = 18258,   
       y2d = 10058,  
       radius = 12,  
   },  
   {   
       x2d = 18273,   
       y2d = 10123,  
       radius = 27,  
   },  
   {   
       x2d = 18338,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 3838,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 3938,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 4038,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 4138,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 4238,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 4488,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 4588,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 4688,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 4788,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 4988,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 5088,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 5188,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 5288,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 5388,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 5488,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 5588,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 5688,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 5788,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 5888,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 5988,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 6338,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 6438,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 6538,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 7138,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 7738,  
       radius = 42,  
   },  
   {   
       x2d = 18308,   
       y2d = 7908,  
       radius = 12,  
   },  
   {   
       x2d = 18308,   
       y2d = 7958,  
       radius = 12,  
   },  
   {   
       x2d = 18338,   
       y2d = 8038,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 8238,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 8488,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 8588,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 8688,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 9088,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 9188,  
       radius = 42,  
   },  
   {   
       x2d = 18338,   
       y2d = 9288,  
       radius = 42,  
   },  
   {   
       x2d = 18301,   
       y2d = 10351,  
       radius = 5,  
   },  
   {   
       x2d = 18388,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 4338,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 4888,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 6088,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 6188,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 6638,  
       radius = 42,  
   },  
   {   
       x2d = 18381,   
       y2d = 6731,  
       radius = 35,  
   },  
   {   
       x2d = 18351,   
       y2d = 6801,  
       radius = 5,  
   },  
   {   
       x2d = 18373,   
       y2d = 6923,  
       radius = 27,  
   },  
   {   
       x2d = 18388,   
       y2d = 7038,  
       radius = 42,  
   },  
   {   
       x2d = 18373,   
       y2d = 7273,  
       radius = 27,  
   },  
   {   
       x2d = 18373,   
       y2d = 7923,  
       radius = 27,  
   },  
   {   
       x2d = 18388,   
       y2d = 8138,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 8338,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 8888,  
       radius = 42,  
   },  
   {   
       x2d = 18388,   
       y2d = 8988,  
       radius = 42,  
   },  
   {   
       x2d = 18351,   
       y2d = 9501,  
       radius = 5,  
   },  
   {   
       x2d = 18351,   
       y2d = 9551,  
       radius = 5,  
   },  
   {   
       x2d = 18351,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 18358,   
       y2d = 10108,  
       radius = 12,  
   },  
   {   
       x2d = 18358,   
       y2d = 10158,  
       radius = 12,  
   },  
   {   
       x2d = 18351,   
       y2d = 10201,  
       radius = 5,  
   },  
   {   
       x2d = 18351,   
       y2d = 10301,  
       radius = 5,  
   },  
   {   
       x2d = 18373,   
       y2d = 10373,  
       radius = 27,  
   },  
   {   
       x2d = 18438,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 3838,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 3938,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 4038,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 4138,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 4238,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 4438,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 4538,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 4638,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 4738,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 4988,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 5088,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 5188,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 5288,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 5388,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 5488,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 5588,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 5688,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 5788,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 5888,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 5988,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 6288,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 6388,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 6488,  
       radius = 42,  
   },  
   {   
       x2d = 18401,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 18438,   
       y2d = 7188,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 7688,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 7788,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 7938,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 8038,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 8238,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 8438,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 8538,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 8638,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 8738,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 9088,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 9188,  
       radius = 42,  
   },  
   {   
       x2d = 18438,   
       y2d = 9288,  
       radius = 42,  
   },  
   {   
       x2d = 18401,   
       y2d = 9451,  
       radius = 5,  
   },  
   {   
       x2d = 18408,   
       y2d = 9508,  
       radius = 12,  
   },  
   {   
       x2d = 18401,   
       y2d = 9901,  
       radius = 5,  
   },  
   {   
       x2d = 18401,   
       y2d = 10051,  
       radius = 5,  
   },  
   {   
       x2d = 18431,   
       y2d = 10181,  
       radius = 35,  
   },  
   {   
       x2d = 18488,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 4338,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 4838,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 6088,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 6188,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 6588,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 6688,  
       radius = 42,  
   },  
   {   
       x2d = 18466,   
       y2d = 6966,  
       radius = 20,  
   },  
   {   
       x2d = 18451,   
       y2d = 7401,  
       radius = 5,  
   },  
   {   
       x2d = 18488,   
       y2d = 8138,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 8338,  
       radius = 42,  
   },  
   {   
       x2d = 18488,   
       y2d = 8838,  
       radius = 42,  
   },  
   {   
       x2d = 18481,   
       y2d = 8931,  
       radius = 35,  
   },  
   {   
       x2d = 18481,   
       y2d = 9431,  
       radius = 35,  
   },  
   {   
       x2d = 18451,   
       y2d = 9501,  
       radius = 5,  
   },  
   {   
       x2d = 18473,   
       y2d = 9623,  
       radius = 27,  
   },  
   {   
       x2d = 18538,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 3838,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 3938,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 4038,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 4138,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 4238,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 4438,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 4538,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 4638,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 4738,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 4938,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 5038,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 5138,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 5238,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 5338,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 5438,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 5538,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 5638,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 5738,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 5838,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 5938,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 6288,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 6388,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 6488,  
       radius = 42,  
   },  
   {   
       x2d = 18508,   
       y2d = 6808,  
       radius = 12,  
   },  
   {   
       x2d = 18501,   
       y2d = 6851,  
       radius = 5,  
   },  
   {   
       x2d = 18501,   
       y2d = 7001,  
       radius = 5,  
   },  
   {   
       x2d = 18508,   
       y2d = 7058,  
       radius = 12,  
   },  
   {   
       x2d = 18516,   
       y2d = 7116,  
       radius = 20,  
   },  
   {   
       x2d = 18523,   
       y2d = 7173,  
       radius = 27,  
   },  
   {   
       x2d = 18501,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 18531,   
       y2d = 7731,  
       radius = 35,  
   },  
   {   
       x2d = 18538,   
       y2d = 7838,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 7988,  
       radius = 42,  
   },  
   {   
       x2d = 18523,   
       y2d = 8223,  
       radius = 27,  
   },  
   {   
       x2d = 18538,   
       y2d = 8438,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 8538,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 8638,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 8738,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 9038,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 9138,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 9238,  
       radius = 42,  
   },  
   {   
       x2d = 18538,   
       y2d = 9338,  
       radius = 42,  
   },  
   {   
       x2d = 18523,   
       y2d = 9573,  
       radius = 27,  
   },  
   {   
       x2d = 18516,   
       y2d = 9666,  
       radius = 20,  
   },  
   {   
       x2d = 18588,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 4338,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 4838,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 6038,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 6138,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 6588,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 6688,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 6788,  
       radius = 42,  
   },  
   {   
       x2d = 18558,   
       y2d = 6908,  
       radius = 12,  
   },  
   {   
       x2d = 18588,   
       y2d = 7038,  
       radius = 42,  
   },  
   {   
       x2d = 18551,   
       y2d = 7251,  
       radius = 5,  
   },  
   {   
       x2d = 18551,   
       y2d = 7301,  
       radius = 5,  
   },  
   {   
       x2d = 18551,   
       y2d = 7451,  
       radius = 5,  
   },  
   {   
       x2d = 18551,   
       y2d = 7551,  
       radius = 5,  
   },  
   {   
       x2d = 18588,   
       y2d = 8088,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 8288,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 8838,  
       radius = 42,  
   },  
   {   
       x2d = 18588,   
       y2d = 8938,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 3838,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 3938,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 4038,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 4138,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 4238,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 4438,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 4538,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 4638,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 4738,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 4938,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 5038,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 5138,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 5238,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 5338,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 5438,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 5538,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 5638,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 5738,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 5838,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 5938,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 6238,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 6338,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 6438,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 6888,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 7138,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 7238,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 7338,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 7488,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 7638,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 7738,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 7838,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 7938,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 8188,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 8438,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 8538,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 8688,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 9038,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 9138,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 9238,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 9338,  
       radius = 42,  
   },  
   {   
       x2d = 18638,   
       y2d = 9438,  
       radius = 42,  
   },  
   {   
       x2d = 18601,   
       y2d = 10051,  
       radius = 5,  
   },  
   {   
       x2d = 18601,   
       y2d = 10101,  
       radius = 5,  
   },  
   {   
       x2d = 18688,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 4338,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 4838,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 6038,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 6138,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 6538,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 6638,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 6738,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 6988,  
       radius = 42,  
   },  
   {   
       x2d = 18681,   
       y2d = 8081,  
       radius = 35,  
   },  
   {   
       x2d = 18688,   
       y2d = 8288,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 8788,  
       radius = 42,  
   },  
   {   
       x2d = 18688,   
       y2d = 8888,  
       radius = 42,  
   },  
   {   
       x2d = 18651,   
       y2d = 9901,  
       radius = 5,  
   },  
   {   
       x2d = 18651,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 18738,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 2538,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 2638,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 2738,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 3838,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 3938,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 4038,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 4138,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 4238,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 4438,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 4538,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 4638,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 4738,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 4938,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 5038,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 5138,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 5238,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 5338,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 5438,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 5538,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 5638,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 5738,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 5838,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 5938,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 6238,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 6338,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 6438,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 6838,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 7088,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 7188,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 7288,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 7388,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 7488,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 7588,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 7688,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 7788,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 7888,  
       radius = 42,  
   },  
   {   
       x2d = 18723,   
       y2d = 7973,  
       radius = 27,  
   },  
   {   
       x2d = 18731,   
       y2d = 8181,  
       radius = 35,  
   },  
   {   
       x2d = 18738,   
       y2d = 8388,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 8488,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 8588,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 8688,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 9038,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 9138,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 9238,  
       radius = 42,  
   },  
   {   
       x2d = 18738,   
       y2d = 9338,  
       radius = 42,  
   },  
   {   
       x2d = 18731,   
       y2d = 9431,  
       radius = 35,  
   },  
   {   
       x2d = 18708,   
       y2d = 9508,  
       radius = 12,  
   },  
   {   
       x2d = 18708,   
       y2d = 9908,  
       radius = 12,  
   },  
   {   
       x2d = 18701,   
       y2d = 9951,  
       radius = 5,  
   },  
   {   
       x2d = 18701,   
       y2d = 10001,  
       radius = 5,  
   },  
   {   
       x2d = 18701,   
       y2d = 10051,  
       radius = 5,  
   },  
   {   
       x2d = 18788,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 2838,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 2938,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 4338,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 4838,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 6038,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 6138,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 6538,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 6638,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 6738,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 6938,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 7988,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 8288,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 8788,  
       radius = 42,  
   },  
   {   
       x2d = 18788,   
       y2d = 8888,  
       radius = 42,  
   },  
   {   
       x2d = 18751,   
       y2d = 9501,  
       radius = 5,  
   },  
   {   
       x2d = 18751,   
       y2d = 9851,  
       radius = 5,  
   },  
   {   
       x2d = 18751,   
       y2d = 9901,  
       radius = 5,  
   },  
   {   
       x2d = 18758,   
       y2d = 10208,  
       radius = 12,  
   },  
   {   
       x2d = 18838,   
       y2d = 38,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 138,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 238,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 338,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 438,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 538,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 638,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 1138,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 1238,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 1338,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 1438,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 1538,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 2038,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 2138,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 2438,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 2588,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 2688,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 3038,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 3338,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 3438,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 3538,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 3638,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 3738,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 3838,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 3938,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 4038,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 4138,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 4238,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 4438,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 4538,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 4638,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 4738,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 4938,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 5038,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 5138,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 5238,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 5338,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 5438,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 5538,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 5638,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 5738,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 5838,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 5938,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 6238,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 6338,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 6438,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 6838,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 7038,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 7138,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 7238,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 7338,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 7438,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 7538,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 7638,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 7738,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 7838,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 8088,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 8188,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 8388,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 8488,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 8588,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 8688,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 8988,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 9088,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 9188,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 9288,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 9388,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 9488,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 9588,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 9688,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 9788,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 9888,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 9988,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 10088,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 10188,  
       radius = 42,  
   },  
   {   
       x2d = 18838,   
       y2d = 10288,  
       radius = 42,  
   },  
   {   
       x2d = 18823,   
       y2d = 10373,  
       radius = 27,  
   },  
   {   
       x2d = 18888,   
       y2d = 738,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 838,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 938,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 1038,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 1638,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 1738,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 1838,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 1938,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 2238,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 2338,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 2788,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 2888,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 3138,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 3238,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 4338,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 4838,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 6038,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 6138,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 6538,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 6638,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 6738,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 6938,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 7938,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 8288,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 8788,  
       radius = 42,  
   },  
   {   
       x2d = 18888,   
       y2d = 8888,  
       radius = 42,  
   },        
}
