#!/bin/bash
# Посчитать сумму первых N натуральных чисел, N передается параметром.

USAGE="Usage: sum <N> [--help]"
INFO="Calculate a sum of first N natural numbers."
ERROR="Error: Illegal parameters count!"
NUMBER_EXP="^[1-9]+([0-9])?$"

print_info() {
	echo
	echo $USAGE
	echo $INFO
        echo	
}

solve() {
	if [[ $# == 1 ]]; then
		if [[ $1 == "--help" ]]; then
			print_info
		elif ! [[ $1 =~ $NUMBER_EXP ]]; then
			echo "Error: " $1 " is not a natural number"
			exit 1
		else
			echo "Sum = " $(( ($1*($1 + 1))/2 ))
		fi
	else
		echo $ERROR
		print_info
	fi
}

solve $@
