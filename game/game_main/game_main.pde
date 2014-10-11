/*
  Raymond Chu, Nick Yeung, Damien McKie, Stanford Mendenhall
  Media in Game Design
  Azuki no Mahou / Magical Beans
  Main File
*/

/*===== CONSTANTS =====*/
final static int WIDTH = 1280;
final static int HEIGHT = 720;

PFont default_font;

TextRoll tr;
TextReader reader;


/*===== FUNCTIONS =====*/
void setup() {
  size(WIDTH, HEIGHT);
  background(130);
  
  default_font = createFont("fonts/EightBit.ttf", 28);
  textFont(default_font, 28);
  
  tr = new TextRoll(width*0.01, height*0.90, width*0.98, height*0.09);
  tr.setTextStart(width*0.03, height*0.96);
  
  reader = new TextReader("testfile.txt", tr);
}

void draw() {
  stroke(0);
  strokeWeight(1);
  line(width/4, height/2, 3*width/4, height/2);
  
  tr.display();
}

void keyPressed() {
  if (key == ' ') {
    reader.sendNextLine();
  }
}
