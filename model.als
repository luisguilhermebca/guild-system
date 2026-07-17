abstract sig Classe {}

one sig Guerreiro extends Classe {}
one sig Mago extends Classe {}
one sig Arqueiro extends Classe {}

sig Jogador {
	classe: one Classe,
	nivel: one Int
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
  all j:Jogador | j.nivel > 0
}

fact GuildaValida{
  -- Para cada guilda, existe pelo menos um jogador associado e cada jogador pertence a no máximo uma guilda
	membros in Guilda lone -> some Jogador

  -- Todo Líder deve ser um membro da guilda
	all g:Guilda | g.lider in g.membros 
}

fact MissaoValida {
  -- Para toda missão, os participantes devem ser da guilda organizadora
	all m:Missao | m.participantes in m.guildaOrganizadora.membros

  -- Para toda missão, o líder da guilda deve estar presente
	all m:Missao | m.guildaOrganizadora.lider in m.participantes

  -- Para toda missão, os participantes fazem parte da guilda organizadora e possui até no máximo 5 participantes
  all m:Missao | m.participantes in m.guildaOrganizadora.membros and #m.participantes <= 5 

  -- Para toda missão, o seu nível de dificuldade deve ser entre 1 e 5
  all m:Missao | m.nivelDificuldade >= 1 and m.nivelDificuldade <= 5
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

check MissaoSoloParticipanteLider for 5
check MissaoComApenas5Participantes for 6
check MissaoComMembrosDiferentesDaOrganizadora  for 6




run example {} for 5