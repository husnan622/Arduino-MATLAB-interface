clear all;
clc
 
%Inisialisasi serial dan grafik 
serialPort = 'COM31';                       % isi dgn COM yg sesuai
judulGrafik = 'Logger Data Sensor Jarak';   % Judul grafik
xLabel = 'Waktu (detik)';                   % x-axis label
yLabel = 'Jarak (cm)';                           % y-axis label
barGrid = 'on';                             % aktifkan grid
min = 0;                                    % minimum axis-y
max = 40;                                   % maksimum axis-y
lebarScroll = 10;                           % display data pada grafik
delay = 0.5;                                  % waktu cuplik
 
%Inisialisasi variabel
waktu = 0;
data = 0;
cacah = 0;
 
%Persiapkan grafik
barGraph = bar(waktu,data,'g',...
    'LineWidth',2,...
    'EdgeColor','r');
title(judulGrafik,'FontSize',15);
xlabel(xLabel,'FontSize',12);
ylabel(yLabel,'FontSize',12);
axis([0 10 min max]);
grid(barGrid);                         %aktifkan grid
s = serial(serialPort);                %Buka komunikasi melalui port COM
set(s,'Timeout',1);                    % set timeout utk komunikasi
disp('Tutup jendela grafik untuk mengakhiri logger');
fopen(s);
fprintf(s,'%s',char(1));               %kirim 1 untuk mengirim Request 
tic                                    %aktifkan deteksi waktu
while ishandle(barGraph)               %Terus looping semasih plot aktif
    pause(0.05);
    nilaiInput = fscanf(s,'%f');       %Baca data serial dalam format float
    disp('Data Diterima!')
    %Pastikan data yg diterima benar
    if(~isempty(nilaiInput) && isfloat(nilaiInput))          
        cacah = cacah + 1;    
        waktu(cacah) = toc;             %ambil waktu saat ini       
        data(cacah) = nilaiInput(1);    %ambil data saat ini         
         
        %Set Axis sesuai dengan nilai lebarScroll
        if(lebarScroll > 0)
        set(barGraph,'XData',waktu(waktu > waktu(cacah)-lebarScroll), ...
            'YData',data(waktu > waktu(cacah)-lebarScroll));
        axis([waktu(cacah)-lebarScroll waktu(cacah) min max]);
        else
        set(barGraph,'XData',waktu,'YData',data);
        axis([0 waktu(cacah) min max]);
        end
         
        %Beri waktu sesaat utk Update Plot
        pause(delay);
    end
    fprintf(s,'%s',char(1));              %kirim '1' untuk mengirim Request
    disp('Request Dikirim...')    
end
 
% Tutup serial port dan delete variabel yg sudah terpakai
fclose(s);
clear all; 
disp('Logger berakhir...');