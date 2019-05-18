function varargout = PRAROB_gui(varargin)
% PRAROB_GUI MATLAB code for PRAROB_gui.fig
%      PRAROB_GUI, by itself, creates a new PRAROB_GUI or raises the existing
%      singleton*.
%
%      H = PRAROB_GUI returns the handle to a new PRAROB_GUI or the handle to
%      the existing singleton*.
%
%      PRAROB_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PRAROB_GUI.M with the given input arguments.
%
%      PRAROB_GUI('Property','Value',...) creates a new PRAROB_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PRAROB_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PRAROB_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PRAROB_gui

% Last Modified by GUIDE v2.5 21-May-2018 16:39:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PRAROB_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @PRAROB_gui_OutputFcn, ...
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


% --- Executes just before PRAROB_gui is made visible.
function PRAROB_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PRAROB_gui (see VARARGIN)

% Choose default command line output for PRAROB_gui
handles.output = hObject;

handles.img = img_capture(10);
%handles.img = imread('ideal2.PNG');
axes(handles.workspace);
hold on
grid on
%handles.img = imread('ideal_visemanje.PNG');
[handles.radni_prostor handles.rad_obj handles.drop_prostor handles.drop_obj]=PRAROB_imgprocess(handles.img);

set(handles.workspace,'Xlim',[-180 180],'Ylim',[-10 230]);
rectangle('Position',handles.radni_prostor(1).BoundingBox,'EdgeColor','r','LineWidth',2);
rectangle('Position',handles.drop_prostor(1).BoundingBox,'EdgeColor','b','LineWidth',2);
plot(handles.workspace,0,0,'og');

for object =1:length(handles.rad_obj)
    handles.rad_obj(object).Centroid(1)=handles.rad_obj(object).Centroid(1);
    handles.rad_obj(object).Centroid(2)=handles.rad_obj(object).Centroid(2);
    plot(handles.workspace,handles.rad_obj(object).Centroid(1),handles.rad_obj(object).Centroid(2),'-m+');
    viscircles([handles.rad_obj(object).Centroid(1) handles.rad_obj(object).Centroid(2)],8,'LineWidth',1,'Color','g');
    txt_w=strcat('Drop zone(',num2str(object),')');
    text(handles.rad_obj(object).Centroid(1)+10,handles.rad_obj(object).Centroid(2)+10,txt_w,'FontSize',10);
end

for object =1:length(handles.drop_obj)
    handles.drop_obj(object).Centroid(1)=handles.drop_obj(object).Centroid(1);
    handles.drop_obj(object).Centroid(2)=handles.drop_obj(object).Centroid(2);
    plot(handles.workspace,handles.drop_obj(object).Centroid(1),handles.drop_obj(object).Centroid(2), '-m+');
    viscircles([handles.drop_obj(object).Centroid(1) handles.drop_obj(object).Centroid(2)],8,'LineWidth',1,'Color','g');    
    txt_d=strcat('Work object(',num2str(object),')');    
    text(handles.drop_obj(object).Centroid(1)+10,handles.drop_obj(object).Centroid(2)+10,txt_d,'FontSize',10);
end

for object = 1:length(handles.drop_obj)
    plot(handles.workspace,handles.rad_obj(object).Centroid(1),handles.rad_obj(object).Centroid(2),'-m+');
    plot(handles.workspace,handles.drop_obj(object).Centroid(1),handles.drop_obj(object).Centroid(2), '-m+');
    viscircles([handles.rad_obj(object).Centroid(1) handles.rad_obj(object).Centroid(2)],8,'LineWidth',1,'Color','g');
    viscircles([handles.drop_obj(object).Centroid(1) handles.drop_obj(object).Centroid(2)],8,'LineWidth',1,'Color','g');
    txt_w=strcat('Drop zone(',num2str(object),')');
    txt_d=strcat('Work object(',num2str(object),')');
    text(handles.rad_obj(object).Centroid(1)+10,handles.rad_obj(object).Centroid(2)+10,txt_w,'FontSize',10);
    text(handles.drop_obj(object).Centroid(1)+10,handles.drop_obj(object).Centroid(2)+10,txt_d,'FontSize',10);
end    
hold off

DISP_str=['Detected: ' newline 'Objects: ' num2str(length(handles.rad_obj)) newline 'Drop locations: ' num2str(length(handles.drop_obj)) newline '...'];
set(handles.DISP,'String',DISP_str);
guidata(hObject, handles);

