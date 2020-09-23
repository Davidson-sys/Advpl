//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zPessoa
Cria��o da classe Pessoa
@author Atilio
@since 13/12/2015
@version 1.0
	@example
	oObjeto := zPessoa():New()
/*/
Class zPessoa
	//Atributos
	Data cNome
	Data nIdade
	Data dNascimento
	//M�todos
	Method New() CONSTRUCTOR
	Method MostraIdade()
EndClass


/*/{Protheus.doc} New
M�todo que cria a inst�ncia com a classe zPessoa
@author Atilio
@since 13/12/2015
@version 1.0
	@param cNome, Caracter, Nome da Pessoa
	@param dNascimento, Data, Data de Nascimento da Pessoa
	@example
	oObjeto := zPessoa():New("Jo�o", sToD("19800712"))
/*/
Method New(cNome, dNascimento) Class zPessoa
	//Atribuindo valores nos atributos do objeto instanciado
	::cNome       := cNome
	::dNascimento := dNascimento
	::nIdade      := fCalcIdade(dNascimento)
Return Self



/*/{Protheus.doc} MostraIdade
M�todo que mostra a idade da pessoa
@author Atilio
@since 13/12/2015
@version 1.0
	@example
	oObjeto:MostraIdade()
/*/
Method MostraIdade() Class zPessoa
	Local cMsg := ""
	
	//Criando e mostrando a mensagem
	cMsg := "A <b>pessoa</b> "+::cNome+" tem "+cValToChar(::nIdade)+" anos!"
	MsgInfo(cMsg, "Aten��o")
Return


/*-------------------------------------------------*
 | Fun��o: fCalcIdade                              |
 | Autor:  Daniel Atilio                           |
 | Data:   13/12/2015                              |
 | Descr.: Fun��o que calcula a idade da Pessoa    |
 *-------------------------------------------------*/
Static Function fCalcIdade(dNascimento)
	Local nIdade
	
	//Chamando a fun��o YearSub para subtrair os anos de uma data
	nIdade := DateDiffYear(dDataBase, dNascimento)
Return nIdade
