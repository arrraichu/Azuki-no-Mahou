class Map {
  
  /* MEMBERS */
  Game parent;                             // Game parent
  public int rows, columns;                // number of rows and columns in the map
  public int center_x, center_y;           // the center of the screen
  BufferedReader map_reader;               // used in initialization to read the map text file
  public int starting_x, starting_y;       // the coordinates where the player is standing
  PImage extras[];                         // other characters, etc.
  public char map[][];                     // the map itself
  PImage tiles[];                          // the tile sprites
  PImage talk_notices[];                   // sprites the signal talking to npcs, etc.
  
  /* CONTROL VARIABLES */
  int talk_counter;                        // time counter to flicker talk indication animation
  int talk_index;                          // the index of the talk animation sprite
  
  /* CONSTANTS */
  final float MOVE_MAGNITUDE = 50f;        // the movement speed of the map
  final String TALK_PATH[] = {             // asset path for talk indication sprites
    "assets/sprites/talkA01.png",
    "assets/sprites/talkA02.png"
  };
  final int TALK_FLICKR = 40;              // the time length of the talk indication sprites
  final int NUM_EXTRAS = 20;               // number of npc charcters and the like
  final int NUM_TILES = 26;                // number of tiles
  final String TILE_PATHS[] = { // asset paths for npcs
    "assets/tiles/rock.png",        
    "assets/tiles/dirt_01.png",
    "assets/tiles/dirt_02.png",
    "assets/tiles/dirt_03.png",
    "assets/tiles/dirt_04.png",
    "assets/tiles/dirt_05.png",
    "assets/tiles/dirt_06.png",
    "assets/tiles/dirt_07.png",
    "assets/tiles/dirt_08.png",
    "assets/tiles/dirt_09.png",
    "assets/tiles/grassB_01.png",
    "assets/tiles/signpost.png",
    "assets/tiles/wetgrass.png",
    "assets/tiles/cornertree_L01.png",
    "assets/tiles/cornertree_L02.png",
    "assets/tiles/cornertree_R01.png",
    "assets/tiles/cornertree_R02.png",
    "assets/tiles/treetop.png",
    "assets/tiles/treebottom_01.png",
    "assets/tiles/treebottom_02.png",
    "assets/tiles/trees_TL.png",
    "assets/tiles/trees_TR.png",
    "assets/tiles/hindtree_01.png",
    "assets/tiles/hindtree_02.png",
    "assets/tiles/cornerhindtree_01.png",
    "assets/tiles/cornerhindtree_02.png",
    "assets/tiles/grass_tile_7.png"
  };
  final String MAP_FILES[] = {             // paths for the map files
    "assets/maps/0.txt",
    "assets/maps/1.txt"
  };
  final char PLAYER_STANDING[] = {         // the asset index of what the player is standing on
    '5',
    '5'
  };
  


  /*
      INTIALIZE ALL MEMBERS
  */
  Map(Game g, int r, int c, int x, int y) {
    parent = g;
    
    rows = r; columns = c;
    
    center_x = x; center_y = y;
    
    map_reader = createReader(MAP_FILES[parent.current_chapter]);
    
    map = new char[rows][columns];
    
    extras = new PImage[NUM_EXTRAS];
    
    // initialize the map, the starting x and y, and extras
    String line;
    for (int i = 0; i < rows; ++i) {
      try {
        line = map_reader.readLine();
      } catch (IOException e) {
        e.printStackTrace();
        line = null;
        return;
      }
      
      if (line == null) {
        
      }
      
      for (int j = 0; j < columns; ++j) {
        map[i][j] = line.charAt(j);
        
        char cur = line.charAt(j);
        if (cur == 'P') {
          starting_x = j * 50;
          starting_y = i * 50;
          map[i][j] = PLAYER_STANDING[parent.current_chapter];
        }
        
        else if (cur >= ('0'+50)) { // character sprites
          int index = cur - '0' - 50;
          extras[index] = loadImage(ChapterNpcs.spritepaths[parent.current_chapter][index]);
        }
      }
    }
    
    tiles = new PImage[NUM_TILES+1]; // !move Tiles class to here?
    for (int i = 0; i <= NUM_TILES; ++i) {
      tiles[i] = loadImage(TILE_PATHS[i]);
    }
    
    talk_notices = new PImage[2];
    talk_notices[0] = loadImage(TALK_PATH[0]);
    talk_notices[1] = loadImage(TALK_PATH[1]);
    talk_index = 0;
    talk_counter = TALK_FLICKR;
  }
  
  
  /*
      RUN & DISPLAY LOOP
  */
  void displayMap() {
    for (int i = 0; i < rows; ++i) {
      for (int j = 0; j < columns; ++j) {
        int x = center_x + j*50 - starting_x;
        int y = center_y + i*50 - starting_y;
       
        if (!tileWithinBounds(x, y)) continue;
        
        char c = map[i][j];
        int c_index = (int) c - '0';
        
        if (c_index < 0) continue;
        if (c_index >= 50 && extras[c_index-50] != null) { // characters
          image(tiles[ChapterNpcs.spritebottoms[parent.current_chapter][c_index-50]], x, y, 50, 50); // standing on
          image(extras[c_index-50], x, y, 50, 50); // the character
          image(talk_notices[talk_index], x+40, y-30, 40, 40); // talkable
          continue;
        }
        if (c_index > NUM_TILES) continue;
        image(tiles[c_index], x, y, 50, 50);
      }
    }
    
    if (parent.mode == GameMode.BATTLE) flickerTalk();
  }
  
  boolean tileWithinBounds(int x, int y) {
    if (x > WIDTH || y > HEIGHT) return false;
    if (x+50 < 0 || y+50 < 0) return false;
    return true;
  }
  
  private void flickerTalk() {
    if (--talk_counter <= 0) {
      talk_counter = TALK_FLICKR;
      talk_index = 1 - talk_index;
    }
  }
  
  char contact(float x, float y) {
    float test_x = center_x - x * MOVE_MAGNITUDE;
    float test_y = center_y - y * MOVE_MAGNITUDE;
    
    return coordinateOn(test_x, test_y);
  }
  
  int character_contact(float speed, int direction) {
    if (direction < 0 || direction > 3) return -1;
    float point1x = 0, point1y = 0, point2x = 0, point2y = 0;
   
    if (direction == 2) { // up
      point1x = WIDTH/2;
      point1y = HEIGHT/2 - speed;
      point2x = WIDTH/2 + 50;
      point2y = HEIGHT/2 - speed;
    } else if (direction == 3) { // down
      point1x = WIDTH/2;
      point1y = HEIGHT/2 + 50 + speed;
      point2x = WIDTH/2 + 50;
      point2y = HEIGHT/2 + 50 + speed;
    } else if (direction == 0) { // left
      point1x = WIDTH/2 - speed;
      point1y = HEIGHT/2;
      point2x = WIDTH/2 - speed;
      point2y = HEIGHT/2 + 50;
    } else if (direction == 1) { // right
      point1x = WIDTH/2 + 50 + speed;
      point1y = HEIGHT/2;
      point2x = WIDTH/2 + 50 + speed;
      point2y = HEIGHT/2 + 50;
    }
    
    int coor1 = coordinateOn(point1x, point1y) - '0' - 50;
    int coor2 = coordinateOn(point2x, point2y) - '0' - 50;
    
    if (coor1 < 0 && coor2 < 0) return -1;
    if (coor1 >= 0 && coor2 >= 0) {
      float point3x = (point1x + point2x) / 2;
      float point3y = (point1y + point2y) / 2;
      int coor3 = coordinateOn(point3x, point3y) - '0' - 50;
      return coor3;
    }
    if (coor1 >= 0) {
      return coor1;
    }
    return coor2;
   
  }
  
  void move(float x, float y) {
    if (x == 0 && y == 0) return;
    if (x != 0 && y != 0) return;
    
    float test_x = center_x - x * MOVE_MAGNITUDE;
    float test_y = center_y - y * MOVE_MAGNITUDE;
    float test2_x = test_x;
    float test2_y = test_y;

    if (y != 0f) {
      if (y < 0f) {
        test_y += 49f;
        test2_y = test_y;
      }
      test2_x += 49f;
    } else {
      if (x < 0f) {
        test_x += 49f;
        test2_x = test_x;
      }
      test2_y += 49f;
    }
    
    int test_char = coordinateOn(test_x, test_y) - '0';
    int test2_char = coordinateOn(test2_x, test2_y) - '0';
    if (walkAllowed(test_char) && walkAllowed(test2_char)) {
      starting_x -= x * MOVE_MAGNITUDE;
      starting_y -= y * MOVE_MAGNITUDE;
    }
    else {
      repeatMove(x, y, MOVE_MAGNITUDE/2);
    }
  }
  
  private boolean walkAllowed(int index) {
    if (index <= 0) return false;
    if (index >= 13 && index <= 25) return false;
    if (index > NUM_TILES) return false;
    return true;
  }
  
  private void repeatMove(float x, float y, float magnitude) {
    if (magnitude < 0.4f) return;
    
    if (x == 0 && y == 0) return;
    if (x != 0 && y != 0) return;
    
    float test_x = center_x - x * magnitude;
    float test_y = center_y - y * magnitude;
    float test2_x = test_x;
    float test2_y = test_y;

    if (y != 0f) {
      if (y < 0f) {
        test_y += 49f;
        test2_y = test_y;
      }
      test2_x += 49f;
    } else {
      if (x < 0f) {
        test_x += 49f;
        test2_x = test_x;
      }
      test2_y += 49f;
    }
    
    int test_char = coordinateOn(test_x, test_y) - '0';
    int test2_char = coordinateOn(test2_x, test2_y) - '0';
    if (walkAllowed(test_char) && walkAllowed(test2_char)) {
      starting_x -= x * magnitude;
      starting_y -= y * magnitude;
    }
    else {
      repeatMove(x, y, magnitude/2);
    }
  }
  
  char coordinateOn(float x, float y) {
    int column = floor((x + starting_x - center_x) / 50f);
    int row = floor((y + starting_y - center_y) / 50f);
    
    return map[row][column];
  }
  
  
}
