function varargout = Benutzeroberflaeche_Manoever(varargin)
% BENUTZEROBERFLAECHE_MANOEVER MATLAB code for Benutzeroberflaeche_Manoever.fig
%      BENUTZEROBERFLAECHE_MANOEVER, by itself, creates a new BENUTZEROBERFLAECHE_MANOEVER or raises the existing
%      singleton*.
%
%      H = BENUTZEROBERFLAECHE_MANOEVER returns the handle to a new BENUTZEROBERFLAECHE_MANOEVER or the handle to
%      the existing singleton*.
%
%      BENUTZEROBERFLAECHE_MANOEVER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BENUTZEROBERFLAECHE_MANOEVER.M with the given input arguments.
%
%      BENUTZEROBERFLAECHE_MANOEVER('Property','Value',...) creates a new BENUTZEROBERFLAECHE_MANOEVER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Benutzeroberflaeche_Manoever_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Benutzeroberflaeche_Manoever_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Benutzeroberflaeche_Manoever

% Last Modified by GUIDE v2.5 05-Dec-2018 12:54:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Benutzeroberflaeche_Manoever_OpeningFcn, ...
                   'gui_OutputFcn',  @Benutzeroberflaeche_Manoever_OutputFcn, ...
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


% --- Executes just before Benutzeroberflaeche_Manoever is made visible.
function Benutzeroberflaeche_Manoever_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Benutzeroberflaeche_Manoever (see VARARGIN)

% Choose default command line output for Benutzeroberflaeche_Manoever
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.To_Wks_akt,'Enable','off');
set(handles.WLTP_info,'Enable','off');

% UIWAIT makes Benutzeroberflaeche_Manoever wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Benutzeroberflaeche_Manoever_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in kreisfahrt_stat.
function kreisfahrt_stat_Callback(hObject, eventdata, handles)
% hObject    handle to kreisfahrt_stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of kreisfahrt_stat


% --- Executes on button press in Besch_El.
function Besch_El_Callback(hObject, eventdata, handles)
% hObject    handle to Besch_El (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Besch_El


% --- Executes on button press in lenkwinkelsprung.
function lenkwinkelsprung_Callback(hObject, eventdata, handles)
% hObject    handle to lenkwinkelsprung (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lenkwinkelsprung


% --- Executes on button press in kreisfahrt_beschl.
function kreisfahrt_beschl_Callback(hObject, eventdata, handles)
% hObject    handle to kreisfahrt_beschl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of kreisfahrt_beschl


% --- Executes on button press in sinuslenken.
function sinuslenken_Callback(hObject, eventdata, handles)
% hObject    handle to sinuslenken (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sinuslenken


% --- Executes on button press in kundenfahrt_kurz.
function kundenfahrt_kurz_Callback(hObject, eventdata, handles)
% hObject    handle to kundenfahrt_kurz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of kundenfahrt_kurz


% --- Executes on button press in kundenfahrt_lang.
function kundenfahrt_lang_Callback(hObject, eventdata, handles)
% hObject    handle to kundenfahrt_lang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of kundenfahrt_lang


% --- Executes on button press in WLTP_Zyklus.
function WLTP_Zyklus_Callback(hObject, eventdata, handles)
% hObject    handle to WLTP_Zyklus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of WLTP_Zyklus

if get(handles.WLTP_Zyklus, 'Value') == 1;
set(handles.To_Wks_akt,'Enable','on');
set(handles.WLTP_info,'Enable','on');
else
set(handles.To_Wks_akt,'Enable','off');
set(handles.WLTP_info,'Enable','off');
end

% --- Executes on button press in To_Wks_akt.
function To_Wks_akt_Callback(hObject, eventdata, handles)
% hObject    handle to To_Wks_akt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of To_Wks_akt


% --- Executes on button press in start_simulation.
function start_simulation_Callback(hObject, eventdata, handles)
%% Auslesen der Eingaben zu den Fahrmanövern
manoever.select_Kreisfahrt                  = get(handles.kreisfahrt_stat, 'Value');
manoever.select_Beschleunigung_Elastizitaet = get(handles.Besch_El, 'Value');
manoever.select_Traktion_low                = get(handles.traktion_low, 'Value');
manoever.select_Traktion_split              = get(handles.traktion_split, 'Value');
manoever.select_Lenkwinkelsprung            = get(handles.lenkwinkelsprung, 'Value');
manoever.select_Kreisfahrt_beschl           = get(handles.kreisfahrt_beschl, 'Value');
manoever.select_sinus_lenken                = get(handles.sinuslenken, 'Value');
manoever.select_Kundenfahrt_kurz            = get(handles.kundenfahrt_kurz, 'Value');
manoever.select_Kundenfahrt_lang            = get(handles.kundenfahrt_lang, 'Value');
manoever.select_WLTP_Zyklus                 = get(handles.WLTP_Zyklus, 'Value');
manoever.select_To_Wks_akt                  = get(handles.To_Wks_akt, 'Value');
manoever.select_WLTP_Zyklus_vektorisiert    = get(handles.WLTP_Zyklus_vektorisiert, 'Value');
manoever.select_vmax                        = get(handles.checkbox_vmax, 'Value');

% auskommentiert durch Angerer am 9.1.18 um die reine Initialisierung ohne
% anschließende Simulation zu ermöglichen. 
% Überprüfen, ob wenigstens ein Fahrmanöver ausgewählt wurde
%     if(manoever.select_Kreisfahrt == 0 && manoever.select_Anfahren == 0 && manoever.select_Lenkwinkelsprung == 0 && manoever.select_Kreisfahrt_beschl == 0 && manoever.select_sinus_lenken == 0 && manoever.select_Kundenfahrt_kurz == 0 && manoever.select_Kundenfahrt_lang == 0 && manoever.select_Hoechstgeschwindigkeit == 0)
%         errordlg('Bitte mindestens ein Fahrmanöver auswählen.','Fehlermeldung');
%     return
%     end


% Übergabe der eingelesenen Werte in den Workspace
assignin('base','manoever',manoever);

close Benutzeroberflaeche_Manoever;

% hObject    handle to start_simulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in traktion_low.
function traktion_low_Callback(hObject, eventdata, handles)
% hObject    handle to traktion_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of traktion_low


% --- Executes on button press in traktion_split.
function traktion_split_Callback(hObject, eventdata, handles)
% hObject    handle to traktion_split (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of traktion_split


% --- Executes on button press in WLTP_Zyklus_vektorisiert.
function WLTP_Zyklus_vektorisiert_Callback(hObject, eventdata, handles)
% hObject    handle to WLTP_Zyklus_vektorisiert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of WLTP_Zyklus_vektorisiert


% --- Executes on button press in checkbox_vmax.
function checkbox_vmax_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_vmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_vmax
