//record vector cutting file generator 
//by Amanda Ghassaei
//May 2013
//http://www.instructables.com/id/Laser-Cut-Record/
//detailed instructions for using this code at http://www.instructables.com/id/Laser-Cut-Record/step7

/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
*/

import processing.pdf.*;
import processing.opengl.*;
import unlekker.util.*;
//import unlekker.mb2.util.*;
import unlekker.modelbuilder.*;
import ec.util.*;
import java.util.Scanner;

//parameters
static String filename = "track._output_lp.txt";//generate a txt file of your waveform using python wav to txt, and copy the file name here
float rpm = 45.0;//33.3,45,78
float samplingRate = 44100;//sampling rate of incoming audio
float dpi = 1200;//dpi of cutter
int cutterWidth = 36;//width of laser cutter bed in inches
int cutterHeight = 24;//height of laser cutter bed in inches
float amplitude = 10;//in pixels
float spacing = 10;//space between grooves (in pixels)
float minDist = 6.0;//min pixel spacing between points in vector path (to prevent cutter from stalling)
float thetaIter = 5880;//how many values of theta per cycle
float diameter = 11.8;//diameter of record in inches
float innerHole = 0.286;//diameter of center hole in inches
float innerRad = 2.25;//radius of innermost groove in inches
float outerRad = 5.75;//radius of outermost groove in inches
boolean cutlines = true;//cut the inner and outer perimeters
boolean drawBoundingBox = false;//draw a rect around the whole thing (helps with alignment)
int numGroovesPerFile = 20;//many lasers will choke if you send them all the data at once, this number spits the cutting path into several files taht can be sent to the laser cutter in series, decrease this number to lower the amount of data on each section

// constants
int scaleNum = 72;//scale factor of vectors (default 72 dpi)
float secPerMin = 60;

void settings(){
  
  //set sketch size
  size(cutterWidth*scaleNum,cutterHeight*scaleNum);
  
}

void setup(){
  

  
  //float[] songData = processAudioData();
  System.out.print("FILENAME [path]:");
  Scanner scanner = new Scanner(System.in);
  filename = "/home/ssmool/Músicas/lp @buskplay/track._output_lp.txt";
  thread("proccessAudioData");
  

  
}

