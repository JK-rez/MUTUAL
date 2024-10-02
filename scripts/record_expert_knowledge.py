#GUI was built with PysimpleuGUI
#git clone free version from forked repo on: https://github.com/JK-rez/PySimpleGUI.git
#Add this to GUI
#===========================Timer and jumphost comm===================================
        if event == "Start":
            recording = True
            start_time = time.time()
            id_ = str(id)
            session_ = str(session)
            #This will call a bash script written for linux based environment
            if platform.system() == "Linux":
                subprocess.Popen(['bash', './recording_script.sh',id_,session_, parent_folder])
            
            subprocess.Popen(['ssh', 'jumphost' ,'touch start.txt'])
        
        if event == "Stop":
            if recording == False:
                continue
            recording = False
            subprocess.Popen(["mkdir","-p", parent_folder + "/StopRecording"])
            subprocess.Popen(['ssh', 'jumphost' ,'touch stop.txt'])
            elapsed_time += time.time() - start_time
            
        if recording:
            time_ = (time.time() - start_time + elapsed_time)/60
            window["Time"].update(str(round(time_,1)))
#===============================================================================