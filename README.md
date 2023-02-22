# Advent of Code 2022

## Every day, all in Crystal

This repo has all of my solutions in Crystal for 2022's [Advent of Code](https://adventofcode.com/2022).
Most of the decision tree problems were solved using a state-based beam search with 
a recursive look-ahead heuristic, with just a few of the parameters tweaked for different problems.
It's not the most efficient way to solve the problems, but it's fast to write, isn't too complex to debug
and very applicable to a wide variety of problems (which makes it great for AoC). 
If you see a `State` class in a solution, this is what it is. The mapping problems were either solved
with A* or the same stupid beam search algorithm. A lot of the days have a bunch of debug functions
commented out, but all of them should produce clean answers. The runtime for each one is usually under
10 seconds, but one of the repetition detection puzzles takes a little over a minute if I recall correctly.

CLOC output:
```
---------------------------------------------------------------
File                     blank        comment           code
---------------------------------------------------------------
./24/part2.cr               34              7            187
./24/part1.cr               31             14            165
./22/part2.cr               20              1            149
./19/part1.cr               18              6            144
./19/part2.cr               19             19            133
./17/part2.cr               29              9            119
./21/part2.cr               17              0            112
./13/part2.cr               13              0            100
./23/part1.cr               13              6             98
./16/part2.cr               18              4             93
./17/part1.cr               25              9             90
./23/part2.cr               11              3             89
./11/part2.cr               15              0             88
./13/part1.cr                8              0             88
./11/part1.cr               15              0             81
./12/part1.cr               13              0             77
./12/part2.cr               13              0             77
./07/part2.cr               13              1             76
./07/part1.cr               12              1             75
./16/part1.cr               18              4             75
./14/part2.cr               12              0             74
./25/part1.cr                7              3             74
./09/part2.cr               18              0             70
./22/part1.cr               12              0             69
./14/part1.cr               10              0             68
./09/part1.cr               17              0             65
./15/part2.cr               13              0             59
./18/part2.cr               11              0             58
./10/part2.cr                9              0             56
./10/part1.cr               12              0             55
./15/part1.cr                9              0             46
./shared.cr                  4              0             43
./21/part1.cr                6              0             41
./08/part2.cr                9              0             40
./02/part2.cr                4              0             34
./08/part1.cr                9              0             34
./03/part2.cr                6              0             26
./20/part2.cr                9              5             25
./03/part1.cr                6              0             24
./02/part1.cr                4              0             23
./20/part1.cr                8              5             22
./04/part1.cr                5              0             21
./05/part1.cr                7              0             21
./04/part2.cr                5              0             19
./05/part2.cr                7              0             19
./18/part1.cr                7              0             18
./06/part1.cr                4              0             15
./06/part2.cr                4              0             15
./01/part1.cr                3              0             10
./01/part2.cr                3              0              8
./template/part2.cr          2              0              3
---------------------------------------------------------------
SUM:                       597             97           3271
---------------------------------------------------------------
```
