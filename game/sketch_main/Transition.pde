public class Transition {
  
  /* MEMBERS */
  Game parent;
  String chapterText;
  PImage bg;
  
  /* CONTROL VARIABLES */
  boolean fadeIn = true;
  boolean done = false;
  int fade_counter;
  int current_chapter = -1;
  
  /* CONSTANTS */
  final String CHAPTER = "Chapter ";
  final String CHAPTER_TITLES[] = {
    "{ Introduction }",
    "{ Into the World }",
    "{ Don't Anger the Rabbit }"
  };
  final int FADE_LENGTH = 75;
  final float TITLE_X = width*0.5;
  final float TITLE_Y = height*0.5;
  final int NEWLINE_DISPARITY = 35;
  final String ASSET_BACKGROUND[] = {
    "assets/backgrounds/transition_0.png",
    "assets/backgrounds/transition_1.png",
    "assets/backgrounds/transition_2.png"
  };
  
  
  /*
      INTIALIZE ALL MEMBERS
  */
  public Transition(Game g) {
    parent = g;
    chapterText = CHAPTER + " " + parent.current_chapter;
    fade_counter = FADE_LENGTH;
  }
  
  
  /*
      RUN & DISPLAY LOOP
  */
  void display() {
    if (bg == null || current_chapter != parent.current_chapter) {
      current_chapter = parent.current_chapter;
      bg = loadImage(ASSET_BACKGROUND[current_chapter]);
    }
    
    textSize(36);
    
    if (!done) {
      if (fadeIn) {
        if (--fade_counter > 0) {
          float pctg = 255f * ((float) (FADE_LENGTH - fade_counter)/FADE_LENGTH);
          tint(255, pctg);
          image(bg, 0, 0, width, height);
//          fill(255, pctg);
//          text(chapterText, TITLE_X-(textWidth(chapterText)/2), TITLE_Y - NEWLINE_DISPARITY);
//          text(CHAPTER_TITLES[parent.current_chapter], TITLE_X-(textWidth(CHAPTER_TITLES[parent.current_chapter])/2), TITLE_Y + NEWLINE_DISPARITY);
        } else {
          tint(255, 255);
          image(bg, 0, 0, width, height);
//          fill(255, 255);
//          text(chapterText, TITLE_X-(textWidth(chapterText)/2), TITLE_Y - NEWLINE_DISPARITY);
//          text(CHAPTER_TITLES[parent.current_chapter], TITLE_X-(textWidth(CHAPTER_TITLES[parent.current_chapter])/2), TITLE_Y + NEWLINE_DISPARITY);
          fade_counter = FADE_LENGTH;
          fadeIn = false;
        }
      } else {
        if (--fade_counter > 0) {
          float pctg = 255f * ((float) fade_counter/FADE_LENGTH);
          tint(255, pctg);
          image(bg, 0, 0, width, height);
//          fill(255, pctg);
//          text(chapterText, TITLE_X-(textWidth(chapterText)/2), TITLE_Y - NEWLINE_DISPARITY);
//          text(CHAPTER_TITLES[parent.current_chapter], TITLE_X-(textWidth(CHAPTER_TITLES[parent.current_chapter])/2), TITLE_Y + NEWLINE_DISPARITY);
        } else {
          noTint();
          done = true;
        }
      }
      textSize(22);
    } else {
//      fill(255);
//      text(chapterText, TITLE_X-(textWidth(chapterText)/2), TITLE_Y - NEWLINE_DISPARITY);
//      text(CHAPTER_TITLES[parent.current_chapter], TITLE_X-(textWidth(CHAPTER_TITLES[parent.current_chapter])/2), TITLE_Y + NEWLINE_DISPARITY);
      noTint();
      textSize(22);
    }
  }
  
}
