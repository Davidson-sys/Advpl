#INCLUDE "PROTHEUS.CH"

// Crio uma função para teste da Classe Exemplo
User Function zteste()

    Local oSoma1 := Exemplo():New() // Crio um novo objeto de exemplo ( objeto 1 )
    Local oSoma2 := Exemplo():New() // Crio outro objeto de exemplo ( objeto 2 )

    // Realizo 3 chamadas ao método Soma, com o objeto 1
    oSoma1:Soma(10)
    oSoma1:Soma(20)
    oSoma1:Soma(30)

    // Realizo 2 chamadas ao método Soma, com o objeto 2
    oSoma2:Soma(30)
    oSoma2:Soma(30)

    // Imprimo no console o acumulador das somas do obj 1 ( 60 )
    conout(oSoma1:nAcumulador)

    // Imprimo no console o acumulador das chamadas à soma com o objeto 1 ( 3 )
    conout(oSoma1:nChamadas)

    // Imprimo no console o acumulador das somas do obj 2 ( 60 )
    conout(oSoma2:nAcumulador)

    // Imprimo no console o acumulador das chamadas à soma com o objeto 2 (2) 
    conout(oSoma2:nChamadas)

Return

// --------------------------------------------------------------------------------
// Declaracao da Classe Exemplo
// --------------------------------------------------------------------------------

CLASS Exemplo

    // Declaracao das propriedades da Classe
    DATA nAcumulador
    DATA nChamadas

    // Declaração dos Métodos da Classe
    METHOD New() CONSTRUCTOR
    METHOD Soma( nNum )

ENDCLASS

// Criação do construtor, onde atribuimos os valores default 
// para as propriedades e retornamos Self
METHOD New() Class Exemplo
    ::nAcumulador := 0
    ::nChamadas   := 0
Return Self

// Criação do Método de Soma , que recebe um número e o soma 
// ao acumulador, retornando o conteudo do acumululador após
// a soma , e incrementa em 1 o contador de chamadas do método
METHOD Soma( nNum ) Class Exemplo
    ::nAcumulador += nNum
    ::nChamadas++
Return ::nAcumulado
