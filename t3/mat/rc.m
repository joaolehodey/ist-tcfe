close all
clear all

% Get Data From File TXT

this_file_path = fileparts(mfilename('fullpath'));
data_path = [this_file_path '/../values.txt'];
fid = fopen (data_path);


lines = strsplit(fileread(data_path), '\n');

fclose(fid);


vector = [];
for n = 1:length(lines) 
    if strfind(lines{n}, '=')
        val=strsplit(lines{n}, '=')(2);
        vector = [vector ; val];
    endif
end 

vector;

vs = str2double(vector(1)) 
rl = str2double(vector(2)) 
c1 = str2double(vector(3)) 


filename = "results.tex";
fid = fopen (filename, "w+");

fprintf(fid, "\\begin{table}[h] \n \\centering \n \\begin{tabular}{ c c } \n")

% fprintf(fid, "\n \\hline\n")
% fprintf(fid, "$y_1$ & %f \\\\ \n ", x(1))
% fprintf(fid, "\\hline\n")
% fprintf(fid, "$y_2$ & %f \\\\ \n ", x(2))
% fprintf(fid, "\\hline\n")
% fprintf(fid, "$y_3$ & %f \\\\ \n ", x(3))
% fprintf(fid, "\\hline\n")
% fprintf(fid, "$y_4$ & %f \\\\ \n ", x(4))
% fprintf(fid, "\\hline\n")

fprintf(fid, "  \\end{tabular} \n \\caption{} \n \\label{tab:mesh_results} \n \\end{table} \n ")


fclose (fid);





% ngspice_path = [this_file_path '../sim/ngdata.txt'];
fid = fopen ('../sim/ngspice_data.txt', "w+");

fprintf(fid, ".param vs = %.11f\n", vs)
fprintf(fid, ".param rl = %.11f\n", rl)
fprintf(fid, ".param c1 = %.11f\n", c1)

fclose (fid);