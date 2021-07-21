# Ouvrir le fichier en lecture seule
file = open('PMO95.csv', "r")
myFile = open('./ParJour/PMO95J.csv',"w+")
# utilisez readline() pour lire la première ligne
line = file.readline()
a = file.readline()
myFile.write(a)
i = 1;
while i < 459000:
    if i%800 == 0:
    	a = file.readline()
    	myFile.write(a)

    else :
    	line = file.readline()
    
    i = i + 1
file.close()
myFile.close()