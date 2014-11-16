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
  
  Random r;
  
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
  
  /*
      DEAL AN ATTACK
      RETURNS THE DAMAGE TO DEAL
      IF THE NUMBER IS NEGATIVE, THE ABS.VALUE IS THE DAMAGE, AND CRITICAL DAMAGE WAS DEALT
      IF THE NUMBER IS ZERO, THE ATTACK DID NOT GO THROUGH
  */
  public int attack() {
    int atk = attack;
    
    r = new Random();
    if (r.nextFloat() < (float) impact / 255f) {
      atk *= -2;
      println("critical hit");
    }
    return atk;
  }
  
  /*
      TAKE DAMAGE
      RETURNS THE DAMAGE TAKEN
      IF THE NUMBER IS ZERO, THE ATTACK MISSED
  */
  public int takeDamage(int atk) {
    float def = (float) defense;
    float spd = (float) speed;
    
    r = new Random();
    float chance = r.nextFloat();
    if (spd >= (float) atk) {
      if (chance < 0.2f) return 0;
    }
    if (spd >= (float) atk * 2f) {
      if (chance < 0.5f) return 0;
    }
    if (spd >= (float) atk * 5f) {
      if (chance < 0.8f) return 0;
    }
    
    if (def >= (float) atk * 3f) atk /= 2;
    else if (def >= (float) atk * 2f) atk = (int)((float) atk * 0.67f);
    else if (def >= (float) atk * 0.75f) atk = (int)((float) atk * 0.9f);
    else if (def >= (float) atk) atk = (int)((float) atk * 0.8f);
    
    rem_health -= atk;
    return atk;
  }
    
}

