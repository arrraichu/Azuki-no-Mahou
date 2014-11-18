class Battle {
 
  /* MEMBERS */
  BattleText battle_text;            // left box in battle
  BattlePrompt battle_prompt;        // right box in battle
  PImage foreground;                 // foreground where the characters are standing on

  /* CONTROL VARIABLES */
 
  /* CONSTANTS */
  final String ASSET_FOREGROUND = "assets/backgrounds/battlefg.png";    // asset path for battle foreground


  /*
      INTIALIZE ALL MEMBERS
  */
  Battle(Game g) {
    battle_text = new BattleText(g, width*0.01, height*0.6, width*0.23, height*0.39);
    battle_text.setTextStart(width*0.03, height*0.66);
    battle_text.setNewlinePlacement(18, height*0.04);
    
    battle_prompt = new BattlePrompt(g, width*0.76, height*0.6, width*0.23, height*0.39, width*0.78, height*0.66, 18, height*0.065);
    
    foreground = loadImage(ASSET_FOREGROUND);
  }
 
  
  
  /*
      RUN & DISPLAY LOOP
  */ 
  void display() {
    image(foreground, 0, 0, WIDTH, HEIGHT);
    battle_text.display();
    battle_prompt.display();
  } 
}
