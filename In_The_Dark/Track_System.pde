/******************************************************************************/
/*!
\file   Track_System.pde
\author Wong Zhihao
\par    email: wongzhihao.student.utwente.nl
\date
\brief
  This file contains the logic of the enemy tracking the player
*/
/******************************************************************************/

class Track_System
{
  /******************************************************************************/
  /*!
      Looks for enemies with brightness values
  */
  /******************************************************************************/
  void Track(Entity_Manager entity_manager, Level_System level_system, Noise_System noise_system)
  {
    for (int i = 0; i < MAX_ENTITIES; ++i)
    {
      // Check if entity is an enemy
      if (entity_manager.entities[i] == ENEMY)
      {
        // Check if enemy has any brightness value
        if (entity_manager.brightness[i].brightness > 0)
        {
          Find_Direction(entity_manager, level_system, i);
          Move(entity_manager, level_system, noise_system, i);
        }
      }
    }
  }

  /******************************************************************************/
  /*!
      Determines the orientation to move towards the player
  */
  /******************************************************************************/
  void Find_Direction(Entity_Manager entity_manager, Level_System level_system, int i)
  {
    // Find player's ID
    int player = entity_manager.Find_Entity(PLAYER);

    // Find player's coordinates
    int player_x = entity_manager.position[player].x;
    int player_y = entity_manager.position[player].y;

    // Find enemy's coordinates
    int enemy_x = entity_manager.position[i].x;
    int enemy_y = entity_manager.position[i].y;

    // Find direction
    int diff_x = enemy_x - player_x;
    int diff_y = enemy_y - player_y;

    // If diff_x is positive, player is leftwards of enemy
    int x_dir = diff_x > 0 ? DIR_LEFT : DIR_RIGHT;

    // If diff_y is positive, player is upwards of enemy
    int y_dir = diff_y > 0 ? DIR_UP : DIR_DOWN;

    // Determine if x or y axis is nearer
    int unsigned_diff_x = diff_x > 0 ? diff_x : -diff_x;
    int unsigned_diff_y = diff_y > 0 ? diff_y : -diff_y;
    // 0 is x-axis, 1 is y-axis
    int axis = unsigned_diff_x < unsigned_diff_y ? 1 : 0;

    switch (axis)
    {
      // Look in x-axis first
      case 0:
        // Look for opening leftwards in tile map
        if (x_dir == DIR_LEFT)
        {
          if (level_system.tile_map[enemy_y][enemy_x - 1] == 0)
            entity_manager.orientation[i].orientation = DIR_LEFT;

          // If no opening leftwards, find in the y-axis instead
          else
          {
            if (y_dir == DIR_DOWN)
              if (level_system.tile_map[enemy_y + 1][enemy_x] == 0)
               entity_manager.orientation[i].orientation = DIR_DOWN;

            else if (y_dir == DIR_UP)
              if (level_system.tile_map[enemy_y - 1][enemy_x] == 0)
                entity_manager.orientation[i].orientation = DIR_UP;
          }
        }

        else if (x_dir == DIR_RIGHT)
        {
          if (level_system.tile_map[enemy_y][enemy_x + 1] == 0)
            entity_manager.orientation[i].orientation = DIR_RIGHT;

          // If no opening rightwards, find in the y-axis instead
          else
          {
            if (y_dir == DIR_DOWN)
              if (level_system.tile_map[enemy_y + 1][enemy_x] == 0)
               entity_manager.orientation[i].orientation = DIR_DOWN;

            else if (y_dir == DIR_UP)
              if (level_system.tile_map[enemy_y - 1][enemy_x] == 0)
                entity_manager.orientation[i].orientation = DIR_UP;
          }
        }

        break;

      // Look in y-axis first
      case 1:
        // Look for opening upwards in tile map
        if (y_dir == DIR_UP)
        {
          if (level_system.tile_map[enemy_y - 1][enemy_x] == 0)
            entity_manager.orientation[i].orientation = DIR_UP;

          // If no opening upwards, find in the x-axis instead
          else
          {
            if (x_dir == DIR_LEFT)
              if (level_system.tile_map[enemy_y][enemy_x - 1] == 0)
               entity_manager.orientation[i].orientation = DIR_LEFT;

            else if (x_dir == DIR_RIGHT)
             if (level_system.tile_map[enemy_y][enemy_x + 1] == 0)
              entity_manager.orientation[i].orientation = DIR_RIGHT;
          }
        }

        else if (y_dir == DIR_DOWN)
        {
          if (level_system.tile_map[enemy_y + 1][enemy_x] == 0)
            entity_manager.orientation[i].orientation = DIR_DOWN;

          // If no opening upwards, find in the x-axis instead
          else
          {
            if (x_dir == DIR_LEFT)
              if (level_system.tile_map[enemy_y][enemy_x - 1] == 0)
               entity_manager.orientation[i].orientation = DIR_LEFT;

            else if (x_dir == DIR_RIGHT)
             if (level_system.tile_map[enemy_y][enemy_x + 1] == 0)
              entity_manager.orientation[i].orientation = DIR_RIGHT;
          }
        }

        break;
    }
  }

  /******************************************************************************/
  /*!
      Moves the enemy towards the player
  */
  /******************************************************************************/
  void Move(Entity_Manager entity_manager, Level_System level_system, Noise_System noise_system, int i)
  {
    // Advances timer based on brightness value, moves faster the more illuminated it is
    entity_manager.track[i].timer += entity_manager.brightness[i].brightness / 1.8f;

    // When ready to move
    if (entity_manager.track[i].timer >= entity_manager.track[i].speed)
    {
      entity_manager.track[i].timer = 0;

      entity_manager.position[i].old_x = entity_manager.position[i].x;
      entity_manager.position[i].old_y = entity_manager.position[i].y;

      switch(entity_manager.orientation[i].orientation)
      {
        case DIR_UP: --entity_manager.position[i].y;
          break;

        case DIR_DOWN: ++entity_manager.position[i].y;
          break;

        case DIR_LEFT: --entity_manager.position[i].x;
          break;

        case DIR_RIGHT: ++entity_manager.position[i].x;
          break;
      }

      noise_system.Emit_Noise(entity_manager, level_system, entity_manager.position[i].old_x, entity_manager.position[i].old_y, 20, DIR_NONE);
    }
  }
}
