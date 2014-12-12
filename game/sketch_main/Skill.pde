class Skill {
  
  PlayerStats parent;
  int skillcolor;
  Random r;
  
  final String COLORNAMES[] = { "White", "Black" };
  
  final int NUM_IMPLEMENTEDSKILLS[] = { 3, 0 };
  
  final String ABILITYNAMES[][] = {
    { "Thrust", "Meditate", "Heal" },
    {}
  };
  
  final String ABIL_DESCRIPTIONS[][] = {
    { // White
      "Attack with a greater force at the expense of losing health.",
      "Slowly gather attack power.",
      "Recover some health."
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
    } else if (index == 1) {
      return white_meditate();
    } else if (index == 2) {
      return white_heal();
    }
    return -1000;
  }
  
  public int white_thrust() {
    r = new Random();
    float magnitude = r.nextFloat() * 0.7f;
    magnitude += 1;
    
    int deduction = (int)(parent.rem_health * 0.15f);
    parent.rem_health -= deduction;
    
    return ((int)((float)parent.attack() * magnitude));
  }
  
  public int white_meditate() {
    int increase = (int) (parent.attack * 0.3f);
    parent.attack += increase;
    
    return 0;
  }
  
  public int white_heal() {
    int num = (int)(parent.health * -0.3f);
    return num;
  }
  
}
