function varargout = stepperGUI(varargin)
% STEPPERGUI MATLAB code for stepperGUI.fig
%      STEPPERGUI, by itself, creates a new STEPPERGUI or raises the existing
%      singleton*.
%
%      H = STEPPERGUI returns the handle to a new STEPPERGUI or the handle to
%      the existing singleton*.
%
%      STEPPERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STEPPERGUI.M with the given input arguments.
%
%      STEPPERGUI('Property','Value',...) creates a new STEPPERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stepperGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stepperGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stepperGUI

% Last Modified by GUIDE v2.5 14-Sep-2015 00:43:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stepperGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @stepperGUI_OutputFcn, ...
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


% --- Executes just before stepperGUI is made visible.
function stepperGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stepperGUI (see VARARGIN)

% Choose default command line output for stepperGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stepperGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stepperGUI_OutputFcn(hObject, eventdata, handles) 
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
global s1;
set(handles.tbON,'Enable','off');
s1 = serial('COM33');   
s1.BaudRate = 9600;
fopen(s1);             
set(handles.tbConnect,'Enable','on'); 
set(handles.textStatus,'String','Terkoneksi!');

% --- Executes on button press in tbConnect.
function tbConnect_Callback(hObject, eventdata, handles)
% hObject    handle to tbConnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global s1;
fwrite(s1,'y');
set(handles.tbConnect,'Enable','off'); 
set(handles.tbDisconnect,'Enable','on');
set(handles.tbForward,'Enable','on'); 
set(handles.tbBackward,'Enable','on');
set(handles.slKecepatan,'Enable','on');
set(handles.tbKeluar,'Enable','off');


% --- Executes on button press in tbDisconnect.
function tbDisconnect_Callback(hObject, eventdata, handles)
% hObject    handle to tbDisconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global s1;
fwrite(s1,'x');
set(handles.tbConnect,'Enable','on'); 
set(handles.tbDisconnect,'Enable','off');
set(handles.tbForward,'Enable','off'); 
set(handles.tbBackward,'Enable','off');
set(handles.slKecepatan,'Enable','off');
set(handles.tbKeluar,'Enable','on');


% --- Executes on button press in tbForward.
function tbForward_Callback(hObject, eventdata, handles)
% hObject    handle to tbForward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global s1;
fwrite(s1,'f');
set(handles.tbForward,'Enable','off'); 
set(handles.tbBackward,'Enable','on');


% --- Executes on button press in tbBackward.
function tbBackward_Callback(hObject, eventdata, handles)
% hObject    handle to tbBackward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global s1;
fwrite(s1,'b');
set(handles.tbForward,'Enable','on'); 
set(handles.tbBackward,'Enable','off');

% --- Executes on slider movement.
function slKecepatan_Callback(hObject, eventdata, handles)
% hObject    handle to slKecepatan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global s1;
nilai = get(handles.slKecepatan,'Value');
nilai = round(nilai);
nilai = num2str(nilai);
awal = 'a';
akhir = 'o';

sendData = [awal nilai akhir];
disp(sendData);

fwrite(s1, sendData);
set(handles.textKecepatan,'String',nilai)


% --- Executes during object creation, after setting all properties.
function slKecepatan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slKecepatan (see GCBO)
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
global s1;
pilihan = questdlg('Ingin keluar dari aplikasi?', ...
    'Keluar Aplikasi','Ya', 'Tidak', 'Ya');
      switch pilihan
          case 'Ya'              
              fclose(s1);
              delete(handles.figure1);
              close all;
              clear all;
          case 'Tidak'
              % batal keluar. kembalikan ke keadaan semula
              return;
      end
