/******************************************************************************/
/*!
\file   Arduino_Send_System.pde
\author Wong Zhihao
\par    email: wongzhihao.student.utwente.nl
\date
\brief
  This file contains the class that sends data to Arduino
*/
/******************************************************************************/

class Arduino_Send_System
{
  void Send_Serial(Entity_Manager entity_manager, Serial serial)
  {
    int player = entity_manager.Find_Entity(PLAYER);

    if (player >= 0)
    {
      int enemy = entity_manager.Find_Entity(ENEMY);

      // Send the orientation, followed by the PWM (brightness of player)
      serial.write(entity_manager.orientation[player].orientation);
      // serial.write(',');
      // serial.write(int(entity_manager.brightness[player].brightness));
      serial.write(char(10));
    }
  }
}
