/* Michael Lee, Jada Dorman
 * 
 * This is our final project for CAP3032. It is a game. Enjoy!
 *
 */

Human player, npc1;
Shield shield;
Button b1, b2;
PFont comicSansMS;
PImage dungeon, sky;

int screen, score, timer, timeFrame, frameReset, timeReset, deathFrame;
boolean pause, normal, hard, leftWall, rightWall, dead, cutscene;

void settings(){
  size(800,800);
}

void setup(){
  
  sky = loadImage("sky.png");
  sky.resize(width, height);
  dungeon = loadImage("dungeonWall.jpg");
  dungeon.resize(width, height);
  comicSansMS = loadFont("ComicSansMS-48.vlw");
  textAlign(CENTER, CENTER);
  
  player = new Human(200,400,20,255);
  npc1 = new Human(600,400,20,100);
  npc1.setY(height - npc1.getf(3));
  
  screen = -1;
  score = 0;
  timer = 0;
  frameReset = 0;
  timeFrame = 0;
  timeReset = 0;
  deathFrame = 0;
  
  dead = false;
  pause = false;
  normal = false;
  hard = false;
  cutscene = false;
}

void draw(){
  background(0);
  if (frameCount%60 == timeFrame && !pause) timer++;
  
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
  if (!cutscene){
    if ((keyCode == UP || key == ' ') && !(pause || dead)){
      if (screen > 0) player.jump();
      else if (screen == 0 && keyCode == UP){
        normal = true;
        timeFrame = frameCount%60;
        timer = 0;
        screen++;
      }
    }
    if (keyCode == DOWN && screen == 0 && !(pause || dead)){
      hard = true;
      player.setHealth(2);
      timeFrame = frameCount%60;
      timer = 0;
      screen++;
    }
    if (key == 'p' && screen > 0 && !dead) pause = !pause;
    if (key == ESC && (screen == -1 || pause || dead)) exit();
    if (key == ENTER){
      if (pause) pause = false;
      else if (screen == -1) screen++;
    }
  }
}

public void turboKeyPressed(){
  if (keyPressed && !cutscene){
    if (screen > 0 && !(pause || dead)){
      if (keyCode == LEFT && !leftWall) player.walk(false);
      if (keyCode == RIGHT && !rightWall) player.walk(true);
      if (keyCode == DOWN && player.getbool(0)){ 
        shield = player.shield();
        shield.display();
      }
    }
  }
}

void mousePressed(){
  if (!cutscene){
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
        timeFrame = frameCount%60;
        timer = 0;
        screen++;
      }
      else if (b2.isPressed()){
        hard = true;
        player.setHealth(2);
        timeFrame = frameCount%60;
        timer = 0;
        screen++;
      }
    }
  }
}



public void displayUI(int c){
  
  fill(c);
  textAlign(CENTER, CENTER);
  textFont(comicSansMS, width/20);
  text("Time: "+timer, width/8, height/24);
  textFont(comicSansMS, width/20);
  text("Health: "+player.getint(0), width/2, height/24);
  textFont(comicSansMS, width/20);
  text("Score: "+score, width*7/8, height/24);
}



