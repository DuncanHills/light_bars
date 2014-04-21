class MidiHandler {
//  MidiInput input;
  Pattern[] patterns;
    
  MidiHandler(Pattern[] patterns_){
    this.patterns = patterns_;
  }
  
  void ccEvent(int cc, int value) {
//    println("CC EVENT STARTED");
    if (cc < 72) {
      int pat = cc/4;
//      println("Changing value on pattern: " + pat);
      switch (cc%4) {
        case 0: patterns[pat].cg.fader = value; break;
        case 1: patterns[pat].cg.encoder = value; break;
        case 2: patterns[pat].cg.bottomButton = value; break;
        case 3: patterns[pat].cg.topButton = value; break;
      }
    }
    else if (cc >= 100) {
//      println("Sending message to pattern: " + (cc-100));
      effects[cc-100].keyChange(value);
    }
  }
  
}
