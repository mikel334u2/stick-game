/* Michael Lee, Jada Dorman
 * 
 * This is our final project for CAP3032. It is a game. Enjoy!
 *
 */

Human player;
Shield shield;

int screen;

Button b1, b2;

int score;
int timer;
int frameReset;

PFont comicSansMS;

boolean pause, normal, hard, leftWall, rightWall, dead;

void settings(){
  size(800,800);
}

void setup(){
  player = new Human(200,400,20,#000000);
  
  screen = -1;
  
  comicSansMS = loadFont("ComicSansMS-48.vlw");
  textAlign(CENTER, CENTER);
  
  dead = false;
  pause = false;
  normal = false;
  hard = false;
  
  score = 0;
  timer = 0;
  frameReset = 0;
}

void draw(){
  background(255);
  if (frameCount%60 == frameReset) timer++;
  
  if (pause) pauseMenu();
  else if (dead) gameOver();
  else if (screen == -1) startMenu();
  else if (screen == 0) difficulty();
  else if (screen == 1) screen1();
  else if (screen == 2) screen2();
  else if (screen == 3) screen3();
  else if (screen == 4) screen4();
  else if (screen == 5) screen5();
  turboKeyPressed();
  if (player.getint(0) == 0) dead = true;
}

void keyPressed(){
  if (keyCode == UP && screen > 0 && !(pause || dead)) player.jump();
  if (key == 'p' && screen > 0 && !dead) pause = !pause;
  if (key == ESC && (screen == -1 || pause)) exit();
  if (key == ENTER){
    if (pause) pause = false;
    else if (screen == -1) screen++;
  }
}

public void turboKeyPressed(){
  if (keyPressed){
    if (screen > 0 && !(pause || dead)){
      if (keyCode == LEFT && !leftWall) player.walk(false);
      if (keyCode == RIGHT && !rightWall) player.walk(true);
      if (keyCode == DOWN){ 
        shield = player.shield();
        shield.display();
      }
    }
  }
}

void mousePressed(){
  if (pause || dead){
    if (b1.isPressed()) pause = false;
    else if (b2.isPressed()) exit();
  }
  else if (screen == -1){
    if (b1.isPressed()) screen++;
    else if (b2.isPressed()) exit();
  }
  else if (screen == 0){
    if (b1.isPressed()){
      normal = true;
      frameReset = frameCount%60;
      timer = 0;
      screen++;
    }
    else if (b2.isPressed()){
      hard = true;
      frameReset = frameCount%60;
      timer = 0;
      screen++;
    }
  }
}

public void displayUI(){
  
  fill(0);
  textAlign(CENTER, CENTER);
  textFont(comicSansMS, width/20);
  text("Time: "+timer, width/8, height/24);
  textFont(comicSansMS, width/20);
  text("Health: "+player.getint(0), width/2, height/24);
  textFont(comicSansMS, width/20);
  text("Score: "+score, width*7/8, height/24);
}

public void pauseMenu(){
  
  fill(0);
  textFont(comicSansMS,width/9);
  textAlign(CENTER,CENTER);
  text("PAUSED", width/2, height/5);
  
  b1 = new Button(#1BF03F, width/2, height*3/7, width/3, height/6);
  b1.display(comicSansMS, width/16, "RESUME");
  b2 = new Button(#E0E0E0, width/2, height*2/3, width/3, height/6);
  b2.display(comicSansMS, width/16, "QUIT");
}

public void startMenu(){
  
  fill(0);
  textFont(comicSansMS,width/9);
  textAlign(CENTER,CENTER);
  text("STICK MAN", width/2, height/5);
  
  b1 = new Button(#1BF03F, width/2, height*5/11, width/3, height/6);
  b1.display(comicSansMS, width/16, "START");
  b2 = new Button(#E0E0E0, width/2, height*5/7, width/3, height/6);
  b2.display(comicSansMS, width/16, "QUIT");
}

public void difficulty(){
  
  fill(0);
  textFont(comicSansMS,width/16);
  textAlign(CENTER,CENTER);
  text("Choose the difficulty mode:", width/2, height/5);
  
  b1 = new Button(#1BF03F, width/2, height*3/7, width/3, height/6);
  b1.display(comicSansMS, width/16, "NORMAL");
  b2 = new Button(#FA4444, width/2, height*2/3, width/3, height/6);
  b2.display(comicSansMS, width/16, "HARD");
}

public void screen1(){
  
  displayUI();
  
  // handle normal/hard difficulty
  
  leftWall = (player.getf(0) - player.getf(4) <= 0) ? true : false;
  if (player.getf(0) >= width){
    player.setX(0);
    screen++;
    score++;
  }
  player.setGL(height);
  //if (player.getter(0) + player.getter(4) <= width/2 && player.getter(0) - player.getter(4) >= 0){
  //  player.setGL(height);
  //}
  //else if (player.getter(0) + player.getter(4) <= width && player.getter(0) + player.getter(4) > width/2){
  //  player.setGL(height-50);
  //}
  player.display();
  player.fall();
}

public void screen2(){
  
  if (timer%2 == 0) background(#FF0000);
  else background(50);
  displayUI();
  
  // handle normal/hard difficulty
  
  if (player.getf(0) >= width){
    player.setX(0);
    screen++;
    score++;
  }
  else if (player.getf(0) <= 0){
    player.setX(width);
    screen--;
    player.setHealth(player.getint(0)-1);
  }
  player.setGL(height);
  //if (player.getter(0) + player.getter(4) <= width/2 && player.getter(0) - player.getter(4) >= 0){
  //  player.setGL(height);
  //}
  //else if (player.getter(0) + player.getter(4) <= width && player.getter(0) + player.getter(4) > width/2){
  //  player.setGL(height-50);
  //}
  player.display();
  player.fall();
}

public void screen3(){
  
  background(#00FF00);
  displayUI();
  
  // handle normal/hard difficulty
  
  if (player.getf(0) >= width){
    player.setX(0);
    screen++;
    score++;
  }
  else if (player.getf(0) <= 0){
    player.setX(width);
    screen--;
    player.setHealth(player.getint(0)-1);
  }
  player.setGL(height);
  //if (player.getter(0) + player.getter(4) <= width/2 && player.getter(0) - player.getter(4) >= 0){
  //  player.setGL(height);
  //}
  //else if (player.getter(0) + player.getter(4) <= width && player.getter(0) + player.getter(4) > width/2){
  //  player.setGL(height-50);
  //}
  player.display();
  player.fall();
}

public void screen4(){
  
  background(#00FFFF);
  displayUI();
  
  // handle normal/hard difficulty
  
  if (player.getf(0) >= width){
    player.setX(0);
    screen++;
    score++;
  }
  else if (player.getf(0) <= 0){
    player.setX(width);
    screen--;
    player.setHealth(player.getint(0)-1);
  }
  player.setGL(height);
  //if (player.getter(0) + player.getter(4) <= width/2 && player.getter(0) - player.getter(4) >= 0){
  //  player.setGL(height);
  //}
  //else if (player.getter(0) + player.getter(4) <= width && player.getter(0) + player.getter(4) > width/2){
  //  player.setGL(height-50);
  //}
  player.display();
  player.fall();
}

public void screen5(){
  
  background(#FFFF00);
  displayUI();
  
  // handle normal/hard difficulty
  
  rightWall = (player.getf(0) + player.getf(4) >= width) ? true : false;
  if (player.getf(0) <= 0){
    player.setX(width);
    screen--;
    player.setHealth(player.getint(0)-1);
  }
  player.setGL(height);
  //if (player.getter(0) + player.getter(4) <= width/2 && player.getter(0) - player.getter(4) >= 0){
  //  player.setGL(height);
  //}
  //else if (player.getter(0) + player.getter(4) <= width && player.getter(0) + player.getter(4) > width/2){
  //  player.setGL(height-50);
  //}
  player.display();
  player.fall();
}

public void gameOver(){
  
  fill(0);
  textFont(comicSansMS,width/9);
  textAlign(CENTER,CENTER);
  text("GAME OVER", width/2, height/5);
  textFont(comicSansMS,width/16);
  text("Score: "+score, width/2, height/3);
  
  b2 = new Button(#E0E0E0, width/2, height*4/7, width/3, height/6);
  b2.display(comicSansMS, width/16, "QUIT");
  
}