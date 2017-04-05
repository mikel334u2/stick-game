public class Human{
  
  private boolean swingDir, jumped, walkRight;
  private color col;
  private float x, y, size, feetY, vy, angle, time;
  
  public Human(float x, float y, float s, color c){
    col = c;
    this.x = x;
    this.y = y;
    size = s;
    swingDir = true;
    walkRight = false;
    angle = PI/6.0;
    feetY = y + size*5 + size*3*cos(angle);
    vy = time = 0;
  }
  
  public void display(){
    
    strokeWeight(3);
    stroke(col);
    fill(255);
    pushMatrix();
    
    translate(x,y);
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
  
  public void setXY(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  public float getFeetY(){
    return feetY;   
  }
  
  public void walk(){
    if (keyCode == RIGHT){
      x += 5;
      if (!walkRight) swingDir = !swingDir;
      walkRight = true;
    }
    else if (keyCode == LEFT){
      x -= 5;
      if (walkRight) swingDir = !swingDir;
      walkRight = false;
    }
    if (angle >= PI/6.0){
      swingDir = true;
    }
    else if (angle <= -PI/6.0){
      swingDir = false;
    }
    if (swingDir){
      angle-=.08;
    }
    else angle+=.08;
  }
  
  public void jump(){
    vy = -15;
    jumped = true;
  }
  
  public void fall(){
    
    if (feetY < height || jumped){
      y += vy;
      time += 0.01;
      vy += 3*time;
      feetY = y + size*5 + size*3*cos(angle);
    }
    if (feetY >= height){
      y = height - (size*5 + size*3*cos(angle));
      feetY = height;
      time = 0;
      vy = 0;
      jumped = false;
    }
  }
}