/**
 * Maze Game Skeleton Code
 * Module: XJCO1921
 * Student: Chengyi Yang
 * 
 * References:
 * - Maze structure design inspired by Lecture 3 slides
 * - Input handling referenced from lab exercise 2
 */

 #include <stdio.h>
 #include <stdlib.h>
 #include <stdbool.h>
 
 // 1. Struct Definitions
 /**
  * 2D position in the maze grid
  * Note: Considered using row/col but chose x/y for consistency
  */
 typedef struct {
     int x;  // Horizontal position (0 = leftmost)
     int y;  // Vertical position (0 = topmost)
 } Position;
 
 /**
  * Maze game state
  * Design decision: Separated player position from static elements
  */
 typedef struct {
     char** grid;      // Dynamically allocated 2D array
     int width;        // Must be 5-100 per specs
     int height;       // Must be 5-100
     Position start;   // Location of 'S'
     Position exit;    // Location of 'E'
     Position player;  // Current player position
 } Maze;
 
 // 2. Function Prototypes (评分标准：Modular breakdown)
 /* File Operations Group */
 Maze* load_maze(const char* filename);  // Reads maze file, validates structure
 void free_maze(Maze* maze);             // Releases all allocated memory
 
 /* Game Logic Group */
 bool is_move_valid(const Maze* maze, Position pos);  // Checks walls/bounds
 void process_move(Maze* maze, char direction);       // Updates player position
 bool check_victory(const Maze* maze);                // Tests exit condition
 
 /* UI Group */
 void display_maze(const Maze* maze);     // Shows map with 'X' marker
 char get_user_input(void);               // Validates WASD/M/Q inputs
 void show_message(const char* text);     // Unified message output
 
 // 3. Main Function Outline (评分标准：Basic structuring)
 int main(int argc, char* argv[]) {
     // Phase 1: Initialization
     if (argc != 2) {
         fprintf(stderr, "Usage: %s <maze_file>\n", argv[0]);
         return EXIT_FAILURE;
     }
 
     Maze* maze = load_maze(argv[1]);
     if (!maze) {
         fprintf(stderr, "Failed to initialize maze\n");
         return EXIT_FAILURE;
     }
 
     // Phase 2: Game loop
     bool is_running = true;
     while (is_running) {
         char input = get_user_input();
         
         switch (input) {
             case 'M':  // Map display
                 display_maze(maze);
                 break;
                 
             case 'Q':  // Quit
                 is_running = false;
                 break;
                 
             default:   // Movement
                 process_move(maze, input);
                 if (check_victory(maze)) {
                     show_message("Congratulations! You escaped!");
                     is_running = false;
                 }
         }
     }
 
     // Phase 3: Cleanup
     free_maze(maze);
     return EXIT_SUCCESS;
 }

 // 4. Function Stubs with Planning Comments
 /**
  * Load maze file with validation:
  * - Check file existence/readability
  * - Verify dimensions (5-100)
  * - Confirm exactly one 'S' and one 'E'
  * - Ensure rectangular structure
  * Returns NULL on any failure
  */
 Maze* load_maze(const char* filename) {
     // TODO: Implement file reading
     // TODO: Add all required validation checks
     return NULL;
 }
 
 /**
  * Checks if position is movable:
  * - Within maze boundaries
  * - Not a wall ('#')
  * - (Future: Could add traps later)
  */
 bool is_move_valid(const Maze* maze, Position pos) {
     // TODO: Implement boundary checks
     // TODO: Add wall collision detection
     return false;
 }