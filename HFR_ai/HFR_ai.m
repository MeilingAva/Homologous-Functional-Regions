function varargout = HFR_ai(varargin)
% HFR_AI MATLAB code for HFR_ai.fig
%      HFR_AI, by itself, creates a new HFR_AI or raises the existing
%      singleton*.
%
%      H = HFR_AI returns the handle to a new HFR_AI or the handle to
%      the existing singleton*.
%
%      HFR_AI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HFR_AI.M with the given input arguments.
%
%      HFR_AI('Property','Value',...) creates a new HFR_AI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HFR_ai_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HFR_ai_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HFR_ai

% Last Modified by GUIDE v2.5 31-May-2017 15:56:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HFR_ai_OpeningFcn, ...
                   'gui_OutputFcn',  @HFR_ai_OutputFcn, ...
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


% --- Executes just before HFR_ai is made visible.
function HFR_ai_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HFR_ai (see VARARGIN)

% Choose default command line output for HFR_ai

Release = 'V1.0-beta-20190308';
fprintf('--------------------------------------------------------------------------------------------------------------------\n');
fprintf('HFR_ai: a toolbox for finding Homologous Functional Regions Across Individuals.\nRelease = %s\n',Release);
fprintf('<a href="http://nmr.mgh.harvard.edu/bid/">Laboratory for the Study of the Brain Basis of Individual Difference</a>\n');
fprintf('Mail to Initiator: Hesheng Liu (hesheng@nmr.mgh.harvard.edu)\n');
fprintf('Programmers: Meiling Li, Danhong Wang\n');
fprintf('Citing Information:\nIf you think HFR_ai is useful for your work, citing it in your paper would be greatly appreciated!\n');
fprintf('1.Parcellating cortical functional networks in individuals.Wang, D. et.al., (2015).  Nat Neurosci 18, 1853-1860\n');
fprintf('2.Performing group-level functional image analyses based on homologous functional regions mapped in individuals. Li,M. et.al., (2019).PLOS Biology,\n');
fprintf('--------------------------------------------------------------------------------------------------------------------\n');


handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

warning('off');

%%% add path of the subfolders
global ProgramPath
ProgramPath = which('HFR_ai.m');
ProgramPath = fileparts(ProgramPath);

addpath(genpath([ProgramPath '/Subfunctions']));
addpath(genpath([ProgramPath '/Templates']));
addpath(genpath([ProgramPath '/Utilities']));
addpath(genpath([ProgramPath '/Bash']));
%%% load IndiROI-logo figure
Imgdata  =  imread([ProgramPath,filesep,'HFR_ai_logo.tif']);
axes(handles.axes1);
imshow(Imgdata);


% set individual parcellation
set(handles.checkbox2,  'Enable','off');
set(handles.checkbox3,  'Enable','off');

set(handles.pushbutton1, 'Enable','off');
set(handles.edit1,       'Enable','off');
set(handles.pushbutton2, 'Enable','off');
set(handles.edit2,       'Enable','off');

set(handles.pushbutton3, 'Enable','off');
set(handles.edit3,       'Enable','off');
    
set(handles.listbox1,    'Enable','off');
set(handles.pushbutton4, 'Enable','off');
set(handles.text1,       'Enable','off'); % Confidence
set(handles.edit5,       'Enable','off'); % Confidence
set(handles.text2,       'Enable','off'); % Iters
set(handles.edit6,       'Enable','off'); % Iters
set(handles.text3,       'Enable','off'); % Conbine left and right?
set(handles.edit7,       'Enable','off'); % Conbine left and right?

% set HFR_ai
set(handles.pushbutton6, 'Enable','off');
set(handles.edit8,       'Enable','off');
set(handles.pushbutton8, 'Enable','off');
set(handles.edit9,       'Enable','off');
set(handles.text6,       'Enable','off'); 
set(handles.edit15,      'Enable','off'); 
set(handles.text8,       'Enable','off'); 
set(handles.edit16,      'Enable','off'); 
set(handles.pushbutton9, 'Enable','off');
set(handles.edit10,      'Enable','off');
set(handles.edit11,      'Enable','off');
set(handles.pushbutton10,'Enable','off');
set(handles.listbox2,    'Enable','off');
set(handles.checkbox5,   'Enable','off');

