function varargout = KontrolKecepatanPutarMotor(varargin)
% KontrolKecepatanPutarMotor MATLAB code for KontrolKecepatanPutarMotor.fig
%      KontrolKecepatanPutarMotor, by itself, creates a new KontrolKecepatanPutarMotor or raises the existing
%      singleton*.
%
%      H = KontrolKecepatanPutarMotor returns the handle to a new KontrolKecepatanPutarMotor or the handle to
%      the existing singleton*.
%
%      KontrolKecepatanPutarMotor('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KontrolKecepatanPutarMotor.M with the given input arguments.
%
%      KontrolKecepatanPutarMotor('Property','Value',...) creates a new KontrolKecepatanPutarMotor or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before KontrolKecepatanPutarMotor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to KontrolKecepatanPutarMotor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help KontrolKecepatanPutarMotor

% Last Modified by GUIDE v2.5 06-Jun-2015 09:30:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @KontrolKecepatanPutarMotor_OpeningFcn, ...
                   'gui_OutputFcn',  @KontrolKecepatanPutarMotor_OutputFcn, ...
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


% --- Executes just before KontrolKecepatanPutarMotor is made visible.
function KontrolKecepatanPutarMotor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to KontrolKecepatanPutarMotor (see VARARGIN)

% Choose default command line output for KontrolKecepatanPutarMotor
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes KontrolKecepatanPutarMotor wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = KontrolKecepatanPutarMotor_OutputFcn(hObject, eventdata, handles) 
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
% atur tombol ON agar tidak ditekan untuk keduakalinya
set(handles.tbON,'Enable', 'off');
% mulai koneksikan MATLAB-Arduino
a = arduino('com31', 'uno');
% aktifkan driver motor. saat ini saya menggunakan pin 4
writeDigitalPin(a,4,1);
% aktifkan slider
set(handles.slMotor,'Enable', 'on');


% --- Executes on slider movement.
function slMotor_Callback(hObject, eventdata, handles)
% hObject    handle to slMotor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global a
% dapatkan nilai dari slider
nilaiMotor = get(handles.slMotor,'Value');
% nilai PWM = nilai input * 255 / maksimum input
nilaiPWM = round(nilaiMotor*255/1);
% umpan nilai-nilai ke teks untuk ditampilkan
set(handles.text3, 'String',nilaiMotor);
set(handles.text5, 'String',nilaiPWM);
% tulis nilai PWM ke Arduino
writePWMDutyCycle(a, 5, nilaiMotor);


% --- Executes during object creation, after setting all properties.
function slMotor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slMotor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in tbKeluar.
function tbKeluar_Callback(hObject, eventdata, handles)
% hObject    handle to tbKeluar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% tanyakan apakah ingin benar-benar keluar aplikasi?

pilihan = questdlg('Ingin keluar dari aplikasi?', 'Keluar Aplikasi', ...
          'Ya', 'Tidak', 'Ya');
      switch pilihan
          case 'Ya'
              % hapus aplikasi dan memori pd MATLAB
              delete(handles.figure1);
              clear all;
          case 'Tidak'
              % batal keluar. kembalikan ke keadaan semula
              return;
      end
