function varargout = AplicativoReconhecedorTexturas(varargin)
% APLICATIVORECONHECEDORDETEXTURAS MATLAB code for AplicativoReconhecedorDeTexturas.fig
%      APLICATIVORECONHECEDORDETEXTURAS, by itself, creates a new APLICATIVORECONHECEDORDETEXTURAS or raises the existing
%      singleton*.
%
%      H = APLICATIVORECONHECEDORDETEXTURAS returns the handle to a new APLICATIVORECONHECEDORDETEXTURAS or the handle to
%      the existing singleton*.
%
%      APLICATIVORECONHECEDORDETEXTURAS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APLICATIVORECONHECEDORDETEXTURAS.M with the given input arguments.
%
%      APLICATIVORECONHECEDORDETEXTURAS('Property','Value',...) creates a new APLICATIVORECONHECEDORDETEXTURAS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AplicativoReconhecedorDeTexturas_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AplicativoReconhecedorDeTexturas_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AplicativoReconhecedorDeTexturas

% Last Modified by GUIDE v2.5 16-Oct-2017 00:13:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @AplicativoReconhecedorDeTexturas_OpeningFcn, ...
    'gui_OutputFcn',  @AplicativoReconhecedorDeTexturas_OutputFcn, ...
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


% --- Executes just before AplicativoReconhecedorDeTexturas is made visible.
function AplicativoReconhecedorDeTexturas_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AplicativoReconhecedorDeTexturas (see VARARGIN)

% Choose default command line output for AplicativoReconhecedorDeTexturas
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AplicativoReconhecedorDeTexturas wait for user response (see UIRESUME)
% uiwait(handles.figure1);

atualiza_display (handles);

% --- Outputs from this function are returned to the command line.
function varargout = AplicativoReconhecedorDeTexturas_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SelecionarDiretorioBotao.
function SelecionarDiretorioBotao_Callback(hObject, eventdata, handles)
% hObject    handle to SelecionarDiretorioBotao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

config = [pwd, '\ConfiguracoesIniciais.mat'];

if exist(config) == 0
    diretorio_principal = pwd;
else
    load(config);
end

diretorio_principal = uigetdir(diretorio_principal);

if length(diretorio_principal) > 1
    p = dir(diretorio_principal);
    i_nome_base = 1;
    for ip = 1 : length(p)
        nome_pasta = p(ip).name;
        qtd_pontos = length(find(nome_pasta == '.'));
        if qtd_pontos == 0
            handles.popupmenu_bases.String{i_nome_base} = nome_pasta;
            i_nome_base = i_nome_base + 1;
        end
    end
    
    
    idx_nome_base = double(1);
    nome_base = handles.popupmenu_bases.String{1};
    save(config, 'nome_base', 'diretorio_principal', 'idx_nome_base');
    atualiza_display(handles);
end

