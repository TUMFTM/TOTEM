function varargout = Benutzeroberflaeche_Info(varargin)
% BENUTZEROBERFLAECHE_INFO MATLAB code for Benutzeroberflaeche_Info.fig
%      BENUTZEROBERFLAECHE_INFO, by itself, creates a new BENUTZEROBERFLAECHE_INFO or raises the existing
%      singleton*.
%
%      H = BENUTZEROBERFLAECHE_INFO returns the handle to a new BENUTZEROBERFLAECHE_INFO or the handle to
%      the existing singleton*.
%
%      BENUTZEROBERFLAECHE_INFO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BENUTZEROBERFLAECHE_INFO.M with the given input arguments.
%
%      BENUTZEROBERFLAECHE_INFO('Property','Value',...) creates a new BENUTZEROBERFLAECHE_INFO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Benutzeroberflaeche_Info_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Benutzeroberflaeche_Info_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Benutzeroberflaeche_Info

% Last Modified by GUIDE v2.5 13-Jul-2017 09:09:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Benutzeroberflaeche_Info_OpeningFcn, ...
                   'gui_OutputFcn',  @Benutzeroberflaeche_Info_OutputFcn, ...
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


% --- Executes just before Benutzeroberflaeche_Info is made visible.
function Benutzeroberflaeche_Info_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Benutzeroberflaeche_Info (see VARARGIN)

% Choose default command line output for Benutzeroberflaeche_Info
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Benutzeroberflaeche_Info wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Benutzeroberflaeche_Info_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Button_Weiter.
function Button_Weiter_Callback(hObject, eventdata, handles)
close
% hObject    handle to Button_Weiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
