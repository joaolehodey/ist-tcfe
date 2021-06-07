
close all
clear all

pkg load symbolic;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                     %
%  CAREFULL -> if testing separately make sure file data.txt exists in main directory %
%                                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#------------------ Getting values from data.txt------------------------ WORKS

this_file_path = fileparts(mfilename('fullpath'));
data_path = [this_file_path '/data.txt'];
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

R1 = str2double(vector(1)) 
R2 = str2double(vector(2)) 
R3 = str2double(vector(3)) 
R4 = str2double(vector(4))      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C3 = str2double(vector(5))      %  values from datagen
C4 = str2double(vector(6))      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 




% Cost of the circuit

C_R1 = R1*1/1000
C_R2 = 2e3
C_R3 = 100e3
C_R4 = 1e3

C_C3 = 3*220e-9
C_C4 = 3e-6

Cost_R = (C_R1+C_R2+C_R3+C_R4)*1e-3
Cost_C =  (C_C3+C_C4)*1e+6


%--------------Cost of ampop---------------------------------

C_Capacitors = (8.661E-12 + 30.00E-12)*1e6


N_Diodes = 4 
C_Diodes = 0.1*N_Diodes


N_Transistors = 2
C_Transistor = 0.1*N_Transistors


C_R =  (100.0E3 + 2*5.305E3 + 2*1.836E3 + 13.19E6 + 50+ 100 + 16e3)*1e-3
 
C_Ampop = (C_R)+(C_Capacitors)+(C_Transistor)+(C_Diodes)   

%-------------------------------------------------------------
 
Total_Cost = Cost_R + Cost_C + C_Ampop


% Merit figure

% Central Voltage Deviation 
% Maximum Gain_frequency
F_Gmax = 9.698412e+01

% Gain at F_H and at F_L
G_H_L = 9.698412e+01/sqrt(2) 

% High cut-off frequency
F_H =  2.32965e+03

% Lower cut-off frequency
F_L =   2.18112e+02

% Central frequency(geometric average)
Central_freq = sqrt(F_H*F_L)

Diff_central_freq = abs(Central_freq-1000)


% Voltage gain deviation
Gain_1K = 39.7225 
Diff_Gain = abs(Gain_1K-40)

% Measures the balance between the voltage deviation and the 
Real_Merit = Diff_Gain*Central_freq

Merit = 1/(Total_Cost*((Diff_Gain*Diff_central_freq)+e-6)) 

Merit_Without_Ampop = 1/((Total_Cost-C_Ampop)*((Diff_Gain*Diff_central_freq)+e-6)) 



Data  = [R1, R2, R3, R4, Total_Cost, Central_freq, Diff_central_freq, Gain_1K, Diff_Gain, Merit]
dlmwrite ("Results.txt", Data,"    |    ", "-append")


















#-------------------------- Writting in file to include in ngspice simulation-----------------------------------

fid = fopen ('../sim/ngspice_data.txt', "w+");

fprintf(fid, ".param R1 = %.11f\n", R1)
fprintf(fid, ".param R2 = %.11f\n", R2)
fprintf(fid, ".param R3 = %.11f\n", R3)
fprintf(fid, ".param R4 = %.11f\n", R4)
fprintf(fid, ".param C3 = %.11f\n", C3)
fprintf(fid, ".param C4 = %.11f\n", C4)

fclose (fid);