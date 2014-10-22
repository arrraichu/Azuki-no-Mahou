class Game {
  int game_width;
  int game_height;
  
  Player p;
  
  PFont default_font;
  TextRoll tr;
  TextReader reader;
  
  PImage tiles[] = new PImage[Tiles.NUM_TILES+1];
  
  final int TOTAL_CHAPTERS = 0;
  int current_chapter;
  
  Map current_map;
  
  boolean initialize;
  
  final float GAME_SPEED = 0.1f;
  
  final float EXTRA_FADE_LENGTH = GAME_SPEED*700f; // 70 frames
  float extraFade = 0f;
  final float EXTRA_SURPRISE_LENGTH = GAME_SPEED*50f;
  float extraSurprise = 0f;
  
  Game(int w, int h) {
    game_width = w; game_height = h;
    p = new Player();
      
    default_font = createFont("assets/fonts/EightBit.ttf", 22);
    textFont(default_font, 22);
    
    tr = new TextRoll(width*0.01, height*0.85, width*0.98, height*0.14);
    tr.setTextStart(width*0.03, height*0.91);
    tr.setNewlinePlacement(width*0.94, height*0.05);
  
    reader = new TextReader("gametexts/0.txt", tr);
    for (int i = 0; i <= Tiles.NUM_TILES; ++i) {
      if (i == 0) tiles[0] = null;
      else tiles[i] = loadImage(Tiles.paths[i]);
    }
    
    current_chapter = 0;
    
    initialize = false;
  }

  void run() {
    if (!initialize) {
       current_map = new Map(100, 100, "assets/maps/0.txt", game_width/2, game_height/2);
       extraFade = EXTRA_FADE_LENGTH;
       initialize = true;
    }
    
    displayMap();
    p.display(game_width/2, game_height/2);
    tr.display();
    
    handleFeedbacks();
    handleExtras();
  }
  
  void receiveKey(char k) {
    if (!initialize || extraFade > 0) return;
    
    if (k == ' ') {
     reader.sendNextLine();
     return;
    }
    
    if (k == 'w') {
      p.move(0, GAME_SPEED);
      current_map.move(0, GAME_SPEED);
    } else if (k == 's') {
      p.move(0, -GAME_SPEED);
      current_map.move(0, -GAME_SPEED);
    } else if (k == 'a') {
      p.move(GAME_SPEED, 0);
      current_map.move(GAME_SPEED, 0);
    } else if (k == 'd') {
      p.move(-GAME_SPEED, 0);
      current_map.move(-GAME_SPEED, 0);
    }
    
    else if (k == 'p') {
      extraPlayerSurprised();
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
        
        if (c_index < 0 || c_index > Tiles.NUM_TILES) continue;
        
        image(tiles[c_index], x, y, 50, 50);
      }
    }
  }
  
  void handleFeedbacks() {
    if (reader.feedback == "surprise") {
      reader.feedback = "";
      extraPlayerSurprised();
    }
  }
  
  boolean tileWithinBounds(int x, int y) {
    if (x > game_width || y > game_height) return false;
    if (x+50 < 0 || y+50 < 0) return false;
    return true;
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
    
  
  void extraPlayerSurprised() {
    extraSurprise = GAME_SPEED*50f;
  }
}
