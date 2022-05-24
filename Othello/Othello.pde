final int GAMEBORAD_X = 100;
final int GAMEBORAD_Y = 100;

final int NUMBER_OF_SQUARE_X = 8;
final int NUMBER_OF_SQUARE_Y = 8;
final int SQUARE_SIZE = 50;
String[][] squareStates = new String[NUMBER_OF_SQUARE_Y][NUMBER_OF_SQUARE_X];

String nowPlayerColor;
boolean canDetectMouse = true;

int numberOfPass = 0;
int numberOfWhite;
int numberOfBlack;

String gameState = "play";

void setup(){
  size(900,600);
  gameInit();
}

void gameInit(){
  for(int i = 0;i < NUMBER_OF_SQUARE_Y;i++){
    for(int j = 0;j < NUMBER_OF_SQUARE_X;j++){
      squareStates[j][i] = "empty";
    }
  }
  squareStates[3][3] = "white";
  squareStates[3][4] = "black";
  squareStates[4][3] = "black";
  squareStates[4][4] = "white";
  
  nowPlayerColor = "black";
  
  numberOfWhite = countNumberOf("white");
  numberOfBlack = countNumberOf("black");
}

void draw(){
  switch(gameState){
    case "play":
      gamePlay();
      break;
    case "result":
      gameResult();
      break;
    default:
      println("メッセージは出ないはずだよ");
      break;
  }
}

void gamePlay(){
  background(255);
  gameBoradDisplay();
  gameBoradUpdate();
  if(mousePressed == false){
    canDetectMouse = true;
  }
  
  textSize(30);
  fill(0);
  text("nowPlayerColor:"+nowPlayerColor,GAMEBORAD_X + SQUARE_SIZE*NUMBER_OF_SQUARE_X + 20,GAMEBORAD_Y + 30);
  text("white:"+numberOfWhite,GAMEBORAD_X + SQUARE_SIZE*NUMBER_OF_SQUARE_X + 20,GAMEBORAD_Y + 60);
  text("black:"+numberOfBlack,GAMEBORAD_X + SQUARE_SIZE*NUMBER_OF_SQUARE_X + 20,GAMEBORAD_Y + 90);
}

void gameResult(){
  background(255);
  textSize(50);
  String resultMessage;
  if(numberOfWhite == numberOfBlack){
    resultMessage = "Draw game";
  }else if(numberOfWhite >= numberOfBlack){
    resultMessage = "White win!";
  }else{
    resultMessage = "Black win";
  }
  drawTextCenter(resultMessage,500);
  textSize(25);
  drawTextCenter("New game with z key",300);
  
  if(keyPressed && key == 'z'){
    gameInit();
    gameState = "play";
  }
}

void drawTextCenter(String text,int y){
  text(text,width/2 - textWidth(text)/2,y);
}

void gameBoradDisplay(){
  for(int yIndex = 0;yIndex < NUMBER_OF_SQUARE_Y;yIndex++){
    for(int xIndex = 0;xIndex < NUMBER_OF_SQUARE_X;xIndex++){
      int topLeftX = SQUARE_SIZE * yIndex + GAMEBORAD_X;
      int topLeftY = SQUARE_SIZE * xIndex + GAMEBORAD_Y;
      fill(5,77,0);
      rect(topLeftX,topLeftY,SQUARE_SIZE,SQUARE_SIZE);
      if(squareStates[yIndex][xIndex] == "empty"){
        continue;
      }
      if(squareStates[yIndex][xIndex] == "white"){
        fill(255);
      }
      if(squareStates[yIndex][xIndex] == "black"){
        fill(0);
      }
      ellipse(topLeftX + SQUARE_SIZE/2,topLeftY + SQUARE_SIZE/2,SQUARE_SIZE * 0.8,SQUARE_SIZE * 0.8);
    }
  }
}

void gameBoradUpdate(){
  for(int yIndex = 0;yIndex < NUMBER_OF_SQUARE_Y;yIndex++){
    for(int xIndex = 0;xIndex < NUMBER_OF_SQUARE_X;xIndex++){
      int topLeftX = SQUARE_SIZE * yIndex + GAMEBORAD_X;
      int topLeftY = SQUARE_SIZE * xIndex + GAMEBORAD_Y;
      
      boolean isClicked = mousePressed && canDetectMouse && isMouseOnRect(topLeftX,topLeftY,SQUARE_SIZE,SQUARE_SIZE);
      if(isClicked && canPutDown(yIndex,xIndex)){
        putStone(yIndex,xIndex);
        nowPlayerColor = getEnemyColor();
        canDetectMouse = false;
        
        numberOfWhite = countNumberOf("white");
        numberOfBlack = countNumberOf("black");
        
        if(shouldPass()){
          nowPlayerColor = getEnemyColor();
          if(shouldPass()){
            gameState = "result";
          }
        }
      }
    }
  }
}

String getEnemyColor(){
  if(nowPlayerColor == "white"){
    return "black";
  }else{
    return "white";
  }
}

boolean isMouseOnRect(float x,float y,int w,int h){
  return ((x < mouseX)&&(mouseX < x + w)&&(y < mouseY)&&(mouseY < y + h));
}

boolean canPutAboutOneDirection(int yIndex,int xIndex,int yVector,int xVector){
  if(xVector == 0 && yVector == 0){
    return false;
  }
  int numberOfReversible = -1;
  do{
    numberOfReversible++;
    xIndex += xVector;
    yIndex += yVector;
    if(xIndex < 0 || NUMBER_OF_SQUARE_X <= xIndex || yIndex < 0 || NUMBER_OF_SQUARE_Y <= yIndex){
      return false;
    }
  }
  while(squareStates[yIndex][xIndex] == getEnemyColor());
  if(numberOfReversible <= 0){
    return false;
  }
  if(squareStates[yIndex][xIndex] == nowPlayerColor){
    return true;
  }
  return false;
}

boolean canPutDown(int yIndex,int xIndex){
  if(squareStates[yIndex][xIndex] != "empty"){
    return false;
  }
  for(int i = -1;i < 2;i++){
    for(int j = -1;j < 2;j++){
      if(canPutAboutOneDirection(yIndex,xIndex,j,i)){
        return true;
      }
    }
  }
  return false;
}

void putStone(int yIndex,int xIndex){
  squareStates[yIndex][xIndex] = nowPlayerColor;
  for(int i = -1;i < 2;i++){
    for(int j = -1;j < 2;j++){
      reverseAboutOneDirection(yIndex,xIndex,j,i);
    }
  }
}

void reverseAboutOneDirection(int yIndex,int xIndex,int yVector,int xVector){
  if(canPutAboutOneDirection(yIndex,xIndex,yVector,xVector)){
    while(squareStates[yIndex + yVector][xIndex + xVector] != nowPlayerColor){
      xIndex += xVector;
      yIndex += yVector;
      squareStates[yIndex][xIndex] = nowPlayerColor;
    }
  }
}

boolean shouldPass(){
  for(int i = 0;i < NUMBER_OF_SQUARE_Y;i++){
    for(int j = 0;j < NUMBER_OF_SQUARE_X;j++){
      if(canPutDown(j,i)){
        return false;
      }
    }
  }
  return true;
}

int countNumberOf(String colorName){
  int numberOfColor = 0;
  for(int i = 0;i < NUMBER_OF_SQUARE_Y;i++){
    for(int j = 0;j < NUMBER_OF_SQUARE_X;j++){
      if(squareStates[j][i] == colorName){
        numberOfColor++;
      }
    }
  }
  return numberOfColor;
}
