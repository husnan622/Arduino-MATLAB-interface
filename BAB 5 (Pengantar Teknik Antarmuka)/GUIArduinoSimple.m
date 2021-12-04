function varargout = GUIArduinoSimple(varargin)
% GUIARDUINOSIMPLE MATLAB code for GUIArduinoSimple.fig
%      GUIARDUINOSIMPLE, by itself, creates a new GUIARDUINOSIMPLE or raises the existing
%      singleton*.
%
%      H = GUIARDUINOSIMPLE returns the handle to a new GUIARDUINOSIMPLE or the handle to
%      the existing singleton*.
%
%      GUIARDUINOSIMPLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIARDUINOSIMPLE.M with the given input arguments.
%
%      GUIARDUINOSIMPLE('Property','Value',...) creates a new GUIARDUINOSIMPLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIArduinoSimple_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIArduinoSimple_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIArduinoSimple 

% Last Modified by GUIDE v2.5 25-May-2015 07:16:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIArduinoSimple_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIArduinoSimple_OutputFcn, ...
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


% --- Executes just before GUIArduinoSimple is made visible.
function GUIArduinoSimple_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIArduinoSimple (see VARARGIN)

% Choose default command line output for GUIArduinoSimple
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIArduinoSimple wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global state
state = 0;


% --- Outputs from this function are returned to the command line.
function varargout = GUIArduinoSimple_OutputFcn(hObject, eventdata, handles) 
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

% variabel a sebagai objek utk Arduino dan jadikan sbg variabel global
global a
% saat segera setelah dijalankan, deactive-kan tombol ini agar tidak
% ditekan lebih dari sekali. 
set(handles.tbON,'Enable','off');
% Disini digunakan Arduino UNO pada COM 33. Sesuaikan dgn komputer Anda!
a = arduino('com33', 'uno');
set(handles.tbConnect,'Enable','on');




% --- Executes on button press in tbConnect.
function tbConnect_Callback(hObject, eventdata, handles)
% hObject    handle to tbConnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% deklarasikan kembali variabel global utk a dan state
global a state
% variabel state dibuat 1 agar Arduino mulai membaca dari Arduino
state = 1;
% pastikan tombol Connect nonaktif dan aktifkan tombol Disconnect
set(handles.tbConnect,'Enable', 'off');
set(handles.tbDisconnect,'Enable', 'on');
% larang menekan tombol keluar sebelum tombol Disconnect ditekan
set(handles.tbKeluar,'Enable','off');
% jika tombol disconnect belum ditekan (state =1), maka baca terus-menerus
while (state==1)
    % baca nilai dari arduino, dan tempatkan hasilnya di variabel data
    data = readVoltage(a,0);
    % ambil nilai varibel data, dan keluarkan pada Static Text 2
    set(handles.text2,'String',data);
    % jeda beberapa saat agar tidak terlalu cepat
    pause(0.1);
end


% --- Executes on button press in tbDisconnect.
function tbDisconnect_Callback(hObject, eventdata, handles)
% hObject    handle to tbDisconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global state
% ubah state menjadi 0 agar komunikasi MATLAB-Arduino terputus
state=0;
% jangan lupa aktifkan dan non aktifkan tombol yg Connect dan Disconnect
set(handles.tbConnect,'Enable','on');
set(handles.tbDisconnect,'Enable','off');
% setelah Disconnect, baru ijinkan keluar aplikasi
set(handles.tbKeluar,'Enable','on');
% set kembali nilai sensor menjadi nol
set(handles.text2,'String','0');

% --- Executes on button press in tbKeluar.
function tbKeluar_Callback(hObject, eventdata, handles)
% hObject    handle to tbKeluar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% hapus figure utama
delete(handles.figure1);
% hapus semua variabel yang tersimpan pada MATLAB
clear all;
