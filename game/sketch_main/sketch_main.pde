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

TitleScreen title;

Minim minim;
AudioPlayer bgm;
AudioPlayer othersound;

final int NUM_MISCSOUNDS = 1;

boolean init = false;

boolean starting_state = true;


/*===== FUNCTIONS =====*/
void setup() {
  size(WIDTH, HEIGHT);
  
  minim = new Minim(this);
  othersound = minim.loadFile("assets/sounds/battle_command_2.mp3");
  
  title = new TitleScreen("assets/titlescreen/menuscreen_01.jpg", "assets/titlescreen/logo.png");
  
  game = new Game(WIDTH, HEIGHT);
  backg = loadImage(Backgrounds.paths[game.current_chapter][bg_index]);
}

void draw() {
  if (starting_state) {
    title.run();
    return;
  }
  
  image(backg, 0, 0, width, height);
  
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
    bgm = minim.loadFile("assets/sounds/battle_music.mp3");
  } else {
    bgm = minim.loadFile("assets/sounds/overworld.mp3");
  }
  bgm.play();
}

void playSound(int i) {
   if (i < 0 || i >= NUM_MISCSOUNDS) return;
   
   if (i == 0) {
     othersound = minim.loadFile("assets/sounds/battle_command_2.mp3");
     othersound.play();
   }
}


void keyPressed() {
  char k = key;
  game.receiveKey(k);
  
  if (starting_state && title.ready && key == ' ') {
    starting_state = false;
  }
  
  if (k == '4')  {
    playSound(0);
    return;
  }
}
