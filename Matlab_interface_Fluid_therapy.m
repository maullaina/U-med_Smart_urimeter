function varargout = INTERFACE_FINAL(varargin)
% INTERFACE_FINAL MATLAB code for INTERFACE_FINAL.fig
%      INTERFACE_FINAL, by itself, creates a new INTERFACE_FINAL or raises the existing
%      singleton*.
%
%      H = INTERFACE_FINAL returns the handle to a new INTERFACE_FINAL or the handle to
%      the existing singleton*.
%
%      INTERFACE_FINAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE_FINAL.M with the given input arguments.
%
%      INTERFACE_FINAL('Property','Value',...) creates a new INTERFACE_FINAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before INTERFACE_FINAL_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to INTERFACE_FINAL_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help INTERFACE_FINAL

% Last Modified by GUIDE v2.5 25-Nov-2019 12:53:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @INTERFACE_FINAL_OpeningFcn, ...
                   'gui_OutputFcn',  @INTERFACE_FINAL_OutputFcn, ...
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


% --- Executes just before INTERFACE_FINAL is made visible.
function INTERFACE_FINAL_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to INTERFACE_FINAL (see VARARGIN)

 set ( gcf, 'Color', 'white' );

 logo = imread('ucloud.jpg');
 axes(handles.logo);
 imshow(logo);
 
 scale = imread('scale.png');
 axes(handles.scale);
 imshow(scale);
 
 greysq = imread('greysquare.jpg');
 axes(handles.startstop);
 imshow(greysq);
 
 greysq = imread('greysquare.jpg');
 axes(handles.alarmled);
 imshow(greysq);
 
 serumvalue = [];
 assignin('base','serumvalue',serumvalue);
 
 drugvalue = [];
 assignin('base','drugvalue',drugvalue);
 
 drinkvalue = [];
 assignin('base','drinkvalue',drinkvalue);
 
 extravalue = [];
 assignin('base','extravalue',extravalue);
 
 insensiblevalue = [];
 assignin('base','insensiblevalue',insensiblevalue);
 
% Choose default command line output for INTERFACE_FINAL
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes INTERFACE_FINAL wait for user response (see UIRESUME)
% uiwait(handles.emptyled);


% --- Outputs from this function are returned to the command line.
function varargout = INTERFACE_FINAL_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)
% hObject    handle to startbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Verification

greenled = imread('greensquare.png');
axes(handles.startstop);
imshow(greenled);
% global a;
clear my_arduino
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end

a = serial('COM7');%check COM in your computer
fopen(a);
vol=0;
sensor_out_decision=2;
pos=1;
vect_vol =zeros(1,linspace(1,24,1));

count = 0;


for j = 1:24 % TOT UN DIA
    tic
    while (toc<3600) %temps per medició UNA HORA
      sensor_out=fscanf(a,'D2');
        count = count + 1;
        display(sensor_out)
        vol=vol+15;
        sensor_out_decision = sensor_out;
        pause(1);
    end
    
    count = 0;
    vect_vol(pos)=vol;
    assignin('base','vect_vol',vect_vol)
    %alarms_u_med(vect_vol,pos);%msg box de com es troba de diuresi
    vol=0;
    pos=pos+1;
%     hold on;
%     bar(vect_vol);%el volem representant-se contantment en la interface
%     drawnow; % force MATLAB to flush any queued displays
%     pause(1);
end

%vect_vol = randi([70,100],1,24);
%assignin('base','vect_vol',vect_vol);
%pos = 24;

axes(handles.histogram);
bar(vect_vol);
xlabel('1h time slots', 'FontSize', 10);
ylabel('Volume (mL)', 'FontSize', 10);


result = alarms_u_med(vect_vol,pos); %msg box de com es troba de diuresi
if result == 3
    redled = imread('redsquare.jpg');
    axes(handles.alarmled);
    imshow(redled);
end

if result == 2
    yellowled = imread('yellowsquare.jpg');
    axes(handles.alarmled);
    imshow(yellowled);
end

if result == 4
    yellowled = imread('yellowsquare.jpg');
    axes(handles.alarmled);
    imshow(yellowled);
end

if result == 6
    yellowled = imread('yellowsquare.jpg');
    axes(handles.alarmled);
    imshow(yellowled);
end

if result == 5
    redled = imread('redsquare.jpg');
    axes(handles.alarmled);
    imshow(redled);
end

