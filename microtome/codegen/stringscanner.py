#
# microtome - Tim Conkling, 2012

import re

import microtome.codegen.util as util

class StringScanner(object):
    def __init__(self, string):
        self._string = string
        self._pos = 0

    def scan(self, pattern, flags=0):
        '''Tries to match 'pattern' at the current position. If there's a match, the scanner
        advances the scan pointer and returns the matched string. Otherwise, the scanner
        returns None.'''
        match = self._get_match(pattern, flags)
        if match is not None:
            self._pos = match.end()
            return match.group(0)
        return None

    def check(self, pattern, flags=0):
        '''Returns the value that 'scan' would return, without advancing the scan pointer'''
        match = self._get_match(pattern, flags)
        if match is not None:
            return match.group(0)
        return None

    def reset(self):
        '''reset the scan pointer to 0'''
        self._pos = 0

    @property
    def string(self):
        return self._string

    @property
    def pos(self):
        return self._pos

    @property
    def rest(self):
        '''returns the rest of the string (everything after the scan pointer)'''
        return self._string[self._pos:]

    @property
    def eos(self):
        '''return True if the scanner is at the end of the string'''
        return self._pos >= len(self._string)

    @property
    def line_number(self):
        '''returns the scanner's current line number (0-indexed)'''
        return util.line_data_at_index(self._string, self._pos).line_num

    @property
    def line(self):
        '''returns the scanner's current line'''
        return self._string.splitlines()[self.line_number]

    def _get_match(self, pattern, flags):
        if isinstance(pattern, basestring):
            pattern = re.compile(pattern, flags)
        return pattern.match(self._string, self._pos)
