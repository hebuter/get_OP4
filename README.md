# get_OP4
This function is used to get the matrix data in OP4 file output by MSC Nastran  
Input Parameter: filename  
Output Parameter: matrix_data  
ONLY 3E23.16 DIGITAL TYPE CAN BE USED TEMPORARILY  

MSC Nastran DMAP script demo shown bellow  
 ```
ASSIGN OUTPUT4='QHH.op4' UNIT=101 FORMATTED  
ASSIGN OUTPUT4='QKH.op4' UNIT=102 FORMATTED  
SOL 145  
DIAG 8,14  
COMPILE FLUTTER  
ALTER 56  
OUTPUT4 QHH,,,,///101///16 $  
OUTPUT4 QKH,,,,///102///16 $  
 ```

