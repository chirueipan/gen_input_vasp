#!/usr/bin/python
import numpy as np
from scipy.optimize import fmin
import matplotlib.pyplot as Plt
#filename=raw_input('/lustre/lwork/crpan/Ni_exercise_fcc/1-energy-vol-medium/SUM')
file1 = open("SUM",'r')
file2 = open("lattice",'r')
y = []
x = [] 
for i in file1.readlines():
    y.append(float(i))

for j in file2.readlines():
    x.append(float(j))

A = np.vander(x, 3)
(coeffs, residuals, rank, sing_vals) = np.linalg.lstsq(A,y)
f = np.poly1d(coeffs)
#print f
p = float(fmin(f,x[len(x)/2]))
p = str(p)
f = open("../optimized_latc",'a')
f.write(p)
f.write('\n')
f.close()


#y_est = f(x)

#Plt.plot(x, y, '.', label = 'original data', markersize=5)
#Plt.plot(t, y_est, 'o-', label = 'estimate', markersize=1)
#Plt.xlabel('lattice constant')
#Plt.ylabel('total energy')
#Plt.title('least squares fit of parabolic')
#plt.savefig('sample.pdf')
