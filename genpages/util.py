#
# microtome - Tim Conkling, 2012

import re
from collections import namedtuple

LineData = namedtuple("LineData", ["line_num", "col"])

def line_data_at_index (str, idx):
    '''returns the string's line number and line column number at the given index'''
    # count the number of newlines up to idx
    pattern = re.compile(r'\n')
    line_num = 0
    col = idx
    pos = 0
    while True:
        match = pattern.search(str, pos)
        if match is None or match.end() > idx:
            break
        pos = match.end()
        line_num += 1
        col = idx - pos

    return LineData(line_num = line_num, col = col)
