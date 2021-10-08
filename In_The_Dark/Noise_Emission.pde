/******************************************************************************/
/*!
\file   Noise_Emission.pde
\author Wong Zhihao
\par    email: wongzhihao.student.utwente.nl
\date
\brief
  This file contains the component that handles the noise emitted by a noise
  entity
*/
/******************************************************************************/

class Noise_Emission
{
  float noise_value;
  boolean emitted;

  Noise_Emission()
  {
    noise_value = 0;
    emitted = false;
  }
}