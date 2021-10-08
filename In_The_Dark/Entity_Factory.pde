/******************************************************************************/
/*!
\file   Entity_Factory.pde
\author Wong Zhihao
\par    email: wongzhihao.student.utwente.nl
\date
\brief
  This file contains the declarations of every entity type, and the functions
  to create those entities in the world
*/
/******************************************************************************/

final int WALL = COMPONENT_POSITION | COMPONENT_SHAPE | COMPONENT_BRIGHTNESS;

final int END = COMPONENT_POSITION | COMPONENT_SHAPE | COMPONENT_END | COMPONENT_BRIGHTNESS;

final int PLAYER = COMPONENT_POSITION | COMPONENT_SHAPE | COMPONENT_SPEED | COMPONENT_BRIGHTNESS | COMPONENT_ORIENTATION;

final int NOISE = COMPONENT_POSITION | COMPONENT_NOISE_MOVE| COMPONENT_ORIENTATION | COMPONENT_NOISE_EMISSION;

final int ENEMY = COMPONENT_POSITION | COMPONENT_ORIENTATION | COMPONENT_SHAPE | COMPONENT_BRIGHTNESS | COMPONENT_TRACK;

void Create_Wall(Entity_Manager entity_manager, int x_, int y_)
{
  // Create Wall
  int entity = entity_manager.Find_Empty();
  
  // Set Wall stats
  entity_manager.entities[entity] = WALL;
  
  entity_manager.shape[entity].shape = '+';
  entity_manager.shape[entity].colour = color(120, 120, 120);

  entity_manager.position[entity].x = x_;
  entity_manager.position[entity].y = y_;
  entity_manager.position[entity].old_x = x_;
  entity_manager.position[entity].old_y = y_;
  
  entity_manager.brightness[entity].brightness = 0;
}

void Create_End(Entity_Manager entity_manager, int x_, int y_)
{
  // Create Player
  int entity = entity_manager.Find_Empty();
  
  // Set Player stats
  entity_manager.entities[entity] = END;
  
  entity_manager.shape[entity].shape = '@';
  entity_manager.shape[entity].colour = color(180, 255, 180);

  entity_manager.position[entity].x = x_;
  entity_manager.position[entity].y = y_;
  entity_manager.position[entity].old_x = x_;
  entity_manager.position[entity].old_y = y_;
  
  entity_manager.brightness[entity].brightness = 0;
}

void Create_Player(Entity_Manager entity_manager, int x_, int y_)
{
  // Create Player
  int entity = entity_manager.Find_Empty();
  
  // Set Player stats
  entity_manager.entities[entity] = PLAYER;
  
  entity_manager.shape[entity].shape = '*';
  entity_manager.shape[entity].colour = color(255);

  entity_manager.position[entity].x = x_;
  entity_manager.position[entity].y = y_;
  entity_manager.position[entity].old_x = x_;
  entity_manager.position[entity].old_y = y_;
  
  entity_manager.speed[entity].speed = 60;
  entity_manager.speed[entity].timer = 60;
  
  entity_manager.brightness[entity].brightness = 0;

  entity_manager.orientation[entity].orientation = DIR_UP;
}

void Create_Noise(Entity_Manager entity_manager, int x_, int y_, float noise_level, int orientation)
{
  // Create Noise
  int entity = entity_manager.Find_Empty();
  
  // Set Noise stats
  entity_manager.entities[entity] = NOISE;

  entity_manager.position[entity].x = x_;
  entity_manager.position[entity].y = y_;
  entity_manager.position[entity].old_x = x_;
  entity_manager.position[entity].old_y = y_;
  
  entity_manager.speed[entity].speed = 10;
  entity_manager.speed[entity].timer = 0;
  
  entity_manager.noise_emission[entity].noise_value = noise_level;
  entity_manager.noise_emission[entity].emitted = false;

  entity_manager.orientation[entity].orientation = orientation;

  // DEBUGGING
  // entity_manager.shape[entity].shape = char(int(random(255)));
  // entity_manager.shape[entity].colour = color(0, 0, 255);
  
  // entity_manager.brightness[entity].brightness = 255;
}

void Create_Enemy(Entity_Manager entity_manager, int x_, int y_)
{
  // Create Noise
  int entity = entity_manager.Find_Empty();
  
  // Set Noise stats
  entity_manager.entities[entity] = ENEMY;

  entity_manager.shape[entity].shape = '!';
  entity_manager.shape[entity].colour = color(255, 180, 180);

  entity_manager.position[entity].x = x_;
  entity_manager.position[entity].y = y_;
  entity_manager.position[entity].old_x = x_;
  entity_manager.position[entity].old_y = y_;
  
  entity_manager.track[entity].speed = 1800;
  entity_manager.track[entity].timer = 0;

  entity_manager.brightness[entity].brightness = 0;

  entity_manager.orientation[entity].orientation = DIR_NONE;
}
