local year = 2018
local start = Date(1,1,year)
--local deadline = Date(31,12,year)

local Senior = Worker{name="Senior",start=start,finish=deadline,workrate=.6}
local Pleno  = Worker{name="Pleno" ,start=start,finish=deadline,workrate=.8}
local Junior = Worker{name="Junior",start=start,finish=deadline,workrate=.8}

local function Screen(info)
	return Task{
		ID = info.ID,
		name = info.name,
		worker = info.worker,
		{effort=1, name="Base de Dados"}, -- schema, mapping to prog. lang.
		{effort=0, name="API REST"}, -- operations, datatypes, documentation
		{effort=1, name="Serviço RESTful"}, -- REST API full implementation
		{effort=0, name="Testes da API"}, -- automatic API tests
		{effort=1, name="Tela do Usuário"}, -- frontend
	}
end
local function CRUD(info)
	return Task{
		ID = info.id,
		name = info.name,
		worker = info.worker,
		{effort=1, name="Base de Dados"}, -- schema, mapping to prog. lang.
		{effort=0, name="API REST"}, -- operations, datatypes, documentation
		{effort=1, name="Serviço RESTful"}, -- REST API full implementation
		{effort=1, name="Testes da API"}, -- automatic API tests
		{effort=1, name="Tela de Listagem"}, -- list all, remove selected, and create and edit buttons
		{effort=1, name="Tela de Edição"}, -- edit entry attributes
	}
end
local function Learning(info)
	return Task{
		ID = info.ID,
		name = info.name or "Infraestrutura Tecnológica",
		worker = info.worker,
		{effort=5, name="Base de Dados Relacional"},
		{effort=5, name="Base de Dados JSON"},
		{effort=5, name="Base de Arquivos"},
		{effort=5, name="Serviços REST (backend)"},
		{effort=5, name="Testes de API REST"},
		{effort=5, name="Aplicação Web (frontend)"},
	}
end

Learning{worker=Junior}
Learning{worker=Pleno}

Task{name="Especificação de Requisitos", worker=Senior,
	-- Controles de Administração
	{effort=1, name="Tela de Usuários"},
	{effort=1, name="Tela de Robôs"},
	{effort=1, name="Tela de Hardware"},
	{effort=1, name="Tela de Firmware"},
	{effort=1, name="Tela de Boxes de Fábrica"},
	{effort=1, name="Tela de Logs de Robôs"},
	-- Controles do Usuário
	{effort=1, name="Tela de Login e Inscrição"},
	{effort=1, name="Tela de Perfil do Usuário"},
	{effort=1, name="Tela dos Meus Robôs"},
	{effort=1, name="Tela de Autorizações"},
	{effort=1, name="Tela de Organizações"},
	{effort=1, name="Tela de CustomBoxes"},
	{effort=1, name="Tela de Fluxos"},
	{effort=1, name="Tela de Fotos e Grupos"},
	{effort=1, name="Tela de Configuração do Robô"},
	{effort=1, name="Tela de Gatilhos por Voz"},
	{effort=1, name="Tela de Gatilhos por Tempo"},
	{effort=1, name="Tela de Gatilhos por Evento"},
	{effort=1, name="Tela de Reconhecimento Facial"},
	{effort=1, name="Tela de WebHooks"},
	{effort=1, name="Tela de Gatilhos por WebHook"},
	{effort=1, name="Tela de Atualização de Firmware"},
	{effort=1, name="Tela de Controle do Robô"},
	{effort=1, name="Tela de "},
	-- Editor FluxBox
	{effort=1, name="Resumo de Variáveis do Fluxo"},
	{effort=1, name="Edição de Idiomas do Fluxo"},
	{effort=1, name="Toolbar de Boxes"},
	{effort=1, name="Config. de Prop. Primitivas (texto, número, boleano)"},
	{effort=1, name="Config. de Prop. Multimídia (imagem, audio e vídeo)"},
	{effort=1, name="Config. de Prop. JavaScript"},
	{effort=1, name="Config. de Prop. de Intervalo"},
	{effort=1, name="Config. de Prop. de Fala"},
	{effort=1, name="Área de Edição de Fluxo"},
	{effort=1, name="Geração de JSON para Execução"},
}

Task{name="Interação com o Robô", worker=Senior,
	{effort=5, name="Infra no Backend"},
	{effort=5, name="Infra no Robô"},
	{effort=3, name="Exemplo de Serviço para o Robô"},
	{effort=3, name="Exemplo de Serviço do Robô"},
	{effort=4, name="Testes Automáticos"},
}

-- # Autenticação de Usuários
Screen{name="Inscrição de Usuário", worker=Pleno}
Screen{name="Recuperação de Senha", worker=Pleno}
Screen{name="Autenticação de Usuário", worker=Pleno}

