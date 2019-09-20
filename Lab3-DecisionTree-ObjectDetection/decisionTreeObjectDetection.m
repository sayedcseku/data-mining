
function varargout = decisionTreeObjectDetection(varargin)
% DECISIONTREEOBJECTDETECTION MATLAB code for decisionTreeObjectDetection.fig
%      DECISIONTREEOBJECTDETECTION, by itself, creates a new DECISIONTREEOBJECTDETECTION or raises the existing
%      singleton*.
%
%      H = DECISIONTREEOBJECTDETECTION returns the handle to a new DECISIONTREEOBJECTDETECTION or the handle to
%      the existing singleton*.
%
%      DECISIONTREEOBJECTDETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DECISIONTREEOBJECTDETECTION.M with the given input arguments.
%
%      DECISIONTREEOBJECTDETECTION('Property','Value',...) creates a new DECISIONTREEOBJECTDETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before decisionTreeObjectDetection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to decisionTreeObjectDetection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help decisionTreeObjectDetection

% Last Modified by GUIDE v2.5 23-Sep-2018 10:36:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @decisionTreeObjectDetection_OpeningFcn, ...
                   'gui_OutputFcn',  @decisionTreeObjectDetection_OutputFcn, ...
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


% --- Executes just before decisionTreeObjectDetection is made visible.
function decisionTreeObjectDetection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to decisionTreeObjectDetection (see VARARGIN)

% Choose default command line output for decisionTreeObjectDetection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes decisionTreeObjectDetection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = decisionTreeObjectDetection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in LoadTrainingImg.
function LoadTrainingImg_Callback(hObject, eventdata, handles)

set(handles.statusBar, 'String','Welcome to My Program.');

path = uigetdir
files = dir (fullfile(path,'\*.png'));

handles.path = path;
handles.files = files;
guidata(hObject,handles)
set(handles.statusBar, 'String','Training Images are selected.');


% --- Executes on button press in ExtractFeatures.
function ExtractFeatures_Callback(hObject, eventdata, handles)

files = handles.files;
path = handles.path;
L = length (files);

handles.L = L;

set(handles.statusBar, 'String','Features extracting...');

classes = {'apple','car','cow','cup','dog','horse','pear','tomato'};
classes = string(classes);

for i=1:L
   orgImage=imread(fullfile(path,'\',files(i).name));   
   % process the image in here
   
   grayImg= rgb2gray(orgImage);
   
   features(i,:) = extractLBPFeatures(grayImg);
   
   for j=1:8
       k = strfind(files(i).name,classes(1,j));
       if ~isempty(k)
           label(i,1)=classes(1,j);
           break;
       end 
    end


end
handles.label = label;
%tab = array2table(features);
writetable(table(features),'features.xlsx');
disp('Features Extraction Completed.');
set(handles.statusBar, 'String','Features Extraction Completed.');
guidata(hObject,handles)

% --- Executes on button press in LoadFeatureData.
function LoadFeatureData_Callback(hObject, eventdata, handles)

winopen features.xlsx

num = xlsread('features.xlsx','Sheet1');
handles.num = num;
guidata(hObject,handles)
set(handles.statusBar, 'String','Features are loaded.');

% --- Executes on button press in LoadQueryImg.
function LoadQueryImg_Callback(hObject, eventdata, handles)

X=handles.num;
Y = handles.label;
tc = fitctree(X,Y);

path = uigetdir
files = dir (fullfile(path,'\*.png'));
L = length (files);

set(handles.statusBar, 'String','Features extracting...');
for i=1:L
   orgImage=imread(fullfile(path,'\',files(i).name));   
   % process the image in here
   
   grayImg= rgb2gray(orgImage);
   features(i,:) = extractLBPFeatures(grayImg);

end

result = predict(tc,features);
handles.result = result;
guidata(hObject,handles)
set(handles.statusBar, 'String','Query Image is loaded.');


% --- Executes on button press in ShowResult.
function ShowResult_Callback(hObject, eventdata, handles)

result=handles.result;
matData = table(result);

writetable(matData,'res.xlsx');
winopen res.xlsx

set(handles.statusBar, 'String','Process is Completed.');
