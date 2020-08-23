#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//--------------------------------------------------------------------------
/* {Protheus.doc} MT120FIM

LOCALIZA��O: 
O ponto se encontra no final da fun��o A120PEDIDO.

EM QUE PONTO: 
Ap�s a restaura��o do filtro da FilBrowse depois de 
fechar a opera��o realizada no pedido de compras, 
� a ultima instru��o da fun��o A120Pedido.

http://tdn.totvs.com/display/public/PROT/MT120FIM	

Empresa - Copyright -Nutratta Nutri��o Animal.
@author Davidson Clayton
@since 21/09/2016
@version P11 R8   

@return Logico (.T. ou .F.)
*/
//--------------------------------------------------------------------------
User Function MT120FIM()

Local nOpcao 	:= PARAMIXB[1]   	// Op��o Escolhida pelo usuario 
Local cNumPC 	:= PARAMIXB[2]   	// Numero do Pedido de Compras
Local nOpcA  	:= PARAMIXB[3]  	// Indica se a a��o foi Cancelada = 0  ou Confirmada = 1.CODIGO DE APLICA��O DO USUARIO.....
Local lRet		:=.T.

//Confirma��o. 2-Visualizar 3-Incluir; 4-Alterar ;5-Excluir.          
If nOpcA == 1 .And. NOPCAO == 3 .Or. NOPCAO == 4  

//--Forma de Pagamento no Pedido de Compras.
	U_ACOM001()  
EndIf

Return