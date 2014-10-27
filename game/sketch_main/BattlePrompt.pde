class BattlePrompt {
  Game parent;
  
  // dimensions of text box
  float left_coor;
  float top_coor;
  float box_width;
  float box_height;
  
  // where the text should start & the max width per line
  float text_startx;
  float text_starty;
  
  float nextline_disp;
  
  int charsperline;
  
  String input;
  
  int wrap_index[];
  
  boolean text_done;
  
  final static int NUM_LINES = 7;
  
  BattlePrompt(Game g, float left, float top, float w, float h) {
    parent = g;
    
    left_coor = left;
    top_coor = top;
    box_width = w;
    box_height = h;
    
    text_startx = left;
    text_starty = top;
    
    nextline_disp = h*0.05;
    
    charsperline = 100;
    
    input = "";
    wrap_index = new int[NUM_LINES];
    
    text_done = true;
    
    for (int i = 0; i < NUM_LINES; ++i) wrap_index[i] = -1;
  }
}
