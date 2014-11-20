static class ChapterNpcs {  
  static String startscenes[] = {
    "gametexts/c0/1_Opening_Scene.txt",
    "gametexts/c1/4_Question.txt",
    "gametexts/c2/9_Walking_Alone.txt"
  };
  
  static String spritepaths[][] = {
    { // Chapter 0
      "assets/sprites/enemies/cicada.png"
    }, { // Chapter 1
      "assets/sprites/enemies/cicada.png",
      "",
      "assets/sprites/enemies/seedcorn.png"
    }, { // Chapter 2
      "assets/sprites/enemies/cicada.png",
      "",
      "assets/sprites/enemies/seedcorn.png",
      "",
      "assets/sprites/enemies/worm.png",
      "assets/sprites/enemies/rabbit-sprite.png"
    }
  };
  
  static int spritebottoms[][] = {
    { // Chapter 0
      10
    }, { // Chapter 1
      10,
      0, // empty
      5
    }, { // Chapter 2
      5,
      0,
      12,
      0,
      5,
      10
    }
  };
  
  static String STARTING_RIGHTPROFS[] = {
    "", // Chapter 0
    "assets/sprites/profiles/cicada_sq.png", // Chapter 1
    "" // Chapter 2
  };
}
