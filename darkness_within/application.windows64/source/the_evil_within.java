import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class the_evil_within extends PApplet {

PFont overall, deadmessage;
PImage wallpaper, dialogue, discovered, selections, tiz;
 
String userInput = "", pass = "word"; String transition = "";
boolean matched = false; boolean gameover = false; boolean gamestart = false;
boolean picked = false;

int tries = 0; int fps = 0; int dps = 0; int timer = 0; int currentR = 0;
int count = 0; int choose = 0; int tizX = -100;
String[] story;
 
public void setup()
{
  size(1024, 764);
  wallpaper = loadImage("darkforest.jpg");
  dialogue = loadImage("dialogue.png");
  discovered = loadImage("darkforest2.jpg");
  selections = loadImage("selection.png");
  tiz = loadImage("Tiz.png");
  deadmessage = loadFont("Bloody-60.vlw");
  overall = loadFont("Aileron-Thin-20.vlw");
  textFont(overall, 20);
}
 
public void draw()
{
  background(0); 
  welcomeScreen();
  if(keyPressed){
    if(key == BACKSPACE && userInput.length() > 0){
        userInput = userInput.substring (0, max(0,userInput.length()-1));
    }
  }
  if (gamestart) {
    gameStart();
  }
}
 
public void keyPressed()
{
/* you do not need to say key.toString() in the processing application. You can just say:
    userInput += key;
  However, when uploading to openprocessing, you will need to use toString()
    */
  if (key != CODED){
//    userInput += key.toString();
    if(userInput.length() < 10){
        userInput += key;
    }
  }
  if(userInput.equalsIgnoreCase(pass))
    matched = true;
  if(key == ENTER ){
    userInput = userInput.substring (0, max(0,userInput.length()-userInput.length()));
    fill(255);
    text("Invalid name.",width/2,height-100);
    tries+=1;
    println(tries);
  }
}

public void welcomeScreen(){
  if(keyPressed & key == 'z') gamestart = true;
  else
  textAlign(CENTER);
  fill(255);
  text("Choose Your Name:", width/2, (height/2)-100);
  text("Samuel", width/2, (height/2)-60);
  text("Anison", width/2, (height/2)-30);
  text("Type Your Own Name:", width/2, height/2);
  rectMode(CENTER);
  rect(width/2,(height/2)+25,120,30);
  fill(0);
  text(userInput,width/2,(height/2)+35);
  if (tries == 2) {
    background(0);
    gameover = true;
    gameOverAlt();
  }
}

public void gameStart(){
  startTime();
  tizX+=10;
  if (tizX >= 100) tizX = 100;
  image(wallpaper,0,0);
  image(tiz,tizX,150);
  image(dialogue,0,0);
  String[] story = loadStrings("story.txt");
  int target = 0;
  for (int i = 0; i < story.length; i++){
      if(timer < 3){
        if(currentR == i){
          if (currentR < 6){
            fill(255);
            text(story[currentR],width/2,(height/2)+200);
            println(story[i]);
            println(currentR);
          }
          else if (currentR >= 6 && currentR < 11){
            seq(story);
          }
          else if (currentR >= 11){
            advSeq(story);
          }
          println(story[currentR]);
        }
      }else{
        currentR+=1;
        timer=0;
        println(currentR);
      }
  }
}

public void seq(String[] story){
  background(0);
  image(dialogue,0,0);
  fill(255);
  text(story[currentR],width/2,(height/2)+200);
}

public void advSeq(String[] story){
  image(discovered,0,0);
  image(tiz,tizX,150);
  image(dialogue,0,0);
  fill(255);
  text(story[currentR],width/2,(height/2)+200);
  if (currentR >= 14){
    resetTime();
    if(picked == false){
      image(selections,0,0);
      count++;
      println(choose);
      fill(0);
      text("Move closer and take a look",(width/2)+300,(height/2)-75);
      text("Do nothing",(width/2)+300,(height/2));
      if (count == 60){
        choose +=1;
        count = 0;
      }
      if (keyPressed && (key == 'Z' || key == 'z')) {
        picked = true;
        currentR+=1;
        startTime();
      }
      else if(key == 'X' || key == 'x'){
        background(0);
        fill(255);
        text("Samuel decides to do nothing. Suddenly, dark overwhelms you with a familiar face.",width/2,height/2);
        startTime();
        if (timer >= 2)
        gameOverAlt();
      }
      if (choose >= 5 && choose < 11){
          resetTime();
          gameOverAlt();
        }
      else if(choose >= 11) exit();
    }
    else{
      startTime();
        println(currentR);
    }
  }
}

public void startTime(){
  fps++;
  if (fps == 60){
    timer+=1;
    fps=0;
    if (timer < 4){
      
    }
    else{
      currentR+=1;
        timer=0;
        println(currentR);
    }
  }
}

public void resetTime(){
  fps = 0;
  timer = 0;
}

public void gameOverAlt(){
  background(0);
  dps++;
  println(dps);
  if (dps == 60) {
    timer+=1;
    dps=0;
  }
  if(timer >= 5) exit();
  fill(255,0,0);
  textFont(deadmessage,60);
  text("HA HA HA HA\nYOU'RE ALREADY TOO LATE!",width/2,height/2);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "the_evil_within" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
