/******************************************************************************/
/*!
\file   Input_Manager.pde
\author Wong Zhihao
\par    email: wongzhihao.student.utwente.nl
\date
\brief
  This file contains the Input Manager, which checks the Serial and keyboard
  for input instruction
*/
/******************************************************************************/

enum DATA_ORDER
{
  NOISE(0),
  BUTTON(1),
  LAST(1);
  
  final int value;
  
  private DATA_ORDER(int value_)
  {
    value = value_;
  }
  
  static DATA_ORDER Return(int value)
  {
    switch (value)
    {
      case 0: return NOISE;

      case 1: return BUTTON;
      
      default: return LAST;
    }
  }
  
  static int Return(DATA_ORDER type)
  {
    switch(type)
    {
      case NOISE: return 0;

      case BUTTON: return 1;

      case LAST: return 1;

      default: return -1;
    }
  }
};

class Input_Manager
{
  int read_data = 0;
  int noise_input = 0;
  int button_input = 1;
  int last_button_input = 1;
  boolean button_pressed = false;

  Serial port;

  /******************************************************************************/
  /*!
      Constructor
  */
  /******************************************************************************/
  Input_Manager()
  {
    // Find and create the serial port with Arduino
    println("Available serial ports:");

    for (int i = 0; i < Serial.list ().length; i++) 
    {  
      print("[" + i + "] ");
      println(Serial.list()[i]);
    }

    port = new Serial(In_The_Dark.this, Serial.list()[0], 9600);
  }

  /******************************************************************************/
  /*!
      Checks for input from Arduino and keyboard
  */
  /******************************************************************************/
  void Update(Entity_Manager entity_manager, Level_System level_system, Noise_System noise_system)
  {
    Arduino_Input(entity_manager, level_system, noise_system);
    Key_Input(entity_manager);
  }

  /******************************************************************************/
  /*!
      Checks for input through the Serial port from Arduino
  */
  /******************************************************************************/
  void Arduino_Input(Entity_Manager entity_manager, Level_System level_system, Noise_System noise_system)
  {
    // If there is input from arduino
    while (port.available() > 0)
    {
      // Store arduino input as an int
      int incoming_byte = port.read();
      //print(char(incoming_byte));
      // Commas seperate the different datas
      if (incoming_byte == ',')
        ++read_data;
      
      // Carriage return means it has reached a new line
      else if (incoming_byte == 13 || incoming_byte == 10)
      {
        if (incoming_byte == 13)
          port.read();

        // Check if all data has been read, not more not less and execute logic
        if (read_data == DATA_ORDER.Return(DATA_ORDER.LAST))
        {
          // Prevents the player from moving by holding the button down
          if (last_button_input != button_input)
          {
            last_button_input = button_input;
            button_pressed = true;
          }

          else button_pressed = false;

          int player = entity_manager.Find_Entity(PLAYER);

          // Mitigates the button press noises
          float noise_mult = 1;

          // Move the player
          if (button_pressed && button_input == 0)
          {
            entity_manager.entities[player] += COMPONENT_MOVE;
            noise_mult = 3f;
          }

          // Emits noise from the mic
          if (noise_input > 0 && player > 0)
          {
            noise_system.Emit_Noise(entity_manager, level_system, entity_manager.position[player].x, entity_manager.position[player].y, noise_input / 4f / noise_mult, DIR_NONE);
          }
        }
        
        // Either data was missing or it has read more data than it is supposed to
        // else
        // {
        //   println("WRONG DATA FORMAT", read_data);
        // }
        
        // Reset read_data to start from beginning
        read_data = 0;

        noise_input = 0;
      }

      // Data to be read
      else if (incoming_byte >= '0' && incoming_byte <= '9')
      {
        // Saves data according to read_data value
        switch (DATA_ORDER.Return(read_data))
        {
          // Reads Noise input
          case NOISE: noise_input = noise_input * 10 + (incoming_byte - '0');
            break;

          case BUTTON: button_input = incoming_byte - '0';
            break;
            
          default: println("EXTRA DATA BEING READ");
              
            read_data = 0;
            noise_input = 0;
            button_input = 1;
            last_button_input = 1;
        }
      }
    }    
  }

  /******************************************************************************/
  /*!
      Checks for input from the keyboard, sets the player's rotation
  */
  /******************************************************************************/
  void Key_Input(Entity_Manager entity_manager)
  {
    if (keyPressed == true && key == CODED)
    {
      int player = entity_manager.Find_Entity(PLAYER);

      if (keyCode == UP)
        entity_manager.orientation[player].orientation = DIR_UP;

      else if (keyCode == DOWN)
        entity_manager.orientation[player].orientation = DIR_DOWN;

      else if (keyCode == LEFT)
        entity_manager.orientation[player].orientation = DIR_LEFT;

      else if (keyCode == RIGHT)
        entity_manager.orientation[player].orientation = DIR_RIGHT;
    }
  }
}
