/*
  Raymond Chu, Nick Yeung, Damien McKie, Stanford Mendenhall
  Media in Game Design
  Azuki no Mahou / Magical Beans
  Main File
*/

import ddf.minim.*;

/*===== CONSTANTS =====*/
final static int WIDTH = 1024;
final static int HEIGHT = 576;

Game game;
PImage backg;

final int BG_FLIPPR = 100;
int bg_itr = 0;
int bg_index = 0;

Minim minim;
AudioPlayer bgm;
AudioPlayer othersounds[];

final int NUM_MISCSOUNDS = 1;

boolean init = false;


/*===== FUNCTIONS =====*/
void setup() {
  size(WIDTH, HEIGHT);
  
  minim = new Minim(this);
  
  game = new Game(WIDTH, HEIGHT);
  backg = loadImage(Backgrounds.paths[game.current_chapter][bg_index]);
}

void draw() {  
  image(backg, 0, 0, width, height);
  
  if (!init) {
    initSounds();
    init = true;
  }
  
  if (bgm == null || !bgm.isPlaying()) resetBgm();
  
  if (++bg_itr >= BG_FLIPPR) {
    bg_itr = 0;
    bg_index = (bg_index+1) % Backgrounds.variations[game.current_chapter];
    backg = loadImage(Backgrounds.paths[game.current_chapter][bg_index]);
  }
  
  game.run();
}

void resetBgm() {
  minim.stop();
  if (game.mode == GameMode.BATTLE) {
    bgm = minim.loadFile("assets/sounds/battleMusic2.mp3");
  } else {
    bgm = minim.loadFile("assets/sounds/overworldMusic.mp3");
  }
  bgm.play();
}

void playSound(int i) {
   if (i < 0 || i >= NUM_MISCSOUNDS) return;
   
   othersounds[i].play();
}

void initSounds() {
  othersounds = new AudioPlayer[NUM_MISCSOUNDS];
  othersounds[0] = minim.loadFile("assets/sounds/battle_command.mp3");
}

void keyPressed() {
  char k = key;
  game.receiveKey(k);
}
