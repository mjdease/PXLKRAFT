class Glob implements Runnable
{
  
  import JMyron.*;
  JMyron m;
  
  boolean running;
  
  //background colour
  int rB,gB,bB;
  // wand 1 variables
  color wc1, wcp1; 
  //int r1,g1,b1; //default colour
  //int r1c,g1c,b1c; // clicked colour
  int x1,y1; // position
  int px1 = -1;
  int py1 = -1; //previous position
  boolean click1 , pclick1; // whether its clicked
  boolean isSet1;
  //PVector v1;  
  // wand 2 variables
  color wc2, wcp2;
  //int r2,g2,b2;
  //int r2c,g2c,b2c;
  int x2,y2;
  int px2 = -1;
  int py2 = -1;
  boolean click2 , pclick2;
  boolean isSet2;
  //PVector v2;
  
  boolean calDone;
  
  // return vector
  PVector vector;
  PVector vector2;
  
  // threshold
  int threshold;
  
  //wand selector counter
  int wand;
  int wandClick;
  
  float wr;
  float hr;
  
  int w;
  int h;
  
  int[] img;
  PImage pImg = createImage(320, 240, RGB);
  
  Glob (int wid , int hei)
  {
    running = false;
    
    w = 320;
    h = 240;
    
    wr = wid / w;
    hr = hei / h;
    
    // minimum glob size
    int minGlob = 10;
    
    threshold = 10;
    
    wand = wandClick = 0;
    
    //size(w,h);
    m = new JMyron();
    m.start(w,h);
    m.findGlobs(1);
    m.minDensity(minGlob);
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
    colorMode(HSB, 255);
    isSet1 = false;
    isSet2 = false;
    //println("running");
    archive();
    m.update();
    m.trackNotColor(rB,gB,bB,255);
    
    int[][] a;
    int[] b;
    int centroidX, centroidY, rr,gg,bb;
    color c;
    
    a = m.globBoxes();
    //println(a.length);
    stroke(255,255,0);
    for(int i=0;i<a.length;i++)
    {
      b = a[i];
      //rect(b[0], b[1], b[2], b[3]);
      centroidX = b[0]+b[2]/2;
      centroidY = b[1]+b[3]/2;
      //point(centroidX,centroidY);
      
      c = m.average(b[0],b[1],b[0] + b[2],b[1] + b[3]);
      
      rr = int(red(c));
      gg = int(green(c));
      bb = int(blue(c));
      
      if(hue(c)>hue(wc1)-threshold && hue(c)<hue(wc1)+threshold)
      {
        x1 = centroidX;
        y1 = centroidY;
        click1 = false;
        isSet1=true;
        //println("wand 1 " + hue(wc1));
      }
      else if(hue(c)>hue(wcp1)-threshold && hue(c)<hue(wcp1)+threshold)
      {
        x1 = centroidX;
        y1 = centroidY;
        click1 = true;
        isSet1=true;
        //println("clicked 1 " + hue(wcp1));
      }
      else if(hue(c)>hue(wc2)-threshold && hue(c)<hue(wc2)+threshold)
      {
        x2 = centroidX;
        y2 = centroidY;
        click2 = false;
        isSet2=true;
        //println("wand 2 " + hue(wc2));
      }
      else if(hue(c)>hue(wcp2)-threshold && hue(c)<hue(wcp2)+threshold)
      {
        x2 = centroidX;
        y2 = centroidY;
        click2 = true;
        isSet2=true;
        //println("clicked 2 " + hue(wcp2));
      }
    }
    popStyle();
    return;
  }
  
  PVector getPos1()
  {
    if(!isSet1)
    {
      vector.set(-100 , -100 , 0);//round(px1 * wr) , round(py1 * hr) , 0);
     
      return vector;
    }
    else
    {
     vector.set(round(x1 * wr) , round(y1 * hr) , 0);
   
      return vector;
    }
  }
  
  PVector getPos2()
  {
    if(!isSet2)
    {
      vector2.set(-100 , -100 , 0);//round(px2 * wr) , round(py2 * hr) , 0
     
      return vector2;
    }
    else
    {
      vector2.set(round(x2 * wr) , round(y2 * hr) , 0);
     
      return vector2;
    }
  }
  
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
    colorMode(HSB, 255);
    m.update();
    img = m.cameraImage();
    pImg.loadPixels();
    for(int i =0;i<w*h;i++)
    {
      pImg.pixels[i] = img[i];
    }
    pImg.updatePixels();
    image(pImg, 0, 0);
    
    //println(int(red(c))+"," + int(green(c)) + "," + int(blue(c)) + ":" + mouseX +";"+mouseY);
    if(mousePressed)
    {
      if (mouseButton == LEFT)
      {
        wc1 = m.average(mouseX-3,mouseY-3,mouseX+3,mouseY+3);
        println("Wand 1: "+ hue(wc1)+"," + saturation(wc1)+"," + brightness(wc1));
      }
      
      else if(mouseButton == RIGHT)
      {
        wcp1 = m.average(mouseX-3,mouseY-3,mouseX+3,mouseY+3);
        println("Wand 1 Click: "+ hue(wcp1)+"," + saturation(wcp1)+"," + brightness(wcp1));
      }
    }
    if(keyPressed)
    {
      if(key == 'z')
      {
        wc2 = m.average(mouseX-3,mouseY-3,mouseX+3,mouseY+3);
        println("Wand 2: "+ hue(wc2)+"," + saturation(wc2)+"," + brightness(wc2));
      }
      else if(key == 'x')
      {
        wcp2 = m.average(mouseX-3,mouseY-3,mouseX+3,mouseY+3);
        println("Wand 2 Click: "+ hue(wcp2)+"," + saturation(wcp2)+"," + brightness(wcp2));
      }
      
      else if(key=='e')
      {
        ui.calibrationSuccess();
      }
      else if(key==' ')
      {
        println(m.version());
        println("ABOUT: SUNMOCK YANG, MATT DEASE, PAUL YOUNG, KYLE THORMPSON, GRAMBO FIRST BLOOD");
        println("PRESS s FOR CAMERA SETTINGS");
      }
      else if(key=='c')
      {
        println("Wand 1: " + hue(wc1)+"," + saturation(wc1)+"," + brightness(wc1) + "\nClicked 1: " +hue(wcp1)+"," + saturation(wcp1)+"," + brightness(wcp1) + "\nWand 2: " + hue(wc2)+"," + saturation(wc2)+"," + brightness(wc2) + "\nClicked 2: " + hue(wcp2)+"," + saturation(wcp2)+"," + brightness(wcp2));
      }
      else if(key=='s')
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
