class Osc {
  float osc, period;
  long lastTime;
  
  Osc() {
    osc = 0;    
    period = 5;
    lastTime = millis();
  }
  
  Osc(float osc, float period, long seedTime) {
    this.osc = osc;
    this.period = period;
    this.lastTime = seedTime;
  }
  
  void seed(long seedTime) {
    lastTime = seedTime;
  }
    
  float update(long newTime) {
    osc += 2*PI*(newTime-lastTime)/(period*1000);
    lastTime = newTime;
    return osc;
  }
  
  float update(long newTime, float period) {
    this.period = period;
    osc += 2*PI*(newTime-lastTime)/(period*1000);
    lastTime = newTime;
    return osc;
  }
  
}

class LinOsc {
  float osc, period;
  long lastTime;
  
  LinOsc() {
    osc = 0;    
    period = 5;
    lastTime = millis();
  }
  
  LinOsc(float osc, float period, long seedTime) {
    this.osc = osc;
    this.period = period;
    this.lastTime = seedTime;
  }
  
  void seed(long seedTime) {
    lastTime = seedTime;
  }
    
  float update(long newTime) {
    osc += (newTime-lastTime)/(period*1000);
    if (osc > 1) {osc -= 1;}
    lastTime = newTime;
    return osc;
  }
  
  float update(long newTime, float period) {
    this.period = period;
    osc += (newTime-lastTime)/(period*1000);
    if (osc > 1) {osc -= 1;}
    lastTime = newTime;
    return osc;
  }
  
}
