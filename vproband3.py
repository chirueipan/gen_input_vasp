#!/usr/bin/python2.4
# Plot element projected energy bands, including spin-orbit coupling PROCAR.
# E_fermi is from DOSCAR!!
# Input: POSCAR (elements), PROCAR (population projected on ions, set LORBIT=11 in Vasp5), EIGENVAL (eigen values), OUTCAR (real-space Kpoints coordinates), DOSCAR (E_max, E_min, E_Fermi)
# Output: bands_pro_(orbital).dat
# Format:  K(x)   Energy(y)   Scale_element1  Scale_element2  ...
# ...
# --TaoHe (tononano@gmail.com)

import string as st
import numpy as np

posfile=file('POSCAR','r')
pos=posfile.readlines()
ele=st.split(pos[5])                              # read element type
Nelem=map(int,st.split(pos[6]))                    # read element number
Nelem2=[0]
step=0
for i in Nelem:
    step+=i
    Nelem2.append(step)
posfile.close()

profile=file('PROCAR','r')
pro=profile.readlines()
Nions=int(st.split(pro[1])[11])                   # read number of ions, Nions=sum(Nelem[i])
if len(st.split(pro[8+Nions+1]))>1:     # spin-orbit coupling (soc)
    soc=4   # 4 blocks
else:
    soc=1   # 1 block
fmt=len(st.split(pro[7])) #fmt = how many orbitals in PROCAR
if fmt!=5 and fmt!=11:
    print('f orbits? call toho..')
    exit()
profile.close()

eigfile=file('EIGENVAL','r')
eigenval=eigfile.readlines()
Nspin=int(st.split(eigenval[0])[3])
[Ne,Nk,Nbands]=map(int,st.split(eigenval[5])) # Ne:number of electron; Nk:number of kpoints; Nbands:number of bands
eigfile.close()

outfile=file('OUTCAR','r')
outcar=outfile.readlines()
for i in outcar:
    if 'k-points in units of 2pi/SCALE and weight' in i:
        yes=outcar.index(i) #yes is the line index of "k-points in units of 2pi/SCALE and weight"
        kpoints=[]
        k=0.0
        k123=0.0
        kpoint=[]
        for j in range(Nk):
            kpoints.append(np.array(map(float,st.split(outcar[yes+1+j])[:-1])))
            #float,st.split(outcar[yes+1+j]) get the lines after "k-points in units of 2pi/SCALE and weight"
            #which are coordinates of k points in string form
            #map(float,   st.split(outcar[yes+1+j])   [:-1]) maps the string to float and cut the last column
            #np.array(map(float,st.split(outcar[yes+1+j])[:-1])) make the coordinate lists become array          
            k+=np.sqrt(np.dot(kpoints[j]-k123,kpoints[j]-k123))
            kpoint.append(k)
            k123=kpoints[j]
        break
outfile.close()

try:
    dosfile=file('DOSCAR','r')
    doscar=dosfile.readlines()
    dosline=st.split(doscar[5])
    E_max=dosline[0]
    E_min=dosline[1]
    E_F=dosline[3]
    dosfile.close()
except:
    E_max='N.A.'
    E_min='N.A.'
    E_F='N.A.'


if E_F != 'N.A.':
    Ef0=raw_input('Set Fermi-level to 0: (1) Yes (2) No:')
    if Ef0=='1' or Ef0=='Y' or Ef0=='y' or Ef0=='Yes' or Ef0=='yes' or Ef0=='YES':
        Efc=1.0
    else:
        Efc=0.0
else:
    E_F = '5201314'
    Efc = 0.0

while 1:
    if fmt==5:
        spd=raw_input('Input the orbital you want to plot:\n(tot, s, p, d)\n')
        if spd in ['s', 'p', 'd', 'tot']:
            break
        else:
            print('Input Error, try again!')
            continue



#    if fmt==11:
#        spd=raw_input('Input the orbital you want to plot:\n(tot, s, p, d, py, pz, px, dxy, dyz, dz2, dxz, dx2)\n')
#        if spd in ['s', 'p', 'd', 'py','pz','px','dxy','dyz','dz2','dxz','dx2','tot']:
#            break
#        else:
#            print('Input Error, try again!')
#            continue

#    Can we use "p" or "d" for fmt==11
    if fmt==11:
        spd=raw_input('Input the orbital you want to plot:\n(tot, s, py, pz, px, dxy, dyz, dz2, dxz, dx2)\n')
        if spd in ['s','py','pz','px','dxy','dyz','dz2','dxz','dx2','tot']:
            break
        else:
            print('Input Error, try again!')

