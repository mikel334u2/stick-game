public class Human{
  
  private boolean swingDir, pright, jump, ground;
  private float ny, ex, sy, wx;
  private color c;
  private float x, y, size, feetY, gLevel;
  private float vy, angle, time, heightDiff;
  private int health;
  //private Shield shield;
  
  public Human(float x, float y, float s, color c){
    this.c = c;
    this.x = x;
    this.y = y;
    size = s;
    angle = PI/6.0;
    
    jump = false;
    gLevel = height;
    ground = (feetY >= gLevel);
    
    health = 4;
    swingDir = true;
    pright = false;
    vy = time = 0;
    update();
  }
  
  public void display(){
    
    update();
    
    strokeWeight(8);
    stroke(c);
    fill(255);
    pushMatrix();
    
    translate(x,y);
    noFill();
    ellipse(0,0,size*2,size*2);
    line(0,size,0,size*5);
    
    translate(0,size*2);
    pushMatrix();
    rotate(angle);
    line(0,0,0,size*3);
    rotate(-angle*2.0);
    line(0,0,0,size*3);
    popMatrix();
    
    translate(0,size*3);
    pushMatrix();
    rotate(angle);
    line(0,0,0,size*3);
    rotate(-angle*2.0);
    line(0,0,0,size*3);
    popMatrix();
    
    popMatrix();
  }
  
  // 0 = x, 1 = y, 2 = feetY, 3 = heightDiff, 4 = size, 5 = gLevel
  public float getf(int var){
    if (var == 0) return x;
    else if (var == 1) return y;
    else if (var == 2) return feetY;
    else if (var == 3) return heightDiff;
    else if (var == 4) return size;
    else if (var == 5) return gLevel;
    return 0;
  }
  
  // 0 = health
  public int getint(int var){
    if (var == 0) return health;
    return 0;
  }
  
  public void setX(float x){
    this.x = x;
  }
  
  public void setHealth(int h){
    health = h;
  }
  
  public void walk(boolean right){
    
    if (right != pright){
      swingDir = !swingDir;
      pright = right;
    }
    
    if (right) x += 6;
    else x -= 6;
    
    if (angle >= PI/6.0) swingDir = true;
    else if (angle <= -PI/6.0) swingDir = false;
    
    if (swingDir) angle -= .05;
    else angle += .05;
  }
  
  public void jump(){
    if (!jump){
      vy = -15;
      jump = true;
    }
  }
  
  public void fall(){
    
    y += vy;
    time += 0.01;
    vy += 3*time;
    if (ground && vy >= 0){
      y = gLevel - heightDiff;
      feetY = gLevel;
      vy = time = 0;
      jump = false;
    }
    update();
  }
  
  public Shield shield(){
    if (ground){
      return new Shield(#00F6FC, x, y - size + heightDiff*.5, size*4, heightDiff + size*2);
    }
    return null;
    //shield.setXY(x, y - size + heightDiff*.5);
    //shield.display();
    //if (shield.isTouching(bulletX, bulletX, bulletY, bulletY)){
    //  return true;
    //}
    //return false;
  }
  
  //public Bullet fireBullet(float x, float y, float sx, float sy){
  //  return new Bullet(x,y,sx,sy);
  //}
  
  public boolean isTouching(float WX, float EX, float NY, float SY){
    
    boolean touch1 = (ex <= EX && ex >= WX || wx <= EX && wx >= WX) &&
      (ny >= NY && ny <= SY || sy >= NY && sy <= SY);
    boolean touch2 = (EX <= ex && EX >= wx || WX <= ex && WX >= wx) &&
      (NY >= ny && NY <= sy || SY >= ny && SY <= sy);
    return touch1 || touch2;
  }
  
  public void setGL(float gl){
    gLevel = gl;
  }
  
  private void update(){
    heightDiff = size*5 + size*3*cos(angle);
    feetY = y + heightDiff;
    ny = y - size;
    sy = y + heightDiff;
    ex = x + size;
    wx = x - size;
    ground = (feetY >= gLevel);
  }
}