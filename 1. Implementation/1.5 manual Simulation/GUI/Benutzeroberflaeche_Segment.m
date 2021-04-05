function varargout = Benutzeroberflaeche_Segment(varargin)
% BENUTZEROBERFLAECHE_SEGMENT MATLAB code for Benutzeroberflaeche_Segment.fig
%      BENUTZEROBERFLAECHE_SEGMENT, by itself, creates a new BENUTZEROBERFLAECHE_SEGMENT or raises the existing
%      singleton*.
%
%      H = BENUTZEROBERFLAECHE_SEGMENT returns the handle to a new BENUTZEROBERFLAECHE_SEGMENT or the handle to
%      the existing singleton*.
%
%      BENUTZEROBERFLAECHE_SEGMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BENUTZEROBERFLAECHE_SEGMENT.M with the given input arguments.
%
%      BENUTZEROBERFLAECHE_SEGMENT('Property','Value',...) creates a new BENUTZEROBERFLAECHE_SEGMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Benutzeroberflaeche_Segment_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Benutzeroberflaeche_Segment_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Benutzeroberflaeche_Segment

% Last Modified by GUIDE v2.5 13-Jul-2017 08:52:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Benutzeroberflaeche_Segment_OpeningFcn, ...
                   'gui_OutputFcn',  @Benutzeroberflaeche_Segment_OutputFcn, ...
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


% --- Executes just before Benutzeroberflaeche_Segment is made visible.
function Benutzeroberflaeche_Segment_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Benutzeroberflaeche_Segment (see VARARGIN)

% Choose default command line output for Benutzeroberflaeche_Segment
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Benutzeroberflaeche_Segment wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Benutzeroberflaeche_Segment_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in Fahrzeugklasse.
function Fahrzeugklasse_Callback(hObject, eventdata, handles)
% hObject    handle to Fahrzeugklasse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Fahrzeugklasse contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Fahrzeugklasse


% --- Executes during object creation, after setting all properties.
function Fahrzeugklasse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fahrzeugklasse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Button_Weiter.
function Button_Weiter_Callback(hObject, eventdata, handles)
% Auslesen der Eingabe für Fahrzeugklasse (A, B, C und T möglich):
Fahrzeugsegment = get(handles.Fahrzeugklasse, 'Value');

if(Fahrzeugsegment == 1)
    errordlg('Unvollständige Eingabe! Bitte ein Fahrzeugsegment auswählen.','Fehlermeldung'); % Ausgabe einer Fehlermeldung, falls unvollständige Eingabe vorliegt
return
elseif(Fahrzeugsegment == 2)    Segment = 'A';
elseif(Fahrzeugsegment == 3)    Segment = 'B';
elseif(Fahrzeugsegment == 4)    Segment = 'C';
elseif(Fahrzeugsegment == 5)    Segment = 'T';
end

% Übergabe der eingelesenen Werte an den Workspace
assignin('base','Segment',Segment);

close Benutzeroberflaeche_Segment;
% hObject    handle to Button_Weiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
