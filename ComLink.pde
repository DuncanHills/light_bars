class ComLink {
  Serial comPort;
  byte[] output;
  
  ComLink() {
    println(Serial.list());
    comPort = new Serial(vlb.this, Serial.list()[1], 57600);
    comPort.bufferUntil(10);
    comPort.clear();
    output = new byte[LIGHT_COUNT*3];
  }
  
  void pushChannels() {
    colorMode(RGB, 1.0);
    
    for (int i = 0; i < LIGHT_COUNT; i++) {
      float r = red(lightBawrs[i].c)*255;
      float g = green(lightBawrs[i].c)*255;
      float b = blue(lightBawrs[i].c)*255;
      
      byte m = 0;

      if (r > m) {output[i*3] = byte(r);} else {output[i*3] = m;}
      if (g > m) {output[i*3+1] = byte(g);} else {output[i*3+1] = m;}
      if (b > m) {output[i*3+2] = byte(b);} else {output[i*3+2] = m;}
//      output[i*3+1] = byte(g);
//      output[i*3+2] = byte(b);
      
      /*
      println("[" + (i*3) + "] " + r);
      println("[" + (i*3+1) + "] " + g);
      println("[" + (i*3+2) + "] " + b);
      */
      
      for (int j = 0; j < 3; j++) {
        if (output[i*3+j] == 69) {output[i*3+j]--;}
      }
    }
    
//      println(output);
    comPort.write(69);
    comPort.write(output);
  }
}
