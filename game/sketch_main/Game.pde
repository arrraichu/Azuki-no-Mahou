class Game {
  final boolean DEBUG = true;
  
  int game_width;
  int game_height;
  
  Player p;
  GameMode mode;
  
  PFont default_font;
  TextRoll tr;
  BattleText battle_text;
  BattlePrompt battle_prompt;
  
  
  TextReader reader;
  
  PImage tiles[] = new PImage[Tiles.NUM_TILES+1];
  
  final int TOTAL_CHAPTERS = 0;
  public int current_chapter;
  
  Map current_map;
  
  boolean initialize;
  
  final float GAME_SPEED = 0.1f;
  final float MOVEMENT_SPEED = 1.6f;
  
  final float EXTRA_FADE_LENGTH = GAME_SPEED*700f; // 70 frames
  float extraFade = 0f;
  boolean chapter_ending = false;
  final float EXTRA_SURPRISE_LENGTH = GAME_SPEED*50f;
  float extraSurprise = 0f;
  final int EMOTE_LENGTH = 51;
  int emote_time = -1;
  boolean isEllipse = false;
  PImage emote;
  
  PlayerStats pstats;
  
  int battle_index;
  
  PImage limbo;
  
  final String TALK_PATH[] = {
    "assets/sprites/talkA01.png",
    "assets/sprites/talkA02.png" };
  PImage talk_notices[];
  final int TALK_FLICKR = 40;
  int talk_counter;
  int talk_index;
  
  Transition t;
  
  final int CHAPTERS_IMPLEMENTED = 1;
  
  
  /*
      INTIALIZE ALL ASSETS
  */
  Game(int w, int h) {
    game_width = w; game_height = h;
    mode = GameMode.TRANSITION;
    p = new Player();
      
    default_font = createFont("assets/fonts/EightBit.ttf", 22);
    textFont(default_font, 22);
    
    tr = new TextRoll(this, width*0.01, height*0.85, width*0.98, height*0.14);
    tr.setTextStart(width*0.03, height*0.91);
    tr.setNewlinePlacement(width*0.94, height*0.05);
    
    battle_text = new BattleText(this, width*0.01, height*0.6, width*0.23, height*0.39);
    battle_text.setTextStart(width*0.03, height*0.66);
    battle_text.setNewlinePlacement(18, height*0.04);
    battle_prompt = new BattlePrompt(this, width*0.76, height*0.6, width*0.23, height*0.39);
    battle_prompt.setTextStart(width*0.78, height*0.66);
    battle_prompt.setNewlinePlacement(18, height*0.065);
    
//    reader = new TextReader(this, ChapterNpcs.startscenes[current_chapter], tr);
    for (int i = 0; i <= Tiles.NUM_TILES; ++i) {
      if (i == 0) tiles[0] = null;
      else tiles[i] = loadImage(Tiles.paths[i]);
    }
    
    current_chapter = 0;
    
    initialize = false;
    
    pstats = new PlayerStats(this, "assets/sprites/player/right0.png", 10, 4, 2, 2, 2);
    
    battle_index = -1;
    
    limbo = loadImage("assets/others/tobecont.jpg");
    
    talk_notices = new PImage[2];
    talk_notices[0] = loadImage(TALK_PATH[0]);
    talk_notices[1] = loadImage(TALK_PATH[1]);
    talk_index = 0;
    talk_counter = TALK_FLICKR;
    
    t = new Transition(this);
  }
  
  

  /*
      RUN & DISPLAY LOOP
  */
  void run() {
    
    // Chapter Transition
    if (mode == GameMode.TRANSITION) {
      println("current chapter: " + current_chapter + "\nTransition mode\n\n");
      t.display();
      if (t.done)  {
        mode = GameMode.STORY;
        initialize = false;
      }
      return; 
    }
    
    // Fade ins before the chapter starts
    if (!initialize) {
       current_map = new Map(this, 100, 100, MapDefaults.mapfiles[current_chapter], game_width/2, game_height/2);
       reader = new TextReader(this, ChapterNpcs.startscenes[current_chapter], tr);
       extraFade = EXTRA_FADE_LENGTH;
       initialize = true;
    }
    
    
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
    }
    
    
    // Battle state
    if (mode != GameMode.BATTLE) {
      displayMap();
      p.display(game_width/2, game_height/2);
      if (mode == GameMode.STORY) tr.display();
      reader.run();
      
      flickerTalk();
      handleExtras();
    }
    
    // Story and Explore state
    else {      
      battle_text.display();
      battle_prompt.display();
    }
    
  }
  
  
  
  /*
      HANDLE KEY PRESSES (TO BE DEPRECATED)
  */
  void receiveKey(char k) {
    if (!initialize || extraFade > 0) return;
    
    // DEBUG MODE
    if (DEBUG) {
      if (k == '`') {
        if (mode == GameMode.STORY) {
          println("Story Mode\n");
        } else if (mode == GameMode.EXPLORE) {
          println("Explore Mode\n");
        } else if (mode == GameMode.BATTLE) {
          println("Battle Mode\n");
        } else if (mode == GameMode.TRANSITION) {
          println("Transition Mode\n");
        } else {
          println("unknown mode\n");
        }
      }
      
    }
    
    // STORY MODE
    if (mode == GameMode.STORY) {
      if (k == ' ') {
        reader.sendNextLine();
        return;
      }
      return;
    }
    
    // EXPLORE MODE
    if (mode == GameMode.EXPLORE) {
      if (k == ' ') {
        playerTalk();
      }
      
      else if (k == 'w') { // up
        p.move(0, MOVEMENT_SPEED*GAME_SPEED);
        current_map.move(0, MOVEMENT_SPEED*GAME_SPEED);
      } else if (k == 's') { // down
        p.move(0, -MOVEMENT_SPEED*GAME_SPEED);
        current_map.move(0, -MOVEMENT_SPEED*GAME_SPEED);
      } else if (k == 'a') { // left
        p.move(MOVEMENT_SPEED*GAME_SPEED, 0);
        current_map.move(MOVEMENT_SPEED*GAME_SPEED, 0);
      } else if (k == 'd') { // right
        p.move(-MOVEMENT_SPEED*GAME_SPEED, 0);
        current_map.move(-MOVEMENT_SPEED*GAME_SPEED, 0);
      }
      return;
    }
    
    if (mode == GameMode.BATTLE) {
      battle_prompt.receiveKeys(k);
      return;
    }
  }
  
  
  
  /*
      PROCESS RESOURCES FROM TEXTROLL AND DISPLAY THE MAP
      (PERHAPS PUT THIS IN TEXTROLL CLASS?)
  */
  void displayMap() {
    for (int i = 0; i < current_map.rows; ++i) {
      for (int j = 0; j < current_map.columns; ++j) {
        int x = current_map.center_x + j*50 - current_map.starting_x;
        int y = current_map.center_y + i*50 - current_map.starting_y;
       
        if (!tileWithinBounds(x, y)) continue;
        
        char c = current_map.map[i][j];
        int c_index = (int) c - '0';
        
        if (c_index <= 0) continue;
        if (c_index >= 50 && current_map.extras[c_index-50] != null) { // characters
          image(tiles[ChapterNpcs.spritebottoms[current_chapter][c_index-50]], x, y, 50, 50); // standing on
          image(current_map.extras[c_index-50], x, y, 50, 50); // the character
          image(talk_notices[talk_index], x+40, y-30, 40, 40); // talkable
          continue;
        }
        if (c_index > Tiles.NUM_TILES) continue;
        image(tiles[c_index], x, y, 50, 50);
      }
    }
  }
  
  boolean tileWithinBounds(int x, int y) {
    if (x > game_width || y > game_height) return false;
    if (x+50 < 0 || y+50 < 0) return false;
    return true;
  }
  
  
  
  void playerTalk() {
    float x = GAME_SPEED; float y = GAME_SPEED;
    if (p.direction > 1) x *= 0;
    else y *= 0;
    if (p.direction == 0) x *= -1;
    if (p.direction == 3) y *= -1;
    
    int index = current_map.contact(x,y) - '0' - 50;
    if (index < 0 || index >= 20) return;
    
    reader = new TextReader(this, ChapterNpcs.speechpaths[current_chapter][index], tr);
    tr.profileLeft = loadImage(PlayerSprites.profile);
    if (ChapterNpcs.spriteprofiles[current_chapter][index] != "") 
      tr.profileRight = loadImage(ChapterNpcs.spriteprofiles[current_chapter][index]);
    battle_index = index;
    mode = GameMode.STORY;
    reader.sendNextLine();
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
  
  private void flickerTalk() {
    if (--talk_counter <= 0) {
      talk_counter = TALK_FLICKR;
      talk_index = 1 - talk_index;
    }
  }
  
  void handleExtras() {
    if (extraFade > 0) {
      float fade = extraFade * 255 / EXTRA_FADE_LENGTH;
      if (chapter_ending) fade = 255 - fade;
      fill(20, fade);
      rect(0, 0, game_width, game_height);
      if (--extraFade <= 0) {
        reader.sendNextLine();
        if (chapter_ending) {
          chapter_ending = false;
          ++current_chapter;
          mode = GameMode.TRANSITION;
        }
      }
      return;
    }
    
    if (extraSurprise > 0) {
      p.move(-0.01f, 0);
      current_map.move(GAME_SPEED*10f, 0);
      extraSurprise -= GAME_SPEED*10f;
      return;
    }
    
    if (emote_time >= 0) {
      if (isEllipse && emote_time == 2*EMOTE_LENGTH/3) emote = loadImage("assets/sprites/ellip02.png");
      else if (isEllipse && emote_time == EMOTE_LENGTH/3) emote = loadImage("assets/sprites/ellip03.png");
      
      image(emote, width/2 + 40, height/2 - 15);
      --emote_time;
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
  
  void extraPlayerSurprised() {
    emote = loadImage("assets/sprites/excl.png");
    emote_time = EMOTE_LENGTH;
    isEllipse = false;
  }
  
  void extraPlayerQuestion() {
    emote = loadImage("assets/sprites/question.png");
    emote_time = EMOTE_LENGTH;
    isEllipse = false;
  }
  
  void extraPlayerEllipses() {
    emote = loadImage("assets/sprites/ellip01.png");
    emote_time = EMOTE_LENGTH;
    isEllipse = true;
  }
}
