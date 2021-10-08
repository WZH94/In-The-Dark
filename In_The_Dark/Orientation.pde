/******************************************************************************/
/*!
\file   Orientation.pde
\author Wong Zhihao
\par    email: wongzhihao.student.utwente.nl
\date
\brief
  This file contains the component that handles the rotation of entities
*/
/******************************************************************************/

final int DIR_NONE = 0;
final int DIR_UP = 1;
final int DIR_DOWN = 2;
final int DIR_LEFT = 3;
final int DIR_RIGHT = 4;

class Orientation
{
  int orientation;

  Orientation()
  {
    orientation = DIR_NONE;
  }
}