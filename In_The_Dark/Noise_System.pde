/******************************************************************************/
/*!
\file   Noise_System.pde
\author Wong Zhihao
\par    email: wongzhihao.student.utwente.nl
\date
\brief
  This file contains the logic of the echolocation mechanics of the game
*/
/******************************************************************************/

class Noise_System
{
  /******************************************************************************/
  /*!
      Creates a noise entity that will spread outward from that position if no
      direction is inputted. If there is direction, this is a noise entity that
      carries on from a previous entity, so it will only not spread to the direction
      it came from
  */
  /******************************************************************************/
  void Emit_Noise(Entity_Manager entity_manager, Level_System level_system, int x_, int y_, float noise_level, int orientation)
  {
    // Check above (if above exists)
    if (orientation != DIR_DOWN && y_ > 0 && level_system.tile_map[y_ - 1][x_] != 1)
    {
      // println("ABOVE");
      // Create a noise object in that direction direction
      Create_Noise(entity_manager, x_, y_ - 1, noise_level, DIR_UP);
    }

    // Check below (if below exists)
    if (orientation != DIR_UP && y_ < level_system.level_height - 1 && level_system.tile_map[y_ + 1][x_] != 1)
    {
      // println("BELOW");
      // Create a noise object in that direction direction
      Create_Noise(entity_manager, x_, y_ + 1, noise_level, DIR_DOWN);
    }

    // Check left (if left exists)
    if (orientation != DIR_RIGHT && x_ > 0 && level_system.tile_map[y_][x_ - 1] != 1)
    {
      // println("LEFT");
      // Create a noise object in that direction direction
      Create_Noise(entity_manager, x_ - 1, y_, noise_level, DIR_LEFT);
    }

    // Check right (if right exists)
    if (orientation != DIR_LEFT && x_ < level_system.level_width - 1 && level_system.tile_map[y_][x_ + 1] != 1)
    {
      // println("RIGHT");
      // Create a noise object in that direction direction
      Create_Noise(entity_manager, x_ + 1, y_, noise_level, DIR_RIGHT);
    }

    if (orientation == DIR_NONE)
    {
      // println("HERE");
      // Emit a noise at present location
      Create_Noise(entity_manager, x_, y_, noise_level, DIR_NONE);
    }
  }

  /******************************************************************************/
  /*!
      Handles the spreading of the noise entities
  */
  /******************************************************************************/
  void Propogate_Noise(Entity_Manager entity_manager, Level_System level_system)
  {
    for (int i = 0; i < MAX_ENTITIES; ++i)
    {
      if (entity_manager.entities[i] == NOISE)
      {
        int noise_x = entity_manager.position[i].x;
        int noise_y = entity_manager.position[i].y;
        float noise_level = entity_manager.noise_emission[i].noise_value;
        int orientation = entity_manager.orientation[i].orientation;

        // Check if noise has direction
        if (orientation != DIR_NONE)
        {
          // Check if it has already emitted noise
          if (entity_manager.noise_emission[i].emitted == false)
          {
            // Emit noise
            Emit_Brightness(entity_manager, level_system, noise_x, noise_y, noise_level, orientation);
            entity_manager.noise_emission[i].emitted = true;
          }

          // Advance movement timer
          entity_manager.speed[i].timer += 1 * frame_time_mult;

          // If is ready to move
          if (entity_manager.speed[i].timer >= entity_manager.speed[i].speed)
          {
            // If noise level is still high enough, create further noise entities to spread
            if (noise_level > 0.06f)
              Emit_Noise(entity_manager, level_system, noise_x, noise_y, noise_level / 1.2f, orientation);

            // Remove this noise entity
            entity_manager.Remove_Entity(i);
          }
        }

        // Noise has no direction, affect brightness on all surrounding objects and remove it
        else
        {
          Emit_Brightness(entity_manager, level_system, noise_x, noise_y, noise_level, orientation);

          entity_manager.Remove_Entity(i);
        }
      }
    }
  }

  /******************************************************************************/
  /*!
      Alters the brightness variable of objects the noise entity touches
  */
  /******************************************************************************/
  void Emit_Brightness(Entity_Manager entity_manager, Level_System level_system, int x_, int y_, float noise_level, int orientation)
  {
    // Check above
    if (orientation != DIR_DOWN && y_ > 0 && level_system.tile_map[y_ - 1][x_] != 0)
    {
      // println("ABOVE");

      int entity = entity_manager.Find_Entity(x_, y_ - 1);

      entity_manager.brightness[entity].brightness += noise_level;

      if (entity_manager.brightness[entity].brightness > 255)
        entity_manager.brightness[entity].brightness = 255;
    }

    // Check below
    if (orientation != DIR_UP && y_ < level_system.level_height - 1 && level_system.tile_map[y_ + 1][x_] != 0)
    {
      // println("BELOW");
      int entity = entity_manager.Find_Entity(x_, y_ + 1);

      entity_manager.brightness[entity].brightness += noise_level;

      if (entity_manager.brightness[entity].brightness > 255)
        entity_manager.brightness[entity].brightness = 255;
    }

    // Check left
    if (orientation != RIGHT && x_ > 0 && level_system.tile_map[y_][x_ - 1] != 0)
    {
      // println("LEFT");
      int entity = entity_manager.Find_Entity(x_ - 1, y_);

      entity_manager.brightness[entity].brightness += noise_level;

      if (entity_manager.brightness[entity].brightness > 255)
        entity_manager.brightness[entity].brightness = 255;
    }

    // Check right
    if (orientation != DIR_LEFT && x_ < level_system.level_width - 1 && level_system.tile_map[y_][x_ + 1] != 0)
    {
      // println("RIGHT");
      int entity = entity_manager.Find_Entity(x_ + 1, y_);

      entity_manager.brightness[entity].brightness += noise_level;

      if (entity_manager.brightness[entity].brightness > 255)
        entity_manager.brightness[entity].brightness = 255;
    }

    // Emit noise on present spot
    if (orientation == DIR_NONE)
    {
      int entity = entity_manager.Find_Entity(x_, y_);

      entity_manager.brightness[entity].brightness += noise_level;

      if (entity_manager.brightness[entity].brightness > 255)
        entity_manager.brightness[entity].brightness = 255;
    }
  }
}
