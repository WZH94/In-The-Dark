/******************************************************************************/
/*!
\file   In_The_Dark.pde
\author Wong Zhihao
\par    email: wongzhihao.student.utwente.nl
\date
\brief
  This file contains the main loop of the game
*/
/******************************************************************************/

import processing.serial.*;

final int MAX_ENTITIES = 8192;
final int FRAMERATE = 60;

float frame_time = 0;
float frame_time_mult = 1;

PVector scale;

Engine engine;

void setup()
{
  size(2560, 1440, P2D);
  
  scale = new PVector(width / 1920, height / 1080);
  
  frameRate(FRAMERATE);
  
  engine = new Engine();
}

void draw()
{
  // Updates frame time and its multiplier
  if (frame_time == 0)
  {
    frame_time = 1f / FRAMERATE;
    frame_time_mult = 1;
  }
  
  else
  {
    frame_time = 1f / frameRate;
    frame_time_mult = FRAMERATE / frameRate;
  }
  
  if (!engine.Update())
    engine.Draw();
  
  textSize(20);
  text(frame_time, 20, 20);
}