% set create FC matrix
set(handles.pushbutton11, 'Enable','off');
set(handles.edit15,       'Enable','off');
set(handles.pushbutton12, 'Enable','off');
set(handles.edit15,       'Enable','off');
set(handles.pushbutton13, 'Enable','off');
set(handles.edit15,       'Enable','off');
set(handles.pushbutton14, 'Enable','off');
set(handles.edit15,       'Enable','off');
set(handles.checkbox7,    'Enable','off');
set(handles.pushbutton15, 'Enable','off');

set(handles.radiobutton1, 'Enable','off');
set(handles.radiobutton2, 'Enable','off');
set(handles.radiobutton3, 'Enable','off');
% UIWAIT makes HFR_ai wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HFR_ai_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.checkbox1,    'value')
   set(handles.checkbox4,    'Value',0); % not select HFR_ai
   set(handles.checkbox6,    'Value',0); % 
   
    set(handles.checkbox2,   'Enable','on');
    set(handles.checkbox3,   'Enable','on');
    
    set(handles.pushbutton1, 'Enable','on'); % Input dir
    set(handles.edit1,       'Enable','on');
  
    
    set(handles.pushbutton2, 'Enable','on'); % Subject List
    set(handles.edit2,       'Enable','on');
    
    set(handles.pushbutton3, 'Enable','on'); % Output dir
    set(handles.edit3,       'Enable','on');
    
    set(handles.listbox1,    'Enable','on');

    set(handles.pushbutton4, 'Enable','on'); % Run
    
    set(handles.text1,       'Enable','on'); % Confidence
    set(handles.edit5,       'Enable','on'); % Confidence
    set(handles.text2,       'Enable','on'); % Iters
    set(handles.edit6,       'Enable','on'); % Iters
    set(handles.text3,       'Enable','on'); % Conbine left and right?
    set(handles.edit7,       'Enable','on'); % Conbine left and right?
    
    % set HFR_ai
    set(handles.pushbutton6, 'Enable','off');
    set(handles.edit8,       'Enable','off');
    set(handles.pushbutton8, 'Enable','off');
    set(handles.edit9,       'Enable','off');
    set(handles.text6,       'Enable','off'); 
    set(handles.edit15,      'Enable','off'); 
    set(handles.text8,       'Enable','off'); 
    set(handles.edit16,      'Enable','off');
    set(handles.pushbutton9, 'Enable','off');
    set(handles.edit10,      'Enable','off');
    set(handles.edit11,      'Enable','off');
    set(handles.pushbutton10,'Enable','off');
    set(handles.listbox2,    'Enable','off');
    set(handles.checkbox5,   'Enable','off');
    
    % set create FC matrix
    set(handles.pushbutton11, 'Enable','off');
    set(handles.edit15,       'Enable','off');
    set(handles.pushbutton12, 'Enable','off');
    set(handles.edit15,       'Enable','off');
    set(handles.pushbutton13, 'Enable','off');
    set(handles.edit15,       'Enable','off');
    set(handles.pushbutton14, 'Enable','off');
    set(handles.edit15,       'Enable','off');
    set(handles.checkbox7,    'Enable','off');
    set(handles.pushbutton15, 'Enable','off');
    
    set(handles.radiobutton1, 'Enable','off');
    set(handles.radiobutton2, 'Enable','off');
    set(handles.radiobutton3, 'Enable','off');

else
    set(handles.checkbox2,    'Enable','off'); 
    set(handles.checkbox3,    'Enable','off'); 
    set(handles.pushbutton1,  'Enable','off');
    set(handles.edit1,        'Enable','off');
    
    set(handles.pushbutton2,  'Enable','off');
    set(handles.edit2,        'Enable','off');
    
    set(handles.pushbutton3,  'Enable','off');
    set(handles.edit3,        'Enable','off');
    
    set(handles.pushbutton4,  'Enable','off');

    
    set(handles.listbox1,     'Enable','off');
    set(handles.text1,        'Enable','off'); % Confidence
    set(handles.edit5,        'Enable','off'); % Confidence
    set(handles.text2,        'Enable','off'); % Iters
    set(handles.edit6,        'Enable','off'); % Iters
    set(handles.text3,        'Enable','off'); % Conbine left and right?
    set(handles.edit7,        'Enable','off'); % Conbine left and right?

 
