final int GAMEBORAD_X = 100;
final int GAMEBORAD_Y = 100;

final int SPACE_NUMBER_X = 8;
final int SPACE_NUMBER_Y = 8;
final int SPACE_SIZE = 50;
String[][] space_state = new String[SPACE_NUMBER_Y][SPACE_NUMBER_X];

void setup(){
  size(900,600);
  gameInit();
}

void gameInit(){
  for(int i = 0;i < SPACE_NUMBER_Y;i++){
    for(int j = 0;j < SPACE_NUMBER_X;j++){
      space_state[j][i] = "empty";
    }
  }
  space_state[3][3] = "white";
  space_state[3][4] = "black";
  space_state[4][3] = "black";
  space_state[4][4] = "white";
}

void draw(){
  background(255);
  for(int i = 0;i < SPACE_NUMBER_Y;i++){
    for(int j = 0;j < SPACE_NUMBER_X;j++){
      gameBoradDisplay(j,i);
      gameBoradUpdate(j,i);
    }
  }
}

void gameBoradDisplay(int yIndex,int xIndex){
  int topLeftX = SPACE_SIZE*yIndex+GAMEBORAD_X;
  int topLeftY = SPACE_SIZE*xIndex+GAMEBORAD_Y;
  fill(5,77,0);
  rect(topLeftX,topLeftY,SPACE_SIZE,SPACE_SIZE);
  if(space_state[yIndex][xIndex] == "empty"){
    return;
  }
  if(space_state[yIndex][xIndex] == "white"){
    fill(255);
  }
  if(space_state[yIndex][xIndex] == "black"){
    fill(0);
  }
  ellipse(topLeftX + SPACE_SIZE/2,topLeftY + SPACE_SIZE/2,SPACE_SIZE * 0.8,SPACE_SIZE * 0.8);
}

void gameBoradUpdate(int yIndex,int xIndex){
  int topLeftX = SPACE_SIZE*yIndex+GAMEBORAD_X;
  int topLeftY = SPACE_SIZE*xIndex+GAMEBORAD_Y;
  if(isOnMouseRect(topLeftX,topLeftY,SPACE_SIZE,SPACE_SIZE) && mousePressed){
    space_state[yIndex][xIndex] = "white";
  }
}

boolean isOnMouseRect(float x,float y,int w,int h){
  return ((x < mouseX)&&(mouseX < x + w)&&(y < mouseY)&&(mouseY < y + h));
}
