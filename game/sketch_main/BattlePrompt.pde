class BattlePrompt {
  
  /* MEMBERS */
  Game parent;                                              // Game parent
  float left_coor, top_coor;                                // top left coordinate of text window
  float box_width, box_height;                              // window width and height
  float text_startx, text_starty;                           // top left coordinate of where the text should start
  float nextline_disp;                                      // how far down the next line should be
  int charsperline;                                         // how many characters a line can have, maximum
  Enemy enemies[];                                          // all enemies
  int player_pos[];                                         // x and y coordinates of player
  int enemies_pos[][];                                      // x and y coodinates of all enemies
  PImage arrow;                                             // arrow for selection
  PImage hpbar;                                             // hp bar sprite
  int player_hpbuffer;                                      // player hp buffer for animation
  int enemies_hpbuffer[];                                   // enemy hp buffers for animation
  
  /* CONTROL VARIABLES */
  int state = 0;                                            // state control variable
  int selection = 0;                                        // selection index
  int enemies_left;                                         // number of enemies 
  boolean response = false;                                 // if a response is needed
  int enemy_ptr = 0;                                        // selection for enemies
  int fade_counter = -1;                                    // time counter for fades when game over happens           
  int using_skill = -1;                                     // whether the player is using a skill 
  
  /* CONSTANTS */
  final float SELECTOR_WIDTH = 16;                          // width of the selector
  final int HEIGHT_REALESTATE = (int)(height*0.75);         // amount of height the screen allows for viewing players and enemies
  final float PLACEMENT_AWAYFROMBOUNDARY = width*0.3;       // how far from the left and right ends of screen the characters should finalize on
  final int SLIDEIN_INTERVAL = 8;                           // the speed of the slide-ins for characters
  final String HPBAR_PATH = "assets/others/hp.png";         // asset path for hp bar
  final String ARROW_PATH = "assets/sprites/arrow.png";     // asset path for selection arrow
  final int FADE_LENGTH = 70;                               // total time for fade
  
  
  
  /*
      INTIALIZE ALL MEMBERS
  */
  BattlePrompt(Game g, float left, float top, float w, float h, float tsx, float tsy, int cpl, float nld) {
    parent = g;
    
    left_coor = left;
    top_coor = top;
    
    box_width = w;
    box_height = h;
    
    text_startx = tsx;
    text_starty = tsy;
    
    nextline_disp = nld;
    charsperline = cpl;
    
    enemies = new Enemy[ChapterEnemies.NUM_ENEMIES[parent.current_chapter]];
    enemies_pos = new int[ChapterEnemies.NUM_ENEMIES[parent.current_chapter]][];
    for (int i = 0; i < ChapterEnemies.NUM_ENEMIES[parent.current_chapter]; ++i) {
      enemies[i] = new Enemy(parent, ChapterEnemies.ENEMY_NAMES[parent.current_chapter][i], ChapterEnemies.ENEMY_ASSETS[parent.current_chapter][i], 5, 2, 1, 1, 1);
      enemies_pos[i] = new int[2];
    }
    enemies_hpbuffer = new int[ChapterEnemies.NUM_ENEMIES[parent.current_chapter]];
    
    player_pos = new int[2];
    player_pos[1] = HEIGHT_REALESTATE/2 - 25;
    
    fitEnemyHeights();
    // every sprite out of screen first
    player_pos[0] = -50;
    for (int i = 0; i < ChapterEnemies.NUM_ENEMIES[parent.current_chapter]; ++i) {
      enemies_pos[i][0] = width;
      enemies_hpbuffer[i] = enemies[i].rem_health;
    }
    
    hpbar = loadImage(HPBAR_PATH);
    arrow = loadImage(ARROW_PATH);
    
    enemies_left = ChapterEnemies.NUM_ENEMIES[parent.current_chapter];
    
    player_hpbuffer = parent.p.stats.rem_health;
    
  }
  
  
  /*
      RUN & DISPLAY LOOP
  */
  void display() {
    stroke(50);
    strokeWeight(4);
    fill(255);
    rect(left_coor, top_coor, box_width, box_height);
    
    stateSettings();
    
    // display sprites
    image(parent.p.stats.sprite, player_pos[0], player_pos[1], 50, 50);
    for (int i = 0; i < ChapterEnemies.NUM_ENEMIES[parent.current_chapter]; ++i) {
      if (enemies[i] == null) continue;
      image(enemies[i].sprite, enemies_pos[i][0], enemies_pos[i][1]);
    }
    
    // display hp bar for states after 0
    if (state != 0) { 
      
      noStroke();
      
      image(hpbar, player_pos[0]+45, player_pos[1], 100, 20);
      float hp_pctg = 68f * (float)(player_hpbuffer) / (float)(parent.p.stats.health);
      if (hp_pctg <= 68f * 0.25f) fill(255, 0, 0);
      else if (hp_pctg <= 68f * 0.5f) fill(255, 170, 0);
      else fill(100, 100, 255);
      rect(player_pos[0]+62, player_pos[1]+9, hp_pctg, 3);
      if (parent.p.stats.rem_health < player_hpbuffer) --player_hpbuffer;
      
      for (int i = 0; i < ChapterEnemies.NUM_ENEMIES[parent.current_chapter]; ++i) {
        if (enemies[i] == null) continue;
        
        image(hpbar, enemies_pos[i][0]+45, enemies_pos[i][1], 100, 20);
        hp_pctg = 68f * (float)(enemies_hpbuffer[i]) / (float)(enemies[i].health);
        if (hp_pctg <= 68f * 0.25f) fill(255, 0, 0);
        else if (hp_pctg <= 68f * 0.5f) fill(255, 170, 0);
        else fill(100, 100, 255);
        rect(enemies_pos[i][0]+62, enemies_pos[i][1]+9, hp_pctg, 3);
        if (enemies[i].rem_health < enemies_hpbuffer[i]) --enemies_hpbuffer[i];
      }
    }
    
    // handle fades for game over
    if (fade_counter >= 0) {
      if (fade_counter == FADE_LENGTH) gameover_state = true;
      
      float alpha = 255f * (float) fade_counter / FADE_LENGTH;
      fill(0, alpha);
      rect(0, 0, WIDTH, HEIGHT);
      ++fade_counter;
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
    
    if (state == 1) { // user prompts to attack, use a skill, or skip
      fill(0);
      textSize(18);
      text("What will you do", text_startx, text_starty);
      text("this turn?", text_startx, text_starty + 0.7*nextline_disp);
      textSize(28);
      
      if (selection == 0) {
        fill(0);
        setText("Select an enemy to attack.");
        image(arrow, text_startx, text_starty + 2*nextline_disp - SELECTOR_WIDTH, SELECTOR_WIDTH, SELECTOR_WIDTH);
      }
      else fill(150);
      text("ATTACK", text_startx + SELECTOR_WIDTH + 5, text_starty + 2*nextline_disp);
      
      if (parent.p.stats.skill != null) {
        if (selection == 1) {
          fill(0);
          setText("Use a specialized.");
          image(arrow, text_startx, text_starty + 3*nextline_disp - SELECTOR_WIDTH, SELECTOR_WIDTH, SELECTOR_WIDTH);
        }
        else fill(150);
        text("SKILL", text_startx + SELECTOR_WIDTH + 5, text_starty + 3*nextline_disp);
        
        if (selection == 2) {
          fill(0);
          setText("Do nothing for this turn.");
          image(arrow, text_startx, text_starty + 4*nextline_disp - SELECTOR_WIDTH, SELECTOR_WIDTH, SELECTOR_WIDTH);
        }
        else fill(150);
        text("SKIP", text_startx + SELECTOR_WIDTH + 5, text_starty + 4*nextline_disp);
      }
      
      else {
        if (selection == 1) {
          fill(0);
          setText("Do nothing for this turn.");
          image(arrow, text_startx, text_starty + 3*nextline_disp - SELECTOR_WIDTH, SELECTOR_WIDTH, SELECTOR_WIDTH);
        }
        else fill(150);
        text("SKIP", text_startx + SELECTOR_WIDTH + 5, text_starty + 3*nextline_disp);
      }
      return; 
    }
    
    if (state == 2) { // user specifying target
      fill(0);
      text("TARGET?", text_startx, text_starty);
      textSize(20);
      int index = 0;
      for (int i = 0; i < ChapterEnemies.NUM_ENEMIES[parent.current_chapter]; ++i) {
        if (enemies[i] == null) continue;
        
        if (selection == index) {
          fill(0);
          image(arrow, text_startx, text_starty + (index+1)*nextline_disp - SELECTOR_WIDTH, SELECTOR_WIDTH, SELECTOR_WIDTH);
        }
        else fill(150);
                
        text(enemies[i].name, text_startx + SELECTOR_WIDTH + 5, text_starty + (index+1)*nextline_disp);
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
        
        int atk_dmg = (using_skill < 0) ? parent.p.stats.attack() : parent.p.stats.skill.activateAbility(using_skill);
        if (atk_dmg < 0) atk_dmg *= -1;
        enemies[target].takeDamage(atk_dmg);
        String text = enemies[target].name + " has taken a hit.";
        
        /* handling knockouts */
        if (enemies[target].rem_health < 0) {
          text += " " + enemies[target].name + " has been knocked out!";
          enemies[target] = null;
          --enemies_left;
        }
        setText(text);
        response = true;
        selection = 0;
        using_skill = -1;
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
        
        int atk_dmg = enemies[enemy_ptr].attack();
        if (atk_dmg < 0) atk_dmg *= -1;
        parent.p.stats.takeDamage(atk_dmg);
        setText(enemies[enemy_ptr].name + " has attacked you.");
        if (parent.p.stats.rem_health <= 0) {
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
        fade_counter = 0;
        response = true;
      }
      return;
    }
    
    if (state == 7) { // prompt the user to select a skill
      fill(0);
      text("SELECT A SKILL:", text_startx, text_starty);
      textSize(20);
      for (int i = 0; i < parent.p.stats.skill.NUM_IMPLEMENTEDSKILLS[parent.p.stats.skill.skillcolor]; ++i) {
        if (selection == i) {
          fill(0);
          image(arrow, text_startx, text_starty + (i+1)*nextline_disp - SELECTOR_WIDTH, SELECTOR_WIDTH, SELECTOR_WIDTH);
          setText(parent.p.stats.skill.ABIL_DESCRIPTIONS[parent.p.stats.skill.skillcolor][i]);
        } else fill(150);
        
        text(parent.p.stats.skill.ABILITYNAMES[parent.p.stats.skill.skillcolor][i], text_startx + SELECTOR_WIDTH + 5, text_starty + (i+1)*nextline_disp);
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
  
  void handleControls(int ctrl) {
    if (fade_counter >= 0) return;
    
    if (state == 1) {
      if (ctrl == 4) {
        if (selection == 0) state = 2;
        else if (parent.p.stats.skill == null) {
          if (selection == 1) state = 4;
        }
        else if (selection == 1) {
          state = 7;
        }
        else if (selection == 2) {
          state = 4;
        }
        playSound(0);
        selection = 0;
        return;
      }
      
      if (ctrl == 2) {
        if (selection > 0) --selection;
        return;
      }
      
      if (ctrl == 3) {
        int max_selection = (parent.p.stats.skill == null) ? 1 : 2;
        if (selection < max_selection) ++ selection;
        return;
      }
      return;
    }
    
    if (state == 2) {
      if (ctrl == 4) {
        state = 3;
        playSound(0);
        return;
      }
      
      if (ctrl == 2) {
        if (selection > 0) --selection;
        return;
      }
      
      if (ctrl == 3) {
        if (selection < enemies_left-1) ++selection;
        return;
      }
      return;
    }
    
    if (state == 3) {
      if (!response) return;
      if (ctrl == 4) {
        response = false;
        if (enemies_left <= 0) state = 5;
        else state = 4;
        playSound(0);
        return;
      }
      return;
    }
    
    if (state == 4) {
      if (ctrl == 4 && response) {
        response = false;
        playSound(0);
      }
      return;
    }
    
    if (state == 7) {
      if (ctrl == 4) {
        state = 2;
        using_skill = selection;
        playSound(0);
        return;
      }
      
      if (ctrl == 2) {
        if (selection > 0) --selection;
        return;
      }
      
      if (ctrl == 3) {
        int max_selection = parent.p.stats.skill.NUM_IMPLEMENTEDSKILLS[parent.p.stats.skill.skillcolor];
        if (selection < max_selection - 1) ++selection;
        return;
      }
    }
  }
  
  void setText(String t) {
    parent.battle_text.setText(t);
  }
}
