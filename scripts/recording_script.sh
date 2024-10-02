
# start with user's name and folder
#Normally GUI will pass user's name and run number
WHO=$1
RUN=$2
user_name=$WHO

#output_folder="/media/hassna/T7 Shield/Experiments_Pituitary_Phantom/Experiments_13_07_2023/$WHO/$RUN/"
output_folder="folder/$WHO/$RUN/"

echo $output_folder


if [ ! -d "$output_folder" ];then
	mkdir -p "$output_folder"
	echo "$output_folder"
fi

# head input 8 and 9
# overall input camera  6 and 7
# endoscopic view camera 4 and 5



# set file paths for videos and audio

output_video_file_video1="$output_folder""Head_View_Camera_1_"$user_name".avi"

#output_video_file_video2="$output_folder""Overall_View_Camera_2_"$user_name".avi"

#output_video_file_video3="$output_folder""Endoscopic_View_"$user_name".avi"

output_audio_file_surgeon="$output_folder""Audio_Recording_Surgeon_"$user_name".wav"

#output_audio_file_JS_commentary="$output_folder""Audio_Recording_JS_commentary_"$user_name".wav"

output_info_file=$output_folder"Info_"$user_name".txt"



if test -f "$output_video_file_video1"; then
    echo " Attempting to overwrite. Files already exists." && exit 0
fi


# create a txt file that records the starting and end of the recordings

touch "$output_info_file"

date_time_start=$(date)

echo "Starting time : $date_time_start" > "$output_info_file"



#record videos from camera 1 and camera 2

echo "Video" $output_video_file_video1 " starts recording at time: "$(date +"%T.%9N") >> "$output_info_file" & # recoding time with nanoseconds accuracy

ffmpeg -y -loglevel quiet -f v4l2 -framerate 30 -video_size 1920x1080 -c:v mjpeg -input_format yuyv422 -i /dev/video6 -c:v copy "$output_video_file_video1" &


#echo "Video" $output_video_file_video2 " starts recording at time: "$(date +"%T.%9N") >> "$output_info_file" & # recoding time with nanoseconds accuracy

#ffmpeg -y -loglevel quiet -f v4l2 -framerate 30 -video_size 1920x1080 -c:v mjpeg -input_format yuyv422 -i /dev/video8 -c:v copy "$output_video_file_video2" &



#record Audio

echo "Audio "$output_audio_file_surgeon" starts recording at time: "$(date +"%T.%9N") >> "$output_info_file" & # recoding time with nanoseconds accuracy 

ffmpeg -f alsa -i hw:3 "$output_audio_file_surgeon" &

#echo "Audio "$output_audio_file_JH_commentary" starts recording at time: "$(date +"%T.%9N") >> "$output_info_file" & # recoding time with nanoseconds accuracy

#ffmpeg -f alsa -i hw:0 "$output_audio_file_JS_commentary" &



#record camera 3 for the endoscopic view

#echo "Video "$output_video_file_video3" starts recording at time: "$(date +"%T.%9N") >> "$output_info_file" & # recoding time with nanoseconds accuracy

#ffmpeg -y -loglevel quiet -f v4l2 -framerate 30 -video_size 1920x1080 -c:v mjpeg -input_format yuyv422 -i /dev/video6 -c:v copy "$output_video_file_video3" &


# record time of finishing the multimodal recording

while [ ! -d "$parent_folder/StopRecording/" ] ; do
sleep 1
done
rm -r "$parent_folder/StopRecording/"
#Brute force way to stop the recording, recorded files are continuosly updated
pkill ffmpeg
echo "exiting script"

date_time_end=$(date +"%T.%9N")

echo "Finishing time : $date_time_end" >> "$output_info_file"
echo "The Command launched for video is: ffmpeg -y  -f v4l2 -framerate 30 -video_size 1920x1080 -c:v mjpeg -input_format yuyv422 -i output_video_file" >> "$output_info_file"
echo "The Command launched for audio is: ffmpeg -f alsa -i hw:4 output_audio_file" >>  "$output_info_file"