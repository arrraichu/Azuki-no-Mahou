class PlayerStats {
  
  /* MEMBERS */
  Game parent;
  int health;
  int rem_health;
  int attack;
  int defense;
  int speed;
  int impact;
  PImage sprite;
  Random r;
  Skill skill;
  
  
  /*
      INTIALIZE ALL MEMBERS
  */
  PlayerStats(Game g, String path, int hp, int atk, int def, int spd, int imp) {
    parent = g;
    health = hp; rem_health = hp;
    attack = atk;
    defense = def;
    speed = spd;
    impact = imp;
    
    sprite = loadImage(path);
    
    skill = new Skill(this, 0);
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
      atk *= 2;
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
    
    if (atk > 0) {
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
    }
    
    rem_health -= atk;
    if (rem_health > health) rem_health = health;
    
    return atk;
  }
}
