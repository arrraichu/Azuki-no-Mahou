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
  
  int state;
  int selection;
  
  Enemy enemies[];
  int player_pos[];
  int enemies_pos[][];
  
  final int HEIGHT_REALESTATE = (int)(height*0.75);
  final float PLACEMENT_AWAYFROMBOUNDARY = width*0.3;
  final int SLIDEIN_INTERVAL = 8;
  final String HPBAR_PATH = "assets/others/hp.png";
  
  PImage hpbar;
  
  int enemies_left;
  
  boolean response;
  int enemy_ptr;
  
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
    
    state = 0;
    selection = 0;
    
    enemies = new Enemy[ChapterEnemies.NUM_ENEMIES[parent.current_chapter]];
    enemies_pos = new int[ChapterEnemies.NUM_ENEMIES[parent.current_chapter]][];
    for (int i = 0; i < ChapterEnemies.NUM_ENEMIES[parent.current_chapter]; ++i) {
      enemies[i] = new Enemy(parent, ChapterEnemies.ENEMY_NAMES[parent.current_chapter][i], ChapterEnemies.ENEMY_ASSETS[parent.current_chapter][i], 5, 2, 1, 1, 1);
      enemies_pos[i] = new int[2];
    }
    
    player_pos = new int[2];
    player_pos[1] = HEIGHT_REALESTATE/2 - 25;
    
    fitEnemyHeights();
    // every sprite out of screen first
    player_pos[0] = -50;
    for (int i = 0; i < ChapterEnemies.NUM_ENEMIES[parent.current_chapter]; ++i) {
      enemies_pos[i][0] = width;
    }
    
    hpbar = loadImage(HPBAR_PATH);
    
    enemies_left = ChapterEnemies.NUM_ENEMIES[parent.current_chapter];
    
    response = false;
    enemy_ptr = 0;
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
    
    stateSettings();
    
    // display sprites
    image(parent.pstats.sprite, player_pos[0], player_pos[1], 50, 50);
    for (int i = 0; i < ChapterEnemies.NUM_ENEMIES[parent.current_chapter]; ++i) {
      if (enemies[i] == null) continue;
      image(enemies[i].sprite, enemies_pos[i][0], enemies_pos[i][1]);
    }
    
    if (state != 0) { // display hp bar
      image(hpbar, player_pos[0]+45, player_pos[1], 100, 20);
      noStroke();
      float hp_pctg = 68f * (float)(parent.pstats.rem_health) / (float)(parent.pstats.health);
      if (hp_pctg <= 68f * 0.25f) fill(255, 0, 0);
      else if (hp_pctg <= 68f * 0.5f) fill(255, 170, 0);
      else fill(100, 100, 255);
      rect(player_pos[0]+62, player_pos[1]+9, hp_pctg, 3);
      for (int i = 0; i < ChapterEnemies.NUM_ENEMIES[parent.current_chapter]; ++i) {
        if (enemies[i] == null) continue;
        image(hpbar, enemies_pos[i][0]+45, enemies_pos[i][1], 100, 20);
        hp_pctg = 68f * (float)(enemies[i].rem_health) / (float)(enemies[i].health);
        if (hp_pctg <= 68f * 0.25f) fill(255, 0, 0);
        else if (hp_pctg <= 68f * 0.5f) fill(255, 170, 0);
        else fill(100, 100, 255);
        rect(enemies_pos[i][0]+62, enemies_pos[i][1]+9, hp_pctg, 3);
      }
    }
  }
  
  private void stateSettings() {
    if (state == 0) { // get the characters & hp bars in correct position
      if (player_pos[0] < PLACEMENT_AWAYFROMBOUNDARY) {
        player_pos[0] += SLIDEIN_INTERVAL;
        for (int i = 0; i < ChapterEnemies.NUM_ENEMIES[parent.current_chapter]; ++i) {
          enemies_pos[i][0] -= SLIDEIN_INTERVAL;
        }
      }
      else state = 1;
      return; 
    }
    
    if (state == 1) { // user prompts to attack or skip
      fill(0);
      textSize(18);
      text("What will you do", text_startx, text_starty);
      text("this turn?", text_startx, text_starty + 0.7*nextline_disp);
      textSize(28);
      
      if (selection == 0) {
        fill(150);
        setText("Select an enemy to attack.");
      }
      else fill(0);
      text("ATTACK", text_startx, text_starty + 2*nextline_disp);
      
      if (selection == 1) {
        fill(150);
        setText("Do nothing for this turn.");
      }
      else fill(0);
      text("SKIP", text_startx, text_starty + 3*nextline_disp);
      return; 
    }
    
    if (state == 2) { // user specifying target
      fill(0);
      text("TARGET?", text_startx, text_starty);
      textSize(20);
      int index = 0;
      for (int i = 0; i < ChapterEnemies.NUM_ENEMIES[parent.current_chapter]; ++i) {
        if (enemies[i] == null) continue;
        
        if (selection == index) fill(150);
        else fill(0);
                
        text(enemies[i].name, text_startx, text_starty + (index+1)*nextline_disp);
        ++index;
      }
      return;
    }
    
    if (state == 3) { // attack mechanism
      if (!response) {
        /* attacking target */
        int target = 0;
        for (int i = 0; i < ChapterEnemies.NUM_ENEMIES[parent.current_chapter]; ++i) {
          if (enemies[i] == null) continue;
          if (selection == 0) {
            target = i;
            break;
          }
          --selection;
        }
        
        enemies[target].rem_health -= parent.pstats.attack;
        String text = enemies[target].name + " has taken a hit.";
        
        /* handling knockouts */
        if (enemies[target].rem_health < 0) {
          text += " " + enemies[target].name + " has been knocked out!";
          enemies[target] = null;
          --enemies_left;
        }
        setText(text);
        response = true;
      }
      return;
    }
    
    if (state == 4) { // enemies turn to move
      if (!response) {
        while (enemy_ptr < ChapterEnemies.NUM_ENEMIES[parent.current_chapter] && enemies[enemy_ptr] == null) {
          ++enemy_ptr;
        }
        
        if (enemy_ptr >= ChapterEnemies.NUM_ENEMIES[parent.current_chapter]) {
          state = 1;
          enemy_ptr = 0;
          return;
        }
        
        parent.pstats.rem_health -= enemies[enemy_ptr].attack;
        setText(enemies[enemy_ptr].name + " has attacked you.");
        if (parent.pstats.rem_health <= 0) {
          state = 6;
          enemy_ptr = 0;
          return;
        }
        
        ++enemy_ptr;
        
        response = true;
      }
      return;
    }
    
    if (state == 5) { // win state
      parent.finishBattle();
      return;
    }
    
    if (state == 6) { // lose state
      if (!response) {
        setText("YOU RAN OUT OF HEALTH.\nGAME OVER");
        response = true;
      }
      return;
    }
  }
  
  private void fitEnemyHeights() {
    int numfit = ChapterEnemies.NUM_ENEMIES[parent.current_chapter];
    int interval = HEIGHT_REALESTATE / (numfit+1);
    
    for (int i = 0; i < numfit; ++i) {
      enemies_pos[i][1] = (1+i)*interval - 25;
    }
  }
  
  void receiveKeys(char k) {
    if (state == 1) {
      if (k == ' ') {
        if (selection == 0) state = 2;
        else if (selection == 1) state = 4;
        playSound(0);
        selection = 0;
        return;
      }
      
      if (k == 'w') {
        if (selection > 0) --selection;
        return;
      }
      
      if (k == 's') {
        if (selection < 1) ++ selection;
        return;
      }
      return;
    }
    
    if (state == 2) {
      if (k == ' ') {
        state = 3;
        playSound(0);
        return;
      }
      
      if (k == 'w') {
        if (selection > 0) --selection;
        return;
      }
      
      if (k == 's') {
        if (selection < enemies_left-1) ++selection;
        return;
      }
      return;
    }
    
    if (state == 3) {
      if (!response) return;
      if (key == ' ') {
        response = false;
        if (enemies_left <= 0) state = 5;
        else state = 4;
        playSound(0);
        return;
      }
      return;
    }
    
    if (state == 4) {
      if (key == ' ' && response) {
        response = false;
        playSound(0);
      }
      return;
    }
  }
  
  void setText(String t) {
    parent.battle_text.setText(t);
  }
}
