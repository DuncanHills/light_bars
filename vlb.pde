import processing.serial.*;
import rwmidi.*;

int NKEY_CHANNEL = 1;
int NKONTROL_CHANNEL = 0;
int NKONTROL2_CHANNEL = 2;
int BAWR_COUNT = 10;
int STROBE_COUNT = 4;
int LIGHT_COUNT = BAWR_COUNT + STROBE_COUNT;
int IMG_COUNT = 4;
int PATTERN_COUNT = 25;
int RENDER_WIDTH = 100;
int RENDER_HEIGHT = 100;

long lastTime = 0;
long startTime = 0;
int fpsCounter = 0;

boolean updating = false;
boolean interrupted = false;

MidiInput nanoKey, nanoKontrol;
LightBawr[] lightBawrs;
Pattern[] effects;
ComLink arduino;
MidiHandler switchBox;  

void setup() {  
  colorMode(HSB);
  noStroke();
  size(900,600,P3D);
  camera((float(BAWR_COUNT-1)/2)*10,0,(BAWR_COUNT*6), (float(BAWR_COUNT-1)/2)*10,0,0, 0,1,0);
    
  String[] in = RWMidi.getInputDeviceNames();
  println(in);

  nanoKey = RWMidi.getInputDevices()[NKEY_CHANNEL].createInput(this);
  nanoKontrol = RWMidi.getInputDevices()[NKONTROL_CHANNEL].createInput(this);
  
  lightBawrs = new LightBawr[LIGHT_COUNT];
  
  for (int i = 0; i < BAWR_COUNT; i++) {
    lightBawrs[i] = new LightBawr(i*10,0,-6-sin(float(i)/(BAWR_COUNT-1)*PI)*14,210,251,129);
  }
  
  for (int i = BAWR_COUNT; i < LIGHT_COUNT; i++) {
    lightBawrs[i] = new LightBawr((BAWR_COUNT-1)/2*10,100,-6-sin(float((BAWR_COUNT-1)/2)/(BAWR_COUNT-1)*PI)*14,210,251,129);
  }
  
  effects = new Pattern[PATTERN_COUNT];
  for (int i = 0; i < PATTERN_COUNT; i++) {
    effects[i] = new Pattern(i);
  }
  
  switchBox = new MidiHandler(effects);  
  arduino = new ComLink(); 
  
  frameRate(120);

//  noLoop();
}

void draw(){
  background(0);  
  
  for (int bawr = 0; bawr < LIGHT_COUNT; bawr++) {
    lightBawrs[bawr].c = color(0,0,0);
  }

  updating = true;

  startTime = millis();
  for (int pattern = 0; pattern < PATTERN_COUNT; pattern++) {
    for (int bawr = 0; bawr < LIGHT_COUNT; bawr++) {
      effects[pattern].render(lightBawrs[bawr], startTime);
    }
  }
  
  updating = false;
  if (interrupted == true) {
    arduino.pushChannels();
    interrupted = false;
  }

  for (int i = 0; i < BAWR_COUNT; i++){
    lightBawrs[i].render();
  }
//  FPS(millis());
}

void serialEvent(Serial myPort) {
  interrupted = false;
  String inString = myPort.readString();
//  print("Arduino: " + inString);
  myPort.clear();    
  if (inString.indexOf("R") >= 0) {
//    println("SENDING DATA");
    if (updating == true) {
      interrupted = true;
    }
    else {arduino.pushChannels();}

//    println("DATA SENT");      
    }
  FPS(millis());
}

void controllerChangeReceived(Controller controller){
//  println("CC " + controller.getCC() + ":" + controller.getValue());
//  lightBawrs[controller.getCC()-100].c = color(map(controller.getValue(), 1,127,0,255),250,250);
//  println("SENDING CC EVENT");
  switchBox.ccEvent(controller.getCC(), controller.getValue());
//  redraw();
}

void noteOnReceived(Note note) {
  
}

void noteOffReceived(Note note) {
  
}

void FPS(long ping) {
  fpsCounter++;
  
  if ((ping - lastTime) > 1000) {
    println("FPS: " + fpsCounter);
    fpsCounter = 0;
    lastTime = ping;
  }
}

public void stop() {
  nanoKey.closeMidi();
  nanoKontrol.closeMidi();
  super.stop();
} 

int getFileCount(String subdir) {  
  java.io.File folder = new java.io.File(dataPath(subdir));
  
  // let's set a filter (which returns true if file's extension is .jpg)
  java.io.FilenameFilter pngFilter = new java.io.FilenameFilter() {
    public boolean accept(File dir, String name) {
      return name.toLowerCase().endsWith(".png");
    }
  };
   
  // list the files in the data folder, passing the filter as parameter
  String[] filenames = folder.list(pngFilter);
  
  // get and display the number of jpg files
  return filenames.length;
}

