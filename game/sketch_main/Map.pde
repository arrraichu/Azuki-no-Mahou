class Map {
  Game parent;
  
  public int rows;
  public int columns;
  BufferedReader map_reader;
  
  public char map[][];
  public int starting_x;
  public int starting_y;
  
  public int center_x, center_y;
  
  final float MOVE_MAGNITUDE = 50f;
  
  PImage extras[] = new PImage[20];

  Map(Game g, int r, int c, String path, int x, int y) {
    parent = g;
    rows = r; columns = c;
    map_reader = createReader(path);
    
    map = new char[rows][columns];
    
    center_x = x;
    center_y = y;
    
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
          map[i][j] = MapDefaults.playerTiles[parent.current_chapter];
        }
        
        else if (cur >= ('0'+50)) { // character sprites
          int index = cur - '0' - 50;
          extras[index] = loadImage(ChapterNpcs.spritepaths[parent.current_chapter][index]);
        }
      }
    }
  }
  
  char contact(float x, float y) {
    float test_x = center_x - x * MOVE_MAGNITUDE;
    float test_y = center_y - y * MOVE_MAGNITUDE;
    
    return coordinateOn(test_x, test_y);
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
    if (test_char > 0 && test_char <= 20 && test2_char > 0 && test2_char <= 20) {
      starting_x -= x * MOVE_MAGNITUDE;
      starting_y -= y * MOVE_MAGNITUDE;
    }
    
  }
  
  char coordinateOn(float x, float y) {
    int column = floor((x + starting_x - center_x) / 50f);
    int row = floor((y + starting_y - center_y) / 50f);
    
    return map[row][column];
  }
  
  
}
