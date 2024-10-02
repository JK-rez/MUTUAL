#!/bin/bash 



#The following script is a high level overview of how to implement in syncorhous mnner multiomdal sensing



#First, make sure you can communicate with a jumphost server thorugh .config file in your .ssh folder
#This step allows communication with the clincial gui to start the recording 
while true; do
	sleep 1
        if ssh jumphost_server "test -e participant.txt";then
                echo "Clinician has done his job"
		break
        fi
done

#Print participant name and infomration
WHO=$(ssh bouncer "cat participant.txt")
echo $WHO

#Clean up jumperhost
ssh bouncer "rm participant.txt"

#Comment above lines and uncomment below lines if you want to manually enter the participant name
#======================Local Setup=====================
#read -p "Name of run: " answer                                                                      
#WHO=$answer                                                                                         
#=====================================================

#Specify the directory to store the data
folder="specify your directory here"
echo "Directory to store data will be" $folder/$WHO
if [ -d $folder/$WHO ]
then
	read -p "Direcotry exists do you want to overwrite (y/n)? " answer
	case $answer in
		y|Y)
			#if directory exists you will overwrite the data, be careful
			echo overwritting...;
			;;
		n|N )
			echo exiting...;
			exit
			;;
	esac
else
	mkdir $folder/$WHO
fi

#Give sudo write permission, this is required if sensors used are connected through ethernet
sudo -v
echo "I am user "$(id -u)""
echo "Root rights have been given"

#Check if start and stop condtion exist and if so remove them
if [-e start.txt];then
	rm start.txt
fi
if [-e stop.txt];then 
	rm stop.txt
fi

#Laubch the diffrent sdk's scripts relating to your sensors and store the process id to monitor them
python3 sensor1.py -f $folder/$WHO/$WHO.sensor_file_extension -c $folder/$WHO/sensor1.txt -s stop.txt -i start.txt >> $fodler/$WHO/logs1.txt &
python_pid_sensor1=$!
python3 sensor2.py -f $folder/$WHO/$WHO.sensor_file_extension -c $folder/$WHO/sensor2.txt -s stop.txt -i start.txt >> $fodler/$WHO/logs2.txt &
python_pid_sensor1=$!
python3 sensor3.py -f $folder/$WHO/$WHO.sensor_file_extension -c $folder/$WHO/sensor3.txt -s stop.txt -i start.txt >> $fodler/$WHO/logs3.txt &
python_pid_sensor1=$!
/usr/local/bin/sensor4 -f $folder/$WHO/$WHO.sensor_file_extension -c $folder/$WHO/sensor4.txt -s stop.txt -i start.txt >> $fodler/$WHO/logs4.txt &
c_pid_sensor4=$!

echo "Pyhton PID for body sensor1 $python_pid_sensor1"
echo "Pyhton PID for body sensor2 $python_pid_sensor2"
echo "Pyhton PID for body sensor3 $python_pid_sensor3"
echo "C++ PID for body sensor4 $c_pid_sensor4"
sleep 1

#The following lines of code check the initalisation status of the sensors and if they fail, the script will terminate them
#This is usefull for misconnected usb or ethernet sensors
while true; do 
	if ps -p $python_pid_sensor1 > /dev/null; then
		sleep 1
	else
		kill -9 $python_pid_sensor2 
		sudo kill -9 $pyhton_pid_sensor3 
		kill -9 $c_pid_sensor4
		echo "Error Sensor1 Failed"
		exit
	fi
	if ps -p $python_pid_sensor2 > /dev/null;then
		sleep 1
	else 
		kill -9 $python_pid_sensor1 
		sudo kill -9 $python_pid_sensor3 
		kill -9 $c_pid_sensor4
		echo "Error Sensor2 Failed"
		exit
	fi
	if ps -p $python_pid_sensor3 > /dev/null;then
                sleep 1
        else
                kill -9 $python_pid_sensor1
                kill -9 $python_pid_sensor2
		        kill -9 $c_pid_sensor4
                echo "Error Sensor3 Failed"
                exit
        fi
	if ps -p $c_pid_sensor4 > /dev/null;then
                sleep 1
        else
                kill -9 $python_pid_sensor1
                kill -9 $python_pid_sensor2
                sudo kill -9 $python_pid_sensor3
                echo "Error Sensor4 Failed"
                exit
        fi
    #After all snesors have been initialized, their respective scripts should genrate a text file
    #This allows this bash script to know when all sensors have been initialized
	if test -f "sensor1.txt" && test -f "sensor2.txt" && 
		test -f "sensor3.txt" && test -f "sensor4.txt"; then
		echo "All modalities have been initialized!!!"
		#touch start.txt
		break
	fi
done
sleep 2

#========================Local Setp=======================
#read -p "To start recording press enter" answer
#touch start.txt
#echo "Recording has started"
#while true;do 
#read -p "Stop Recording (y/n)? " answer
#        case $answer in
#                y|Y)
#                        touch stop.txt;
#			break
#                        ;;
#                n|N )
#                        echo Continuing recording...;
#                        ;;
#        esac
#done
# rm start.txt
# rm "imu.txt"
# rm "bodytracking.txt"
# sudo rm "ati.txt"
# rm "stereo.txt"
#=========================================================

#=======================Remote Setup=======================
echo "Waiting for remote input to start"
while true; do 
	sleep 1
	if ssh bouncer "test -e start.txt";then
		echo "Recording has started"
		touch start.txt
		break
	fi
done

while true; do 
	sleep 1
    #Can add here error monitoring for sensors
    #Please look at error catching bash script for further detail
	if ssh bouncer "test -e stop.txt";then
		touch stop.txt
		rm start.txt
		rm "imu.txt"
		rm "bodytracking.txt"
		sudo rm "ati.txt"
		rm "stereo.txt"
		ssh bouncer "rm start.txt"
		break
	fi
done
sleep 2
ssh bouncer "rm stop.txt"
#=========================================================


echo "Finished"
rm stop.txt