#Python backend highlevel implemetnation specifics for most SDKs
import os
import argparse

#import SDK libraries 



def main():
    # argument parsing
    parser = OptionParser()
    parser.add_option("-f", dest="filename", help="file path where video will be saved in .svo format", default= None, metavar="FILENAME")
    parser.add_option("-c", dest="filenamecoord", help= "filepath where coord data will be saved in .txt format", default= None, metavar="COORDINATE")
    parser.add_option("-s", dest="stop", help="absolute path of file that will be used to stop this script", default= None, metavar="STOP")
    parser.add_option("-i", dest="start", help="absolute path of file that will be used to start this script", default= None, metavar="START")
    (options, args) = parser.parse_args()
    
    if not options.filename.endswith(".svo"):
        raise TypeError("Wrong video output format, should be in .svo")

    if not options.filenamecoord.endswith(".txt"):
        raise TypeError("Wrong coord file extension should be in .txt")

    if options.start is None:
        raise ValueError("No start file specified")

    if options.stop is None:
        raise ValueError("No stop file specified")

    
    #=============Connect and initialize SDK================
    #
    #
    #=============Generate file to be read by bash script===

        print("Sensor python file intialized \n")
        
        #Creating file to be read by bash script
        new_file = open("sensor.txt", "w")
        new_file.close()
        #Endless loop to wait for other sensors
        while not os.path.exists(options.start):
            pass
    #=============Start recording===========================
        print("Recording")
        while not os.path.exists(options.stop):
            #record data
            pass