#include <stdio.h>
#include <stdlib.h>

#define MAX_SIZE 100

// Struct to represent the maze
typedef struct {
    int width;
    int height;
    char grid[MAX_SIZE][MAX_SIZE];
    int player_x;
    int player_y;
} Maze;

// Function prototypes
Maze load_maze(const char *filename);
void print_map(const Maze *maze);
void move_player(Maze *maze, char direction);
int is_valid_move(const Maze *maze, int new_x, int new_y);

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    Maze maze = load_maze(argv[1]);

    // Game loop
    char input;
    while (1) {
        printf("Enter move (W/A/S/D/M/Q): ");
        scanf(" %c", &input);
        // Handle movement, map display, or quit
    }

    return 0;
}
