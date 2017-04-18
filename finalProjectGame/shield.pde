// Shield class for defending player against attacks
class Shield{
  
  private color c;
  private float x, y, w, h;
  private float ny, ex, sy, wx;
  
  // Shield constructor
  public Shield(color c, float x, float y, float w, float h){
    this.c = c;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    update();
  }
  
  // updates the boundaries
  private void update(){
    wx = x - w/2;
    ex = x + w/2;
    ny = y - h/2;
    sy = y + h/2;
  }
  
  // display the shield
  public void display(){
    
    update();
    
    stroke(c);
    strokeWeight(5);
    rectMode(CENTER);
    noFill();
    pushMatrix();
    translate(x,y);
    rect(0,0,w,h);
    popMatrix();
  }
  
  // determines if shield is touching another human
  public boolean isTouching(Human h){
    
    float NY = h.getf(6);
    float EX = h.getf(7);
    float SY = h.getf(8);
    float WX = h.getf(9);
    
    // essentially determines if a corner of one human's "box" is within the box
    // of the other human
    boolean touch1 = (ex <= EX && ex >= WX || wx <= EX && wx >= WX) &&
      (ny >= NY && ny <= SY || sy >= NY && sy <= SY);
    boolean touch2 = (EX <= ex && EX >= wx || WX <= ex && WX >= wx) &&
      (NY >= ny && NY <= sy || SY >= ny && SY <= sy);
    return touch1 || touch2;
  }
  
  // get boundaries of the shield
  public float getCorners(int var){
    if (var == 0) return ny;
    if (var == 1) return ex;
    if (var == 2) return sy;
    if (var == 3) return wx;
    return 0;
  }
}