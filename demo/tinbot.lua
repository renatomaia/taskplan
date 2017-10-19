local year = 2018
local start = Date(1,1,year)
--local deadline = Date(31,12,year)

ShowGantGraph = true

local Senior = Worker{name="Senior",start=start,finish=deadline,workrate=.6}
local Pleno  = Worker{name="Pleno" ,start=start,finish=deadline,workrate=.8}
local Junior = Worker{name="Junior",start=start,finish=deadline,workrate=.8}

local function Screen(info)
	return Task{
		ID = info.ID,
		name = info.name,
		worker = info.worker,
		milestone = info.milestone,
		{days=1, name="Base de Dados"}, -- schema, mapping to prog. lang.
		{days=0, name="API REST"}, -- operations, datatypes, documentation
		{days=1, name="Serviço RESTful"}, -- REST API full implementation
		{days=0, name="Testes da API"}, -- automatic API tests
		{days=1, name="Tela do Usuário"}, -- frontend
	}
end
local function CRUD(info)
	return Task{
		ID = info.ID,
		name = info.name,
		worker = info.worker,
		milestone = info.milestone,
		{days=1, name="Base de Dados"}, -- schema, mapping to prog. lang.
		{days=0, name="API REST"}, -- operations, datatypes, documentation
		{days=1, name="Serviço RESTful"}, -- REST API full implementation
		{days=1, name="Testes da API"}, -- automatic API tests
		{days=1, name="Tela de Listagem"}, -- list all, remove selected, and create and edit buttons
		{days=1, name="Tela de Edição"}, -- edit entry attributes
	}
end
local function Learning(info)
	return Task{
		ID = info.ID,
		name = info.name or "Infraestrutura Tecnológica",
		worker = info.worker,
		days = 30.0*info.worker.workrate,
		-- {days=5, name="Base de Dados Relacional"},
		-- {days=5, name="Base de Dados JSON"},
		-- {days=5, name="Base de Arquivos"},
		-- {days=5, name="Serviços REST (backend)"},
		-- {days=5, name="Testes de API REST"},
		-- {days=5, name="Aplicação Web (frontend)"},
	}
end

Learning{worker=Junior}
Learning{worker=Pleno}

Task{name="Especificação de Requisitos", worker=Senior, days=30.0*Senior.workrate
--[[
	-- Controles de Administração
	{days=1, name="Tela de Usuários"},
	{days=1, name="Tela de Robôs"},
	{days=1, name="Tela de Hardware"},
	{days=1, name="Tela de Firmware"},
	{days=1, name="Tela de Boxes de Fábrica"},
	{days=1, name="Tela de Logs de Robôs"},
	-- Controles do Usuário
	{days=1, name="Tela de Login e Inscrição"},
	{days=1, name="Tela de Perfil do Usuário"},
	{days=1, name="Tela dos Meus Robôs"},
	{days=1, name="Tela de Autorizações"},
	{days=1, name="Tela de Organizações"},
	{days=1, name="Tela de CustomBoxes"},
	{days=1, name="Tela de Fluxos"},
	{days=1, name="Tela de Fotos e Grupos"},
	{days=1, name="Tela de Configuração do Robô"},
	{days=1, name="Tela de Gatilhos por Voz"},
	{days=1, name="Tela de Gatilhos por Tempo"},
	{days=1, name="Tela de Gatilhos por Evento"},
	{days=1, name="Tela de Reconhecimento Facial"},
	{days=1, name="Tela de WebHooks"},
	{days=1, name="Tela de Gatilhos por WebHook"},
	{days=1, name="Tela de Atualização de Firmware"},
	{days=1, name="Tela de Controle do Robô"},
	{days=1, name="Tela de "},
	-- Editor FluxBox
	{days=1, name="Resumo de Variáveis do Fluxo"},
	{days=1, name="Edição de Idiomas do Fluxo"},
	{days=1, name="Toolbar de Boxes"},
	{days=1, name="Config. de Prop. Primitivas (texto, número, boleano)"},
	{days=1, name="Config. de Prop. Multimídia (imagem, audio e vídeo)"},
	{days=1, name="Config. de Prop. JavaScript"},
	{days=1, name="Config. de Prop. de Intervalo"},
	{days=1, name="Config. de Prop. de Fala"},
	{days=1, name="Área de Edição de Fluxo"},
	{days=1, name="Geração de JSON para Execução"},
--]]
}

