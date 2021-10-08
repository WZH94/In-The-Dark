/******************************************************************************/
/*!
\file   Collision_System.pde
\author Wong Zhihao
\par    email: wongzhihao.student.utwente.nl
\date
\brief
  This file contains the logic that checks for collision for objects that have
  moved this frame, and also determines what happens
*/
/******************************************************************************/

class Collision_System
{
  final int COLLISION_MASK = COMPONENT_POSITION | COMPONENT_ORIENTATION;

  /******************************************************************************/
  /*!
      Looks for objects that have moved and checks if they have collided with
      anything
  */
  /******************************************************************************/
  boolean Check_Collisions(Entity_Manager entity_manager, Level_System level_system)
  {
    for (int i = 0; i < MAX_ENTITIES; ++i)
    {
      // If object has collision mask
      if ((entity_manager.entities[i] & COLLISION_MASK) == COLLISION_MASK)
      {
        // Tile map still holds old locations, objects' positions hold new locations

        int new_x = entity_manager.position[i].x;
        int new_y = entity_manager.position[i].y;
        int old_x = entity_manager.position[i].old_x;
        int old_y = entity_manager.position[i].old_y;

        // Check if object's positions has changed first
        if ((new_x != old_x) || (new_y != old_y))
        {
          // Check against tile map if object has moved over any space that is not an empty space
          if (level_system.tile_map[new_y][new_x] != 0)
          {
            // Find out what it has moved over
            switch (level_system.tile_map[new_y][new_x])
            {
              // Wall, move object back to old position and do not update tile map
              case 1: 
                entity_manager.position[i].x = old_x;
                entity_manager.position[i].y = old_y;

                break;

              // End, check against tile map if object's old position is player object, else move object back to old position and do not update tile map
              case 2: 
                if (level_system.tile_map[old_y][old_x] == 3)
                {
                  // Win level
                  level_system.Clear_Level(entity_manager);

                  return true;
                }

                else
                {
                  entity_manager.position[i].x = old_x;
                  entity_manager.position[i].y = old_y;
                }

                break;

              // Player or enemy, only player or enemies can move into each other, restart game
              case 3:
              case 4:
                level_system.Restart_Level(entity_manager);

                return true;
            }
          }

          // Object has moved over empty space, update tile map
          else
          {
            int moved_object = level_system.tile_map[old_y][old_x];

            level_system.tile_map[old_y][old_x] = 0;
            level_system.tile_map[new_y][new_x] = moved_object;

            entity_manager.position[i].old_x = entity_manager.position[i].x;
            entity_manager.position[i].old_y = entity_manager.position[i].y;
          }
        }
      }
    }

    return false;
  }
}
