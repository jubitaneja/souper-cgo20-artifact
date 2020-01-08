import collections
import os
import sys

souper_dict = {}
llvm_dict = {}
from_llvm = False

def countZeros(bits):
  zeroCount = 0
  for i in range(0, len(bits)):
    if bits[i] == '0':
      zeroCount = zeroCount+1
  return zeroCount

with open(sys.argv[1], "r") as read_handle:
  with open(sys.argv[2], "a") as write_handle:
    for line in read_handle:
      # check if the line is from souper
      if "demanded-bits from Souper" in line:
        #if yes, then store it in map
        #first find the key for map
        lst = line.split(':')

        #if "oops" throw error
        if "oops" in lst[1]:
          write_handle.write(line)
          write_handle.write("Error: Both LLVM and Souper cannot handle this case\n")
          continue

        if "%" not in lst[1]:
          write_handle.write(line)
          write_handle.write("Error: var does not exist\n")
          continue

        key = lst[1].split('%')
        dummy=key[1]
        souper_dict[dummy] = line
        continue

      #check if the line is from llvm
      if "demanded-bits from compiler" in line:
        from_llvm = True
        #first find the key for map
        lst = line.split(':')

        #if "oops" throw error
        if "oops" in lst[1]:
          write_handle.write(line)
          write_handle.write("Error: Both LLVM and Souper cannot handle this case\n")
          continue

        if "%" not in lst[1]:
          write_handle.write(line)
          write_handle.write("Error: var does not exist\n")
          continue

        key = lst[1].split('%')
        dummy2=key[1]
        llvm_dict[dummy2] = line
        continue

      #if we have read both souper and llvm then write to file in ordered manner
      if (from_llvm):
        #if lengths of maps differ then, this is not correct
        if len(souper_dict) != len(llvm_dict):
          # write souper lines first
          for key in souper_dict:
            write_handle.write(souper_dict[key])
      
          #write llvm lines now
          for key in llvm_dict:
             write_handle.write(llvm_dict[key])

          # now write the error to file
          write_handle.write("Error: Souper timeout\n")
          souper_dict.clear()
          llvm_dict.clear()
        else:
          # sort the maps based on key
          od_souper = collections.OrderedDict(sorted(souper_dict.items()))
          od_llvm = collections.OrderedDict(sorted(llvm_dict.items()))
      
          for (k,v), (k2,v2) in zip(od_souper.items(),od_llvm.items()):
            write_handle.write(v)
            write_handle.write(v2)

            #get the souper bits
            ss = v.split(':')
            souper_bits  = ss[2].split(' ')

            #get the llvm bits
            ll = v2.split(':')
            llvm_bits  = ll[2].split(' ')

            if len(souper_bits[1]) != len(llvm_bits[1]):
              write_handle.write("Error: mismatched bitwidth of vars\n")
            else:
              zerosInSouper = countZeros(souper_bits[1])
              zerosInLlvm  = countZeros(llvm_bits[1])
      
              #print zerosInSouper, zerosInLlvm
              if zerosInSouper > zerosInLlvm:
                write_handle.write("Souper is stronger\n")
              elif zerosInSouper < zerosInLlvm:
                write_handle.write("LLVM is stronger\n")
              else:
                 write_handle.write("Same precision\n")

          od_souper.clear()
          od_llvm.clear()
          souper_dict.clear()
          llvm_dict.clear()

        from_llvm = False

      write_handle.write(line)
      line = line.rstrip('\n')
      print line
