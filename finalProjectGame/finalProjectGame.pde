/* Michael Lee, Jada Dorman
 * 
 * This is our final project for CAP3032. It is a game. Enjoy!
 *
 */


Human h;
int isWalking;

void setup(){
  size(800,800);
  background(255);
  h = new Human(400,400,20,#000000);
  isWalking = 0;
}

void draw(){
  background(255);
  h.display();
  h.fall();
  if (keyPressed){
    if(keyCode == LEFT || keyCode == RIGHT){
      h.walk();
    }
  }
}

void keyPressed(){
  if(keyCode == UP && h.getFeetY() == height){
    h.jump();
  }
}

void mousePressed(){
  
}