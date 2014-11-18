/*
    Raymond Chu, Nick Yeung, Damien McKie, Stanford Mendenhall
    Media in Game Design
    Azuki no Mahou / Magical Beans
    Main File
*/

/*
    The Main file should initialize as few things as possible,
    and it should also control the sound and keyboard input interfaces.
*/

import ddf.minim.*;
import java.util.Random;

/* MEMBERS */
Game game;                                   // the game itself
TitleScreen title;                           // the titlescreen
GameOver gameover;                           // game over screen
Minim minim;                                 // audio player object
AudioPlayer bgm;                             // background music
AudioPlayer othersound;                      // miscellaneous sounds

/* CONTROL VARIABLES */
boolean starting_state = true;               // title screen state
boolean gameover_state = false;              // game over state
boolean lastkey_pressed = false;             // whether a button was pressed at the previous loop iteration
char lastkey = '`';                          // the last key that was pressed

/* CONSTANTS */
final static int WIDTH = 1024;               // game screen width & height
final static int HEIGHT = 576;
final boolean DEBUG = false;                 // display debug text
final int NUM_MISCSOUNDS = 1;                // number of miscellaneous sounds
final char BUTTON_UP = UP;                   // directional controls for when coded controls are used
final char BUTTON_DOWN = DOWN;
final char BUTTON_LEFT = LEFT;
final char BUTTON_RIGHT = RIGHT;
final char U_BUTTON_UP = 'w';                // directional controls for when coded controls aren't used
final char U_BUTTON_DOWN = 's';
final char U_BUTTON_LEFT = 'a';
final char U_BUTTON_RIGHT = 'd';
final boolean USE_CODED_CONTROLS = true;     // to use coded controls or not
final char BUTTON_A = ' ';                   // affirmative button
static final int CHAPTERS_IMPLEMENTED = 2;   // controls whether to play subsequent chapters



/*
    INTIALIZE ALL MEMBERS
*/
void setup() {
  size(WIDTH, HEIGHT);
  
  // control variables reinitialized for when game is repeated
  starting_state = true;
  gameover_state = false;
  lastkey_pressed = false;
  lastkey = '`';
  
  game = new Game();

  title = new TitleScreen("assets/titlescreen/menuscreen_01.jpg", "assets/titlescreen/logo.png");
  gameover = new GameOver();

  minim = new Minim(this);
  resetBgm();
  
  othersound = minim.loadFile("assets/sounds/battle_command_2.mp3");
}


/*
    RUN & DISPLAY LOOP
*/
void draw() {
  handleKeys();
  
  if (starting_state) {
    title.run();
    return;
  }
  
  if (gameover_state) {
    gameover.display();
    return;
  }
  
  background(0);

  if (bgm == null || !bgm.isPlaying()) resetBgm();
  
  game.run();
}


/*
    PROCESS KEYBOARD INPUTS AND SEND THEM TO APPROPRIATE METHODS
*/
void handleKeys() {
  
  if (keyPressed) {
    
    if (game == null) return;
    
    if (starting_state && title.ready && key == ' ') {
      starting_state = false;
      return;
    }
    
    if (gameover_state && key == ' ') {
      setup();
    }
    
    if (key == '1' && game.current_chapter != 1 && game.mode != GameMode.TRANSITION && game.mode != GameMode.LIMBO) game.DEBUGnextChapter(1);
    if (key == '2' && game.current_chapter != 2 && game.mode != GameMode.TRANSITION && game.mode != GameMode.LIMBO) game.DEBUGnextChapter(2);
    
    if (game.mode == GameMode.EXPLORE) {
      if (key == ' ') game.playerTalk();
      
      else if (USE_CODED_CONTROLS) {
        if (key == CODED) {
          if (keyCode == BUTTON_UP) {
            game.sendSignalMove(2);
          } else if (keyCode == BUTTON_DOWN) {
            game.sendSignalMove(3);
          } else if (keyCode == BUTTON_LEFT) {
            game.sendSignalMove(0);
          } else if (keyCode == BUTTON_RIGHT) {
            game.sendSignalMove(1);
          }
        }
      }
      
      else {
        if (key == U_BUTTON_UP) {
          game.sendSignalMove(2);
        } else if (key == U_BUTTON_DOWN) {
          game.sendSignalMove(3);
        } else if (key == U_BUTTON_LEFT) {
          game.sendSignalMove(0);
        } else if (key == U_BUTTON_RIGHT) {
          game.sendSignalMove(1);
        }
      }
    }
    
    else if (game.mode == GameMode.STORY) {
      if (key == ' ') {
        if (game.reader == null) return;
        if (DEBUG) game.reader.sendNextLine();
        if (!lastkey_pressed) game.reader.sendNextLine();
        else if (lastkey != key) game.reader.sendNextLine();
      }
    }
    
    else if (game.mode == GameMode.BATTLE) { // 0123 for direction, 4 for space
      if (!DEBUG && lastkey_pressed && lastkey == key) return;
    
      if (key == ' ') game.battle.battle_prompt.handleControls(4);
      
      else if (USE_CODED_CONTROLS) {
        if (key == CODED) {
          if (keyCode == BUTTON_UP) {
            game.battle.battle_prompt.handleControls(2);
          } else if (keyCode == BUTTON_DOWN) {
            game.battle.battle_prompt.handleControls(3);
          } else if (keyCode == BUTTON_LEFT) {
            game.battle.battle_prompt.handleControls(0);
          } else if (keyCode == BUTTON_RIGHT) {
            game.battle.battle_prompt.handleControls(1);
          }
        }
      }
      
      else {
        if (key == U_BUTTON_UP) {
          game.battle.battle_prompt.handleControls(2);
        } else if (key == U_BUTTON_DOWN) {
          game.battle.battle_prompt.handleControls(3);
        } else if (key == U_BUTTON_LEFT) {
          game.battle.battle_prompt.handleControls(0);
        } else if (key == U_BUTTON_RIGHT) {
          game.battle.battle_prompt.handleControls(1);
        }
      }
    }
    
    lastkey_pressed = true;
    lastkey = key;
    
  } else {
    lastkey_pressed = false;
  }
}

void resetBgm() {
  minim.stop();
  if (bgm != null) {bgm.close(); bgm = null;}
  if (starting_state) {
    return;
  } else if (game.mode == GameMode.BATTLE) {
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