public void pauseMenu(){
  
  fill(255);
  textFont(comicSansMS,width/9);
  textAlign(CENTER,CENTER);
  text("p a u s e d", width/2, height/5);
  
  b1 = new Button(#1BF03F, width/2, height*3/7, width/3, height/6);
  b1.display(comicSansMS, width/16, "resume");
  b2 = new Button(#E0E0E0, width/2, height*2/3, width/3, height/6);
  b2.display(comicSansMS, width/16, "quit");
}

public void startMenu(){
  
  fill(255);
  textFont(comicSansMS,width/9);
  textAlign(CENTER,CENTER);
  text("s t i c k _ m a n", width/2, height/5);
  
  b1 = new Button(#1BF03F, width/2, height*5/11, width/3, height/6);
  b1.display(comicSansMS, width/16, "s t a r t");
  b2 = new Button(#E0E0E0, width/2, height*5/7, width/3, height/6);
  b2.display(comicSansMS, width/16, "q u i t");
}

public void difficulty(){
  
  fill(255);
  textFont(comicSansMS,width/16);
  textAlign(CENTER,CENTER);
  text("choose the difficulty mode:", width/2, height/5);
  
  b1 = new Button(#1BF03F, width/2, height*3/7, width/3, height/6);
  b1.display(comicSansMS, width/16, "normal");
  b2 = new Button(#FA4444, width/2, height*2/3, width/3, height/6);
  b2.display(comicSansMS, width/16, "hard");
}

public void gameOver(){
  
  fill(255);
  textFont(comicSansMS,width/9);
  textAlign(CENTER,CENTER);
  text("g a m e _ o v e r", width/2, height/5);
  textFont(comicSansMS,width/16);
  text("score : "+score, width/2, height*2/5);
  
  b2 = new Button(#E0E0E0, width/2, height*3/5, width/3, height/6);
  b2.display(comicSansMS, width/16, "q u i t");
}



public void screen1(){
  
  background(dungeon);
  displayUI(255);
  leftWall = (player.getf(0) - player.getf(4) <= 0) ? true : false;
  player.setGL(height);
  
  npc1.display();
  if (player.isTouching(npc1)){
    fill(255);
    textAlign(CENTER,CENTER);
    textFont(comicSansMS,width/24);
    if (normal) text("G'day, mate!", npc1.getf(0), npc1.getf(1) - 4*npc1.getf(4));
    if (hard) text("...", npc1.getf(0), npc1.getf(1) - 4*npc1.getf(4));
  }
  
  player.display();
  player.fall();
  
  if (leftWall){
    fill(255);
    textFont(comicSansMS,width/30);
    if (normal) text("Can't go there, buddy!", npc1.getf(0), npc1.getf(1) - 4*npc1.getf(4));
    if (hard) text("....?", npc1.getf(0), npc1.getf(1) - 4*npc1.getf(4));
  }
  
  if (player.getf(0) > width){
    player.setX(0);
    screen++;
    frameReset = frameCount%120;
    if (normal) timeReset = 10;
    if (hard) timeReset = 3;
  }
}

public void screen2(){
  
  if ((frameCount - frameReset) % 120 < 60) background(#FF0000);
  else background(dungeon);
  
  displayUI(255);
  
  if ((frameCount - frameReset) % 60 == 0) timeReset--;
  if (timeReset <= -1){
    cutscene = true;
    if (frameCount%10 < 5) background(0);
    else background(255);
    if (deathFrame == 60){
      dead = true;
      cutscene = false;
    }
    deathFrame++;
  }
  else {
    fill(255);
    textFont(comicSansMS,width/16);
    text("WARNING: "+timeReset,width/2,height/5);
  }
  
  rightWall = (player.getf(0) + player.getf(4) >= width/2 && player.getf(2) > height*5/6 ||
    player.getf(0) + player.getf(4) >= width*3/4 && player.getf(2) > height*2/3) ? true : false;
  fill(0);
  stroke(0);
  rectMode(CORNER);
  rect(width/2, height*5/6, width/2, height/6);
  rect(width*3/4, height*2/3, width/4, height/3);
  
  if (player.getf(0) + player.getf(4) <= width/2) player.setGL(height);
  else if (player.getf(0) + player.getf(4) > width*3/4 && !rightWall)
    player.setGL(height*2/3);
  else if (player.getf(0) + player.getf(4) > width/2 && !rightWall)
    player.setGL(height*5/6);
  player.display();
  player.fall();
  
  if (player.getf(0) > width){
    player.setX(0);
    screen++;
    player.setGL(height*5/6);
  }
  else if (player.getf(0) < 0){
    player.setX(width);
    screen--;
    player.setGL(height);
  }
}

public void screen3(){
  
  background(dungeon);
  displayUI(255);
  
  // death handling
  
  int wallHeight = 0;
  if (normal) wallHeight = height*2/3;
  if (hard) wallHeight = height/3;
  leftWall = (player.getf(0) - player.getf(4) <= width/6 && player.getf(2) > height*2/3
    || player.getf(0) - player.getf(4) <= width*3/4 && player.getf(0)
    + player.getf(4) >= width*2/3 && player.getf(2) > wallHeight) ? true : false;
  rightWall = (player.getf(0) + player.getf(4) >= width*2/5 && player.getf(0)
    - player.getf(4) <= width*2/3 && player.getf(2) > wallHeight) ? true : false;
  fill(0);
  stroke(0);
  rectMode(CORNER);
  rect(0, height*2/3, width/6, height/3);
  rect(width*2/5, wallHeight, width*3/4 - width*2/5, height - wallHeight);
  
  if (player.getf(0) - player.getf(4) >= width/6 && player.getf(0)
    + player.getf(4) <= width*2/5 || player.getf(0) - player.getf(4) >= width*3/4)
  player.setGL(height);
  else if (player.getf(0) - player.getf(4) < width/6 && !leftWall){
    player.setGL(height*2/3);
  }
  else if (player.getf(0) + player.getf(4) > width*2/5 && player.getf(0)
    - player.getf(4) < width*3/4 && !leftWall && !rightWall){
    player.setGL(wallHeight);
  }
  player.display();
  player.fall();
  
  if (player.getf(0) > width){
    player.setX(0);
    screen++;
  }
  else if (player.getf(0) < 0){
    player.setX(width);
    screen--;
    frameReset = frameCount%120;
    if (normal) timeReset = 10;
    if (hard) timeReset = 3;
  }
}

public void screen4(){
  
  image(dungeon, -width/2,0);
  image(sky,width/2,0);
  displayUI(0);
  
  // handle normal/hard difficulty
  
  if (player.getf(0) > width){
    player.setX(0);
    screen++;
  }
  else if (player.getf(0) < 0){
    player.setX(width);
    screen--;
  }
  player.setGL(height);
  
  player.display();
  player.fall();
}

public void screen5(){
  
  background(#FFFF00);
  displayUI(0);
  
  // handle normal/hard difficulty
  
  rightWall = (player.getf(0) + player.getf(4) >= width) ? true : false;
  if (player.getf(0) < 0){
    player.setX(width);
    screen--;
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