def complement_a_un(n):
    # Convertir le nombre en binaire
    binaire = bin(n)[2:]

    # Calculer le complément à un
    complement = bin(~int(binaire, 2) & ((1 << len(binaire)) - 1))[2:]

    # Convertir le complément en décimal
    decimal = int(complement, 2) + 1

    return -decimal

print(complement_a_un(559038737))