Task{name="Comunicação com o Robô", worker=Senior,
	{days=5, name="Infra no Backend"},
	{days=5, name="Infra no Robô"},
	{days=3, name="Exemplo de Chamada Robô -> Servidor"},
	{days=3, name="Exemplo de Chamada Servidor -> Robô"},
}

-- # Autenticação de Usuários
Screen{name="Inscrição de Usuário", worker=Pleno}
Screen{name="Recuperação de Senha", worker=Pleno}
Screen{name="Autenticação de Usuário", worker=Pleno}

-- # Administração DB1
CRUD{name="Cadastro de Usuários", worker=Junior}
CRUD{name="Cadastro de Boxes de Fábrica", worker=Junior, milestone=true}
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
	{days=2, name="Definição de Variáveis do Fluxo"},
	{days=3, name="Validação de Variáveis Usadas"},
	-- Multi-línguas
	{days=1, name="Definição de Idioma do Fluxo"},
	{days=1, name="Validação de Idiomas Preenchidos"},
	-- Validações (service or JavaScript library)
	{days=3, name="Validação do JavaScript"},
	--{days=3, name="Validação de Extensões no JS"}, -- e.g. 'bag', 'Exit'
	--{days=3, name="Validação de Imagem"},
	--{days=3, name="Validação de Áudio"},
	--{days=3, name="Validação de Vídeo"},
	-- Boxes de Fábrica
	{days=2, name="Toolbar de Boxes"}, -- list boxes and create buttons
	{days=1, name="Propriedade de Enumeração"},
	{days=1, name="Propriedade de Intervalo"}, -- e.g. audio level
	{days=1, name="Propriedade de Texto"},
	{days=3, name="Propriedade de Tico-Tico"}, -- Tico-Tico
	--{days=2, name="Propriedade de Imagem"},
	--{days=2, name="Propriedade de Audio"},
	--{days=2, name="Propriedade de Vídeo"},
	{days=2, name="Propriedade de JavaScript"},
	-- CustomBoxes
	{days=2, name="Toolbar de CustomBoxes"}, -- list boxes and create buttons
	-- {days=5, name="Geração de CustomBox"},
}
Task{name="Editor Gráfico", worker=Pleno,
	-- Framework do Editor
	{days=3, name="Modelo de Undo & Redo de Ações"},
	{days=3, name="Modelo de Desenho de Elementos"},
	{days=3, name="Modelo de Criação de Elementos"},
	{days=3, name="Modelo de Seleção de Elementos"},
	{days=3, name="Modelo de Remoção de Elementos"}, -- individual e grupo
	{days=3, name="Modelo de Movimentação de Elementos"}, -- individual e grupo
	{days=3, name="Modelo de Copy & Paste de Elementos"},
	{days=3, name="Modelo de Indicação de Erros"},
	{days=3, name="Modelo de Configuração de Propriedades"},
	-- Elemento do Box
	{days=3, name="Desenho"},
	{days=3, name="Criação"},
	{days=3, name="Remoção"},
	{days=3, name="Movimentação"},
	{days=3, name="Validação"}, -- identificação e erros semânticos de composição
	-- Elemento de Ligação
	{days=3, name="Desenho"},
	{days=3, name="Criação"},
	{days=3, name="Remoção"},
	{days=3, name="Movimentação"},
	{days=3, name="Validação"}, -- identificação e erros semânticos de composição
	-- Elemento do Fluxo
	{days=3, name="Desenho"}, -- início e fim
	{days=3, name="Redimensionamento"}, -- início e fim
	{days=3, name="Validação"}, -- identificação e erros semânticos de composição
}
Task{name="Persistência de Fluxos", worker=Pleno,
	{days=3, name="Fluxo em Memória para JSON"},
	{days=3, name="JSON para Fluxo em Memória"},
}

Screen{name="Perfil de Usuário", worker=Junior}

-- # Robôs do Usuário
Task{name="Gestão dos Meus Robôs", worker=Junior, 
	{days=1, name="Tela de Listagem"},
	{days=1, name="Tela de Passagem de Titularidade"},
}
CRUD{name="Autorização dos Meus Robôs", worker=Junior}
Screen{name="Convite de Autorização", worker=Pleno, milestone=true }

-- # Cadastro de Configurações de Robô
Screen{name="Instalação de Firmware em Robô", worker=Junior} 
Screen{name="Configuração de Parâmetros", worker=Junior} -- volume, mic sensibility, shutdown date
CRUD{name="Configuração de Personas", worker=Junior}
CRUD{name="Configuração de Gatilhos de Voz", worker=Junior}
CRUD{name="Configuração de Gatilhos de Data", worker=Junior}
CRUD{name="Configuração de Gatilhos de Eventos", worker=Junior}
CRUD{name="Gestão de Reconhecimento Facial", worker=Junior}
CRUD{name="Gestão de WebHooks", worker=Junior}
CRUD{name="Configuração de Gatilhos de WebHooks", worker=Junior}

