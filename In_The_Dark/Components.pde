/******************************************************************************/
/*!
\file   Components.pde
\author Wong Zhihao
\par    email: wongzhihao.student.utwente.nl
\date
\brief
  This file contains the declarations of every component type
*/
/******************************************************************************/

static final int COMPONENT_NONE = 0;
static final int COMPONENT_SHAPE = 1 << 0;
static final int COMPONENT_POSITION = 1 << 1;
static final int COMPONENT_SPEED = 1 << 2;
static final int COMPONENT_END = 1 << 3;
static final int COMPONENT_BRIGHTNESS = 1 << 4;
static final int COMPONENT_ORIENTATION = 1 << 5;
static final int COMPONENT_NOISE_MOVE = 1 << 6;
static final int COMPONENT_NOISE_EMISSION = 1 << 7;
static final int COMPONENT_MOVE = 1 << 8;
static final int COMPONENT_COLLISION = 1 << 9;
static final int COMPONENT_TRACK = 1 << 10;
//static final int COMPONENT_OOB = 1 << 11;
//static final int COMPONENT_COLLISION = 1 << 12;
//static final int COMPONENT_ENEMY = 1 << 13;
//static final int COMPONENT_TRACK = 1 << 14;
//static final int COMPONENT_DAMAGE = 1 << 15;
//static final int COMPONENT_ROTATE = 1 << 16;
//static final int COMPONENT_PLAYER_HEALTH_COLOUR = 1 << 17;
//static final int COMPONENT_INVULNERABILITY = 1 << 18;
//static final int COMPONENT_EDGE_DIE = 1 << 19;