if Nspin == 1:

    E=[]
    pop=[]
    pop_tot=[]
    for i in range(Nk):
        E.append([])
        pop.append([])
        pop_tot.append([])

        for j in range(Nbands):
            E[i].append(float(st.split(eigenval[8+i*(Nbands+2)+j])[1])-Efc*float(E_F))
            #E[i] collect the eigenvalues of the i-th kpoint        
            pop[i].append([])
            pop_tot[i].append([])
            if fmt==5:
                for k in range(Nions):
                    pop_tot[i][j].append(float(st.split(pro[8+i*(Nbands*(soc*Nions+soc-1+5)+3)+j*(soc*Nions+soc-1+5)+k])[4]))
                    #here pot_tot collect the total(all orbitals) projection of each atom for fmt==5 for i-th k, j-th E 
            if fmt==11:
                for k in range(Nions):
                    pop_tot[i][j].append(float(st.split(pro[8+i*(Nbands*(soc*Nions+soc-1+5)+3)+j*(soc*Nions+soc-1+5)+k])[10]))
                    #here pot_tot collect the total(all orbitals) projection of each atom for fmt==11 for i-th k, j-th E
            if spd == 'tot':
                pop=pop_tot[:] #assign pop_tot[] to pop[]
            else:
                if fmt==5:
                    for k in range(Nions):
                        if spd == 's':
                            s   = float(st.split(pro[8+i*(Nbands*(soc*Nions+soc-1+5)+3)+j*(soc*Nions+soc-1+5)+k])[1])
                            pop[i][j].append(s)
                        if spd == 'p':
                            p   = float(st.split(pro[8+i*(Nbands*(soc*Nions+soc-1+5)+3)+j*(soc*Nions+soc-1+5)+k])[2])
                            pop[i][j].append(p)
                        if spd == 'd':
                            d   = float(st.split(pro[8+i*(Nbands*(soc*Nions+soc-1+5)+3)+j*(soc*Nions+soc-1+5)+k])[3])
                            pop[i][j].append(d)

                if fmt==11:
                    for k in range(Nions):
                        if spd == 's':
                            s   = float(st.split(pro[8+i*(Nbands*(soc*Nions+soc-1+5)+3)+j*(soc*Nions+soc-1+5)+k])[1])
                            pop[i][j].append(s)
                        if spd == 'py':
                            py  = float(st.split(pro[8+i*(Nbands*(soc*Nions+soc-1+5)+3)+j*(soc*Nions+soc-1+5)+k])[2])
                            pop[i][j].append(py)
                        if spd == 'pz':
                            pz  = float(st.split(pro[8+i*(Nbands*(soc*Nions+soc-1+5)+3)+j*(soc*Nions+soc-1+5)+k])[3])
                            pop[i][j].append(pz)
                        if spd == 'px':
                            px  = float(st.split(pro[8+i*(Nbands*(soc*Nions+soc-1+5)+3)+j*(soc*Nions+soc-1+5)+k])[4])
                            pop[i][j].append(px)
                        if spd == 'p':
                            p   = py+pz+px
                            pop[i][j].append(p)
                        if spd == 'dxy':
                            dxy = float(st.split(pro[8+i*(Nbands*(soc*Nions+soc-1+5)+3)+j*(soc*Nions+soc-1+5)+k])[5])
                            pop[i][j].append(dxy)
                        if spd == 'dyz':
                            dyz = float(st.split(pro[8+i*(Nbands*(soc*Nions+soc-1+5)+3)+j*(soc*Nions+soc-1+5)+k])[6])
                            pop[i][j].append(dyz)
                        if spd == 'dz2':
                            dz2 = float(st.split(pro[8+i*(Nbands*(soc*Nions+soc-1+5)+3)+j*(soc*Nions+soc-1+5)+k])[7])
                            pop[i][j].append(dz2)
                        if spd == 'dxz':
                            dxz = float(st.split(pro[8+i*(Nbands*(soc*Nions+soc-1+5)+3)+j*(soc*Nions+soc-1+5)+k])[8])
                            pop[i][j].append(dxz)
                        if spd == 'dx2':
                            dx2 = float(st.split(pro[8+i*(Nbands*(soc*Nions+soc-1+5)+3)+j*(soc*Nions+soc-1+5)+k])[9])
                            pop[i][j].append(dx2)
                        if spd == 'd':
                            pop[i][j].append(dxy+dyz+dz2+dxz+dx2)

    out=file('bands_pro_%s.dat'%spd,'w+')

    if Efc==1.0:
        out.write('# E_F = 0.0\n')
    else:
        out.write('# E_F =    '+E_F+'\n')

    out.write('# k_min, k_max  =   %f  %f\n'%(kpoint[0],kpoint[-1]))

    if Efc==1.0:
        out.write('# E_min, E_max  =   %f   %f\n'%((float(E_min)-float(E_F)),(float(E_max)-float(E_F))))
    else:
        out.write('# E_min, E_max  =   '+E_min+'  '+E_max+'\n')

    out.write('# Nbands, Nspin, Nk =   %d   %d   %d\n'%(Nbands,Nspin,Nk))
    out.write('#        k            E     ')
    for i in range(len(Nelem)):
        out.write('    Ele%d_pct'%(i+1))
    out.write('\n')
    out.write('# --------------------------------------------------------------\n')

    for i in range(Nbands):
        for j in range(len(kpoint)):
            out.write('      %f    %f'%(kpoint[j],E[j][i]))
            totpop=0.0
            for k in range(len(Nelem)):
                totpop+=sum(pop_tot[j][i][Nelem2[k]:Nelem2[k+1]])
                #print i,j,totpop
            for k in range(len(Nelem)):
                out.write('    %f'%(sum(pop[j][i][Nelem2[k]:Nelem2[k+1]])/totpop))
            out.write('\n')
        out.write('\n\n')
    out.close()

