
int MIDI_DEVICE = 0;
int BAWR_COUNT = 9;

import rwmidi.*;

MidiInput input;
LightBawr[] lightBawrs;

void setup(){  
  colorMode(HSB);
  String[] in = RWMidi.getInputDeviceNames();
  input = RWMidi.getInputDevices()[MIDI_DEVICE].createInput(this);
  
  noStroke();
  size(900,600,P3D);
  camera(0,0,50, 0,0,0, 0,1,0);
  
  lightBawrs = new LightBawr[BAWR_COUNT];
  for (int i = 0; i < BAWR_COUNT; i++) {
    lightBawrs[i] = new LightBawr((-BAWR_COUNT/2+i)*10,0,-6-sin(float(i)/(BAWR_COUNT-1)*PI)*14,210,251,129);
  }
  noLoop();
}

void controllerChangeReceived(Controller controller){
  println("controller " + controller.getCC() + ":" + controller.getValue());
  lightBawrs[controller.getCC()].c = color(map(controller.getValue(), 1,127,0,255),250,250);
  redraw();
}

void draw(){
  background(0);
  for (int i=0; i<lightBawrs.length; i++){
    lightBawrs[i].render();
  }
}
