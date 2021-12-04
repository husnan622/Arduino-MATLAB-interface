function varargout = GUIArduinoI2C(varargin)
% GUIARDUINOI2C MATLAB code for GUIArduinoI2C.fig
%      GUIARDUINOI2C, by itself, creates a new GUIARDUINOI2C or raises the existing
%      singleton*.
%
%      H = GUIARDUINOI2C returns the handle to a new GUIARDUINOI2C or the handle to
%      the existing singleton*.
%
%      GUIARDUINOI2C('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIARDUINOI2C.M with the given input arguments.
%
%      GUIARDUINOI2C('Property','Value',...) creates a new GUIARDUINOI2C or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIArduinoI2C_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIArduinoI2C_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIArduinoI2C

% Last Modified by GUIDE v2.5 01-Aug-2015 10:47:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIArduinoI2C_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIArduinoI2C_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUIArduinoI2C is made visible.
function GUIArduinoI2C_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIArduinoI2C (see VARARGIN)

% Choose default command line output for GUIArduinoI2C
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIArduinoI2C wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% deklarasikan variabel state dan posisiTombol
global posisiTombol state tombolLED
posisiTombol = 1;
state = 0;
tombolLED = true(1);

%deklarasikan variabel-variabel global untuk membangun grafik
global waktu data cacah plotGraph lebarScroll delay min max

% Deklarasikan properti grafik:
xLabel = 'Waktu (detik)';             % x-axis label
yLabel = 'Data';                      % y-axis label
plotGrid = 'on';                      % aktifkan grid
min = 0;                              % minimum axis-y
max = 300;                            % maksimum axis-y
lebarScroll = 10;                     % display data pada grafik
delay = 0.5;                          % waktu cuplik
 
%Inisialisasi variabel data grafik dibuat nol semua
waktu = 0;
data = 0;
cacah = 0;

% Ubah tampilan grafik di awal GUI di-load
axes(handles.axes1);
plotGraph = plot(waktu,data,'--o',...
                'LineWidth',2,...
                'MarkerSize',6,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','r');
% tampilkan tulisan pada axes             
xlabel(xLabel,'FontSize',12);
ylabel(yLabel,'FontSize',12);
% atur posisi sumbu-x dan sumbu-y
axis([0 10 min max]);
% aktifkan grid
grid(plotGrid);                 


% --- Outputs from this function are returned to the command line.
function varargout = GUIArduinoI2C_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in tbON.
function tbON_Callback(hObject, eventdata, handles)
% hObject    handle to tbON (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Disini digunakan Arduino UNO pada COM 33. Sesuaikan dgn komputer Anda!
global a I2Cdevice
% atur tombol mana yang aktif dan tidak aktif
set(handles.tbON,'Enable', 'off');
set(handles.tbConnect,'Enable', 'on');
% mulai koneksikan MATLAB-Arduino
a = arduino('com33', 'uno', 'Libraries', 'I2C');
% sesuaikan dengan alamat slave
I2Cdevice = i2cdev(a, '0x02');
% buat LED pada di awal
write(I2Cdevice,0,'uint8');
% aktifkan tombol LED
set(handles.tbLED,'Enable', 'on');


% --- Executes on button press in tbConnect.
function tbConnect_Callback(hObject, eventdata, handles)
% hObject    handle to tbConnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% deklarasikan variabel-variabel global. 
global I2Cdevice
global posisiTombol state
global waktu data cacah plotGraph lebarScroll delay min max

% cek keadaan tombol saat ini
if (posisiTombol==1)
    % Tombol saat ini Connect. Switch tampilan tulisan menjadi Disconnect
    set(handles.tbConnect,'String','Disconnect');
    set(handles.tbKeluar,'Enable', 'off');
    % aktifkan pengambilan data Arduino
    state = 1;
    % langsung ubah status tombol menjadi Disconnect
    posisiTombol = ~(posisiTombol);    
else
    % Tombol saat ini Disconnect. Switch tampilan tulisan menjadi Connect
    set(handles.tbConnect,'String','Connect');
    set(handles.tbKeluar,'Enable', 'on');
    % putus pengambilan data
    state = 0;
    % pangsung ubah status tombol menjadi Connect
    posisiTombol = ~(posisiTombol);
    %Inisialisasi variabel kembali menjadi nol ketika di-Disconnect
    waktu = 0;
    data = 0;
    cacah = 0;
end

% tampilkan data pada axes 1
axes(handles.axes1);

% start timer pakai perintah tic
tic

%ambil data dari Arduino secara terus-menerus selagi state = 1
while(state==1)
    % baca data dari Arduino
    % selanjutnya Arduino akan request ke slave    
    nilaiInput = double(read(I2Cdevice, 1, 'uint8'));    
    %Pastikan data yg diterima benar
    if(~isempty(nilaiInput) && isfloat(nilaiInput))          
        cacah = cacah + 1;              %start counter  
        waktu(cacah) = toc;             %ambil waktu saat ini
        data(cacah) = nilaiInput(1);    %ambil data saat ini         

        %Set Axis sesuai dengan nilai lebarScroll
        if(lebarScroll > 0)
        set(plotGraph,'XData',waktu(waktu > waktu(cacah)-lebarScroll), ...
            'YData',data(waktu > waktu(cacah)-lebarScroll));
        axis([waktu(cacah)-lebarScroll waktu(cacah) min max]);
        else
        set(plotGraph,'XData',waktu,'YData',data);
        axis([0 waktu(cacah) min max]);
        end

        %Beri waktu sesaat utk Update Plot
        pause(delay);
    end
end

% --- Executes on button press in tbKeluar.
function tbKeluar_Callback(hObject, eventdata, handles)
% hObject    handle to tbKeluar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% tanyakan apakah ingin benar-benar keluar aplikasi?
global state
pilihan = questdlg('Ingin keluar dari aplikasi?', 'Keluar Aplikasi', ...
          'Ya', 'Tidak', 'Ya');
      switch pilihan
          case 'Ya'
              % pastikan state = 0, hapus aplikasi dan memori pd MATLAB
              state=0;
              delete(handles.figure1);
              clear all;
          case 'Tidak'
              % batal keluar. kembalikan ke keadaan semula
              return;
      end


% --- Executes on button press in tbLED.
function tbLED_Callback(hObject, eventdata, handles)
% hObject    handle to tbLED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global I2Cdevice tombolLED
if(tombolLED ==1)
    write(I2Cdevice,1,'uint8');
    tombolLED = ~(tombolLED);
    set(handles.tbLED,'BackgroundColor','green','String','LED:ON');    
else
    write(I2Cdevice,0,'uint8');
    tombolLED = ~(tombolLED);
    set(handles.tbLED,'BackgroundColor','red','String','LED:OFF');
end
