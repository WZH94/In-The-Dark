/******************************************************************************/
/*!
\file   Render_System.pde
\author Wong Zhihao
\par    email: wongzhihao.student.utwente.nl
\date
\brief
  This file contains the logic that renders every entity into the game screen.
*/
/******************************************************************************/

class Render_System
{
  void Render(Entity_Manager entity_manager, int grid_size, int width_gap)
  {
    background(0);
    textSize(grid_size);
    
    for (int i = 0; i < MAX_ENTITIES; ++i)
    {
      if ((entity_manager.entities[i] & COMPONENT_SHAPE) == COMPONENT_SHAPE)
      {
        pushMatrix();
        
        float ent_x = width_gap + (entity_manager.position[i].x * grid_size) + (grid_size / 2);
        float ent_y = (entity_manager.position[i].y * grid_size) + (grid_size / 1.5f);
        
        translate(ent_x, ent_y);

        // , entity_manager.brightness[i].brightness
        fill(entity_manager.shape[i].colour, entity_manager.brightness[i].brightness);
        
        text(entity_manager.shape[i].shape, 0, 0);

        popMatrix();
      }
    }
  }
}
