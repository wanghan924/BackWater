function varargout = BackW(varargin)
% BACKW MATLAB code for BackW.fig
%      BACKW, by itself, creates a new BACKW or raises the existing
%      singleton*.
%
%      H = BACKW returns the handle to a new BACKW or the handle to
%      the existing singleton*.
%
%      BACKW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BACKW.M with the given input arguments.
%
%      BACKW('Property','Value',...) creates a new BACKW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BackW_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BackW_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BackW

% Last Modified by GUIDE v2.5 12-Feb-2016 11:13:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @BackW_OpeningFcn, ...
    'gui_OutputFcn',  @BackW_OutputFcn, ...
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


% --- Executes just before BackW is made visible.
function BackW_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BackW (see VARARGIN)

% Choose default command line output for BackW
handles.output = hObject;
handles.output = hObject;
ha=axes('units','normalized','position',[0 0 1 1]);
uistack(ha,'down')
II=imread('river.jpg');
image(II)
colormap gray
set(ha,'handlevisibility','off','visible','off');
varargout{1} = handles.output;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BackW wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BackW_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hf
set(handles.uitable1,'Data',[]);
cla reset;

choose1=get(handles.radiobutton1,'Value');
choose2=get(handles.radiobutton2,'Value');
plot1=get(handles.radiobutton3,'Value');
plot2=get(handles.radiobutton4,'Value');
% if coa==1
%     flag='F';
% else
%     flag='C';
% end

b=str2num(get(handles.edit1,'string'));
h0=str2num(get(handles.edit2,'string'));
dx=str2num(get(handles.edit3,'string'));
Q=str2num(get(handles.edit4,'string'));
C=str2num(get(handles.edit5,'string'));
I=str2num(get(handles.edit6,'string'));
Nx=str2num(get(handles.edit7,'string'));

if isempty(b) | b<=0
    msgbox('Please input b again(b>0)!');
    return
end
if isempty(h0) | h0<=0
    msgbox('Please input h0 again(h0>0)!');
    return
end
if isempty(dx) | dx<=0
    msgbox('Please input dx again(dx>0)!');
    return
end

if isempty(Q) | Q<=0
    msgbox('Please input Q again(Q>0)!');
    return
end

if isempty(C) | C<=0
    msgbox('Please input C again(C>0)!!');
    return
end

if isempty(I) | I<=0 | I>=1
    msgbox('Please input I again(0<I<1)!');
    return
end
% normal depth
hN=Q^(2/3)/(b^(2/3)*C^(2/3)*I^(1/3));

