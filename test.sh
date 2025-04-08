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