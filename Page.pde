class Page{
  float tlength;
  float margin;
  float theight;
  Button[] buttonArray = new Button[11];
  Button[] mainArray = new Button[3];
  Button[] musicArray = new Button[9];
  Button[] gameArray = new Button[11];
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
  musicArray[7] = new Button("noMel",width/2 + 200, height/2 - 120);
  musicArray[8] = new Button("noRhy",width/2 + 200, height/2 + 20);
  
  buttonArray[0] = mainArray[0];
  buttonArray[1] = mainArray[1];
  buttonArray[2] = mainArray[2];
  
  gameArray[0] = new Button ("exit", 0, -50);
  gameArray[1] = new Button ("erase",126-45, -90);
  gameArray[2] = new Button ("stone", 229-45, -90);
  gameArray[3] = new Button ("ice",  332-45, -90);
  gameArray[4] = new Button ("works", 435-45, -90);
  gameArray[5] = new Button ("oil", 538-45, -90);
  gameArray[6] = new Button ("water", 615-45, -90);
  gameArray[7] = new Button ("fire", 692-45, -90);
  gameArray[8] = new Button ("seed", 769-45, -90);
  gameArray[9] = new Button ("wood", 769+45+10, -90);
  gameArray[10] = new Button ("clear", 956, -50);
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


