class Music
{
  AudioPlayer[] groove = new AudioPlayer[3];
  AudioSample[] groove2 = new AudioSample[24];
  //WaveformRenderer waveform;
  LowPassFS bpf;
  int wfwidth;
  int rhythm;
  float distance;
  PVector pv1, pv2;
  PVector dist1, dist2;
  PVector dir1, dir2;

  Music()
  {
    wfwidth = 1024;
    pv1 = new PVector(0,0,0);
    pv2 = new PVector(0,0,0);
    dist1 = new PVector(0,0);
    dist2 = new PVector(0,0);
    dir1 = new PVector(0,0);
    dir2 = new PVector(0,0);
    rhythm = 0;

    groove[0] = minim.loadFile("data/sound/Rhythm_Track_1.mp3", 512);
    groove[1] = minim.loadFile("data/sound/Rhythm_Track_2.mp3", 512);
    groove[2] = minim.loadFile("data/sound/Rhythm_Track_3.mp3", 512);
    groove[rhythm].setGain(12);
    groove2[0] = minim.loadSample("data/sound/melody 1/1.mp3", 512);
    groove2[1] = minim.loadSample("data/sound/melody 1/2.mp3", 512);
    groove2[2] = minim.loadSample("data/sound/melody 1/3.mp3", 512);
    groove2[3] = minim.loadSample("data/sound/melody 1/4.mp3", 512);
    groove2[4] = minim.loadSample("data/sound/melody 1/5.mp3", 512);
    groove2[5] = minim.loadSample("data/sound/melody 1/6.mp3", 512);
    groove2[6] = minim.loadSample("data/sound/melody 1/7.mp3", 512);
    groove2[7] = minim.loadSample("data/sound/melody 1/8.mp3", 512);
    groove2[8] = minim.loadSample("data/sound/melody 1/9.mp3", 512);
    groove2[9] = minim.loadSample("data/sound/melody 1/10.mp3", 512);
    groove2[10] = minim.loadSample("data/sound/melody 1/11.mp3", 512);
    groove2[11] = minim.loadSample("data/sound/melody 1/12.mp3", 512);
    groove2[12] = minim.loadSample("data/sound/melody 1/13.mp3", 512);
    groove2[13] = minim.loadSample("data/sound/melody 1/14.mp3", 512);
    groove2[14] = minim.loadSample("data/sound/melody 1/15.mp3", 512);
    groove2[15] = minim.loadSample("data/sound/melody 1/16.mp3", 512);
    groove2[16] = minim.loadSample("data/sound/melody 1/17.mp3", 512);
    groove2[17] = minim.loadSample("data/sound/melody 1/18.mp3", 512);
    groove2[18] = minim.loadSample("data/sound/melody 1/19.mp3", 512);
    groove2[19] = minim.loadSample("data/sound/melody 1/20.mp3", 512);
    groove2[20] = minim.loadSample("data/sound/melody 1/21.mp3", 512);
    groove2[21] = minim.loadSample("data/sound/melody 1/22.mp3", 512);
    groove2[22] = minim.loadSample("data/sound/melody 1/23.mp3", 512);
    groove2[23] = minim.loadSample("data/sound/melody 1/24.mp3", 512);

    groove[rhythm].loop();
    //waveform = new WaveformRenderer();
    //groove.addListener(waveform);
    bpf = new LowPassFS(2000, groove[rhythm].sampleRate());

    groove[rhythm].addEffect(bpf);
  }
  void run(PVector wand1)
  {
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

  void movedMouse(PVector wand1, PVector wand2)
  {
    float frequency = map(dist(wand1.x, wand1.y, wand2.x, wand2.y), 0, 1280, 200, 3600);
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
    float widthgrid = map(xpos, 0, width, 0, 6);
    float heightgrid = map (ypos, 0, height, 0, 4);

    //FIRST COLUMN
    if (widthgrid <= 1)
    {
      if (heightgrid <=1)
      {  
        //rect(0,0,171,192);
        groove2[0].trigger();
      }

      if (heightgrid <=2 && heightgrid > 1)
      {
        groove2[3].trigger();
        //rect(0,192,171,192);
      }

      if (heightgrid <=3 && heightgrid > 2)
      {
        groove2[6].trigger();
        //rect(0,384,171,192);
      }

      if (heightgrid <=4 && heightgrid > 3)
      {
        groove2[9].trigger();
        //rect(0,576,171,192);
      }
    }

    //SECOND COLUMN
    if (widthgrid <= 2 && widthgrid > 1)
    {
      if (heightgrid <=1)
      {  
        //rect(171,0,171,192);
        groove2[1].trigger();
      }

      if (heightgrid <=2 && heightgrid > 1)
      {
        groove2[4].trigger();
        //rect(171,192,171,192);
      }

      if (heightgrid <=3 && heightgrid > 2)
      {
        groove2[7].trigger();
        //rect(171,384,171,192);
      }

      if (heightgrid <=4 && heightgrid > 3)
      {
        groove2[10].trigger();
        //rect(171,576,171,192);
      }
    }

    //THIRD COLUMN
    if (widthgrid <= 3 && widthgrid > 2)
    {
      if (heightgrid <=1)
      {  
        //rect(342,0,171,192);
        groove2[2].trigger();
      }

      if (heightgrid <=2 && heightgrid > 1)
      {
        groove2[5].trigger();
        //rect(342,192,171,192);
      }

      if (heightgrid <=3 && heightgrid > 2)
      {
        groove2[8].trigger();
        //rect(342,384,171,192);
      }

      if (heightgrid <=4 && heightgrid > 3)
      {
        groove2[11].trigger();
        //rect(342,576,171,192);
      }
    }

    //FOURTH COLUMN
    if (widthgrid <= 4 && widthgrid > 3)
    {
      if (heightgrid <=1)
      {  
        //rect(513,0,171,192);
        groove2[12].trigger();
      }

      if (heightgrid <=2 && heightgrid > 1)
      {
        groove2[15].trigger();
        //rect(513,192,171,192);
      }

      if (heightgrid <=3 && heightgrid > 2)
      {
        groove2[18].trigger();
        //rect(513,384,171,192);
      }

      if (heightgrid <=4 && heightgrid > 3)
      {
        groove2[21].trigger();
        //rect(513,576,171,192);
      }
    }

    //FIFTH COLUMN
    if (widthgrid <= 5 && widthgrid > 4)
    {
      if (heightgrid <=1)
      {  
        //rect(684,0,171,192);
        groove2[13].trigger();
      }

      if (heightgrid <=2 && heightgrid > 1)
      {
        groove2[16].trigger();
        //rect(684,192,171,192);
      }

      if (heightgrid <=3 && heightgrid > 2)
      {
        groove2[19].trigger();
        //rect(684,384,171,192);
      }

      if (heightgrid <=4 && heightgrid > 3)
      {
        groove2[22].trigger();
        //rect(684,576,171,192);
      }
    }

    //SIXTH COLUMN
    if (widthgrid <= 6 && widthgrid > 5)
    {
      if (heightgrid <=1)
      {  
        //rect(855,0,171,192);
        groove2[14].trigger();
      }

      if (heightgrid <=2 && heightgrid > 1)
      {
        groove2[17].trigger();
        //rect(855,192,171,192);
      }

      if (heightgrid <=3 && heightgrid > 2)
      {
        groove2[20].trigger();
        //rect(855,384,171,192);
      }

      if (heightgrid <=4 && heightgrid > 3)
      {
        groove2[23].trigger();
        //rect(855,576,171,192);
      }
    }
  }




  void playMenuSound()
  {
    playGridNote(1000, 200);
  }

  void setRhythm(int i)
  {
    groove[rhythm].pause();
    rhythm = i;
    groove[rhythm].setGain(12);
    groove[rhythm].loop();
    bpf = new LowPassFS(2000, groove[rhythm].sampleRate());
    groove[rhythm].addEffect(bpf);
  }


  void stop()
  {
    // always close Minim audio classes when you are done with them
    groove[rhythm].close();


    // always stop Minim before exiting.
    minim.stop();

    //super.stop();
  }
}

