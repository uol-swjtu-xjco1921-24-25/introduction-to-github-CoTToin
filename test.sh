import pytest
import subprocess
import os

MAZE_EXECUTABLE = "./maze"
TEST_DATA_DIR = os.path.join(os.path.dirname(__file__), "test_data")

def run_maze_test(filename, inputs=None):
    """运行迷宫程序并捕获输出和退出码"""
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


"""TEST1:加载有效的迷宫文件"""
def test_load_valid_maze():
    stdout, stderr = run_maze_test("valid/reg_5x5.txt")
    assert "Player starts at position" in stdout
    assert stderr == ""

"""TEST2:合法移动（WASD）"""
def test_valid_movement():
    stdout, stderr = run_maze("valid/reg_5x5.txt", ["D"])
    assert "Player moved to" in stdout
    assert stderr == ""

"""TEST3:显示地图（M/m）"""
def test_show_map():
    stdout, stderr = run_maze("valid/reg_5x5.txt", ["M"])
    assert "X marks current position" in stdout
    assert stderr == ""

"""TEST4:到达出口(E)"""
def test_reach_exit():
    stdout, stderr = run_maze("valid/reg_movement_test.txt", ["D","D"])
    assert "Congratulations! You escaped the maze!" in stdout
    assert stderr == ""

"""TEST5:输入退出命令（Q/q）"""
def test_quit_command():
    stdout, stderr = run_maze("valid/reg_5x5.txt", ["Q"])
    assert "Game exited" in stdout or stdout == ""
    assert stderr == ""

"""TEST6:加载不存在的文件"""
def test_load_nonexistent_file():
    stdout, stderr, code = run_maze_test("nonexistent.txt")
    assert "Error: File not found" in stderr
    assert code != 0

"""TEST7:测试缺少起点(S)的迷宫"""
def test_missing_start_point():
    _, stderr, code = run_maze_test("invalid/ireg_missing_S.txt")
    assert "Start point 'S' not found" in stderr
    assert code != 0

"""TEST8:测试缺少终点(E)的迷宫"""
def test_missing_exit_point():
    _, stderr, code = run_maze_test("invalid/ireg_missing_E.txt")
    assert "Exit point 'E' not found" in stderr
    assert code != 0

"""TEST9:测试行长度不一致的迷宫"""
def test_invalid_width():
    _, stderr, code = run_maze_test("invalid/ireg_width_5x5.txt")
    assert "Row 3 has invalid length" in stderr
    assert code != 0

"""TEST10:测试宽长度不一致的迷宫"""
def test_invalid_height():
    _, stderr, code = run_maze_test("invalid/ireg_height_5x5.txt")
    assert "Maze height must be ≥5" in stderr
    assert code != 0

"""TEST10:测试尺寸不足的迷宫(4x4)"""
def test_undersized_maze():
    _, stderr, code = run_maze_test("invalid/ireg_small_4x4.txt")
    assert "Maze dimensions must be between 5 and 100" in stderr
    assert code != 0

"""TEST11:测试尺寸过大的迷宫(101x101)"""
def test_oversized_maze():
    _, stderr, code = run_maze_test("invalid/large_101x101.txt")
    assert "Maze dimensions exceed 100x100" in stderr
    assert code != 0

"""TEST12:迷宫包含非法字符"""
def test_invalid_maze_characters():
    stdout, stderr, code = run_maze_test("invalid/ireg_char.txt")
    assert "Error: Invalid character in maze" in stderr
    assert code != 0

"""TEST13:传入目录路径而非文件"""
def test_load_directory_instead_of_file():
    stdout, stderr, returncode = run_maze_test(TEST_DATA_DIR)
    assert "Error: Not a file" in stderr
    assert returncode != 0

"""TEST14:迷宫含多个起点"""
def test_multiple_start_points():
    stdout, stderr, returncode = run_maze_test("invalid/ireg_multi_S.txt")
    assert "Error: Multiple start points" in stderr
    assert returncode != 0

"""TEST15:迷宫包含多个终点"""
def test_multiple_exit_points():
    stdout, stderr, returncode = run_maze_test("invalid/ireg_multi_E.txt")
    assert "Error: Multiple exit points" in stderr 
    assert returncode != 0                        

"""TEST16:起点被墙壁包围"""
def test_trapped_start():
    stdout, stderr, _ = run_maze_test("invalid/ireg_trapped.txt", ["D", "W", "A", "S"])
    assert "No valid moves" in stdout

"""TEST17:测试玩家移动撞墙"""
def test_move_into_wall():
    stdout, _, _ = run_maze_test("valid/reg_10x6.txt", ["d", "d", "w"]) 
    assert "Cannot move into a wall" in stdout

"""TEST18:测试玩家移动越界"""
def test_move_out_of_bounds():
    stdout, _, _ = run_maze_test("valid/reg_15x8.txt", ["d", "d", "d", "d" , "w"])  
    assert "Cannot move outside maze" in stdout

"""TEST19:输入空行"""
def test_empty_input():
    stdout, stderr, _ = run_maze_test("valid/reg_5x5.txt", [""])
    assert "Invalid input" in stdout

"""TEST20:输入超长字符串"""
def test_long_input_string():
    stdout, stderr, _ = run_maze_test("valid/reg_5x5.txt", ["D"*1000])
    assert "Invalid input" in stdout