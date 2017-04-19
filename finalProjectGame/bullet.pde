// creates a bullet that will be fired
class Bullet{
  
  // declare bullet objects
  private float x,y,sx,sy;
  
  // bullet constructor
  public Bullet(float x, float y, float sx, float sy){
    this.x = x;
    this.y = y;
    this.sx = sx;
    this.sy = sy;
  }
  
  // display the bullet
  public void display(){
    stroke(#FF0000);
    strokeWeight(10);
    point(x,y);
  }
  
  // getters for x and y position
  public float getX(){
    return x;
  }
  public float getY(){
    return y;
  }
  
  // set the speed of the bullet
  public void setSpeed(float sx, float sy){
    this.sx = sx;
    this.sy = sy;
  }
  
  // move the bullet
  public void move(){
    x += sx;
    y += sy;
  }
  
  // determine if bullet is touching Human object
  public boolean isTouching(Human h){
    
    float NY = h.getf(6);
    float EX = h.getf(7);
    float SY = h.getf(8);
    float WX = h.getf(9);
    
    // essentially determines if the bullet circle is within the box of the human
    boolean touch = (x <= EX && x >= WX) && (y >= NY && y <= SY);
    return touch;
  }
  
  // determine if bullet is touching Shield object
  public boolean isTouching(Shield s){
    
    float NY = s.getCorners(0);
    float EX = s.getCorners(1);
    float SY = s.getCorners(2);
    float WX = s.getCorners(3);
    
    // essentially determines if the bullet circle is within the box of the shield
    boolean touch = (x <= EX && x >= WX) && (y >= NY && y <= SY);
    return touch;
  }
}