% UIWAIT makes PRAROB_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PRAROB_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in RUN.
function RUN_Callback(hObject, eventdata, handles)
% hObject    handle to RUN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDAsetTA)
DISP_str=['RUN executed' newline '...'];
    set(handles.DISP,'String',DISP_str);
    handles.man_loop = false;
    guidata(hObject, handles);
    if get(handles.radiobutton1, 'Value')
        DISP_str=['MANUAL RUN executed' newline '...'];
%         DISP_TOOL_str=['TOOL Status: running' newline 
%                 'X: ' num2str(X_enc) ' Y: ' num2str(Y_enc) ' Z: ' num2str(Z_enc) newline
%                 'theta1: ' num2str(t1_enc) ' theta2: ' num2str(t2_enc) ' l0: ' num2str(l0_enc)];
%         set(handles.DISP_TOOL,'String',DISP_TOOL_str);
        set(handles.DISP,'String',DISP_str);
        drawnow limitrate;
        X_man=str2num(get(handles.X_man,'String'))*0.1;
        Y_man=str2num(get(handles.Y_man,'String'))*0.1;
        Z_man=str2num(get(handles.Z_man,'String'))*0.1;
       
        DISP_str=['MANUAL RUN executed' newline '...' newline num2str(X_man) ' ' num2str(Y_man) ' ' num2str(Z_man)];
        set(handles.DISP,'String',DISP_str);
        drawnow limitrate;
        set_param('ROKI_3/ROKI_ALL/x','Value',num2str(X_man));
        set_param('ROKI_3/ROKI_ALL/y','Value',num2str(Y_man));
        set_param('ROKI_3/ROKI_ALL/z','Value',num2str(Z_man));
        pause(2);
%         while get_param('ROKI_3/ROKI_ALL/Mode','Value')==10
%             X_enc=get_param('ROKI_3/ROKI_ALL/x_enc','Value'0);
%             Y_enc=get_param('ROKI_3/ROKI_ALL/x_enc','Value');
%             Z_enc=get_param('ROKI_3/ROKI_ALL/x_enc','Value');
%             t1_enc=get_param('ROKI_3/ROKI_ALL/x_enc','Value');
%             t2_enc=get_param('ROKI_3/ROKI_ALL/x_enc','Value');
%             l0_enc=get_param('ROKI_3/ROKI_ALL/x_enc','Value');
%             DISP_TOOL_str=['TOOL Status: running' newline 
%                 'X: ' num2str(X_enc) ' Y: ' num2str(Y_enc) ' Z: ' num2str(Z_enc) newline
%                 'theta1: ' num2str(t1_enc) ' theta2: ' num2str(t2_enc) ' l0: ' num2str(l0_enc)];
%             set(handles.DISP_TOOL,'String',DISP_TOOL_str);
%             drawnow limitrate;
%         end
        
        DISP_str=[DISP_str ' complete' ];