-- # Administração DB1
CRUD{name="Cadastro de Usuários", worker=Junior}
CRUD{name="Cadastro de Boxes de Fábrica", worker=Junior}
CRUD{name="Cadastro de Firmware", worker=Junior}
CRUD{name="Cadastro de Hardware", worker=Junior}
CRUD{name="Cadastro de Robôs", worker=Junior}

-- # Organizações
CRUD{name="Cadastro de Organizações", worker=Junior}
CRUD{name="Cadastro de Usuários de Organização", worker=Junior}
CRUD{name="Cadastro de CustomBoxes", worker=Junior}
CRUD{name="Cadastro de Fluxos", worker=Junior}
CRUD{name="Cadastro de Fotos", worker=Junior}

-- # FluxBox
Task{name="Editor de Fluxos", worker=Pleno,
	-- Variáveis
	{effort=2, name="Definição de Variáveis do Fluxo"},
	{effort=3, name="Validação de Variáveis Usadas"},
	-- Multi-línguas
	{effort=2, name="Definição de Idioma do Fluxo"},
	{effort=3, name="Validação de Idioma Preenchidas"},
	-- Validações (service or JavaScript library)
	{effort=3, name="Validação do JavaScript"},
	{effort=3, name="Validação de Extensões no JS"}, -- e.g. 'bag', 'Exit'
	--{effort=3, name="Validação de Imagem"},
	--{effort=3, name="Validação de Áudio"},
	--{effort=3, name="Validação de Vídeo"},
	-- Boxes de Fábrica
	{effort=3, name="Toolbar de Boxes"}, -- list boxes and create buttons
	{effort=2, name="Propriedade de Enumeração"},
	{effort=2, name="Propriedade de Intervalo"}, -- e.g. audio level
	{effort=3, name="Propriedade de Texto"},
	{effort=5, name="Propriedade de Tico-Tico"}, -- Tico-Tico
	--{effort=2, name="Propriedade de Imagem"},
	--{effort=2, name="Propriedade de Audio"},
	--{effort=2, name="Propriedade de Vídeo"},
	{effort=3, name="Propriedade de JavaScript"},
	-- CustomBoxes
	{effort=3, name="Toolbar de CustomBoxes"}, -- list boxes and create buttons
	{effort=5, name="Geração de CustomBox"},
}
Task{name="Editor Gráfico", worker=Pleno,
	-- Framework do Editor
	{effort=3, name="Modelo de Undo&Redo de Ações"},
	{effort=3, name="Modelo de Desenho de Elementos"},
	{effort=3, name="Modelo de Criação de Elementos"},
	{effort=3, name="Modelo de Remoção de Elementos"}, -- individual e grupo
	{effort=3, name="Modelo de Movimentação de Elementos"}, -- individual e grupo
	{effort=3, name="Modelo de Copy&Paste de Elementos"},
	{effort=3, name="Modelo de Indicação de Erros"},
	{effort=3, name="Modelo de Configuração de Propriedades"},
	-- Elemento do Box
	{effort=3, name="Desenho"},
	{effort=3, name="Criação"},
	{effort=3, name="Remoção"},
	{effort=3, name="Movimentação"},
	{effort=3, name="Validação"}, -- identificação e erros semânticos de composição
	-- Elemento de Ligação
	{effort=3, name="Desenho"},
	{effort=3, name="Criação"},
	{effort=3, name="Remoção"},
	{effort=3, name="Movimentação"},
	{effort=3, name="Validação"}, -- identificação e erros semânticos de composição
	-- Elemento do Fluxo
	{effort=3, name="Desenho"}, -- início e fim
	{effort=3, name="Redimensionamento"}, -- início e fim
	{effort=3, name="Validação"}, -- identificação e erros semânticos de composição
}
Task{name="Persistência de Fluxos", worker=Pleno,
	{effort=5, name="Fluxo em Memória para JSON"},
	{effort=5, name="JSON para Fluxo em Memória"},
}
Task{name="Testes do Editor de Fluxos", worker=Junior,
	-- Propriedades do fluxo
	{effort=1, name="Roteiro de Testes de Variáveis"},
	{effort=1, name="Roteiro de Testes de Línguas"},
	-- Propriedades de boxes
	{effort=1, name="Roteiro de Testes de Prop. Primitivas"},
	{effort=1, name="Roteiro de Testes de Prop. de Intervalo"},
	{effort=2, name="Roteiro de Testes de Prop. de Fala"},
	{effort=2, name="Roteiro de Testes de Prop. Multimídia"},
	{effort=2, name="Roteiro de Testes de Prop. JavaScript"},
	-- Boxes
	{effort=1, name="Roteiro de Testes de Criação de Boxes"},
	{effort=1, name="Roteiro de Testes de Remoção de Boxes"},
	{effort=1, name="Roteiro de Testes de Movimentação de Boxes"},
	{effort=1, name="Roteiro de Testes de Validação de Boxes"},
	{effort=1, name="Casos de Testes de Validação de Boxes"},
	-- Conexões
	{effort=1, name="Roteiro de Testes de Criação de Conexões"},
	{effort=1, name="Roteiro de Testes de Remoção de Conexões"},
	{effort=1, name="Roteiro de Testes de Movimentação de Conexões"},
	{effort=1, name="Roteiro de Testes de Validação de Conexões"},
	{effort=1, name="Casos de Testes de Validação de Conexões"},
}

