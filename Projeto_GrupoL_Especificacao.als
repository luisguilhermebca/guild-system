abstract sig Classe {}

one sig Guerreiro extends Classe {}
one sig Mago extends Classe {}
one sig Arqueiro extends Classe {}

sig Status {
	missoesConcluidas: set Missao
}

sig Jogador {
	classe: one Classe,
	status: one Status
}

sig Guilda {
	membros: some Jogador,
	lider: one Jogador
}

sig Missao {
	guildaOrganizadora: one Guilda,
	participantes: set Jogador,
	nivelDificuldade: one Int
}

-- Função que retorna os pontos de experiência de um jogador a partir de suas missões concluídas
fun getPontosDeExperiencia(j: Jogador): one Int {
	sum m: j.status.missoesConcluidas | m.nivelDificuldade
}

-- Função que calcula o nível do jogador, a partir dos seus pontos de experiência
fun getNivelJogador(j: Jogador): one Int {
	getPontosDeExperiencia[j] < 10 => 1 else
	getPontosDeExperiencia[j] < 30 => 2 else
	getPontosDeExperiencia[j] < 60 => 3 else
	getPontosDeExperiencia[j] < 100 => 4 else
	5
}

-- Função que retorna a média do nível dos participantes em uma missão
fun mediaNivelParticipantes(m: Missao): one Int {
	div[sum p: m.participantes | getNivelJogador[p], #m.participantes]
}

-- Predicado das condições necessárias para uma missão ser válida
pred podeIniciarMissao(m: Missao) {
	-- Toda missão precisa ter participantes
		some m.participantes

	-- Os participantes devem ser da guilda organizadora
		m.participantes in m.guildaOrganizadora.membros

		-- O líder da guilda deve estar presente
		m.guildaOrganizadora.lider in m.participantes

		-- Limite máximo de participantes
		#m.participantes <= 5

		-- Dificuldade entre 1 e 5
		m.nivelDificuldade >= 1 and m.nivelDificuldade <= 5

		-- Média do nível dos participantes deve ser maior ou igual à dificuldade
		mediaNivelParticipantes[m] >= m.nivelDificuldade

		-- Se tiver mais de 2 participantes, eles devem ser de classes distintas
		(#m.participantes > 2) implies (#m.participantes.classe >= 2)
}

fact JogadorValido {
	all j: Jogador {
		-- Todo jogador deve possuir nível positivo
		getNivelJogador[j] >= 1 and getNivelJogador[j] <= 5

		-- Todo jogador deve possuir pontos de experiência maior ou igual a 0
		getPontosDeExperiencia[j] >= 0

		-- Todo jogador deve possuir um nível coerente com seus pontos de experiência
		let xp = getPontosDeExperiencia[j] {
			((xp >= 0 and xp < 10) implies getNivelJogador[j] = 1) and
			((xp >= 10 and xp < 30) implies getNivelJogador[j] = 2) and
			((xp >= 30 and xp < 60) implies getNivelJogador[j] = 3) and
			((xp >= 60 and xp < 100) implies getNivelJogador[j] = 4) and
			((xp >= 100) implies getNivelJogador[j] = 5)
		}
	}
}

fact StatusValido {
	-- Cada status deve pertencer a no máximo um jogador
	all s: Status | lone s.~status
}

fact GuildaValida {
	-- Cada jogador pertence a no máximo uma guilda
	all j: Jogador | lone j.~membros

	-- Todo líder deve ser membro da guilda
	all g: Guilda | g.lider in g.membros
}

fact MissaoValida {
	all m: Missao {
		podeIniciarMissao[m]
	}
}

/*
Conjunto de Asserts para verificar se as condições do nível estão sendo respeitadas
Nível 1 e 5
*/
assert Nivel1TemAte9XP {
	all j: Jogador | getNivelJogador[j] = 1 implies getPontosDeExperiencia[j] < 10
}

assert Nivel5ExigePeloMenos100XP {
	all j: Jogador | getNivelJogador[j] = 5 implies getPontosDeExperiencia[j] >= 100
}

assert MaisMissoesConcluidasNaoDiminuemXP {
	all j1, j2: Jogador |
		j1.status.missoesConcluidas in j2.status.missoesConcluidas implies
		getPontosDeExperiencia[j1] <= getPontosDeExperiencia[j2]
}

-- Se a missão possui apenas um único participante, logo ele deve ser o líder
assert MissaoSoloParticipanteLider {
	all m:Missao | #m.participantes = 1 implies m.participantes = m.guildaOrganizadora.lider
}

-- Verificar se existe alguma missão com mais do que 5 participantes
assert MissaoComApenas5Participantes {
	no m:Missao | #m.participantes > 5 
}

-- Verificar se existe algum participante da missão que não seja da guilda organizadora
assert MissaoComMembrosDiferentesDaOrganizadora {
	no m: Missao | m.participantes not in m.guildaOrganizadora.membros
}

-- Se o grupo possui mais de dois participantes, logo, ele é heterogêneo (em relação às classes)
assert ImpossivelApenasUmaClasseEmGrupoGrande {
    all m: Missao | (#m.participantes > 2) implies not (all p1, p2: m.participantes | p1.classe = p2.classe)
}

check MissaoSoloParticipanteLider for 5 but 8 Int
check MissaoComApenas5Participantes for 5 but 8 Int
check MissaoComMembrosDiferentesDaOrganizadora for 5 but 8 Int

check Nivel1TemAte9XP for 8 Int, exactly 8 Jogador, exactly 8 Status, exactly 2 Guilda, exactly 3 Missao
check Nivel5ExigePeloMenos100XP for 8 Int, exactly 8 Jogador, exactly 8 Status, exactly 2 Guilda, exactly 3 Missao
check MaisMissoesConcluidasNaoDiminuemXP for 8 Int, exactly 8 Jogador, exactly 8 Status, exactly 2 Guilda, exactly 3 Missao
check ImpossivelApenasUmaClasseEmGrupoGrande for 8 Int, exactly 8 Jogador, exactly 8 Status, exactly 2 Guilda, exactly 3 Missao

run {} for 8 Int, exactly 8 Jogador, exactly 8 Status, exactly 5 Guilda, exactly 5 Missao