class UI
{
  Page Main;

  PFont font;
  int cursorX;
  int cursorY;
  int cursor2X;
  int cursor2Y;
  int Hue;
  int margin = 20;
  int tlength = 305;
  int theight = 13;
  boolean inGame;
  boolean inMusic;
  boolean inCalib;
  boolean inIns;
  PImage[] insPages = new PImage[6];
  PImage mechPage;
  int insPage = 0;

  UI()
  {

    font = loadFont("04b03-48.vlw");
    textFont(font,60);
    textSize(20);
    //noCursor();
    insPages[0] = loadImage("page01.png");
    insPages[1] = loadImage("page02.png");
    insPages[2] = loadImage("page03.png");
    insPages[3] = loadImage("page04.png");
    insPages[4] = loadImage("page05.png");
    insPages[5] = loadImage("page06.png");
    mechPage = loadImage("mech.png");
    
    inGame = false;
    inMusic = false;
    inCalib = false;
    inIns = false;
    Main = new Page();
    Hue = 0;
  }

  void run() 
  {
    rectMode(CORNER);
    colorMode(HSB, 1000, 255, 255, 100);
    
    Main.run();
    //turn off in 'v'
    if(page != 'v' && page != 'c' && page != 'i')
    {
      ease(10, 1, false);
    }
    else if(page == 'v')
    {
      cursorX = int(wand1.x);
      cursorY = int(wand1.y);
      cursor2X = int(wand2.x);
      cursor2Y = int(wand2.y);
      pushStyle();
      noFill();
      rectMode(CENTER);
      
      strokeWeight(8);
      stroke(color(0,0,0));
      if(emitters[0].type != 'e')
        rect(wand1.x, wand1.y, 20,20);
      if(emitters[1].type != 'e')
        rect(wand2.x, wand2.y, 20,20);
      
      strokeWeight(4);
      stroke(dye1);
      if(emitters[0].type != 'e')
        rect(wand1.x, wand1.y, 20,20);
      stroke(dye2);
      if(emitters[1].type != 'e')
        rect(wand2.x, wand2.y, 20,20);
      if(emitters[0].type == 'e')
      {
        strokeWeight(8);
        stroke(color(0,0,0));
        rect(wand1.x, wand1.y, 30,30);
        strokeWeight(4);
        if(emitters[0].isOn)
          stroke(dye1);
        else
          stroke(0,0,255);
        rect(wand1.x, wand1.y, 30,30);
        line(wand1.x - 15,wand1.y - 15,wand1.x + 15,wand1.y + 15);
        line(wand1.x - 15,wand1.y + 15,wand1.x + 15,wand1.y - 15);
      }
      if(emitters[1].type == 'e')
      {
        strokeWeight(8);
        stroke(color(0,0,0));
        rect(wand2.x, wand2.y, 30,30);
        strokeWeight(4);
        if(emitters[1].isOn)
          stroke(dye2);
        else
          stroke(0,0,255);
        rect(wand2.x, wand2.y, 30,30);
        line(wand2.x - 15,wand2.y - 15,wand2.x + 15,wand2.y + 15);
        line(wand2.x - 15,wand2.y + 15,wand2.x + 15,wand2.y - 15);
      }
      popStyle();
    }
    else if(page == 'i' && wandIsInput)
    {
      cursorX = int(wand1.x);
      cursorY = int(wand1.y);
      cursor2X = int(wand2.x);
      cursor2Y = int(wand2.y);
      pushStyle();
      colorMode(RGB, 255);
      rectMode(CENTER);
      fill(255,255,255);
      rect(cursorX, cursorY, 15,15);
      popStyle();
    }
    else
    {
      cursorX = int(wand1.x);
      cursorY = int(wand1.y);
      cursor2X = int(wand2.x);
      cursor2Y = int(wand2.y);
    }
    //TITLES
    //Main titles
    if(inGame == false && inCalib == false && inIns == false) {
      fill(Hue,255,255,100);
      if(cursorX + 100 + margin > width - margin - tlength) {
        if(inMusic == false)
        {
          textSize(60);
          text("PXLKRAFT", cursorX + 100 + margin, cursorY + 20);
        }
        else if(inMusic == true)
        {
          textSize(40);
          text("Select a track", cursorX + 100 + margin, cursorY + 20);
        }
        if(-tlength - margin + (cursorX + 100 + margin + margin + tlength - width) > margin) {
          if(inMusic == false)
          {
            textSize(60);
            text("PXLKRAFT", margin, cursorY + 20);
          }
          else if (inMusic == true)
          {
            textSize(40);
            text("Select a track", margin, cursorY + 20);
          }
        }
        else {
          if(inMusic == false)
          {
            textSize(60);
            text("PXLKRAFT", -tlength - margin + (cursorX + 100 + margin + margin + tlength - width), cursorY + 20);
          }
          if(inMusic == true)
          {
            textSize(40);
            text("Select a track", -tlength - margin + (cursorX + 100 + margin + margin + tlength - width), cursorY + 20);
          }
        }
      }
      else {
        if(inMusic == false)
        {
          textSize(60);
          text("PXLKRAFT", width - margin - tlength, cursorY + 20);
        }
        if(inMusic == true)
        {
          textSize(40);
          text("Select a track", width - margin - tlength, cursorY + 20);
        }
      }
      if(inMusic == false)
        //Credits
      {
        if(cursorY - 100 < ((2*margin) + (5*theight) + 40)) {
          textSize(15);
          text("MATT DEASE",        cursorX - 100 + margin, margin                       - (((2*margin) + (5*theight) + 40) - (cursorY - 100)));
          text("GRAEME ROMBOUGH",   cursorX - 100 + margin, margin + theight + 10        - (((2*margin) + (5*theight) + 40) - (cursorY - 100)));
          text("KYLE THOMPSON",     cursorX - 100 + margin, margin + (2 * theight) + 20  - (((2*margin) + (5*theight) + 40) - (cursorY - 100)));
          text("SUNMOCK YANG",      cursorX - 100 + margin, margin + (3 * theight) + 30  - (((2*margin) + (5*theight) + 40) - (cursorY - 100))); 
          text("PAUL YOUNG",        cursorX - 100 + margin, margin + (4 * theight) + 40  - (((2*margin) + (5*theight) + 40) - (cursorY - 100))); 
          if(height - (((2*margin) + (5*theight) + 40) - (cursorY - 100)) < (height - (2*margin) - (5 * theight) - 40)) {
            textSize(15);
            text("MATT DEASE",        cursorX - 100 + margin, height - (margin) - (5 * theight) - 40);
            text("GRAEME ROMBOUGH",   cursorX - 100 + margin, height - (margin) - (4 * theight) - 30);
            text("KYLE THOMPSON",     cursorX - 100 + margin, height - (margin) - (3 * theight) - 20);
            text("SUNMOCK YANG",      cursorX - 100 + margin, height - (margin) - (2 * theight) - 10);
            text("PAUL YOUNG",        cursorX - 100 + margin, height - (margin) - (theight));
          }
          else {
            textSize(15);
            text("MATT DEASE",        cursorX - 100 + margin, height + margin                       - (((2*margin) + (5*theight) + 40) - (cursorY - 100)));
            text("GRAEME ROMBOUGH",   cursorX - 100 + margin, height + margin + theight + 10        - (((2*margin) + (5*theight) + 40) - (cursorY - 100)));
            text("KYLE THOMPSON",     cursorX - 100 + margin, height + margin + (2 * theight) + 20  - (((2*margin) + (5*theight) + 40) - (cursorY - 100)));
            text("SUNMOCK YANG",      cursorX - 100 + margin, height + margin + (3 * theight) + 30  - (((2*margin) + (5*theight) + 40) - (cursorY - 100)));
            text("PAUL YOUNG",        cursorX - 100 + margin, height + margin + (4 * theight) + 40  - (((2*margin) + (5*theight) + 40) - (cursorY - 100)));
          }
        }
        else {
          textSize(15);
          text("MATT DEASE",        cursorX - 100 + margin, margin);
          text("GRAEME ROMBOUGH",   cursorX - 100 + margin, margin + theight + 10);
          text("KYLE THOMPSON",     cursorX - 100 + margin, margin + (2 * theight) + 20);
          text("SUNMOCK YANG",      cursorX - 100 + margin, margin + (3 * theight) + 30);
          text("PAUL YOUNG",        cursorX - 100 + margin, margin + (4 * theight) + 40);
        }
      }
    }
    //BOXES
    if(inGame == false && inCalib == false && inIns == false)
    {
      Hue += 1;
      if(Hue >= 1000)
        Hue = 0;
      fill(Hue,255,255,40);
      dye1 = color(Hue,255,255,40);
      noStroke();
      rect(cursorX-100,0,200,cursorY-100);
      rect(cursorX+100,cursorY-100,width-cursorX+100,200);
      rect(cursorX-100,cursorY+100,200,height-cursorY+100);
      rect(0,cursorY-100,cursorX-100,200);
    }
  }
  
