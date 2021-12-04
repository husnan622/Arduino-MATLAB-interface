function varargout = Plotly_GUI(varargin)
% PLOTLY_GUI MATLAB code for Plotly_GUI.fig
%      PLOTLY_GUI, by itself, creates a new PLOTLY_GUI or raises the existing
%      singleton*.
%
%      H = PLOTLY_GUI returns the handle to a new PLOTLY_GUI or the handle to
%      the existing singleton*.
%
%      PLOTLY_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTLY_GUI.M with the given input arguments.
%
%      PLOTLY_GUI('Property','Value',...) creates a new PLOTLY_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Plotly_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Plotly_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Plotly_GUI

% Last Modified by GUIDE v2.5 18-Jun-2015 18:35:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Plotly_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Plotly_GUI_OutputFcn, ...
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


% --- Executes just before Plotly_GUI is made visible.
function Plotly_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Plotly_GUI (see VARARGIN)

% Choose default command line output for Plotly_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Plotly_GUI wait for user response (see UIRESUME)
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
delay = 1;                            % waktu cuplik
 
%Inisialisasi variabel data grafik dibuat nol semua
waktu = 0;
data = 0;
cacah = 0;

% Ubah tampilan grafik di awal GUI di-load
axes(handles.axes1);
plotGraph = plot(waktu,data,'-o',...
                'LineWidth',2,...
                'MarkerSize',10,...
                'MarkerEdgeColor','r',...
                'MarkerFaceColor','g');
% tampilkan tulisan pada axes             
xlabel(xLabel,'FontSize',12);
ylabel(yLabel,'FontSize',12);
% atur posisi sumbu-x dan sumbu-y
axis([0 10 min max]);
% aktifkan grid
grid(plotGrid);                 


% --- Outputs from this function are returned to the command line.
function varargout = Plotly_GUI_OutputFcn(hObject, eventdata, handles) 
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

global a ps dataPlotly args
% atur tombol mana yang aktif dan tidak aktif
set(handles.tbON,'Enable', 'off');

% mulai koneksikan MATLAB-Arduino
a = arduino('com33', 'uno');

%============================================================
% persiapkan data utk Plotly
% ubahlah sesuai dengan akun probadi kita
saveplotlycredentials('AkunSaya','abcdefghi1',...
{'abcdefghi2','abcdefghi3','abcdefghi4'});
% load hasil konfigurasi
data_saya = loadplotlycredentials;
% ambil satu token.. bisa dipilih sesuai keinginan
streamTokenSaya = data_saya.stream_ids{1};
% seting awal untuk data
dataPlotly{1}.x = []; 
dataPlotly{1}.y = [];
dataPlotly{1}.line.width = 5;
dataPlotly{1}.marker.symbol = 'circle';
dataPlotly{1}.line.color = 'rgba(0,200,200,0.5)';
dataPlotly{1}.marker.size = 10;
dataPlotly{1}.marker.line.width = 2;
dataPlotly{1}.type = 'scatter';
dataPlotly{1}.mode = 'lines+markers';
dataPlotly{1}.stream.token = streamTokenSaya;
dataPlotly{1}.stream.maxpoints = 30;
args.filename = 'STREAM DATA DARI ARDUINO'; 
args.fileopt = 'overwrite';
args.layout.title = 'REAL TIME SINYAL ARDUINO';
args.layout.yaxis.range = [0 5];
args.layout.yaxis.title = 'Tegangan (Volt)';
args.layout.xaxis.title = 'Waktu (Detik)';

% lakukan koneksi dan amati respon
respon = plotly(dataPlotly,args);
% Kirim data ke Command Window dan kunjungi alamat ini
alamatURL = respon.url;
disp(alamatURL)
% mulai lakukan inisialisasi data streaming
ps = plotlystream(streamTokenSaya);


% aktifkan tombol Connect
set(handles.tbConnect,'Enable', 'on');

% --- Executes on button press in tbConnect.
function tbConnect_Callback(hObject, eventdata, handles)
% hObject    handle to tbConnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% deklarasikan variabel-variabel global. 
global a ps dataPlotly args
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
    % refresh data ketika ditekan tombol Connect
    plotly(dataPlotly,args);
    ps.open();

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
    ps.close();
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
        
        % kirim data ke plotly        
        mydata.x = waktu(cacah);
        mydata.y = data(cacah);
        ps.write(mydata);
        
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
pilihan = questdlg('Ingin keluar dari aplikasi?', ...
      'Keluar Aplikasi','Ya', 'Tidak', 'Ya');
      switch pilihan
          case 'Ya'
              state=0;
              delete(handles.figure1);
              clear all;
          case 'Tidak'
              % batal keluar. kembalikan ke keadaan semula
              return;
      end



  
       
    