Screen{name="Perfil de Usuário", worker=Junior}

-- # Robôs do Usuário
Task{name="Gestão dos Meus Robôs", worker=Junior,
	{effort=2, name="Tela de Listagem"},
	{effort=2, name="Tela de Passagem de Titularidade"},
}
CRUD{name="Autorização dos Meus Robôs", worker=Junior}
Screen{name="Convite de Autorização", worker=Pleno}

-- # Cadastro de Configurações de Robô
Screen{name="Instalação de Firmware em Robô", worker=Junior} -- volume, mic sensibility, shutdown date
Screen{name="Configuração de Parâmetros", worker=Junior} -- volume, mic sensibility, shutdown date
CRUD{name="Configuração de Personas", worker=Junior}
CRUD{name="Configuração de Gatilhos de Voz", worker=Junior}
CRUD{name="Configuração de Gatilhos de Data", worker=Junior}
CRUD{name="Configuração de Gatilhos de Eventos", worker=Junior}
CRUD{name="Gestão de Reconhecimento Facial", worker=Junior}
CRUD{name="Gestão de WebHooks", worker=Junior}
CRUD{name="Configuração de Gatilhos de WebHooks", worker=Junior}

-- # Atualização do Robô
Task{name="Atualização da Configuração do Robô", worker=Senior,
	{effort=2, name="API REST"},
	{effort=5, name="Serviço RESTful"},
	{effort=3, name="Testes da API"},
	{effort=5, name="Infra no Robô"}, -- receive, confirm and update configs
}
Task{name="Atualização do Firmware do Robô", worker=Senior,
	{effort=5, name="Update do Firmware no Robô"},
	{effort=2, name="API REST"},
	{effort=5, name="Serviço RESTful"},
	{effort=3, name="Testes da API"},
	{effort=5, name="Infra no Robô"}, -- receive, confirm and update firmware
}

Task{name="Disparo de WebHooks", worker=Senior,
	{effort=2, name="API REST"},
	{effort=5, name="Serviço RESTful"},
	{effort=3, name="Testes da API"}, -- mock do robô e testes
	{effort=5, name="Infra no Robô"}, -- receive and trigger event
}

-- # Dados dos Robôs
Task{name="Status do Robô", worker=Pleno,
	{effort=5, name="Infra no Robô"}, -- collect and send state to backend
	{effort=5, name="Infra no Backend"}, -- receive and store state for frontend
	{effort=2, name="API REST"},
	{effort=3, name="Serviço RESTful"},
	{effort=3, name="Testes da API"},
	{effort=2, name="Tela de Visualização"},
}
Task{name="Histórico do Robô", worker=Pleno,
	{effort=5, name="Infra no Robô"}, -- collect and send state to backend
	{effort=5, name="Infra no Backend"}, -- receive and store state for frontend
	{effort=2, name="API REST"},
	{effort=3, name="Serviço RESTful"},
	{effort=3, name="Testes da API"},
	{effort=2, name="Tela de Visualização"},
}

-- # Controle Remoto
Task{name="Controle do Estado do Robô", worker=Senior,
	{effort=5, name="Infra no Robô"}, -- send/receive and read/write state
	{effort=5, name="Infra no Backend"}, -- receive/store/send state
	{effort=2, name="API REST"},
	{effort=3, name="Serviço RESTful"},
	{effort=3, name="Testes da API"},
	{effort=2, name="Tela de Controle"},
}
Task{name="Suporte de Áudio e Vídeo", worker=Senior,
	{effort=5, name="Infra no Robô"}, -- send/receive and capture/reproduce streams
	{effort=3, name="Infra no Backend"}, -- receive/send streams
	{effort=2, name="API REST"},
	{effort=3, name="Serviço RESTful"},
	{effort=5, name="Testes da API"}, -- mock do robô e testes
	{effort=5, name="Infra no Frontend"}, -- send/receive and capture/reproduce streams
	{effort=2, name="Tela de Conferência"},
}

--[=====[
MarketPlace

	Publicação de Box/Fluxo
		TODO: Falta definir esse processo direito...

	Curadoria
		TODO: Falta definir esse processo direito...

	Loja
		Busca
		Instalação
--]=====]
