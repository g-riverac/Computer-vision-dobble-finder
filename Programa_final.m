function varargout = Programa_final(varargin)
% Programa_final MATLAB code for Programa_final.fig
%      Programa_final, by itself, creates a new Programa_final or raises the existing
%      singleton*.
%
%      H = Programa_final returns the handle to a new Programa_final or the handle to
%      the existing singleton*.
%
%      Programa_final('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Programa_final.M with the given input arguments.
%
%      Programa_final('Property','Value',...) creates a new Programa_final or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Programa_final_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Programa_final_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Programa_final

% Last Modified by GUIDE v2.5 02-Jan-2021 15:52:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Programa_final_OpeningFcn, ...
                   'gui_OutputFcn',  @Programa_final_OutputFcn, ...
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


% --- Executes just before Programa_final is made visible.
function Programa_final_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Programa_final (see VARARGIN)

% Choose default command line output for Programa_final
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global xcentro ycentro radio ra2 ra captura guardar1 guardar2 imag2 imag3...
Irgb Mask_m Mask_m2 iconos  iconos2 ra1 ra2 resultado_comparacion Etiqueta seleccion1 seleccion2...
cargar1 cargar2 iconos2 carta1 carta2

Irgb=[];
Mask_m=[]; 
iconos=[]; 
Mask_m2=[]; 
iconos2=[];
carta1=[];
carta2=[];
ra1=[]; 
ra2=[]; 
resultado_comparacion=[];
Etiqueta=[];

captura=0;guardar1=0;guardar2=0;cargar1=0;cargar2=0;

xcentro=round(1900/2);
ycentro=round(1080/2);
radio=500;

imag1=zeros(2400,6000);
imag2=zeros(1080,1920);
imag3=zeros(1080,1100);

set(handles.axes1,'Units','pixels');
set(handles.axes2,'Units','pixels');
set(handles.axes4,'Units','pixels');
set(handles.axes5,'Units','pixels');

imshow(imag1,'Parent', handles.axes1)
imshow(imag2,'Parent', handles.axes2)
imshow(imag3,'Parent', handles.axes4)
imshow(imag3,'Parent', handles.axes7)
h = gca;
h.Visible = 'off';

set(handles.axes5,'Visible','off')
set(handles.pushbutton3,'Enable','off')
% set(handles.pushbutton4,'Enable','off')
set(handles.pushbutton5,'Enable','off')
% set(handles.pushbutton9,'Enable','off')
    


% UIWAIT makes Programa_final wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Programa_final_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global URL1 URL2 URL3 URL4 URL5 xcentro ycentro radio url imWidth imHeight

URL1=get(handles.edit1,'string');
URL2=get(handles.edit2,'string');
URL3=get(handles.edit3,'string');
URL4=get(handles.edit4,'string');
URL5=get(handles.edit5,'string');

st1='http://';
st2='.';
st3=':';
st4='/photo.jpg';


url = [st1 URL1 st2 URL2 st2 URL3 st2 URL4 st3 URL5 st4]; 

try
    % Some code that generates an error.

        cam=ipcam('http://192.168.0.16:8080/video','','', 'Timeout', 5);
        url = 'http://192.168.0.16:8080/photo.jpg';
        handles.output = hObject;
        handles.cam=cam;
        imWidth=1920;
        imHeight=1080;
        
        handles.hImage=image(zeros(imHeight,imWidth,3),'Parent',handles.axes1);
        preview(handles.cam, handles.hImage)
%         viscircles(handles.axes1,[xcentro ycentro], radio,'Color','b');
        guidata(hObject, handles)

    
catch ME
    message = sprintf('Error in blahblahblah():\n%s', ME.message);
    uiwait(warndlg(message));
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global url ra imWidth imHeight captura ra1 ra2 guardar1 guardar2
ra=imread(url); 
% ra=imresize(ra,0.2);
guardar1=0;

if (guardar1==0)
    imshow(ra, 'Parent', handles.axes2);
    imwrite(ra,'dobble_compara_1.jpg');
    ra1=ra;
    set(handles.pushbutton3,'Enable','on')
end

captura=1;


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global guardar1 guardar2 ra1 Irgb Mask_m iconos

guardar1=1;
set(handles.pushbutton3,'Enable','off')

[Irgb,Mask_m,Mask_m2,iconos,iconos2,carta1,carta2] = preprocesar(ra1);
imshow(carta1,'Parent', handles.axes4)
imshow(carta2,'Parent', handles.axes7)
if (guardar1==1 )
    set(handles.pushbutton5,'Enable','on')
end



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global guardar1 guardar2

guardar2=1;
set(handles.pushbutton4,'Enable','off')

if (guardar1==1 )
    set(handles.pushbutton5,'Enable','on')
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Irgb Mask_m iconos iconos2 ra1 ra2 resultado_comparacion Etiqueta Mask_m2 carta1 carta2

[resultado_comparacion,Etiqueta] = comparar(carta1,carta2,Mask_m,Mask_m2,iconos,iconos2);
imshow(resultado_comparacion, 'Parent', handles.axes5);
set(handles.text7,'String',Etiqueta);



% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global guardar1 guardar2 imag2 imag3 cargar1 cargar2 ra1 resultado_comparacion
guardar1=0;
cargar1=0;
imshow(imag2,'Parent', handles.axes2)
imshow(imag3,'Parent', handles.axes4)
imshow(imag3,'Parent', handles.axes7)
imshow(imag3,'Parent', handles.axes5)
set(handles.axes5,'Visible','off')
ra1=[];

resultado_comparacion=[];
h = gca;
h.Visible = 'off';
set(handles.pushbutton5,'Enable','off')
set(handles.pushbutton8,'Enable','on')
set(handles.pushbutton3,'Enable','on')
set(handles.text7,'String',' ');


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global guardar1 guardar2 imag2 imag3 cargar2 cargar1 ra2 resultado_comparacion
guardar2=0;
cargar2=0;
ra2=[];
resultado_comparacion=[];
imshow(imag3,'Parent', handles.axes4)
h = gca;
h.Visible = 'off';
set(handles.pushbutton5,'Enable','off')
set(handles.pushbutton9,'Enable','on')


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global seleccion1

posicion=get(hObject,'String');
sel1=posicion(get(hObject,'Value'));
seleccion1=sel1{1};

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global seleccion2

posicion=get(hObject,'String');
sel2=posicion(get(hObject,'Value'));
seleccion2=sel2{1};
% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global seleccion1 img_selec cargar1 ra1 cargar2 Irgb Mask_m Mask_m2 iconos iconos2...
    carta1 carta2

cargar1=1;
ra1=imread(seleccion1);
imshow(ra1,'Parent', handles.axes2)
h = gca;
h.Visible = 'off';
set(handles.pushbutton8,'Enable','off')
% set(handles.pushbutton9,'Enable','on')

[Irgb,Mask_m,Mask_m2,iconos,iconos2,carta1,carta2] = preprocesar(ra1);
imshow(carta1,'Parent', handles.axes4)
imshow(carta2,'Parent', handles.axes7)
if (cargar1==1 )
    set(handles.pushbutton5,'Enable','on')
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global seleccion2 cargar2 ra2 cargar1

cargar2=1;
ra2=imread(seleccion2);
imshow(ra2,'Parent', handles.axes4)
h = gca;
h.Visible = 'off';
set(handles.pushbutton9,'Enable','off')
if(cargar1==1 )
  set(handles.pushbutton5,'Enable','on')
end
