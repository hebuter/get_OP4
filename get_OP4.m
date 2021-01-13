function [matrix_Data]=get_OP4(filename)
%% Written by Hao ZHANG
%% This function is used to get the matrix data in OP4 file

%% DMAP script demo shown bellow
% ASSIGN OUTPUT4='QHH.op4' UNIT=101 FORMATTED
% ASSIGN OUTPUT4='QKH.op4' UNIT=102 FORMATTED
% SOL 145  
% DIAG 8,14
% compile FLUTTER
% ALTER 56
% OUTPUT4 QHH,,,,///101///16 $
% OUTPUT4 QKH,,,,///102///16 $

%% INPUT PARAMETER :FILENAME
%% OUTPUT PARAMETER:MATRIX_DATA
%% OLNY 3E23.16 CAN BE USED TEMPORARILY

fileID = fopen(filename);
data = textscan(fileID,'%s');
fclose(fileID);

data_temp=data{1,1};
[m,n]=size(data_temp);
% LENGTH OF EACH DATA
str_length =23;

%% THIS PART IS TO FIND ‘new’
% TEXTSCAN FUNCTION CAN'T SEPARATE CONTINUOUS STRING(NUMBERS). 
% SO,ACTUAL SIZE OF THE DATA IS LONGER THAN THE RESULT OF THE TEXTSCAN
% new + LENGTH OBTAIN BY TEXTSCAN = ACTUAL LENGTH
new = 0;         
for index=1:m
    data_tt = data_temp(index);
    [str_size1,str_size2] = size(data_temp{index});
    if str_size2>str_length
        for index_str=1:str_size2
            if data_tt{1}(index_str)=='E'
                new = new+1;
            end
        end
        new =new-1;
    end
end

%% THIS PART IS TO GET THE ACTUAL DATA(MAXIMUM LENGTH IS 23)
%% MAXIMUM NUMBER OF DATA IN EACH LINE IS 3
data_temp_1 = cell(m+new,n);
dis_X_1=0;
dis_X_2=0;

for index=1:m
    data_tt = data_temp(index);
    [str_size1,str_size2] = size(data_temp{index});
    dis_X=dis_X_1+dis_X_2;
    
    if str_size2<=str_length
        data_temp_1(index + dis_X) = {data_tt};
    end
    
    if  (str_size2>str_length) && (str_size2 <=str_length*2)
        for index_str=1:str_length
            if data_tt{1}(index_str)=='E'
                data_str_1 = data_tt{1}(1:index_str+3);
                data_str_2 = data_tt{1}(index_str+4:end);
                data_temp_1(index + dis_X) = {data_str_1};
                data_temp_1(index + dis_X + 1) = {data_str_2};
                dis_X_1 = dis_X_1 + 1;
            end
        end
    end
    
    if str_size2 > str_length*2
        for index_str=1:str_length
            if data_tt{1}(index_str)=='E'
                data_str_1 = data_tt{1}(1:index_str+3);
                data_str_2 = data_tt{1}(index_str+4:index_str+26);
                data_str_3 = data_tt{1}(index_str+27:end);
                data_temp_1(index + dis_X) = {data_str_1};
                data_temp_1(index + dis_X + 1) = {data_str_2};
                data_temp_1(index + dis_X + 2) = {data_str_3};
                dis_X_2 = dis_X_2 + 2;
            end
        end
    end
end

%% PUT EVERY DATA IN THE RIGHT POSTION OF THE MATRIX
%% MATRIX MAY BE REAL OR COMPLEX

row_Data = str2double(data_temp_1{2}{1});
col_Data = str2double(data_temp_1{1}{1});
blk_Data = str2double(data_temp_1{8}{1});
flag_Data = data_temp_1{4}{1};
matrix_Data = zeros(row_Data,col_Data);

order_total=(m+new-9)/(blk_Data+3);

for col_index=1:order_total
    start_col_pos = (col_index-1)*(blk_Data+3)+6;
    start_row_pos = (col_index-1)*(blk_Data+3)+7;
    num_row_pos = (col_index-1)*(blk_Data+3)+8;
    
    start_col = str2double(data_temp_1{start_col_pos}{1});
    start_row = str2double(data_temp_1{start_row_pos}{1});
    num_row = str2double(data_temp_1{num_row_pos}{1});
    
    if flag_Data(1) == '3'
        for row_index=1:num_row/2
            data_pos = (col_index-1)*(blk_Data+3)+row_index*2+7;
            matrix_Data(row_index-1+start_row,start_col) =  str2double(data_temp_1{data_pos})+1i*str2double(data_temp_1{data_pos+1});
        end
    elseif flag_Data(1) =='1'
        for row_index=1:num_row
            data_pos = (col_index-1)*(blk_Data+3)+row_index+8;
            matrix_Data(row_index-1+start_row,start_col) =  str2double(data_temp_1{data_pos});
        end
    end
end
end


