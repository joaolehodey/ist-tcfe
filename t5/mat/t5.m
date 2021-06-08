
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

C_R1 = 3e4
C_R2 = 2e3
C_R3 = 100e3
C_R4 = 2e3

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
F_H =  2.28832e+03

% Lower cut-off frequency
F_L =   2.22941e+02

% Central frequency(geometric average)
Central_freq = sqrt(F_H*F_L)

Diff_central_freq = abs(Central_freq-1000)


% Voltage gain deviation
Gain_1K = 3.972291e+01
Diff_Gain = abs(Gain_1K-40)

% Measures the balance between the voltage deviation and the 
Real_Merit = Diff_Gain*Central_freq

Merit = 1/(Total_Cost*((Diff_Gain*Diff_central_freq)+e-6)) 

Merit_Without_Ampop = 1/((Total_Cost-C_Ampop)*((Diff_Gain*Diff_central_freq)+e-6)) 



Data  = [R1, R2, R3, R4, Total_Cost, Central_freq, Diff_central_freq, Gain_1K, Diff_Gain, Merit]
dlmwrite ("Results.txt", Data,"    |    ", "-append")


pkg load control

f=logspace(1,7,10000);
n=columns(f);

for i=1:n
  R1 = 3.333e3;
  R2 = 0.5e3;
  R3 = 100e3;
  R4 = 1e3;
  C3 = 0.0733e-6;
  C4 = 0.3e-6;
  w(i)=2*pi*f(i);
  s(i)=j*w(i);  
  T(i) = abs( R1/(R1 + 1/(s(i)*C4)) *(1 + R3/R4) / (1 + R2*C3*s(i)));
  phase_T(i) = arg((R1*C3*s(i))*(1+R3/R4)*(1/(1+R2*C4*s(i)))*(1/(R1*C3*s(i))));
endfor

w = 2*pi*1000;
s = j*w;
t = abs((R1*C4*s)*(1+R3/R4)*(1/(1+R2*C3*s))*(1/(R1*C4*s)))

hf = figure();
semilogx(f, 20*log10(T));
grid on;
xlabel("f[Hz]");
ylabel("T(f)");
print (hf, "firstoctave.eps", "-depsc");

hf1 = figure();
semilogx(f, phase_T);
grid on;
xlabel("f[Hz]");
ylabel("arg(T)[rad]")
print (hf1, "secondoctave.eps", "-depsc");

% Gain_1K_theoric= t(j*1000*2*pi)
ZO = R2/(s*C3*R2 + 1)
ZI = 1/(s*C4) + R4



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIRST VALUES TABEL PRINT TO REPORT

filename = "results_octave.tex";
fid = fopen (filename, "w+");

fprintf(fid, "\\begin{table}[H] \n \\centering \n \\begin{tabular}{ c c } \n")
fprintf(fid, "\\hline\n")
fprintf(fid, "Total Cost & %.11f \\\\ \n ", Total_Cost)
fprintf(fid, "\\hline\n")
fprintf(fid, "Central Freq & %.11f \\\\ \n ", Central_freq)
fprintf(fid, "\\hline\n")
fprintf(fid, "Central Frequency diference & %.11f \\\\ \n ", Diff_central_freq)
fprintf(fid, "\\hline\n")
fprintf(fid, "Gain & %.11f \\\\ \n ", Gain_1K)
fprintf(fid, "\\hline\n")
fprintf(fid, "Gain Theoric & %.11f \\\\ \n ", t)
fprintf(fid, "\\hline\n")
fprintf(fid, "Cut off low & %.11f \\\\ \n ", F_L)
fprintf(fid, "\\hline\n")
fprintf(fid, "Cut off high & %.11f \\\\ \n ", F_H)
fprintf(fid, "\\hline\n")
fprintf(fid, "Gain Diference & %.11f \\\\ \n ", Diff_Gain)
fprintf(fid, "\\hline\n")
fprintf(fid, "ZO & %.11f \\\\ \n ", ZO)
fprintf(fid, "\\hline\n")
fprintf(fid, "ZI & %.11f \\\\ \n ", ZI)
fprintf(fid, "\\hline\n")
fprintf(fid, "Merit & %.11f \\\\ \n ", Merit)
fprintf(fid, "\\hline\n")
fprintf(fid, "  \\end{tabular} \n \\caption{Values used as parameters for the circuit studied.} \n \\label{tab:ex1} \n \\end{table} \n ")


fclose (fid);













#-------------------------- Writting in file to include in ngspice simulation-----------------------------------

fid = fopen ('../sim/ngspice_data.txt', "w+");

fprintf(fid, ".param R1 = %.11f\n", R1)
fprintf(fid, ".param R2 = %.11f\n", R2)
fprintf(fid, ".param R3 = %.11f\n", R3)
fprintf(fid, ".param R4 = %.11f\n", R4)
fprintf(fid, ".param C3 = %.11f\n", C3)
fprintf(fid, ".param C4 = %.11f\n", C4)

fclose (fid);