function varargout = rubik(varargin)
% RUBIK MATLAB code for rubik.fig
%      RUBIK, by itself, creates a new RUBIK or raises the existing
%      singleton*.
%
%      H = RUBIK returns the handle to a new RUB`IK or the handle to
%      the existing singleton*.
%
%      RUBIK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUBIK.M with the given input arguments.
%
%      RUBIK('Property','Value',...) creates a new RUBIK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rubik_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rubik_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rubik

% Last Modified by GUIDE v2.5 07-Dec-2016 22:29:29

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rubik_OpeningFcn, ...
                   'gui_OutputFcn',  @rubik_OutputFcn, ...
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


% --- Executes just before rubik is made visible.
function rubik_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rubik (see VARARGIN)

% Choose default command line output for rubik
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rubik wait for user response (see UIRESUME)
% uiwait(handles.RubikGui);


% --- Outputs from this function are returned to the command line.
function varargout = rubik_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in camStart.
function camStart_Callback(hObject, eventdata, handles)
% hObject    handle to camStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%setare camera
cam = videoinput('winvideo', 1, 'YUY2_640x480');
cam.FramesPerTrigger = 1;
cam.ReturnedColorspace = 'rgb';
triggerconfig(cam, 'manual');

%creeare handle camera
handles.cam = cam;
guidata(hObject, handles);

%preluare rezolutie camera
vidRes = get(cam, 'VideoResolution');
imWidth = vidRes(1);
imHeight = vidRes(2);
nBands = get(cam, 'NumberOfBands');

%afisare Preview camera in GUI
hImage = image(zeros(imHeight, imWidth, nBands), 'parent', handles.cameraAxes);
preview(cam, hImage);
%afisare mesaj in fereastra de rezultate din GUI
set(handles.edit1,'String','Start Camera');


% --- Executes on button press in camStop.
function camStop_Callback(hObject, eventdata, handles)
% hObject    handle to camStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cam = handles.cam;
%stop Preview camera din GUI
stoppreview(cam);
%afisare mesaj in fereastra de rezultate din GUI
set(handles.edit1,'String',['Stop Camera']);


% --- Executes on button press in camSnapshot.
function camSnapshot_Callback(hObject, eventdata, handles)
% hObject    handle to camSnapshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%afisare mesaj in fereastra de rezultate din GUI
set(handles.edit1,'String',['Snapshot']);

%preluare handle camera
cam = handles.cam;

%snapshot camera - imOriginala este imaginea cu care o sa lucram in
%continuare
imOriginala = getsnapshot(cam); 

%afisare snapshot in GUI
axes(handles.imagePreviewWindow)
imshow(imOriginala);

%construire imagine cu fundal uniform si preluarea doar a elementelor de 
%culoare rosie din imagine
%folosim diferenta imaginilor : functia imsubstract
%scad imaginea ce contine doar componentele rosii din imaginea originala
% transformata in grayscale
ImGray = imsubtract(imOriginala(:,:,1), rgb2gray(imOriginala));

%aplicam un filtru median de 9 elemente (3 linii si 3 coloane) pentru eliminarea zgomotului din fundal
ImFiltrata = medfilt2(ImGray, [3 3]);

%segmentarea imaginii
%pentru imaginile rubik1 si rubik2 se foloseste threshold 0.28
%pentru imaginile realx se foloseste threshold 0.18
ImBinara = im2bw(ImFiltrata, 0.18);

%afisare imgine segmentata in GUI
axes(handles.imageSegmentationWindow)
imshow(ImBinara);

%creeare handle ImBinara
handles.ImBinara = ImBinara;
handles.imOriginala = imOriginala;
guidata(hObject,handles);


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


% --- Executes on button press in confirmSnapshot.
function confirmSnapshot_Callback(hObject, eventdata, handles)
% hObject    handle to confirmSnapshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ImBinara = handles.ImBinara;

imOriginala = handles.imOriginala;

%etichtare obiecte din imagine
[labeled,nrObiecte]=bwlabel(ImBinara,4);

%determinare proprietati obiecte:Aria,Perimetru,Centroid si BoundingBox
proprietatiObiecte = regionprops(labeled,'Area','Perimeter','Centroid','BoundingBox');

%spatiuNegru - am determinat experimental ca spatiul dintre patratelele colorate ale
%cubului este de 42% din suprafata unui patratel
spatiuNegru = 0.42;

%consideram primul obiect gasit in imagine
%pentru buna functionare a programului acesta trebuie sa fie un patratel al
%cubului
Obiect1 = proprietatiObiecte(1);

%se determina latura aproximativa a patrateluli
latura = Obiect1.Perimeter/4;

%distantaMin reprezinta distanta dintre doi centroizi ai patratelelor
%cubului Rubik: 1/2 din latura + 1/2 din latura + 42% din spatiuNegru
distantaMin = latura + 0.42*latura;

%construirea unei matric: prima coloana - coordonatele pe x a centroizilor
%                     a doua coloana - coordonatele pe y a centroizilor
centroids = cat(1, proprietatiObiecte.Centroid);

%construirea unei matrici cu numar de linii egal cu numarul de obiecte si 8
%coloana
distante = zeros ((nrObiecte-1)*nrObiecte/2,8);

w = 1;

%calculare distante intre centroizii obiectelor 
%de exemplu pentru 3 obiecte calculam distantele 1-2,1-3,2-3
%dupa teste ulterioare am constatat ca este nevoie si calcularea inversa a
%acestor distante. Pentru exmplul de mai sus: 3-2,3-1,2-3
%in matricea distante punem pe coloana 1 obiectul de start de unde se
%calculeaza distanta
%pe coloana 2 elementul obiectul final
%pe coloana 3 valoare distantei
%pe coloanele 4 si 5 coordonatele centroidului obiectului de start
%pe coloanele 5 si 6 coordonatele centroidului obiectului final
for i=1:(nrObiecte-1)  
    for j=i+1:nrObiecte
         %folosind formula sqrt((x2-x1)^2+(y2-y1)^2) calculam distantele 
         dist = fix(sqrt((centroids(j,1)-centroids(i,1))^2 + (centroids(j,2)-centroids(i,2))^2));
         distante(w,:) = [i j dist centroids(i,1) centroids(i,2) centroids(j,1) centroids(j,2) -1];
         w = w+1;
    end
end 
for i=1:(nrObiecte-1)  
    for j=i+1:nrObiecte
         dist = fix(sqrt((centroids(j,1)-centroids(i,1))^2 + (centroids(j,2)-centroids(i,2))^2));
         distante(w,:) = [j i dist centroids(j,1) centroids(j,2) centroids(i,1) centroids(i,2) -1];
         w = w+1;
    end
end

%determinare dimensiuni matrice distante
[m,n] = size(distante);

%folosind distantele dintre obiecte putem determina in ca vecinatate a unui
%obiect se afla celalalt astfel:
%am considerat o marja de eroare de 20 la comparatia distantei cu distanta
%minima
for i=1:m
    %daca distanta este aproximativ egala cu distanta minima
    if distante(i,3) < distantaMin+20
        if abs(distante(i,6)-distante(i,4))<15 & distante(i,7) > distante(i,5)
            distante(i,8) = 6;
        end
        if abs(distante(i,6)-distante(i,4))<15 & distante(i,7) < distante(i,5)
            distante(i,8) = 2;
        end
        if abs(distante(i,5)-distante(i,7))<15 & distante(i,6) > distante(i,4)
            distante(i,8) = 0;
        end
        if abs(distante(i,5)-distante(i,7))<15 & distante(i,6) < distante(i,4)
            distante(i,8) = 4;
        end
    end
    %daca distanta este aproximativ egala cu distanta minima*radical din 2
    if distante(i,3) < distantaMin*sqrt(2)+20 & distante(i,3) > distantaMin+20
        if distante(i,6) > distante(i,4) & distante(i,7) < distante(i,5)
            distante(i,8) = 1;
        end
        if distante(i,6) < distante(i,4) & distante(i,7) < distante(i,5)
            distante(i,8) = 3;
        end
        if distante(i,6) < distante(i,4) & distante(i,7) > distante(i,5)
            distante(i,8) = 5;
        end
        if distante(i,6) > distante(i,4) & distante(i,7) > distante(i,5)
            distante(i,8) = 7;
        end
    end
    %daca distanta este mult mai mare decat distanta minima
    if distante(i,3) > distantaMin*sqrt(2)+20
        distante(i,8) = -1;
    end
end

%construim o matrice in care o sa mapam cubul astfel incat sa determinam
%cate linii complete si cate linii rosii sunt pe fata cubului
cubRubik = zeros(7,7);
cubRubik(4,4) = 1;

%construim o matrice cu coordonatele din cubul mapat a fiecarui obiect
coordonate = zeros(nrObiecte,3);
coordonate(1,:) = [1 4 4];

%parcurgem matricea distante si in functie de informatiile de acolo
%construim cubul mapat astfel
%Presupunem urmatoare linie din matricea distante
% 1.0000    2.0000   52.0000  494.3136  241.9598  496.6116  189.8969    2.0000
%din coloanele 1,2 si 8 deducem faptul ca in vecinatatea V2 a patratelului 1
%se afla patratelul 2
% 1.0000    3.0000   78.0000  494.3136  241.9598  553.6479  190.5161    1.0000
%din coloanele 1,2 si 8 deducem faptul ca in vecinatatea V1 a patratelului 1
%se afla patratelul 3,samd
for i=1:m
    es = distante(i,1);
    estop = distante(i,2);
    %coordonatele elementului de start
    pi = coordonate(es,2);
    pj = coordonate(es,3);
    if pi == 0 | pj ==0
        i=i+1;
        es = distante(i,1);
        estop = distante(i,2);
        pi = coordonate(es,2);
        pj = coordonate(es,3);
    end
    %Vecinatatea V0
    if distante(i,8) == 0
        cubRubik(pi,pj+1) = estop;
        coordonate(estop,:) = [estop pi pj+1];
    end
    %Vecinatatea V1
    if distante(i,8) == 1
        cubRubik(pi-1,pj+1) = estop;
        coordonate(estop,:) = [estop pi-1 pj+1];
    end
    %Vecinatatea V2
    if distante(i,8) == 2
        cubRubik(pi-1,pj) = estop;
        coordonate(estop,:) = [estop pi-1 pj];
    end
    %Vecinatatea V3
    if distante(i,8) == 3
        cubRubik(pi-1,pj-1) = estop;
        coordonate(estop,:) = [estop pi-1 pj-1];
    end
    %Vecinatatea V4
    if distante(i,8) == 4
        cubRubik(pi,pj-1) = estop;
        coordonate(estop,:) = [estop pi pj-1];
    end
    %Vecinatatea V5
    if distante(i,8) == 5
        cubRubik(pi+1,pj-1) = estop;
        coordonate(estop,:) = [estop pi+1 pj-1];
    end
    %Vecinatatea V6
    if distante(i,8) == 6
        cubRubik(pi+1,pj) = estop;
        coordonate(estop,:) = [estop pi+1 pj];
    end
    %Vecinatatea V7
    if distante(i,8) == 7
        cubRubik(pi+1,pj+1) = estop;
        coordonate(estop,:) = [estop pi+1 pj+1];
    end
end

contorC = 0;
contorL = 0;
coloaneComplete = 0;
liniiComplete = 0;

%parcurgem cubul mapat si determinam numarul de linii repectiv coloane
%complete
for i=1:7
    for j=1:7
        %numaram elementele de pe fiecare coloana
        if cubRubik(j,i) > 0 
            contorC = contorC + 1;
        end
        %numaram elementele de pe fiecare linie
        if cubRubik(i,j) > 0 
            contorL = contorL + 1;
        end
    end
    %daca avem coloana completa
    if contorC == 3
        coloaneComplete = coloaneComplete + 1;
        contorC = 0;
    end
     %daca avem linii completa
    if contorL == 3
        liniiComplete = liniiComplete + 1;
        contorL = 0;
    end
    contorC = 0;
    contorL = 0;
end

distante
cubRubik

%afisare imagine rezultat in GUI
axes(handles.imageSegmentationWindow);
imshow(imOriginala);
hold on

for i=1:7
    if (cubRubik(i,4) > 0 & cubRubik(i,5) > 0 & cubRubik(i,6) > 0)
        pos = cubRubik(i,4);
        rectangle('Position',[centroids(pos,1)-(latura/2), centroids(pos,2)-(latura/2), latura*4, latura],...
            'EdgeColor','b', 'LineWidth', 2);
    end
end

for j=1:7
    for i=1:5
        if (cubRubik(i,j) > 0 & cubRubik(i+1,j) > 0 & cubRubik(i+2,j) > 0)
            pos = cubRubik(i,j);
            rectangle('Position',[centroids(pos,1)-(latura/2), centroids(pos,2)-(latura/2), latura, latura*4],...
            'EdgeColor','b', 'LineWidth', 2);
        end
    end
end

cubRubik = zeros(7,7);

%afisare rezultate in consola MATLAB
X = sprintf('Numar coloane rosii complete: %d',coloaneComplete);
disp(X);
Y = sprintf('Numar linii rosii complete: %d',liniiComplete);
disp(Y);

%afisare rezultate in GUI
oldmsgs = cellstr(get(handles.edit1,'String'));
set(handles.edit1,'String',[oldmsgs;{'<------- Rezultate ------->'}]);
oldmsgs = cellstr(get(handles.edit1,'String'));
set(handles.edit1,'String',[oldmsgs;{X}]);
oldmsgs = cellstr(get(handles.edit1,'String'));
set(handles.edit1,'String',[oldmsgs;{Y}]);

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