end

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
% ProgramPath = which('HFR_ai.m');
% ProgramPath = fileparts(ProgramPath);

if get(handles.checkbox2,  'value')

    set(handles.checkbox3, 'Enable','off');  

else

    set(handles.checkbox3, 'Enable','on');
    
end
% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.checkbox3, 'value')
   set(handles.checkbox2, 'Enable','off'); 
   helpdlg(sprintf('Make sure the files are organized into specified format!\n sub_001_timeframes_fs4.mat \n sub_002_timeframes_fs4.mat \n Each MAT includes two variables: lhData rhData'),'Warning')
else
    set(handles.checkbox2, 'Enable','on');
    
end
% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_path = uigetdir(pwd, 'Select the file includes time frames');
set(handles.edit1,'string',folder_path);
clear folder_name


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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[list_file,list_path] = uigetfile('*.txt','Select Subject list file');
[~,~,ext]           = fileparts([list_path,filesep,list_file]);
if  isequal(ext,'.txt')
    SubName            = textread([list_path,filesep,list_file],'%s');
end
if ~isempty(SubName)
    set(handles.listbox1,'string',SubName);
else
    warming('No subjects name detected in the selected file!');
end
 
set(handles.edit2,'string',[list_path,filesep,list_file]);
clear list_file list_path




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





% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_path = uigetdir(pwd);
set(handles.edit3,'string',folder_path);
clear folder_name

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


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton4,  'Enable','off');
dr_fs     = get(handles.checkbox2,         'value'); % 1 - yes, reading FS4 files
dr_mat    = get(handles.checkbox3,         'value'); % 1 - yes, reading MAT files

dr_fold   = get(handles.edit1,             'string'); % data folder
dr_out    = get(handles.edit3,             'string'); % output folder(organized data, IndiPar)
sub_list  = get(handles.listbox1,          'string');


if dr_fs
   Func_FS4_Data_Read(dr_fold,dr_out,sub_list);
end

if dr_mat
   Func_MAT_Data_Read(dr_fold,dr_out,sub_list);
end

%% Pacellation parameters
confidence_threshold = str2num(get(handles.edit5, 'string'));
numIter              = str2num(get(handles.edit6, 'string'));
combineLeftRight     = str2num(get(handles.edit7, 'string'));

global ProgramPath
Func_IterativeParcellation(ProgramPath,dr_out,sub_list,numIter,confidence_threshold,combineLeftRight);
fprintf('Individual Parcellation finished!\n');
set(handles.pushbutton4,  'Enable','on');

% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
if get(handles.checkbox4,    'value')
   set(handles.checkbox1,    'Value',0);
   set(handles.checkbox6,    'Value',0);
   
   % set individual parcellation
   set(handles.checkbox2,    'Enable','off'); 
   set(handles.checkbox3,    'Enable','off'); 
   set(handles.pushbutton1,  'Enable','off');
   set(handles.edit1,        'Enable','off');
    
   set(handles.pushbutton2,  'Enable','off');
   set(handles.edit2,        'Enable','off');
    
   set(handles.pushbutton3,  'Enable','off');
   set(handles.edit3,        'Enable','off');
    
   set(handles.pushbutton4,  'Enable','off');

    
   set(handles.listbox1,     'Enable','off'); 
   set(handles.text1,        'Enable','off'); % Confidence
   set(handles.edit5,        'Enable','off'); % Confidence
   set(handles.text2,        'Enable','off'); % Iters
   set(handles.edit6,        'Enable','off'); % Iters
   set(handles.text3,        'Enable','off'); % Conbine left and right?
   set(handles.edit7,        'Enable','off'); % Conbine left and right?

   % set HRF-ai
   set(handles.pushbutton6,  'Enable','on');
   set(handles.edit8,        'Enable','on');
   set(handles.pushbutton8,  'Enable','on');
   set(handles.edit9,        'Enable','on');
   set(handles.text6,        'Enable','on'); 
   set(handles.edit15,       'Enable','on'); 
   set(handles.text8,        'Enable','on'); 
   set(handles.edit16,       'Enable','on');
   set(handles.pushbutton9,  'Enable','on');
   set(handles.edit10,       'Enable','on');
   set(handles.edit11,       'Enable','on');
   set(handles.pushbutton10, 'Enable','on');
   set(handles.listbox2,     'Enable','on');
   set(handles.checkbox5,    'Enable','off');
   
   % set create FC matrix
   set(handles.pushbutton11, 'Enable','off');
   set(handles.edit15,       'Enable','off');
   set(handles.pushbutton12, 'Enable','off');
   set(handles.edit15,       'Enable','off');
   set(handles.pushbutton13, 'Enable','off');
   set(handles.edit15,       'Enable','off');
   set(handles.pushbutton14, 'Enable','off');
   set(handles.edit15,       'Enable','off');
   set(handles.checkbox7,    'Enable','off');
   set(handles.pushbutton15, 'Enable','off');
   set(handles.radiobutton1, 'Enable','off');
   set(handles.radiobutton2, 'Enable','off');
   set(handles.radiobutton3, 'Enable','off');

