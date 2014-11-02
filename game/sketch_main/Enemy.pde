class Enemy {
  Game parent;
  
  String name;
  
  // max health and remaining health
  int health;
  int rem_health;
  
  // stats
  int attack;
  int defense;
  int speed;
  int impact;
  
  PImage sprite;
  
  Enemy(Game g, String n, String path, int hp, int atk, int def, int spd, int imp) {
    parent = g;
    name = n;
    
    health = hp; rem_health = hp;
    attack = atk;
    defense = def;
    speed = spd;
    impact = imp;
    
    sprite = loadImage(path);
  }
    
}

