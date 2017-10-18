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

USAGE="Usage: usblist [--help]"
INFO="Используя вывод команды dmesg, вывести список usb-устройств, сгруппированных по idVendor."
TEMPFILE=tmp.txt

if [[ $1 == "--help" ]]; then
	echo $USAGE
	echo $INFO
	exit 0
fi

# Берем строки с информацией об idVendor и разбиваем их, сохраняя результат во временный файл
grep idVendor dmesg.txt | while read STRING; do
	VENDOR=`echo $STRING | cut -d '=' -f2 | cut -d ',' -f1`
	USB=`echo $STRING | cut -d ' ' -f4`
	NUMBER=`echo $STRING | cut -d '[' -f2 | cut -d ']' -f1`
	echo $VENDOR $USB $NUMBER >> $TEMPFILE
done

# Находим уникальные idVendor и формируем информацию для них
cut -d ' ' -f1 $TEMPFILE | uniq | while read VENDOR; do
	echo
	echo idVendor: $VENDOR
	TOTAL=`grep $VENDOR $TEMPFILE | wc -l`
	echo total: $TOTAL
  	grep $VENDOR $TEMPFILE | cut -d ' ' -f2,3
done

echo
rm -f $TEMPFILE
