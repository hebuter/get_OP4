# get_OP4
This function is used to get the matrix data in OP4 file  
Input Parameter: filename  
Output Parameter: matrix_data  
OLNY 3E23.16 CAN BE USED TEMPORARILY  

DMAP script demo shown bellow  
 ```
ASSIGN OUTPUT4='QHH.op4' UNIT=101 FORMATTED  
ASSIGN OUTPUT4='QKH.op4' UNIT=102 FORMATTED  
SOL 145  
DIAG 8,14  
compile FLUTTER  
ALTER 56  
OUTPUT4 QHH,,,,///101///16 $  
OUTPUT4 QKH,,,,///102///16 $  
 ```

