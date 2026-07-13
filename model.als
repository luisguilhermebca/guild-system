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
  participantes: set Jogador
}

fact GuildaValida{
  -- Para guilda existe um jogador associado e cada jogador pertence a no máximo uma guilda
	membros in Guilda lone -> some Jogador

  -- Todo Líder deve ser um membro da guilda
	all g:Guilda | g.lider in g.membros 
}

fact MissaoValida {
  -- Paro toda missão, os participantes devem ser da guilda organizadora
  all m:Missao | m.participantes in m.guildaOrganizadora.membros
}

run example {} for 5