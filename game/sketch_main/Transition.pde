public class Transition {
  Game parent;
  
  final String CHAPTER = "Chapter ";
  String chapterText;
  
  final String CHAPTER_TITLES[] = {
    "Introduction"
  };
  
  boolean fadeIn = true;
  boolean done = false;
  
  public final int FADE_LENGTH = 75;
  public int fade_counter;
  
  public final float TITLE_X = width*0.5;
  public final float TITLE_Y = height*0.5;
  
  public Transition(Game g) {
    parent = g;
    chapterText = CHAPTER + " " + parent.current_chapter;
    fade_counter = FADE_LENGTH;
  }
  
  void display() {
    background(0);
    textSize(36);
    
    if (!done) {
      if (fadeIn) {
        if (--fade_counter > 0) {
          float pctg = 255f * ((float) (FADE_LENGTH - fade_counter)/FADE_LENGTH);
          fill(pctg);
          text(chapterText, TITLE_X-(textWidth(chapterText)/2), TITLE_Y);
        } else {
          fill(255);
          text(chapterText, TITLE_X-(textWidth(chapterText)/2), TITLE_Y);
          fade_counter = FADE_LENGTH;
          fadeIn = false;
        }
      } else {
        if (--fade_counter > 0) {
          float pctg = 255f * ((float) fade_counter/FADE_LENGTH);
          fill(pctg);
          text(chapterText, TITLE_X-(textWidth(chapterText)/2), TITLE_Y);
        } else {
          done = true;
        }
      }
      textSize(22);
    } else {
      fill(255);
      text(chapterText, TITLE_X-(textWidth(chapterText)/2), TITLE_Y);
      textSize(22);
    }
  }
  
}