  void calibrationSuccess()
  {
    wandIsInput = true;
    inCalib = false;
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
  
  void gameInstructions()
  {
    image(insPages[insPage],0,41);
  }
  
  void wandInstructions()
  {
    //if(wandVid.available()) 
    //{
    //  wandVid.read();
    //}
    image(mechPage, 0, 41);
    //image(wandVid, 0, 160);
  }
  void calibrateInstructions()
  {
    fill(225);
    textSize(30);
    text("Select wand to calibrate:", 380, 30);
    
    text("Notes:", 40, 280);
    text("Colors (R,G,B):", 640, 280);
    
    textSize(20);
    text("- Wand 1 should be Blue, and Orange when clicked", 40, 310);
    text("- Wand 2 should be Red, and Green when clicked", 40, 340);
    text("- Left click on the default color", 40, 370);
    text("- Right click on the clicked color", 40, 400);
    text("- Place the wand halfway between the center", 40, 430);
    text("and corner of the image for best tracking", 52, 450);
    rectMode(CORNER);
    fill(color(red(glob.wc1),green(glob.wc1),blue(glob.wc1)));
    rect(605, 310-20, 30,30);
    text("Wand 1:                "+ red(glob.wc1)+"," + green(glob.wc1)+"," + blue(glob.wc1), 640, 310);
    fill(color(red(glob.wcp1),green(glob.wcp1),blue(glob.wcp1)));
    rect(605, 340-20, 30,30);
    text("Wand 1 Clicked: "+ red(glob.wcp1)+"," + green(glob.wcp1)+"," + blue(glob.wcp1), 640, 340);
    fill(color(red(glob.wc2),green(glob.wc2),blue(glob.wc2)));
    rect(605, 370-20, 30,30);
    text("Wand 2:                "+ red(glob.wc2)+"," + green(glob.wc2)+"," + blue(glob.wc2), 640, 370);
    fill(color(red(glob.wcp2),green(glob.wcp2),blue(glob.wcp2)));
    rect(605, 400-20, 30,30);
    text("Wand 2 Clicked: "+ red(glob.wcp2)+"," + green(glob.wcp2)+"," + blue(glob.wcp2), 640, 400);
  }


  /* 1:1 mapping of the mouse/wand cursor to the visible cursor. Used mainly for debug
   void setCursor()
   {
   
   getMouse(); 
   
   cursorX = mouseX;
   cursorY = mouseY;
   
   }
   */

  //accuracy (float acc) allows for the visible cursor to have a small area of dead space where the mouse/wand cursor can move
  //without moving the visible cursor. This allow us to compenstate for glob jitter. Larger value = larger deadspace. 
  //Lower value = more accurate looking visible cursor). Value has to be greater than 1 (function compensates for values lower than 1)
  //
  //magnitude with Powers
  //magnitude (float magn) is the amount of easing. Lower value = more delay/slower. Higher value = closer to actual mouse/wand 
  //cursor. Cannot be bigger than 1 (function makes sure it isn't, defaults anything 1 or larger to 0.9999)
  //
  //magnitude with multiplication
  //magnitude (float magn) is the amount of easing. magnitude (float magn) is the amount of easing. Lower value = more delay/slower. Higher value = closer to actual mouse/wand 
  //cursor. Cannot be bigger than 0 or lower or larger than 10 (function makes sure it isn't, defaults anything 0 or lower to 1 and anything hight than 10 to 10)
  //
  //the type (boolean type) is true for opwers, false for multiplication

  void ease(float acc, float magn, boolean type)
  {

    if(acc < 1)
    {

      acc = 1;
    }

    if(magn >= 1 && type == true)
    {

      magn = .9999;
    }
    else if(magn <= 0 && type == false)
    {

      magn = 1;
    }
    else if(magn > 10 && type == false)
    {

      magn = 10;
    }

    float distX = wand1.x - cursorX;
    float distY = wand1.y - cursorY;

    if(distX > acc && type == true)
    {

      cursorX += pow(distX, magn);
    }
    else if(distX < -acc && type == true)
    {

      cursorX -= pow(abs(distX), magn);
    }

    if(distY > acc && type == true)
    {

      cursorY += pow(distY, magn);
    }
    else if(distY < -acc && type == true)
    {

      cursorY -= pow(abs(distY), magn);
    }
    else if(distX > acc && type == false)
    {

      cursorX += distX * .15;
    }
    else if(distX < -acc && type == false)
    {

      cursorX += distX * .15;
    }

    if(distY > acc && type == false)
    {

      cursorY += distY * .15;
    }
    else if(distY < -acc && type == false)
    {

      cursorY += distY * .15;
    }

    /* Debug output
     println("Distance X" + distX);
     println("Distance Y" + distY);
     println("");
     */
  }
}

