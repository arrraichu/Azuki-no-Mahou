static class State {
  
  /* MEMBERS */
  
  /* CONTROL VARIABLES */
  
  /* CONSTANTS */
  static int NUM_CHAPTERS = 2;
  static int NUM_STATES[] = {
    1, 3
  };
  static int STATE_COORS[][][] = {
    {
      {19, 67}
    },
    {
      {70, 72},{54, 50},{30, 49}
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
    }
  };
  
  private State() {}
  
  public static boolean isCoor(int chapter, int state, int x, int y) {
    if (chapter >= NUM_CHAPTERS) return false;
    if (state >= NUM_STATES[chapter]) return false;
    
    if (x != STATE_COORS[chapter][state][0]) return false;
    if (y != STATE_COORS[chapter][state][1]) return false;
    
    return true;
  }
}
