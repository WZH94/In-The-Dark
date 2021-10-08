/******************************************************************************/
/*!
\file   Engine.pde
\author Wong Zhihao
\par    email: wongzhihao.student.utwente.nl
\date
\brief
  This file contains the Engine class, and holds the System and Entity Managers.
*/
/******************************************************************************/

class Engine
{
  private Entity_Manager entity_manager;
  private System_Manager system_manager;
  
  Engine()
  {
    entity_manager = new Entity_Manager();
    system_manager = new System_Manager();
  }
  
  boolean Update()
  {
    if (system_manager.Update(entity_manager))
      return true;

    return false;
  }
  
  void Draw()
  {
    system_manager.Draw(entity_manager);
  }
}
