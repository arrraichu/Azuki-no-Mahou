class GameOver {
  
  /* MEMBERS */
  String gameoverText;
  String retryText;
  PImage selector;
  
  /* CONTROL VARIABLES */
  
  /* CONSTANTS */
  final String TEXT_GAMEOVER = "GAME OVER";
  final String TEXT_RETRY = "Press SPACEBAR to play again.";
//  final String ASSET_SELECTOR = "assets/sprites/arrow.png";
  final float GAMEOVER_X = width*0.5;
  final float GAMEOVER_Y = height*0.5;
  final float RETRY_Y = height*0.55;
  
  
  /*
      INITIALIZE ALL MEMBERS
  */
  GameOver() {
    gameoverText = TEXT_GAMEOVER;
    retryText = TEXT_RETRY;
    
//    selector = loadImage(ASSET_SELECTOR);
  }
  
  
  /*
      RUN & DISPLAY LOOP
  */
  void display() {
    textSize(18);
    fill(255);
    text(gameoverText, GAMEOVER_X - (textWidth(gameoverText)/2), GAMEOVER_Y);
    text(retryText, GAMEOVER_X - (textWidth(retryText)/2), RETRY_Y);
  }
}
