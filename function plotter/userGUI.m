function varargout = userGUI(varargin)
% USERGUI MATLAB code for userGUI.fig
%      USERGUI, by itself, creates a new USERGUI or raises the existing
%      singleton*.
%
%      H = USERGUI returns the handle to a new USERGUI or the handle to
%      the existing singleton*.
%
%      USERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in USERGUI.M with the given input arguments.
%
%      USERGUI('Property','Value',...) creates a new USERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before userGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to userGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help userGUI

% Last Modified by GUIDE v2.5 20-Dec-2021 17:12:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @userGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @userGUI_OutputFcn, ...
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


% --- Executes just before userGUI is made visible.
function userGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to userGUI (see VARARGIN)

% Choose default command line output for userGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes userGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = userGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%initial error validating user input
function [error]=validateInput(handles)
error = false;
%set the error msg with empty string
set(handles.errMsg, 'string', '');
%check if the user entered empty function.
if (isempty(get(handles.user_function, 'string')))
    set(handles.errMsg, 'string', 'You need to enter an equation like: 3*x^4+6.1*x^3-2*x^2+3*x+2');
    error = true;
    return;
end
%check if the user entered empty start point.
if (isempty(get(handles.user_startPoint, 'string')))
    set(handles.errMsg, 'string', 'Start field is empty');
    error = true;
    return;
end
%check if the user entered empty end point.
if (isempty(get(handles.user_endPoint, 'string')))
    set(handles.errMsg, 'string', 'End field is empty');
    error = true;
    return;
end
%check if the user entered numerical start point.
if(isnan(str2double(get(handles.user_startPoint, 'string'))))
    error = true;
    set(handles.errMsg, 'string', 'Start point MUST be numerical values');
    return;
end
%check if the user entered numerical end point.
if(isnan(str2double(get(handles.user_endPoint, 'string'))))
    error = true;
    set(handles.errMsg, 'string', 'End point MUST be numerical values');
    return;
end
%check if start point < end point.
if (str2double(get(handles.user_endPoint, 'string')) - str2double(get(handles.user_startPoint, 'string')) < 0)
    set(handles.errMsg, 'string', 'Invalid Range Order Start > End');
    error = true;
    return;
end
%check if the start point not equal end point.
if (str2double(get(handles.user_endPoint, 'string')) - str2double(get(handles.user_startPoint, 'string')) == 0)
    set(handles.errMsg, 'string', 'Invalid Range Order Start = End');
    error = true;
    return;
end


function user_function_Callback(hObject, eventdata, handles)
% hObject    handle to user_function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of user_function as text
%        str2double(get(hObject,'String')) returns contents of user_function as a double


% --- Executes during object creation, after setting all properties.
function user_function_CreateFcn(hObject, eventdata, handles)
% hObject    handle to user_function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in user_enter.
function user_enter_Callback(hObject, eventdata, handles)
% hObject    handle to user_enter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~validateInput(handles))
    xmin = str2double(get(handles.user_startPoint, 'string'));
    xmax = str2double(get(handles.user_endPoint, 'string'));
    f = get(handles.user_function, 'string');
    try
        fx = inline(f);
        axes(handles.Axes);
        fplot(sym(f),[xmin xmax],'k');
        grid minor;
        hold on;
        zoom on;
        plot(xmin, fx(xmin),'r*');
        plot(xmax, fx(xmax),'r*');
        axes(handles.Axes);
    catch
        set(handles.errMsg, 'string', 'please check your function inputs');
    end
end


function user_startPoint_Callback(hObject, eventdata, handles)
% hObject    handle to user_startPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of user_startPoint as text
%        str2double(get(hObject,'String')) returns contents of user_startPoint as a double


% --- Executes during object creation, after setting all properties.
function user_startPoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to user_startPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function user_endPoint_Callback(hObject, eventdata, handles)
% hObject    handle to user_endPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of user_endPoint as text
%        str2double(get(hObject,'String')) returns contents of user_endPoint as a double


% --- Executes during object creation, after setting all properties.
function user_endPoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to user_endPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
