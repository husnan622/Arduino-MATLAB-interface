function varargout = lcd_matlab(varargin)
% LCD_MATLAB MATLAB code for lcd_matlab.fig
%      LCD_MATLAB, by itself, creates a new LCD_MATLAB or raises the existing
%      singleton*.
%
%      H = LCD_MATLAB returns the handle to a new LCD_MATLAB or the handle to
%      the existing singleton*.
%
%      LCD_MATLAB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LCD_MATLAB.M with the given input arguments.
%
%      LCD_MATLAB('Property','Value',...) creates a new LCD_MATLAB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lcd_matlab_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lcd_matlab_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lcd_matlab

% Last Modified by GUIDE v2.5 27-Aug-2015 12:30:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lcd_matlab_OpeningFcn, ...
                   'gui_OutputFcn',  @lcd_matlab_OutputFcn, ...
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


% --- Executes just before lcd_matlab is made visible.
function lcd_matlab_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lcd_matlab (see VARARGIN)

% Choose default command line output for lcd_matlab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lcd_matlab wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = lcd_matlab_OutputFcn(hObject, eventdata, handles) 
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

global serialKu
set(handles.tbON,'Enable','Off');
%sesuaikan dengan serial port kita
serialKu = serial('COM33');  
% atur properti dari komunikasi serial
serialKu.BaudRate=9600;
fopen(serialKu);
set(handles.tbKirim,'Enable','On');
set(handles.tbClear,'Enable','On');
set(handles.tbKeluar,'Enable','On');

% --- Executes on button press in tbKirim.
function tbKirim_Callback(hObject, eventdata, handles)
% hObject    handle to tbKirim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global karakterLCD
global serialKu;
fwrite(serialKu, karakterLCD);

% --- Executes on button press in tbClear.
function tbClear_Callback(hObject, eventdata, handles)
% hObject    handle to tbClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global serialKu;
fwrite(serialKu, ' ');
set(handles.edKarakter,'String','');
 
 
function edKarakter_Callback(hObject, eventdata, handles)
% hObject    handle to edKarakter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edKarakter as text
%        str2double(get(hObject,'String')) returns contents of edKarakter as a double

global karakterLCD
karakterLCD = num2str(get(handles.edKarakter,'String'));


% --- Executes during object creation, after setting all properties.
function edKarakter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edKarakter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in tbKeluar.
function tbKeluar_Callback(hObject, eventdata, handles)
% hObject    handle to tbKeluar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global serialKu
pilihan = questdlg('Ingin keluar dari aplikasi?', ...
    'Keluar Aplikasi','Ya', 'Tidak', 'Ya');
      switch pilihan
          case 'Ya'
              % pastikan menutup serial
              fclose(serialKu);              
              pause(0.5);
              delete(handles.figure1);              
          case 'Tidak'
              % batal keluar. kembalikan ke keadaan semula
              return;
      end
