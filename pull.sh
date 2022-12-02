#! /bin/bash
curl --cookie "session=$(cat ../cookie)" -A "github:PenguinOwl/aoc2022" https://adventofcode.com/2022/day/${PWD##*/}/input > input.txt
