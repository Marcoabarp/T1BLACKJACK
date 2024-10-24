############################
# Desenvolva o código abaixo em assembly do RISC-V.
############################ 
# ATENÇÃO! Não use divisão/resto para determinar se é PAR ou IMPAR! Utilize operações BITWISE!
############################ 

# void verificarParidade(int num) {
#     if (num % 2 == 0) {
#         printf("%d é par.\n", num);
#     } else {
#         printf("%d é ímpar.\n", num);
#     }
# }
# int main() {
#     int x;
#     printf("Digite um número: ");
#     scanf("%d", &x);
#     verificarParidade(x);
#     return 0;
# }
############################
.data # Dados do programa
msg_input:  .string "Digite um número: "
msg_par:    .string " é par.\n"
msg_impar:  .string " é ímpar.\n"
############################
############################
.text # Codigo
.globl main
main:
    # Imprime "Digite um número: "
    la a0, msg_input
    li a7, 4
    ecall

    # Lê o número inteiro
    li a7, 5
    ecall
    mv s0, a0  # Salva o número lido em s0

    # Chama verificarParidade
    mv a0, s0
    jal ra, verificarParidade

    # Encerra o programa
    li a7, 10
    ecall

verificarParidade:
    # Verifica se o número é par usando operação bitwise
    andi t0, a0, 1  # t0 = último bit de a0
    bnez t0, impar  # Se t0 != 0, o número é ímpar

par:
    # Imprime o número
    mv a1, a0
    li a7, 1
    ecall

    # Imprime " é par.\n"
    la a0, msg_par
    li a7, 4
    ecall
    j fim

impar:
    # Imprime o número
    mv a1, a0
    li a7, 1
    ecall

    # Imprime " é ímpar.\n"
    la a0, msg_impar
    li a7, 4
    ecall

fim:
    ret
############################
