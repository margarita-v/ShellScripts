#!/bin/bash
# Найти в директории файлы размера не более N Кб, не старше М дней и имеющие тип "обычный файл".
# N, M передаются параметрами

USAGE="Usage: filecnt <size> <daycnt> [--help]"
INFO="Найти в директории файлы размера не более N Кб, не старше М дней и имеющие тип \"обычный файл\"."

if [[ $# < 2 || $1 == '--help' ]]; then
	echo $USAGE
	echo $INFO
else
	find . -type f -size -"$1"k -mtime -"$2" -print
fi