else
    set(handles.pushbutton6, 'Enable','off');
    set(handles.edit8,       'Enable','off');
    set(handles.pushbutton8, 'Enable','off');
    set(handles.edit9,       'Enable','off');
    set(handles.text6,       'Enable','off'); 
    set(handles.edit15,      'Enable','off'); 
    set(handles.text8,       'Enable','off'); 
    set(handles.edit16,      'Enable','off');
    set(handles.pushbutton9, 'Enable','off');
    set(handles.edit10,      'Enable','off');
    set(handles.edit11,      'Enable','off');
    set(handles.pushbutton10,'Enable','off');
    set(handles.listbox2,    'Enable','off');
    set(handles.checkbox5,   'Enable','off');
    
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


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_path = uigetdir(pwd,'Select the file includes parcellation results(IndiPar file)');
set(handles.edit8,'string',folder_path);
clear folder_name


function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[list_file,list_path] = uigetfile('*.txt','Select Subject list file');
[~,~,ext]           = fileparts([list_path,filesep,list_file]);
if  isequal(ext,'.txt')
    SubName            = textread([list_path,filesep,list_file],'%s');
end
if ~isempty(SubName)
    set(handles.listbox2,'string',SubName);
else
    warming('No subjects name detected in the selected file!');
end
 
set(handles.edit9,'string',[list_path,filesep,list_file]);
clear list_file list_path




function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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




% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_path = uigetdir(pwd);
set(handles.edit10,'string',folder_path);
clear folder_name


function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton10,                  'Enable','off');
global ProgramPath 

dr_fold   = get(handles.edit8,             'string'); % data folder
dr_out    = get(handles.edit10,            'string'); % output folder(organized data, IndiPar)
sub_list  = get(handles.listbox2,          'string');

IterNumber  = get(handles.edit16,          'string');

% HFR_ai parameters
Matchrate = str2num(get(handles.edit11,    'string'));


%% HFR_ai, get the discrete patches
OutDir = [dr_out '/DiscretePatches/'];
mkdir(OutDir);
fprintf(['Gettting discrete patches for each subject.....\n']);


for s = 1:length(sub_list)    
    sub = sub_list{s};
    eval(['! ' ProgramPath '/Bash/Get_DiscretePatches_for_EachNet.csh ' dr_fold ' ' OutDir ' ' sub ' ' IterNumber]);
end

%% HFR_ai, get the individual ROIs

OutDir = [dr_out '/MatchMatrix/'];
mkdir(OutDir);
fprintf(['Gettting Homologous regions across subjects.....\n']);

% Create match matrix
Func_MatchPatch_Between_IndiSub_GrpTemplate(ProgramPath,[dr_out '/DiscretePatches'],sub_list,OutDir);



%% HFR_ai, get the individual ROIs
Func_Generate_Matched_ROIs(ProgramPath,[dr_out '/DiscretePatches'],[dr_out '/MatchMatrix/'],dr_fold,dr_out,sub_list,Matchrate);
% 
% % Clear files that will be not used
eval(['!rm -rf ' dr_out '/MatchRate' num2str(Matchrate) '/Indi_Matched_Patches_Splited']);
eval(['!rm -rf ' dr_out '/MatchRate' num2str(Matchrate) '/Indi_Matched_Patches_Clean']);

helpdlg(sprintf(['ROI Matching finished!\nPlease check the created ROIs at ' dr_out '/MatchRate' num2str(Matchrate) '\n']),'HFR_ai Message')
set(handles.checkbox5,     'Enable','on');
set(handles.pushbutton10,  'Enable','on');

