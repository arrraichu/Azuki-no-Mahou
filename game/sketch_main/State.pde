static class State {
  
  /* MEMBERS */
  
  /* CONTROL VARIABLES */
  
  /* CONSTANTS */
  static int NUM_STATES[] = {
    1, 3, 5
  };
  static int STATE_COORS[][][] = {
    { // Chapter 0
      {58, 76}
    },
    { // Chapter 1
      {162, 44}, {156, 72}, {112, 51}
    },
    { // Chapter 2
      {71, 45}, {51, 57}, {37, 41}, {24, 43}, {6, 76}
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
  
  // text file states that must be always on
  static int ALWAYS_ONS[] = {0, 10, 0};
  static int ALWAYS_ON[][][] = {
    {},
    {
      {79, 53}, // 1
      {68, 93}, // 3
      {66, 9}, // 4
      {62, 28}, // 5
      {61, 77}, // 6
      {46, 112}, // 7
      {37, 24}, // 8
      {11, 34}, // 9
      {35, 46}, // 10
      {28, 95} // 11
    },
    {}
  };
  static String ALWAYS_ON_FILES[][] = {
    {},
    {
      "gametexts/c1/bsp_01.txt",
      "gametexts/c1/bsp_03.txt",
      "gametexts/c1/bsp_04.txt",
      "gametexts/c1/bsp_05.txt",
      "gametexts/c1/bsp_06.txt",
      "gametexts/c1/bsp_07.txt",
      "gametexts/c1/bsp_08.txt",
      "gametexts/c1/bsp_09.txt",
      "gametexts/c1/bsp_10.txt",
      "gametexts/c1/bsp_11.txt"
    },
    {}
  };
  
  private State() {}
  
  public static boolean isCoor(int chapter, int state, int x, int y) {
    if (chapter > CHAPTERS_IMPLEMENTED) return false;
    if (state >= NUM_STATES[chapter]) return false;
    
    if (x != STATE_COORS[chapter][state][0]) return false;
    if (y != STATE_COORS[chapter][state][1]) return false;
    
    return true;
  }
  
  public static int isPerm(int chapter, int x, int y) {
    if (ALWAYS_ONS[chapter] <= 0) return -1;
    
    for (int i = 0; i < ALWAYS_ONS[chapter]; ++i) {
      if (ALWAYS_ON[chapter][i][0] == x && ALWAYS_ON[chapter][i][1] == y) return i;
    }
    
    return -1;
  }
}
