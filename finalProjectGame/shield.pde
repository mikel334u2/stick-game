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
  
  public boolean isTouching(float WX, float EX, float NY, float SY){
    
    boolean touch = (EX <= ex && EX >= wx || WX <= ex && WX >= wx) &&
      (NY >= ny && NY <= sy || SY >= ny && SY <= sy);
    return touch;
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