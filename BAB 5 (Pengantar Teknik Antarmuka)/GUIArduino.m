function varargout = GUIArduino(varargin)
% GUIARDUINO MATLAB code for GUIArduino.fig
%      GUIARDUINO, by itself, creates a new GUIARDUINO or raises the existing
%      singleton*.
%
%      H = GUIARDUINO returns the handle to a new GUIARDUINO or the handle to
%      the existing singleton*.
%
%      GUIARDUINO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIARDUINO.M with the given input arguments.
%
%      GUIARDUINO('Property','Value',...) creates a new GUIARDUINO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIArduino_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIArduino_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIArduino

% Last Modified by GUIDE v2.5 31-July-2015 22:53:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIArduino_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIArduino_OutputFcn, ...
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


% --- Executes just before GUIArduino is made visible.
function GUIArduino_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIArduino (see VARARGIN)

% Choose default command line output for GUIArduino
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIArduino wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% deklarasikan variabel state dan posisiTombol
global posisiTombol state
posisiTombol = 1;
state = 0;

%deklarasikan variabel-variabel global untuk membangun grafik
global waktu data cacah plotGraph lebarScroll delay min max

% Deklarasikan properti grafik:
xLabel = 'Waktu (detik)';             % x-axis label
yLabel = 'Data';                      % y-axis label
plotGrid = 'on';                      % aktifkan grid
min = 0;                              % minimum axis-y
max = 5;                              % maksimum axis-y
lebarScroll = 10;                     % display data pada grafik
delay = 1;                          % waktu cuplik
 
%Inisialisasi variabel data grafik dibuat nol semua
waktu = 0;
data = 0;
cacah = 0;

% Ubah tampilan grafik di awal GUI di-load
axes(handles.axes1);
plotGraph = plot(waktu,data,'--o',...
                'LineWidth',1,...
                'MarkerSize',4,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','r');
% tampilkan tulisan pada axes             
xlabel(xLabel,'FontSize',12);
ylabel(yLabel,'FontSize',12);
% atur posisi sumbu-x dan sumbu-y
axis([0 10 min max]);
% aktifkan grid
grid(plotGrid);                 


% --- Outputs from this function are returned to the command line.
function varargout = GUIArduino_OutputFcn(hObject, eventdata, handles) 
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
global a
% atus timbol mana yang aktif dan tidak aktif
set(handles.tbON,'Enable', 'off');
set(handles.tbConnect,'Enable', 'on');
% mulai koneksikan MATLAB-Arduino
a = arduino('com33', 'uno');



% --- Executes on button press in tbConnect.
function tbConnect_Callback(hObject, eventdata, handles)
% hObject    handle to tbConnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% deklarasikan variabel-variabel global. 
global a
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
    posisiTombol = 0;    
else
    % Tombol saat ini Disconnect. Switch tampilan tulisan menjadi Connect
    set(handles.tbConnect,'String','Connect');
    set(handles.tbKeluar,'Enable', 'on');
    % putus pengambilan data
    state = 0;
    % pangsung ubah status tombol menjadi Connect
    posisiTombol = 1;
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
    nilaiInput = readVoltage(a,0);
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
