class LightBawr{
  color c;
  PVector loc;
  LightBawr(float x, float y, float z, float r, float g, float b){
    this.loc = new PVector(x,y,z);
    this.c = color(r,g,b);
  }
  
  void render(){
    fill(c);
    pushMatrix();
      translate(loc.x,loc.y,loc.z);
      cylinder(1,30,16);
    popMatrix();
  }
}