function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ProgramPath
dr_out    = get(handles.edit10,         'string'); % output folder(organized data, IndiPar)
sub_list  = get(handles.listbox2,       'string');
Matchrate = str2num(get(handles.edit11, 'string'));

OutDir = [dr_out '/MatchRate' num2str(Matchrate) '/GrpTemplate_Matched_ROIs'];

if get(handles.checkbox5,   'value')
   ROIsNum = Func_Find_ExcludeROIs_From116ROIs([dr_out '/MatchMatrix'],OutDir,sub_list,Matchrate);
  
   % Snapshot 
   eval(['! ' ProgramPath '/Bash/TakeSnapshotsOnSurface_for_mgh_files.csh ' OutDir ' ' ProgramPath '/Bash/']);
   
   range1 = 145:455;
   range2 = 70:535;  
   img1 = imread([OutDir '/Include_ROIs_FS5_lh.mgh.tiff']);
   img1 = img1(range1,range2,:);
   img2 = imread([OutDir '/Include_ROIs_FS5_lh.mgh_med.tiff']);
   img2 = img2(range1,range2,:);   
   
   img3 = imread([OutDir '/Include_ROIs_FS5_rh.mgh.tiff']);
   img3 = img3(range1,range2,:);
   img4 = imread([OutDir '/Include_ROIs_FS5_rh.mgh_med.tiff']);
   img4 = img4(range1,range2,:);   
   
   img = cat(3,[img1 img2 img3 img4]);
   figure('Name','Homologous Regions covering')
   imshow(img);
   title(strrep(['Path:' OutDir],'_','\_'));
   text(15,380,['Homologous Regions Number: ' num2str(ROIsNum)],'fontsize',12);
end

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox4
if get(handles.checkbox6,   'value')
   set(handles.checkbox1,   'Value',0);
   set(handles.checkbox4,   'Value',0);
   
   % set individual parcellation
   set(handles.checkbox2,    'Enable','off'); 
   set(handles.checkbox3,    'Enable','off'); 
   set(handles.pushbutton1,  'Enable','off');
   set(handles.edit1,        'Enable','off');
    
   set(handles.pushbutton2,  'Enable','off');
   set(handles.edit2,        'Enable','off');
    
   set(handles.pushbutton3,  'Enable','off');
   set(handles.edit3,        'Enable','off');
    
   set(handles.pushbutton4,  'Enable','off');

    
   set(handles.listbox1,     'Enable','off'); 
   set(handles.text1,        'Enable','off'); % Confidence
   set(handles.edit5,        'Enable','off'); % Confidence
   set(handles.text2,        'Enable','off'); % Iters
   set(handles.edit6,        'Enable','off'); % Iters
   set(handles.text3,        'Enable','off'); % Conbine left and right?
   set(handles.edit7,        'Enable','off'); % Conbine left and right?

   % set HRF-ai
   set(handles.pushbutton6,  'Enable','off');
   set(handles.edit8,        'Enable','off');
   set(handles.pushbutton8,  'Enable','off');
   set(handles.edit9,        'Enable','off');
   set(handles.text6,        'Enable','off'); 
   set(handles.edit15,       'Enable','off'); 
   set(handles.text8,        'Enable','off'); 
   set(handles.edit16,       'Enable','off'); 
   set(handles.pushbutton9,  'Enable','off');
   set(handles.edit10,       'Enable','off');
   set(handles.edit11,       'Enable','off');   
   set(handles.pushbutton10, 'Enable','off');
   set(handles.listbox2,     'Enable','off');
   set(handles.checkbox5,    'Enable','off');
   
   % set create FC matrix
   set(handles.pushbutton11, 'Enable','on');
   set(handles.edit15,       'Enable','on');
   set(handles.pushbutton12, 'Enable','on');
   set(handles.edit15,       'Enable','on');
   set(handles.pushbutton13, 'Enable','on');
   set(handles.edit15,       'Enable','on');
   set(handles.pushbutton14, 'Enable','on');
   set(handles.edit15,       'Enable','on');
   set(handles.checkbox7,    'Enable','on');
   set(handles.pushbutton15, 'Enable','on');
   set(handles.radiobutton1, 'Enable','on');
   set(handles.radiobutton2, 'Enable','on');
   set(handles.radiobutton3, 'Enable','on');

