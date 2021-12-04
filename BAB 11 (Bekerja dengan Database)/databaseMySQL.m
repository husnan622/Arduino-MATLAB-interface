function varargout = databaseMySQL(varargin)
% DATABASEMYSQL MATLAB code for databaseMySQL.fig
%      DATABASEMYSQL, by itself, creates a new DATABASEMYSQL or raises the existing
%      singleton*.
%
%      H = DATABASEMYSQL returns the handle to a new DATABASEMYSQL or the handle to
%      the existing singleton*.
%
%      DATABASEMYSQL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATABASEMYSQL.M with the given input arguments.
%
%      DATABASEMYSQL('Property','Value',...) creates a new DATABASEMYSQL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before databaseMySQL_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to databaseMySQL_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help databaseMySQL

% Last Modified by GUIDE v2.5 23-Jul-2015 10:41:15
% Dibuat Oleh: I Nyoman Kusuma Wardana

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @databaseMySQL_OpeningFcn, ...
                   'gui_OutputFcn',  @databaseMySQL_OutputFcn, ...
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


% --- Executes just before databaseMySQL is made visible.
function databaseMySQL_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to databaseMySQL (see VARARGIN)

% Choose default command line output for databaseMySQL
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes databaseMySQL wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global plotGraph delay waktu data cacah lebarScroll min max
global state connState
% Deklarasikan properti grafik:
xLabel = 'Waktu (detik ke-)';         % x-axis label
yLabel = 'Data';                      % y-axis label
plotGrid = 'on';                      % aktifkan grid
min = 0;                              % minimum axis-y
max = 1;                              % maksimum axis-y
lebarScroll = 10;                     % display data pada grafik
delay = 3;                            % waktu cuplik
 
%Inisialisasi variabel data grafik dibuat nol semua
waktu = 0;
data = 0;
cacah = 0;

% Ubah tampilan grafik di awal GUI di-load
axes(handles.axes1);
plotGraph = plot(waktu,data,'--o',...
                'LineWidth',3,...
                'MarkerSize',8,...
                'MarkerEdgeColor','r',...
                'MarkerFaceColor','r');
% tampilkan tulisan pada axes             
xlabel(xLabel,'FontSize',12);
ylabel(yLabel,'FontSize',12);
% atur posisi sumbu-x dan sumbu-y
axis([0 10 min max]);
% aktifkan grid
grid(plotGrid);
% state = 1, maka ploting dimulai
state = 0;
% connState = 1, maka data dimasukkan ke database
connState = 0;


% --- Outputs from this function are returned to the command line.
function varargout = databaseMySQL_OutputFcn(hObject, eventdata, handles) 
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

global plotGraph delay waktu data cacah lebarScroll state min max 
global nilaiInput conn connState
% INI ADALAH TOMBOL ON
% aktifkan grafik
state = 1;
% deactive tombol ON
set(handles.tbON,'Enable','Off');
% aktifkan tombol Connect
set(handles.tbConnectDB,'Enable','On');
% mulai deteksi waktu
tic;
while(state==1)
    % input data berupa bilangan acak antara 0 dan 1
    nilaiInput = rand(1);  
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
    % sekarang, cek apakan tombolconnect ditekan? 
    if (connState == 1)
        % cek primary key saat ini (Kolom No)
        sqlSelect = 'SELECT datasensor.No FROM datasensor';
        sqlSelect = exec(conn,sqlSelect);
        % bawa ke workspace
        sqlSelect = fetch(sqlSelect);
        % ambil nomer terakhir
        NoInput = sqlSelect.Data{end};
        % apakah database kosong?
        cocokkan = strcmp(NoInput, 'No Data');
        if cocokkan == 1
            % jika ya, masukkan nomer = 0
            NoInput = 0;
            % jika tidak, maka biarkan saja
        end 
        % tambahkan nomer dengan 1, pastikan primary key unik
        NoInput = NoInput + 1;
        %insert data sensor ke database
        namaKolom = {'No','Data', 'Waktu'};
        % ambil nilai input = bilangan random
        % ambil waktu = detik saat ini
        dataMasuk = {NoInput, nilaiInput, waktu(cacah)};
        % masukkan ke database dgn perintah 'insert'
        insert(conn,'datasensor', namaKolom, dataMasuk);
        % tampilkan kembali data pada tabel
        sqlSelect = exec(conn,'SELECT * FROM datasensor');
        sqlSelect = fetch(sqlSelect);
        datasensor = [sqlSelect.Data];
        set(handles.uitable1,'data',datasensor);
    end
