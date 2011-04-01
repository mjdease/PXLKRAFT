class Page{
  float tlength;
  float margin;
  float theight;
  Button[] buttonArray = new Button[9];
  Button[] mainArray = new Button[3];
  Button[] musicArray = new Button[7];
  Button[] gameArray = new Button[9];
  Button[] calibArray = new Button[0];

  Page(){ 
  mainArray[0] = new Button("music",width/2 - 75, height/2 - 51);
  mainArray[1] = new Button("play",width/4 - 75 , height/4 - 51);
  mainArray[2] = new Button("calib",(width - (width/4)) - 75, (height - (height/4)) - 51);
  
  musicArray[0] = new Button("mel1",width/2 - 170, height/2 - 75 - 5 - 150);
  musicArray[1] = new Button("mel2",width/2 + 20,  height/2 - 75 - 5 - 150);
  musicArray[2] = new Button("rhy1",width/2 - 170, height/2 - 75);
  musicArray[3] = new Button("rhy2",width/2 + 20 , height/2 - 75);
  musicArray[4] = new Button("rhy3",width/2 - 170, height/2 + 75 + 20);
  musicArray[5] = new Button("rhy4",width/2 + 20 , height/2 + 75 + 20);
  musicArray[6] = new Button("back",width - 200, height - 200);
  
  buttonArray[0] = mainArray[0];
  buttonArray[1] = mainArray[1];
  buttonArray[2] = mainArray[2];
  
  gameArray[0] = new Button ("exit", 0, -63);
  gameArray[1] = new Button ("erase", width/2 - 63*4, -63);
  gameArray[2] = new Button ("stone", width/2 - 63*3, -63);
  gameArray[3] = new Button ("ice",   width/2 - 63*2, -63);
  gameArray[4] = new Button ("works", width/2 - 63, -63);
  gameArray[5] = new Button ("oil", width/2, -63);
  gameArray[6] = new Button ("water", width/2 + 63, -63);
  gameArray[7] = new Button ("fire", width/2 + 63*2, -63);
  gameArray[8] = new Button ("seed", width/2 + 63*3, -63);
  }
  
  void run(){
    for(int i = buttonArray.length-1; i >= 0; i--){
      if(buttonArray[i] != null)
      {
        buttonArray[i].run(i);
       // println(buttonArray[i].type);
      }
    }
    
    
  }
}


