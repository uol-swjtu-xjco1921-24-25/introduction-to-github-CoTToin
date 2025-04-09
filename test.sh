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

# --------------------------
# 无效迷宫测试
# --------------------------
def test_missing_start_point():
    """测试缺少起点(S)的迷宫"""
    _, stderr, code = run_maze_test("invalid/ireg_missing_S.txt")
    assert "Start point 'S' not found" in stderr
    assert code != 0

def test_missing_exit_point():
    """测试缺少终点(E)的迷宫"""
    _, stderr, code = run_maze_test("invalid/ireg_missing_E.txt")
    assert "Exit point 'E' not found" in stderr
    assert code != 0

def test_invalid_width():
    """测试行长度不一致的迷宫"""
    _, stderr, code = run_maze_test("invalid/ireg_width_5x5.txt")
    assert "Row 3 has invalid length" in stderr
    assert code != 0

def test_invalid_height():
    """测试高度不足的迷宫"""
    _, stderr, code = run_maze_test("invalid/ireg_height_5x5.txt")
    assert "Maze height must be ≥5" in stderr
    assert code != 0

def test_undersized_maze():
    """测试尺寸不足的迷宫(4x4)"""
    _, stderr, code = run_maze_test("invalid/ireg_small_4x4.txt")
    assert "Maze dimensions must be between 5 and 100" in stderr
    assert code != 0

def test_oversized_maze():
    """测试尺寸过大的迷宫(101x101)"""
    _, stderr, code = run_maze_test("invalid/large_101x101.txt")
    assert "Maze dimensions exceed 100x100" in stderr
    assert code != 0

# --------------------------
# 用户输入和逻辑测试
# --------------------------

def test_move_into_wall():
    """测试撞墙逻辑"""
    stdout, _, _ = run_maze_test("valid/reg_5x5.txt", ["w"])
    assert "Cannot move into a wall" in stdout

def test_move_out_of_bounds():
    """测试越界移动"""
    stdout, _, _ = run_maze_test("valid/reg_5x5.txt", ["a", "a", "a"])
    assert "Cannot move outside maze" in stdout

def test_invalid_command_line_args():
    """测试缺少命令行参数"""
    proc = subprocess.Popen(
        [MAZE_EXECUTABLE],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    _, stderr = proc.communicate()
    assert "Usage: ./maze <filename>" in stderr
    assert proc.returncode != 0

def test_invalid_user_input():
    """测试非法输入键"""
    stdout, _, _ = run_maze_test("valid/reg_5x5.txt", ["z"])
    assert "Invalid input" in stdout  至少十种情况 你觉得还有什么可能呢
# --------------------------
# 有效迷宫测试
# --------------------------

def test_valid_maze_5x5():
    """测试有效5x5迷宫的加载和基本移动"""
    stdout, stderr, code = run_maze_test("valid/reg_5x5.txt", ["w", "a", "s", "d", "m", "q"])
    assert code == 0
    assert "X" in stdout  # 地图显示玩家位置

def test_valid_maze_10x6():
    """测试有效10x6迷宫的加载"""
    stdout, _, code = run_maze_test("valid/reg_10x6.txt")
    assert code == 0
    assert "S" in stdout  # 初始位置正确

def test_valid_maze_15x8():
    """测试有效15x8迷宫的加载"""
    stdout, _, code = run_maze_test("valid/reg_15x8.txt")
    assert code == 0
    assert "S" in stdout  # 初始位置正确

def test_win_condition():
    """测试到达出口胜利条件"""
    stdout, _, code = run_maze_test("valid/simple_win.txt", ["d", "d", "d", "d"])
    assert "You won!" in stdout
    assert code == 0