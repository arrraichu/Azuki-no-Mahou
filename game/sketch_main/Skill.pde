class Skill {
  
  PlayerStats parent;
  int skillcolor;
  Random r;
  
  final String COLORNAMES[] = { "White", "Black" };
  
  final int NUM_IMPLEMENTEDSKILLS[] = { 2, 0 };
  
  final String ABILITYNAMES[][] = {
    { "Thrust", "Meditate" },
    {}
  };
  
  final String ABIL_DESCRIPTIONS[][] = {
    { // White
      "Attack with a greater force.",
      "Slowly gather attack power."
    },
    {}
  };
  
  Skill(PlayerStats p, int colorindex) {
    parent = p;
    skillcolor = colorindex;
  }
  
  int activateAbility(int index) {
    if (index == 0) {
      if (skillcolor == 0) {
        return white_thrust();
      }
    }
    return 0;
  }
  
  public int white_thrust() {
    r = new Random();
    float magnitude = r.nextFloat() * 0.7f;
    magnitude += 1;
    return ((int)((float)parent.attack() * magnitude));
  }
  
  public int white_meditate() {
    return 0;
  }
  
}
