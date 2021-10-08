/******************************************************************************/
/*!
\file   Level_System.pde
\author Wong Zhihao
\par    email: wongzhihao.student.utwente.nl
\date
\brief
  This file contains the main loop of the game
*/
/******************************************************************************/

class Level_System
{
  // Whether level has been initialised
  boolean level_initialised;
  // Current level in play
  int current_level;
  // Max levels
  final int MAX_LEVEL = 3;
  
  // Number of grids for the level
  int level_width;
  int level_height;
  
  // Holds the data of every tile/grid in the level
  int tile_map[][];
  
  // The number of pixels each grid is 
  int grid_size = 0;
  // Offsets the game screen to the centre
  int width_gap = 0;
  
  final int MAX_DIMENSION = 50;
  
  /******************************************************************************/
  /*!
      Constructor
  */
  /******************************************************************************/
  Level_System()
  {
    level_initialised = false;
    
    current_level = 1;
    
    level_width = 0;
    level_height = 0;
    
    tile_map = new int[MAX_DIMENSION][MAX_DIMENSION];
    
    Reset_Level_Data();
  }
  
  /******************************************************************************/
  /*!
      Check if the level has been initialised
  */
  /******************************************************************************/
  void Update(Entity_Manager entity_manager)
  {
    if (level_initialised == false)
    {
      switch (current_level)
      {
        case 1: Init_Level(entity_manager, "data/level1.txt");
          break;

        case 2: Init_Level(entity_manager, "data/level2.txt");
          break;

        case 3: Init_Level(entity_manager, "data/level3.txt");
          break;

        // case 4: Init_Level(entity_manager, "data/level4.txt");
        //   break;
          
        default: println("ERROR! INVALID LEVEL SELECTED!");
          exit();
      }
    }
  }
  
  /******************************************************************************/
  /*!
      Initialises a level, loads up the data from a text file and creates every
      entity
  */
  /******************************************************************************/
  private void Init_Level(Entity_Manager entity_manager, String level_name)
  {
    // Load the bytes from the text file
    byte [] level_read = loadBytes(level_name);
    
    // Width -> Height -> Tile Map
    int read_line = 0;
    // Which position in the tilemap to save
    int current_x = 0;
    int current_y = 0;
    
    for (int i = 0 ; i < level_read.length; i++)
    {
      // Every new line means either a new data or the y-axis has moved up
      if (level_read[i] == 13)
      {
        ++read_line;
        ++i;
        
        if (read_line > 1)
          current_y = read_line - 2;
          
        current_x = 0;
          
        continue;
      }
      
      // Reads the data in the txt file, omits spaces
      else if (level_read[i] != ' ')
      {
        switch (read_line)
        {
          case 0: level_width = level_width * 10 + (level_read[i] - '0');
            break;
            
          case 1: level_height = level_height * 10 + (level_read[i] - '0');
            break;
            
          // Save data in the tilemap
          default:
          {
            tile_map[current_y][current_x] = level_read[i] - '0';
            ++current_x;
          }
        }
      }
    }
    
    // Grid size based on height, since height is smaller
    grid_size = height / level_height;
    
    width_gap = (width - (grid_size * level_width)) / 2;
    
    // Reads through the tile map and creates every entity
    for (int y = 0; y < level_height; ++y)
      for(int x = 0; x < level_width; ++x)
        switch(tile_map[y][x])
        {
          case 1: Create_Wall(entity_manager, x, y);
            break;
            
          case 2: Create_End(entity_manager, x, y);
            break;
            
          case 3: Create_Player(entity_manager, x, y);
            break;

          case 4: Create_Enemy(entity_manager, x, y);
            break;
        }
    
    // println("Level Width: "+level_width);
    // println("Level Height: "+level_height);
    
    // for (int y = 0; y < level_height; ++y)
    // {
    //   for (int x = 0; x < level_width; ++x)
    //   {
    //     print(tile_map[y][x]);
    //   }
    //   println(" ");
    // }
    
    // println("Grid Size: "+grid_size);
    // println("Width Gap: "+width_gap);
      
    level_initialised = true;
  }
  
  /******************************************************************************/
  /*!
      Sets every value in the tilemap to a negative number
  */
  /******************************************************************************/
  void Reset_Level_Data()
  {
    for (int y = 0; y < MAX_DIMENSION; ++y)
      for(int x = 0; x < MAX_DIMENSION; ++x)
        tile_map[y][x] = -1;

    level_width = 0;
    level_height = 0;
    width_gap = 0;
    grid_size = 0;

    level_initialised = false;
  }

  /******************************************************************************/
  /*!
      Resets everything but does not change level number
  */
  /******************************************************************************/
  void Restart_Level(Entity_Manager entity_manager)
  {
    Reset_Level_Data();
    entity_manager.Reset_Instance();
  }

  /******************************************************************************/
  /*!
      Resets everything when you reach the end, advances the level
  */
  /******************************************************************************/
  void Clear_Level(Entity_Manager entity_manager)
  {
    Reset_Level_Data();
    entity_manager.Reset_Instance();

    ++current_level;

    // Simply resets the level when you reach the max
    if (current_level > MAX_LEVEL)
      current_level = 1;
  }
}
