clear
clc
 
%Inisialisasi serial dan grafik 
serialPort = 'COM33';                 % isi dgn COM yg sesuai
judulGrafik = 'Logger Data Serial';   % Judul grafik
xLabel = 'Waktu (detik)';             % x-axis label
yLabel = 'Data';                      % y-axis label
plotGrid = 'on';                      % aktifkan grid
min = 0;                             % minimum axis-y
max = 1050;                              % maksimum axis-y
lebarScroll = 20;                     % display data pada grafik
delay = .01;                          % waktu cuplik
 
%Inisialisasi variabel
waktu = 0;
data = 0;
cacah = 0;
 
%Persiapkan grafik
plotGraph = plot(waktu,data,'-o',...
                'LineWidth',1,...
                'MarkerSize',3,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','r');
             
title(judulGrafik,'FontSize',15);
xlabel(xLabel,'FontSize',12);
ylabel(yLabel,'FontSize',12);
axis([0 10 min max]);
grid(plotGrid);  %aktifkan grid
 
%Buka komunikasi melalui port COM
s = serial(serialPort);
disp('Tutup jendela grafik untuk mengakhiri logger');
fopen(s);
 
tic                                    %aktifkan deteksi waktu
while ishandle(plotGraph)              %Terus looping semasih plot aktif
     
    nilaiInput = fscanf(s,'%f');       %Baca data serial dalam format float
    
    %Pastikan data yg diterima benar
    if(~isempty(nilaiInput) && isfloat(nilaiInput))          
        cacah = cacah + 1;    
        waktu(cacah) = toc;             %ambil waktu saat ini
        data(cacah) = nilaiInput(1);    %ambil data saat ini         
        cekWarna = mod(cacah,2);
        
        %Set Axis sesuai dengan nilai lebarScroll
        if(lebarScroll > 0)
        set(plotGraph,'XData',waktu(waktu > waktu(cacah)-lebarScroll),'YData',data(waktu > waktu(cacah)-lebarScroll));
        axis([waktu(cacah)-lebarScroll waktu(cacah) min max]);
        else
        set(plotGraph,'XData',waktu,'YData',data);
        axis([0 waktu(cacah) min max]);
        end
        
        %Beri waktu sesaat utk Update Plot
        pause(delay);
        
    end
end
 
% Tutup serial port dan delete variabel yg sudah terpakai
fclose(s);
clear all; 
disp('Logger berakhir...');