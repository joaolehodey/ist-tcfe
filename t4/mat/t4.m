%gain stage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                     %
%  CAREFULL -> if testing separately make sure file data.txt exists in main directory %
%                                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#------------------ Getting values from data.txt------------------------ WORKS

this_file_path = fileparts(mfilename('fullpath'));
data_path = [this_file_path '/../valores.txt'];
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

VT = str2double(vector(1)) ;
BFN = str2double(vector(2)) ;
VAFN = str2double(vector(3)) ;
RE1 = str2double(vector(4))  ;    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RC1 = str2double(vector(5)) ;     %  values from datagen
RB1 = str2double(vector(6)) ;     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RB2 = str2double(vector(7)) ;
VBEON = str2double(vector(8)) ;
VCC = str2double(vector(9)) ;
RS = str2double(vector(10)) ;
RL = 8;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %Actual analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


RB = 1/(1/RB1+1/RB2);
VEQ = RB2/(RB1+RB2)*VCC;

% Colocar tudo isto 
IB1 = (VEQ-VBEON)/(RB+(1+BFN)*RE1)
IC1 = BFN*IB1
IE1 = (1+BFN)*IB1
VE1 = RE1*IE1
VO1 = VCC-RC1*IC1
VCE = VO1-VE1

% isto também 
gm1 = IC1/VT
rpi1 = BFN/gm1
ro1 = VAFN/IC1



RE1 = 100;

% impedancia de entrada do transistor 1 : ZI1 = rpi || R2 || R1

ZI1 = RB1*RB2*rpi1/(RB1*RB2+ RB1*rpi1+ RB2*rpi1) 

% Impedância de saída 1: Zo1 = r01||RC1
ZO1 = ro1*RC1/(ro1+RC1)

% ganho de tensão 1 em módulo
AV1 = gm1*ZO1*(ZI1/(ZI1+RS))

% ouput stage
BFP = 227.3;
VAFP = 37.2;
RE2 = 100;
VEBON = 0.7;

% Colocar tudo isto 
VI2 = VO1
IE2 = (VCC-VEBON-VI2)/RE2
IC2 = BFP/(BFP+1)*IE2
VO2 = VCC - RE2*IE2

% isto também 
gm2 = IC2/VT
go2 = IC2/VAFP
gpi2 = gm2/BFP
ge2 = 1/RE2

% ganho de tensão 2 em módulo
AV2 = gm2/(gm2+gpi2+go2+ge2)

% impedancia de entrada do tansistor 2

ZI2 = (gm2+gpi2+go2+ge2)/gpi2/(gpi2+go2+ge2)

% Impedância de saída 2
ZO2 = 1/(gm2+gpi2+go2+ge2)

% Este rácio tem que ser aproximadamente 1
% Confirmação da baixa perda de sinal entre os trasistores:
b = ZI2/(ZI2+ ZO1)

% Confirmação que n há perda de sinal entre a fonte Vin e o primeiro transistor
% deve ser aproximadamente 1
a = ZI1/(ZI1+RS)

