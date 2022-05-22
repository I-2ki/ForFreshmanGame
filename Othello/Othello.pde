final int GAMEBORAD_X = 100;
final int GAMEBORAD_Y = 100;

final int SPACE_NUMBER_X = 8;
final int SPACE_NUMBER_Y = 8;
final int SPACE_SIZE = 50;

void setup(){
  size(900,600);
}

void draw(){
  background(255);
  gameBoradDisplay();
}

void gameBoradDisplay(){
  for(int i = 0;i < SPACE_NUMBER_Y;i++){
    for(int j = 0;j < SPACE_NUMBER_X;j++){
      fill(5,77,0);
      rect(SPACE_SIZE*j+GAMEBORAD_X,SPACE_SIZE*i+GAMEBORAD_Y,SPACE_SIZE,SPACE_SIZE);
    }
  }
}
