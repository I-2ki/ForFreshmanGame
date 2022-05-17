String gameState = "gamePlay";

int paddle_x;
int paddle_y;
final int PADDLE_WIDTH = 100;
final int PADDLE_HEIGHT = 25;

float bullet_x = 0;
float bullet_y = 0;
float pre_bullet_x = bullet_x;
float pre_bullet_y = bullet_y;
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
    default:
      throw(new Error("Invaild gameState"));
  }
}

void whenGameTitle(){
}

void whenGamePlay(){
  paddleUpdate();
  bulletUpdate();
  blockUpdate();
}

void whenGameOver(){
}

void paddleDisplay(){
  fill(255);
  rect(paddle_x,paddle_y,PADDLE_WIDTH,PADDLE_HEIGHT);
}

void paddleMove(){
  paddle_x = mouseX - PADDLE_WIDTH/2;
  if(paddle_x < 0){
    paddle_x = 0;
  }
  if(width < paddle_x + PADDLE_WIDTH){
    paddle_x = width - PADDLE_WIDTH;
  }
}

void paddleUpdate(){
  paddleDisplay();
  paddleMove();
}

void bulletDisplay(){
  fill(255);
  rect(bullet_x,bullet_y,BULLET_WIDTH,BULLET_HEIGHT);
}

void bulletMove(){
  bullet_x += bullet_speed_x;
  bullet_y += bullet_speed_y;
  
  if(bullet_x < 0 || width < bullet_x + BULLET_WIDTH){
    bullet_speed_x *= -1;
  }
  if(bullet_y < 0 || height < bullet_y + BULLET_HEIGHT){
    bullet_speed_y *= -1;
  }
  
  if(isHitRects(paddle_x,paddle_y,PADDLE_WIDTH,PADDLE_HEIGHT,bullet_x,bullet_y,BULLET_WIDTH,BULLET_HEIGHT)){
    bullet_speed_y = -abs(bullet_speed_y);
  }
}

void bulletUpdate(){
  bulletDisplay();
  bulletMove();
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
  blockDisplay();
}

boolean isHitRects(float x1,float y1,int w1,int h1,float x2,float y2,int w2,int h2){
  if((x1 < x2 + w2)&&(x2 < x1 + w1)&&(y1 < y2 + h2)&&(y2 < y1 + h1)){
    return true;
  }
  return false;
}

String bulletComingDirection(float x,float y,int w,int h){
  return "left";//return the direction
}
