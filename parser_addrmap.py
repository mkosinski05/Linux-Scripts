# main.py
import sys
import os

class addr_yaml:
	def __init__(self, filename):
		
		self.filename = filename
		self.model_name = ""
		self.app_name = ""
		
		cleanstring = filename.strip()
		cleanstring = cleanstring.replace('./', '')
		arryOfDirs = cleanstring.split('/')
		self.app_name = arryOfDirs[0]
		self.model_name = arryOfDirs[-2]
		
		
		self.attributes = ["data_in,", "data,", "data_out,", "work", "weight", "drp_config", "drp_param", "desc_aimac", "desc_drp"]

		self.total = 0
		self.fileTotal = 0;
		self.subTotal = 0;

		self.foundFileTotal = False;
		
		self.sections = [];
		self.GetPrePostFile();
		self.GetAIInputShape();
	
	def GetPrePostFile (self):
		
		cleanstring = self.filename.strip()
		cleanstring = cleanstring.replace('./', '')
		arryOfDirs = cleanstring.split('/')

		# find exe dirextory
		for i, dir in enumerate(arryOfDirs):
			if "exe" in dir :
				arry = arryOfDirs[0:i]
				break
				
		relPath = '/'.join(arry)
		relPath = "./"+relPath+"/etc"
		
		fullPath = os.path.abspath(relPath)
		yamlprepost = "prepost_"
		for dirpath, dirnames, filenames in os.walk(fullPath):
			for file in filenames:
				if yamlprepost in file:
					self.PrePostYaml = (os.path.join(dirpath, file))
            
	def GetAIInputShape (self):
		
		with open( self.PrePostYaml, 'r') as file:
			lines = file.readlines()
			# make list iterable
			lines = iter(lines)

			# Loop through the lines and find the line that starts with "input_to_body"
			for line in lines:
				if line.startswith('input_to_body'):
					# Get the next line, which should contain the shape information
					shape_line = next(lines)
					while "shape" not in shape_line :
						shape_line = next(lines)
					
	
					key,val = shape_line.split(':')
					start_index = val.index('#')
					val = val[:start_index]
					self.inputShape = val.strip()
					break
		
	def attrParser ( self, attr ) :
		# Remove extra spaces
		cleaned_string = ' '.join(attr.split())

		# Convert hex to decimal
		cleaned_string = cleaned_string.replace('0x', '')
		#cleaned_string = cleaned_string.replace('_', '')
		cleaned_string = cleaned_string.replace('}', '')
		cleaned_string = cleaned_string.replace('{', '')
		cleaned_string = cleaned_string.replace('-', '').strip()
		
		
		# Split the string into key-value pairs
		key_value_pairs = cleaned_string.split(',')
		
		# Create a dictionary from the key-value pairs
		result = {}
		for pair in key_value_pairs:
			key, value = pair.split(':')
			result[key.strip()] = value
			
		result['addr'] = result['addr'].replace('_','')
		result['size'] = int(result['size'].replace('_','').strip(), 16) 
		self.total += result['size']
		
		# Print the resulting dictionary
		self.sections.append(result)

	def fileParser ( self ) :
		with open( self.filename, 'r') as file:
			for line in file:
				if "size" in line and self.foundFileTotal == False :
					key,val = line.strip().split(':')
					self.fileTotal = int(val.strip().replace('0x','').replace('_',''),16)
		
					self.foundFileTotal = True;
					
				for attr in self.attributes:
					if attr in line:
						self.attrParser(line.strip())
		file.close()
		
		
	def FindSubTotal (self):
		attr = ["weight", "drp_config", "drp_parm", "desc_aimac", "desc_drp"]
		for item in self.sections:
			
			for a in attr:
				if a == item['name'].strip():
					self.subTotal += item['size']
					
	def Display(self):
		print("Application\t : "+self.app_name)
		print("Model\t\t : "+self.model_name)
		print("File Stated Total: "+str(self.fileTotal))
		print("Calculated Total: "+str(+self.total))
		print("Inference Total\t : "+str(self.subTotal))
		print("Inference Input Shape : "+str(self.inputShape))
		print('')
		
	def DisplayAll(self):
		self.Display()
		for item in self.sections:
			print(item)	
    
	def CreateCVSFile (self):
		# Create Header
		# For each 
		pass
    
if __name__ == "__main__":
	if len(sys.argv) > 1:
		yaml = addr_yaml(sys.argv[1]);
		yaml.fileParser ( )
		yaml.FindSubTotal()
		yaml.Display()
	else :
		print("Must input Address Map YAML File")

