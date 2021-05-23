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

VT = str2double(vector(1)) 
BFN = str2double(vector(2)) 
VAFN = str2double(vector(3)) 
RE1 = str2double(vector(4))      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RC1 = str2double(vector(5))      %  values from datagen
RB1 = str2double(vector(6))      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RB2 = str2double(vector(7)) 
VBEON = str2double(vector(8)) 
VCC = str2double(vector(9)) 
RS = str2double(vector(10)) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %Actual analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


RB=1/(1/RB1+1/RB2)
VEQ=RB2/(RB1+RB2)*VCC
IB1=(VEQ-VBEON)/(RB+(1+BFN)*RE1)
IC1=BFN*IB1
IE1=(1+BFN)*IB1
VE1=RE1*IE1
VO1=VCC-RC1*IC1
VCE=VO1-VE1


gm1=IC1/VT
rpi1=BFN/gm1
ro1=VAFN/IC1

RSB=RB*RS/(RB+RS)

AV1 = RSB/RS * RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RSB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)
AVI_DB = 20*log10(abs(AV1))
AV1simple = RB/(RB+RS) * gm1*RC1/(1+gm1*RE1)
AVIsimple_DB = 20*log10(abs(AV1simple))

RE1=0
AV1 = RSB/RS * RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RSB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)
AVI_DB = 20*log10(abs(AV1))
AV1simple =  - RSB/RS * gm1*RC1/(1+gm1*RE1)
AVIsimple_DB = 20*log10(abs(AV1simple))

RE1=100
ZI1 = 1/(1/RB+1/(((ro1+RC1+RE1)*(rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)))
ZX = ro1*((RSB+rpi1)*RE1/(RSB+rpi1+RE1))/(1/(1/ro1+1/(rpi1+RSB)+1/RE1+gm1*rpi1/(rpi1+RSB)))
ZX = ro1*(   1/RE1+1/(rpi1+RSB)+1/ro1+gm1*rpi1/(rpi1+RSB)  )/(   1/RE1+1/(rpi1+RSB) ) 
ZO1 = 1/(1/ZX+1/RC1)

RE1=0
ZI1 = 1/(1/RB+1/(((ro1+RC1+RE1)*(rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)))
ZO1 = 1/(1/ro1+1/RC1)

%ouput stage
BFP = 227.3
VAFP = 37.2
RE2 = 100
VEBON = 0.7
VI2 = VO1
IE2 = (VCC-VEBON-VI2)/RE2
IC2 = BFP/(BFP+1)*IE2
VO2 = VCC - RE2*IE2

gm2 = IC2/VT
go2 = IC2/VAFP
gpi2 = gm2/BFP
ge2 = 1/RE2

AV2 = gm2/(gm2+gpi2+go2+ge2)
ZI2 = (gm2+gpi2+go2+ge2)/gpi2/(gpi2+go2+ge2)
ZO2 = 1/(gm2+gpi2+go2+ge2)


%total
gB = 1/(1/gpi2+ZO1)
AV = (gB+gm2/gpi2*gB)/(gB+ge2+go2+gm2/gpi2*gB)*AV1
AV_DB = 20*log10(abs(AV))
ZI=ZI1
ZO=1/(go2+gm2/gpi2*gB+ge2+gB)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FIRST VALUES TABEL PRINT TO REPORT

filename = "values.tex";
fid = fopen (filename, "w+");

fprintf(fid, "\\begin{table}[H] \n \\centering \n \\begin{tabular}{ c c } \n")
fprintf(fid, "\\hline\n")
fprintf(fid, "VT & %f \\\\ \n ", VT)
fprintf(fid, "\\hline\n")
fprintf(fid, "BFN & %f \\\\ \n ", BFN)
fprintf(fid, "\\hline\n")
fprintf(fid, "VAFN & %f \\\\ \n ", VAFN)
fprintf(fid, "\\hline\n")
fprintf(fid, "RE1 & %f \\\\ \n ", RE1)
fprintf(fid, "\\hline\n")
fprintf(fid, "RC1 & %f \\\\ \n ", RC1)
fprintf(fid, "\\hline\n")
fprintf(fid, "RB1 & %f \\\\ \n ", RB1)
fprintf(fid, "\\hline\n")
fprintf(fid, "RB2 & %f \\\\ \n ", RB2)
fprintf(fid, "\\hline\n")
fprintf(fid, "VBEON & %f \\\\ \n ", VBEON)
fprintf(fid, "\\hline\n")
fprintf(fid, "VCC & %f \\\\ \n ", VCC)
fprintf(fid, "\\hline\n")
fprintf(fid, "RS & %f \\\\ \n ", RS)
fprintf(fid, "\\hline\n")
fprintf(fid, "  \\end{tabular} \n \\caption{Values used as parameters for the circuit studied.} \n \\label{tab:ex1} \n \\end{table} \n ")


fclose (fid);