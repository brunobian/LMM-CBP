import os

labos  = [1,2,3,4,5,7]
compus = [[12,13],[1,4,5,6,7,8,9,11,12,13,16,17,18],[9,10],[2,5],[12,18,22],[2,4,10,15]]


for i,l in enumerate(labos):
	print 'En el labo ' + str(l)
	for j,c in enumerate(compus[i]):
		print 'En la compu ' + str(c)

		ip      = '10.2.' + str(l) + "." + str(c)
		fullLine = "ssh " + str(ip) + " -t killall R" 
                
		os.system(fullLine)
