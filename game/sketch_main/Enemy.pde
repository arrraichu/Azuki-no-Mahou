class Enemy {
  Game parent;
  
  // max health and remaining health
  int health;
  int rem_health;
  
  // stats
  int attack;
  int defense;
  int speed;
  int impact;
  
  Enemy(Game g, int hp, int atk, int def, int spd, int imp) {
    parent = g;
    health = hp; rem_health = hp;
    attack = atk;
    defense = def;
    speed = spd;
    impact = imp;
  }
    
}

