class Button{
  
  // data fields
  private color colour;
  private float x,y,w,h;
  
  // constructs button object
  public Button(color c, float x, float y, float w, float h){
    colour = c;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  // displays button
  public void display(PFont font, float fontSize, String text){
    stroke(0);
    strokeWeight(1);
    rectMode(CENTER);
    fill(colour);
    pushMatrix();
    translate(x,y);
    rect(0,0,w,h);
    fill(0);
    textFont(font, fontSize);
    textAlign(CENTER,CENTER);
    text(text,0,0);
    popMatrix();
  }
  
  // if mouse pressed within button bounds, return true, else false
  public boolean isPressed(){
    if (mouseX < x+w/2 && mouseX >= x-w/2 && mouseY < y+h/2 && mouseY >= y-h/2){
      return true;
    }
    return false;
  }
}