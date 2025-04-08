import os
import subprocess
import random


MAZE_EXECUTABLE = "./maze"
TEST_DATA_DIR = os.path.join(os.path.dirname(__file__), "test_data")


def is_valid_file(file_path):
    """
    检查迷宫文件是否有效
    :param file_path: 迷宫文件路径
    :return: 有效返回True，无效返回False
    """
    if not os.path.exists(file_path):
        return False
    file_extension = os.path.splitext(file_path)[1]
    if file_extension != '.txt':
        return False

    start_count = 0
    end_count = 0
    with open(file_path, 'r') as f:
        lines = f.readlines()
        height = len(lines)
        if height < 5 or height > 100:
            return False
        width = len(lines[0].strip())
        if width < 5 or width > 100:
            return False

        for line in lines:
            start_count += line.count('S')
            end_count += line.count('E')
            for char in line:
                if char not in ['S', 'E', '#', ' ']:
                    return False
    if start_count != 1 or end_count != 1:
        return False
    return True

def run_maze_test(filename, inputs=None):
    """
    运行迷宫程序并捕获其输出和退出状态码
    :param filename: 迷宫测试文件的名称
    :param inputs: 可选参数，传入迷宫程序的输入指令列表
    :return: 一个元组，包含程序的标准输出、标准错误输出和退出状态码
    """
    cmd = [MAZE_EXECUTABLE, os.path.join(TEST_DATA_DIR, filename)]
    try:
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
            stdout, stderr = proc.communicate(
            return_code = proc.returncode
        return stdout, stderr, return_code
    except FileNotFoundError:
        print(f"错误: 未找到迷宫可执行文件 {MAZE_EXECUTABLE}")
        return "", f"错误: 未找到迷宫可执行文件 {MAZE_EXECUTABLE}", 1
    except Exception as e:
        print(f"运行迷宫程序时发生未知错误: {e}")
        return "", f"运行迷宫程序时发生未知错误: {e}", 1
