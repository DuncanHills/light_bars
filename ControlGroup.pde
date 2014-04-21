class ControlGroup {
  int fader, encoder, topButton, bottomButton;
  int location;  
  
  ControlGroup(int location) {
    this.location = location;
    fader = 0;
    encoder = 0;
    topButton = 0;
    bottomButton = 0;
  }
}

class Key {
  int value;
  int location;
  
  Key(int location) {
    this.location = location;
    value = 0;
  }
}

