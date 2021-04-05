function varargout = Benutzeroberflaeche_Start(varargin)
% BENUTZEROBERFLAECHE_START MATLAB code for Benutzeroberflaeche_Start.fig
%      BENUTZEROBERFLAECHE_START, by itself, creates a new BENUTZEROBERFLAECHE_START or raises the existing
%      singleton*.
%
%      H = BENUTZEROBERFLAECHE_START returns the handle to a new BENUTZEROBERFLAECHE_START or the handle to
%      the existing singleton*.
%
%      BENUTZEROBERFLAECHE_START('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BENUTZEROBERFLAECHE_START.M with the given input arguments.
%
%      BENUTZEROBERFLAECHE_START('Property','Value',...) creates a new BENUTZEROBERFLAECHE_START or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Benutzeroberflaeche_Start_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Benutzeroberflaeche_Start_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Benutzeroberflaeche_Start

% Last Modified by GUIDE v2.5 14-Jul-2017 13:04:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Benutzeroberflaeche_Start_OpeningFcn, ...
                   'gui_OutputFcn',  @Benutzeroberflaeche_Start_OutputFcn, ...
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


% --- Executes just before Benutzeroberflaeche_Start is made visible.
function Benutzeroberflaeche_Start_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Benutzeroberflaeche_Start (see VARARGIN)

% Choose default command line output for Benutzeroberflaeche_Start
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Benutzeroberflaeche_Start wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Benutzeroberflaeche_Start_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Neues_Fahrzeug.
function Neues_Fahrzeug_Callback(hObject, eventdata, handles)
Neues_Fahrzeug = get(handles.Neues_Fahrzeug, 'Value');
if(Neues_Fahrzeug == 1)
    set(handles.Vorhandene_Konfiguration, 'Value', 0);
    set(handles.Neues_Fahrzeug_Speichern, 'Value', 0);
end
% hObject    handle to Neues_Fahrzeug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Neues_Fahrzeug


% --- Executes on button press in Vorhandene_Konfiguration.
function Vorhandene_Konfiguration_Callback(hObject, eventdata, handles)
Vorhandene_Konfiguration = get(handles.Vorhandene_Konfiguration, 'Value');
if(Vorhandene_Konfiguration == 1)
    set(handles.Neues_Fahrzeug, 'Value', 0);
    set(handles.Neues_Fahrzeug_Speichern, 'Value', 0);
end
% hObject    handle to Vorhandene_Konfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Vorhandene_Konfiguration


% --- Executes on button press in Neues_Fahrzeug_Speichern.
function Neues_Fahrzeug_Speichern_Callback(hObject, eventdata, handles)
Neues_Fahrzeug_Speichern = get(handles.Neues_Fahrzeug_Speichern, 'Value');
if(Neues_Fahrzeug_Speichern == 1)
    set(handles.Neues_Fahrzeug, 'Value', 0);
    set(handles.Vorhandene_Konfiguration, 'Value', 0);
end
% hObject    handle to Neues_Fahrzeug_Speichern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Neues_Fahrzeug_Speichern


% --- Executes on button press in Button_Weiter.
function Button_Weiter_Callback(hObject, eventdata, handles)
Neues_Fahrzeug = get(handles.Neues_Fahrzeug, 'Value');
Neues_Fahrzeug_Speichern = get(handles.Neues_Fahrzeug_Speichern, 'Value');
Vorhandene_Konfiguration = get(handles.Vorhandene_Konfiguration, 'Value');

if(Neues_Fahrzeug == 0 && Neues_Fahrzeug_Speichern == 0 && Vorhandene_Konfiguration == 0)
        errordlg('Bitte eine der Auswahlmöglichkeiten wählen.','Fehlermeldung');
return
end

assignin('base','Neues_Fahrzeug',Neues_Fahrzeug);
assignin('base','Neues_Fahrzeug_Speichern',Neues_Fahrzeug_Speichern);
assignin('base','Vorhandene_Konfiguration',Vorhandene_Konfiguration);

close Benutzeroberflaeche_Start;
% hObject    handle to Button_Weiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in Weiter.
