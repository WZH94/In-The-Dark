/******************************************************************************/
/*!
\file   Brightness_System.pde
\author Wong Zhihao
\par    email: wongzhihao.student.utwente.nl
\date
\brief
  This file contains the logic to decrement objects' brightness every frame
*/
/******************************************************************************/

class Brightness_System
{
  void Update_Brightness(Entity_Manager entity_manager)
  {
    for (int i = 0; i < MAX_ENTITIES; ++i)
    {
      if ((entity_manager.entities[i] & COMPONENT_BRIGHTNESS) == COMPONENT_BRIGHTNESS)
      {
        if (entity_manager.brightness[i].brightness > 0)
          entity_manager.brightness[i].brightness -= 1.2f;

        if (entity_manager.brightness[i].brightness < 0)
          entity_manager.brightness[i].brightness = 0;
      }
    }
  }
}