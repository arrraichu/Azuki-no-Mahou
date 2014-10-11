/*
  Displays the text on the bottom textbox,
  and rolling the text when necessary.
*/

class TextRoll {
  final static int TEXTROLL_INTERVAL = 1;
  
  // dimensions of text box
  float left_coor;
  float top_coor;
  float box_width;
  float box_height;
  
  // where the text should start
  float text_startx;
  float text_starty;
  
  // two-pass buffer system for text rolling
  String fedInput;
  String inputBuffer;
  
  // count for text rolling interval
  int textroll_count;
  
  boolean isPrompt; // false is roll isn't needed
  boolean readyNext;
  
  // constructor reads box coordinates and sets default values
  TextRoll(float left, float top, float w, float h) {
    left_coor = left;
    top_coor = top;
    box_width = w;
    box_height = h;
    
    text_startx = left;
    text_starty = top;
    
    fedInput = ""; inputBuffer = ""; textroll_count = 0;
    isPrompt = false; readyNext = true;
  }
  
  // set where the text should begin
  void setTextStart(float x, float y) {
    text_startx = x;
    text_starty = y;
  }
  
  // display function run in main's draw method
  void display() {
    stroke(50);
    strokeWeight(4);
    fill(255);
    rect(left_coor, top_coor, box_width, box_height);
    
    this.rollText();
    this.updateReady();
  }
  
  // returns whether the textbox is ready to accept the next input
  boolean ready() {
    return readyNext;
  }
  
  // set text function; CHECK IF READY FIRST!
  void setText(String text, boolean prompt) {
    if (!readyNext) return;
    
    isPrompt = prompt;
    inputBuffer = (isPrompt) ? text : "";
    textroll_count = 0;
    fedInput = text;
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
    
    if (fedInput == "") return;
    
    if (inputBuffer == fedInput) {

    } else if (++textroll_count % TEXTROLL_INTERVAL == 0) {
      inputBuffer = fedInput.substring(0, inputBuffer.length()+1);
    }
    
    text(inputBuffer, text_startx, text_starty);
  }
  
  // hard reset on displaying text
  void reset() {
    fedInput = ""; inputBuffer = ""; textroll_count = 0;
    isPrompt = false; readyNext = true;
  }
}
