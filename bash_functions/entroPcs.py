import os

labos  = [7]
compus = [[1,2,3,4,5,6,7,8,9,10,12,13,14]]

for i,l in enumerate(labos):
	for j,c in enumerate(compus[i]):
		print 'Intento la compu ' + str(c) + ' del labo' + str(l)

		ip      = '10.2.' + str(l) + "." + str(c)
		fullLine = "ssh " + str(ip) + " -t echo entre" 
                
		os.system(fullLine)
