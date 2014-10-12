/*
  Raymond Chu, Nick Yeung, Damien McKie, Stanford Mendenhall
  Media in Game Design
  Azuki no Mahou / Magical Beans
  Main File
*/

/*===== CONSTANTS =====*/
final static int WIDTH = 1024;
final static int HEIGHT = 576;

PFont default_font;

TextRoll tr;
TextReader reader;


/*===== FUNCTIONS =====*/
void setup() {
  size(WIDTH, HEIGHT);
  background(130);
  
  default_font = createFont("fonts/EightBit.ttf", 22);
  textFont(default_font, 22);
  
  tr = new TextRoll(width*0.01, height*0.85, width*0.98, height*0.14);
  tr.setTextStart(width*0.03, height*0.91);
  tr.setNewlinePlacement(width*0.94, height*0.05);
  
  reader = new TextReader("debug/testfile.txt", tr);
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
