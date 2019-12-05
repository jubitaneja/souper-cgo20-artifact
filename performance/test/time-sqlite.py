import os
import re
import sys
import json
import subprocess

if len(sys.argv) < 2:
    print """\
EEROR: Insufficient number of arguments.
Usage:- python time-sqlite.pyresult-sqlite.txt"""
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

avg_baseCompTime = 0
avg_souperCompTime = 0

baseComp = False
souperComp = False

for line in lines:
    time = 0 
    mins = 0
    sec = 0
    if line == '':
        continue
    if 'baseline' in line:
        baseComp = True
        souperComp = False
    if 'precise' in line:
        baseComp = False
        souperComp = True
    #if 'real' in line or 'user' in line or 'sys' in line:
    if 'user' in line or 'sys' in line:
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
		elif souperComp == True:
			souperCompTime = souperCompTime + time

avg_baseCompTime = float(baseCompTime / 3)			
avg_souperCompTime = float(souperCompTime / 3)			

speedup_comp = float(((avg_baseCompTime - avg_souperCompTime)/(avg_baseCompTime))*100)

print("\nAvg Baseline SQLite = "+ str(avg_baseCompTime) + " sec")			
print("\nAvg Precise SQLite = "+ str(avg_souperCompTime) + " sec")			

print "\n"
print("\nSpeedup in SQLite = " + str(speedup_comp) + "%")
print "------------------------------------------------\n"

