class Pattern {
  ControlGroup cg;
  Key k;  
  boolean active, bpmSync, momentary;
  int mode;
  
  Particle[] p;
  int particleCount = 10;
  PImage img;  
  int imgNo = 0;
  Osc osc;
  LinOsc linOsc;
  long time = 0;
  
  float hg = 1.0;
  float sg = 1.0;
  float bg = 1.0;
  
  long lastToggle = 0;
//  boolean toggle = false;
  int toggleCounter = 0;
  
  float log127 = log(127);
  
  Pattern(int mode) {
    this.mode = mode;
    cg = new ControlGroup(mode);
    k = new Key(mode);
    active = false;
    bpmSync = false;
    momentary = false;
    osc = new Osc();
    linOsc = new LinOsc();
/*    
    p = new Particle[particleCount];
    for (int i = 0; i < particleCount; i++) {
      p[i] = new Particle();
    }
*/    
  }
  
  void keyChange(int newValue) {
    if (cg.topButton == 0) {  // momentary off
      if (newValue == 127) {
        if (active) {active = false;}
        else {
          active = true;
          osc.seed(millis());
          linOsc.seed(millis());
        }
      }
    }
    else {
      if (newValue == 127) {
        active = true;
        osc.seed(millis());
        linOsc.seed(millis());
      }
      else {active = false;}
    }
  }
  
  void render(LightBawr lb, long time) {
    this.time = time;
    
    if (mode == 6) {active = true;}
    
    if (active) {
      switch(mode) {
        case 0: pastels(lb); break;
        case 1: colorWave(lb); break;
        case 2: scan(lb,1); break;
        case 3: scan(lb,2); break;
        case 4: scan(lb,3); break;
        case 5: oneColor(lb); break;
        case 6: wash(lb); break;
        case 7: strobe(lb); break;
        case 8: globals(lb); break;
        case 9: break;
        case 10: break;
        case 11: break;
        case 12: break;
        case 13: break;
        case 14: killAll(); break;
        case 15: break;
        case 16: break;
        case 17: break;
        case 18: break;
        case 19: break;
        case 20: break;
        case 21: break;
        case 22: break;
        case 23: break;
        case 24: break;
      }
    }
  }
  
  void pastels(LightBawr lb) {
    float r, g, b;
    float period = map(cg.fader,0,127,20,0.1);
    float spread = map(cg.encoder,0,127,0,10);
    float oscVal = osc.update(time, period);    
    
    colorMode(RGB, 1.0);  
    r = (sin(oscVal-lb.loc.x/RENDER_WIDTH*spread*PI)+1)/2;
    g = (cos(oscVal/1.3-lb.loc.x/RENDER_WIDTH*spread*PI)+1)/2;
    b = (-sin(oscVal/0.7-lb.loc.x/RENDER_WIDTH*3*PI)+1)/2;
    lb.c = color(r, g, b);
  }  
  
  void colorWave(LightBawr lb) {
    float h, s, b;
    float period = map(cg.fader,0,127,20,0.5);    
    float spread = map(cg.encoder,0,127,0,1);
    float oscVal;
    
    if (cg.bottomButton == 127){period *= -1;}
    
    oscVal = osc.update(time, period);
    
    colorMode(HSB, 1.0);
    h = (sin(oscVal-lb.loc.x/100*spread*PI)+1)/2;
    s = 1;
    b = 1;
    lb.c = color(h, s, b);
  }
  
  void scan(LightBawr lb, int imgSet) {
    int imgsPer = 4;
    int offset = cg.fader;
    int imgCount = getFileCount(str(imgSet));
    int newImgNo = 0;
    
    float period = map(cg.fader,0,127,12,0.5);
    float oscVal;    
    
    oscVal = linOsc.update(time, period);
    if (cg.bottomButton == 127) {offset = int(map(oscVal,0,1,0,127));}    
    
//    println("IMAGE COUNT: " + imgCount);
    
    if (imgCount > 0) {
      if (imgCount < imgsPer) {
        newImgNo = round(map(cg.encoder,0,127,1,imgCount));
      }
      else {
//        if (cg.bottomButton == 127) {
//          newImgNo = round(map(cg.encoder,0,127,imgsPer+1,min(imgCount,imgsPer*2)));
//        }
//        else {
          newImgNo = round(map(cg.encoder,0,127,1,imgsPer));
//        }
      }
      
      if (newImgNo != imgNo) {
        imgNo = newImgNo;
        img = loadImage(imgSet + "/" + imgNo + ".png");
        println("IMG: " + imgSet + "/" + imgNo + ".png");
      }
      
      lb.c = img.get(int(lb.loc.x/10), offset);
      colorMode(HSB, 1.0);
      if (brightness(lb.c) < 0.05) { lb.c = color(hue(lb.c),saturation(lb.c),0);}
    }
  } 
  
  void wash(LightBawr lb) {  
    colorMode(HSB,1.0);
    float b;
    
    if (lb.loc.y > 0) {
      b = brightness(lb.c)*map(cg.encoder,0,127,0,1);
    }
    else {b = brightness(lb.c)*map(cg.fader,0,127,0,1);}
    
    lb.c = color(hue(lb.c),saturation(lb.c),b);    
  }
  
  void oneColor(LightBawr lb) {    
    colorMode(HSB,1.0);
    
    if (cg.bottomButton == 127) {hg = map(cg.fader,0,127,0,1);}
    else {sg = map(cg.fader,0,127,0,1);}
    bg = map(cg.encoder,0,127,0,1);
    lb.c = color(hg,sg,bg);
  }  
  
  void strobe(LightBawr lb) {
    int minRate = 28;
    int toggleSections = 2;
    int rate = round(map(cg.encoder,0,127,minRate,250));
    
    if (cg.bottomButton == 127) {toggleSections = 3;};
    
    colorMode(HSB,1.0);
    

    /*    
    if ((millis() - lastToggle) > rate) {
      if (toggle) {toggle = false;} else {toggle = true;}
      lastToggle = millis();
    }
    
    if (toggle) {lb.c = color(0,0,0);}
    */
    
   if ((time - lastToggle) > rate) {
      toggleCounter++;
      lastToggle = time;
    }
    
    if (toggleCounter < (toggleSections-1)) {lb.c = color(0,0,0);}
    else if (toggleCounter == toggleSections) {toggleCounter = 0;}
  }  
  
  void globals(LightBawr lb) {
    
    colorMode(HSB,1.0);
    float h = hue(lb.c);
    float s = saturation(lb.c);
    float b = brightness(lb.c);
    
    if (cg.bottomButton == 127) {
      h += map(cg.fader,0,127,0,1);
      if (h > 1) {h -= 1;}
    }
    else {s *= map(cg.fader,0,127,0,1);}
    b *= map(cg.encoder,0,127,0,1);
    lb.c = color(h,s,b);    
  }
  
  void killAll() {
    for (int i = 0; i < PATTERN_COUNT; i++) {
      effects[i].active = false;
    }
    momentary = true;
  }
  
}
