/******************************************************************************/
/*!
\file   Entity_Manager.pde
\author Wong Zhihao
\par    email: wongzhihao.student.utwente.nl
\date
\brief
  This file contains the Entity Manager, which holds every entity and their
  components.
*/
/******************************************************************************/

class Entity_Manager
{
  // Holds the mask of every entity and their components
  int entities[];
  
  Shape shape[];
  Position position[];
  End end[];
  Brightness brightness[];
  Speed speed[];
  Orientation orientation[];
  Noise_Move noise_move[];
  Noise_Emission noise_emission[];
  Track track[];
  
  /******************************************************************************/
  /*!
      Constructor, allocate memory for everything
  */
  /******************************************************************************/
  Entity_Manager()
  {
    entities = new int[MAX_ENTITIES];
    
    shape = new Shape[MAX_ENTITIES];
    position = new Position[MAX_ENTITIES];
    end = new End[MAX_ENTITIES];
    brightness = new Brightness[MAX_ENTITIES];
    speed = new Speed[MAX_ENTITIES];
    orientation = new Orientation[MAX_ENTITIES];
    noise_move = new Noise_Move[MAX_ENTITIES];
    noise_emission = new Noise_Emission[MAX_ENTITIES];
    track = new Track[MAX_ENTITIES];
    
    for (int i = 0; i < MAX_ENTITIES; ++i)
    {
      entities[i] = COMPONENT_NONE;
      
      shape[i] = new Shape();
      position[i] = new Position();
      end[i] = new End();
      brightness[i] = new Brightness();
      speed[i] = new Speed();
      orientation[i] = new Orientation();
      noise_move[i] = new Noise_Move();
      noise_emission[i] = new Noise_Emission();
      track[i] = new Track();
    }
  }
  
  /******************************************************************************/
  /*!
      Finds an empty component that can be used
  */
  /******************************************************************************/
  int Find_Empty()
  {
    for (int i = 0; i < MAX_ENTITIES; ++i)
    {
      // Check if the component is empty
      if (entities[i] == COMPONENT_NONE)
      {
        //println("i: "+i);
        return i;
      }
    }
    
    println("NO MORE AVAILABLE ENTITIES!");
    
    return -1;
  }

  /******************************************************************************/
  /*!
      Finds a specific entity based on its x and y coordinates
  */
  /******************************************************************************/
  int Find_Entity(int x, int y)
  {
    for (int i = 0; i < MAX_ENTITIES; ++i)
    {
      // Check if the component is empty
      if ((entities[i] & COMPONENT_POSITION) == COMPONENT_POSITION)
      {
        if (position[i].x == x && position[i].y == y)
          return i;
      }
    }

    return -1;
  }

  /******************************************************************************/
  /*!
      Finds a specific entity based on its mask, can only find one entity
  */
  /******************************************************************************/
  int Find_Entity(int mask)
  {
    for (int i = 0; i < MAX_ENTITIES; ++i)
    {
      // Check if mask matches
      if ((entities[i] & mask) == mask)
      {
        return i;
      }
    }

    return -1;
  }

  /******************************************************************************/
  /*!
      Removes the entity
  */
  /******************************************************************************/
  void Remove_Entity(int id)
  {
    entities[id] = COMPONENT_NONE;
  }

  /******************************************************************************/
  /*!
      Resets every entity to none
  */
  /******************************************************************************/
  void Reset_Instance()
  {
    // Set every entity as empty
    for (int i = 0; i < MAX_ENTITIES; ++i)
    {
      entities[i] = COMPONENT_NONE;
    }
  }
}
