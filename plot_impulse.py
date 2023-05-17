import matplotlib.pyplot as plt
import numpy as np
import sys
#import re

fig, ax = plt.subplots()

argc = len(sys.argv)
if argc < 2:
    print("Usage: python <script.py> <log file> [options]")
    print("Options: -ymax <val> : set the y axis limit")
    sys.exit(1)

#Expect data to be continguous blocks with values on each line and 
#line breaks between

ymax=None
for i in range(2,argc):
    if sys.argv[i] == "-ymax" and i<argc-1:
        ymax=float(sys.argv[i+1])

f = open(sys.argv[1])

data = [ [] ]
data_cur = data[0]

for line in f:
    if len(line) == 0 or line.isspace():
        data.append([])
        data_cur = data[len(data)-1]
    else:
        #print("Parsing line \"%s\" of length %d as float" % (line,len(line)))
        data_cur.append(float(line))

f.close()

#Last dataset may or may not be empty depending on if there was a linebreak at the end
if len(data_cur) == 0:
    data.pop(len(data)-1)

nsets = len(data)

print("Got %d datasets" % nsets)
labels = []
for i in range(nsets):
    labels.append(i)

cm = plt.get_cmap('Paired')
colors=[]
for i in range(len(data)):
    colors.append(cm(i))

ax.hist(data, bins=20, density=True, histtype="stepfilled", stacked=True, label=labels, color=colors)
if ymax != None:
    ax.set_ylim(0,ymax)
fig.legend()
fig.canvas.draw()

outfile=sys.argv[1] + ".pdf"
fig.savefig(outfile, bbox_inches="tight")

#plt.show()

