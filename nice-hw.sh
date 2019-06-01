#! /bin/bash

if [[ $1 == -h ]] #Обрабатываем ключ -h с инфой о запуске
then
	echo "This script needs time utility."
	echo "Follow insructions after start this script."
	echo "If you want start script whith negative nice, you must start it by root."
	exit 0
fi

for i in 1 2 #Начинаем цикл, в котором запрашиваем даннные у пользователя
do
	n=1 # Счетчик для передачи параметров
	while [[ n -eq 1 ]]
	do
		read -p "Please insert nice for process $i (-20 - 19)  " nc
		if [[ $nc -lt -20 || $nc -gt 19 ]] #проверяем на валидность введенные данные
		then
			echo "Please insert valid nice. Try again"
		else
			n=2
		fi
	done

	if [[ $i -eq 1 ]]
	 then
	 	nc1=$nc
	 else 
	 	nc2=$nc
	fi
done
#начинаем выполнение команд, конкурирующих за процессорное время:
echo "First process is starting. In progress..."
/usr/bin/time -f %E -o ./t1 nice -n $nc1 dd if=/dev/urandom bs=4096 count=25k 2>test1| nice -n $nc1 bzip2 -9 > /dev/null &
echo "First process is starting. In progress..."
/usr/bin/time -f %E -o ./t2 nice -n $nc2 dd if=/dev/urandom bs=4096 count=25k 2>test2| nice -n $nc2 bzip2 -9 > /dev/null &
echo "Now you can see top to chek out this processes"
wait
#Выводим все на экран
echo "Process 1 log: "
echo "Nice is $nc1"
cat test1
echo -n "Real execution time is:  "
cat t1
echo "Process 2 log: "
echo "Nice is $nc2"
cat test2
echo -n "Real execution time is:  "
cat t2

rm -f test1 test2 t1 t2

exit 0
 
