class Page{
  float tlength;
  float margin;
  float theight;
  Button[] buttonArray = new Button[11];
  Button[] mainArray = new Button[5];
  Button[] musicArray = new Button[9];
  Button[] gameArray = new Button[11];
  Button[] calibArray = new Button[4];
  Button[] insArray = new Button[5];

  Page(){ 
  mainArray[0] = new Button("music",width/2 - 75, height/2 - 51);
  mainArray[1] = new Button("play",width/4 - 75 , height/4 - 51);
  mainArray[2] = new Button("calib",(width - (width/4)) - 75, (height - (height/4)) - 51);
  mainArray[3] = new Button("ins",(width - (width/4)) - 75, height/4 - 51);
  mainArray[4] = new Button("mainExit",50, height - 80);
  
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
  buttonArray[3] = mainArray[3];
  buttonArray[4] = mainArray[4];
  
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
  
  calibArray[0] = new Button("doneCalib",width - 200, 600);
  calibArray[1] = new Button("backCalib",50, 600);
  calibArray[2] = new Button("wand1", 370, 50);
  calibArray[3] = new Button("wand2", 570, 50);
  
  insArray[0] = new Button("backIns", width - 200, 43);
  insArray[1] = new Button("ins1", 0, 0);
  insArray[2] = new Button("ins2", 160, 0);
  insArray[3] = new Button("insPrev", 900, 674);
  insArray[4] = new Button("insNext", 967, 674);
  }
  
  void run(){
    if(ui.inIns == true && subPage == 2)
    {
      for(int i = 0; i < 3; i++)
      {
        if(buttonArray[i] != null)
        {
          buttonArray[i].run(i);
         // println(buttonArray[i].type);
        }
      }
    }
    else
    {
      for(int i = buttonArray.length-1; i >= 0; i--){
        if(buttonArray[i] != null)
        {
          buttonArray[i].run(i);
         // println(buttonArray[i].type);
        }
      }
    }
    
    
  }
}


