class Music
{
  AudioPlayer[] groove = new AudioPlayer[4];
  AudioSample[][] groove2 = new AudioSample[2][24];
  AudioPlayer fireSound;
  AudioPlayer waterSound;
  AudioPlayer oilSound;
  AudioPlayer windSound;
  AudioSample fireworksSound;
  
  //WaveformRenderer waveform;
  LowPassFS bpf;
  int wfwidth;
  int rhythm;
  int melody;
  boolean noMelody = false;
  boolean noRhythm = false;
  float distance;
  PVector pv1, pv2;
  PVector dist1, dist2;
  PVector dir1, dir2;
  int melodyBuffer;
  int lastPlay;
  int fwBuffer;
  int fwLastPlay;

  Music()
  {
    wfwidth = 1024;
    pv1 = new PVector(0,0,0);
    pv2 = new PVector(0,0,0);
    dist1 = new PVector(0,0);
    dist2 = new PVector(0,0);
    dir1 = new PVector(0,0);
    dir2 = new PVector(0,0);
    rhythm = int(random(0,4));
    melody = 0;
    int delayAmt = 50;
    melodyBuffer = 15;
    lastPlay = 0;
    fwLastPlay = 0;
    fwBuffer = 5;
    fireSound = minim.loadFile("data/sound/environment/fire.wav", 4096);
    waterSound = minim.loadFile("data/sound/environment/water.wav", 4096);
    oilSound = minim.loadFile("data/sound/environment/oil.wav", 4096);
    windSound = minim.loadFile("data/sound/environment/wind.wav", 4096);
    fireworksSound = minim.loadSample("data/sound/environment/firework.wav", 2048);

    groove[0] = minim.loadFile("data/sound/Rhythm_Track_1.wav", 4096);
    groove[1] = minim.loadFile("data/sound/Rhythm_Track_2.wav", 4096);
    groove[2] = minim.loadFile("data/sound/Rhythm_Track_3.wav", 4096);
    groove[3] = minim.loadFile("data/sound/Rhythm_Track_4.wav", 4096);
       
    groove2[0][0] = minim.loadSample("data/sound/melody 2/1.mp3", 1024); delay(delayAmt);
    groove2[0][1] = minim.loadSample("data/sound/melody 2/2.mp3", 1024); delay(delayAmt);
    groove2[0][2] = minim.loadSample("data/sound/melody 2/3.mp3", 1024); delay(delayAmt);
    groove2[0][3] = minim.loadSample("data/sound/melody 2/4.mp3", 1024); delay(delayAmt);
    groove2[0][4] = minim.loadSample("data/sound/melody 2/5.mp3", 1024); delay(delayAmt);
    groove2[0][5] = minim.loadSample("data/sound/melody 2/6.mp3", 1024); delay(delayAmt);
    groove2[0][6] = minim.loadSample("data/sound/melody 2/7.mp3", 1024); delay(delayAmt);
    groove2[0][7] = minim.loadSample("data/sound/melody 2/8.mp3", 1024); delay(delayAmt);
    groove2[0][8] = minim.loadSample("data/sound/melody 2/9.mp3", 1024); delay(delayAmt);
    groove2[0][9] = minim.loadSample("data/sound/melody 2/10.mp3", 1024); delay(delayAmt);
    groove2[0][10] = minim.loadSample("data/sound/melody 2/11.mp3", 1024); delay(delayAmt);
    groove2[0][11] = minim.loadSample("data/sound/melody 2/12.mp3", 1024); delay(delayAmt);
    groove2[0][12] = minim.loadSample("data/sound/melody 2/13.mp3", 1024); delay(delayAmt);
    groove2[0][13] = minim.loadSample("data/sound/melody 2/14.mp3", 1024); delay(delayAmt);
    groove2[0][14] = minim.loadSample("data/sound/melody 2/15.mp3", 1024); delay(delayAmt);
    groove2[0][15] = minim.loadSample("data/sound/melody 2/16.mp3", 1024); delay(delayAmt);
    groove2[0][16] = minim.loadSample("data/sound/melody 2/17.mp3", 1024); delay(delayAmt);
    groove2[0][17] = minim.loadSample("data/sound/melody 2/18.mp3", 1024); delay(delayAmt);
    groove2[0][18] = minim.loadSample("data/sound/melody 2/19.mp3", 1024); delay(delayAmt);
    groove2[0][19] = minim.loadSample("data/sound/melody 2/20.mp3", 1024); delay(delayAmt);
    groove2[0][20] = minim.loadSample("data/sound/melody 2/21.mp3", 1024); delay(delayAmt);
    groove2[0][21] = minim.loadSample("data/sound/melody 2/22.mp3", 1024); delay(delayAmt);
    groove2[0][22] = minim.loadSample("data/sound/melody 2/23.mp3", 1024); delay(delayAmt);
    groove2[0][23] = minim.loadSample("data/sound/melody 2/24.mp3", 1024); delay(delayAmt);
    
    groove2[1][0] = minim.loadSample("data/sound/melody 1/1.mp3", 1024); delay(delayAmt);
    groove2[1][1] = minim.loadSample("data/sound/melody 1/2.mp3", 1024); delay(delayAmt);
    groove2[1][2] = minim.loadSample("data/sound/melody 1/3.mp3", 1024); delay(delayAmt);
    groove2[1][3] = minim.loadSample("data/sound/melody 1/4.mp3", 1024); delay(delayAmt);
    groove2[1][4] = minim.loadSample("data/sound/melody 1/5.mp3", 1024); delay(delayAmt);
    groove2[1][5] = minim.loadSample("data/sound/melody 1/6.mp3", 1024); delay(delayAmt);
    groove2[1][6] = minim.loadSample("data/sound/melody 1/7.mp3", 1024); delay(delayAmt);
    groove2[1][7] = minim.loadSample("data/sound/melody 1/8.mp3", 1024); delay(delayAmt);
    groove2[1][8] = minim.loadSample("data/sound/melody 1/9.mp3", 1024); delay(delayAmt);
    groove2[1][9] = minim.loadSample("data/sound/melody 1/10.mp3", 1024); delay(delayAmt);
    groove2[1][10] = minim.loadSample("data/sound/melody 1/11.mp3", 1024); delay(delayAmt);
    groove2[1][11] = minim.loadSample("data/sound/melody 1/12.mp3", 1024); delay(delayAmt);
    groove2[1][12] = minim.loadSample("data/sound/melody 1/13.mp3", 1024); delay(delayAmt);
    groove2[1][13] = minim.loadSample("data/sound/melody 1/14.mp3", 1024); delay(delayAmt);
    groove2[1][14] = minim.loadSample("data/sound/melody 1/15.mp3", 1024); delay(delayAmt);
    groove2[1][15] = minim.loadSample("data/sound/melody 1/16.mp3", 1024); delay(delayAmt);
    groove2[1][16] = minim.loadSample("data/sound/melody 1/17.mp3", 1024); delay(delayAmt);
    groove2[1][17] = minim.loadSample("data/sound/melody 1/18.mp3", 1024); delay(delayAmt);
    groove2[1][18] = minim.loadSample("data/sound/melody 1/19.mp3", 1024); delay(delayAmt);
    groove2[1][19] = minim.loadSample("data/sound/melody 1/20.mp3", 1024); delay(delayAmt);
    groove2[1][20] = minim.loadSample("data/sound/melody 1/21.mp3", 1024); delay(delayAmt);
    groove2[1][21] = minim.loadSample("data/sound/melody 1/22.mp3", 1024); delay(delayAmt);
    groove2[1][22] = minim.loadSample("data/sound/melody 1/23.mp3", 1024); delay(delayAmt);
    groove2[1][23] = minim.loadSample("data/sound/melody 1/24.mp3", 1024); delay(delayAmt);
    
    fireSound.setGain(-47);
    waterSound.setGain(-47);
    oilSound.setGain(-47);
    windSound.setGain(-47);
    fireworksSound.setGain(-5);
    
    groove[rhythm].loop();
    fireSound.loop();
    waterSound.loop();
    oilSound.loop();
    windSound.loop();
    
    //waveform = new WaveformRenderer();
    //groove.addListener(waveform);
    bpf = new LowPassFS(2000, groove[rhythm].sampleRate());

    groove[rhythm].addEffect(bpf);
  }
  void run(PVector wand1)
  {
    groove[rhythm].setGain(6);
    for(int h=0; h<2;h++)
    {
      for (int i=0; i<= 23; i++)
      {
        groove2[h][i].setGain(-6);
      }
    }
    fireSound.setGain(map(fireCount, 0, fire_max-700, -30, -4));
    waterSound.setGain(map(waterCount-freezeCount, 0, water_max-300, -30, -4));
    oilSound.setGain(map(oilCount, 0, oil_max-200, -40, -12));
    windSound.setGain(map(int(engine.fluidSolver.getAvgSpeed()*1000000000), 0, 100000, -30, -7));
    //println(int(engine.fluidSolver.getAvgSpeed()*1000000000));
    if(noMelody)
      return;
    //println(wandP1+"+"+wand1);
    if(frameCount % 2 == 0)
    { 
      //println("1");
      pv1.x = wand1.x;
      pv1.y = wand1.y;
      dist1.x = pv2.x-pv1.x;
      dist1.y = pv2.y-pv1.y;

      if (dist2.x > dist1.x)
      {
        dir1.x = 1;
        //println("right");
      }
      else if (dist2.x < dist1.x)
      {
        dir1.x = -1;
        //println("left");
      }

      if (dir2.x > dir1.x)
      {
        playGridNote(pv2.x, pv2.y);
        //println("switch");
      } 



      if (dist2.y > dist1.y)
      {
        dir1.y = 1;
        //println("right");
      }
      else if (dist2.y < dist1.y)
      {
        dir1.y = -1;
        //println("left");
      }

      if (dir2.y > dir1.y)
      {
        playGridNote(pv2.x, pv2.y);
        //println("switch");
      }
    }



    else if (frameCount % 2 != 0)
    {
      //println("2");
      pv2.x = wand1.x;
      pv2.y = wand1.y;
      dist2.x = pv2.x-pv1.x;
      dist2.y = pv2.y-pv1.y;

      if (dist2.x > dist1.x)
      {
        dir2.x = 1;
        //println("right");
      }
      else if (dist2.x < dist1.x)
      {
        dir2.x = -1;
        //println("left");
      }

      if (dir2.x > dir1.x)
      {
        playGridNote(pv2.x, pv2.y);
        //println("switch");
      } 



      if (dist2.y > dist1.y)
      {
        dir2.y = 1;
        //println("right");
      }
      else if (dist2.y < dist1.y)
      {
        dir2.y = -1;
        //println("left");
      }

      if (dir2.y > dir1.y)
      {
        playGridNote(pv2.x, pv2.y);
        //println("switch");
      }
    }
  }
  void playFwSound()
  {
    //if(frameCount > fwLastPlay + fwBuffer)
    //{
      fwLastPlay = frameCount;
      fireworksSound.trigger();
    //}
  }
  void movedMouse(PVector wand1, PVector wand2)
  {
    //println(dist(wand1.x, wand1.y, wand2.x, wand2.y));
    float frequency = map(dist(wand1.x, wand1.y, wand2.x, wand2.y), 0, 1280, 800, 3600);
    bpf.setFreq(frequency);
    
  }

