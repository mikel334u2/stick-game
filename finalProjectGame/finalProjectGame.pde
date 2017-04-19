/* Michael Lee, Jada Dorman
 * 
 * This is our final project for CAP3032. It is a game. Enjoy!
 *
 */

// import necessary libraries
import ddf.minim.*;

// declare variables
Human player, npc1, npc2, npc3, e1, e2, e3, e4, boss;
Shield shield;
Bullet[] bt1, bt2;
Button b1, b2;
PFont comicSansMS;
PImage dungeon, sky, cave, desert, summer, lava, lair;

// sound variables
Minim minim;
AudioPlayer [] music;

// changing game mechanics
int screen, score, timer, timeFrame, frameReset, timeReset, deathFrame, bossHealth;
boolean pause, normal, hard, leftWall, rightWall, dead, cutscene, threshold, already;
float cx, v, colorChange;

// character variables
boolean e1walk, e1dir, touch, bossDead; // enemy/boss

// set size
void settings(){
  size(800,800);
}

void setup(){
  
   // head tumbleweed variables
  v = -4;
  cx = 700;
  
  //load audio
  music = new AudioPlayer[9];
  minim = new Minim(this);
  music[0] = minim.loadFile("click.mp3");
  music[1] = minim.loadFile("dungeon.mp3");
  music[2] = minim.loadFile("Alarm.mp3");
  music[3] = minim.loadFile("Chirp.mp3");
  music[4] = minim.loadFile("Waves.mp3");
  music[5] = minim.loadFile("Desert.mp3");
  music[6] = minim.loadFile("Cave.mp3");
  music[7] = minim.loadFile("lava.mp3");
 // music[8] = minim.loadFile()
  music[8] = minim.loadFile("Boss.mp3");
  
  // load images from file, resize to fit
  sky = loadImage("sky.png");
  sky.resize(width, height);
  dungeon = loadImage("dungeonWall.jpg");
  dungeon.resize(width, height);
  cave = loadImage("cave.png");
  desert = loadImage("desert.png");
  desert.resize(width,height);
  summer = loadImage("summer.jpg");
  summer.resize(width,height);
  lava = loadImage("lava.jpg");
  lava.resize(width,height);
  lair = loadImage("lair.jpg");
  lair.resize(width,height);
  
  // load font
  comicSansMS = loadFont("ComicSansMS-48.vlw");
  textAlign(CENTER, CENTER);
  
  // set positions of humans
  player = new Human(200,400,20,200);
  npc1 = new Human(600,400,20,100);
  npc1.setY(height - npc1.getf(3));
  npc2 = new Human(200,400,20,#0000FF);
  npc2.setY(height - npc2.getf(3));
  npc3 = new Human(500,400,20, #A57721);
  npc3.setY(height - npc3.getf(3));
  
  // initialize bullet arrays
  bt1 = new Bullet[0];
  bt2 = new Bullet[0];
  
  // keeps track of which screen to display
  screen = -1;
  
  // keeps track of score
  score = 0;
  
  // internal game clock
  timer = 0;
  
  // catches current frame to reset the time via modulo
  frameReset = 0;
  
  // same use as above, but for the timer variable
  timeFrame = 0;
  
  // a timer that starts upon a certain event
  timeReset = 0;
  
  // keeps track of animation until death
  deathFrame = 0;
  
  // if true, game over
  dead = false;
  
  // if true, you win
  bossDead = false;
  
  // changes color for celebration
  colorChange = 0;
  
  // if true, pause game and its mechanics
  pause = false;
  
  // difficulty settings
  normal = false;
  hard = false;
  
  // prohibits user control if true
  cutscene = false;
  
  // screen 6 boolean
  already = false;
}

void draw(){
  
  background(0);
  
  // when the game starts, start incrementing timer
  if (frameCount%60 == timeFrame && !pause) timer++;
  
  // possible options for screens to display
  if (pause) pauseMenu();
  else if (dead) gameOver();
  else if (screen == -1) startMenu();
  else if (screen == 0) difficulty();
  else if (screen == 1){
    music[1].play();
    screen1();
  }
  else if (screen == 2) screen2();
  else if (screen == 3) screen3();
  else if (screen == 4) screen4();
  else if (screen == 5) screen5();
  else if (screen == 6) screen6();
  else if (screen == 7) screen7();
  else if (screen == 8) screen8();
  else if (screen == 9) screen9();
  else if (screen == 10) screen10();
  
  // allows player continuous input upon pressing a button
  turboKeyPressed();
  
  // if health is 0, game over
  if (player.getint(0) == 0) dead = true;
}



// USER INPUT----------------------------------------------------------------



// "one and done" key input
void keyPressed(){
  
  if (!cutscene){
    
    // if up or space is pressed...
    if ((keyCode == UP || key == ' ') && !(pause || dead)){
      
      // jump character if in game screens
      if (screen > 0) player.jump();
      
      // choose normal mode if on difficulty screen and UP is pressed
      else if (screen == 0 && keyCode == UP){
        normal = true;
        
        // resets current frame upon start of main game
        timeFrame = frameCount%60;
        
        // resets the timer to 0
        timer = 0;
        
        // goes to the first screen
        screen++;
      }
    }
    
    // if down is pressed on the difficulty screen, set difficulty to hard
    if (keyCode == DOWN && screen == 0 && !(pause || dead)){
      hard = true;
      
      // health is 2 instead of 4
      player.setHealth(2);
      timeFrame = frameCount%60;
      timer = 0;
      screen++;
    }
    
    // if p pressed, switch between pause screen and game screen
    if (key == 'p' && screen > 0 && !dead) pause = !pause;
    
    // if screen is start, pause, or game over and ESC pressed, exit game
    if (key == ESC && (screen == -1 || pause || dead)) exit();
    
    // if ENTER pressed...
    if (key == ENTER){
      
      // if pause screen, return to main game
      if (pause) pause = false;
      
      // if start screen, continue to difficulty screen
      else if (screen == -1) screen++;
    }
  }
}

// method for running turbo button functions
public void turboKeyPressed(){
  
  if (keyPressed && !cutscene){
    if (screen > 0 && !(pause || dead)){
      
      // if left or right pressed, player walks left/right
      if (keyCode == LEFT && !leftWall) player.walk(false);
      if (keyCode == RIGHT && !rightWall) player.walk(true);
      
      // if on the ground and down pressed, activate shield
      if (keyCode == DOWN && player.getbool(0)){ 
        shield = player.shield();
        shield.display();
      }
      else shield = null;
    }
  }
}

void mousePressed(){
  if (!cutscene){
    
    // on pause or game over screens...
    if (pause || dead){
      
      // if top button clicked, unpause the game (for pause screen)
      if (b1.isPressed()){
        pause = false;
        music[0].rewind();
        music[0].play();
      }
      
      // if bottom one clicked, exit game
      else if (b2.isPressed()) exit();
    }
    
    // on start screen...
    else if (screen == -1){
      
      // if start button pressed, go to difficulty screen
      if (b1.isPressed()){
        music[0].rewind();
        music[0].play();
        screen++;
      }
      
      // exit game if quit pressed
      else if (b2.isPressed()) exit();
    }
    
    // on difficulty screen...
    else if (screen == 0){
      
      // if normal button pressed, go to main game in normal mode
      if (b1.isPressed()){
        normal = true;
        timeFrame = frameCount%60;
        timer = 0;
        screen++;
      }
      
      // ifhard button pressed, go to main game in hard mode
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

// method that displays the time, health, and score at the top of game screen
public void displayUI(int c){
  
  // color of text can be changed
  fill(c);
  textAlign(CENTER, CENTER);
  textFont(comicSansMS, width/20);
  text("Time: "+timer, width/8, height/24);
  textFont(comicSansMS, width/20);
  text("Health: "+player.getint(0), width/2, height/24);
  textFont(comicSansMS, width/20);
  text("Score: "+score, width*7/8, height/24);
}





// MENUS-------------------------------------------------------------------




// displays pause menu
public void pauseMenu(){
  
  // shows paused text
  fill(255);
  textFont(comicSansMS,width/9);
  textAlign(CENTER,CENTER);
  text("p a u s e d", width/2, height/5);
  
  // creates buttons that say "resume" and "quit" and sets locations/sizes
  b1 = new Button(#1BF03F, width/2, height*3/7, width/3, height/6);
  b1.display(comicSansMS, width/16, "resume");
  b2 = new Button(#E0E0E0, width/2, height*2/3, width/3, height/6);
  b2.display(comicSansMS, width/16, "quit");
}

// displays start menu
public void startMenu(){
  
  // shows game title
  fill(255);
  textFont(comicSansMS,width/9);
  textAlign(CENTER,CENTER);
  text("s t i c k _ m a n", width/2, height/5);
  
  // creates buttons that say "start" and "quit" and sets locations/sizes
  b1 = new Button(#1BF03F, width/2, height*5/11, width/3, height/6);
  b1.display(comicSansMS, width/16, "s t a r t");
  b2 = new Button(#E0E0E0, width/2, height*5/7, width/3, height/6);
  b2.display(comicSansMS, width/16, "q u i t");
}

// displays difficulty screen
public void difficulty(){
  
  // shows prompt to choose a difficulty mode
  fill(255);
  textFont(comicSansMS,width/16);
  textAlign(CENTER,CENTER);
  text("choose the difficulty mode:", width/2, height/5);
  
  // creates buttons that say "normal" and "hard" and sets locations/sizes
  b1 = new Button(#1BF03F, width/2, height*3/7, width/3, height/6);
  b1.display(comicSansMS, width/16, "normal");
  b2 = new Button(#FA4444, width/2, height*2/3, width/3, height/6);
  b2.display(comicSansMS, width/16, "hard");
}

// displays game over screen
public void gameOver(){
  
  // shows game over and the latest score
  fill(255);
  textFont(comicSansMS,width/9);
  textAlign(CENTER,CENTER);
  if (!bossDead) text("g a m e _ o v e r", width/2, height/5);
  else {
    colorMode(HSB);
    fill(colorChange,255,255);
    text("YOU WIN!!!", width/2, height/5);
    colorChange++;
    if (colorChange == 255) colorChange = 0;
  }
  textFont(comicSansMS,width/16);
  text("score : "+score, width/2, height*2/5);
  
  // creates a button that says "quit" and sets location/size
  b2 = new Button(#E0E0E0, width/2, height*3/5, width/3, height/6);
  b2.display(comicSansMS, width/16, "q u i t");
}





// MAIN GAME SCREENS-----------------------------------------------------------





public void screen1(){
  
  // displays a dungeon background
  background(dungeon);
  
  // displays UI with white text
  displayUI(255);
  
  // creates a left wall if player runs into left edge
  leftWall = (player.getf(0) - player.getf(4) <= 0) ? true : false;
  
  // sets ground level to bottom of the screen
  player.setGL(height);
  
  // displays an npc
  npc1.display();
  
  // if player touches npc, display some text above his head (varies w/ difficulty)
  if (player.isTouching(npc1)){
    fill(255);
    textAlign(CENTER,CENTER);
    textFont(comicSansMS,width/24);
    if (normal) text("G'day, mate!", npc1.getf(0), npc1.getf(1) - 4*npc1.getf(4));
    if (hard) text("...", npc1.getf(0), npc1.getf(1) - 4*npc1.getf(4));
  }
  
  // display player, allow to fall
  player.display();
  player.fall();
  
  // if player touches a left wall, npc says something (varies w/ difficulty)
  if (leftWall){
    fill(255);
    textFont(comicSansMS,width/30);
    if (normal) text("Can't go there, buddy!",
      npc1.getf(0), npc1.getf(1) - 4*npc1.getf(4));
    if (hard) text("....?", npc1.getf(0), npc1.getf(1) - 4*npc1.getf(4));
  }
  
  // switches screen if player position is at right edge
  if (player.getf(0) > width){
    
    nextTrack(1,2);
    
    // set player position to x=0
    player.setX(0);
    screen++;
    
    // resets frame, sets the countdown timer for next screen
    frameReset = frameCount%120;
    if (normal) timeReset = 10;
    if (hard) timeReset = 3;
  }
}

public void screen2(){
  
  // switches b/w red and dungeon background on each second
  if ((frameCount - frameReset) % 120 < 60) background(#FF0000);
  else background(dungeon);
  
  displayUI(255);
  
  // decreases countdown timer with every second in this screen
  if ((frameCount - frameReset) % 60 == 0) timeReset--;
  
  // when countdown finished...
  if (timeReset <= -1){
    
    // prohibit user input
    cutscene = true;
    
    // black and white flashing for one second
    if (frameCount%10 < 5) background(0);
    else background(255);
    
    // after one second, kill player (game over)
    if (deathFrame == 60){
      dead = true;
      cutscene = false;
    }
    deathFrame++;
  }
  
  // otherwise, display countdown timer
  else {
    fill(255);
    textFont(comicSansMS,width/16);
    text("WARNING: "+timeReset,width/2,height/5);
  }
  
  // create right walls i.e if player is at halfway point
  // and feet are below certain point, create right wall
  rightWall = (player.getf(0) + player.getf(4) >= width/2 && player.getf(2) > height*5/6
    || player.getf(0) + player.getf(4) >= width*3/4 && player.getf(2) > height*2/3)
    ? true : false;
  
  // draw black platforms
  fill(0);
  stroke(0);
  rectMode(CORNER);
  rect(width/2, height*5/6, width/2, height/6);
  rect(width*3/4, height*2/3, width/4, height/3);
  
  // if the player is within these x positions, set the ground level to specified level
  if (player.getf(0) + player.getf(4) <= width/2) player.setGL(height);
  else if (player.getf(0) + player.getf(4) > width*3/4 && !rightWall)
    player.setGL(height*2/3);
  else if (player.getf(0) + player.getf(4) > width/2 && !rightWall)
    player.setGL(height*5/6);
    
  player.display();
  player.fall();
  
  // switch screens forward if on right edge
  if (player.getf(0) > width){
    player.setX(0);
    screen++;
    
    nextTrack(2,1);
    
    // set next ground level to specific level
    player.setGL(height*5/6);
  }
  
  // switch screens back if on left edge
  else if (player.getf(0) < 0){
    
    nextTrack(2,1);
    
    // reset x position to x=width
    player.setX(width);
    screen--;
    player.setGL(height);
  }
}

public void screen3(){
  
  // dungeon background
  background(dungeon);
  displayUI(255);
  
  // determines wall height for specific area, varies w/ difficulty
  int wallHeight = 0;
  if (normal) wallHeight = height*2/3;
  if (hard) wallHeight = height/3;
  
  // creates left and right walls at specific locations
  leftWall = (player.getf(0) - player.getf(4) <= width/6 && player.getf(2) > height*2/3
    || player.getf(0) - player.getf(4) <= width*3/4 && player.getf(0)
    + player.getf(4) >= width*2/3 && player.getf(2) > wallHeight) ? true : false;
  rightWall = (player.getf(0) + player.getf(4) >= width*2/5 && player.getf(0)
    - player.getf(4) <= width*2/3 && player.getf(2) > wallHeight) ? true : false;
    
  // draws platforms
  fill(0);
  stroke(0);
  rectMode(CORNER);
  rect(0, height*2/3, width/6, height/3);
  rect(width*2/5, wallHeight, width*3/4 - width*2/5, height - wallHeight);
  
  // if the player is within these x positions, set the ground level to specified level
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
    
    nextTrack(1,3);
    
    // sets position of enemy on next screen
    e1 = new Human(-100,height,20,#FF0000);
    e1walk = false;
    e1dir = true;
    touch = true;
  }
  else if (player.getf(0) < 0){
    player.setX(width);
    screen--;
    
    nextTrack(1,2);
    
    // when go back a screen, reset conditions for countdown timer
    frameReset = frameCount%120;
    if (normal) timeReset = 10;
    if (hard) timeReset = 3;
  }
}

public void screen4(){
  
  // half dungeon, half sky background
  image(dungeon, -width/2,0);
  image(sky,width/2,0);
  displayUI(255);
  
  player.setGL(height);
  
  // if shield is touching enemy 1 and both exist, delete enemy, increase score
  if (!(shield == null || e1 == null) && shield.isTouching(e1)){
    e1 = null;
    score++;
  }
  
  // if enemy exists...
  else if (e1 != null){
    
    // and if player is/was on right half of screen
    if (e1walk){
      
      // display, fall, and walk enemy
      e1.display();
      e1.fall();
      
      // changes direction when it hits an edge
      if (e1dir) e1.walk(true);
      else e1.walk(false);
      
      // write menacing text
      fill(#FF0000);
      textAlign(CENTER,CENTER);
      textFont(comicSansMS,width/24);
      text("DIEEE!", e1.getf(0), e1.getf(1) - 4*e1.getf(4));
    }
    
    // deactivates shield if down is not currently being pressed
    shield = null;
    
    // if player touches enemy, subtract health by one
    // touch makes sure player won't lose health until touched again
    if (player.isTouching(e1) && touch){
      player.setHealth(player.getint(0)-1);
      touch = false;
    }
    else if (!player.isTouching(e1)) touch = true;
    
    // changes direction of e1 if it hits an edge
    if (e1.getf(0) > width) e1dir = false;
    else if (e1.getf(0) < 0) e1dir = true;
    if (normal && player.getf(0) >= width/2) e1walk = true;
    if (hard && player.getf(0) >= width/4) e1walk = true;
  }
  
  player.display();
  player.fall();
  
  if (player.getf(0) > width){
    player.setX(0);
    screen++;
    
    nextTrack(3,4);
    
    // sets position of enemy on next screen
    e2 = new Human(700,height,20,#000000);
    frameReset = frameCount%120;
    
    // erases bullets still on screen
    while (bt1.length > 0 && bt1[0] != null)
      bt1 = (Bullet[])subset(bt1,1,bt1.length-1);
  }
  else if (player.getf(0) < 0){
    nextTrack(3,1);
    
    player.setX(width);
    screen--;
  }
}

public void screen5(){
  
  // makes the background summer
  background(summer);
  displayUI(0);
  
  // if player is touching enemy 2, he dies (set equal to null), increment score
  if (e2 != null && player.isTouching(e2)){
    e2 = null;
    score++;
  }
  
  // if the enemy exists...
  else if (e2 != null){
    
    // display/fall enemy
    e2.display();
    e2.fall();
    
    // normal mode has slower bullets and slower launch rate
    if (normal && (frameCount - frameReset) % 120 == 0){
      
      // put bullet at first index of bt1 array
      bt1 = (Bullet[])append(bt1, e2.bullet(-10,0));
    }
    
    // hard mode has faster bullets and faster launch rate
    if (hard && (frameCount - frameReset) % 60 == 0){
      bt1 = (Bullet[])append(bt1, e2.bullet(-20,0));      
    }
    
    // write menacing text
    fill(0);
    textAlign(CENTER,CENTER);
    textFont(comicSansMS,width/30);
    text("HAIL THE", e2.getf(0), e2.getf(1) - 6*e2.getf(4));
    text("STICK GOD!", e2.getf(0), e2.getf(1) - 4*e2.getf(4));
  }
  
  for (Bullet bullet : bt1){
    
    // if the bullet is touching the shield, simply delete it
    if (!(bullet == null || shield == null) && bullet.isTouching(shield)){
      bt1 = (Bullet[])subset(bt1,1,bt1.length-1);
    }
    
    // if it touches the player, subtract health from player and delete bullet
    else if (bullet != null && bullet.isTouching(player)){
      bt1 = (Bullet[])subset(bt1,1,bt1.length-1);
      player.setHealth(player.getint(0)-1);
    }
    
    // if bullet is past left bound, delete it (saves memory)
    else if (bullet != null && bullet.getX() < 0){
      bt1 = (Bullet[])subset(bt1,1,bt1.length-1);
    }
    
    // otherwise, move and display the bullet
    else if (bullet != null){
      bullet.display();
      bullet.move();
    }
  }
  
  shield = null;
  
  player.setGL(height);
  
  player.display();
  player.fall();
  
  
  if (player.getf(0) > width){
    threshold = false;
    
    nextTrack(4,5);
    
    player.setX(0);
    screen++;
  }
  else if (player.getf(0) < 0){
    player.setX(width);
    screen--;
    
    nextTrack(4,3);
    
    // sets position of enemy on previous screen
    e1 = new Human(-100,height,20,#FF0000);
    e1walk = false;
    e1dir = true;
    touch = true;
  }
}

public void screen6(){
  
  background(desert);
  image(cave,500,450);
  
  // displays UI with white text
  displayUI(255);
  
  // sets ground level to bottom of the screen
  player.setGL(height);
  
  // displays an npc
  npc2.display();
  
  // if player touches npc, display some text above his head (varies w/ difficulty)
  if (player.isTouching(npc2) && !(threshold || already)){
    
    fill(#0000FF);
    textAlign(CENTER,CENTER);
    textFont(comicSansMS,width/30);
    if (normal) text("Welcome Stick Man! I have some neat advice." +
      "\nPress DOWN to activate your shield.\nYou'll definitely need it!",
      npc2.getf(0) + 5*npc2.getf(4), npc2.getf(1) - 5*npc2.getf(4));
    if (hard) text("...heh, good luck..", npc2.getf(0), npc2.getf(1) - 4*npc2.getf(4));
  }
  
  if (player.getf(0) > width/2) threshold = true;
  if (threshold && !already){
    noFill();
    stroke(200);
    ellipse(cx, 780, 40, 40);
    cx += v;
    if (cx == 100) v = 0;
    fill(#0000FF);
    textAlign(CENTER,CENTER);
    textFont(comicSansMS,width/30);
    if (normal) text("You don't want to end up\nlike this poor guy...",
      npc2.getf(0), npc2.getf(1) - 4*npc2.getf(4));
    if (hard) text("Mmm...dessert...", npc2.getf(0), npc2.getf(1) - 4*npc2.getf(4));
  }
  if (already){
    if (player.isTouching(npc2)){
      fill(#0000FF);
      textAlign(CENTER,CENTER);
      textFont(comicSansMS,width/30);
      if (normal) text("Welcome Stick Man! I have some neat advice." +
        "\nPress DOWN to activate your shield.\nYou'll definitely need it!",
        npc2.getf(0) + 5*npc2.getf(4), npc2.getf(1) - 5*npc2.getf(4));
      if (hard) text("...heh, good luck..", npc2.getf(0), npc2.getf(1) - 4*npc2.getf(4));
    }
    noFill();
    stroke(200);
    ellipse(cx, 780, 40, 40);
  }
  
  // display player, allow to fall
  player.display();
  player.fall();
  
  if (player.getf(0) < 0){
    
    nextTrack(5,4);
    
    // set player position to x=width
    player.setX(width);
    screen--;
    already = true;
  }
  else if (player.getf(0) > width){
    
    nextTrack(5,6);
    
    // set player position to x=0
    player.setX(0);
    screen++;
    already = true;
    
    // sets position of enemy on next screen
    e3 = new Human(500,height,20,255);
    frameReset = frameCount%120;
    while (bt1.length > 0 && bt1[0] != null)
      bt1 = (Bullet[])subset(bt1,1,bt1.length-1);
    if (hard){
      e4 = new Human(700,height,20,255);
      while (bt2.length > 0 && bt2[0] != null)
        bt2 = (Bullet[])subset(bt2,1,bt2.length-1);
    }
  }
}

public void screen7(){
  
  // dungeon background
  background(lava);
  displayUI(255);
  
  // creates left and right walls at specific locations
  rightWall = (player.getf(0) + player.getf(4) >= width/4 && player.getf(2) > height*5/6
    || player.getf(0) + player.getf(4) >= width/2 && player.getf(2) > height*2/3 ||
    player.getf(0) + player.getf(4) >= width*3/4 && player.getf(2) > height/3)
    ? true : false;
    
  // draws platforms
  fill(#FF0000);
  stroke(0);
  rectMode(CORNER);
  rect(width/4, height*5/6, width*3/4, height/6);
  rect(width/2, height*2/3, width/2, height/6);
  rect(width*3/4, height/3, width/4, height/3);
  
  // if the player is within these x positions, set the ground level to specified level
  if (player.getf(0) + player.getf(4) <= width/4) player.setGL(height);
  else if (player.getf(0) + player.getf(4) > width*3/4 && !rightWall)
    player.setGL(height/3);
  else if (player.getf(0) + player.getf(4) > width/2 && !rightWall)
    player.setGL(height*2/3);
  else if (player.getf(0) + player.getf(4) > width/4 && !rightWall)
    player.setGL(height*5/6);
    
  // if player is touching enemy 3, he dies (set equal to null), increment score
  if (e3 != null && player.isTouching(e3)){
    e3 = null;
    score++;
  }
  
  // if the enemy exists...
  else if (e3 != null){
    
    // display/fall enemy
    e3.setGL(height*2/3);
    e3.display();
    e3.fall();
    
    if ((frameCount - frameReset) % 120 == 0){
      
      // put bullet at first index of bt1 array
      bt1 = (Bullet[])append(bt1, e3.bullet(-10,0));
    }
  }
  
  if (hard && e4 != null && player.isTouching(e4)){
    e4 = null;
    score++;
  }
  
  // if the enemy exists...
  else if (hard && e4 != null){
    
    // display/fall enemy
    e4.setGL(height/3);
    e4.display();
    e4.fall();
    
    if ((frameCount - frameReset) % 120 == 0){
      
      // put bullet at first index of bt1 array
      bt2 = (Bullet[])append(bt2, e4.bullet(-10,0));
    }
  }
  
  for (Bullet bullet : bt1){
    
    // if the bullet is touching the shield, simply delete it
    if (!(bullet == null || shield == null) && bullet.isTouching(shield)){
      bt1 = (Bullet[])subset(bt1,1,bt1.length-1);
    }
    
    // if it touches the player, subtract health from player and delete bullet
    else if (bullet != null && bullet.isTouching(player)){
      bt1 = (Bullet[])subset(bt1,1,bt1.length-1);
      player.setHealth(player.getint(0)-1);
    }
    
    // if bullet is past left bound, delete it (saves memory)
    else if (bullet != null && bullet.getX() < 0){
      bt1 = (Bullet[])subset(bt1,1,bt1.length-1);
    }
    
    // otherwise, move and display the bullet
    else if (bullet != null){
      bullet.display();
      bullet.setSpeed(player.getf(0)*.05 - bullet.getX()*.05,
        player.getf(1)*.05 - bullet.getY()*.05);
      bullet.move();
    }
  }
  
  if (hard){
    for (Bullet bullet : bt2){
      
      // if the bullet is touching the shield, simply delete it
      if (!(bullet == null || shield == null) && bullet.isTouching(shield)){
        bt2 = (Bullet[])subset(bt2,1,bt2.length-1);
      }
      
      // if it touches the player, subtract health from player and delete bullet
      else if (bullet != null && bullet.isTouching(player)){
        bt2 = (Bullet[])subset(bt2,1,bt2.length-1);
        player.setHealth(player.getint(0)-1);
      }
      
      // if bullet is past left bound, delete it (saves memory)
      else if (bullet != null && bullet.getX() < 0){
        bt2 = (Bullet[])subset(bt2,1,bt2.length-1);
      }
      
      // otherwise, move and display the bullet
      else if (bullet != null){
        bullet.display();
        bullet.setSpeed(player.getf(0)*.05 - bullet.getX()*.05,
          player.getf(1)*.05 - bullet.getY()*.05);
        bullet.move();
      }
    }
  }
  
  shield = null;
  
  player.display();
  player.fall();
  
  if (player.getf(0) > width){
    player.setX(0);
    nextTrack(6,7);
    screen++;
    player.setGL(height/3);
  }
  else if (player.getf(0) < 0){
    nextTrack(6,5);
    player.setX(width);
    screen--;
  }
}

public void screen8(){
  
  background(lava);
  displayUI(255);
  
  fill(0);
  stroke(0);
  player.setGL(height/3);
  rect(0,height/3, 300, 700);
  rect(500,height/3, 300, 700);
  
  rightWall = (player.getf(0) + player.getf(4) >= width) ? true : false;
  
   if (player.getf(0) >=300 && player.getf(0)<500){
     player.setGL(1000);
   }
    if (player.getf(0) >= 300 && player.getf(1) >= 750){
      
      music[7].pause();
      music[7].rewind();
      player.setX(400);
      player.setY(-100);
      screen++;
      player.setGL(height);
    }
  
  
  if (player.getf(0) < 0){
    nextTrack(7,6);
    player.setX(width);
    screen--;
    player.setGL(height/2);
  }
  
  player.display();
  player.fall();
}

public void screen9(){
  
  background(lair);
  displayUI(0);
  npc3.display();
  player.display();
  player.fall();
  
  player.setGL(height);
  
  if (player.isTouching(npc3)){
    fill(255);
    textAlign(CENTER,CENTER);
    textFont(comicSansMS,width/24);
    text("Please....Save...Him.", npc3.getf(0), npc3.getf(1) - 4*npc3.getf(4));
  }
  
  leftWall = (player.getf(0) - player.getf(4) <= 0) ? true : false;
  
  player.display();
  player.fall();
  
  if (player.getf(0) > width){
    music[8].play();
    player.setX(0);
    screen++;
    boss = new Human(600,height,80,#D4D80F);
    if (normal) bossHealth = 6;
    if (hard) bossHealth = 15;
    touch = true;
    frameReset = frameCount%120;
    while (bt1.length > 0 && bt1[0] != null)
      bt1 = (Bullet[])subset(bt1,1,bt1.length-1);
  }
}

public void screen10(){
  
  background(0);
  displayUI(255);
  
  // if player is touching boss, he loses health, player is warped
  if (boss != null && player.isTouchingWeak(boss) && touch){
    if (boss.getColor() == #D4D80F) boss.setColor(#D11515);
    else boss.setColor(#D4D80F);
    player.setX(20);
    bossHealth--;
    touch = false;
  }
  else if (!player.isTouchingWeak(boss)) touch = true;
  
  if (bossHealth == 0){
    boss = null;
    score += 100;
    bossDead = true;
    dead = true;
    music[1].pause();
  }
  
  // if the enemy exists...
  else if (boss != null){
    
    // display/fall enemy
    boss.display();
    boss.fall();
    
    if (normal && (frameCount - frameReset) % 60 == 0){
      
      // put bullet at first index of bt1 array
      bt1 = (Bullet[])append(bt1, boss.bullet(-10,0));
    }
  }
  
  for (Bullet bullet : bt1){
    
    // if the bullet is touching the shield, simply delete it
    if (!(bullet == null || shield == null) && bullet.isTouching(shield)){
      bt1 = (Bullet[])subset(bt1,1,bt1.length-1);
    }
    
    // if it touches the player, subtract health from player and delete bullet
    else if (bullet != null && bullet.isTouching(player)){
      bt1 = (Bullet[])subset(bt1,1,bt1.length-1);
      player.setHealth(player.getint(0)-1);
    }
    
    // if bullet is past left bound, delete it (saves memory)
    else if (bullet != null && bullet.getX() < 0){
      bt1 = (Bullet[])subset(bt1,1,bt1.length-1);
    }
    
    // otherwise, move and display the bullet
    else if (bullet != null){
      bullet.display();
      bullet.setSpeed(player.getf(0)*.05 - bullet.getX()*.05,
          player.getf(1)*.05 - bullet.getY()*.05);
      bullet.move();
    }
  }
  
  // creates a left/right wall if player runs into left/right edge
  leftWall = (player.getf(0) - player.getf(4) <= 0) ? true : false;
  rightWall = (player.getf(0) + player.getf(4) >= width) ? true : false;
  player.display();
  player.fall();
}

public void nextTrack(int b, int a){
  music[b].pause();
  music[b].rewind();
  music[a].play();
}

void stop(){
  for (AudioPlayer p : music) p.close();
  minim.stop();
  super.stop();
}