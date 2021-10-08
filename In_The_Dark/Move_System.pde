/******************************************************************************/
/*!
\file   Move_System.pde
\author Wong Zhihao
\par    email: wongzhihao.student.utwente.nl
\date
\brief
  This file contains the logic to move the player
*/
/******************************************************************************/

class Move_System
{
  final int MOVE_MASK = COMPONENT_POSITION | COMPONENT_SPEED | COMPONENT_ORIENTATION | COMPONENT_MOVE;

  /******************************************************************************/
  /*!
      Moves the player
  */
  /******************************************************************************/
  void Move(Entity_Manager entity_manager, Level_System level_system, Noise_System noise_system)
  {
    for (int i = 0; i < MAX_ENTITIES; ++i)
    {
      if ((entity_manager.entities[i] & MOVE_MASK) == MOVE_MASK)
      {
        if (entity_manager.orientation[i].orientation != DIR_NONE)
        {
          // Time based engine
          entity_manager.speed[i].timer += 1 * frame_time_mult;

          // Check if it is time to move
          if (entity_manager.speed[i].timer >= entity_manager.speed[i].speed)
          {
            // Save the old positions for collision checking later
            entity_manager.position[i].old_x = entity_manager.position[i].x;
            entity_manager.position[i].old_y = entity_manager.position[i].y;

            // Move player based on orientation
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

            // Emits some noise when player moves
            noise_system.Emit_Noise(entity_manager, level_system, entity_manager.position[i].old_x, entity_manager.position[i].old_y, 30, DIR_NONE);

            entity_manager.entities[i] -= COMPONENT_MOVE;
          }
        }
      }
    }
  }
}