if choose1==1 && plot1==1
    if isempty(Nx)  |  Nx-round(Nx)~=0
        msgbox('Nx must be a positive integer!');
        return
    end
    Distances(1)=0;
    Points(1)=0;
    Depths(1)=h0;
    for i=1:Nx
        Depths(i+1)=Depths(i)+dx*(Q^2/(C^2*Depths(i)^3*b^2)-I);
        Distances(i+1)=dx+Distances(i);
        Points(i+1)=Points(i)+1;
    end
    % calculate geodetical and piezometrical heights
    Geo_heights(1)=0;
    Piezo_heights(1)=Depths(1)+Geo_heights(1);
    for i=1:Nx
        Geo_heights(i+1)=I*Distances(i+1);
        Piezo_heights(i+1)=Geo_heights(i+1)+Depths(i+1);
    end
    set(handles.uitable1,'Data',[Points',Distances',Geo_heights',Depths',Piezo_heights']);
    axes(handles.axes1);
    plot(Distances,Piezo_heights,Distances,Geo_heights);
    title('Back Water Curve','Color','b');
    xlabel('distances(m)','Color','b');
    ylabel('water level(m)','Color','b');
    legend('water level','river bed','Location','southeast');
elseif choose2==1 && plot1==1
    Depths(1)=h0;
    Distances(1)=0;
    Points(1)=0;
    Geo_heights(1)=0;
    Piezo_heights(1)=Depths(1)+Geo_heights(1);
    hN=Q^(2/3)/(b^(2/3)*C^(2/3)*I^(1/3));
    if abs(h0-hN)<=0.001
        msgbox('Initial depth is normal wanter depth!');
        for i=1:10
            Points(i+1)=Points(i)+1;
            Distances(i+1)=Distances(i)+dx;
            Depths(i+1)=hN;
            Geo_heights(i+1)=I*Distances(i+1);
            Piezo_heights(i+1)=Geo_heights(i+1)+Depths(i+1);
        end
    else
        i=1;
        while abs(Depths(i)-hN)>=0.001
            Points(i+1)=Points(i)+1;
            Distances(i+1)=dx+Distances(i);
            Depths(i+1)=Depths(i)+dx*(Q^2/(C^2*Depths(i)^3*b^2)-I);
            Geo_heights(i+1)=I*Distances(i+1);
            Piezo_heights(i+1)=Geo_heights(i+1)+Depths(i+1);
            i=i+1;
        end
    end
    axes(handles.axes1);
    set(handles.edit7,'string',num2str(length(Points)-1));
    set(handles.uitable1,'Data',[Points',Distances',Geo_heights',Depths',Piezo_heights']);
    plot(Distances,Piezo_heights,Distances,Geo_heights);
    title('Back Water Curve','Color','b');
    xlabel('distances(m)','Color','b');
    ylabel('water level(m)','Color','b');
    legend('water level','river bed','Location','southeast');
elseif choose1==1 && plot2==1
    if isempty(Nx)  |  Nx-round(Nx)~=0
        msgbox('Nx must be a positive integer!');
        return
    end
    Distances(1)=0;
    Points(1)=0;
    Depths(1)=h0;
    for i=1:Nx
        Depths(i+1)=Depths(i)+dx*(Q^2/(C^2*Depths(i)^3*b^2)-I);
        Distances(i+1)=dx+Distances(i);
        Points(i+1)=Points(i)+1;
    end
    % calculate geodetical and piezometrical heights
    Geo_heights(1)=0;
    Piezo_heights(1)=Depths(1)+Geo_heights(1);
    for i=1:Nx
        Geo_heights(i+1)=I*Distances(i+1);
        Piezo_heights(i+1)=Geo_heights(i+1)+Depths(i+1);
    end
    set(handles.uitable1,'Data',[Points',Distances',Geo_heights',Depths',Piezo_heights']);
    axes(handles.axes1);
    plot(Distances,Piezo_heights,Distances,Geo_heights);
    title('Back Water Curve','Color','b');
    xlabel('distances(m)','Color','b');
    ylabel('water level(m)','Color','b');
    legend('water level','river bed','Location','southeast');
    hold on
    p=plot(Distances(1),Piezo_heights(1),'o','MarkerFaceColor','red');
    hold off
    axis manual
    %These lines updates the graph
    for k=2:Nx
       p.XData=Distances(k);
       p.YData=Piezo_heights(k);
        drawnow
    end
elseif choose2==1 && plot2==1
    Depths(1)=h0;
    Distances(1)=0;
    Points(1)=0;
    Geo_heights(1)=0;
    Piezo_heights(1)=Depths(1)+Geo_heights(1);
    hN=Q^(2/3)/(b^(2/3)*C^(2/3)*I^(1/3));
    if abs(h0-hN)<=0.001
        msgbox('Initial depth is normal wanter depth!');
        for i=1:10
            Points(i+1)=Points(i)+1;
            Distances(i+1)=Distances(i)+dx;
            Depths(i+1)=hN;
            Geo_heights(i+1)=I*Distances(i+1);
            Piezo_heights(i+1)=Geo_heights(i+1)+Depths(i+1);
        end
    else
        i=1;
        while abs(Depths(i)-hN)>=0.001
            Points(i+1)=Points(i)+1;
            Distances(i+1)=dx+Distances(i);
            Depths(i+1)=Depths(i)+dx*(Q^2/(C^2*Depths(i)^3*b^2)-I);
            Geo_heights(i+1)=I*Distances(i+1);
            Piezo_heights(i+1)=Geo_heights(i+1)+Depths(i+1);
            i=i+1;
        end
    end
    axes(handles.axes1);
    title('Back Water Curve','Color','b');
    xlabel('distances(m)','Color','b');
    ylabel('water level(m)','Color','b');
    legend('water level','river bed','Location','southeast');
    set(handles.edit7,'string',num2str(length(Points)-1));
    set(handles.uitable1,'Data',[Points',Distances',Geo_heights',Depths',Piezo_heights']);
    plot(Distances,Piezo_heights,Distances,Geo_heights);
    hold on
    p=plot(Distances(1),Piezo_heights(1),'o','MarkerFaceColor','b');
    hold off
    axis manual
    %These lines updates the graph
    for k=2:i
       p.XData=Distances(k);
       p.YData=Piezo_heights(k);
       drawnow
    end
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[f,p]=uiputfile({'*.jpg'},'save figure');
if f==0
    return;
else
    str=strcat(p,f);
    pix=getframe(handles.axes1);
    imwrite(pix.cdata,str,'jpg')
end



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Filename,Pathname]=uiputfile({'*.txt'},'Select Data');
if (Filename~=0)
    filepath=[Pathname,'\',Filename];
else
    return
end

table=get(handles.uitable1,'Data');
f=fopen(filepath,'w+');
fprintf(f,'%s\r\n','Points    Disatances    Depths  Geo_heights  Piezo_heights');
fprintf(f,'%4d\t%6.3f\t%6.4f\t%6.4f\t\t%6.4f\r\n',table');
fclose(f);



% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2



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



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Filename,Pathname]=uigetfile({'*.txt'},'Select Data');
if (Filename~=0)
    filepath=[Pathname,'\',Filename];
else
   return
end

inputfile=importdata(filepath);
i=1;
while inputfile{2,1}(i)~=' '
    num1(i)=inputfile{2,1}(i);
    i=i+1;
end
set(handles.edit1,'string',num1);

i=1;
while inputfile{3,1}(i)~=' '
    num2(i)=inputfile{3,1}(i);
    i=i+1;
end
set(handles.edit2,'string',num2);
i=1;
while inputfile{4,1}(i)~=' '
    num3(i)=inputfile{4,1}(i);
    i=i+1;
end
set(handles.edit3,'string',num3)
i=1;
while inputfile{5,1}(i)~=' '
    num4(i)=inputfile{5,1}(i);
    i=i+1;
end
set(handles.edit4,'string',num4);
i=1;
while inputfile{6,1}(i)~=' '
    num5(i)=inputfile{6,1}(i);
    i=i+1;
end
set(handles.edit5,'string',num5);
i=1;
while inputfile{7,1}(i)~=' '
    num6(i)=inputfile{7,1}(i);
    i=i+1;
end
set(handles.edit6,'string',num6);

i=1;
while inputfile{8,1}(i)~=' '
    DD1(i)=inputfile{8,1}(i);
    i=i+1;
end

if DD1=='F'
    i=1;
 while inputfile{9,1}(i)~=' '
     num7(i)=inputfile{9,1}(i);
     i=i+1;
 end
 set(handles.edit7,'string',num7);
end
% [Fn] = uigetfile({'*.inp', 'Input parameters file'; '*.*', 'All Files'}, 'Select input file');
% data=importdata(Fn);
% b=sscanf(data{2},'%d');
% set(handles.edit1,'String',b);
% h0=sscanf(data{3},'%d');
% set(handles.edit2,'String',h0);
% dx=sscanf(data{4},'%d');
% set(handles.edit3,'String',dx);
% Q=sscanf(data{5},'%d');
% set(handles.edit4,'String',Q);
% C=sscanf(data{6},'%d');
% set(handles.edit5,'String',C);
% I=sscanf(data{7},'%f');
% set(handles.edit6,'String',I);

% if flag=='F'
% Nx=sscanf(data{8},'%f');
% set(handles.edit7,'String',Nx);
% else
%     Nx=i;
%     set(handles.edit7,'String',Nx);
% end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
