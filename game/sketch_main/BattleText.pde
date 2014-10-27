class BattleText {
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
  
  final static int NUM_LINES = 8;
  
  BattleText(Game g, float left, float top, float w, float h) {
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
  
  void setTextStart(float x, float y) {
    text_startx = x;
    text_starty = y;
  }
  
  void setNewlinePlacement(int cpl, float nld) {
    charsperline = cpl;
    nextline_disp = nld;
  }
  
  void display() {
    stroke(50);
    strokeWeight(4);
    fill(255);
    rect(left_coor, top_coor, box_width, box_height);
    
    displayText();
  }
  
  private void displayText() {
    if (input == null || input == "") return;
    
    textSize(20);
    fill(0);
    
    if (!text_done) {
      int last_space = -1; // last occurrence of a space
      int current_index = 0; // current index of wrap index we're dealing with
      int lastlinebreak = 0; // last time we broke the line
      for (int i = 0; i < input.length(); ++i) {
        if (input.charAt(i) == ' ') last_space = i;
        
        if (i - lastlinebreak > charsperline) { // time to break the line
          lastlinebreak = (last_space == -1) ? i : last_space;
          wrap_index[current_index] = lastlinebreak;
          if (++current_index >= NUM_LINES) break;
        }
      }
      text_done = true;
    }
    
    if (wrap_index[0] == -1) {
      text(input, text_startx, text_starty);
    }
    
    else {
      text(input.substring(0, wrap_index[0]), text_startx, text_starty);
      for (int i = 1; i < NUM_LINES; ++i) {
        if (wrap_index[i] == -1) {
          text(input.substring(wrap_index[i-1]+1), text_startx, text_starty + i*nextline_disp);
          break;
        }
        else {
          text(input.substring(wrap_index[i-1]+1, wrap_index[i]), text_startx, text_starty + i*nextline_disp);
        } 
      }
    }
  }
  
  void setText(String text) {
    input = text;
    text_done = false;
  }
}
