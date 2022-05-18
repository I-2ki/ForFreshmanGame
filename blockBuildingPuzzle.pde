String gameState = "gameTitle";

int paddle_x;
int paddle_y;
final int PADDLE_WIDTH = 100;
final int PADDLE_HEIGHT = 25;

float bullet_x = 0;
float bullet_y = 0;
final int BULLET_WIDTH = 10;
final int BULLET_HEIGHT = 10;
int bullet_speed_x = 5;
int bullet_speed_y = 5;

final int NUM_OF_BLOCK_X = 5;
final int NUM_OF_BLOCK_Y = 5;
final int BLOCK_WIDTH = 100;
final int BLOCK_HEIGHT = 50;
int[][] blocks_x = new int[NUM_OF_BLOCK_X][NUM_OF_BLOCK_Y];
int[][] blocks_y = new int[NUM_OF_BLOCK_X][NUM_OF_BLOCK_Y];
boolean[][] blocks_isAlive = new boolean[NUM_OF_BLOCK_X][NUM_OF_BLOCK_Y];

void setup(){
  size(500,800);
  frameRate(60);
  for(int i = 0;i < NUM_OF_BLOCK_Y;i++){
    for(int j = 0;j < NUM_OF_BLOCK_X;j++){
      blocks_x[j][i] = BLOCK_WIDTH*j;
      blocks_y[j][i] = BLOCK_HEIGHT*i;
    }
  }
  gameInit();
}

void gameInit(){
  paddle_x = width/2 - PADDLE_WIDTH/2;
  paddle_y = 700;
  
  bullet_x = random(0,width);
  bullet_y = 300;
  
  for(int i = 0;i < NUM_OF_BLOCK_Y;i++){
    for(int j = 0;j < NUM_OF_BLOCK_X;j++){
      blocks_isAlive[j][i] = true;
    }
  }
}

void draw(){
  background(0);
  switch(gameState){
    case "gameTitle":
      whenGameTitle();
      break;
    case "gamePlay":
      whenGamePlay();
      break;
    case "gameOver":
      whenGameOver();
      break;
    case "gameClear":
      whenGameClear();
      break;
    default:
      throw(new Error("Invaild gameState"));
  }
}

void whenGameTitle(){
  fill(255);
  textSize(50);
  centerText("BlockGame",100);
  textSize(25);
  centerText("ClickToStart",600);
  if(mousePressed){
    gameState = "gamePlay";
  }
}

void whenGamePlay(){
  paddleDisplay();
  paddleUpdate();
  bulletDisplay();
  bulletUpdate();
  blockDisplay();
  blockUpdate();
}

void whenGameOver(){
  fill(255,0,0);
  textSize(50);
  centerText("GameOver",300);
  if(frameCount%60 < 30){
    fill(255);
    textSize(30);
    centerText("ClickToRetry",400);
  }
  paddleDisplay();
  bulletDisplay();
  blockDisplay();
  if(mousePressed){
    gameInit();
    gameState = "gamePlay";
  }
}

void whenGameClear(){
  fill(255,255,0);
  textSize(70);
  centerText("GameClear!!!",400);
  fill(255);
  textSize(35);
  centerText("ClickToTitle",600);
  if(mousePressed){
    gameState = "gameTitle";
  }
}

void paddleDisplay(){
  fill(255);
  rect(paddle_x,paddle_y,PADDLE_WIDTH,PADDLE_HEIGHT,10);
}

void paddleUpdate(){
  paddle_x = mouseX - PADDLE_WIDTH/2;
  if(paddle_x < 0){
    paddle_x = 0;
  }
  if(width < paddle_x + PADDLE_WIDTH){
    paddle_x = width - PADDLE_WIDTH;
  }
  if(isHitRects(paddle_x,paddle_y,PADDLE_WIDTH,PADDLE_HEIGHT,bullet_x,bullet_y,BULLET_WIDTH,BULLET_HEIGHT)){
    bulletHitResponse(paddle_x,paddle_y,PADDLE_WIDTH,PADDLE_HEIGHT);
  }
}

void bulletDisplay(){
  fill(255);
  rect(bullet_x,bullet_y,BULLET_WIDTH,BULLET_HEIGHT);
}

void bulletUpdate(){
  bullet_x += bullet_speed_x;
  bullet_y += bullet_speed_y;
  
  if((bullet_x < 0) || (width < bullet_x + BULLET_WIDTH)){
    bullet_speed_x *= -1;
  }
  if(bullet_y < 0){
    bullet_speed_y *= -1;
  }
  if(height < bullet_y + BULLET_HEIGHT){
    gameState = "gameOver";
  }
}

void blockDisplay(){
  for(int i = 0;i < NUM_OF_BLOCK_Y;i++){
    for(int j = 0;j < NUM_OF_BLOCK_X;j++){
      if(!blocks_isAlive[j][i]){
        continue;
      }
      fill(255);
      rect(blocks_x[j][i],blocks_y[j][i],BLOCK_WIDTH,BLOCK_HEIGHT);
    }
  }
}

void blockUpdate(){
  for(int i = 0;i < NUM_OF_BLOCK_Y;i++){
    for(int j = 0;j < NUM_OF_BLOCK_X;j++){
      if(!blocks_isAlive[j][i]){
        continue;
      }
      if(isHitRects(blocks_x[j][i],blocks_y[j][i],BLOCK_WIDTH,BLOCK_HEIGHT,bullet_x,bullet_y,BULLET_WIDTH,BULLET_HEIGHT)){
        blocks_isAlive[j][i] = false;
        if(isClear()){
          gameState = "gameClear";
        }
        bulletHitResponse(blocks_x[j][i],blocks_y[j][i],BLOCK_WIDTH,BLOCK_HEIGHT);
      }
    }
  }
}

void centerText(String text,float y){
  text(text,width/2-textWidth(text)/2,y);
}

boolean isHitRects(float x1,float y1,int w1,int h1,float x2,float y2,int w2,int h2){
  if((x1 < x2 + w2)&&(x2 < x1 + w1)&&(y1 < y2 + h2)&&(y2 < y1 + h1)){
    return true;
  }
  return false;
}

void bulletHitResponse(float x,float y,int w,int h){
  if(bullet_x < x){
    bullet_x = x - BULLET_WIDTH;
    bullet_speed_x = -1;
  }
  if(x + w < bullet_x + BULLET_WIDTH){
    bullet_x = x + w;
    bullet_speed_x *= -1;
  }
  if(bullet_y < y){
    bullet_y = y - BULLET_HEIGHT;
    bullet_speed_y *= -1;
  }
  if(y + h < bullet_y + BULLET_HEIGHT){
    bullet_y = y + h;
    bullet_speed_y *= -1;
  }
}

boolean isClear(){
  for(int i = 0;i < NUM_OF_BLOCK_Y;i++){
    for(int j = 0;j < NUM_OF_BLOCK_X;j++){
      if(blocks_isAlive[j][i]){
        return false;
      }
    }
  }
  return true;
}