else
   set(handles.pushbutton11, 'Enable','off');
   set(handles.edit15,       'Enable','off');
   set(handles.pushbutton12, 'Enable','off');
   set(handles.edit15,       'Enable','off');
   set(handles.pushbutton13, 'Enable','off');
   set(handles.edit15,       'Enable','off');
   set(handles.pushbutton14, 'Enable','off');
   set(handles.edit15,       'Enable','off');
   set(handles.checkbox7,    'Enable','off');
   set(handles.pushbutton15, 'Enable','off');
   set(handles.radiobutton1, 'Enable','off');
   set(handles.radiobutton2, 'Enable','off');
   set(handles.radiobutton3, 'Enable','off');

end


% Hint: get(hObject,'Value') returns toggle state of checkbox6


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_path = uigetdir(pwd,'Select the file includes ROIs(MatchRate file)');
set(handles.edit12,'string',folder_path);
set(handles.edit15,'string',folder_path);
clear folder_name


function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function ButtonGroup4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ButtonGroup4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
applyROIs = 'Individual';
setappdata(0,'applyROIs',applyROIs);


% --- Executes when selected object is changed in ButtonGroup4.
function ButtonGroup4_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in ButtonGroup4 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

str = get(hObject,'string');
switch str
    case 'Individual'
      applyROIs = 'Individual';
    case 'Atlas'
      applyROIs = 'Atlas';
    case 'Both'
      applyROIs = 'Both'; 
end

setappdata(0,'applyROIs',applyROIs);



% --- Executes on button press in checkbox6.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6


    

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_path = uigetdir(pwd,'Select the file includes time frames(OrganizedData file)');
set(handles.edit13,'string',folder_path);

clear folder_name


function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[list_file,list_path] = uigetfile('*.txt','Select Subject list file');
[~,~,ext]           = fileparts([list_path,filesep,list_file]);
if  isequal(ext,'.txt')
    global SubName
    SubName            = textread([list_path,filesep,list_file],'%s');
end

set(handles.edit14,'string',[list_path,filesep,list_file]);
clear list_file list_path



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_path = uigetdir(pwd);
set(handles.edit15,'string',folder_path);
clear folder_name

% --- Executes on button press in pushbutton14.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ROIPath   = get(handles.edit12,         'string'); 
DataPath  = get(handles.edit13,         'string'); 
OutPath   = get(handles.edit15,         'string'); 
sub_path  = get(handles.edit14,         'string');
sub_list  = textread(sub_path,'%s');

applyROIs = getappdata(0,'applyROIs');


fprintf('Preparing to calculate FC Matrix----');
if strcmp(applyROIs,'Individual')
   Func_ROI2ROI_from_ROIs_Indi(ROIPath,DataPath,OutPath,sub_list);
else if strcmp(applyROIs,'Atlas')
       Func_ROI2ROI_from_ROIs_Atlas(ROIPath,DataPath,OutPath,sub_list); 
    else if strcmp(applyROIs,'Both')
      Func_ROI2ROI_from_ROIs_Indi(ROIPath,DataPath,OutPath,sub_list);
      Func_ROI2ROI_from_ROIs_Atlas(ROIPath,DataPath,OutPath,sub_list);
        end
    end
end



% Display average FC Matrix
load([ROIPath '/GrpTemplate_Matched_ROIs/AllSelected_Patches_lh.mat']);
PatchNum_lh = AllSelected_Patches;
load([ROIPath '/GrpTemplate_Matched_ROIs/AllSelected_Patches_rh.mat']);
PatchNum_rh = AllSelected_Patches;

Region = PatchNum_lh+PatchNum_rh;
global ProgramPath
load([ProgramPath '/Utilities/MyColormaps'],'mycmap');

