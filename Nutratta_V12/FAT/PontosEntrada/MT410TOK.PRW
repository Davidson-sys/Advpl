#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MT410TOK
Ponto de Entrada para validar a tela de pedido de 
vendas Nutratta.

@author Davidson-Nutratta
@since  27/07/2017
@version 1.0 

@param  N/H

@return Logico (.T. ou .F.)
/*/

User Function MT410TOK()

//Local _aAreaAnt 	:= GetArea()
Local _oProcess   	:= NIL
Local _cFilial		:= xFilial("SC5")
Local _cCliente		:= M->C5_CLIENTE 
Local _cLoja		:= M->C5_LOJACLI 
Local _cVendedor	:= M->C5_VEND1
Local _cNumped		:= M->C5_NUM  
Local _nOpc      	:= PARAMIXB[1]	//Opcao de manutencao
Local _aRecTiadt 	:= PARAMIXB[2]	//Array com registros de adiantamentoc
Local _lTipo		:= IIF(M->C5_TPFRETE=='C',.T.,.F.)
Local _cAtivaPE		:= SuperGetMv("MV_VLDLOC",.F.,"")
Local _lEnd	   		:= .F.
Local _lRet			:= .T.
Local _cAtivaPE		:= .F.
Local _cTipPV	 	:= M->C5_TIPO


If _cAtivaPE //.And. _lTipo
	If _nOpc == 3 .Or. _nOpc == 4 //INCLUSAO E ALTERAÇÃO.
		If  'N' $ _cTipPV
			//		_oProcess := MsNewProcess():New( { |_lEnd| _lRet:= StaticCall(NT_Release,fProcLib,_lEnd,_oProcess,_cFilial,_cNumped)} ,"Pedidos de Venda...", "Validando pedido de vendas...", .F. )
			//		_oProcess:Activate()
			
			//		_oProcess := MsNewProcess():New( { |_lEnd| U_GFAT003()} ,"Pedidos de Venda...", "Validando Margem Contribuição...", .F. )
			//		_oProcess:Activate()
			
			//		_oProcess := MsNewProcess():New( { |_lEnd| U_GFAT005()} ,"Pedidos de Venda...", "Validando descontos Nutratta...", .F. )
			//		_oProcess:Activate()
			_lRet:= U_GFAT005()	//Chama a função para calculo dos descontos Nutratta.
		EndIf
	EndIf
EndIf

//-----------------------------------------------------------------------------------
// Validação Cliente x Vendedor.
//-----------------------------------------------------------------------------------
/*If dbSeek(_cFilial+_cCliente+_cLoja)
	If	SA1->A1_VEND != _cVendedor
    
		Aviso("Atenção","Vendedor Selecionado não pertence ao cadastro do cliente .!! Favor Verificar.",{"OK"},2)
		_lRet:=.T.                            
	EndIf
EndIf*/

//RestArea(_aAreaAnt)
Return(_lRet)