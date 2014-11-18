static class State {
  
  /* MEMBERS */
  
  /* CONTROL VARIABLES */
  
  /* CONSTANTS */
  static int NUM_STATES[] = {
    1, 3, 5
  };
  static int STATE_COORS[][][] = {
    { // Chapter 0
      {19, 67}
    },
    { // Chapter 1
      {76, 44}, {70, 72}, {17, 50}
    },
    { // Chapter 2
      {78, 48}, {51, 57}, {37, 51}, {19, 59}, {6, 76}
    }
  };
  static String SPEECH_PATHS[][] = {
    { // Chapter 0
      "gametexts/c0/2_Meeting_Cadi.txt"
    },
    { // Chapter 1
      "gametexts/c1/5_Problem.txt",
      "gametexts/c1/6_More_Seeds.txt",
      "gametexts/c1/7_All_Alone.txt"
    },
    { // Chapter 2
      "gametexts/c2/10_So_Many_Seeds.txt",
      "gametexts/c2/11_Reunited.txt",
      "gametexts/c2/12_Not_far.txt",
      "gametexts/c2/13_Rabbit.txt",
      "gametexts/c2/14_Found_the_Worm.txt"
    }
  };
  
  static String SPRITE_PROFILES[][] = {
    { // Chapter 0
      "assets/sprites/profiles/cicada_sq.png"
    },
    { // Chapter 1
      "assets/sprites/profiles/cicada_sq.png",
      "",
      "assets/sprites/profiles/cicada_sq.png"
    },
    { // Chapter 2
      "",
      "assets/sprites/profiles/cicada_sq.png",
      "assets/sprites/profiles/cicada_sq.png",
      "assets/sprites/profiles/cicada_sq.png",
      "assets/sprites/profiles/cicada_sq.png"
    }
  };
  
  static String AFTERBATTLE_TEXTS[][] = {
    { // Chapter 0
      "gametexts/c0/3_After_the_Fight.txt"
    },
    { // Chapter 1
      "", "", "gametexts/c1/8_New_Enemies.txt"
    },
    { // Chapter 2
      "", "", "", "", "gametexts/c2/15_Wake_Up_Call.txt"
    }
  };
  
  private State() {}
  
  public static boolean isCoor(int chapter, int state, int x, int y) {
    if (chapter > CHAPTERS_IMPLEMENTED) return false;
    if (state >= NUM_STATES[chapter]) return false;
    
    if (x != STATE_COORS[chapter][state][0]) return false;
    if (y != STATE_COORS[chapter][state][1]) return false;
    
    return true;
  }
}
