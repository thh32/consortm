#!/usr/bin/env python2.7

import glob
import argparse
from subprocess import call
import subprocess

parser = argparse.ArgumentParser(description="Version 0.01. ConsortM provides simplified analysis of MALDI profiles. For further information go to the github; https://github.com/thh32/ConsortM") #simplifys the wording of using argparse as stated in the python tutorial

# Basic input output files
parser.add_argument("-i", type=str, action='store',  dest='input', help="Input folder containing sub-folders") # allows input of the forward read
parser.add_argument("-p", type=str, action='store',  dest='project_name', help="Name of your project") # allows input of the forward read


args = parser.parse_args()

# Place each of the input into a simple variable to call
input_files = str(args.input)
project_name = str(args.project_name)


print 'Input folder; ', input_files
print 'Project name is; ', project_name


print '1. Listing  files...'

List_possibilities = []
file_list = []

for cfile in glob.glob(input_files + '/*/*'):
    print 'Sample; ', cfile.split('/')[-2:][0]
    file_list.append(cfile.split('/')[-2:][0])
    dt = {}
    for line in open(cfile,'r'):
        timber = line.replace('\r\n','').split(' ')
        List_possibilities.append(timber[0])
Reduced_list = list(set(List_possibilities))

print 'Total samples studied; ', len(file_list)
print 'Total peaks studied; ', len(Reduced_list)


print '1. Files listed OK.'




data = {}

for i in Reduced_list:
    data[i] = []

print '2. Reading in samples m/z values.'


for cfile in glob.glob(input_files + '/*/*'):
    print 'Sample; ', cfile.split('/')[-2:][0]
    dt = {}
    for line in open(cfile,'r'):
        timber = line.replace('\r\n','').split(' ')
        dt[timber[0]] = float(timber[1])
        
    for i in Reduced_list:
        if i in dt.keys():
            if i > 0.0:
                prev = data[i]
                prev.append(dt[i])
                data[i] = prev
            else:
                prev.append(0.0)
                data[i] = prev
        else:
            prev = data[i]
            prev.append(0.0)
            data[i] = prev

print '2. All values stored in memory.'


summed_1 = {}

print '3. Reducing m/z values to integers.'


for k,v in data.iteritems():
    summ = round(float(k))
    if summ in summed_1:
        post = []
        for t,y in zip(v, summed_1[summ]):
            post.append(t+y)
        summed_1[summ] = post
    else:     
        summed_1[summ] = v



print '3. Reduction complete.'



print '4. Outputting data.'



outputting = open(project_name + '_data_summed1.csv','w')
outputting_group = open(project_name + '_groups.csv','w')

outputting_group.write('Name	Condition\n')

outline = 'm/Z'
file_num = {}

numbs = 0
for i in file_list:
    numbs +=1
    outline = outline + ',' + i.split('-')[0] + '-' + str(numbs)
    outputting_group.write(i.split('-')[0] + '-' + str(numbs) + '\t' + i + '\n')

outputting_group.close()


outputting.write(outline + '\n')

for k,v in summed_1.iteritems():
    line = str(k)
    for i in v:
        if i < 0.0:
            line = line + ',' + str(0.0)
        else:
            line = line + ',' + str(i)
    outputting.write(line + '\n')
    
outputting.close()



print '4. Outputting of combined files complete.'



print '5. Running NMDS analysis .'

bashCommand = 'ConsortM-NMDS.R ' +  project_name + '_data_summed1.csv ' + project_name + '_groups.csv ' + project_name
print bashCommand
process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
output, error = process.communicate()


print '5. NMDS visualisation complete.'


print 'Please cite out work at; .........'

print 'For further sub-analysis, edit the combined files and run the command; ConsortM-NMDS.R Data_file Group_file Project_name'