# Causion!!!!!    Spin polarized result has not been composed for projected bands !!!!!!
else:
    print('Sorry no projection for spin-polarized PROCAR. Call toho...')
    out_up=file('bands_up.dat','w+')
    if Efc==1.0:
        out_up.write('# E_F = 0.0\n')
    else:
        out_up.write('# E_F =    '+E_F+'\n')
    out_up.write('# k_min, k_max  =   %f  %f\n'%(kpoint[0],kpoint[-1]))
    if Efc==1.0:
        out_up.write('# E_min, E_max  =   %f   %f\n'%((float(E_min)-float(E_F)),(float(E_max)-float(E_F))))
    else:
                out_up.write('# E_min, E_max  =   '+E_min+'  '+E_max+'\n')
    out_up.write('# Nbands, Nspin, Nk =   %d   %d   %d\n'%(Nbands,Nspin,Nk))
    out_up.write('# --------------------------------------------------------------------------\n')

    out_down=file('bands_down.dat','w+')
    if Efc==1.0:
        out_down.write('# E_F = 0.0\n')
    else:
        out_down.write('# E_F =    '+E_F+'\n')
    out_down.write('# k_min, k_max  =   %f  %f\n'%(kpoint[0],kpoint[-1]))
    if Efc==1.0:
        out_down.write('# E_min, E_max  =   %f   %f\n'%((float(E_min)-float(E_F)),(float(E_max)-float(E_F))))
    else:
                out_down.write('# E_min, E_max  =   '+E_min+'  '+E_max+'\n')
    out_down.write('# Nbands, Nspin, Nk =   %d   %d   %d\n'%(Nbands,Nspin,Nk))
    out_down.write('# --------------------------------------------------------------------------\n')
    E_up=[]
    E_down=[]

    if Efc==1.0:
        for i in range(Nk):
            E_up.append([])
            E_down.append([])
            for j in range(Nbands):
                E_up[i].append(float(st.split(eigenval[8+i*(Nbands+2)+j])[1])-float(E_F))
                E_down[i].append(float(st.split(eigenval[8+i*(Nbands+2)+j])[2])-float(E_F))
        for i in range(Nbands):
            for j in range(len(kpoint)):
                out_up.write('      %f    %f\n'%(kpoint[j],E_up[j][i]))
                out_down.write('      %f    %f\n'%(kpoint[j],E_down[j][i]))
            out_up.write('\n\n')
            out_down.write('\n\n')
        out_up.close()
        out_down.close()
    else:
        for i in range(Nk):
            E_up.append([])
            E_down.append([])
            for j in range(Nbands):
                E_up[i].append(float(st.split(eigenval[8+i*(Nbands+2)+j])[1]))
                E_down[i].append(float(st.split(eigenval[8+i*(Nbands+2)+j])[2]))
        for i in range(Nbands):
            for j in range(len(kpoint)):
                out_up.write('      %f    %f\n'%(kpoint[j],E_up[j][i]))
                out_down.write('      %f    %f\n'%(kpoint[j],E_down[j][i]))
            out_up.write('\n\n')
            out_down.write('\n\n')
        out_up.close()
        out_down.close()