end


% --- Executes on button press in tbKeluar.
function tbKeluar_Callback(hObject, eventdata, handles)
% hObject    handle to tbKeluar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state conn
pilihan = questdlg('Ingin keluar dari aplikasi?', 'Keluar Aplikasi', ...
          'Ya', 'Tidak', 'Ya');
      switch pilihan
          case 'Ya'
              % pastikan state = 0, hapus aplikasi dan memori pd MATLAB
              state = 0;
              % tutup koneksi ke database
              close(conn);
              pause(0.5);
              delete(handles.figure1);
              % clear all;
          case 'Tidak'
              % batal keluar. kembalikan ke keadaan semula
              return;
      end

% --- Executes on button press in tbConnectDB.
function tbConnectDB_Callback(hObject, eventdata, handles)
% hObject    handle to tbConnectDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)\

global conn connState
% INI ADALAH TOMBOL CONNECT
% jika tombol state ditekan, maka lakukan koneksi ke database
conn = database('matlabDB', 'root', '');
% ubah status connState = 1, agar data mulai dimasukkan ke database
connState = 1;
% Atur penampakan tombol-tombol
set(handles.tbConnectDB,'Enable','Off');
set(handles.tbDisconnectDB,'Enable','On');
set(handles.tbKeluar,'Enable','Off');
set(handles.tbHapusDB,'Enable','Off');
set(handles.tbHapusSemuaDB,'Enable','Off');
set(handles.tbInsertDB,'Enable','Off');
set(handles.tbUpdateDB,'Enable','Off');



% --- Executes on button press in tbDisconnectDB.
function tbDisconnectDB_Callback(hObject, eventdata, handles)
% hObject    handle to tbDisconnectDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global connState

% INI ADALAH TOMBOL DISCONNECT
% hentikan pengiriman data ke database
connState=0;
% Atur penampakan tombol-tombol
set(handles.tbConnectDB,'Enable','On');
set(handles.tbDisconnectDB,'Enable','Off');
set(handles.tbKeluar,'Enable','On');
set(handles.tbHapusDB,'Enable','On');
set(handles.tbHapusSemuaDB,'Enable','On');
set(handles.tbInsertDB,'Enable','On');
set(handles.tbUpdateDB,'Enable','On');



function edKodeHapus_Callback(hObject, eventdata, handles)
% hObject    handle to edKodeHapus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edKodeHapus as text
%        str2double(get(hObject,'String')) returns contents of edKodeHapus as a double


% --- Executes during object creation, after setting all properties.
function edKodeHapus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edKodeHapus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tbHapusDB.
function tbHapusDB_Callback(hObject, eventdata, handles)
% hObject    handle to tbHapusDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global conn connState
connState = 0;
% INI ADALAH TOMBOL HAPUS
% ambil data yang akan dihapus
ambilKodeHapus = get(handles.edKodeHapus,'String');
sqlDel = ['Delete FROM datasensor WHERE No = ' ambilKodeHapus];
exec(conn,sqlDel);

%tampilkan kembali data pada tabel
sqlSelect = exec(conn,'SELECT * FROM datasensor');
sqlSelect = fetch(sqlSelect);
dataSensor = [sqlSelect.Data];
set(handles.uitable1,'data',dataSensor);


% --- Executes on button press in tbHapusSemuaDB.
function tbHapusSemuaDB_Callback(hObject, eventdata, handles)
% hObject    handle to tbHapusSemuaDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global conn connState
connState = 0;