% --- Executes on selection change in popupmenu_bases.
function popupmenu_bases_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_bases (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_bases contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_bases

config = [pwd, '\ConfiguracoesIniciais.mat'];

if exist(config)
    load(config);
    idx_nome_base = get(hObject,'Value');
    nome_base = handles.popupmenu_bases.String{idx_nome_base};
    save(config, 'nome_base', 'diretorio_principal', 'idx_nome_base');
    atualiza_display(handles);
end

% --- Executes during object creation, after setting all properties.
function popupmenu_bases_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_bases (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tam_sub_figuras_texto_Callback(hObject, eventdata, handles)
% hObject    handle to tam_sub_figuras_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tam_sub_figuras_texto as text
%        str2double(get(hObject,'String')) returns contents of tam_sub_figuras_texto as a double


% --- Executes during object creation, after setting all properties.
function tam_sub_figuras_texto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tam_sub_figuras_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function escala_imagem_original_texto_Callback(hObject, eventdata, handles)
% hObject    handle to escala_imagem_original_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of escala_imagem_original_texto as text
%        str2double(get(hObject,'String')) returns contents of escala_imagem_original_texto as a double


% --- Executes during object creation, after setting all properties.
function escala_imagem_original_texto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to escala_imagem_original_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Rmax_texto_Callback(hObject, eventdata, handles)
% hObject    handle to Rmax_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rmax_texto as text
%        str2double(get(hObject,'String')) returns contents of Rmax_texto as a double


% --- Executes during object creation, after setting all properties.
function Rmax_texto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rmax_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function N_sub_fig_analisadas_texto_Callback(hObject, eventdata, handles)
% hObject    handle to N_sub_fig_analisadas_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of N_sub_fig_analisadas_texto as text
%        str2double(get(hObject,'String')) returns contents of N_sub_fig_analisadas_texto as a double


% --- Executes during object creation, after setting all properties.
function N_sub_fig_analisadas_texto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to N_sub_fig_analisadas_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tam_Dim_min_reescala_texto_Callback(hObject, eventdata, handles)
% hObject    handle to Tam_Dim_min_reescala_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tam_Dim_min_reescala_texto as text
%        str2double(get(hObject,'String')) returns contents of Tam_Dim_min_reescala_texto as a double


% --- Executes during object creation, after setting all properties.
function Tam_Dim_min_reescala_texto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tam_Dim_min_reescala_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function Camadas_analisadas_texto_Callback(hObject, eventdata, handles)
% hObject    handle to Camadas_analisadas_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Camadas_analisadas_texto as text
%        str2double(get(hObject,'String')) returns contents of Camadas_analisadas_texto as a double


% --- Executes during object creation, after setting all properties.
function Camadas_analisadas_texto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Camadas_analisadas_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SalvarConfiguracoes.
function SalvarConfiguracoes_Callback(hObject, eventdata, handles)
% hObject    handle to SalvarConfiguracoes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('ConfiguracoesIniciais.mat');

dir_arquivos = [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\'];
dir_config = [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Configuracoes\'];
arquivo_config = [dir_config, 'ConfiguracoesAplicacao.mat'];

if exist(arquivo_config)
    load(arquivo_config);
    
    tam_sub_figuras_novo = str2num(handles.tam_sub_figuras_texto.String);
    escala_imagem_original_novo = str2num(handles.escala_imagem_original_texto.String);
    
    if tam_sub_figuras_novo ~= tam_sub_figuras || escala_imagem_original ~= escala_imagem_original_novo
        if exist(dir_arquivos)
            rmdir(dir_arquivos, 's')
        end
        mkdir(dir_config);
    else
        
        
        if exist([diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Base\'])
            comando = ['move "', [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Base'], '" "', [diretorio_principal, '\', nome_base, '\Base'], '"'];
            res = 1;
            while res ~= 0
                res = system(comando);
            end
        end
        
        if exist([diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Class\'])
            comando = ['move "', [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Class'], '" "', [diretorio_principal, '\', nome_base, '\Class'], '"'];
            res = 1;
            while res ~= 0
                res = system(comando);
            end
        end
        
        
        if exist(dir_arquivos)
            rmdir(dir_arquivos, 's')
        end
        mkdir(dir_config);
        
        if exist([diretorio_principal, '\', nome_base, '\Base\'])
            comando = ['move "', [diretorio_principal, '\', nome_base, '\Base'], '" "', [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Base'], '"'];
            res = 1;
            while res ~= 0
                res = system(comando);
            end
        end
        
        if exist([diretorio_principal, '\', nome_base, '\Class\'])
            comando = ['move "', [diretorio_principal, '\', nome_base, '\Class'], '" "', [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Class'], '"'];
            res = 1;
            while res ~= 0
                res = system(comando);
            end
        end
        
    end
    
else
    
    if exist(dir_arquivos)
        rmdir(dir_arquivos, 's')
    end
    mkdir(dir_config);
    
end

tam_sub_figuras = str2num(handles.tam_sub_figuras_texto.String);
escala_imagem_original = str2num(handles.escala_imagem_original_texto.String);
Camadas_analisadas = str2num(handles.Camadas_analisadas_texto.String);
Rmax = str2num(handles.Rmax_texto.String);
N_sub_fig_analisadas = str2num(handles.N_sub_fig_analisadas_texto.String);
Tam_Dim_min_reescala = str2num(handles.Tam_Dim_min_reescala_texto.String);

save([dir_config, 'ConfiguracoesAplicacao.mat'], 'tam_sub_figuras', 'escala_imagem_original', 'Camadas_analisadas', 'Rmax', 'N_sub_fig_analisadas', 'Tam_Dim_min_reescala');
dir_Testes = [diretorio_principal, '\', nome_base, '\Testes\'];
if exist(dir_Testes) == 0
    mkdir(dir_Testes);
end

dir_Bruto = [diretorio_principal, '\', nome_base, '\Bruto\'];
if exist(dir_Bruto) == 0
    mkdir(dir_Bruto);
end

atualiza_display (handles);

% --- Executes on button press in RenomearTestesBotao.
function RenomearTestesBotao_Callback(hObject, eventdata, handles)
% hObject    handle to RenomearTestesBotao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

config = [pwd, '\ConfiguracoesIniciais.mat'];

if exist(config)
    load(config);
    dir_testes = [diretorio_principal, '\', nome_base, '\Testes\'];
    if exist(dir_testes)
        winopen(dir_testes);
    else
        mkdir(dir_testes);
    end
end

Renomear_Testes;

atualiza_display (handles);

% --- Executes on button press in ReescalarTestesBotao.
function ReescalarTestesBotao_Callback(hObject, eventdata, handles)
% hObject    handle to ReescalarTestesBotao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

config = [pwd, '\ConfiguracoesIniciais.mat'];

if exist(config)
    load(config);
    dir_testes = [diretorio_principal, '\', nome_base, '\Testes\'];
    if exist(dir_testes)
        winopen(dir_testes);
    else
        mkdir(dir_testes);
    end
end

Reescala_Testes;

atualiza_display (handles);

% --- Executes on button press in GerarBase0.
function GerarBase0_Callback(hObject, eventdata, handles)
% hObject    handle to GerarBase0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a1_CriadorBaseTextura_SubPastas;

atualiza_display (handles);

% --- Executes on button press in GerarDescritoresBotao0.
function GerarDescritoresBotao0_Callback(hObject, eventdata, handles)
% hObject    handle to GerarDescritoresBotao0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a2_GerarDescritores;

atualiza_display (handles);

% --- Executes on button press in ReconhecerTestesBotao0.
function ReconhecerTestesBotao0_Callback(hObject, eventdata, handles)
% hObject    handle to ReconhecerTestesBotao0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

config = [pwd, '\ConfiguracoesIniciais.mat'];

if exist(config)
    load(config);
    dir_testes = [diretorio_principal, '\', nome_base, '\Testes\'];
    if exist(dir_testes)
        winopen(dir_testes);
    else
        mkdir(dir_testes);
    end
end

a4_AplicativoReconhecedor;

atualiza_display (handles);


% --- Executes on button press in FazTudoBotao0.
function FazTudoBotao0_Callback(hObject, eventdata, handles)
% hObject    handle to FazTudoBotao0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a1_CriadorBaseTextura_SubPastas;

fprintf('Terminando de criar as bases\n');

a2_GerarDescritores;

atualiza_display (handles);

function atualiza_display (handles)

config = [pwd, '\ConfiguracoesIniciais.mat'];

if exist(config)
    load(config);
    handles.DiretorioBase_texto.String = diretorio_principal;
    dir_config = [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Configuracoes\'];
    
    p = dir(diretorio_principal);
    i_nome_base = 1;
    for ip = 1 : length(p)
        nome_pasta = p(ip).name;
        qtd_pontos = length(find(nome_pasta == '.'));
        if qtd_pontos == 0
            handles.popupmenu_bases.String{i_nome_base} = nome_pasta;
            i_nome_base = i_nome_base + 1;
        end
    end
    handles.popupmenu_bases.Value = double(idx_nome_base);
    
    arquivo_configuracoes = [dir_config, 'ConfiguracoesAplicacao.mat'];
    if exist(arquivo_configuracoes)
        handles.FazTudoBotao0.Enable = 'on';
        
        load(arquivo_configuracoes);
        handles.tam_sub_figuras_texto.String = num2str(tam_sub_figuras);
        handles.escala_imagem_original_texto.String = num2str(escala_imagem_original);
        handles.Camadas_analisadas_texto.String = num2str(Camadas_analisadas);
        handles.Rmax_texto.String = num2str(Rmax);
        handles.N_sub_fig_analisadas_texto.String = num2str(N_sub_fig_analisadas);
        handles.Tam_Dim_min_reescala_texto.String = num2str(Tam_Dim_min_reescala);
        
    else
        handles.FazTudoBotao0.Enable = 'off';
        handles.ReconhecerTestesBotao0.Enable = 'off';
        handles.GerarDescritoresBotao0.Enable = 'off';
        handles.GerarBaseBotao.Enable = 'off';
    end
    
    dir_Testes = [diretorio_principal, '\', nome_base, '\Testes\'];
    
    if exist(dir_Testes)
        handles.ReescalarTestes.Enable = 'on';
    else
        handles.ReescalarTestes.Enable = 'off';
    end
    
    dir_Bruto = [diretorio_principal, '\', nome_base, '\Bruto\'];
    if exist(dir_Bruto)
        handles.GerarBaseBotao.Enable = 'on';
    else
        handles.GerarBaseBotao.Enable = 'off';
    end
    
    dir_Base = [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Base\'];
    if exist(dir_Base)
        handles.GerarDescritoresBotao0.Enable = 'on';
    else
        handles.GerarDescritoresBotao0.Enable = 'off';
    end
    
    arquivo_otimizacao = [diretorio_principal, '\', nome_base, '\ArquivosDoPrograma\Otimizacao\Otimizacao.mat'];
    if exist(arquivo_otimizacao)
        handles.ReconhecerTestesBotao0.Enable = 'on';
        load(arquivo_otimizacao);
        
        handles.RateMaxGeral_texto.String = num2str(RateMaxGeral);
        handles.NCamadas_texto.String = num2str(Camadas_analisadas(idx_Camadas_RateMaxGeral));
        handles.n_atrib_RateMax_texto.String = num2str(n_atrib_RateMax);
    else
        handles.ReconhecerTestesBotao0.Enable = 'off';
        
        handles.RateMaxGeral_texto.String = num2str(-1);
        handles.NCamadas_texto.String = num2str(-1);
        handles.n_atrib_RateMax_texto.String = num2str(-1);
    end
    
end



function DiretorioBase_texto_Callback(hObject, eventdata, handles)
% hObject    handle to DiretorioBase_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DiretorioBase_texto as text
%        str2double(get(hObject,'String')) returns contents of DiretorioBase_texto as a double


% --- Executes during object creation, after setting all properties.
function DiretorioBase_texto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DiretorioBase_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RateMaxGeral_texto_Callback(hObject, eventdata, handles)
% hObject    handle to RateMaxGeral_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RateMaxGeral_texto as text
%        str2double(get(hObject,'String')) returns contents of RateMaxGeral_texto as a double


% --- Executes during object creation, after setting all properties.
function RateMaxGeral_texto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RateMaxGeral_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NCamadas_texto_Callback(hObject, eventdata, handles)
% hObject    handle to NCamadas_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NCamadas_texto as text
%        str2double(get(hObject,'String')) returns contents of NCamadas_texto as a double


% --- Executes during object creation, after setting all properties.
function NCamadas_texto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NCamadas_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function n_atrib_RateMax_texto_Callback(hObject, eventdata, handles)
% hObject    handle to n_atrib_RateMax_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n_atrib_RateMax_texto as text
%        str2double(get(hObject,'String')) returns contents of n_atrib_RateMax_texto as a double


% --- Executes during object creation, after setting all properties.
function n_atrib_RateMax_texto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n_atrib_RateMax_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
