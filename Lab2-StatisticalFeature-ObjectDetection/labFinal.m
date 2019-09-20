
function varargout = labFinal(varargin)
% LABFINAL MATLAB code for labFinal.fig
%      LABFINAL, by itself, creates a new LABFINAL or raises the existing
%      singleton*.
%
%      H = LABFINAL returns the handle to a new LABFINAL or the handle to
%      the existing singleton*.
%
%      LABFINAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LABFINAL.M with the given input arguments.
%
%      LABFINAL('Property','Value',...) creates a new LABFINAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before labFinal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to labFinal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help labFinal

% Last Modified by GUIDE v2.5 03-Sep-2018 14:46:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @labFinal_OpeningFcn, ...
                   'gui_OutputFcn',  @labFinal_OutputFcn, ...
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


% --- Executes just before labFinal is made visible.
function labFinal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to labFinal (see VARARGIN)

% Choose default command line output for labFinal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes labFinal wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = labFinal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function [fmean,fmedian,fmode,fmidrange,fIQR,fstd,frange] = getfeatures(img)

    img = img(:);
    fmean = mean(img);
    
    fmedian = median(img);
    
    fmode = mode(img);
    
    fmin = min(img);
    fmax = max(img);
    
    fmidrange = (fmin+fmax)/2;
    
    fIQR = iqr(double(img));
    
    fstd = std(double(img));
    frange = fmax-fmin;
    

% --- Executes on button press in LoadTrainingImg.
function LoadTrainingImg_Callback(hObject, eventdata, handles)
% hObject    handle to LoadTrainingImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%a = get(handles.edit1,'String');
set(handles.statusBar, 'String','Welcome to My Program.');

path = uigetdir
files = dir (fullfile(path,'\*.png'));

handles.path = path;
handles.files = files;
guidata(hObject,handles)
set(handles.statusBar, 'String','Training Images are selected.');


% --- Executes on button press in ExtractFeatures.
function ExtractFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to ExtractFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%disp('Training Images are selected');

files = handles.files;
path = handles.path;
L = length (files);

handles.L = L;

set(handles.statusBar, 'String','Features extracting...');
for i=1:L
   orgImage=imread(fullfile(path,'\',files(i).name));   
   % process the image in here
   
   grayImg= rgb2gray(orgImage);
   %grayImg = im2double(grayImg);
   %image{i} = grayImg;
   [fmean,fmedian,fmode,fmidrange,fIQR,fstd,frange] = getfeatures(grayImg);
   data{i}.fmean = fmean;
   data{i}.fmedian = fmedian;
   data{i}.fmode = fmode;
   data{i}.fmidrange = fmidrange;
   data{i}.fIQR = fIQR;
   data{i}.fstd = fstd;
   data{i}.frange = frange;
end

matData = cell2mat(data);
%tabData = cell2table(data);
%matData = struct2table(matData);
writetable(struct2table(matData),'features.xlsx');
disp('Features Extraction Completed.');
set(handles.statusBar, 'String','Features Extraction Completed.');
guidata(hObject,handles)

% --- Executes on button press in LoadFeatureData.
function LoadFeatureData_Callback(hObject, eventdata, handles)
% hObject    handle to LoadFeatureData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winopen features.xlsx

num = xlsread('features.xlsx','Sheet1');
handles.num = num;
guidata(hObject,handles)
set(handles.statusBar, 'String','Features are loaded.');

% --- Executes on button press in LoadQueryImg.
function LoadQueryImg_Callback(hObject, eventdata, handles)
% hObject    handle to LoadQueryImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uigetfile({'*.png';'*.jpg';'*.jpeg';'*.*'},'File Selector');
handles.testImageLocation = fullfile(PathName,'\',FileName);
orgImage=imread(fullfile(PathName,'\',FileName)); 
%orgImg = im2double(orgImage);
grayImg= rgb2gray(orgImage);

handles.grayImg=grayImg;
guidata(hObject,handles)
set(handles.statusBar, 'String','Query Image is loaded.');


% --- Executes on button press in ShowResult.
function ShowResult_Callback(hObject, eventdata, handles)
% hObject    handle to ShowResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path = handles.path;
grayImg = handles.grayImg;
num = handles.num;
files = handles.files;
[fmean,fmedian,fmode,fmidrange,fIQR,fstd,frange] = getfeatures(grayImg);

%matData = struct2table(matData);
L= handles.L;

set(handles.statusBar, 'String','Calculating similar images...');
for i=1:L
    f1 = abs(num(i,1)- fmean);
    f2 =abs(num(i,2)- fmedian);
    f4 = abs(num(i,4)- fmidrange);
    f5 = abs(num(i,5)- fIQR);
    f6= abs(num(i,6)- fstd);
    f3 = abs(num(i,3)- fmode);
    f7 = abs(num(i,7)-frange);
   manhatDistance = (f1+f2+f3+f4+f5+f6+f7)/7;
   dissimilarityMatrix{i}.val = manhatDistance;
   dissimilarityMatrix{i}.location = fullfile(path,'\',files(i).name);
end

disdata = cell2mat(dissimilarityMatrix);
disdata = struct2table(disdata);
disdata = sortrows(disdata);

 disp(char(disdata(1,2).location));
  %disp(disdata(1,2).location);
 img = imread(char(handles.testImageLocation));
 axes(handles.axes1);
 imshow(img);
 
img = imread(char(disdata(1,2).location));
axes(handles.axes2);
imshow(img);

img = imread(char(disdata(2,2).location));
axes(handles.axes3);
imshow(img);

img = imread(char(disdata(3,2).location));
axes(handles.axes4);
imshow(img);

img = imread(char(disdata(4,2).location));
axes(handles.axes5);
imshow(img);

img = imread(char(disdata(5,2).location));
axes(handles.axes6);
imshow(img);

img = imread(char(disdata(6,2).location));
axes(handles.axes7);
imshow(img);

img = imread(char(disdata(7,2).location));
axes(handles.axes8);
imshow(img);

img = imread(char(disdata(8,2).location));
axes(handles.axes9);
imshow(img);

img = imread(char(disdata(9,2).location));
axes(handles.axes10);
imshow(img);

img = imread(char(disdata(10,2).location));
axes(handles.axes11);
imshow(img);

img = imread(char(disdata(11,2).location));
axes(handles.axes12);
imshow(img);

img = imread(char(disdata(12,2).location));
axes(handles.axes13);
imshow(img);

img = imread(char(disdata(13,2).location));
axes(handles.axes14);
imshow(img);

img = imread(char(disdata(14,2).location));
axes(handles.axes15);
imshow(img);

img = imread(char(disdata(15,2).location));
axes(handles.axes16);
imshow(img);

img = imread(char(disdata(16,2).location));
axes(handles.axes17);
imshow(img);

img = imread(char(disdata(17,2).location));
axes(handles.axes18);
imshow(img);

img = imread(char(disdata(18,2).location));
axes(handles.axes19);
imshow(img);

img = imread(char(disdata(19,2).location));
axes(handles.axes20);
imshow(img);

img = imread(char(disdata(20,2).location));
axes(handles.axes21);
imshow(img);

set(handles.statusBar, 'String','Process is Completed.');
