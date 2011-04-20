import codeanticode.gsvideo.*;
class Button {
  
  //** sorry for the terrible code :( (but it works :D)**//
  
  String type;
  PImage b;
  //Main menu images
  PImage playOver;
  PImage musicOver;
  PImage backOver;
  PImage calibOver;
  PImage doneOver;
  PImage insOver;
  PImage exitPic;
  
  PImage ins1Over;
  PImage ins2Over;
  PImage exitO;
  PImage wand1O;
  PImage wand2O;
  
  //In game rollovers
  PImage eraseO;
  PImage stoneO;
  PImage iceO;
  PImage worksO;
  PImage oilO;
  PImage waterO;
  PImage fireO;
  PImage seedO;
  PImage woodO;
  PImage noMelO;
  PImage noRhyO;
  PImage insNextO;
  PImage insPrevO;

  int X;
  int Y;
  int wide;
  int high;
  int sec;
  int count;
  int menuSoundBuffer = 0;

  Button(String inType, int x, int y) {
    X = x;
    Y = y;
    type = inType;
    //main menu rollovers
    playOver = loadImage("playOver.gif");
    musicOver = loadImage("musicOver.gif");
    backOver = loadImage("backOver.gif");
    calibOver = loadImage("calibOver.gif");
    doneOver = loadImage("doneOver.gif");
    insOver = loadImage("insOver.gif");
    
    ins1Over = loadImage("insGameO.png");
    ins2Over = loadImage("insMechO.png");
    insNextO = loadImage("insNextO.png");
    insPrevO = loadImage("insPrevO.png");
    exitO = loadImage("exitO.gif");
    wand1O = loadImage("wand1O.gif");
    wand2O = loadImage("wand2O.gif");
    
    //ingame rollovers
    eraseO = loadImage("eraseO.gif");
    stoneO = loadImage("stoneO.gif");
    iceO = loadImage("iceO.gif");
    worksO = loadImage("worksO.gif");
    oilO = loadImage("oilO.gif");
    waterO = loadImage("waterO.gif");
    fireO = loadImage("fireO.gif");
    seedO = loadImage("seedO.gif");
    woodO = loadImage("woodO.gif");
    noMelO = loadImage("noMelO.gif");
    noRhyO = loadImage("noRhyO.gif");

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
    else if(inType == "backIns")
    {
      b = loadImage("back.gif");
    }
    else if(inType == "backCalib")
    {
      b = loadImage("back.gif");
    }
    else if(inType == "doneCalib")
    {
      b = loadImage("done.gif");
    }
    else if(inType == "calib")
    {
      b = loadImage("calib.gif");
    }
    else if(inType == "ins")
    {
      b = loadImage("ins.gif");
    }
    else if(inType == "wand1")
    {
      b = loadImage("wand1.gif");
    }
    else if(inType == "wand2")
    {
      b = loadImage("wand2.gif");
    }
    else if(inType == "ins1")
    {
      b = loadImage("insGame.png");
    }
    else if(inType == "ins2")
    {
      b = loadImage("insMech.png");
    }
    else if(inType == "insPrev")
    {
      b = loadImage("insPrev.png");
    }
    else if(inType == "insNext")
    {
      b = loadImage("insNext.png");
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
    else if (inType == "mainExit")
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
    else if (inType == "wood")
    {
      b = loadImage("wood.gif");
    }
    else if (inType == "clear")
    {
      b = loadImage("clear.gif");
    }
    else if (inType == "noMel")
    {
      b = loadImage("noMel.gif");
    }
    else if (inType == "noRhy")
    {
      b = loadImage("noRhy.gif");
    }
  }

//animate in the game menu
  void animate() {
    Y += 6;
    if( Y >= 0 && type!="exit" && type!="clear")
      Y = 0;
    else if(Y >=40)
    {
      Y=40;
    }
  }

//animate out the ui menu
  void animateOut() {
    Y -= 6;
    if((type=="exit" || type=="clear") && Y<-50)
    {
      Y=-50;
    }
    else if( Y <= -90 )
    {
      Y = -90 ;
      //draw grey rectangle when UI is off screen
      pushStyle();
      colorMode(RGB,255);
      fill(100,100,100,200);
      rect(0,0,1024,10);
      popStyle();
    }
      
  }

  void run(int i) {
    image(b, X, Y);
    //prevents ui sound from playing continuously when the mouse/wand is pressed
    if(menuSoundBuffer >0)
      menuSoundBuffer--;
    //println(gameFrame +"+"+ frameCount);
    if(ui.inGame == true)
    {
      //animate the game ui in if 
      if(wand1.y < 102 || wand2.y < 102 || gameFrame + 200 > frameCount)
      {
        animate();
      }
      else
        animateOut();
    }
    //selected icons (hover effects):
    if(type == "rhy1" && music.rhythm == 0 && !music.noRhythm)
    {
      image(rhy1Over, X, Y);
    }
    else if(type == "rhy2" && music.rhythm == 1 && !music.noRhythm)
    {
      image(rhy2Over, X, Y);
    }
    else if(type == "rhy3"&& music.rhythm == 2 && !music.noRhythm)
    {
      image(rhy3Over, X, Y);
    }
    else if(type == "rhy4"&& music.rhythm == 3 && !music.noRhythm)
    {
      image(rhy4Over, X, Y);
    }
    else if(type == "mel1"&& music.melody == 0 && !music.noMelody)
    {
      image(mel1Over, X, Y);
    }
    else if(type == "mel2"&& music.melody == 1 && !music.noMelody)
    {
      image(mel2Over, X, Y);
    }
    else if(type == "noMel" && music.noMelody)
    {
      image(noMelO,X,Y);
    }
    else if(type == "noRhy" && music.noRhythm)
    {
      image(noRhyO,X,Y);
    }
    else if(type == "wand1" && glob.nowCalibrating == 1)
    {
      image(wand1O,X,Y);
    }
    else if(type == "wand2" && glob.nowCalibrating == 2)
    {
      image(wand2O,X,Y);
    }
    else if(type == "ins1" && subPage == 1)
    {
      image(ins1Over,X,Y);
    }
    else if(type == "ins2" && subPage == 2)
    {
      image(ins2Over,X,Y);
    }
    
    
    //menu buttons by only the first wand/mouse, triggered by a press
    if(ui.cursorX > X && ui.cursorX < X + b.width && ui.cursorY > Y && ui.cursorY < Y + b.height+30 && ((glob.wand1Pressed() && page != 'c') || mousePressed))
    {
      //text(type,width/2,height/2);
      if(menuSoundBuffer == 0)
      {
        music.playMenuSound();
        menuSoundBuffer = 10;
      }
      //ui play button pressed
      if(type == "play")
      { 
        setHSB(233, 1,1,1);
        ui.inGame = true;  
        gameFrame = frameCount;      
        for(int k = 0; k < 11; k++)
        {
          ui.Main.buttonArray[k] = ui.Main.gameArray[k];
        }
        page = 'v';
      }
      //ui music button pressed
      else if (type == "music")
      {
        ui.inMusic = true;
        for(int k = 0; k < 11; k++)
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
      //ui instructions button pressed
      else if (type == "ins")
      {
        ui.inIns = true;
        for(int k = 0; k < 11; k++)
        {
          if(k > ui.Main.insArray.length - 1)
          {
            ui.Main.buttonArray[k] = null;
          }
          else {
            ui.Main.buttonArray[k] = ui.Main.insArray[k];
          }
        }
        page = 'i';
      }
      //music back button pressed
      else if (type == "back")
      {
        ui.inMusic = false;
        for (int k = 0; k < 11; k++)
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
      //instruction back button pressed
      else if (type == "backIns")
      {
        ui.inIns = false;
        ui.insPage = 0;
        subPage = 1;
        delay(250);
        wandVid.pause();
        if(!music.noRhythm)
          music.groove[music.rhythm].loop();
        for (int k = 0; k < 11; k++)
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
      //in-game exit button pressed
      else if(type == "exit")
      {
        ui.inGame = false;
        animateOut();
        for (int k = 0; k < 11; k++)
        {
          if( k > ui.Main.mainArray.length - 1)
          {
            ui.Main.buttonArray[k] = null;
          }
          else {
            ui.Main.buttonArray[k] = ui.Main.mainArray[k];
          }
        }
        reset();
        page = 'u';
      }
      //calibration back button pressed
      else if(type == "backCalib")
      {
        ui.inCalib = false;
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
      //ui calibration button pressed
      else if(type == "calib")
      {
        ui.inCalib = true;
        delay(250);
        for(int k = 0; k < 11; k++)
        {
          if(k > ui.Main.calibArray.length - 1)
          {
            ui.Main.buttonArray[k] = null;
          }
          else {
            ui.Main.buttonArray[k] = ui.Main.calibArray[k];
          }
        }
        page = 'c';
      } 
      //calibration done button pressed
      else if(type == "doneCalib")
      {
        ui.calibrationSuccess();
      } 
      //ui exit button pressed
      else if(type == "mainExit")
      {
        stop();
      } 
      //calibration wand1 button pressed
      else if(type == "wand1")
      {
        glob.nowCalibrating = 1;
      }
      //calibration wand2 button pressed
      else if(type == "wand2")
      {
        glob.nowCalibrating = 2;
      }
      //instructions gameplay button pressed
      else if(type == "ins1")
      {
        subPage = 1;
        delay(250);
        wandVid.pause();
        if(!music.noRhythm)
          music.groove[music.rhythm].loop();
      } 
      //instructions game mechanics button pressed
      else if(type == "ins2")
      {
        subPage = 2;
        delay(250);
        wandVid.goToBeginning();
        wandVid.play();
        music.groove[music.rhythm].pause();
      } 
      // previous instruction page pressed
      else if(type == "insPrev")
      {
        ui.insPage--;
        delay(250);
        if(ui.insPage<0)
          ui.insPage = 5;
      }
      // next instruction page pressed
      else if(type == "insNext")
      {
        ui.insPage++;
        delay(250);
        if(ui.insPage>5)
          ui.insPage = 0;
      }
      //particle types selected:
      else if (type == "erase")
      {
        changeParticle('e', 0);
      }
      else if(type == "fire")
      {
        changeParticle('f', 0);
      }
      else if(type == "stone")
      {
        changeParticle('c', 0);
      }
      else if(type == "ice")
      {
        changeParticle('i', 0);
      }
      else if(type == "works")
      {
        changeParticle('k', 0);
      }
      else if(type == "oil")
      {
        changeParticle('o', 0);
      }
      else if(type == "water")
      {
        changeParticle('w', 0);
      }
      else if(type == "seed")
      {
        changeParticle('s', 0);
      }
      else if(type == "wood")
      {
        changeParticle('d', 0);
      }
      //music options selected:
      else if(type == "rhy1")
      {
        music.setRhythm(0);
      }
      else if(type == "rhy2")
      {
        music.setRhythm(1);
      }
      else if(type == "rhy3")
      {
        music.setRhythm(2);
      }
      else if(type == "rhy4")
      {
        music.setRhythm(3);
      }
      else if(type == "mel1")
      {
        music.setMelody(0);
      }
      else if(type == "mel2")
      {
        music.setMelody(1);
      }
      else if(type == "noMel")
      {
        music.noMelody();
      }
      else if(type == "noRhy")
      {
        music.noRhythm();
      }
      else if(type == "clear")
      {
        reset();
      }
    }
    //ingame ui buttons by either wand
    else if(ui.cursor2X > X && ui.cursor2X < X + b.width && ui.cursor2Y > Y && ui.cursor2Y < Y + b.height+30 && glob.wand2Pressed())
    {
      if(type == "fire")
      {
        changeParticle('f', 1);
      }
      else if (type == "erase")
      {
        changeParticle('e', 1);
      }
      else if(type == "stone")
      {
        changeParticle('c', 1);
      }
      else if(type == "ice")
      {
        changeParticle('i', 1);
      }
      else if(type == "works")
      {
        changeParticle('k', 1);
      }
      else if(type == "oil")
      {
        changeParticle('o', 1);
      }
      else if(type == "water")
      {
        changeParticle('w', 1);
      }
      else if(type == "seed")
      {
        changeParticle('s', 1);
      }
      else if(type == "wood")
      {
        changeParticle('d', 1);
      }
      else if(type == "clear")
      {
        reset();
      }
      else if(type == "exit")
      {
        ui.inGame = false;
        animateOut();
        for (int k = 0; k < 11; k++)
        {
          if( k > ui.Main.mainArray.length - 1)
          {
            ui.Main.buttonArray[k] = null;
          }
          else {
            ui.Main.buttonArray[k] = ui.Main.mainArray[k];
          }
        }
        reset();
        page = 'u';
      }
      
    }
    //rollover effects
    else if(cursor1Over() || cursor2Over())
    {
      pushStyle();
      textSize(20);
      textAlign(CENTER);
      if(cursor1Over())
      {
        if(type == "play")
        {
          image(playOver, X, Y);
        }
        else if(type == "music")
        {
          image(musicOver, X, Y);
        }
        else if(type == "back" || type == "backIns" || type == "backCalib")
        {
          image(backOver, X, Y);
        }
        else if(type == "calib")
        {
          image(calibOver, X, Y);
        }
        else if(type == "doneCalib")
        {
          image(doneOver, X, Y);
        }
        else if(type == "ins")
        {
          image(insOver, X, Y);
        }
        else if(type == "ins1")
        {
          image(ins1Over, X, Y);
        }
        else if(type == "insPrev")
        {
          image(insPrevO, X, Y);
        }
        else if(type == "insNext")
        {
          image(insNextO, X, Y);
        }
        else if(type == "ins2")
        {
          image(ins2Over, X, Y);
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
        else if(type == "mainExit")
        {
          image(exitO, X, Y);
        }
        else if(type == "wand1")
        {
          image(wand1O, X, Y);
        }
        else if(type == "wand2")
        {
          image(wand2O, X, Y);
        }
      }
      if(type == "erase")
      {
        image(eraseO,X,Y);
        pushStyle();
        colorMode(RGB,255);
        fill(255,255);
        text("Eraser", X + b.width/2, 110);
        popStyle();
      }
      else if(type == "stone")
      {
        image(stoneO,X,Y);
        pushStyle();
        colorMode(RGB,255);
        fill(255,255);
        text("Stone", X + b.width/2, 110);
        popStyle();
      }
      if(type == "ice")
      {
        image(iceO,X,Y);
        pushStyle();
        colorMode(RGB,255);
        fill(255,255);
        text("Snow", X + b.width/2, 110);
        popStyle();
      }
      else if(type == "works")
      {
        image(worksO,X,Y);
        pushStyle();
        colorMode(RGB,255);
        fill(255,255);
        text("Fireworks", X + b.width/2, 110);
        popStyle();
      }
      else if(type == "oil")
      {
        image(oilO,X,Y);
        pushStyle();
        colorMode(RGB,255);
        fill(255,255);
        text("Oil", X + b.width/2, 110);
        popStyle();
      }
      else if(type == "water")
      {
        image(waterO,X,Y);
        pushStyle();
        colorMode(RGB,255);
        fill(255,255);
        text("Water", X + b.width/2, 110);
        popStyle();
      }
      else if(type == "fire")
      {
        image(fireO,X,Y);
        pushStyle();
        colorMode(RGB,255);
        fill(255,255);
        text("Fire", X + b.width/2, 110);
        popStyle();
      }
      else if(type == "seed")
      {
        image(seedO,X,Y);
        pushStyle();
        colorMode(RGB,255);
        fill(255,255);
        text("Seeds", X + b.width/2, 110);
        popStyle();
      }
      else if(type == "wood")
      {
        image(woodO,X,Y);
        pushStyle();
        colorMode(RGB,255);
        fill(255,255);
        text("Wood", X + b.width/2, 110);
        popStyle();
      }
      else if(type == "noMel")
      {
        image(noMelO,X,Y);
      }
      else if(type == "noRhy")
      {
        image(noRhyO,X,Y);
      }
      popStyle();
    }
  }
  boolean cursor1Over()
  {
    if(ui.cursorX > X && ui.cursorX < X + b.width && ui.cursorY > Y && ui.cursorY < Y + b.height+30)
      return true;
    else
      return false;
  }
  boolean cursor2Over()
  {
    if(ui.cursor2X > X && ui.cursor2X < X + b.width && ui.cursor2Y > Y && ui.cursor2Y < Y + b.height+30)
      return true;
    else
      return false;
  }
  //used to prevent emission if you're selecting a new particle type
  boolean isOverButton(int wand)
  {
    if(wand ==0)
    {
      if(ui.cursorX > X && ui.cursorX < X + b.width && ui.cursorY > Y && ui.cursorY < Y + b.height+30)
        return true;
      else
        return false;
    }
    else if(wand ==1)
    {
      if(ui.cursor2X > X && ui.cursor2X < X + b.width && ui.cursor2Y > Y && ui.cursor2Y < Y + b.height+30)
        return true;
      else
        return false;
    }
    else
      return false;
  }
}

