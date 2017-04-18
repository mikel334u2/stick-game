// class of all humans (players, npcs, enemies)
public class Human{
  
  // declare variables
  private boolean swingDir, pright, jump, ground;
  private float ny, ex, sy, wx;
  private color c;
  private float x, y, size, feetY, gLevel;
  private float vy, angle, time, heightDiff;
  private int health;
  
  // constructor for human object
  public Human(float x, float y, float s, color c){
    
    // establishes specified position, size, and leg/arm walking angle
    this.c = c;
    this.x = x;
    this.y = y;
    size = s;
    angle = PI/12.0;
    
    // is true when player jumps, false when lands on ground
    jump = false;
    
    // establishes current ground level
    gLevel = height;
    
    // boolean that checks whether the feet are on the ground
    ground = (feetY >= gLevel);
    
    // sets health to 4 by default
    health = 4;
    
    // boolean that handles arm/leg swinging, switches direction if angle gets too high
    swingDir = true;
    
    // boolean for previous direction of walking
    pright = false;
    
    // sets vertical velocity and time to 0
    vy = time = 0;
    
    // updates all other variables
    update();
  }
  
  // updates various variables
  private void update(){
    
    // difference between y position of head and y position of feet
    heightDiff = size*5 + size*3*cos(angle);
    
    // y position of feet
    feetY = y + heightDiff;
    
    // corners of the touching "box" of a human
    ny = y - size;
    sy = y + heightDiff;
    ex = x + size;
    wx = x - size;
    
    // sets the ground boolean to position of feet in relation to ground level
    ground = (feetY >= gLevel);
  }
  
  
  
  
  // GETTERS AND SETTERS---------------------------------------------------
  
  
  
  
  // general getter for float variables
  public float getf(int var){
    if (var == 0) return x;
    else if (var == 1) return y;
    else if (var == 2) return feetY;
    else if (var == 3) return heightDiff;
    else if (var == 4) return size;
    else if (var == 5) return gLevel;
    else if (var == 6) return ny;
    else if (var == 7) return ex;
    else if (var == 8) return sy;
    else if (var == 9) return wx;
    return 0;
  }
  
  // general getter for int variables
  public int getint(int var){
    if (var == 0) return health;
    return 0;
  }
  
  // general getter for booleans
  public boolean getbool(int var){
    if (var == 0) return ground;
    return false;
  }
  
  // setters
  public void setX(float x){ this.x = x; }
  public void setY(float y){ this.y = y; }
  public void setHealth(int h){ health = h; }
  public void setColor(color c){ this.c = c; }
  public void setGL(float gl){ gLevel = gl; }
  
  
  
  
  // ENVIRONMENT INTERACTION------------------------------------------------------
  
  
  
  
  // method that displays human on the screen
  public void display(){
    
    update();
    
    strokeWeight(8);
    stroke(c);
    fill(255);
    pushMatrix();
    
    // draws head and body
    translate(x,y);
    noFill();
    ellipse(0,0,size*2,size*2);
    line(0,size,0,size*5);
    
    // draws arms
    translate(0,size*2);
    pushMatrix();
    rotate(angle);
    line(0,0,0,size*3);
    rotate(-angle*2.0);
    line(0,0,0,size*3);
    popMatrix();
    
    // draws legs
    translate(0,size*3);
    pushMatrix();
    rotate(angle);
    line(0,0,0,size*3);
    rotate(-angle*2.0);
    line(0,0,0,size*3);
    popMatrix();
    
    popMatrix();
  }
  
  // allows human to move left/right
  public void walk(boolean right){
    
    // if current walking direction is different from previous, change swing direction
    if (right != pright){
      swingDir = !swingDir;
      pright = right;
    }
    
    // moves human
    if (right) x += 6;
    else x -= 6;
    
    // controls when human limb swinging direction will change, limits, angle
    if (angle >= PI/6.0) swingDir = true;
    else if (angle <= -PI/6.0) swingDir = false;
    
    // swings arms/legs
    if (swingDir) angle -= .05;
    else angle += .05;
  }
  
  // allows character to jump
  public void jump(){
    
    // if on ground, set vertical velocity to -15
    if (!jump){
      vy = -15;
      jump = true;
    }
  }
  
  // allows character to fall
  public void fall(){
    
    // character movement through time, parabolic
    y += vy;
    time += 0.01;
    vy += 3*time;
    
    // if reaches ground, reset positions of character
    if (ground && vy >= 0){
      y = gLevel - heightDiff;
      feetY = gLevel;
      vy = time = 0;
      jump = false;
    }
    update();
  }
  
  // creates a shield object that will surround player
  public Shield shield(){
    return new Shield(#00FFFF, x, y - size + heightDiff*.5, size*4, heightDiff + size*2);
  }
  
  public Bullet bullet(float sx, float sy){
    return new Bullet(x,y,sx,sy);
  }
  
  // determines if a human is touching another human
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
}