if result == 1
    greenled = imread('greensquare.jpg');
    axes(handles.alarmled);
    imshow(greenled);
end

%fclose(serial_port);

% --- Executes on button press in stopbutton.
function stopbutton_Callback(hObject, eventdata, handles)
% hObject    handle to stopbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

redled = imread('redsquare.jpg');
axes(handles.startstop);
imshow(redled);


% --- Executes on button press in pausebutton.
function pausebutton_Callback(hObject, eventdata, handles)
% hObject    handle to pausebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in emptybutton.
function emptybutton_Callback(hObject, eventdata, handles)
% hObject    handle to emptybutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function editserum_Callback(hObject, eventdata, handles)
% hObject    handle to editserum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editserum as text
%        str2double(get(hObject,'String')) returns contents of editserum as a double


% --- Executes during object creation, after setting all properties.
function editserum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editserum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editdrug_Callback(hObject, eventdata, handles)
% hObject    handle to editdrug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editdrug as text
%        str2double(get(hObject,'String')) returns contents of editdrug as a double


% --- Executes during object creation, after setting all properties.
function editdrug_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editdrug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editdrink_Callback(hObject, eventdata, handles)
% hObject    handle to editdrink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editdrink as text
%        str2double(get(hObject,'String')) returns contents of editdrink as a double


% --- Executes during object creation, after setting all properties.
function editdrink_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editdrink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fluidtherapybutton.
function fluidtherapybutton_Callback(hObject, eventdata, handles)
% hObject    handle to fluidtherapybutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a = get(hObject,'Value');
vect_vol = evalin('base', 'vect_vol');
vect_serum = evalin('base', 'serumvalue');
vect_drug = evalin('base', 'drugvalue');
vect_foodintake = evalin('base', 'drinkvalue');
vect_extraord = evalin('base', 'extravalue');
vect_insens = evalin('base', 'insensiblevalue');

if a == 1
    try
        fluidtherapy_u_med(vect_vol, vect_serum, vect_drug, vect_foodintake, vect_extraord, vect_insens);
    catch 
       msgbox('No diuresis data to compute fluid therapy.','Altert');
    end
end




function editextra_Callback(hObject, eventdata, handles)
% hObject    handle to editextra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editextra as text
%        str2double(get(hObject,'String')) returns contents of editextra as a double


% --- Executes during object creation, after setting all properties.
function editextra_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editextra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editinsensible_Callback(hObject, eventdata, handles)
% hObject    handle to editinsensible (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editinsensible as text
%        str2double(get(hObject,'String')) returns contents of editinsensible as a double


% --- Executes during object creation, after setting all properties.
function editinsensible_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editinsensible (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in enter.
function enter_Callback(hObject, eventdata, handles)
% hObject    handle to enter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


serumvalue = (str2double(get(handles.editserum,'String')));
if isnan (serumvalue)
    errordlg('You must enter numeric values','Invalid Input','modal')
else
    serumvalue = evalin('base', 'serumvalue');
    serumvalue = [serumvalue (str2double(get(handles.editserum,'String')))];
    assignin('base','serumvalue',serumvalue);
end

drugvalue = (str2double(get(handles.editserum,'String')));
if isnan (drugvalue)
    errordlg('You must enter numeric values','Invalid Input','modal')
else
    drugvalue = evalin('base', 'drugvalue');
    drugvalue = [drugvalue (str2double(get(handles.editdrug,'String')))];
    assignin('base','drugvalue',drugvalue);
end

drinkvalue = (str2double(get(handles.editserum,'String')));
if isnan (drinkvalue)
    errordlg('You must enter numeric values','Invalid Input','modal')
else
    drinkvalue = evalin('base', 'drinkvalue');
    drinkvalue = [drinkvalue (str2double(get(handles.editdrink,'String')))];
    assignin('base','drinkvalue',drinkvalue);
end

extravalue = (str2double(get(handles.editserum,'String')));
if isnan (extravalue)
    errordlg('You must enter numeric values','Invalid Input','modal')
else
    extravalue = evalin('base', 'extravalue');
    extravalue = [extravalue (str2double(get(handles.editextra,'String')))];
    assignin('base','extravalue',extravalue);
end

insensiblevalue = (str2double(get(handles.editinsensible,'String')));
if isnan (insensiblevalue)
    errordlg('You must enter numeric values','Invalid Input','modal')
else
    assignin('base','insensiblevalue',insensiblevalue);
end
