import pytest
import subprocess
import os

MAZE_EXECUTABLE = "./maze"
TEST_DATA_DIR = os.path.join(os.path.dirname(__file__), "test_data")

def run_maze_test(filename, inputs=None):
    """ Run maze program and capture output and exit code """
    cmd = [MAZE_EXECUTABLE, os.path.join(TEST_DATA_DIR, filename)]
    proc = subprocess.Popen(
        cmd,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    if inputs:
        input_str = "\n".join(inputs) + "\n"
        stdout, stderr = proc.communicate(input_str)
    else:
        stdout, stderr = proc.communicate()
    return stdout, stderr, proc.returncode

""TEST1: Load a valid maze file """
def test_load_valid_maze():
    stdout, stderr = run_maze_test("valid/reg_5x5.txt")
    assert "Player starts at position" in stdout
    assert stderr == ""

"""TEST2: Legal Movement (WASD)"""
def test_valid_movement():
    stdout, stderr = run_maze_test("valid/reg_5x5.txt", ["D"])
    assert "Player moved to" in stdout
    assert stderr == ""

"""TEST3: Display map (M/m)"""
def test_show_map():
    stdout, stderr = run_maze_test("valid/reg_5x5.txt", ["M"])
    assert "X marks current position" in stdout
    assert stderr == ""

"""TEST4: Reaching the Exit (E)"""
def test_reach_exit():
    stdout, stderr = run_maze_test("valid/reg_movement_test.txt", ["D","D"])
    assert "Congratulations! You escaped the maze!" in stdout
    assert stderr == ""

"""TEST5: Enter the exit command (Q/q)"""
def test_quit_command():
    stdout, stderr = run_maze_test("valid/reg_5x5.txt", ["Q"])
    assert "Game exited" in stdout or stdout == ""
    assert stderr == ""

"""TEST6: Load a file that doesn't exist"""
def test_load_nonexistent_file():
    stdout, stderr, code = run_maze_test("nonexistent.txt")
    assert "Error: File not found" in stderr
    assert code != 0

"""TEST7: Test mazes that lack a starting point (S)"""
def test_missing_start_point():
    _, stderr, code = run_maze_test("invalid/ireg_missing_S.txt")
    assert "Start point 'S' not found" in stderr
    assert code != 0

"""TEST8: Test a maze without end point (E)"""
def test_missing_exit_point():
    _, stderr, code = run_maze_test("invalid/ireg_missing_E.txt")
    assert "Exit point 'E' not found" in stderr
    assert code != 0

"""TEST9: Tests mazes with inconsistent lines"""
def test_invalid_width():
    _, stderr, code = run_maze_test("invalid/ireg_width_5x5.txt")
    assert "Row 3 has invalid length" in stderr
    assert code != 0

"""TEST10: Tests mazes of inconsistent width and length"""
def test_invalid_height():
    _, stderr, code = run_maze_test("invalid/ireg_height_5x5.txt")
    assert "Maze height must be ≥5" in stderr
    assert code != 0

"""TEST11: Testing undersized mazes (4x4)"""
def test_undersized_maze():
    _, stderr, code = run_maze_test("invalid/ireg_small_4x4.txt")
    assert "Maze dimensions must be between 5 and 100" in stderr
    assert code != 0

"""TEST12: Testing oversized mazes (101x101)"""
def test_oversized_maze():
    _, stderr, code = run_maze_test("invalid/large_101x101.txt")
    assert "Maze dimensions exceed 100x100" in stderr
    assert code != 0

"""TEST13: The maze contains illegal characters"""
def test_invalid_maze_characters():
    stdout, stderr, code = run_maze_test("invalid/ireg_char.txt")
    assert "Error: Invalid character in maze" in stderr
    assert code != 0

"""TEST14: Pass a directory path instead of a file"""
def test_load_directory_instead_of_file():
    stdout, stderr, returncode = run_maze_test(TEST_DATA_DIR)
    assert "Error: Not a file" in stderr
    assert returncode != 0

"""TEST15: A maze has multiple starting points"""
def test_multiple_start_points():
    stdout, stderr, returncode = run_maze_test("invalid/ireg_multi_S.txt")
    assert "Error: Multiple start points" in stderr
    assert returncode != 0

"""TEST16: A maze consists of multiple ends"""
def test_multiple_exit_points():
    stdout, stderr, returncode = run_maze_test("invalid/ireg_multi_E.txt")
    assert "Error: Multiple exit points" in stderr 
    assert returncode != 0                        

"""TEST17: The starting point is surrounded by walls"""
def test_trapped_start():
    stdout, stderr, _ = run_maze_test("invalid/ireg_trapped.txt", ["D", "W", "A", "S"])
    assert "No valid moves" in stdout

"""TEST18: Test the player moving into a wall"""
def test_move_into_wall():
    stdout, _, _ = run_maze_test("valid/reg_10x6.txt", ["d", "d", "w"]) 
    assert "Cannot move into a wall" in stdout

"""TEST19: Test Player moves out of bounds"""
def test_move_out_of_bounds():
    stdout, _, _ = run_maze_test("valid/reg_15x8.txt", ["d", "d", "d", "d" , "w"])  
    assert "Cannot move outside maze" in stdout

"""TEST20: Enter blank line """
def test_empty_input():
    stdout, stderr, _ = run_maze_test("valid/reg_5x5.txt", [""])
    assert "Invalid input" in stdout

""" TEST21: Enter a long string """
def test_long_input_string():
    stdout, stderr, _ = run_maze_test("valid/reg_5x5.txt", ["D"*1000])
    assert "Invalid input" in stdout

""TEST22: Mixed Case input Test"""
def test_mixed_case_commands():
    stdout, stderr, code = run_maze_test("valid/reg_5x5.txt", ["W", "a", "S", "d", "m", "Q"])
    assert "Player moved up" in stdout
    assert "Player moved left" in stdout
    assert "Player moved down" in stdout
    assert "Player moved right" in stdout
    assert "Map displayed" in stdout
    assert code == 0

"""TEST23: Consecutive invalid input tests ""
def test_multiple_invalid_inputs():
    inputs = ["X", "Z", "123", "", " ", "DD", "W A"]
    stdout, stderr, _ = run_maze_test("valid/reg_5x5.txt", inputs)
    assert stdout.count("Invalid input") == len(inputs)

"""TEST24: Continue typing after victory
def test_commands_after_win():
    inputs = ["D", "D", "S", "W", "A"] 
    stdout, stderr, code = run_maze_test("valid/quick_win.txt", inputs)
    assert "Congratulations" in stdout
    assert "Player moved" not in stdout[-100:] 

"""TEST25: Mix valid/invalid move sequences """
def test_mixed_movement_sequence():
    inputs = ["D", "W", "invalid", "S", "123", "A", "X", "D"]
    stdout, stderr, _ = run_maze_test("valid/reg_10x6.txt", inputs)
    valid_moves = ["right", "down", "left"]
    for move in valid_moves:
        assert f"Player moved {move}" in stdout
    assert stdout.count("Invalid input") == 3
    assert "Cannot move into wall" in stdout

"""TEST26:Test the uppercase command (M) separately"""
def test_uppercase_map_command():
    stdout, stderr = run_maze_test("valid/reg_5x5.txt", ["M"])
    assert "X marks" in stdout

"""TEST27:Test the lower-case command (m) separately"""
def test_lowercase_map_command():
    stdout, stderr = run_maze_test("valid/reg_5x5.txt", ["m"])
    assert "X marks" in stdout