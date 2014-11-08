class TitleScreen {  
  final int PICTURE_FADE_LENGTH = 50;
  final int LOGO_FADE_LENGTH = 50;
  final int INTERMEDIATE_WAIT_LENGTH = 50;
  final int BLINK_LENGTH = 50;
  
  int pf_time;
  int lf_time;
  int iw_time;
  int blink_interval;
  boolean blink_on;
  
  boolean ready;
  
  PImage bg;
  PImage logo;
  
  int logo_x = (int) (width * 0.45);
  int logo_y = (int) (height * 0);
  int logo_width = (int) (width/2);
  int logo_height = (int) (height/2);
  
  final String pressText = "Press SPACEBAR to Start.";
  
  TitleScreen(String bgpath, String logopath) {
    pf_time = PICTURE_FADE_LENGTH;
    lf_time = LOGO_FADE_LENGTH;
    iw_time = INTERMEDIATE_WAIT_LENGTH;
    blink_interval = BLINK_LENGTH;
    blink_on = true;
    
    bg = loadImage(bgpath);
    logo = loadImage(logopath);
    
    ready = false;
  } 
  
  void run() {
    image(bg, 0, 0, width, height);
    if (pf_time > 0) {
      float pf_pctg = 255f * (float) pf_time / PICTURE_FADE_LENGTH;
      fill(0, 0, 0 , pf_pctg);
      rect(0, 0, width, height);
      
      --pf_time;
    }
    else if (lf_time > 0) {
      float logo_pctg = 255f * (float) lf_time / LOGO_FADE_LENGTH;
      logo_pctg = 255f - logo_pctg;
      tint(255, logo_pctg);
      image(logo, logo_x, logo_y, logo_width, logo_height);
      
      --lf_time;
    }
    else if (iw_time > 0) {
      lf_time = 0;
      image(logo, logo_x, logo_y, logo_width, logo_height);
      float text_pctg = 255f * (float) iw_time / INTERMEDIATE_WAIT_LENGTH;
      text_pctg = 255f - text_pctg;
      textSize(33);
      fill(0, text_pctg);
      text(pressText, width * 0.52, height * 0.67);
      

      --iw_time;
    }
    
    else {
      image(logo, logo_x, logo_y, logo_width, logo_height);
      fill(0);
      textSize(33);
      if (blink_on) text(pressText, width * 0.52, height * 0.67);
      if (--blink_interval <= 0) {
        blink_interval = BLINK_LENGTH;
        blink_on = !blink_on;
      }
      textSize(22);
      noTint();
      ready = true;
    }
  }
}
