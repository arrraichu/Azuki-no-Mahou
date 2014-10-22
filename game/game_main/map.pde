class Map {
  public int rows;
  public int columns;
  BufferedReader map_reader;
  
  public char map[][];
  public int starting_x;
  public int starting_y;
  
  public int center_x, center_y;
  
  final float MOVE_MAGNITUDE = 30f;

  Map(int r, int c, String path, int x, int y) {
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
        }
      }
    }
  }
  
  void move(float x, float y) {
    if (x == 0 && y == 0) return;
    if (x != 0 && y != 0) return;
    
    starting_x -= x * MOVE_MAGNITUDE;
    starting_y -= y * MOVE_MAGNITUDE;
    
//    System.out.println(y * MOVE_MAGNITUDE);
//    System.out.println(starting_y);
  }
  
  
}
