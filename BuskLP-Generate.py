#this code unpacks and repacks data from:
#16 bit stereo wav file at 44100hz sampling rate
#to:
##16 bit mono wav file at 44100hz sampling rate

import wave
import math
import struct

bitDepth = 8#target bitDepth
frate = 44100#target frame rate

fileName = "track.wav" #file to be imported (change this)

#fileName = input("FILENAME[path]:")

#read file and get data
w = wave.open(fileName, 'r')
numframes = w.getnframes()

frame = w.readframes(numframes)#w.getnframes()

#frameInt = map(ord, list(frame))#turn into array

#separate left and right channels and merge bytes
frameOneChannel = [0]*numframes#initialize list of one channel of wave
print(len(frame))
for i in range(numframes):
    #frameOneChannel[i] = frameInt[4*i+1]*2**8+frameInt[4*i]#separate channels and store one channel in new list
    print("[" + str(i) + " = " + str(numframes) + "] = [4*i+1=" + str(4*i+1) + " of " + str(len(frame)) + "] + [4*i=" + str(4*i) + "]")
    if((4*i+1) < len(frame)):
        frameOneChannel[i] = frame[4*i+1]*2**8+frame[4*i]#separate channels and store one channel in new list
        print("[" + str(i) + " = " + str(numframes) + "] = [" + str(4*i+1) + "] + [" + str(4*i) + "]")
        if frameOneChannel[i] > 2**15:
            frameOneChannel[i] = (frameOneChannel[i]-2**16)
        elif frameOneChannel[i] == 2**15:
            frameOneChannel[i] = 0
        else:
            frameOneChannel[i] = frameOneChannel[i]

#convert to string
print("converted to string - first loop is done...")
audioStr = ''
#for i in range(numframes):
#    audioStr += str(frameOneChannel[i])
#    audioStr += ","#separate elements with comma
print("awating for writing array byte to txt - 2º loop is starting...")
binary_string = ','.join(str(bit) for bit in frameOneChannel)
print("awating for writing array byte to txt - 2º loop ended...")
fileName = fileName[:-3]#remove .wav extension
text_file = open(fileName+"_output_lp.txt", "w")
print("awating for writing file to " + fileName + "_output_lp.txt ...")
text_file.write(binary_string)
print("file create to " + fileName + "_output_lp.txt ...")
text_file.close()
print("convert is done...")
