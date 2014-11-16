class Player {
  
  /* MEMBERS */
  Game parent;                   // Game parent
  PImage sprites[];              // the sprites of the player
  PlayerStats stats;             // player's battle statistics
  PImage emote;                  // player's emoticons
  
  /* CONTROL VARIABLES */
  int sprite_num = 0;            // the index of the player sprite
  int direction = 0;             // direction facing; left = 0, right = 1, up = 2, down = 3
  float sprite_counter = 0f;     // time counter for sprite animation
  int emote_time = -1;           // time counter for emoticon animation
  boolean isEllipse = false;     // whether the emoticon is the ellipse (animation)
  
  /* CONSTANTS */  
  final float SPRITE_SPEED = 0.8f;                                           // speed of which the sprite animates
  final int EMOTE_LENGTH = 51;                                               // time length of emoticon being alive
  final String ASSETPATH_SURPRISE = "assets/sprites/excl.png";               // asset path for exclamation mark
  final String ASSETPATH_QUESTION = "assets/sprites/question.png";           // asset path for question mark 
  final String ASSETPATH_ELLIPSE[] = {                                       // asset paths for ellipses
    "assets/sprites/ellip01.png",
    "assets/sprites/ellip02.png",
    "assets/sprites/ellip03.png"
  };
  final int SPRITE_SIZE = 16;                                                // total number of sprites for player sprites
  final String SPRITE_PATHS[] = {                                            // asset paths for player sprites
    "assets/sprites/player/left0.png",
    "assets/sprites/player/left1.png",
    "assets/sprites/player/left2.png",
    "assets/sprites/player/left3.png",
    "assets/sprites/player/right0.png",
    "assets/sprites/player/right1.png",
    "assets/sprites/player/right2.png",
    "assets/sprites/player/right3.png",
    "assets/sprites/player/up0.png",
    "assets/sprites/player/up1.png",
    "assets/sprites/player/up2.png",
    "assets/sprites/player/up3.png",
    "assets/sprites/player/down0.png",
    "assets/sprites/player/down1.png",
    "assets/sprites/player/down2.png",
    "assets/sprites/player/down3.png"
  };
  final String SPRITE_PROFILE = "assets/sprites/profiles/beanny_sq.png";     // asset path for sprite profile
  
  
  
  /*
      INTIALIZE ALL MEMBERS
  */
  Player(Game g) {
    parent = g;
    
    sprites = new PImage[SPRITE_SIZE];
    for (int i = 0; i < SPRITE_SIZE; ++i) {
      sprites[i] = loadImage(SPRITE_PATHS[i]);
    }
    
    stats = new PlayerStats(g, SPRITE_PATHS[4], 10, 4, 2, 2, 2);
    
    // emote loaded dynamically when passed the function
  } 
  
  
  /*
      RUN & DISPLAY LOOP
  */
  void display(int w, int h) {
    image(sprites[4 * direction + sprite_num], w, h, 50, 50);
    
    if (emote_time >= 0) {
      if (isEllipse && emote_time == 2*EMOTE_LENGTH/3) emote = loadImage(ASSETPATH_ELLIPSE[1]);
      else if (isEllipse && emote_time == EMOTE_LENGTH/3) emote = loadImage(ASSETPATH_ELLIPSE[2]);
      
      image(emote, width/2 + 40, height/2 - 15);
      --emote_time;
    }
  }
  
  void move(float x, float y) {
    if (x == 0 && y == 0) return;
    if (x != 0 && y != 0) return;
    
    int dir;
    if (y == 0) {
      if (x > 0) dir = 0; // left
      else dir = 1; // right
    } else {
      if (y > 0) dir = 2; // up
      else dir = 3; // down
    }
    
    if (dir == direction) {
      sprite_counter += abs(x) + abs(y);
      if (sprite_counter > SPRITE_SPEED) {
        sprite_counter -= SPRITE_SPEED;
        sprite_num = (sprite_num + 1) % 4;
      }
    } else {
      direction = dir;
      sprite_num = 0;
    }
  }
  
  void setEmote(int index, boolean e) {
     if (index == 1) {
       emote = loadImage(ASSETPATH_SURPRISE);
     } else if (index == 2) {
       emote = loadImage(ASSETPATH_QUESTION);
     } else if (index == 3) {
       emote = loadImage(ASSETPATH_ELLIPSE[0]);
     }
     
     emote_time = EMOTE_LENGTH;
     isEllipse = e;
  }
}
