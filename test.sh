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

"""测试高度不足的迷宫"""
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

"""测试玩家移动限制（墙壁和边界）"""
def test_movement_restrictions():
    maze_file = "valid/reg_movement_test.txt"
    
    # 测试撞墙
    stdout, _, _ = run_maze_test(maze_file, ["d", "d", "w"])  # 向右两次然后向上撞墙
    assert "Cannot move into a wall" in stdout
    
    # 测试越界
    stdout, _, _ = run_maze_test(maze_file, ["a", "a", "a"])  # 连续向左移动
    assert "Cannot move outside maze" in stdout

def test_invalid_input_handling():
    """测试非法输入处理"""
    # 测试非WASDQM的按键输入
    invalid_inputs = ["z", "x", "1", "!", "\n", " ", "wa", "dd"]
    for inp in invalid_inputs:
        stdout, _, _ = run_maze_test("valid/reg_5x5.txt", [inp])
        assert "Invalid input" in stdout
        assert "Valid commands are" in stdout  # 应提示有效指令

def test_mixed_valid_invalid_input():
    """测试混合有效和无效输入"""
    inputs = ["d", "x", "a", "1", "s", "!", "w"]
    stdout, _, _ = run_maze_test("valid/reg_5x5.txt", inputs)
    
    # 统计错误消息出现次数
    invalid_count = stdout.count("Invalid input")
    assert invalid_count == 3
    
    # 验证有效移动仍被执行
    assert stdout.count("X") > 1  # 玩家位置应改变
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