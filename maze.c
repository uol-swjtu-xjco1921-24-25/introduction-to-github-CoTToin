/**
 * Maze Game Skeleton Code
 * 
 * Module: XJCO1921 - Programming Project
 * Student: Chengyi Yang
 * 
 * References:
 * - Maze file format adapted from assignment brief
 * - Struct design inspired by lecture notes on modular programming
 */

 #include <stdio.h>
 #include <stdlib.h>
 #include <stdbool.h>
 
 // 1. Struct Definitions 
 
 /**
  * Represents a 2D coordinate in the maze
  * (Used for player position, start/end points)
  */
 typedef struct {
     int x;
     int y;
 } Position;
 
 /**
  * Contains all maze data and metadata
  * (Modular design for easy expansion)
  */
 typedef struct {
     char** grid;        // 2D array storing maze characters
     int width;          // Maze width (5-100)
     int height;         // Maze height (5-100)
     Position start;     // Starting position 'S'
     Position exit;      // Exit position 'E'
     Position player;    // Current player position
 } Maze;
 

 // 2. Function Prototypes 

 /* File Operations */
 Maze* load_maze(const char* filename);          // Load maze from file
 void free_maze(Maze* maze);                     // Release allocated memory
 
 /* Game Logic */
 bool is_valid_move(const Maze* maze, Position pos);  // Check move validity
 void update_player_position(Maze* maze, char move); // Process movement
 void display_maze(const Maze* maze);                // Show map with 'X'
 
 /* Input/Output */
 char get_user_input();                         // Get and validate user input
 void print_game_message(const char* message);  // Unified message output
 
 // 3. Main Function Outline 
 
 int main(int argc, char* argv[]) {
     // 1. Command line validation
     if (argc != 2) {
         fprintf(stderr, "Usage: %s <maze_file>\n", argv[0]);
         return EXIT_FAILURE;
     }
 
     // 2. Initialize maze
     Maze* maze = load_maze(argv[1]);
     if (!maze) {
         fprintf(stderr, "Failed to load maze\n");
         return EXIT_FAILURE;
     }
 
     // 3. Game loop
     bool game_running = true;
     while (game_running) {
         // a. Get input
         char input = get_user_input();
         
         // b. Process input
         switch (input) {
             case 'M':
             case 'm':
                 display_maze(maze);
                 break;
             case 'Q':
             case 'q':
                 game_running = false;
                 break;
             default:
                 update_player_position(maze, input);
                 
                 // c. Check win condition
                 if (maze->player.x == maze->exit.x && 
                     maze->player.y == maze->exit.y) {
                     print_game_message("Congratulations! You escaped!");
                     game_running = false;
                 }
         }
     }
 
     // 4. Cleanup
     free_maze(maze);
     return EXIT_SUCCESS;
 }
 
 // 4. Function Stubs with Detailed Comments
 
 /**
  * Load maze from file with error checking:
  * - Validate file existence and permissions
  * - Check maze dimensions (5-100)
  * - Verify exactly one 'S' and one 'E'
  * - Ensure rectangular structure
  */
 Maze* load_maze(const char* filename) {
     // TODO: Implementation
     return NULL;
 }
 
 /**
  * Validate move based on:
  * - Wall collisions (#)
  * - Maze boundaries
  * - Other constraints
  */
 bool is_valid_move(const Maze* maze, Position pos) {
     // TODO: Implementation
     return false;
 }
 
 /** 
  * Process movement command (WASD):
  * - Check validity via is_valid_move()
  * - Update player position or show error
  */
 void update_player_position(Maze* maze, char move) {
     // TODO: Implementation
 }
