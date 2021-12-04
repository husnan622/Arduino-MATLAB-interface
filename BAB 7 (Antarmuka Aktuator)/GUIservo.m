function varargout = GUIservo(varargin)
% GUISERVO MATLAB code for GUIservo.fig
%      GUISERVO, by itself, creates a new GUISERVO or raises the existing
%      singleton*.
%
%      H = GUISERVO returns the handle to a new GUISERVO or the handle to
%      the existing singleton*.
%
%      GUISERVO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUISERVO.M with the given input arguments.
%
%      GUISERVO('Property','Value',...) creates a new GUISERVO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIservo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIservo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIservo

% Last Modified by GUIDE v2.5 09-Sep-2015 12:12:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIservo_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIservo_OutputFcn, ...
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


% --- Executes just before GUIservo is made visible.
function GUIservo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIservo (see VARARGIN)

% Choose default command line output for GUIservo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIservo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIservo_OutputFcn(hObject, eventdata, handles) 
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

global a s
% mulai koneksikan MATLAB-Arduino
a = arduino('com33', 'uno', 'Libraries', 'Servo');
% buat objek servo. ganti sesuai dengan pin yang digunakan
s = servo(a, 4);
% posisikan pada sudut 0 derajat
writePosition(s,0);
% atur penampakan tombol
set(handles.slSudut,'Enable','on');
set(handles.edSudut,'Enable','on');

% --- Executes on button press in tbKeluar.
function tbKeluar_Callback(hObject, eventdata, handles)
% hObject    handle to tbKeluar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pilihan = questdlg('Ingin keluar dari aplikasi?', ...
    'Keluar Aplikasi','Ya', 'Tidak', 'Ya');
      switch pilihan
          case 'Ya'              
              delete(handles.figure1);
              clear all;
          case 'Tidak'
              % batal keluar. kembalikan ke keadaan semula
              return;
      end
      
% --- Executes on slider movement.
function slSudut_Callback(hObject, eventdata, handles)
% hObject    handle to slSudut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global s nilaiServo nilaiSudut
% ambil nilai slider
nilaiServo = get(handles.slSudut,'Value');
writePosition(s,nilaiServo);
nilaiSudut = round(nilaiServo*180);
set(handles.textSudut,'String',nilaiSudut);


% --- Executes during object creation, after setting all properties.
function slSudut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slSudut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function edSudut_Callback(hObject, eventdata, handles)
% hObject    handle to edSudut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edSudut as text
%        str2double(get(hObject,'String')) returns contents of edSudut as a double
global s nilaiServo nilaiSudut
nilaiServo = str2double(get(handles.edSudut,'String'));

% pastikan input dari user benar
if nilaiServo<0
    nilaiServo = 0;
elseif nilaiServo>180
    nilaiServo = 180;
else
    % jika user memasukkan SELAIN karakter angka, berilah nilai nol
    nilaiServo = 0;
end
nilaiServo = nilaiServo/180;
writePosition(s,nilaiServo);
nilaiSudut = round(nilaiServo*180);
set(handles.textSudut,'String',nilaiSudut);

% --- Executes during object creation, after setting all properties.
function edSudut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edSudut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