Task{name="Testes do Editor de Fluxos", worker=Junior, milestone=true,
	-- Propriedades do fluxo
	{days=1, name="Roteiro de Testes de Variáveis"},
	{days=1, name="Roteiro de Testes de Línguas"},
	-- Propriedades de boxes
	{days=1, name="Roteiro de Testes de Prop. Texto"},
	{days=1, name="Roteiro de Testes de Prop. de Intervalo"},
	{days=1, name="Roteiro de Testes de Prop. de Fala"},
	-- {days=1, name="Roteiro de Testes de Prop. Multimídia"},
	{days=1, name="Roteiro de Testes de Prop. JavaScript"},
	-- Boxes
	{days=1, name="Roteiro de Testes de Criação de Boxes"},
	{days=1, name="Roteiro de Testes de Remoção de Boxes"},
	{days=1, name="Roteiro de Testes de Movimentação de Boxes"},
	-- {days=1, name="Roteiro de Testes de Validação de Boxes"},
	{days=1, name="Casos de Testes de Validação de Boxes"},
	-- Conexões
	{days=1, name="Roteiro de Testes de Criação de Conexões"},
	{days=1, name="Roteiro de Testes de Remoção de Conexões"},
	{days=1, name="Roteiro de Testes de Movimentação de Conexões"},
	-- {days=1, name="Roteiro de Testes de Validação de Conexões"},
	-- {days=1, name="Casos de Testes de Validação de Conexões"},
}

-- # Atualização do Robô
Task{name="Atualização da Configuração (Fluxos, Boxes etc) do Robô", worker=Senior,
	{days=1, name="API REST"},
	{days=3, name="Serviço RESTful"},
	{days=1, name="Testes da API"},
	{days=5, name="Infra no Robô"}, -- receive, confirm and update configs
}
Task{name="Atualização do Firmware do Robô", worker=Senior,
	-- {days=5, name="Update do Firmware no Robô"},
	{days=1, name="API REST"},
	{days=3, name="Serviço RESTful"},
	{days=1, name="Testes da API"},
	{days=5, name="Infra no Robô"}, -- receive, confirm and update firmware
}

Task{name="Disparo de WebHooks", worker=Senior, milestone=true,
	{days=1, name="API REST"},
	{days=3, name="Serviço RESTful"},
	{days=1, name="Testes da API"}, -- mock do robô e testes
	{days=5, name="Infra no Robô"}, -- receive and trigger event
}

-- # Dados dos Robôs
Task{name="Status do Robô", worker=Pleno,
	{days=5, name="Infra no Robô"}, -- collect and send state to backend
	{days=2, name="Infra no Backend"}, -- receive and store state for frontend
	{days=1, name="API REST"},
	{days=3, name="Serviço RESTful"},
	{days=1, name="Testes da API"},
	{days=1, name="Tela de Visualização"},
}
Task{name="Histórico do Robô", worker=Pleno,
	{days=5, name="Infra no Robô"}, -- collect and send state to backend
	{days=2, name="Infra no Backend"}, -- receive and store state for frontend
	{days=1, name="API REST"},
	{days=3, name="Serviço RESTful"},
	{days=1, name="Testes da API"},
	{days=3, name="Tela de Visualização"},
}

-- # Controle Remoto
Task{name="Controle do Estado do Robô", worker=Senior,
	{days=5, name="Infra no Robô"}, -- send/receive and read/write state
	{days=2, name="Infra no Backend"}, -- receive/store/send state
	{days=1, name="API REST"},
	{days=3, name="Serviço RESTful"},
	{days=1, name="Testes da API"},
	{days=2, name="Tela de Controle"},
}
Task{name="Suporte de Áudio e Vídeo", worker=Senior,
	{days=5, name="Infra no Robô"}, -- send/receive and capture/reproduce streams
	{days=3, name="Infra no Backend"}, -- receive/send streams
	{days=2, name="API REST"},
	{days=3, name="Serviço RESTful"},
	{days=5, name="Testes da API"}, -- mock do robô e testes
	{days=5, name="Infra no Frontend"}, -- send/receive and capture/reproduce streams
	{days=2, name="Tela de Conferência"},
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
