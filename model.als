abstract sig Classe {}

one sig Guerreiro extends Classe {}
one sig Mago extends Classe {}
one sig Arqueiro extends Classe {}

sig Jogador {
	classe: one Classe,
	pontosDeExperiencia: one Int
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

fact JogadorValido {
  -- Todo jogador deve possuir nível positivo
	all j:Jogador | getNivelJogador[j] > 0
}

fact GuildaValida{
  -- Para cada guilda, existe pelo menos um jogador associado e cada jogador pertence a no máximo uma guilda
	membros in Guilda lone -> some Jogador

  -- Todo Líder deve ser um membro da guilda
	all g:Guilda | g.lider in g.membros 
}

fact MissaoValida {

	all m:Missao {
  -- Para toda missão, os participantes devem ser da guilda organizadora
		m.participantes in m.guildaOrganizadora.membros

  -- Para toda missão, o líder da guilda deve estar presente
		m.guildaOrganizadora.lider in m.participantes

  -- Para toda missão, os participantes fazem parte da guilda organizadora e possui até no máximo 5 participantes
  		m.participantes in m.guildaOrganizadora.membros and #m.participantes <= 5 

  -- Para toda missão, o seu nível de dificuldade deve ser entre 1 e 5
		m.nivelDificuldade >= 1 and m.nivelDificuldade <= 5

  -- Para toda missão, a media do nivel dos participantes deve ser maior ou igual a dificuldade da missao
		mediaNivelParticipantes[m] >= m.nivelDificuldade

  -- Para toda missão, se ela possui mais de dois participantes, então deve possuir pelo menos 2 classes distintas
		#m.participantes > 2 implies #m.participantes.classe >= 2
	}
}

-- Função que retorna a média do nível dos participantes
fun mediaNivelParticipantes(m:Missao): one Int {
	div[sum p: m.participantes | getNivelJogador[p], #m.participantes]
}

-- Funcao que retorna o valor constante utilizado para o calculo do nivel
fun getConstanteNivel (): one Int {
	5
}

-- Funçao que calcula o nivel do jogador, a partir dos seus pontos de experiencia 
fun getNivelJogador(j:Jogador) : one Int {
	div[j.pontosDeExperiencia, getConstanteNivel]
}
		
-- Se a missão possui apenas um único participante, logo ele é o líder
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

-- Mais de dois participantes por missão


-- check MissaoSoloParticipanteLider for 5
-- check MissaoComApenas5Participantes for 5
-- check MissaoComMembrosDiferentesDaOrganizadora  for 5


-- run {} for exactly 8 Jogador, exactly 2 Guilda, exactly 3 Missao, 6 Int

run example {} for 5
