# guild-system

Especificação formal de um Sistema de Guildas para um jogo online, desenvolvida na linguagem Alloy para a disciplina de Lógica para Computação (2026.1).

## Sobre o Projeto
**Arquivo principal:** `Projeto_GrupoL_Especificacao.als`  

O projeto consiste em modelar e validar as regras de negócio de um ambiente de RPG online utilizando o Alloy Analyzer. O sistema garante a consistência das regras de classes, agrupamento em guildas e condições para execução de missões através de fatos lógicos, além de verificar propriedades desejáveis do software através de asserções.

## Equipe (Grupo L)
- Kaique Jose de Souza Santos
- Lucas Rodrigues Mendonca
- Lucas Souto Maior Nobrega
- Luis Guilherme Brito Ceglia Araujo
- Luis Henrique Rego Leite
- Luiz Anselmo Medeiros Lima
- Pedro Barbosa de Menezes Leitao Batista

## Regras de Negócio do Domínio

### Jogadores e Classes
- Cada jogador possui uma classe única (Guerreiro, Mago ou Arqueiro).
- O jogador possui um nível atual (baseado em sua experiência).
- Um jogador pode pertencer a no máximo uma guilda (ou estar temporariamente sem guilda).

### Guildas e Liderança
- Cada guilda possui exatamente um líder.
- O líder de uma guilda obrigatoriamente é um dos membros ativos dela.
- É permitida a existência de guildas que ainda não possuam missões ativas.

### Sistema de Missões
- Cada missão é vinculada a uma única guilda organizadora.
- **Participação:** Restrita a no máximo 5 jogadores. Todos devem ser da guilda organizadora.
- **Líder ativo:** O líder da guilda organizadora deve participar de todas as missões de sua guilda.
- **Diversidade de Classes:** Missões iniciadas com mais de 2 jogadores não podem ter composição homogênea (exige-se pelo menos 2 classes distintas).
- **Dificuldade e Nível:** A dificuldade das missões varia de 1 a 5. Uma missão só pode ser iniciada se a média de nível dos participantes for maior ou igual à dificuldade exigida.

## Requisitos Técnicos Implementados (Alloy)
- [x] Assinaturas, relações binárias e cardinalidades.
- [x] Herança e especialização de componentes (`extends` / `in`).
- [x] Uso de quantificadores para estabelecimento dos fatos.
- [x] Definição de no mínimo 1 predicado (`pred`) e 1 função (`fun`).
- [x] Implementação de no mínimo 2 asserções (`assert`) de verificação de propriedades que não duplicam fatos.
- [x] Cenário de execução de exemplo (`run`) utilizando escopo mínimo igual a 5.
- [x] Código organizado e documentado.

## Como Executar
1. Faça o download e abra o [Alloy Analyzer](https://alloytools.org/).
2. Carregue o arquivo de especificação `Projeto_GrupoL_Especificacao.als`.
3. Para gerar um cenário válido (modelo), vá ao menu **Execute** e selecione o comando `Run`.
4. Para validar as propriedades do sistema, selecione os comandos `Check` referentes às asserções.