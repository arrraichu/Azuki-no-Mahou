class Game {
  final boolean DEBUG = true;
  
  int game_width;
  int game_height;
  
  Player p;
  GameMode mode;
  
  PFont default_font;
  TextRoll tr;
  BattleText battle_prompt;
  
  
  TextReader reader;
  
  PImage tiles[] = new PImage[Tiles.NUM_TILES+1];
  
  final int TOTAL_CHAPTERS = 0;
  public int current_chapter;
  
  Map current_map;
  
  boolean initialize;
  
  final float GAME_SPEED = 0.1f;
  
  final float EXTRA_FADE_LENGTH = GAME_SPEED*700f; // 70 frames
  float extraFade = 0f;
  final float EXTRA_SURPRISE_LENGTH = GAME_SPEED*50f;
  float extraSurprise = 0f;
    
  Game(int w, int h) {
    game_width = w; game_height = h;
    mode = GameMode.STORY;
    p = new Player();
      
    default_font = createFont("assets/fonts/EightBit.ttf", 22);
    textFont(default_font, 22);
    
    tr = new TextRoll(this, width*0.01, height*0.85, width*0.98, height*0.14);
    tr.setTextStart(width*0.03, height*0.91);
    tr.setNewlinePlacement(width*0.94, height*0.05);
    
    battle_prompt = new BattleText(this, width*0.01, height*0.6, width*0.23, height*0.39);
    battle_prompt.setTextStart(width*0.03, height*0.66);
    battle_prompt.setNewlinePlacement(18, height*0.04);
    
    reader = new TextReader(this, "gametexts/0.txt", tr);
    for (int i = 0; i <= Tiles.NUM_TILES; ++i) {
      if (i == 0) tiles[0] = null;
      else tiles[i] = loadImage(Tiles.paths[i]);
    }
    
    current_chapter = 0;
    
    initialize = false;
  }

  void run() {
    if (!initialize) {
       current_map = new Map(this, 100, 100, MapDefaults.mapfiles[current_chapter], game_width/2, game_height/2);
       extraFade = EXTRA_FADE_LENGTH;
       initialize = true;
    }
    
    if (mode != GameMode.BATTLE) {
      displayMap();
      p.display(game_width/2, game_height/2);
      if (mode == GameMode.STORY) tr.display();
      reader.run();
      
      handleExtras();
    }
    
    else {
      battle_prompt.display();
    }
  }
  
  void receiveKey(char k) {
    if (!initialize || extraFade > 0) return;
    
    // DEBUG MODE
    if (DEBUG) {
      if (k == '`') {
        mode = GameMode.BATTLE;
      }
      if (k == '1' && mode == GameMode.BATTLE)
      {
        battle_prompt.setText("Hello World my name is Raichu i like potatoes yolo what up yoyos hurt anpanman synchro summon omg haha lmfao yogurtz are bomb!"); 
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
        p.move(0, GAME_SPEED);
        current_map.move(0, GAME_SPEED);
      } else if (k == 's') { // down
        p.move(0, -GAME_SPEED);
        current_map.move(0, -GAME_SPEED);
      } else if (k == 'a') { // left
        p.move(GAME_SPEED, 0);
        current_map.move(GAME_SPEED, 0);
      } else if (k == 'd') { // right
        p.move(-GAME_SPEED, 0);
        current_map.move(-GAME_SPEED, 0);
      }
      return;
    }
  }
  
  void displayMap() {
    for (int i = 0; i < current_map.rows; ++i) {
      for (int j = 0; j < current_map.columns; ++j) {
        int x = current_map.center_x + j*50 - current_map.starting_x;
        int y = current_map.center_y + i*50 - current_map.starting_y;
       
        if (!tileWithinBounds(x, y)) continue;
        
        char c = current_map.map[i][j];
        int c_index = (int) c - '0';
        
        if (c_index <= 0) continue;
        if (c_index >= 50 && current_map.extras[c_index-50] != null) {
          image(tiles[ChapterNpcs.spritebottoms[current_chapter][c_index-50]], x, y, 50, 50);
          image(current_map.extras[c_index-50], x, y, 50, 50);
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
    mode = GameMode.STORY;
    reader.sendNextLine();
  }
  
  void handleExtras() {
    if (extraFade > 0) {
      fill(20, extraFade * 255 / EXTRA_FADE_LENGTH);
      rect(0, 0, game_width, game_height);
      if (--extraFade <= 0) reader.sendNextLine();
      return;
    }
    
    if (extraSurprise > 0) {
      p.move(-0.01f, 0);
      current_map.move(GAME_SPEED*10f, 0);
      extraSurprise -= GAME_SPEED*10f;
      return;
    }
  }
  
  void extraOff() {
    mode = GameMode.EXPLORE;
  }
  
  void extraFight() {
    mode = GameMode.BATTLE;
  }
  
  void extraPlayerSurprised() {
    extraSurprise = GAME_SPEED*30f;
  }
}
