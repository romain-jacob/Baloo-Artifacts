#!/usr/bin/python

# Copyright (c) 2018-2019, Swiss Federal Institute of Technology (ETH Zurich)
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# 
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# 
# * Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


# 2018 by rdaforno
#
# counts the lines of code, excludes comments and blank lines
#
# either pass a list of files or a directory to this script
# to get a list of files within a folder, use e.g.:
#   find [dir] -type f -name "*.[c|h]" -printf "[dir]/%f "

import sys
import re
import os
from glob import glob

debug = False

if len(sys.argv) < 2:
  print( "not enough arguments provided\r\nusage:\t" + sys.argv[0] + " [dir or file1] [file2] ..." )
  sys.exit()

filelist = sys.argv[1:]
if os.path.isdir(sys.argv[1]):
  filelist = [y for x in os.walk(sys.argv[1]) for y in glob(os.path.join(x[0], '*.c'))]
  filelist += [y for x in os.walk(sys.argv[1]) for y in glob(os.path.join(x[0], '*.h'))]
  print( " ".join(filelist))

commentBegin = re.compile(r"\/\*.*")
commentEnd = re.compile(r".*\*\/")
commentOneline = re.compile(r"\/\*.*\*\/|\/\/.*$")

linecnt = 0
filecnt = 0
output  = ""
skip    = False

for filename in filelist:
  if not os.path.isfile(filename):
    print( "file '" + filename + "' skipped" )
    continue
  linecntfile = 0
  content = [line for line in open(filename, 'r')]
  for line in content:
    if skip:
      # look for end of multiline comment
      if re.search(commentEnd, line) is not None:
        line = re.sub(commentEnd, "", line)
        skip = False
      else:
        continue
    else:
      # remove single line comments
      line = re.sub(commentOneline, "", line)
      # look for begin of multiline comments
      if re.search(commentBegin, line) is not None:
        line = re.sub(commentBegin, "", line)
        skip = True
    # remove all whitespaces from the right side
    line = line.rstrip()
    # count as a line of code if there are still characters remaining
    if len(line) > 0:
      linecntfile = linecntfile + 1
      if debug:
        output += line + '\n'

  if debug:
    print( output )
  print( "lines of code in '" + sys.argv[1] + "': " + str(linecntfile) )
  linecnt = linecnt + linecntfile
  filecnt = filecnt + 1

print( "total lines of code in all " + str(filecnt) + " files: " + sys.argv[1] + "': " + str(linecnt) )

