final int GAMEBORAD_X = 100;
final int GAMEBORAD_Y = 100;

final int SPACE_NUMBER_X = 8;
final int SPACE_NUMBER_Y = 8;
final int SPACE_SIZE = 50;
String[][] spaceState = new String[SPACE_NUMBER_Y][SPACE_NUMBER_X];

String nowTurn;
boolean canPressMouse = true;

int passCount = 0;

int numOfWhite;
int numOfBlack;

String gameState = "gamePlay";

void setup(){
  size(900,600);
  gameInit();
}

void gameInit(){
  for(int i = 0;i < SPACE_NUMBER_Y;i++){
    for(int j = 0;j < SPACE_NUMBER_X;j++){
      spaceState[j][i] = "empty";
    }
  }
  spaceState[3][3] = "white";
  spaceState[3][4] = "black";
  spaceState[4][3] = "black";
  spaceState[4][4] = "white";
  
  nowTurn = "black";
  
  numOfWhite = getNumOfColor("white");
  numOfBlack = getNumOfColor("black");
}

void draw(){
  if(gameState == "gamePlay"){
    whenGamePlay();
  }
  if(gameState == "gameFinished"){
    whenGameFinished();
  }
}

void whenGamePlay(){
  background(255);
  for(int i = 0;i < SPACE_NUMBER_Y;i++){
    for(int j = 0;j < SPACE_NUMBER_X;j++){
      gameBoradDisplay(j,i);
      gameBoradUpdate(j,i);
    }
  }
  if(mousePressed == false){
    canPressMouse = true;
  }
  if(shouldPass()){
    nowTurn = getReverseTurn();
    passCount++;
  }else{
    passCount = 0;
  }
  
  if(2 <= passCount||isFinished()){
    gameState = "gameFinished";
  }
  
  textSize(30);
  fill(0);
  text("nowTurn:"+nowTurn,GAMEBORAD_X + SPACE_SIZE*SPACE_NUMBER_X + 20,GAMEBORAD_Y + 30);
  text("white:"+numOfWhite,GAMEBORAD_X + SPACE_SIZE*SPACE_NUMBER_X + 20,GAMEBORAD_Y + 60);
  text("black:"+numOfBlack,GAMEBORAD_X + SPACE_SIZE*SPACE_NUMBER_X + 20,GAMEBORAD_Y + 90);
}

void whenGameFinished(){
  background(255);
  textSize(50);
  if(numOfWhite < numOfBlack){
    centerText("Black Win!!!",500);
  }
  if(numOfWhite > numOfBlack){
    centerText("White Win!!!",500);
  }
  if(numOfWhite == numOfBlack){
    centerText("Draw!!!",500);
  }
  textSize(25);
  centerText("PressAnyKeyNewGame",300);
  if(keyPressed){
    gameInit();
    gameState = "gamePlay";
  }
}

void centerText(String text,int y){
  text(text,width/2 - textWidth(text)/2,y);
}

void gameBoradDisplay(int yIndex,int xIndex){
  int topLeftX = SPACE_SIZE*yIndex+GAMEBORAD_X;
  int topLeftY = SPACE_SIZE*xIndex+GAMEBORAD_Y;
  fill(5,77,0);
  rect(topLeftX,topLeftY,SPACE_SIZE,SPACE_SIZE);
  if(spaceState[yIndex][xIndex] == "empty"){
    return;
  }
  if(spaceState[yIndex][xIndex] == "white"){
    fill(255);
  }
  if(spaceState[yIndex][xIndex] == "black"){
    fill(0);
  }
  ellipse(topLeftX + SPACE_SIZE/2,topLeftY + SPACE_SIZE/2,SPACE_SIZE * 0.8,SPACE_SIZE * 0.8);
}

void gameBoradUpdate(int yIndex,int xIndex){
  int topLeftX = SPACE_SIZE * yIndex + GAMEBORAD_X;
  int topLeftY = SPACE_SIZE * xIndex + GAMEBORAD_Y;
  boolean isClicked = isOnMouseRect(topLeftX,topLeftY,SPACE_SIZE,SPACE_SIZE) && mousePressed && canPressMouse;
  if(isClicked && canPutDown(yIndex,xIndex)){
    putDown(yIndex,xIndex);
    nowTurn = getReverseTurn();
    canPressMouse = false;
    
    numOfWhite = getNumOfColor("white");
    numOfBlack = getNumOfColor("black");
  }
}

String getReverseTurn(){
  if(nowTurn == "white"){
    return "black";
  }else{
    return "white";
  }
}

boolean isOnMouseRect(float x,float y,int w,int h){
  return ((x < mouseX)&&(mouseX < x + w)&&(y < mouseY)&&(mouseY < y + h));
}

boolean canPutAboutOneDirection(int yIndex,int xIndex,int yVector,int xVector){
  int count = 0;
  do{
    count++;
    xIndex += xVector;
    yIndex += yVector;
    if(xIndex < 0 || SPACE_NUMBER_X <= xIndex || yIndex < 0 || SPACE_NUMBER_Y <= yIndex){
      return false;
    }
  }
  while(spaceState[yIndex][xIndex] == getReverseTurn());
  if(count <= 1){
    return false;
  }
  if(spaceState[yIndex][xIndex] == nowTurn){
    return true;
  }
  return false;
}

boolean canPutDown(int yIndex,int xIndex){
  if(spaceState[yIndex][xIndex] != "empty"){
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

void putDown(int yIndex,int xIndex){
  spaceState[yIndex][xIndex] = nowTurn;
  for(int i = -1;i < 2;i++){
    for(int j = -1;j < 2;j++){
      reverseAboutOneDirection(yIndex,xIndex,j,i);
    }
  }
}

void reverseAboutOneDirection(int yIndex,int xIndex,int yVector,int xVector){
  if(canPutAboutOneDirection(yIndex,xIndex,yVector,xVector)){
    xIndex += xVector;
    yIndex += yVector;
    while(spaceState[yIndex][xIndex] != nowTurn){
      spaceState[yIndex][xIndex] = nowTurn;
      xIndex += xVector;
      yIndex += yVector;
    }
  }
}

boolean shouldPass(){
  for(int i = 0;i < SPACE_NUMBER_Y;i++){
    for(int j = 0;j < SPACE_NUMBER_X;j++){
      if(canPutDown(j,i)){
        return false;
      }
    }
  }
  return true;
}

int getNumOfColor(String _color){
  int numOfColor = 0;
  for(int i = 0;i < SPACE_NUMBER_Y;i++){
    for(int j = 0;j < SPACE_NUMBER_X;j++){
      if(spaceState[j][i] == _color){
        numOfColor ++;
      }
    }
  }
  return numOfColor;
}

boolean isFinished(){
  
  for(int i = 0;i < SPACE_NUMBER_Y;i++){
    for(int j = 0;j < SPACE_NUMBER_X;j++){
      if(spaceState[j][i] == "empty"){
        return false;
      }
    }
  }
  return true;
}
