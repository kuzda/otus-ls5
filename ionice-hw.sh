#! /bin/bash
if [[ $1 == -h ]] #Обрабатываем ключ -h с инфой о запуске
then
	echo "Follow insructions after start this script."
	echo "If you want use Real-time class, you must start this script by root."
	exit 1
fi

for i in 1 2 #запускаем цикл для опроса параметров процессов для сравнения
do
	n=1 #Переменна, с помощью которой управляем циклом
	while [[ $n -eq 1 ]]
	do
		read -p "Please enter class for process $i (1-3)  " class #Тут спрашиваем приоритет для первог процесса, повторяем пока
		if [[ $class -lt 1 || $class -gt 3 ]]					  #не будет введена цифра в интервале [1..3]
		then
			echo "Please insert valid class. Try again"
		else
			n=2
		fi	
	done
	
	case $class in #Обрабатываем возможные значения классов.
		1)
			while [[ $n -eq 2 ]]
			do
				read -p "Please enter priority for process $i (0-7)  " prio #То же самое для приоритета - считываем ввод
				if [[ $prio -lt 0 || $prio -gt 7 ]]
				then 
					echo echo "Please insert valid priority. Try again"
				else
					n=3
				fi	
			done
		;;

		2)
			while [[ $n -eq 2 ]]
			do
				read -p "Please enter priority for process $i (0-7)  " prio
				if [[ $prio -lt 0 || $prio -gt 7 ]]
				then 
					echo echo "Please insert valid priority. Try again"
				else
					n=3	
				fi	
			done
		;;

		3)
			echo "There	are no priority for this class" #Для класса Idle нет приоритетов, поэтому назначаем 0 просто так
			prio=0
		;;
	esac
	if [[ i -eq 1 ]] #Теперь вводим переменные, которые будут соответствовать каждому процессу.
	then
		class1=$class
		prio1=$prio
	else
		class2=$class
		prio2=$prio
	fi	
done

#Теперь запускаем наши процессы с переданными параметрами, вывод будет содержать время выполнения операции
#количество записанных байт и среднюю скорость записи.
echo "Testing first process. Please. waiting..."
echo "Testing second process. Please. waiting..."
echo "Now you can see top and ionice to chek out this processes."

if [[ $class1 -eq 3 ]]
then
	ionice -c$class1 dd if=/dev/zero of=test1 bs=4k count=250k oflag=direct 2>t1 &
else
	ionice -c$class1 -n$prio1 dd if=/dev/zero of=test1 bs=4k count=250k oflag=direct 2>t1 &
fi

if [[ $class2 -eq 3 ]]
then
	ionice -c$class2 dd if=/dev/zero of=test2 bs=4k count=250k oflag=direct 2>t2 &
else
	ionice -c$class2 -n$prio2 dd if=/dev/zero of=test2 bs=4k count=250k oflag=direct 2>t2 &
fi

wait
#Выводим на экран результаты работы процессов
echo "Process 1 log:"
cat t1
echo "Process 2 log:"
cat t2
rm -f test1 test2 t1 t2 #Убираем за собой 
exit 0