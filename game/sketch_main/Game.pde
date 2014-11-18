/*
    Game class should only handle containing, running, and controlling all the resources,
    as well as any kinds of game fades and between-chapter assets.
    
*/

class Game {
  
  /* MEMBERS */
  Player p;                          // playable character
  GameMode mode;                     // current game mode
  PFont default_font;                // font used in the game
  TextRoll tr;                       // used for rolling text
  TextReader reader;                 // reading text from a text file
  Battle battle;                     // battle interface
  Map current_map;                   // the map of a game
  Transition t;                      // fade in to the chapter
  PImage limbo;                      // to be continued art
  
  /* CONTROL VARIABLES */
  boolean initialize = false;        // starts as false so fades happen before the chapter starts
  float extraFade = 0f;              // pre- and post-battle fades?
  boolean chapter_ending = false;    // post-chapter fade
  int battle_index = -1;             // which character the battle came from
  public int current_chapter = 0;    // current chapter number
  
  /* CONSTANTS */
  final float GAME_SPEED = 0.1f;                         // overall game speed
  final float MOVEMENT_SPEED = 1.6f;                     // movement speed
  final float EXTRA_FADE_LENGTH = GAME_SPEED*700f;       // fade in and out time length (70 frames)
  final int CHAPTERS_IMPLEMENTED = 1;                    // controls whether to play subsequent chapters
  
  
  /*
      INTIALIZE ALL MEMBERS
  */
  Game() {
    p = new Player(this);
    
    mode = GameMode.TRANSITION;
      
    default_font = createFont("assets/fonts/EightBit.ttf", 22);
    textFont(default_font, 22);
    
    tr = new TextRoll(this, width*0.01, height*0.85, width*0.98, height*0.14, width*0.03, height*0.91, width*0.94, height*0.05);
    
    // reader initialized in run function
    
    // battle object initialized in initial control of run function
    
    // map initialized in intialize control of run function
    
    t = new Transition(this);
    
    limbo = loadImage("assets/others/tobecont.jpg");
  }
  
  

  /*
      RUN & DISPLAY LOOP
  */
  void run() {
    // Limbo state for if the chapter is not coded yet
    if (mode == GameMode.LIMBO) {
      image(limbo, 0, 0, width, height);
      handleExtras();
      return;
    }
    
     if (current_chapter > CHAPTERS_IMPLEMENTED) {
      --current_chapter;
      mode = GameMode.LIMBO;
      extraFade = EXTRA_FADE_LENGTH;
      return;
    }
    
    
    // Chapter Transition; the art before the chapter starts
    if (mode == GameMode.TRANSITION) {
      if (DEBUG) println("current chapter: " + current_chapter + "\nTransition mode\n\n");
      t.display();
      if (t.done)  {
        mode = GameMode.STORY;
        initialize = false;
      }
      return; 
    }
    
    
    // Fade ins before the chapter starts
    if (!initialize) {
       current_map = new Map(this, 100, 100, WIDTH/2, HEIGHT/2);
       reader = new TextReader(this, ChapterNpcs.startscenes[current_chapter], tr);
       battle = new Battle(this);
       extraFade = EXTRA_FADE_LENGTH;
       initialize = true;
    }
    
    
    // Story and Explore states
    if (mode != GameMode.BATTLE) {
      current_map.displayMap();
      p.display(WIDTH/2, HEIGHT/2);
      if (mode == GameMode.STORY) tr.display();
      else {
         
      }
      
      handleExtras();
    }
    
    // Battle state
    else {      
      battle.display();
    }
    
  }
  
  void sendSignalMove(int dir) {
    float move_x, move_y;
    
    switch (dir) { // left = 0, right = 1, up = 2, down = 3
      case 0: move_x = MOVEMENT_SPEED*GAME_SPEED; move_y = 0; break;
      case 1: move_x = -MOVEMENT_SPEED*GAME_SPEED; move_y = 0; break;
      case 2: move_x = 0; move_y = MOVEMENT_SPEED*GAME_SPEED; break;
      case 3: move_x = 0; move_y = -MOVEMENT_SPEED*GAME_SPEED; break;
      default: return;
    }
    
    p.move(move_x, move_y);
    current_map.move(move_x, move_y);
  }
  
  
  
  void playerTalk() {
    int index = current_map.character_contact(GAME_SPEED, p.direction);
    if (index < 0 || index >= 20) return;
    
//    reader = new TextReader(this, ChapterNpcs.speechpaths[current_chapter][index], tr);
    if (current_map.isState(GAME_SPEED, p.direction)) {
      reader = new TextReader(this, State.SPEECH_PATHS[current_chapter][current_map.state], tr);
      tr.profileLeft = loadImage(p.SPRITE_PROFILE);
      if (ChapterNpcs.spriteprofiles[current_chapter][index] != "") 
        tr.profileRight = loadImage(ChapterNpcs.spriteprofiles[current_chapter][index]);
      battle_index = index;
      mode = GameMode.STORY;
      reader.sendNextLine();
      ++current_map.state;
    }
  }
  
  void finishBattle() {
    extraFade = EXTRA_FADE_LENGTH;
    
    if (battle_index >= 0) {
      if (ChapterNpcs.afterbattlepaths[current_chapter][battle_index] != "") {
        reader = new TextReader(this, ChapterNpcs.afterbattlepaths[current_chapter][battle_index], tr);
        battle_index = -1;
        mode = GameMode.STORY;
      }
      else {
        mode = GameMode.EXPLORE;
        resetBgm();
      }
    }
    else mode = GameMode.EXPLORE;
    resetBgm();
  }
  
  void handleExtras() {
    /*
        CHAPTER ENDING FADES AND CODE
    */
    if (extraFade > 0) {
      float fade = extraFade * 255 / EXTRA_FADE_LENGTH;
      if (chapter_ending) fade = 255 - fade;
      fill(20, fade);
      rect(0, 0, WIDTH, HEIGHT);
      if (--extraFade <= 0) {
        reader.sendNextLine();
        if (chapter_ending) {
          chapter_ending = false;
          ++current_chapter;
          t = new Transition(this);
          mode = GameMode.TRANSITION;
        }
      }
      return;
    }
  }
  
  void extraOff() {
    mode = GameMode.EXPLORE;
    battle_index = -1;
  }
  
  void extraFight() {
    mode = GameMode.BATTLE;
    resetBgm();
  }
  
  void extraEmoticon(String command) {
    if (command.equals("surprised")) {
      p.setEmote(1, false);
    } else if (command.equals("question")) {
      p.setEmote(2, false);
    } else if (command.equals("ellipses")) {
      p.setEmote(3, true);
    }
  }
  
  void DEBUGnextChapter() {
    if (current_chapter >= CHAPTERS_IMPLEMENTED) return;
    chapter_ending = false;
    ++current_chapter;
    t = new Transition(this);
    mode = GameMode.TRANSITION;
  }
}