//float[] processAudioData(){
void proccessAudioData(){
  //pasted from setup(); code
  //storage variables
  size(cutterWidth*scaleNum,cutterHeight*scaleNum);
  float radCalc;
  float xVal;
  float yVal;
  float theta;//angular variable
  float radius;
  float xValLast = 0.0;
  float yValLast = 0.0;
  float[] songData;
  //scale pixel distances
  amplitude =  amplitude/dpi*scaleNum;
  minDist =  minDist/dpi*scaleNum;
  spacing =  spacing/dpi*scaleNum;
  
  //get data out of txt file
  print(filename);
  String rawData[] = loadStrings(filename);
  String rawDataString = rawData[0];
  float audioData[] = float(split(rawDataString,','));//separated by commas
  print("audioData" + audioData);
  //normalize audio data to given bitdepth
  //first find max val
  float maxval = 0;
  print("NORMALIZE AUDIO DATA");
  for(int i=0;i<audioData.length;i++){
    if (abs(audioData[i])>maxval){
      maxval = abs(audioData[i]);
    }
  }
  print("normalize amplitube to max");
  //normalize amplitude to max val
  for(int i=0;i<audioData.length;i++){
    audioData[i]*=amplitude/maxval;
  }
  
  songData = audioData;
  
  //pasted from setup();
    //change extension of file name
  int dotPos = filename.lastIndexOf(".");
  if (dotPos > 0)
    filename = filename.substring(0, dotPos);
  
  //open pdf file
  int section = 1;
  beginRecord(PDF, filename + "_laser.pdf");//save as PDF
  background(255);//white background
  noFill();//don't fill loops
  strokeWeight(0.001);//hairline width
  
  //init variables
  float incrNum = TWO_PI/thetaIter;//calculcate angular inrementation amount
  float radIncrNum = (2*amplitude+spacing)/thetaIter;//radial incrementation amount
  radius = outerRad*scaleNum;//calculate outermost radius (at 5.75")
  
  stroke(255,0,0);//red
  beginShape();//start vecotr path
  
  //draw silent outer groove
  print("draw silent outer groove");
  for(theta=0;theta<TWO_PI;theta+=incrNum){//for theta between 0 and 2pi
    //calculate new point
    radCalc = radius;
    xVal = 6*scaleNum+radCalc*cos(theta);
    yVal = 6*scaleNum-radCalc*sin(theta);
    if(((xValLast-xVal)*(xValLast-xVal)+(yValLast-yVal)*(yValLast-yVal))>(minDist*minDist)){
      vertex(xVal,yVal);
      //store last coordinates in vector path
      xValLast = xVal;
      yValLast = yVal;
    }
    radius -= radIncrNum;//decreasing radius forms spiral
    print("radius=" + radius);
  }
  
  int numGrooves = 1;
  int index = 0;
  int indexIncr = int((samplingRate*secPerMin/rpm)/thetaIter);
  print("while sote last coords in vector path");
  while(radius>innerRad*scaleNum && index < songData.length-thetaIter*indexIncr){
    for(theta=0;theta<TWO_PI;theta+=incrNum){//for theta between 0 and 2pi
      //calculate new point
      radCalc = radius+songData[index];
      index+=indexIncr;//go to next spot in audio data
      xVal = 6*scaleNum+radCalc*cos(theta);
      yVal = 6*scaleNum-radCalc*sin(theta);
      if(((xValLast-xVal)*(xValLast-xVal)+(yValLast-yVal)*(yValLast-yVal))>(minDist*minDist)){
        vertex(xVal,yVal);
        //store last coordinates in vector path
        xValLast = xVal;
        yValLast = yVal;
      }
      radius -= radIncrNum;//decreasing radius forms spiral
      print("radius[2]:"+radius);
    }
    numGrooves++;
    if (numGrooves%numGroovesPerFile==0){
      //endShape();
      if (drawBoundingBox) rect(0,0,cutterWidth*scaleNum,cutterHeight*scaleNum);
      //endRecord();//LIST<vertex>
      //DRAWN ITS DONE
      String fileNumber = str(numGrooves/numGroovesPerFile);
      //beginRecord(PDF, filename + fileNumber + ".pdf");//save as PDF
      //beginRecord(PDF, filename + "_laser.pdf");//save as PDF
      //noFill();//don't fill loops
      //strokeWeight(0.001);//hairline width
      //stroke(255,0,0);
      //beginShape();
      vertex(xValLast,yValLast);
    }
    println(numGrooves);
  }
  
  //draw silent inner locked groove
  print("draw silent inner locked groove");
  for(theta=0;theta<TWO_PI;theta+=incrNum){//for theta between 0 and 2pi
    //calculate new point
    radCalc = radius;
    xVal = 6*scaleNum+radCalc*cos(theta);
    yVal = 6*scaleNum-radCalc*sin(theta);
    if(((xValLast-xVal)*(xValLast-xVal)+(yValLast-yVal)*(yValLast-yVal))>(minDist*minDist)){
      vertex(xVal,yVal);
      //store last coordinates in vector path
      xValLast = xVal;
      yValLast = yVal;
      print("x="+xVal+"y="+yVal);
    }
    radius -= radIncrNum;//decreasing radius forms spiral
    print("radius[3]="+radius);
  }
  print("store last coordinates in vector path");
  for(theta=0;theta<TWO_PI;theta+=incrNum){//for theta between 0 and 2pi
    //calculate new point
    xVal = 6*scaleNum+radius*cos(theta);
    yVal = 6*scaleNum-radius*sin(theta);
    if(((xValLast-xVal)*(xValLast-xVal)+(yValLast-yVal)*(yValLast-yVal))>(minDist*minDist)){
      vertex(xVal,yVal);
      //store last coordinates in vector path
      xValLast = xVal;
      yValLast = yVal;
      print("x=" + xVal + "y=" + yVal);
    }
  }
  
  endShape();
  
  if (cutlines){
    //draw cut lines (100 units = 1")
    stroke(0);//draw in black
    ellipse(6*scaleNum,6*scaleNum,innerHole*scaleNum,innerHole*scaleNum);//0.286" center hole
    ellipse(6*scaleNum,6*scaleNum,diameter*scaleNum,diameter*scaleNum);//12" diameter outer edge 
  }
  
  endRecord();
  exit();
  
  //tell me when it's over
  println("Finished.");
//  return audioData;
}
