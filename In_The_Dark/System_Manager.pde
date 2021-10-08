/******************************************************************************/
/*!
\file   System_Manager.pde
\author Wong Zhihao
\par    email: wongzhihao.student.utwente.nl
\date
\brief
  This file contains the Manager for every System class
*/
/******************************************************************************/

class System_Manager
{
  private Level_System level_system;
  private Render_System render_system;
  private Noise_System noise_system;
  private Input_Manager input_manager;
  private Brightness_System brightness_system;
  private Move_System move_system;
  private Collision_System collision_system;
  private Arduino_Send_System ass;
  private Track_System track_system;
  
  System_Manager()
  {
    input_manager = new Input_Manager();
    level_system = new Level_System();
    render_system = new Render_System();
    noise_system = new Noise_System();
    brightness_system = new Brightness_System();
    move_system = new Move_System();
    collision_system = new Collision_System();
    ass = new Arduino_Send_System();
    track_system = new Track_System();
  }
  
  boolean Update(Entity_Manager entity_manager)
  {
    level_system.Update(entity_manager);
    input_manager.Update(entity_manager, level_system, noise_system);
    noise_system.Propogate_Noise(entity_manager, level_system);
    brightness_system.Update_Brightness(entity_manager);
    move_system.Move(entity_manager, level_system, noise_system);
    track_system.Track(entity_manager, level_system, noise_system);

    if (collision_system.Check_Collisions(entity_manager, level_system) == true)
      return true;

    ass.Send_Serial(entity_manager, input_manager.port);

    return false;
  }
  
  void Draw(Entity_Manager entity_manager)
  {
    render_system.Render(entity_manager, level_system.grid_size, level_system.width_gap);
  }
}
