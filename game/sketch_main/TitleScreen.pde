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
  boolean acceptkey;
  boolean controlsmode = false;
  
  PImage bg;
  PImage logo;
  PImage controls;
  PImage a_button[];
  
  int logo_x = (int) (width * 0.45);
  int logo_y = (int) (height * 0);
  int logo_width = (int) (width/2);
  int logo_height = (int) (height/2);
  
  final String pressText = "Press A key to Start.";
  final String ASSET_CONTROLSPATH = "assets/backgrounds/controls.png";
  final String PRESS_A_ASSET[] = {
    "assets/sprites/text_completion1.png",
    "assets/sprites/text_completion2.png"
  };
  
  boolean fadeDone = false;
  boolean fadeIn = true;
  int fade_counter;
  final int FADE_LENGTH = 120;
  
  TitleScreen(String bgpath, String logopath) {
    pf_time = PICTURE_FADE_LENGTH;
    lf_time = LOGO_FADE_LENGTH;
    iw_time = INTERMEDIATE_WAIT_LENGTH;
    blink_interval = BLINK_LENGTH;
    blink_on = true;
    
    bg = loadImage(bgpath);
    logo = loadImage(logopath);
    controls = loadImage(ASSET_CONTROLSPATH);
    a_button = new PImage[2];
    a_button[0] = loadImage(PRESS_A_ASSET[0]);
    a_button[1] = loadImage(PRESS_A_ASSET[1]);
    
    ready = false;
    acceptkey = false;
    
    fade_counter = FADE_LENGTH;
  } 
  
  void run() {
    if (ready) {
      if (!controlsmode) {
        controlsmode = true;
        fade_counter = FADE_LENGTH;
      }
      else {
        starting_state = false;
        resetBgm();
      }
      ready = false;
      acceptkey = false;
    }
    
    if (!controlsmode) {
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
        
        textSize(22);
        acceptkey = true;
  
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
        acceptkey = true;
      }
    } else {
      if (!fadeDone) {
        if (fadeIn) {
          if (--fade_counter > 0) {
            float pctg = 255f * ((float) (FADE_LENGTH - fade_counter)/FADE_LENGTH);
            tint(255, pctg);
            image(controls, 0, 0, width, height);
          } else {
            tint(255, 255);
            image(controls, 0, 0, width, height);
            fade_counter = FADE_LENGTH;
            fadeIn = false;
          }
        } else {
          if (--blink_interval <= 0) {
            blink_interval = BLINK_LENGTH;
            blink_on = !blink_on;
          }
          int blink_index = (blink_on) ? 0 : 1;
          image(a_button[blink_index], width*0.95, height*0.92, 30, 30);
          acceptkey = true;
        }
        textSize(22);
      }
    }
  }
}
