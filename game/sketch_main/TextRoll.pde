/*
  Displays the text on the bottom textbox,
  and rolling the text when necessary.
*/

class TextRoll {
  final static int TEXTROLL_INTERVAL = 1;
  
  Game parent;
  
  // dimensions of text box
  float left_coor;
  float top_coor;
  float box_width;
  float box_height;
  
  // where the text should start & the max width per line
  float text_startx;
  float text_starty;
  
  // set text max width and displacement of next line
  float text_width;
  float nextline_disp;
  
  // two-pass buffer system for text rolling
  String fedInput;
  String inputBuffer;
  
  // count for text rolling interval
  int textroll_count;
  
  // where the text needs to be wrapped to the next line
  int current_spcindex;
  int wrap_index;
  
  boolean isPrompt; // false is roll isn't needed
  boolean readyNext;
  
  final String FINISH_PATH[] = {
    "assets/sprites/text_completion1.png",
    "assets/sprites/text_completion2.png" };
  PImage finishers[];
  final int FINISH_FLICKR = 40;
  int finish_counter;
  int finish_index;
  
  
  // constructor reads box coordinates and sets default values
  TextRoll(Game g, float left, float top, float w, float h) {
    parent = g;
    left_coor = left;
    top_coor = top;
    box_width = w;
    box_height = h;
    
    text_startx = left;
    text_starty = top;
    
    text_width = w;
    nextline_disp = h*0.05;
    
    fedInput = ""; inputBuffer = ""; textroll_count = 0;
    current_spcindex = -1; wrap_index = -1;
    isPrompt = false; readyNext = true;
    
    finishers = new PImage[2];
    for (int i = 0; i < 2; ++i) finishers[i] = loadImage(FINISH_PATH[i]);
    finish_counter = FINISH_FLICKR;
    finish_index = 0;
  }
  
  // set where the text should begin
  void setTextStart(float x, float y) {
    text_startx = x;
    text_starty = y;
  }
  
  // set the max width of a line and how far the new line should go
  void setNewlinePlacement(float tw, float nld) {
    text_width = tw;
    nextline_disp = nld;
  }
  
  // display function run in main's draw method
  void display() {
    stroke(50);
    strokeWeight(4);
    fill(255);
    rect(left_coor, top_coor, box_width, box_height);
    
    this.rollText();
    this.updateReady();

    flicker();
  }
  
  private void flicker() {
    if (--finish_counter <= 0) {
      finish_counter = FINISH_FLICKR;
      finish_index = 1 - finish_index;
    }
  }
  
  // returns whether the textbox is ready to accept the next input
  boolean ready() {
    return readyNext;
  }
  
  // set text function; CHECK IF READY FIRST!
  void setText(String text, boolean prompt) {
    if (!readyNext) {
      return;
    }
    
    isPrompt = prompt;
    inputBuffer = (isPrompt) ? text : "";
    textroll_count = 0;
    fedInput = text;
    current_spcindex = -1;
    wrap_index = -1;
  }
  
  // update whether textbox is ready at each iteration
  private void updateReady() {
    if (readyNext) return;
    
    if (fedInput == "" || inputBuffer == fedInput) {
      readyNext = true;
    }
  }
  
  // handles displaying the text character by character
  private void rollText() {
    stroke(50);
    fill(0);
    if (isPrompt) {
      text(fedInput, text_startx, text_starty);
      return;
    }
    
    if (fedInput.length() == 0) return;
    
    readyNext = false;
    if (inputBuffer == fedInput) {
      image(finishers[finish_index], width*0.96, height*0.94, 23, 23);
      readyNext = true;
    } else if (++textroll_count % TEXTROLL_INTERVAL == 0) {
      inputBuffer = fedInput.substring(0, inputBuffer.length()+1);
      if (inputBuffer.charAt(inputBuffer.length()-1) == ' ') current_spcindex = inputBuffer.length();
    }
    
    if (textWidth(inputBuffer) > text_width && wrap_index == -1) {
      wrap_index = current_spcindex;
    }
    
    if (wrap_index != -1) {
      text(inputBuffer.substring(0, wrap_index), text_startx, text_starty);
      text(inputBuffer.substring(wrap_index), text_startx, text_starty+nextline_disp);
    } else {
      text(inputBuffer, text_startx, text_starty);
    }
  }
  
  void flushBuffer() {
    if (fedInput == "") return;
    inputBuffer = fedInput;
  }
  
  // hard reset on displaying text
  void reset() {
    fedInput = ""; inputBuffer = ""; textroll_count = 0;
    current_spcindex = -1; wrap_index = -1;
    isPrompt = false; readyNext = true;
  }
}
