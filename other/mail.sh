#!/bin/bash

touch test.txt
cat > test.txt <<- "EOF"
hi
hello




EOF

mail -s "test1009" xdxxxx4713@gmail.com < test.txt
