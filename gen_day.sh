#! /bin/bash

dataFile="./Sources/data/day${1}.txt"
codeFile="./Sources/days/day${1}.swift"
code="class Day${1}: AdventDay {

    func part1() -> Any {
        return \"\"
    }

    func part2() -> Any {
        return \"\"
    }
}"

if [ -f "$dataFile" ]; then
    echo "data file $dataFile already exists"
else
    touch "$dataFile"
    echo "data file $dataFile created"
fi

if [ -f "$codeFile" ]; then
    echo "code file $codeFile already exists"
else
    touch "$codeFile"
    echo "$code" > "$codeFile"
    echo "code file $codeFile created"
fi
