/*
  Raymond Chu, Nick Yeung, Damien McKie, Stanford Mendenhall
  Media in Game Design
  Azuki no Mahou / Magical Beans
  Main File
*/

/*===== CONSTANTS =====*/
final static int WIDTH = 1024;
final static int HEIGHT = 576;

Game game;


/*===== FUNCTIONS =====*/
void setup() {
  size(WIDTH, HEIGHT);
  
  game = new Game(WIDTH, HEIGHT);
}

void draw() {  
  background(130);
  
  game.run();
}

void keyPressed() {
  char k = key;
  game.receiveKey(k);
}
