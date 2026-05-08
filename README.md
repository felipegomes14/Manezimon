🌿 Manezinmon

Jogo RPG de exploração e batalhas inspirado em Pokémon

Projeto desenvolvido em Lua + LÖVE2D

📖 Sobre o Projeto

IlhaMon é um jogo 2D inspirado em RPGs clássicos de captura e batalha de criaturas, com foco em exploração, combates por turnos e progressão de nível.

O projeto foi desenvolvido com arquitetura modular utilizando a engine LÖVE2D, separando os sistemas principais em módulos independentes para facilitar manutenção, expansão e organização do código.

🎮 Funcionalidades
🌎 Exploração
Movimentação livre no mapa
Sistema de câmera dinâmica
Limites de mapa
Estrutura preparada para encontros aleatórios
⚔️ Sistema de Batalha
Combate em turnos
Menu de ataques
Sistema de fuga
HUD inspirada em Pokémon Fire Red
Efeitos de dano
Sistema de tipos elementais
🔥 Sistema Elemental

Atualmente o jogo possui:

Elemento	Vantagem
🔥 Fogo	🌿 Planta
💧 Água	🔥 Fogo
🌿 Planta	💧 Água

Com mensagens:

SUPER EFETIVO!
NÃO FOI MUITO EFETIVO...
📈 Sistema de Progressão
Sistema de XP
Level Up automático
Escalonamento de atributos
Progressão dinâmica de dificuldade
🧠 Paralelismo / Concorrência

O projeto utiliza conceitos de concorrência lógica através de sistemas independentes executados simultaneamente no loop principal do jogo.

Sistemas concorrentes:
IA inimiga
Eventos de batalha
Atualização de animações
Sistema de efeitos
Controle de tempo entre ações

A arquitetura foi preparada para expansão futura utilizando:

coroutines
eventos assíncronos
sistemas paralelos de clima e encontros
🛠️ Tecnologias Utilizadas
🎮 Engine
LÖVE2D
💻 Linguagem
Lua
📚 Bibliotecas
STI (Simple Tiled Implementation)
Windfield
Anim8
Camera
📂 Estrutura do Projeto
project/
│
├── main.lua
├── core.lua
│
├── battle.lua
├── draw.lua
├── input.lua
├── exploration.lua
│
├── maps/
├── sprites/
├── sounds/
├── libraries/
│
└── README.md
🧩 Arquitetura Modular

O projeto foi dividido em módulos independentes:

Arquivo	Responsabilidade
core.lua	Inicialização e gerenciamento principal
exploration.lua	Exploração e movimentação
battle.lua	Sistema de combate
input.lua	Controle de entrada
draw.lua	Interface e renderização
🚀 Como Executar
1. Instale o LÖVE2D

Baixe em:

LÖVE2D Official Website

2. Execute o Projeto

Arraste a pasta do projeto para o executável do LÖVE2D
OU execute pelo terminal:

love .
🎯 Objetivos do Projeto
Aplicar conceitos de desenvolvimento de jogos
Utilizar arquitetura modular
Implementar sistemas de batalha em turnos
Trabalhar concorrência/paralelismo lógico
Desenvolver interface estilo RPG clássico
🔮 Melhorias Futuras
Sistema de captura
Inventário
Evolução de criaturas
Clima dinâmico
Encontros aleatórios
NPCs
Missões
Sistema de áudio completo
Multiplayer local
👨‍💻 Desenvolvedor

Projeto acadêmico desenvolvido para estudos de:

Programação de Jogos
Estruturas Modulares
Paralelismo e Concorrência
Desenvolvimento com Lua/LÖVE2D
📜 Licença

Projeto desenvolvido para fins educacionais.
