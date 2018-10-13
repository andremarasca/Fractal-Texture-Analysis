Fractal Texture Analysis

Código desenvolvido no meu TCC para classificação supervisionada de imagens, o método de extração de características é FDMIC: https://www.sciencedirect.com/science/article/pii/S0020025516300135, ou seja, análise de textura baseada em fractais.

Como funciona:
- Você deve executar o arquivo AplicativoReconhecedorTexturas.m com Matlab.
- Em seguida criar um diretório padrão da seguinte forma:
- MinhasAplicações
.  |_ Aplicação 1 <br />
.  |_ Aplicação 2 <br />
.  |_ ... <br />
.  |_ Aplicação X <br />
.      |_ Bruto <br />
.         |_ Classe 1 <br />
.         |_ Classe 2 <br />
.         |_ ... <br />
.         |_ Classe Y <br />
.            |_ imagens 1 da classe Y <br />
.            |_ imagens 2 da classe Y <br />
.            |_ ... <br />
.            |_ imagens Z da classe Y <br />
            
- Basicamente Você deve criar uma pasta chamada Bruto, em que recebe uma pasta para cada classe de textura, cada pasta recebe várias imagens brutas, ou seja, a imagem inteira, sem tratamento.

Na interface gráfica faça:
- Selecionar Diretório -> Selecionar diretório MinhasAplicações (seja qual for o nome dado).
- Na caixa ao lado selecionar a aplicação
- Clicar em Salvar Configurações
- Gerar Base
- Gerar Descritores

Após isso a pasta da aplicação selecionada estará assim:
- MinhasAplicações
.  |_ Aplicação 1 <br />
.  |_ Aplicação 2 <br />
.  |_ ... <br />
.  |_ Aplicação X <br />
.      |_ <b>ArquivosDoPrograma </b><br />
.      |_ <b>Testes </b><br />      
.      |_ Bruto <br />
.         |_ Classe 1 <br />
.         |_ Classe 2 <br />
.         |_ ... <br />
.         |_ Classe Y <br />
.            |_ imagens 1 da classe Y <br />
.            |_ imagens 2 da classe Y <br />
.            |_ ... <br />
.            |_ imagens Z da classe Y <br />
            
Inserir a imagem a ser classificada em Testes
- Clicar em reescalar testes
- Clicar em reconhecer testes

Dessa forma cada imagem na pasta de testes será renomeada para classificação

Vídeo tutorial:
- Em breve.