%         DISP_TOOL_str=['TOOL Status: stopped' newline 
%                 'X: ' num2str(X_enc) ' Y: ' num2str(Y_enc) ' Z: ' num2str(Z_enc) newline
%                 'theta1: ' num2str(t1_enc) ' theta2: ' num2str(t2_enc) ' l0: ' num2str(l0_enc)];
%         set(handles.DISP_TOOL,'String',DISP_TOOL_str);
        set(handles.DISP,'String',DISP_str);
        drawnow limitrate;
        guidata(hObject, handles);
        pause(1);
        radiobutton1_Callback(handles.radiobutton1, eventdata, handles);
    end
    if get(handles.radiobutton2, 'Value')
        DISP_str=['AUTOMATIC RUN executed' newline '...'];
        set(handles.DISP,'String',DISP_str);
        drawnow limitrate;
        for object=1:length(handles.drop_obj)
            %raise
            X_aut=0;
            Y_aut=0;
            Z_aut=5;       
            DISP_str=['AUTOMATIC RUN executed' newline '...' newline num2str(X_aut) ' ' num2str(Y_aut) ' ' num2str(Z_aut) newline];
            set_param('ROKI_3/ROKI_ALL/z', 'Value' , '5.2');
            drawnow limitrate;
            pause(1);
            
            %go
            drop_indexx=handles.drop_index(object);
            X_aut=-handles.drop_obj(object).Centroid(1)*0.1;
            Y_aut=handles.drop_obj(object).Centroid(2)*0.1;
           
            Z_aut=10;       
            DISP_str=['AUTOMATIC RUN executed' newline '...' newline num2str(X_aut) ' ' num2str(Y_aut) ' ' num2str(Z_aut) newline];
            set(handles.DISP,'String',DISP_str);
            drawnow limitrate;
            set_param('ROKI_3/ROKI_ALL/x', 'Value' , num2str(X_aut));set_param('ROKI_3/ROKI_ALL/y', 'Value' , num2str(Y_aut));
            pause(1);
            
            
            
            %lower
           
            Z_aut=0;      
            DISP_str=['AUTOMATIC RUN executed' newline '...' newline num2str(X_aut) ' ' num2str(Y_aut) ' ' num2str(Z_aut) newline];
            set(handles.DISP,'String',DISP_str);
            drawnow limitrate;
            set_param('ROKI_3/ROKI_ALL/z', 'Value' , '0');
            pause(4);
           
            
            %raise
            X_aut=-handles.rad_obj(object).Centroid(1)*0.1;
            Y_aut=handles.rad_obj(object).Centroid(2)*0.1;
            Z_aut=10;       
            DISP_str=['AUTOMATIC RUN executed' newline '...' newline num2str(X_aut) ' ' num2str(Y_aut) ' ' num2str(Z_aut) newline];
            set(handles.DISP,'String',DISP_str);
            drawnow limitrate;
            set_param('ROKI_3/ROKI_ALL/z', 'Value' , '4.9');
            pause(3);
            
            %deliver
            drop_indexx=handles.drop_index(object);
            X_aut=-handles.rad_obj(drop_indexx).Centroid(1)*0.1;
            Y_aut=handles.rad_obj(drop_indexx).Centroid(2)*0.1;
            Z_aut=10;       
            DISP_str=['AUTOMATIC RUN executed' newline '...' newline num2str(X_aut) ' ' num2str(Y_aut) ' ' num2str(Z_aut) newline];
            set(handles.DISP,'String',DISP_str);
            set_param('ROKI_3/ROKI_ALL/x', 'Value' , num2str(X_aut));set_param('ROKI_3/ROKI_ALL/y', 'Value' , num2str(Y_aut));
            drawnow limitrate;
            pause(1);
            
            %lower
         
            DISP_str=['AUTOMATIC RUN executed' newline '...' newline num2str(X_aut) ' ' num2str(Y_aut) ' ' num2str(Z_aut) newline];
            set(handles.DISP,'String',DISP_str);
            drawnow limitrate;
            set_param('ROKI_3/ROKI_ALL/z', 'Value' , '0');
            pause(4);
            
        end
        guidata(hObject, handles);
        pause(1);
        radiobutton2_Callback(handles.radiobutton2, eventdata, handles);
    end
% --- Executes on button press in STOP.
function STOP_Callback(hObject, eventdata, handles)
% hObject    handle to STOP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function X_man_Callback(hObject, eventdata, handles)
% hObject    handle to X_man (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of X_man as text
%        str2double(get(hObject,'String')) returns contents of X_man as a double


% --- Executes during object creation, after setting all properties.
function X_man_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X_man (see GCBO)
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



function Y_man_Callback(hObject, eventdata, handles)
% hObject    handle to Y_man (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Y_man as text
%        str2double(get(hObject,'String')) returns contents of Y_man as a double


% --- Executes during object creation, after setting all properties.
function Y_man_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Y_man (see GCBO)
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


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value')
    DISP_str=['Automatic mode selected' newline '...loading'];
    set(handles.DISP,'String',DISP_str);
    guidata(hObject, handles);   
    DISP_str=['Automatic mode selected' newline 'Detected pairings: ' newline];
   
    for object=1:length(handles.drop_obj)
        handles.drop_index(object)=PRAROB_analyze_shape(handles.img,object);
        DISP_str=[DISP_str 'Object: ' num2str(object) ' ==> drop location: ' num2str(handles.drop_index(object)) newline];       
    end
set(handles.DISP,'String',DISP_str);
guidata(hObject, handles);
end    
% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
%  if handles.loopflag
%      return;
%  end
if get(hObject,'Value')
    DISP_str=['Manual mode selected' newline 'select point...'];
    set(handles.DISP,'String',DISP_str);
    handles.man_loop = true;
    guidata(hObject, handles);
%while handles.man_loop
    X_man=get(handles.X_man,'String');
    Y_man=get(handles.Y_man,'String');
    DISP_str=['Manual mode selected' newline 'select point...' newline X_man ' ' Y_man];
    set(handles.DISP,'String',DISP_str);
    drawnow limitrate;
%     if get(handles.RUN, 'Value')
%         handles.man_loop = false;
%     end
    guidata(hObject, handles);
%end
%guidata(hObject, handles);
end
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes during object creation, after setting all properties.
function DISP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DISP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function Z_man_Callback(hObject, eventdata, handles)
% hObject    handle to Z_man (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Z_man as text
%        str2double(get(hObject,'String')) returns contents of Z_man as a double


% --- Executes during object creation, after setting all properties.
function Z_man_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Z_man (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
