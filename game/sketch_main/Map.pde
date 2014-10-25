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
        
        if (line.charAt(j) == 'P') {
          starting_x = j * 50;
          starting_y = i * 50;
          map[i][j] = MapDefaults.playerTiles[parent.current_chapter];
        }
      }
    }
  }
  
  void move(float x, float y) {
    if (x == 0 && y == 0) return;
    if (x != 0 && y != 0) return;
    
    float test_x = center_x - x * MOVE_MAGNITUDE;
    float test_y = center_y - y * MOVE_MAGNITUDE;
    
    // check the bottom right point instead when checking down and right boundaries
    if (x+y < 0f) {
      test_x += 49f;
      test_y += 49f;
    }
    
    if (coordinateOn(test_x, test_y) != '0') {
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
