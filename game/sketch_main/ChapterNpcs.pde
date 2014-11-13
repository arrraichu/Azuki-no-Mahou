static class ChapterNpcs {
  static int NUM_CHAPTERS = 1;
  
  static String startscenes[] = {
    "gametexts/c0/1_Opening_Scene.txt",
    "gametexts/c1/4_Question.txt"
  };
  
  static String spritepaths[][] = {
    { // Chapter 0
      "assets/sprites/enemies/cicada.png"
    }, { // Chapter 1
      "assets/sprites/enemies/cicada.png",
      "",
      "assets/sprites/enemies/seedcorn.png"
    }
  };
  
  static int spritebottoms[][] = {
    { // Chapter 0
      10
    }, { // Chapter 1
      9,
      5
    }
  };
  
  static String spriteprofiles[][] = {
    { // Chapter 0
      "assets/sprites/profiles/cicada_sq.png"
    }, { // Chapter 1
      "assets/sprites/profiles/cicada_sq.png",
      "", // no ants
      "" // no profile for seedcorns
    }  
  };
  
  static String speechpaths[][] = {
    { // Chapter 0
      "gametexts/c0/2_Meeting_Cadi.txt"
    }, { // Chapter 1
      "gametexts/c1/7_All Alone.txt", // talking to Cadi
      "", // leave empty
      "gametexts/c1/5_Problem.txt" // approaching a seedcorn
    }
  };
  
  // the second index correlates to which asset triggered the battle
  static String afterbattlepaths[][] = {
    { // Chapter 0
      "gametexts/c0/3_After_the_Fight.txt" // Cadi
    }, { // Chapter 1
      "gametexts/c1/8_New Enemies.txt", // Cadi
      "", // no ants in chapter
      "" // no battle in seedcorn
    }
  };
}
