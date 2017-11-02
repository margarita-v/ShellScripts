#!/bin/bash
#Используя вывод команды dmesg, вывести список usb-устройств, сгруппированных по idVendor, в формате:
#idVendor : AAA
#total : 2
#usb1 : 0000:00:12.1
#usb2 : 0000:00:12.2

#idVendor : BBB
#total : 3
#usb1 : 0000:00:13.1 
#usb2 : 0000:00:13.2
#usb3 : 0000:00:13.3

#Задача делается при помощи AWK, при этом конечный результат при помощи latex выводится в PDF-файл.

USAGE="Usage: awkusb [--help]"
INFO="Используя вывод команды dmesg, вывести список usb-устройств, сгруппированных по idVendor."
IDVENDOR="idVendor"
IDPRODUCT="idProduct"

HEADER="
\\documentclass{article}
\\usepackage[utf8]{inputenc}
\\begin{document}
\\begin{tabular}{| c |}
\\hline"

FOOTER="
\\end{tabular}
\\end{document}"

if [[ $1 == "--help" ]]; then
        echo $USAGE
        echo $INFO
        exit 0
fi

# Находим строки, где есть информация об idVendor и сохряняем их во временый файл
awk '/'$IDVENDOR'/ { 
	# Находим индекс значения поля idVendor
	vendorBegin = index($0, "'$IDVENDOR'") + length("'$IDVENDOR'") + 1

	# Находим индекс окончания значения
	# Он равен индексу начала следующего поля минус два символа-разделителя
	vendorEnd = index($0, "'$IDPRODUCT'") - 2
	
	# Печатаем найденные значения полей во временный файл
	vendor = substr($0, vendorBegin, vendorEnd - vendorBegin)
	usbNumber = substr($2, 0, length($2) - 1)
	usbName = substr($4, 0, length($4)) 
	
	# Создаем строку с информацией о usb
	str = usbName " " usbNumber
	# Если информация с id = vendor уже есть в массиве,
	# мы должны добавить новую информацию о usb; иначе создаем запись с id = vendor
	if (!(vendor in vendorArr))
  		vendorArr[vendor] = str
	else
  		vendorArr[vendor] = vendorArr[vendor] ";" str
} 
END {
	printf "\\documentclass{article}\n";
  	printf "\\usepackage[utf8]{inputenc}\n";
  	printf "\\begin{document}\n";
  	printf "\\begin{tabular}{| c |}\n";
	printf "\\hline\n";

	for (key in vendorArr) {
		# Получаем массив с информацией о usb для конкретного vendor
    		split(vendorArr[key], usbArr, ";")
    		printf "idVendor: "key;
		printf "\\\\ \\hline\n";
		printf "total: "length(usbArr);
		printf "\\\\ \\hline\n";
    		for (usb in usbArr) {
      			printf usbArr[usb];
			printf "\\\\ \\hline\n";
    		}
		printf "\\\\ \\hline\n";
  	}	
	printf "\\end{tabular}\n";
  	printf "\\end{document}\n";
}' dmesg.txt | pdflatex
