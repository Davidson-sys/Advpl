#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//--------------------------------------------------------------------------
/* {Protheus.doc} MT120FIM

LOCALIZAÇÃO: 
O ponto se encontra no final da função A120PEDIDO.

EM QUE PONTO: 
Após a restauração do filtro da FilBrowse depois de 
fechar a operação realizada no pedido de compras, 
é a ultima instrução da função A120Pedido.

http://tdn.totvs.com/display/public/PROT/MT120FIM	

Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 21/09/2016
@version P11 R8   

@return Logico (.T. ou .F.)
*/
//--------------------------------------------------------------------------
User Function MT120FIM()

Local nOpcao 	:= PARAMIXB[1]   	// Opção Escolhida pelo usuario 
Local cNumPC 	:= PARAMIXB[2]   	// Numero do Pedido de Compras
Local nOpcA  	:= PARAMIXB[3]  	// Indica se a ação foi Cancelada = 0  ou Confirmada = 1.CODIGO DE APLICAÇÃO DO USUARIO.....
Local lRet		:=.T.

//Confirmação. 2-Visualizar 3-Incluir; 4-Alterar ;5-Excluir.          
If nOpcA == 1 .And. NOPCAO == 3 .Or. NOPCAO == 4  

//--Forma de Pagamento no Pedido de Compras.
	U_ACOM001()  
EndIf

Return