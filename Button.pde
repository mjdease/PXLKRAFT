
class Button {
  String type;
  PImage b;
  //Main menu images
  PImage playOver;
  PImage musicOver;
  PImage backOver;
  PImage calibOver;
  PImage exitPic;


  int X;
  int Y;
  int wide;
  int high;
  int sec;
  int count;

  Button(String inType, int x, int y) {
    X = x;
    Y = y;
    type = inType;
    //main menu rollovers
    playOver = loadImage("playOver.gif");
    musicOver = loadImage("musicOver.gif");
    backOver = loadImage("backOver.gif");
    calibOver = loadImage("calibOver.gif");

    //fills the b image with 
    if(inType == "play")
    {
      b = loadImage("play.gif");
    }
    else if(inType == "music")
    {
      b = loadImage("music.gif");
    }
    else if(inType == "back")
    {
      b = loadImage("back.gif");
    }
    else if(inType == "calib")
    {
      b = loadImage("calib.gif");
    }
    else if(inType == "mel1")
    {
      b = loadImage("mel1.gif");
    }
    else if(inType == "mel2")
    {
      b = loadImage("mel2.gif");
    }
    else if(inType == "rhy1")
    {
      b = loadImage("rhy1.gif");
    }
    else if (inType == "rhy2")
    {
      b = loadImage("rhy2.gif");
    }
    else if (inType == "rhy3")
    {
      b = loadImage("rhy3.gif");
    }
    else if (inType == "rhy4")
    {
      b = loadImage("rhy4.gif");
    }
    else if (inType == "exit")
    {
      b = loadImage("exit.gif");
    }
    else if (inType == "erase")
    {
      b = loadImage("erase.gif");
    }
    else if (inType == "stone")
    {
      b = loadImage("stone.gif");
    }
    else if (inType == "ice")
    {
      b = loadImage("ice.gif");
    }
    else if (inType == "works")
    {
      b = loadImage("works.gif");
    }
    else if (inType == "oil")
    {
      b = loadImage("oil.gif");
    }
    else if (inType == "water")
    {
      b = loadImage("water.gif");
    }
    else if (inType == "fire")
    {
      b = loadImage("fire.gif");
    }
    else if (inType == "seed")
    {
      b = loadImage("seed.gif");
    }
  }

  void animate() {
    text("animating",20,20);
    Y -= 2;
    if( Y <= height - 63)
      Y = height - 63;
  }

  void animateOut() {
    Y += 2;
    if( Y >= height)
      Y = height;
  }

  void run(int i) {
    image(b, X, Y);
    if(ui.inGame == true && mouseY > height - 63)
    {
      animate();
    }
    else if(ui.inGame == true) {
      animateOut();
    }
    if(ui.cursorX > X && ui.cursorX < X + b.width && ui.cursorY > Y && ui.cursorY < Y + b.height && mousePressed)
    {
      text(type,width/2,height/2);
      if(type == "play")
      { 
        ui.inGame = true;        
        for(int k = 0; k < 9; k++)
        {
          ui.Main.buttonArray[k] = ui.Main.gameArray[k];
        }
        page = 'v';
      }
      else if (type == "music")
      {
        ui.inMusic = true;
        for(int k = 0; k < 9; k++)
        {
          if(k > ui.Main.musicArray.length - 1)
          {
            ui.Main.buttonArray[k] = null;
          }
          else {
            ui.Main.buttonArray[k] = ui.Main.musicArray[k];
          }
        }
        page = 'm';
      }
      else if (type == "back")
      {
        ui.inMusic = false;
        for (int k = 0; k < 9; k++)
        {
          if( k > ui.Main.mainArray.length - 1)
          {
            ui.Main.buttonArray[k] = null;
          }
          else {
            ui.Main.buttonArray[k] = ui.Main.mainArray[k];
          }
        }
        page = 'u';
      }
      else if(type == "exit")
      {
        ui.inGame = false;
        animateOut();
        for (int k = 0; k < 9; k++)
        {
          if( k > ui.Main.mainArray.length - 1)
          {
            ui.Main.buttonArray[k] = null;
          }
          else {
            ui.Main.buttonArray[k] = ui.Main.mainArray[k];
          }
        }
        page = 'u';
      }
      else if(type == "calib")
      {
        page = 'c';
      }
      else if(type == "fire")
      {
        //TODO change variables
        background(255);
      }
    }
    else if(ui.cursorX > X && ui.cursorX < X + b.width && ui.cursorY > Y && ui.cursorY < Y + b.height)
    {
      if(type == "play")
      {
        image(playOver, X, Y);
      }
      else if(type == "music")
      {
        image(musicOver, X, Y);
      }
      else if(type == "back")
      {
        image(backOver, X, Y);
      }
      else if(type == "calib")
      {
        image(calibOver, X, Y);
      }
      else if(type == "rhy1")
      {
        image(rhy1Over, X, Y);
      }
      else if(type == "rhy2")
      {
        image(rhy2Over, X, Y);
      }
      else if(type == "rhy3")
      {
        image(rhy3Over, X, Y);
      }
      else if(type == "rhy4")
      {
        image(rhy4Over, X, Y);
      }
      else if(type == "mel1")
      {
        image(mel1Over, X, Y);
      }
      else if(type == "mel2")
      {
        image(mel2Over, X, Y);
      }
    }
  }
}