% Confirmação que n há perda de sinal entre o egundo transistor e o altifalante
% deve ser aproximadamente 1
c = RL/(RL+ZO2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OP

filename = "octave1.tex";
fid = fopen (filename, "w+");

fprintf(fid, "\\begin{table}[H] \n \\centering \n \\begin{tabular}{ c c } \n")
fprintf(fid, "\\hline\n")
fprintf(fid, "IB1 & %f \\\\ \n ", IB1)
fprintf(fid, "\\hline\n")
fprintf(fid, "IC1 & %f \\\\ \n ", IC1)
fprintf(fid, "\\hline\n")
fprintf(fid, "IE1 & %f \\\\ \n ", IE1)
fprintf(fid, "\\hline\n")
fprintf(fid, "VE1 & %f \\\\ \n ", VE1)
fprintf(fid, "\\hline\n")
fprintf(fid, "VO1 & %f \\\\ \n ", VO1)
fprintf(fid, "\\hline\n")
fprintf(fid, "VCE & %f \\\\ \n ", VCE)
fprintf(fid, "\\hline\n")
fprintf(fid, "gm1 & %f \\\\ \n ", gm1)
fprintf(fid, "\\hline\n")
fprintf(fid, "rpi1 & %f \\\\ \n ", rpi1)
fprintf(fid, "\\hline\n")
fprintf(fid, "ro1 & %f \\\\ \n ", ro1)
fprintf(fid, "\\hline\n")
fprintf(fid, "ZI1 & %f \\\\ \n ", ZI1)
fprintf(fid, "\\hline\n")
fprintf(fid, "ZO1 & %f \\\\ \n ", ZO1)
fprintf(fid, "\\hline\n")
fprintf(fid, "AV1 & %f \\\\ \n ", AV1)
fprintf(fid, "\\hline\n")
fprintf(fid, "VI2 & %f \\\\ \n ", VI2)
fprintf(fid, "\\hline\n")
fprintf(fid, "IE2 & %f \\\\ \n ", IE2)
fprintf(fid, "\\hline\n")
fprintf(fid, "IC2 & %f \\\\ \n ", IC2)
fprintf(fid, "\\hline\n")
fprintf(fid, "VO2 & %f \\\\ \n ", VO2)
fprintf(fid, "\\hline\n")
fprintf(fid, "gm2 & %f \\\\ \n ", gm2)
fprintf(fid, "\\hline\n")
fprintf(fid, "go2 & %f \\\\ \n ", go2)
fprintf(fid, "\\hline\n")
fprintf(fid, "gpi2 & %f \\\\ \n ", gpi2)
fprintf(fid, "\\hline\n")
fprintf(fid, "ge2 & %f \\\\ \n ", ge2)
fprintf(fid, "\\hline\n")
fprintf(fid, "AV2 & %f \\\\ \n ", AV2)
fprintf(fid, "\\hline\n")
fprintf(fid, "ZI2 & %f \\\\ \n ", ZI2)
fprintf(fid, "\\hline\n")
fprintf(fid, "ZO2 & %f \\\\ \n ", ZO2)
fprintf(fid, "\\hline\n")
fprintf(fid, "a & %f \\\\ \n ", a)
fprintf(fid, "\\hline\n")
fprintf(fid, "b & %f \\\\ \n ", b)
fprintf(fid, "\\hline\n")
fprintf(fid, "c & %f \\\\ \n ", c)
fprintf(fid, "\\hline\n")
fprintf(fid, "  \\end{tabular} \n \\caption{Operating point theoretically} \n \\label{tab:ex1} \n \\end{table} \n ")


fclose (fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIRST VALUES TABEL PRINT TO REPORT

filename = "values.tex";
fid = fopen (filename, "w+");

fprintf(fid, "\\begin{table}[H] \n \\centering \n \\begin{tabular}{ c c } \n")
fprintf(fid, "\\hline\n")
fprintf(fid, "RE1 & %f \\\\ \n ", RE1)
fprintf(fid, "\\hline\n")
fprintf(fid, "RC1 & %f \\\\ \n ", RC1)
fprintf(fid, "\\hline\n")
fprintf(fid, "RB1 & %f \\\\ \n ", RB1)
fprintf(fid, "\\hline\n")
fprintf(fid, "RB2 & %f \\\\ \n ", RB2)
fprintf(fid, "\\hline\n")
fprintf(fid, "VCC & %f \\\\ \n ", VCC)
fprintf(fid, "\\hline\n")
fprintf(fid, "RS & %f \\\\ \n ", RS)
fprintf(fid, "\\hline\n")
fprintf(fid, "  \\end{tabular} \n \\caption{Values used as parameters for the circuit studied.} \n \\label{tab:ex1} \n \\end{table} \n ")


fclose (fid);

%%%%%%%%%%%%%%%%%%%% VALLUES FOR USE IN NGSPICE%%%%5

fid = fopen ('../sim/ngspice_data.txt', "w+");


fprintf(fid, ".param RE1 = %.11f\n", RE1)
fprintf(fid, ".param RC1 = %.11f\n", RC1)
fprintf(fid, ".param RB1 = %.11f\n", RB1)
fprintf(fid, ".param RB2 = %.11f\n", RB2)
fprintf(fid, ".param VCC = %.11f\n", VCC)
fprintf(fid, ".param RS = %.11f\n", RS)


fclose (fid);