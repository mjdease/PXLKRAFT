class Glob implements Runnable
{
  
  import JMyron.*;
  JMyron m;
  
  boolean running;
  
  //background colour
  int rB,gB,bB;
  // wand 1 variables
  int r1,g1,b1; //default colour
  int r1c,g1c,b1c; // clicked colour
  int x1,y1; // position
  int px1 , py1 = -1; //previous position
  boolean click1 , pclick1; // whether its clicked
  //PVector v1;  
  // wand 2 variables
  int r2,g2,b2;
  int r2c,g2c,b2c;
  int x2,y2;
  int px2 , py2 = -1;
  boolean click2 , pclick2;
  //PVector v2;
  
  // return vector
  PVector vector;
  
  // threshold
  int threshold;
  
  //wand selector counter
  int wand;
  int wandClick;
  
  float wr;
  float hr;
  
  Glob (int wid , int hei)
  {
    running = false;
    
    int w = 320;
    int h = 240;
    
    wr = wid / w;
    hr = hei / h;
    
    // minimum glob size
    int minGlob = 10;
    
    threshold = 100;
    
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
     while(running)
     {
        track(); 
        //delay(30);
     }
  }
  
  void track()
  {
    
    archive();
    m.update();
    m.trackNotColor(rB,gB,bB,100);
    
    int[][] a;
    int[] b;
    int centroidX, centroidY, c, rr,gg,bb;
    
    a = m.globBoxes();
    stroke(255,255,0);
    for(int i=0;i<a.length;i++)
    {
      b = a[i];
      rect(b[0], b[1], b[2], b[3]);
      centroidX = b[0]+b[2]/2;
      centroidY = b[1]+b[3]/2;
      point(centroidX,centroidY);
      
      c = m.average(centroidX-3,centroidY-3,centroidX+3,centroidY+3);
      
      rr = int(red(c));
      gg = int(green(c));
      bb = int(blue(c));
      
      //println(centroidX+":"+centroidY+" --> r:"+rr+","+gg+","+bb + " --> "+i);
      
      if(rr>r1c-threshold && rr<r1c+threshold && gg>g1c-threshold && gg<g1c+threshold && bb>b1c-threshold &&bb<b1c+threshold && wand == 1)
      {
        rect(0, 0, 10, 10);
        x1 = centroidX;
        y1 = centroidY;
        click1 = true;
        //println("clicked 1");
      }
      else if(rr>r2c-threshold && rr<r2c+threshold && gg>g2c-threshold && gg<g2c+threshold && bb>b2c-threshold &&bb<b2c+threshold && wand==2)
      {
        rect(0, 0, 10, 10);
        x2 = centroidX;
        y2 = centroidY;
        click2 = true;
        //println("clicked 2");
      }
      else if(rr>r1-threshold && rr<r1+threshold && gg>g1-threshold && gg<g1+threshold && bb>b1-threshold &&bb<b1+threshold && wandClick == 1)
      {
        rect(0, 0, 10, 10);
        x1 = centroidX;
        y1 = centroidY;
        click1 = false;
        //println("wand 1");
      }
      else if(rr>r2-threshold && rr<r2+threshold && gg>g2-threshold && gg<g2+threshold && bb>b2-threshold &&bb<b2+threshold && wandClick ==2)
      {
        rect(0, 0, 10, 10);
        x2 = centroidX;
        y2 = centroidY;
        click2 = false;
        //println("wand 2");
      }
    }
  }
  
  PVector getPos1()
  {
    vector.set(round(x1 * wr) , round(y1 * hr) , 0);
   
    return vector;
  }
  
  PVector getPos2()
  {
    vector.set(round(x2 * wr) , round(y2 * hr) , 0);
   
    return vector;
  }
  
  PVector getPPos1()
  {
    vector.set(round(px1 * wr) , round(py1 * hr) , 0);
   
    return vector;
  }
  
  PVector getPPos2()
  {
    vector.set(round(px2 * wr) , round(py2 * hr) , 0);
   
    return vector;
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
  
   void archive()
  {  
     px1 = x1;
     py1 = y1;
     px2 = x2;
     py2 = y2;
    
     pclick1 = click1;
     pclick2 = click2;
        
   }
  
  void mousePressed()
  {
    int c = m.average(mouseX-3,mouseY-3,mouseX+3,mouseY+3);
    
    if (mouseButton == LEFT)
    {
      if(wand==0)
      {
        r1 = int(red(c));
        g1 = int(green(c));
        b1 = int(blue(c));
        wand =1;
        println(wand +":"+ r1+"," + g1+"," + b1);
      }
      else
      {
        r2 = int(red(c));
        g2 = int(green(c));
        b2 = int(blue(c));
        wand = 2;
        println(wand +":"+ r2+"," + g2 + "," + b2);
      }
    }
    
    if (mouseButton == RIGHT)
    {
      if(wandClick==0)
      {
        r1c = int(red(c));
        g1c = int(green(c));
        b1c = int(blue(c));
        wandClick =1;
        println(wandClick +":"+ r1c+"," + g1c + "," + b1c);
      }
      else
      {
        r2c = int(red(c));
        g2c = int(green(c));
        b2c = int(blue(c));
        wandClick = 2;
        println(wandClick +":"+ r2c+"," + g2c + "," + b2c);
      }
    }
  }
  void quit()
  {
    println("quitting");
    running = false;
    //interrupt();
  }
  
}
