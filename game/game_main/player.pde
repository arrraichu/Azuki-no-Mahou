class Player {
  PImage sprites[] = new PImage[PlayerSprites.SIZE];
  int sprite_num;
  int direction; // left = 0, right = 1, up = 2, down = 3
  
  final float SPRITE_SPEED = 0.30f;
  float sprite_counter;
  
  Player() {
    for (int i = 0; i < PlayerSprites.SIZE; ++i) {
      sprites[i] = loadImage(PlayerSprites.paths[i]);
    }
    
    direction = 0; sprite_num = 0;
    sprite_counter = 0f;
  } 
  
  void display(int w, int h) {
    image(sprites[4 * direction + sprite_num], w, h, 50, 50);
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
//      System.out.println(sprite_counter);
      if (sprite_counter > SPRITE_SPEED) {
        sprite_counter -= SPRITE_SPEED;
        sprite_num = (sprite_num + 1) % 4;
      }
    } else {
      direction = dir;
      sprite_num = 0;
    }
  }
}
