/*
  Displays the text on the bottom textbox,
  and rolling the text when necessary.
*/

class TextRoll {
  
  /* MEMBERS */
  Game parent;                                      // Game parent
  float left_coor, top_coor;                        // top left coordinate of the text window
  float box_width, box_height;                      // window width and height
  PImage profileLeft, profileRight;                 // sprites for the left and right profile images
  float text_startx, text_starty;                   // top left coordinate of where the text should start
  float text_width, nextline_disp;                  // the maximum width a line of text can take, and how far down the next line should be
  String fedInput, inputBuffer;                     // the input as well as a buffer of current text that is so far displayed
  PImage finishers[];                               // sprite at the bottom right to indicate user should continue
  
  /* CONTROL VARIABLES */
  boolean leftTalking = true;                       // indicator for whether the left or right character is talking
  int textroll_count = 0;                           // iterator for which character is being processed atm
  int current_spcindex = -1;                        // last index where a space was found
  int wrap_index = -1;                              // last index where a next line should be placed
  boolean isPrompt = false;                         // false is roll isn't needed
  boolean readyNext = true;                         // whether it is ready to take new text
  int finish_counter = 0;                           // time counter for the text finished indicator
  int finish_index = 0;                             // sprite index for the text finished indicator animation
  
  /* CONSTANTS */
  final static int TEXTROLL_INTERVAL = 1;           // time length to roll the next character
  final float PROFILE_SIZE = width*0.08;            // the size of the profile square
  final float LEFT_PROFCORNER_X = width*0.01;       // top left coordinate of left profile image
  final float LEFT_PROFCORNER_Y = height*0.7;
  final float RIGHT_PROFCORNER_X = width*0.91;      // top left coordinate of right profile image
  final float RIGHT_PROFCORNER_Y = height*0.7;
  final String FINISH_PATH[] = {                    // asset paths for the text finished indicator animation
    "assets/sprites/text_completion1.png",
    "assets/sprites/text_completion2.png" 
  };
  final int FINISH_FLICKR = 40;                     // time length for the text finished sprites to animate
 
  
  /*
      INTIALIZE ALL MEMBERS
  */
  TextRoll(Game g, float left, float top, float w, float h, float tsx, float tsy, float tw, float nld) {
    parent = g;
    
    left_coor = left;
    top_coor = top;
    
    box_width = w;
    box_height = h;
    
    // profileLeft & profileRight initialized dynamically
    
    text_startx = tsx;
    text_starty = tsy;
    
    text_width = tw;
    nextline_disp = nld;
    
    fedInput = ""; inputBuffer = "";
    
    finishers = new PImage[2];
    for (int i = 0; i < 2; ++i) finishers[i] = loadImage(FINISH_PATH[i]);

  }
  
  /*
      RUN & DISPLAY LOOP
  */
  void display() {
    stroke(50);
    strokeWeight(4);
    fill(255);
    rect(left_coor, top_coor, box_width, box_height);
        
    this.rollText();
    displayProfiles();
    flicker();
  }
  
  /*
      DISPLAYS TEXT
      DETERMINES WHETHER THE TEXT NEEDS TO ROLL AND DISPLAYS APPROPRIATELY
  */
  private void rollText() {
    
    // null checking
    if (fedInput.length() == 0)  {
      readyNext = true;
      return;
    }
    
    stroke(50);
    fill(0);
    
    // do not roll. just display text
    if (isPrompt) {
      text(fedInput, text_startx, text_starty);
      readyNext = true;
      return;
    }
    
    readyNext = false;
    
    // finished rolling all of the text
    if (inputBuffer == fedInput) {
      text(inputBuffer, text_startx, text_starty);
      image(finishers[finish_index], width*0.96, height*0.94, 23, 23);
      readyNext = true;
      return;
    }
    
    // timer has not hit for next character
    if (++textroll_count % TEXTROLL_INTERVAL != 0) return;
    
    // add a character. if it is a space, save the index
    inputBuffer = fedInput.substring(0, inputBuffer.length()+1);
    if (inputBuffer.charAt(inputBuffer.length()-1) == ' ') current_spcindex = inputBuffer.length();
    
    // if we hit max width, save the wrap index
    if (textWidth(inputBuffer) > text_width && wrap_index == -1) {
      wrap_index = current_spcindex;
    }
    
    // if wrap index was recorded, then the text needs to split into two lines
    if (wrap_index != -1) {
      text(inputBuffer.substring(0, wrap_index), text_startx, text_starty);
      text(inputBuffer.substring(wrap_index), text_startx, text_starty+nextline_disp);
    }
    // everything fits into one line 
    else {
      text(inputBuffer, text_startx, text_starty);
    }
  }
  
  /*
      DISPLAY THE LEFT AND RIGHT PROFILE IMAGES WHEN APPLICABLE
  */
  private void displayProfiles() {
    
    // hint: left profile should NEVER be null (this should always run)
    if (profileLeft != null) {
      noFill();
      stroke(50);
      strokeWeight(3);
      
      // the border rectangle
      rect(LEFT_PROFCORNER_X-1, LEFT_PROFCORNER_Y-1, PROFILE_SIZE+2, PROFILE_SIZE+2);
      
      // player is talking: display at full opacity
      if (leftTalking) {
        image(profileLeft, LEFT_PROFCORNER_X, LEFT_PROFCORNER_Y, PROFILE_SIZE, PROFILE_SIZE);
      } 
      // npc is talking: display somewhat transparently
      else {
        tint(255, 100);
        image(profileLeft, LEFT_PROFCORNER_X, LEFT_PROFCORNER_Y, PROFILE_SIZE, PROFILE_SIZE);
        noTint();
      }
      noStroke();
    }
    
    // if there is a second character in the dialogue
    if (profileRight != null) {
      noFill();
      stroke(50);
      strokeWeight(3);
      
      // the border rectangle
      rect(RIGHT_PROFCORNER_X-1, RIGHT_PROFCORNER_Y-1, PROFILE_SIZE+2, PROFILE_SIZE+2);
      
      // player is talking: display somewhat transparently
      if (leftTalking) {
        tint(255, 100);
        image(profileRight, RIGHT_PROFCORNER_X, RIGHT_PROFCORNER_Y, PROFILE_SIZE, PROFILE_SIZE);
        noTint();
      } 
      // npc is talking: display at full opacity
      else {
        image(profileRight, RIGHT_PROFCORNER_X, RIGHT_PROFCORNER_Y, PROFILE_SIZE, PROFILE_SIZE);
      }
      noStroke();
    }
  }
  
  
  /*
      ANIMATE THE TEXT-FINISHED INDICATOR AT THE BOTTOM RIGHT CORNER OF THE WINDOW
  */
  private void flicker() {
    if (--finish_counter <= 0) {
      finish_counter = FINISH_FLICKR;
      finish_index = 1 - finish_index;
    }
  }
   
  
  /*
      ALLOWS OTHER CLASSES TO SET THE WINDOW TEXT
  */
  public void setText(String text, boolean prompt) {    
    isPrompt = prompt;
    inputBuffer = (isPrompt) ? text : "";
    textroll_count = 0;
    fedInput = text;
    current_spcindex = -1;
    wrap_index = -1;
    
    leftTalking = (text.indexOf(':') == -1);
  }
  
  /*
      FORCE THE TEXT TO COMPLETE AND DISPLAY TO THE WINDOW
  */
  public void flushBuffer() {
    if (fedInput == "") return;
    inputBuffer = fedInput;
  }
}
