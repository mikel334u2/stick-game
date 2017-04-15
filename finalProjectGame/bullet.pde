class Bullet{
  
  private float x,y,sx,sy;
  private boolean appear;
  
  public Bullet(float x, float y, float sx, float sy){
    this.x = x;
    this.y = y;
    this.sx = sx;
    this.sy = sy;
    appear = true;
  }
  
  public void setAppear(){
    appear = !appear;
  }
  
  public void display(){
    if (appear){
      stroke(0);
      strokeWeight(2);
      point(x,y);
      x += sx;
      y += sy;
    }
  }
}