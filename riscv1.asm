# Implementação do Blackjack em Assembly RISC-V
.data
    msg_bemvindo:    .string "\n=== Bem-vindo ao Blackjack! ===\n\n"
    msg_jogador:     .string "O jogador recebe: "
    msg_dealer:      .string "O dealer revela: "
    msg_oculta:      .string " e uma carta oculta\n"
    msg_suamao:      .string "Sua mão: "
    msg_mais:        .string " + "
    msg_igual:       .string " = "
    msg_quebra:      .string "\n"
    msg_escolha:     .string "\nO que você deseja fazer? (1 - Pedir Carta, 2 - Parar): "
    msg_dealer_rev:  .string "\nO dealer revela sua mão: "
    msg_dealer_cont: .string "\nO dealer deve continuar pedindo cartas...\n"
    msg_dealer_nova: .string "O dealer recebe: "
    msg_dealer_mao:  .string "O dealer tem: "
    msg_perdeu:      .string "\nVocê estourou! O dealer venceu!\n"
    msg_ganhou:      .string "\nO dealer estourou! Você venceu!\n"
    msg_venceu_maior: .string "\nVocê venceu com "
    msg_perdeu_maior: .string "\nO dealer venceu com "
    msg_contra:      .string " contra "
    msg_exclamacao:  .string "!\n"
    msg_empate:      .string "\nEmpate!\n"
    msg_jogar_novamente: .string "\nDeseja jogar novamente? (1 - Sim, 2 - Não): "
    
.text
# Registradores:
# s0 - Total do jogador
# s1 - Total do dealer
# s2 - Primeira carta do jogador
# s3 - Segunda carta do jogador
# s4 - Primeira carta do dealer
# s5 - Segunda carta do dealer
# s6 - Array index para cartas do jogador
# t0-t6 - Cálculos temporários

.globl main
main:
    la a0, msg_bemvindo
    li a7, 4
    ecall
    
    # Inicializa o estado do jogo
    li s0, 0       # Total do jogador
    li s1, 0       # Total do dealer
    li s6, 2       # Contador de cartas do jogador
    
distribuir_inicial:
    # Primeira carta do jogador
    jal ra, dar_carta
    mv s2, a0      # Salva primeira carta
    add s0, s0, a0
    
    # Segunda carta do jogador
    jal ra, dar_carta
    mv s3, a0      # Salva segunda carta
    add s0, s0, a0
    
    # Mostra cartas do jogador
    la a0, msg_jogador
    li a7, 4
    ecall
    
    mv a0, s2
    li a7, 1
    ecall
    
    la a0, msg_mais
    li a7, 4
    ecall
    
    mv a0, s3
    li a7, 1
    ecall
    
    la a0, msg_igual
    li a7, 4
    ecall
    
    mv a0, s0
    li a7, 1
    ecall
    
    la a0, msg_quebra
    li a7, 4
    ecall
    
    # Primeira carta do dealer
    jal ra, dar_carta
    mv s4, a0      # Salva primeira carta do dealer
    add s1, s1, a0
    
    # Segunda carta do dealer (oculta)
    jal ra, dar_carta
    mv s5, a0      # Salva segunda carta
    add s1, s1, a0
    
    # Mostra apenas primeira carta do dealer
    la a0, msg_dealer
    li a7, 4
    ecall
    
    mv a0, s4
    li a7, 1
    ecall
    
    la a0, msg_oculta
    li a7, 4
    ecall
    
turno_jogador:
    la a0, msg_escolha
    li a7, 4
    ecall
    
    li a7, 5
    ecall
    
    li t0, 1
    beq a0, t0, jogador_pede
    j turno_dealer

