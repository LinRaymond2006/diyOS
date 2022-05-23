import os
import sys
print(round(os.path.getsize("./"+sys.argv[1])/512), end='')