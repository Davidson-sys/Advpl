//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} zExecView
Fun��o de teste que demonstra o funcionamento da FWExecView
@type function
@author Atilio
@since 24/10/2016
@version 1.0
    @example
    u_zExecView()
@obs Se a rotina tiver grid, provavelmente ser� necess�rio declarar a vari�vel "n" como private
/*/
User Function zExecView()
    
    Local aArea := GetArea()
    Local cFunBkp     := FunName()

    DbSelectArea('Z02')
    Z02->(DbSetOrder(1)) //Filial + C�digo

    //Se conseguir posicionar
    If Z02->(DbSeek(FWxFilial('Z02') + "000002"))
        SetFunName("zModel1")
        FWExecView('Visualizacao Teste', 'zModel1', MODEL_OPERATION_VIEW)
        SetFunName(cFunBkp)
    EndIf

    RestArea(aArea)
Return
