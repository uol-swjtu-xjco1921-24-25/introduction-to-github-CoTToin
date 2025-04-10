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


"""加载有效的迷宫文件"""
def test_load_valid_maze():
    stdout, stderr = run_maze_test("reg_5x5.txt")
    assert "Player starts at position" in stdout
    assert stderr == ""

"""合法移动（WASD）"""
def test_valid_movement():
    stdout, stderr = run_maze("reg_5x5.txt", ["D"])
    assert "Player moved to" in stdout
    assert stderr == ""

"""显示地图（M/m）"""
def test_show_map():
    stdout, stderr = run_maze("reg_5x5.txt", ["M"])
    assert "X marks current position" in stdout
    assert stderr == ""

"""到达出口(E)"""
def test_reach_exit():
    stdout, stderr = run_maze("reg_movement_test.txt", ["D","D"])
    assert "Congratulations! You escaped the maze!" in stdout
    assert stderr == ""

"""输入退出命令（Q/q）"""
def test_quit_command():
    stdout, stderr = run_maze("reg_5x5.txt", ["Q"])
    assert "Game exited" in stdout or stdout == ""
    assert stderr == ""

"""加载不存在的文件"""
def test_load_nonexistent_file():
    stdout, stderr, returncode = run_maze_test("nonexistent.txt")
    assert "Error: File not found" in stderr
    assert returncode != 0

"""测试缺少起点(S)的迷宫"""
def test_missing_start_point():
    _, stderr, code = run_maze_test("invalid/ireg_missing_S.txt")
    assert "Start point 'S' not found" in stderr
    assert code != 0

"""测试缺少终点(E)的迷宫"""
def test_missing_exit_point():
    _, stderr, code = run_maze_test("invalid/ireg_missing_E.txt")
    assert "Exit point 'E' not found" in stderr
    assert code != 0

"""测试行长度不一致的迷宫"""
def test_invalid_width():
    _, stderr, code = run_maze_test("invalid/ireg_width_5x5.txt")
    assert "Row 3 has invalid length" in stderr
    assert code != 0

"""测试宽长度不一致的迷宫"""
def test_invalid_height():
    _, stderr, code = run_maze_test("invalid/ireg_height_5x5.txt")
    assert "Maze height must be ≥5" in stderr
    assert code != 0

 """测试尺寸不足的迷宫(4x4)"""
def test_undersized_maze():
    _, stderr, code = run_maze_test("invalid/ireg_small_4x4.txt")
    assert "Maze dimensions must be between 5 and 100" in stderr
    assert code != 0

"""测试尺寸过大的迷宫(101x101)"""
def test_oversized_maze():
    _, stderr, code = run_maze_test("invalid/large_101x101.txt")
    assert "Maze dimensions exceed 100x100" in stderr
    assert code != 0

"""测试玩家移动撞墙"""
def test_move_into_wall():
    stdout, _, _ = run_maze_test("reg_10x6.txt", ["d", "d", "w"]) 
    assert "Cannot move into a wall" in stdout

"""测试玩家移动越界"""
def test_move_out_of_bounds():
    stdout, _, _ = run_maze_test("reg_15x8.txt", ["d", "d", "d", "d" , "w"])  
    assert "Cannot move outside maze" in stdout

def test_invalid_input_handling():
    """测试非法输入处理"""
    # 测试非WASDQM的按键输入
    invalid_inputs = ["z", "x", "1", "!", "\n", " ", "wa", "dd"]
    for inp in invalid_inputs:
        stdout, _, _ = run_maze_test("valid/reg_5x5.txt", [inp])
        assert "Invalid input" in stdout
        assert "Valid commands are" in stdout  # 应提示有效指令

 """测试混合有效和无效输入"""
def test_mixed_valid_invalid_input():
    inputs = ["d", "x", "a", "1", "s", "!", "w"]
    stdout, _, _ = run_maze_test("valid/reg_5x5.txt", inputs)
    
    invalid_count = stdout.count("Invalid input")
    assert invalid_count == 3
    
    assert stdout.count("X") > 1  

 """测试通关后继续输入的情况"""
def test_win_with_extra_steps():
    inputs = ["d", "d", "d", "a", "s", "w"]  
    stdout, _, code = run_maze_test("valid/straight_path.txt", inputs)
    
    assert "You won!" in stdout
    assert code == 0
    assert stdout.count("Invalid") == 0
    assert stdout.count("Cannot move") == 0