jogador_pede:
    # Nova carta
    jal ra, dar_carta
    mv t1, a0      # Salva carta recebida
    add s0, s0, a0
    
    # Mostra carta recebida
    la a0, msg_jogador
    li a7, 4
    ecall
    
    mv a0, t1
    li a7, 1
    ecall
    
    la a0, msg_quebra
    li a7, 4
    ecall
    
    # Mostra mão completa
    la a0, msg_suamao
    li a7, 4
    ecall
    
    # Mostra primeira carta
    mv a0, s2
    li a7, 1
    ecall
    
    # Mostra cartas intermediárias
    la a0, msg_mais
    li a7, 4
    ecall
    
    mv a0, s3
    li a7, 1
    ecall
    

    
mostrar_mais_cartas:
    la a0, msg_mais
    li a7, 4
    ecall
    
    mv a0, t1
    li a7, 1
    ecall
    
mostrar_igual:
    la a0, msg_igual
    li a7, 4
    ecall
    
    mv a0, s0
    li a7, 1
    ecall
    
    la a0, msg_quebra
    li a7, 4
    ecall
    
    addi s6, s6, 1  # Incrementa contador de cartas
    
    # Verifica se estourou
    li t0, 21
    bgt s0, t0, jogador_estorou
    j turno_jogador

jogador_estorou:
    la a0, msg_perdeu
    li a7, 4
    ecall
    j fim_jogo

turno_dealer:
    # Revela mão completa do dealer
    la a0, msg_dealer_rev
    li a7, 4
    ecall
    
    mv a0, s1
    li a7, 1
    ecall
    
    la a0, msg_quebra
    li a7, 4
    ecall

jogar_dealer:
    li t0, 17
    bge s1, t0, verificar_vencedor
    
    # Dealer pede carta
    la a0, msg_dealer_cont
    li a7, 4
    ecall
    
    jal ra, dar_carta
    add s1, s1, a0
    
    la a0, msg_dealer_mao
    li a7, 4
    ecall
    
    mv a0, s1
    li a7, 1
    ecall
    
    la a0, msg_quebra
    li a7, 4
    ecall
    
    # Verifica se dealer estourou
    li t0, 21
    bgt s1, t0, dealer_estorou
    
    j jogar_dealer

dealer_estorou:
    la a0, msg_ganhou
    li a7, 4
    ecall
    j fim_jogo

verificar_vencedor:
    bgt s0, s1, jogador_vence_maior
    bgt s1, s0, dealer_vence_maior
    j empate

jogador_vence_maior:
    la a0, msg_venceu_maior
    li a7, 4
    ecall
    
    mv a0, s0
    li a7, 1
    ecall
    
    la a0, msg_contra
    li a7, 4
    ecall
    
    mv a0, s1
    li a7, 1
    ecall
    
    la a0, msg_exclamacao
    li a7, 4
    ecall
    j fim_jogo

dealer_vence_maior:
    la a0, msg_perdeu_maior
    li a7, 4
    ecall
    
    mv a0, s1
    li a7, 1
    ecall
    
    la a0, msg_contra
    li a7, 4
    ecall
    
    mv a0, s0
    li a7, 1
    ecall
    
    la a0, msg_exclamacao
    li a7, 4
    ecall
    j fim_jogo

empate:
    la a0, msg_empate
    li a7, 4
    ecall
    j fim_jogo

fim_jogo:
    la a0, msg_jogar_novamente
    li a7, 4
    ecall
    
    li a7, 5
    ecall
    
    li t0, 1
    beq a0, t0, main
    li a7, 10
    ecall

# Função para dar carta (1-13)
dar_carta:
    li a7, 42       # Número aleatório
    li a1, 13       # Limite superior
    ecall
    addi a0, a0, 1  # Intervalo 1-13
    
    # Converte valor para pontuação
    mv t6, a0       # Salva valor original
    
    # Se for maior que 10 (Valete, Dama, Rei)
    li t0, 10
    ble t6, t0, valor_normal
    li a0, 10
    j fim_dar_carta
    
valor_normal:
    li t0, 1
    bne t6, t0, fim_dar_carta
    li a0, 11       # Ás vale 11
    
fim_dar_carta:
    ret