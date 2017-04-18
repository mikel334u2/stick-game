//in progress...-----------------------------------------
class Shield{
  
  private color c;
  private float x, y, w, h;
  private float ny, ex, sy, wx;
  
  public Shield(color c, float x, float y, float w, float h){
    this.c = c;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    update();
  }
  
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
  
  public void setXY(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  private void update(){
    wx = x - w/2;
    ex = x + w/2;
    ny = y - h/2;
    sy = y + h/2;
  }
}