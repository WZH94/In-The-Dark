/******************************************************************************/
/*!
\file   Position.pde
\author Wong Zhihao
\par    email: wongzhihao.student.utwente.nl
\date
\brief
  This file contains the component that stores the entity's coordinates in the
  tile map
*/
/******************************************************************************/

class Position
{
  int x;
  int y;

  int old_x;
  int old_y;
  
  Position()
  {
    x = 0;
    y = 0;

    old_x = 0;
    old_y = 0;
  }
}
