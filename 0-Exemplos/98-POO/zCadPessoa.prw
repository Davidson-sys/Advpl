//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zCadPessoa
Função que testa a classe Pessoa
@author Atilio
@since 13/12/2015
@version 1.0
	@example
	u_zCadPessoa()
/*/
User Function zCadPessoa()
	Local oPessoa
	Local cNome       := "Davidson"
	Local dNascimento := sToD("19820920")
	
	//Instanciando o objeto através da classe Pessoa
	oPessoa := zPessoa():New(cNome, dNascimento)
	
	//Chamando um método da classe
	oPessoa:MostraIdade()
Return
