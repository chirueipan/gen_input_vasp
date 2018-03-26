#!/usr/bin/python2.4
import random
import math
count = 0
nither = 1000000
for i in range(nither):
  x = random.random()
  y = random.random()
  if math.sqrt((x*x)+(y*y))<=1:
    count = count +1
  Pi = 4*float(count)/nither

print count
print("%8f"%Pi)
