public class Transition {
  
  /* MEMBERS */
  Game parent;
  String chapterText;
  PImage bg;
  
  /* CONTROL VARIABLES */
  boolean fadeIn = true;
  boolean done = false;
  int fade_counter;
  
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
  final String ASSET_BACKGROUND = "assets/backgrounds/foresttactile.png";
  
  
  /*
      INTIALIZE ALL MEMBERS
  */
  public Transition(Game g) {
    parent = g;
    chapterText = CHAPTER + " " + parent.current_chapter;
    fade_counter = FADE_LENGTH;
    bg = loadImage(ASSET_BACKGROUND);
  }
  
  
  /*
      RUN & DISPLAY LOOP
  */
  void display() {
    image(bg, 0, 0, width, height);
    textSize(36);
    
    if (!done) {
      if (fadeIn) {
        if (--fade_counter > 0) {
          float pctg = 255f * ((float) (FADE_LENGTH - fade_counter)/FADE_LENGTH);
          fill(255, pctg);
          text(chapterText, TITLE_X-(textWidth(chapterText)/2), TITLE_Y - NEWLINE_DISPARITY);
          text(CHAPTER_TITLES[parent.current_chapter], TITLE_X-(textWidth(CHAPTER_TITLES[parent.current_chapter])/2), TITLE_Y + NEWLINE_DISPARITY);
        } else {
          fill(255, 255);
          text(chapterText, TITLE_X-(textWidth(chapterText)/2), TITLE_Y - NEWLINE_DISPARITY);
          text(CHAPTER_TITLES[parent.current_chapter], TITLE_X-(textWidth(CHAPTER_TITLES[parent.current_chapter])/2), TITLE_Y + NEWLINE_DISPARITY);
          fade_counter = FADE_LENGTH;
          fadeIn = false;
        }
      } else {
        if (--fade_counter > 0) {
          float pctg = 255f * ((float) fade_counter/FADE_LENGTH);
          fill(255, pctg);
          text(chapterText, TITLE_X-(textWidth(chapterText)/2), TITLE_Y - NEWLINE_DISPARITY);
          text(CHAPTER_TITLES[parent.current_chapter], TITLE_X-(textWidth(CHAPTER_TITLES[parent.current_chapter])/2), TITLE_Y + NEWLINE_DISPARITY);
        } else {
          done = true;
        }
      }
      textSize(22);
    } else {
      fill(255);
      text(chapterText, TITLE_X-(textWidth(chapterText)/2), TITLE_Y - NEWLINE_DISPARITY);
      text(CHAPTER_TITLES[parent.current_chapter], TITLE_X-(textWidth(CHAPTER_TITLES[parent.current_chapter])/2), TITLE_Y + NEWLINE_DISPARITY);
      textSize(22);
    }
  }
  
}
