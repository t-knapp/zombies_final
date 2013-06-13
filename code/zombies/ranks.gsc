/*
    1.1 Zombies - a Call of Duty modification
    Copyright (C) 2013 DJ Hepburn

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

/*
    lvl xp
    1	0
    2	545
    3	1090
    4	1636
    5	2182
    6	2728
    7	3275
    8	4366
    9	5458
    10	6551
    11	7643
    12	8736
    13	9830
    14	10923
    15	13107
    16	15290
    17	17474
    18	19659
    19	21843
    20	24028
    21	26214
    22	30578
    23	34943
    24	39308
    25	43673
    26	48039
    27	52405
    28	56771
    29	65495
    30	74219
    31	82944
    32	91669
    33	100394
    34	109120
    35	117846
    36	135287
    37	152728
    38	170170
    39	187612
    40	205054
    41	222497
    42	239940
    43	274813
    44	309686
    45	344559
    46	379433
    47	414307
    48	449181
    49	484056
    50	553789
    51	623523
    52	693258
    53	762992
    54	832727
    55	902463
    56	972198
*/

init() {
    level.ranks = [];
    level.ranks[ "hunters" ] = [];
    level.ranks[ "zombies" ] = [];
}