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

  UI()
  {

    font = loadFont("04b03-48.vlw");
    textFont(font,60);
    textSize(20);
    //noCursor();

    inGame = false;
    inMusic = false;
    inCalib = false;
    Main = new Page();
    Hue = 0;
  }

  void run() 
  {
    rectMode(CORNER);
    colorMode(HSB, 1000, 255, 255, 100);
    
    Main.run();
    //turn off in 'v'
    if(page != 'v')
    {
      ease(10, 1, false);
    }
    else
    {
      cursorX = int(wand1.x);
      cursorY = int(wand1.y);
      cursor2X = int(wand2.x);
      cursor2Y = int(wand2.y);
      pushStyle();
      noFill();
      strokeWeight(4);
      rectMode(CENTER);
      stroke(dye1);
      if(emitters[0].type != 'e')
        rect(wand1.x, wand1.y, 20,20);
      stroke(dye2);
      if(emitters[1].type != 'e')
        rect(wand2.x, wand2.y, 20,20);
      if(emitters[0].type == 'e')
      {
        if(emitters[0].isOn)
          stroke(dye1);
        else
          stroke(0,0,255);
        rect(wand1.x, wand1.y, 20,20);
        line(wand1.x - 10,wand1.y - 10,wand1.x + 10,wand1.y + 10);
        line(wand1.x - 10,wand1.y + 10,wand1.x + 10,wand1.y - 10);
      }
      if(emitters[1].type == 'e')
      {
        if(emitters[1].isOn)
          stroke(dye2);
        else
          stroke(0,0,255);
        rect(wand2.x, wand2.y, 20,20);
        line(wand2.x - 10,wand2.y - 10,wand2.x + 10,wand2.y + 10);
        line(wand2.x - 10,wand2.y + 10,wand2.x + 10,wand2.y - 10);
      }
      popStyle();
    }
    //TITLES
    //Main titles
    if(inGame == false && inCalib == false) {
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
    if(inGame == false && inCalib == false)
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

