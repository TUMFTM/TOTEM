function varargout = Benutzeroberflaeche_Fahrzeugkonfiguration(varargin)
% Benutzeroberflaeche_Fahrzeugkonfiguration MATLAB code for Benutzeroberflaeche_Fahrzeugkonfiguration.fig
%      Benutzeroberflaeche_Fahrzeugkonfiguration, by itself, creates a new Benutzeroberflaeche_Fahrzeugkonfiguration or raises the existing
%      singleton*.
%
%      H = Benutzeroberflaeche_Fahrzeugkonfiguration returns the handle to a new Benutzeroberflaeche_Fahrzeugkonfiguration or the handle to
%      the existing singleton*.
%
%      Benutzeroberflaeche_Fahrzeugkonfiguration('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Benutzeroberflaeche_Fahrzeugkonfiguration.M with the given input arguments.
%
%      Benutzeroberflaeche_Fahrzeugkonfiguration('Property','Value',...) creates a new Benutzeroberflaeche_Fahrzeugkonfiguration or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Benutzeroberflaeche_Fahrzeugkonfiguration_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Benutzeroberflaeche_Fahrzeugkonfiguration_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Benutzeroberflaeche_Fahrzeugkonfiguration

% Last Modified by GUIDE v2.5 29-Nov-2018 10:20:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Benutzeroberflaeche_Fahrzeugkonfiguration_OpeningFcn, ...
                   'gui_OutputFcn',  @Benutzeroberflaeche_Fahrzeugkonfiguration_OutputFcn, ...
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


% --- Executes just before Benutzeroberflaeche_Fahrzeugkonfiguration is made visible.
function Benutzeroberflaeche_Fahrzeugkonfiguration_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Benutzeroberflaeche_Fahrzeugkonfiguration (see VARARGIN)
axes(gca)
[img, map, alphachannel] = imread('TOTEM logo.png');
image(img, 'AlphaData', alphachannel);
axis off
axis image

% Choose default command line output for Benutzeroberflaeche_Fahrzeugkonfiguration
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Benutzeroberflaeche_Fahrzeugkonfiguration wait for user response (see UIRESUME)
% uiwait(handles.Benutzeroberflaeche_Fahrzeugkonfiguration);


% --- Outputs from this function are returned to the command line.
function varargout = Benutzeroberflaeche_Fahrzeugkonfiguration_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on selection change in Konfiguration_VA.
function Konfiguration_VA_Callback(hObject, eventdata, handles)
Konfi_VA = get(handles.Konfiguration_VA,'Value');
% if-Schleife: sperrt je nach Auswahl bei "Konfiguration_VA" die
% Eingabemöglichkeiten bei "Torque Vectoring System VA".
%     if(Konfi_VA == 1 || Konfi_VA == 2 || Konfi_VA == 3 || Konfi_VA == 5)
%                        set(handles.delta_M_max_VA, 'enable', 'off');
%                        set(handles.delta_M_max_VA, 'string', '');
%     elseif(Konfi_VA == 4)   
%                        set(handles.delta_M_max_VA, 'enable', 'on');
%     end

% hObject    handle to Konfiguration_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Konfiguration_VA contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Konfiguration_VA


% --- Executes during object creation, after setting all properties.
function Konfiguration_VA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Konfiguration_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 

% --- Executes on selection change in Konfiguration_HA.
function Konfiguration_HA_Callback(hObject, eventdata, handles)
Konfi_HA = get(handles.Konfiguration_HA,'Value');
% if-Schleife: sperrt je nach Auswahl bei "Konfiguration_HA" die
% Eingabemöglichkeiten bei "Torque Vectoring System HA".
%     if(Konfi_HA == 1 || Konfi_HA == 2 || Konfi_HA == 3 || Konfi_HA == 5)
%                        set(handles.delta_M_max_HA, 'enable', 'off');
%                        set(handles.delta_M_max_HA, 'string', '');
%     elseif(Konfi_HA == 4)  
%                        set(handles.delta_M_max_HA, 'enable', 'on');
%     end
% hObject    handle to Konfiguration_HA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Konfiguration_HA contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Konfiguration_HA


% --- Executes during object creation, after setting all properties.
function Konfiguration_HA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Konfiguration_HA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in typ_EM_VA.
function typ_EM_VA_Callback(hObject, eventdata, handles)
% hObject    handle to typ_EM_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns typ_EM_VA contents as cell array
%        contents{get(hObject,'Value')} returns selected item from typ_EM_VA


% --- Executes during object creation, after setting all properties.
function typ_EM_VA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to typ_EM_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in typ_EM_HA.
function typ_EM_HA_Callback(hObject, eventdata, handles)
% hObject    handle to typ_EM_HA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns typ_EM_HA contents as cell array
%        contents{get(hObject,'Value')} returns selected item from typ_EM_HA


% --- Executes during object creation, after setting all properties.
function typ_EM_HA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to typ_EM_HA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in typ_EM_Steuer_VA.
function typ_EM_Steuer_VA_Callback(hObject, eventdata, handles)
% hObject    handle to typ_EM_Steuer_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns typ_EM_Steuer_VA contents as cell array
%        contents{get(hObject,'Value')} returns selected item from typ_EM_Steuer_VA


% --- Executes during object creation, after setting all properties.
function typ_EM_Steuer_VA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to typ_EM_Steuer_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in typ_EM_Steuer_HA.
function typ_EM_Steuer_HA_Callback(hObject, eventdata, handles)
% hObject    handle to typ_EM_Steuer_HA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns typ_EM_Steuer_HA contents as cell array
%        contents{get(hObject,'Value')} returns selected item from typ_EM_Steuer_HA


% --- Executes during object creation, after setting all properties.
function typ_EM_Steuer_HA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to typ_EM_Steuer_HA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in n_gears_VA.
function n_gears_VA_Callback(hObject, eventdata, handles)
gears_VA = get(handles.n_gears_VA,'Value');
% if-Schleife ermöglicht je nach Auswahl der Ganganzahl an der Vorderachse
% die benötigten Eingabemöglichkeiten zu den Übersetzungen an dieser Achse.
% Außerdem werden bereits getätigte Eingaben bei den Übersetzungen an der
% Vorderachse gelöscht, falls diese durch die Wahl einer neuen Ganganzahl
% nicht mehr benötigt werden.
    if(gears_VA == 1)       set(handles.i_gear1_VA, 'enable', 'off');
                            set(handles.i_gear1_VA, 'string', '');
                            set(handles.i_gear2_VA, 'enable', 'off');
                            set(handles.i_gear2_VA, 'string', '');
    elseif(gears_VA == 2)   set(handles.i_gear1_VA, 'enable', 'on');    
                            set(handles.i_gear2_VA, 'enable', 'off');
                            set(handles.i_gear2_VA, 'string', '');
    elseif(gears_VA == 3)   set(handles.i_gear1_VA, 'enable', 'on');    
                            set(handles.i_gear2_VA, 'enable', 'on');
    end
% hObject    handle to n_gears_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns n_gears_VA contents as cell array
%        contents{get(hObject,'Value')} returns selected item from n_gears_VA


% --- Executes during object creation, after setting all properties.
function n_gears_VA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n_gears_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in n_gears_HA.
function n_gears_HA_Callback(hObject, eventdata, handles)
gears_HA = get(handles.n_gears_HA,'Value');
% if-Schleife ermöglicht je nach Auswahl der Ganganzahl an der Hinterachse
% die benötigten Eingabemöglichkeiten zu den Übersetzungen an dieser Achse.
% Außerdem werden bereits getätigte Eingaben bei den Übersetzungen an der
% Hinterachse gelöscht, falls diese durch die Wahl einer neuen Ganganzahl
% nicht mehr benötigt werden.
    if(gears_HA == 1)       set(handles.i_gear1_HA, 'enable', 'off');
                            set(handles.i_gear1_HA, 'string', '');
                            set(handles.i_gear2_HA, 'enable', 'off');
                            set(handles.i_gear2_HA, 'string', '');
    elseif(gears_HA == 2)   set(handles.i_gear1_HA, 'enable', 'on');    
                            set(handles.i_gear2_HA, 'enable', 'off');
                            set(handles.i_gear2_HA, 'string', '');
    elseif(gears_HA == 3)   set(handles.i_gear1_HA, 'enable', 'on');    
                            set(handles.i_gear2_HA, 'enable', 'on');
    end
% hObject    handle to n_gears_HA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns n_gears_HA contents as cell array
%        contents{get(hObject,'Value')} returns selected item from n_gears_HA


% --- Executes during object creation, after setting all properties.
function n_gears_HA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n_gears_HA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Mnenn_achs_VA_Callback(hObject, eventdata, handles)
Mnenn_achs_VA = get(handles.Mnenn_achs_VA,'string');
% Kontrolle, ob eine gültige Zahl eingegeben wurde. Gültige Zahlen müssen
% das Format 'Ziffern_vor_dem_Komma.Ziffern_nach_dem_Komma' aufweisen,
% beispielsweise also '1.1'. Die Eingabe von ganzen Zahlen ist ebenfalls
% erlaubt. Zusätzlich zu den genannten Einschränkungen sind außerdem nur
% positive Zahlen oder die Null erlaubt. Bei Eingabe einer nicht gültigen
% Zahl wird eine Fehlermeldung ausgegeben und die ungültige Eingabe
% automatisch gelöscht.
ist_zahl = regexp(Mnenn_achs_VA ,'^(\d)+(\.(\d)*)?$|^\.(\d)+$');
    if((isempty(ist_zahl) == 1) && (isempty(Mnenn_achs_VA) == 0))
        set(handles.Mnenn_achs_VA, 'string', '');
        errordlg('Ungültige Eingabe! Bitte eine gültige Zahl eingeben.','Fehlermeldung');
    return
    end
% hObject    handle to Mnenn_achs_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Mnenn_achs_VA as text
%        str2double(get(hObject,'String')) returns contents of Mnenn_achs_VA as a double


% --- Executes during object creation, after setting all properties.
function Mnenn_achs_VA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mnenn_achs_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function nmax_VA_Callback(hObject, eventdata, handles)
nmax_VA = get(handles.nmax_VA,'string');
% Kontrolle, ob eine gültige Zahl eingegeben wurde. Gültige Zahlen müssen
% das Format 'Ziffern_vor_dem_Komma.Ziffern_nach_dem_Komma' aufweisen,
% beispielsweise also '1.1'. Die Eingabe von ganzen Zahlen ist ebenfalls
% erlaubt. Zusätzlich zu den genannten Einschränkungen sind außerdem nur
% positive Zahlen oder die Null erlaubt. Bei Eingabe einer nicht gültigen
% Zahl wird eine Fehlermeldung ausgegeben und die ungültige Eingabe
% automatisch gelöscht.
ist_zahl = regexp(nmax_VA ,'^(\d)+(\.(\d)*)?$|^\.(\d)+$');
    if((isempty(ist_zahl) == 1) && (isempty(nmax_VA) == 0))
        set(handles.nmax_VA, 'string', '');
        errordlg('Ungültige Eingabe! Bitte eine gültige Zahl eingeben.','Fehlermeldung');
    return
    end
% hObject    handle to nmax_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nmax_VA as text
%        str2double(get(hObject,'String')) returns contents of nmax_VA as a double


% --- Executes during object creation, after setting all properties.
function nmax_VA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nmax_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Mnenn_achs_HA_Callback(hObject, eventdata, handles)
Mnenn_achs_HA = get(handles.Mnenn_achs_HA,'string');
% Kontrolle, ob eine gültige Zahl eingegeben wurde. Gültige Zahlen müssen
% das Format 'Ziffern_vor_dem_Komma.Ziffern_nach_dem_Komma' aufweisen,
% beispielsweise also '1.1'. Die Eingabe von ganzen Zahlen ist ebenfalls
% erlaubt. Zusätzlich zu den genannten Einschränkungen sind außerdem nur
% positive Zahlen oder die Null erlaubt. Bei Eingabe einer nicht gültigen
% Zahl wird eine Fehlermeldung ausgegeben und die ungültige Eingabe
% automatisch gelöscht.
ist_zahl = regexp(Mnenn_achs_HA ,'^(\d)+(\.(\d)*)?$|^\.(\d)+$');
    if((isempty(ist_zahl) == 1) && (isempty(Mnenn_achs_HA) == 0))
        set(handles.Mnenn_achs_HA, 'string', '');
        errordlg('Ungültige Eingabe! Bitte eine gültige Zahl eingeben.','Fehlermeldung');
    return
    end
% hObject    handle to Mnenn_achs_HA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Mnenn_achs_HA as text
%        str2double(get(hObject,'String')) returns contents of Mnenn_achs_HA as a double


% --- Executes during object creation, after setting all properties.
function Mnenn_achs_HA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mnenn_achs_HA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function nmax_HA_Callback(hObject, eventdata, handles)
nmax_HA = get(handles.nmax_HA,'string');
% Kontrolle, ob eine gültige Zahl eingegeben wurde. Gültige Zahlen müssen
% das Format 'Ziffern_vor_dem_Komma.Ziffern_nach_dem_Komma' aufweisen,
% beispielsweise also '1.1'. Die Eingabe von ganzen Zahlen ist ebenfalls
% erlaubt. Zusätzlich zu den genannten Einschränkungen sind außerdem nur
% positive Zahlen oder die Null erlaubt. Bei Eingabe einer nicht gültigen
% Zahl wird eine Fehlermeldung ausgegeben und die ungültige Eingabe
% automatisch gelöscht.
ist_zahl = regexp(nmax_HA ,'^(\d)+(\.(\d)*)?$|^\.(\d)+$');
    if((isempty(ist_zahl) == 1) && (isempty(nmax_HA) == 0))
        set(handles.nmax_HA, 'string', '');
        errordlg('Ungültige Eingabe! Bitte eine gültige Zahl eingeben.','Fehlermeldung');
    return
    end
% hObject    handle to nmax_HA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nmax_HA as text
%        str2double(get(hObject,'String')) returns contents of nmax_HA as a double


% --- Executes during object creation, after setting all properties.
function nmax_HA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nmax_HA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function Mnenn_Steuer_VA_Callback(hObject, eventdata, handles)
% hObject    handle to Mnenn_Steuer_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Mnenn_Steuer_VA as text
%        str2double(get(hObject,'String')) returns contents of Mnenn_Steuer_VA as a double


% --- Executes during object creation, after setting all properties.
function Mnenn_Steuer_VA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mnenn_Steuer_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function nmax_Steuer_VA_Callback(hObject, eventdata, handles)
% hObject    handle to nmax_Steuer_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nmax_Steuer_VA as text
%        str2double(get(hObject,'String')) returns contents of nmax_Steuer_VA as a double


% --- Executes during object creation, after setting all properties.
function nmax_Steuer_VA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nmax_Steuer_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function i_gear1_VA_Callback(hObject, eventdata, handles)
i_gear1_VA = get(handles.i_gear1_VA,'string');
% Kontrolle, ob eine gültige Zahl eingegeben wurde. Gültige Zahlen müssen
% das Format 'Ziffern_vor_dem_Komma.Ziffern_nach_dem_Komma' aufweisen,
% beispielsweise also '1.1'. Die Eingabe von ganzen Zahlen ist ebenfalls
% erlaubt. Zusätzlich zu den genannten Einschränkungen sind außerdem nur
% positive Zahlen oder die Null erlaubt. Bei Eingabe einer nicht gültigen
% Zahl wird eine Fehlermeldung ausgegeben und die ungültige Eingabe
% automatisch gelöscht.
ist_zahl = regexp(i_gear1_VA ,'^(\d)+(\.(\d)*)?$|^\.(\d)+$');
    if((isempty(ist_zahl) == 1) && (isempty(i_gear1_VA) == 0))
        set(handles.i_gear1_VA, 'string', '');
        errordlg('Ungültige Eingabe! Bitte eine gültige Zahl eingeben.','Fehlermeldung');
    return
    end
% hObject    handle to i_gear1_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of i_gear1_VA as text
%        str2double(get(hObject,'String')) returns contents of i_gear1_VA as a double


% --- Executes during object creation, after setting all properties.
function i_gear1_VA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to i_gear1_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function i_gear2_VA_Callback(hObject, eventdata, handles)
i_gear2_VA = get(handles.i_gear2_VA,'string');
% Kontrolle, ob eine gültige Zahl eingegeben wurde. Gültige Zahlen müssen
% das Format 'Ziffern_vor_dem_Komma.Ziffern_nach_dem_Komma' aufweisen,
% beispielsweise also '1.1'. Die Eingabe von ganzen Zahlen ist ebenfalls
% erlaubt. Zusätzlich zu den genannten Einschränkungen sind außerdem nur
% positive Zahlen oder die Null erlaubt. Bei Eingabe einer nicht gültigen
% Zahl wird eine Fehlermeldung ausgegeben und die ungültige Eingabe
% automatisch gelöscht.
ist_zahl = regexp(i_gear2_VA ,'^(\d)+(\.(\d)*)?$|^\.(\d)+$');
    if((isempty(ist_zahl) == 1) && (isempty(i_gear2_VA) == 0))
        set(handles.i_gear2_VA, 'string', '');
        errordlg('Ungültige Eingabe! Bitte eine gültige Zahl eingeben.','Fehlermeldung');
    return
    end
% hObject    handle to i_gear2_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of i_gear2_VA as text
%        str2double(get(hObject,'String')) returns contents of i_gear2_VA as a double


% --- Executes during object creation, after setting all properties.
function i_gear2_VA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to i_gear2_VA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function i_gear1_HA_Callback(hObject, eventdata, handles)
i_gear1_HA = get(handles.i_gear1_HA,'string');
% Kontrolle, ob eine gültige Zahl eingegeben wurde. Gültige Zahlen müssen
% das Format 'Ziffern_vor_dem_Komma.Ziffern_nach_dem_Komma' aufweisen,
% beispielsweise also '1.1'. Die Eingabe von ganzen Zahlen ist ebenfalls
% erlaubt. Zusätzlich zu den genannten Einschränkungen sind außerdem nur
% positive Zahlen oder die Null erlaubt. Bei Eingabe einer nicht gültigen
% Zahl wird eine Fehlermeldung ausgegeben und die ungültige Eingabe
% automatisch gelöscht.
ist_zahl = regexp(i_gear1_HA ,'^(\d)+(\.(\d)*)?$|^\.(\d)+$');
    if((isempty(ist_zahl) == 1) && (isempty(i_gear1_HA) == 0))
        set(handles.i_gear1_HA, 'string', '');
        errordlg('Ungültige Eingabe! Bitte eine gültige Zahl eingeben.','Fehlermeldung');
    return
    end
% hObject    handle to i_gear1_HA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of i_gear1_HA as text
%        str2double(get(hObject,'String')) returns contents of i_gear1_HA as a double


% --- Executes during object creation, after setting all properties.
function i_gear1_HA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to i_gear1_HA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function i_gear2_HA_Callback(hObject, eventdata, handles)
i_gear2_HA = get(handles.i_gear2_HA,'string');
% Kontrolle, ob eine gültige Zahl eingegeben wurde. Gültige Zahlen müssen
% das Format 'Ziffern_vor_dem_Komma.Ziffern_nach_dem_Komma' aufweisen,
% beispielsweise also '1.1'. Die Eingabe von ganzen Zahlen ist ebenfalls
% erlaubt. Zusätzlich zu den genannten Einschränkungen sind außerdem nur
% positive Zahlen oder die Null erlaubt. Bei Eingabe einer nicht gültigen
% Zahl wird eine Fehlermeldung ausgegeben und die ungültige Eingabe
% automatisch gelöscht.
ist_zahl = regexp(i_gear2_HA ,'^(\d)+(\.(\d)*)?$|^\.(\d)+$');
    if((isempty(ist_zahl) == 1) && (isempty(i_gear2_HA) == 0))
        set(handles.i_gear2_HA, 'string', '');
        errordlg('Ungültige Eingabe! Bitte eine gültige Zahl eingeben.','Fehlermeldung');
    return
    end
% hObject    handle to i_gear2_HA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of i_gear2_HA as text
%        str2double(get(hObject,'String')) returns contents of i_gear2_HA as a double


% --- Executes during object creation, after setting all properties.
function i_gear2_HA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to i_gear2_HA (see GCBO)
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


function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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


function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Button_Werte_uebernehmen.
function Button_Werte_uebernehmen_Callback(hObject, eventdata, handles)
%% Überprüfen der Eingaben auf Vollständigkeit
% Überprüfen, ob die Eingabe vollständig ist. Eine vollständige Eingabe
% bedeutet, dass alle für die jeweils gewählte Fahrzeugkonfiguration
% notwendigen Eingaben vorhanden sind.

% Überprüfen der Muss-Eingaben
Fahrzeugsegment = get(handles.Fahrzeugklasse,'Value');
Konfig_VA = get(handles.Konfiguration_VA,'Value');
Konfig_HA = get(handles.Konfiguration_HA,'Value');
typ_EM_VA = get(handles.typ_EM_VA,'Value');
typ_EM_HA = get(handles.typ_EM_HA,'Value');
n_gears_VA = get(handles.n_gears_VA,'Value');
n_gears_HA = get(handles.n_gears_HA,'Value');
Mnenn_achs_VA = get(handles.Mnenn_achs_VA,'string');
Mnenn_achs_HA = get(handles.Mnenn_achs_HA,'string');
nmax_VA = get(handles.nmax_VA,'string');
nmax_HA = get(handles.nmax_HA,'string');
% Ausgabe einer Fehlermeldung, falls unvollständige Eingabe vorliegt:
    if(Fahrzeugsegment == 1 || typ_EM_VA == 1 || typ_EM_HA == 1 || n_gears_VA == 1 || n_gears_HA == 1  || isempty(Mnenn_achs_VA) == 1 || isempty(Mnenn_achs_HA) == 1 || isempty(nmax_VA) == 1 || isempty(nmax_HA) == 1 )
        errordlg('Unvollständige Eingabe! Bitte Eingabe vervollständigen.','Fehlermeldung');
    return
    end

% Überprüfen der Eingaben zu TV_Vorderachse
Konfig_VA = get(handles.Konfiguration_VA,'Value');
    
% Überprüfen der Eingaben zu TV_Hinterachse
Konfig_HA = get(handles.Konfiguration_HA,'Value');


% Überprüfen der Eingaben zu Hauptgetriebe_VA
gears_VA = get(handles.n_gears_VA,'Value');
i_gear1_VA = get(handles.i_gear1_VA,'string');
i_gear2_VA = get(handles.i_gear2_VA,'string');
% Ausgabe einer Fehlermeldung, falls unvollständige Eingabe vorliegt:
    if((gears_VA == 2 && isempty(i_gear1_VA) == 1) || (gears_VA == 3 && (isempty(i_gear1_VA) == 1 || isempty(i_gear2_VA)) == 1) )
        errordlg('Unvollständige Eingabe! Bitte Eingabe vervollständigen.','Fehlermeldung');
    return
    end
    
% Überprüfen der Eingaben zu Hauptgetriebe_HA
gears_HA = get(handles.n_gears_HA,'Value');
i_gear1_HA = get(handles.i_gear1_HA,'string');
i_gear2_HA = get(handles.i_gear2_HA,'string');
% Ausgabe einer Fehlermeldung, falls unvollständige Eingabe vorliegt:
    if((gears_HA == 2 && isempty(i_gear1_HA) == 1) || (gears_HA == 3 && (isempty(i_gear1_HA) == 1 || isempty(i_gear2_HA)) == 1))
        errordlg('Unvollständige Eingabe! Bitte Eingabe vervollständigen.','Fehlermeldung');
    return
    end

    
    



%% Überprüfen, ob die Übersetzungen mit steigender Gangzahl kleiner werden
% Vorderachse
gears_VA = get(handles.n_gears_VA,'Value');
i_gear1_VA = str2double(get(handles.i_gear1_VA,'string'));
i_gear2_VA = str2double(get(handles.i_gear2_VA,'string'));
% Ausgabe einer Fehlermeldung, falls die Übersetzungen mit steigender
% Gangzahl zunehmen oder gleich bleiben
    if(gears_VA == 3 && i_gear1_VA <= i_gear2_VA)
        errordlg('Unplausibilität Hauptgetriebe Vorderachse: Übersetzung muss mit steigender Gangzahl kleiner werden.','Fehlermeldung');
    return
    end
    
    
% Hinterachse
gears_HA = get(handles.n_gears_HA,'Value');
i_gear1_HA = str2double(get(handles.i_gear1_HA,'string'));
i_gear2_HA = str2double(get(handles.i_gear2_HA,'string'));
% Ausgabe einer Fehlermeldung, falls die Übersetzungen mit steigender
% Gangzahl zunehmen oder gleich bleiben
    if(gears_HA == 3 && i_gear1_HA <= i_gear2_HA)
        errordlg('Unplausibilität Hauptgetriebe Hinterachse: Übersetzung muss mit steigender Gangzahl kleiner werden.','Fehlermeldung');
    return
    end
    

%% Auslesen der getätigten Eingaben
% Wurde bei einem Feld keine Eingabe vorgenommen, wird das entsprechende
% Feld mit einem Default Wert belegt, damit "Nutzerkonfiguration_Fzg"
% problemlos ausgeführt werden kann.

% Auslesen der Eingabe für Fahrzeugklasse (A, B, C und T möglich):
Fahrzeugsegment = get(handles.Fahrzeugklasse, 'Value');
if(Fahrzeugsegment == 2)        Segment = 'A';
elseif(Fahrzeugsegment == 3)    Segment = 'B';
elseif(Fahrzeugsegment == 4)    Segment = 'C';
elseif(Fahrzeugsegment == 5)    Segment = 'T';
end


% Auslesen der Eingabe für Konfiguration_Vorderachse:
Konfig_VA = get(handles.Konfiguration_VA,'Value');
% Ableiten der Fahrzeugkonfiguration_VA im Detail (achszentraler
% Antrieb oder radnaher Antrieb; im achszemtralen Fall: OD, eTV oder TS):
        if(Konfig_VA == 1)      config.akt.rn_VA = 0; config.akt.az_VA = 0; config.akt.OD_VA = 0; config.akt.eTV_VA = 0; config.akt.TS_VA = 0;
        elseif(Konfig_VA == 2)  config.akt.rn_VA = 1; config.akt.az_VA = 0; config.akt.OD_VA = 0; config.akt.eTV_VA = 0; config.akt.TS_VA = 0;
        elseif(Konfig_VA == 3)  config.akt.rn_VA = 0; config.akt.az_VA = 1; config.akt.OD_VA = 1; config.akt.eTV_VA = 0; config.akt.TS_VA = 0;
        elseif(Konfig_VA == 4)  config.akt.rn_VA = 0; config.akt.az_VA = 1; config.akt.OD_VA = 0; config.akt.eTV_VA = 1; config.akt.TS_VA = 0;
        elseif(Konfig_VA == 5)  config.akt.rn_VA = 0; config.akt.az_VA = 1; config.akt.OD_VA = 0; config.akt.eTV_VA = 0; config.akt.TS_VA = 1;
        end
        
% Auslesen der Eingabe für Konfiguration_Hinterachse:
Konfig_HA = get(handles.Konfiguration_HA,'Value');
% Ableiten der Fahrzeugkonfiguration_HA im Detail (achszentraler
% Antrieb oder radnaher Antrieb; im achszemtralen Fall: OD, eTV oder TS):
        if(Konfig_HA == 1)      config.akt.rn_HA = 0; config.akt.az_HA = 0; config.akt.OD_HA = 0; config.akt.eTV_HA = 0; config.akt.TS_HA = 0;
        elseif(Konfig_HA == 2)  config.akt.rn_HA = 1; config.akt.az_HA = 0; config.akt.OD_HA = 0; config.akt.eTV_HA = 0; config.akt.TS_HA = 0;
        elseif(Konfig_HA == 3)  config.akt.rn_HA = 0; config.akt.az_HA = 1; config.akt.OD_HA = 1; config.akt.eTV_HA = 0; config.akt.TS_HA = 0;        
        elseif(Konfig_HA == 4)  config.akt.rn_HA = 0; config.akt.az_HA = 1; config.akt.OD_HA = 0; config.akt.eTV_HA = 1; config.akt.TS_HA = 0;
        elseif(Konfig_HA == 5)  config.akt.rn_HA = 0; config.akt.az_HA = 1; config.akt.OD_HA = 0; config.akt.eTV_HA = 0; config.akt.TS_HA = 1;   
        end

% Auslesen der Eingaben zu den elektrischen Maschinen:
typ_EM_VA_input = get(handles.typ_EM_VA,'Value');
        if(typ_EM_VA_input == 2)        config.em.typ_EM_VA = 'ASM';
        elseif(typ_EM_VA_input == 3)    config.em.typ_EM_VA = 'PSM';
        end
        
typ_EM_HA_input = get(handles.typ_EM_HA,'Value');
        if(typ_EM_HA_input == 2)        config.em.typ_EM_HA = 'ASM';
        elseif(typ_EM_HA_input == 3)    config.em.typ_EM_HA = 'PSM';
        end
        
Mnenn_achs_VA_input = str2double(get(handles.Mnenn_achs_VA,'string'));

config.em.Mnenn_achs_VA = Mnenn_achs_VA_input;

    
Mnenn_achs_HA_input = str2double(get(handles.Mnenn_achs_HA,'string'));

config.em.Mnenn_achs_HA = Mnenn_achs_HA_input;

    
config.em.nmax_VA = str2double(get(handles.nmax_VA,'string'));
   
config.em.nmax_HA = str2double(get(handles.nmax_HA,'string'));

if(Konfig_VA == 4)  config.etv.delta_M_max_VA = 576; %str2double(get(handles.delta_M_max_VA,'string'));
end
    
if(Konfig_HA == 4)  config.etv.delta_M_max_HA = 576; %str2double(get(handles.delta_M_max_HA,'string'));
end



% Auslesen der Eingaben zu den Getrieben:
gears_VA_input = get(handles.n_gears_VA,'Value');
if(gears_VA_input == 2)         config.trans.n_gears_VA = 1;
elseif(gears_VA_input == 3)     config.trans.n_gears_VA = 2;
elseif(gears_VA_input == 4)     config.trans.n_gears_VA = 3;
end

gears_HA_input = get(handles.n_gears_HA,'Value');
if(gears_HA_input == 2)         config.trans.n_gears_HA = 1;
elseif(gears_HA_input == 3)     config.trans.n_gears_HA = 2;
elseif(gears_HA_input == 4)     config.trans.n_gears_HA = 3;
end
        
i_gear1_VA = str2double(get(handles.i_gear1_VA,'string'));
i_gear2_VA = str2double(get(handles.i_gear2_VA,'string'));
i_gear1_HA = str2double(get(handles.i_gear1_HA,'string'));
i_gear2_HA = str2double(get(handles.i_gear2_HA,'string'));

if(config.trans.n_gears_VA == 1)     config.trans.i_gears_VA = [i_gear1_VA];
elseif(config.trans.n_gears_VA == 2) config.trans.i_gears_VA = [i_gear1_VA, i_gear2_VA];
end  

if(config.trans.n_gears_HA == 1)     config.trans.i_gears_HA = [i_gear1_HA];
elseif(config.trans.n_gears_HA == 2) config.trans.i_gears_HA = [i_gear1_HA, i_gear2_HA];
end


% Übergabe der eingelesenen Werte an den Workspace
assignin('base','Segment',Segment);
assignin('base','config',config);


close Benutzeroberflaeche_Fahrzeugkonfiguration;

% hObject    handle to Button_Werte_uebernehmen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Text_6.
function Text_6_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Text_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
