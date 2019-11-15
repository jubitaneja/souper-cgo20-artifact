import os
import re
import sys
import json
import subprocess

if len(sys.argv) < 2:
    print """\
EEROR: Insufficient number of arguments.
Usage:- python time-zip.py <input file>"""
    sys.exit(0)

time_re = re.compile('(?P<secs>[0-9]+.[0-9]+)')

mainfestFile=sys.argv[1]

#print("\nReading the  data now")
f = open(mainfestFile , "r")
txt = f.read()
f.close()

lines = txt.split('\n')

baseCompTime = 0
souperCompTime = 0
baseDecompTime = 0
souperDecompTime = 0

avg_baseCompTime = 0
avg_souperCompTime = 0
avg_baseDecompTime = 0
avg_souperDecompTime = 0

baseComp = False
souperComp = False
baseDecomp = False
souperDecomp = False

for line in lines:
    time = 0 
    mins = 0
    sec = 0
    if line == '':
        continue
    if 'baseline-c' in line:
        baseComp = True
        souperComp = False
        baseDecomp = False
        souperDecomp = False
    if 'baseline-dec' in line:
        baseComp = False
        souperComp = False
        baseDecomp = True
        souperDecomp = False
    if 'precise-c' in line:
        baseComp = False
        souperComp = True
        baseDecomp = False
        souperDecomp = False
    if 'precise-dec' in line:
        baseComp = False
        souperComp = False
        baseDecomp = False
        souperDecomp = True
    if 'real' in line or 'user' in line or 'sys' in line:
		#print line
		#timeReg = time_re.match(line)
		timeReg = re.search('(?P<secs>[0-9]+.[0-9]+)', line)
		if timeReg is not None:
			sec = timeReg.group(0)
		else:
			print "Not a match"
		
		time = float(sec)		
		if baseComp == True:
			baseCompTime = baseCompTime + time
		elif baseDecomp == True:
			baseDecompTime = baseDecompTime + time
		elif souperComp == True:
			souperCompTime = souperCompTime + time
		else:
			souperDecompTime = souperDecompTime + time

avg_baseCompTime = float(baseCompTime / 3)			
avg_baseDecompTime = float(baseDecompTime / 3)			
avg_souperCompTime = float(souperCompTime / 3)			
avg_souperDecompTime = float(souperDecompTime / 3)

print("\nAvg Baseline Compression time = "+ str(avg_baseCompTime))			
print("\nAvg Precise Compression time = "+ str(avg_souperCompTime))			
print "\n"
print("\nAvg Baseline Decompression time = "+ str(avg_baseDecompTime))			
print("\nAvg Precise Decompression time = "+ str(avg_souperDecompTime))			
print "\n"

