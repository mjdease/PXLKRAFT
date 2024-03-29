class Glob implements Runnable
{
  
  import JMyron.*;
  JMyron m;
  
  boolean running;
  
  //background colour
  int rB,gB,bB;
  
  // wand 1 variables
  color wc1, wcp1; // wand 1 colours
  int x1,y1; // wand 1 position
  int px1 = -1; //position of the wand in the previous frame
  int py1 = -1;
  boolean click1 , pclick1; // whether it is/was clicked
  boolean isSet1; // whether the colours have been detected in the globs
  
  boolean wand1IsOff = false; // whether the wand is on the screen
  boolean wand2IsOff = false;
  
  // wand 2 variables
  color wc2, wcp2;
  int x2,y2;
  int px2 = -1;
  int py2 = -1;
  boolean click2 , pclick2;
  boolean isSet2;
  //PVector v2;
  
  boolean calDone;
  
  // vectors to be set and returned to the other classes on the wand positions
  PVector vector;
  PVector vector2;
  
  // threshold
  int threshold; // NOT BEING USED
  int thresh = 200;
  
  int calibratedR, calibratedG, calibratedB; // variables that are set to the blob colours when tracking
  int closestColor;
  
  //wand selector counter
  int wand;
  int wandClick;
  
  float wr;
  float hr;
  
  int w;
  int h;
  
  int[] img;
  PImage pImg = createImage(320, 240, RGB);
  
  int nowCalibrating = 1;
  
  Glob (int wid , int hei)
  {
    running = false;
    
    w = 320;
    h = 240;
    
    //wr = wid / w;
    //hr = hei / h;
    wr = 3.303;
    hr = 3.339;
    
    // minimum glob size
    int minGlob = 10;
    
    threshold = 10; //NOT BEING USED
    
    wand = wandClick = 0;
    
    //size(w,h);
    
    // start JMyron Object
    m = new JMyron();
    m.start(w,h);
    m.findGlobs(1);
    m.minDensity(minGlob); //set minimum glob size in jmyron
    //println("Myron " + m.version());
    
    //v1 = new PVector(0 , 0);
    //v2 = new PVector(0 , 0);
    
    vector = new PVector(0 , 0);
    vector2 = new PVector(0 , 0);
    noStroke();
    noFill();
  }
  
  void start()
  {
    // Start Tracking
    running = true;
    
    //super.start();
  }
  
  void run()
  {
    //println("threading");
     while(running)
     {
        track();
     }
  }
  
  void track()
  {
    pushStyle();
    colorMode(RGB, 255);
    
    // at the start of the frame, set the variables so that neither wands have been detected
    isSet1 = false;
    isSet2 = false;
    //println("running");
    archive();
    m.update();
    m.trackNotColor(rB,gB,bB,100);
    
    int[][] a; //Array of points for the glob boxes
    int[] b;
    int centroidX, centroidY, rr,gg,bb;
    color c;
    int hueDiff, satDiff, briDiff;
    int wc1Correl, wcp1Correl, wc2Correl, wcp2Correl;
    
    a = m.globBoxes(); //get all the globs and put them in the array.
    //println(a.length);
    stroke(255,255,0);
    for(int i=0;i<a.length;i++)
    {
      b = a[i];
      //rect(b[0], b[1], b[2], b[3]);
      centroidX = b[0]+b[2]/2; // get the center of the globs (The globCenter() function didn't work)
      centroidY = b[1]+b[3]/2;
      //point(centroidX,centroidY);
      
      //c = m.average(b[0],b[1],b[0] + b[2],b[1] + b[3]);
      c = m.average(centroidX-2,centroidY-2,centroidX+2,centroidY+2);// get the average colour of a 4x4 box around the center
      
      // set the RGB values from the average colour
      calibratedR = int(red(c));
      calibratedG = int(green(c));
      calibratedB = int(blue(c));
      
      // calculate correlation values for each of the four calibrated colors
      wc1Correl = int(abs(calibratedR - red(wc1)) + abs(calibratedG - green(wc1)) + abs(calibratedB - blue(wc1)));
      wcp1Correl = int(abs(calibratedR - red(wcp1)) + abs(calibratedG - green(wcp1))+ abs(calibratedB - blue(wcp1)));
      wc2Correl = int(abs(calibratedR - red(wc2)) + abs(calibratedG - green(wc2))+ abs(calibratedB - blue(wc2)));
      wcp2Correl = int(abs(calibratedR - red(wcp2)) + abs(calibratedG - green(wcp2)) + abs(calibratedB - blue(wcp2)));
      // choose the color that matches best
      closestColor = min(min(wc1Correl, wcp1Correl), min(wc2Correl, wcp2Correl));
      if(closestColor < thresh)
      {
        // If the colour matches the wand colour,
        // set the position of the wand, whether it is clicked or not,
        // and set the variable saying that wand 1 or 2 is on screen to true.
        if(closestColor == wc1Correl)
        {
          x1 = centroidX;
          y1 = centroidY;
          click1 = false;
          isSet1=true;
          //println("wand 1 " + hue(wc1));
        }
        if(closestColor == wcp1Correl)
        {
          x1 = centroidX;
          y1 = centroidY;
          click1 = true;
          isSet1=true;
          //println("clicked 1 " + hue(wcp1));
        }
        if(closestColor == wc2Correl)
        {
          x2 = centroidX;
          y2 = centroidY;
          click2 = false;
          isSet2=true;
          //println("wand 2 " + hue(wc2));
        }
        if(closestColor == wcp2Correl)
        {
          x2 = centroidX;
          y2 = centroidY;
          click2 = true;
          isSet2=true;
          //println("clicked 2 " + hue(wcp2));
        }
      }
    }
    popStyle();
  }
  
  //This function is called to return the vector of the wands
  PVector getPos1()
  {
    if(!isSet1)
    {
      //vector.set(-100 , 100 , 0);//round(px1 * wr) , round(py1 * hr) , 0);
      wand1IsOff = true;
      return vector;
    }
    else
    {
      //println(x1 +"+"+ y1);
      vector.set(round(x1 * wr) , round(y1 * hr) , 0);
      wand1IsOff = false;
      return vector;
    }
  }
  
  PVector getPos2()
  {
    if(!isSet2)
    {
      //vector2.set(-100 , 100 , 0);//round(px2 * wr) , round(py2 * hr) , 0
      wand2IsOff = true;
      return vector2;
    }
    else
    {
      vector2.set(round(x2 * wr) , round(y2 * hr) , 0);
      wand2IsOff = false;
      return vector2;
    }
  }
  
  // returns previous vectors
  PVector getPPos1()
  {
      vector.set(round(px1 * wr) , round(py1 * hr) , 0);
      return vector;
  }
  
  PVector getPPos2()
  {
      vector2.set(round(px2 * wr) , round(py2 * hr) , 0);
      return vector2;
  }
  
  // returns the states of the wands
  boolean isDown1()
  {
    return (click1);
  }
  
  boolean isDown2()
  {
    return (click2);
  }
  
  boolean wasDown1()
  {
     return (pclick1); 
  }
  
  boolean wasDown2()
  {
     return (pclick2); 
  }
  boolean wand1Pressed()
  {
    if(!pclick1 && click1)
      return true;
    else
      return false;
  }
  boolean wand2Pressed()
  {
    if(!pclick2 && click2)
      return true;
    else
      return false;
  }
  
   void archive()
  {  
     px1 = x1;
     py1 = y1;
     px2 = x2;
     py2 = y2;
    
     pclick1 = click1;
     pclick2 = click2;
        
   }
  
  void calibrate()
  {
    pushStyle();
    colorMode(RGB, 255);
    m.update();
    img = m.cameraImage();
    pImg.loadPixels();
    for(int i =0;i<w*h;i++)
    {
      pImg.pixels[i] = img[i];
    }
    pImg.updatePixels();
    image(pImg, 0, 0); // Draw the camera input on the screen
    
    //And I helped - Paul
    pushStyle();
    
    noFill();
    colorMode(RGB , 255);
    stroke(255 , 0 , 0);
    strokeWeight(2);
    
    rect(70 , 180 , 30 , 30); // Draw the calibration rectangle
    
    popStyle();
    
    //println(int(red(c))+"," + int(green(c)) + "," + int(blue(c)) + ":" + mouseX +";"+mouseY);
    
    for(int i = 0; i<ui.Main.calibArray.length; i++)
    {
      if(ui.Main.calibArray[i].isOverButton(0))
        return;
    }
  
    //Sets the wand 1 and 2 colours when the mouse is pressed
    if(mousePressed)
    {
      if(glob.nowCalibrating == 1)
      {
        if (mouseButton == LEFT)
        {
          wc1 = m.average(mouseX-2,mouseY-2,mouseX+2,mouseY+2);
          println("Wand 1: "+ red(wc1)+"," + green(wc1)+"," + blue(wc1));
        }
        else if(mouseButton == RIGHT)
        {
          wcp1 = m.average(mouseX-2,mouseY-2,mouseX+2,mouseY+2);
          println("Wand 1 Click: "+ red(wcp1)+"," + green(wcp1)+"," + blue(wcp1));
        }
      }
      if(glob.nowCalibrating == 2)
      {
        if(mouseButton == LEFT)
        {
          wc2 = m.average(mouseX-2,mouseY-2,mouseX+2,mouseY+2);
          println("Wand 2: "+ red(wc2)+"," + green(wc2)+"," + blue(wc2));
        }
        else if(mouseButton == RIGHT)
        {
          wcp2 = m.average(mouseX-2,mouseY-2,mouseX+2,mouseY+2);
          println("Wand 2 Click: "+ red(wcp2)+"," + green(wcp2)+"," + blue(wcp2));
        }
      }
    }
    // Hotkeys left in from previous work for debugging and camera settings
    if(keyPressed)
    {
      if(key=='q')
      {
        ui.calibrationSuccess();
      }
      else if(key==' ')
      {
        println(m.version());
        println("ABOUT: SUNMOCK YANG, MATT DEASE, PAUL YOUNG, KYLE THORMPSON, GRAMBO FIRST BLOOD");
        println("PRESS p FOR CAMERA SETTINGS");
      }
      else if(key=='c')
      {
        println("Wand 1: " + hue(wc1)+"," + saturation(wc1)+"," + brightness(wc1) + "\nClicked 1: " +hue(wcp1)+"," + saturation(wcp1)+"," + brightness(wcp1) + "\nWand 2: " + hue(wc2)+"," + saturation(wc2)+"," + brightness(wc2) + "\nClicked 2: " + hue(wcp2)+"," + saturation(wcp2)+"," + brightness(wcp2));
      }
      else if(key=='p')
      {
        m.settings();
      }
    }
    popStyle();
  }
  void quit()
  {
    println("quitting");
    running = false;
    //interrupt();
  }
  
}