% INI ADALAH TOMBOL HAPUS SEMUA
pause(0.3);
sqlDeleteAll = 'DELETE FROM datasensor';
exec(conn,sqlDeleteAll);
% tampilkan kembali data pada tabel
sqlSelect = exec(conn,'SELECT * FROM datasensor');
sqlSelect = fetch(sqlSelect);
dataSensor = [sqlSelect.Data];
set(handles.uitable1,'data',dataSensor);



function edNoInsert_Callback(hObject, eventdata, handles)
% hObject    handle to edNoInsert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edNoInsert as text
%        str2double(get(hObject,'String')) returns contents of edNoInsert as a double


% --- Executes during object creation, after setting all properties.
function edNoInsert_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edNoInsert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tbInsertDB.
function tbInsertDB_Callback(hObject, eventdata, handles)
% hObject    handle to tbInsertDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global conn connState
connState = 0;

% INI ADALAH TOMBOL INSERT
% ambil data No, Data, dan Waktu
ambilNo = get(handles.edNoInsert,'String');
ambilData = get(handles.edDataInsert,'String');
ambilWaktu = get(handles.edWaktuInsert,'String');
namaKolom = {'No','Data', 'Waktu'};
dataMasuk = {ambilNo, ambilData, ambilWaktu};
% eksekusi dengan sintaks 'insert'
insert(conn,'datasensor', namaKolom, dataMasuk);
%tampilkan kembali data pada tabel
sqlSelect = exec(conn,'SELECT * FROM datasensor');
sqlSelect = fetch(sqlSelect);
datasensor = [sqlSelect.Data];
set(handles.uitable1,'data',datasensor);


function edDataInsert_Callback(hObject, eventdata, handles)
% hObject    handle to edDataInsert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edDataInsert as text
%        str2double(get(hObject,'String')) returns contents of edDataInsert as a double


% --- Executes during object creation, after setting all properties.
function edDataInsert_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edDataInsert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edWaktuInsert_Callback(hObject, eventdata, handles)
% hObject    handle to edWaktuInsert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edWaktuInsert as text
%        str2double(get(hObject,'String')) returns contents of edWaktuInsert as a double


% --- Executes during object creation, after setting all properties.
function edWaktuInsert_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edWaktuInsert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edNoUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to edNoUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edNoUpdate as text
%        str2double(get(hObject,'String')) returns contents of edNoUpdate as a double


% --- Executes during object creation, after setting all properties.
function edNoUpdate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edNoUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tbUpdateDB.
function tbUpdateDB_Callback(hObject, eventdata, handles)
% hObject    handle to tbUpdateDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global conn connState
connState = 0;

% INI ADALAH TOMBOL UPDATE
% Ambil data yang mau di-update
ambilNO = str2double(get(handles.edNoUpdate,'String'));
ambilData = str2double(get(handles.edDataUpdate,'String'));
ambilWaktu = str2double(get(handles.edWaktuUpdate,'String'));
namaKolom = {'No','Data', 'Waktu'};
dataMasuk = {ambilNO, ambilData, num2str(ambilWaktu)};
sqlUpdate = ['WHERE No = ' num2str(ambilNO)];
% eksekusi dengan perintah 'update'
update(conn,'datasensor', namaKolom, dataMasuk, sqlUpdate)
%tampilkan data pada tabel
sqlSelect = exec(conn,'SELECT * FROM datasensor');
sqlSelect = fetch(sqlSelect);
datasensor = [sqlSelect.Data];
set(handles.uitable1,'data',datasensor);


function edDataUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to edDataUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edDataUpdate as text
%        str2double(get(hObject,'String')) returns contents of edDataUpdate as a double


% --- Executes during object creation, after setting all properties.
function edDataUpdate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edDataUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edWaktuUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to edWaktuUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edWaktuUpdate as text
%        str2double(get(hObject,'String')) returns contents of edWaktuUpdate as a double


% --- Executes during object creation, after setting all properties.
function edWaktuUpdate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edWaktuUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
