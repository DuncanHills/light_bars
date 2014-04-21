class Particle {
  PVector location, velocity, acceleration;
  long lastTime;
  
  Particle() {
    location.set(0,0,0);
    velocity.set(0,0,0);
    acceleration.set(0,0,0);
  }
  
  Particle(float x, float y, float z) {
    location.set(x,y,z);
    velocity.set(0,0,0);
    acceleration.set(0,0,0);
  }
  
  void update() {
    long time = millis();
    location.add(PVector.mult(velocity,(time - lastTime)/1000));
    velocity.add(PVector.mult(acceleration,(time - lastTime)/1000));
    lastTime = time;
  }
  
}