  void keyPressed()
  {


    if (key == 'A' || key == 'a')
    {
      playMenuSound();
      wfwidth -= 50;
      bpf.setFreq(wfwidth);
    }
    if (key == 'Q' || key == 'q')
    {
      wfwidth += 50;
      bpf.setFreq(wfwidth);
    }
  }

  void playGridNote(float xpos, float ypos)
  {
    if(frameCount < lastPlay + melodyBuffer)
      return;
    else
      lastPlay = frameCount;
    float widthgrid = map(xpos, 0, width, 0, 6);
    float heightgrid = map (ypos, 0, height, 0, 4);

    //FIRST COLUMN
    if (widthgrid <= 1)
    {
      if (heightgrid <=1)
      {  
        //rect(0,0,171,192);
        groove2[melody][0].trigger();
      }

      if (heightgrid <=2 && heightgrid > 1)
      {
        groove2[melody][3].trigger();
        //rect(0,192,171,192);
      }

      if (heightgrid <=3 && heightgrid > 2)
      {
        groove2[melody][6].trigger();
        //rect(0,384,171,192);
      }

      if (heightgrid <=4 && heightgrid > 3)
      {
        groove2[melody][9].trigger();
        //rect(0,576,171,192);
      }
    }

    //SECOND COLUMN
    if (widthgrid <= 2 && widthgrid > 1)
    {
      if (heightgrid <=1)
      {  
        //rect(171,0,171,192);
        groove2[melody][1].trigger();
      }

      if (heightgrid <=2 && heightgrid > 1)
      {
        groove2[melody][4].trigger();
        //rect(171,192,171,192);
      }

      if (heightgrid <=3 && heightgrid > 2)
      {
        groove2[melody][7].trigger();
        //rect(171,384,171,192);
      }

      if (heightgrid <=4 && heightgrid > 3)
      {
        groove2[melody][10].trigger();
        //rect(171,576,171,192);
      }
    }

    //THIRD COLUMN
    if (widthgrid <= 3 && widthgrid > 2)
    {
      if (heightgrid <=1)
      {  
        //rect(342,0,171,192);
        groove2[melody][2].trigger();
      }

      if (heightgrid <=2 && heightgrid > 1)
      {
        groove2[melody][5].trigger();
        //rect(342,192,171,192);
      }

      if (heightgrid <=3 && heightgrid > 2)
      {
        groove2[melody][8].trigger();
        //rect(342,384,171,192);
      }

      if (heightgrid <=4 && heightgrid > 3)
      {
        groove2[melody][11].trigger();
        //rect(342,576,171,192);
      }
    }

    //FOURTH COLUMN
    if (widthgrid <= 4 && widthgrid > 3)
    {
      if (heightgrid <=1)
      {  
        //rect(513,0,171,192);
        groove2[melody][12].trigger();
      }

      if (heightgrid <=2 && heightgrid > 1)
      {
        groove2[melody][15].trigger();
        //rect(513,192,171,192);
      }

      if (heightgrid <=3 && heightgrid > 2)
      {
        groove2[melody][18].trigger();
        //rect(513,384,171,192);
      }

      if (heightgrid <=4 && heightgrid > 3)
      {
        groove2[melody][21].trigger();
        //rect(513,576,171,192);
      }
    }

    //FIFTH COLUMN
    if (widthgrid <= 5 && widthgrid > 4)
    {
      if (heightgrid <=1)
      {  
        //rect(684,0,171,192);
        groove2[melody][13].trigger();
      }

      if (heightgrid <=2 && heightgrid > 1)
      {
        groove2[melody][16].trigger();
        //rect(684,192,171,192);
      }

      if (heightgrid <=3 && heightgrid > 2)
      {
        groove2[melody][19].trigger();
        //rect(684,384,171,192);
      }

      if (heightgrid <=4 && heightgrid > 3)
      {
        groove2[melody][22].trigger();
        //rect(684,576,171,192);
      }
    }

    //SIXTH COLUMN
    if (widthgrid <= 6 && widthgrid > 5)
    {
      if (heightgrid <=1)
      {  
        //rect(855,0,171,192);
        groove2[melody][14].trigger();
      }

      if (heightgrid <=2 && heightgrid > 1)
      {
        groove2[melody][17].trigger();
        //rect(855,192,171,192);
      }

      if (heightgrid <=3 && heightgrid > 2)
      {
        groove2[melody][20].trigger();
        //rect(855,384,171,192);
      }

      if (heightgrid <=4 && heightgrid > 3)
      {
        groove2[melody][23].trigger();
        //rect(855,576,171,192);
      }
    }
  }




  void playMenuSound()
  {
    playGridNote(1000, 200);
  }
  
  void setMelody(int uimelody)
  {
    noMelody = false;
    melody = uimelody; 
  }
  void setRhythm(int uirhythm)
  {
    noRhythm = false;
    groove[rhythm].pause();
    rhythm = uirhythm;
    bpf = new LowPassFS(2000, groove[rhythm].sampleRate());
    groove[rhythm].addEffect(bpf);
    groove[rhythm].loop();
  }
  void noRhythm()
  {
    groove[rhythm].pause();
    noRhythm = true;
  }
  
  void noMelody()
  {
    noMelody = true;
  }
}