if get(handles.checkbox7,   'value') 
    switch applyROIs
        case 'Individual'
            FCmatrix = Func_Average_ROI2ROI_FC([OutPath '/ROI2ROIFC_Indi'],sub_list); 
           
            figure('Name','Mean FC Matrix')  
            imagesc(FCmatrix,[-1 1]);
            hold on;
            region_ind_tmp = 0;
            for region_ind = Region
                region_ind_tmp = region_ind_tmp+region_ind;
                plot([-0.5 -0.5]+region_ind_tmp+1,[-0.5 300],'w-','LineWidth',0.5);
                hold on;
            end

            region_ind_tmp = 0;
            for region_ind = Region
                region_ind_tmp = region_ind_tmp+region_ind;
                plot([-0.5 300],[-0.5 -0.5]+region_ind_tmp+1,'w-','LineWidth',0.5);
                hold on;
            end
            axis square
            set(gcf,'Colormap',mycmap,'PaperUnits','inches','PaperPosition',[0 0 4 4]);
            title('Individualized ROIs(z)');
            colorbar
            saveas(gcf,[OutPath '/ROI2ROIFC_Indi/Average_FCMatrix_IndividualizedROIs','.tif']);
            
        case 'Atlas'
            FCmatrix = Func_Average_ROI2ROI_FC([OutPath '/ROI2ROIFC_Atlas'],sub_list);
            
            figure('Name','Mean FC Matrix')  
            imagesc(FCmatrix,[-1 1]);
            hold on;
            region_ind_tmp = 0;
            for region_ind = Region
                region_ind_tmp = region_ind_tmp+region_ind;
                plot([-0.5 -0.5]+region_ind_tmp+1,[-0.5 300],'w-','LineWidth',0.5);
                hold on;
            end

            region_ind_tmp = 0;
            for region_ind = Region
                region_ind_tmp = region_ind_tmp+region_ind;
                plot([-0.5 300],[-0.5 -0.5]+region_ind_tmp+1,'w-','LineWidth',0.5);
                hold on;
            end
            axis square
            set(gcf,'Colormap',mycmap,'PaperUnits','inches','PaperPosition',[0 0 4 4]);
            title('Atlas ROIs(z)');
            colorbar
            saveas(gcf,[OutPath '/ROI2ROIFC_Atlas/Average_FCMatrix_AtlasROIs','.tif']);

   
        case 'Both'
           
            FCmatrix1 = Func_Average_ROI2ROI_FC([OutPath '/ROI2ROIFC_Indi'],sub_list);
            FCmatrix2 = Func_Average_ROI2ROI_FC([OutPath '/ROI2ROIFC_Atlas'],sub_list);
            
            figure('Name','Mean FC Matrix');
            imagesc(FCmatrix1,[-1 1]);
            hold on;
            region_ind_tmp = 0;
            for region_ind = Region
                region_ind_tmp = region_ind_tmp+region_ind;
                plot([-0.5 -0.5]+region_ind_tmp+1,[-0.5 300],'w-','LineWidth',0.5);
                hold on;
            end

            region_ind_tmp = 0;
            for region_ind = Region
                region_ind_tmp = region_ind_tmp+region_ind;
                plot([-0.5 300],[-0.5 -0.5]+region_ind_tmp+1,'w-','LineWidth',0.5);
                hold on;
            end
            axis square
            set(gcf,'Colormap',mycmap,'PaperUnits','inches','PaperPosition',[0 0 4 4]);
            title('Individualized ROIs(z)');
            colorbar
            saveas(gcf,[OutPath '/ROI2ROIFC_Indi/Average_FCMatrix_IndividualizedROIs','.tif']);
            
            figure('Name','Mean FC Matrix');
            imagesc(FCmatrix2,[-1 1]);
            hold on;
            region_ind_tmp = 0;
            for region_ind = Region
                region_ind_tmp = region_ind_tmp+region_ind;
                plot([-0.5 -0.5]+region_ind_tmp+1,[-0.5 300],'w-','LineWidth',0.5);
                hold on;
            end

            region_ind_tmp = 0;
            for region_ind = Region
                region_ind_tmp = region_ind_tmp+region_ind;
                plot([-0.5 300],[-0.5 -0.5]+region_ind_tmp+1,'w-','LineWidth',0.5);
                hold on;
            end
            axis square
            set(gcf,'Colormap',mycmap,'PaperUnits','inches','PaperPosition',[0 0 4 4]);
            title('Atlas ROIs(z)');
            colorbar
            saveas(gcf,[OutPath '/ROI2ROIFC_Atlas/Average_FCMatrix_AtlasROIs','.tif']);
           
    end
end
  



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double



% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in checkbox7.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
