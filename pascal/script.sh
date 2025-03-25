#!/bin/bash

# ./SortRandomNumbers from_number to_number number_count

# default:
# ./SortRandomNumbers is equal to ./SortRandomNumbers 0 100 50
#	from_number:    0
#	to_number:    100
#	number_count:  50

# to change default behaviour, you must provide all three numbers, i.e.:
# ./SortRandomNumbers 2 10 4

fpc SortRandomNumbers.pas
./SortRandomNumbers
