#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//--------------------------------------------------------------------------
/* {Protheus.doc} NTVLDTRANSP
Função para realizar a validação do Transportador.

Verifica se o PIS do fornecedor esta preenchido, caso contrario exibe a 
tela para realizar a gravação do dados -

Especifico RH Nutratta-SEFIP.

Função chamada na validação do campo - DUP_CODMOT.

Empresa - Copyright - P2P Nutratta Nutrição Animal.
@author Davidson Clayton
@since 10/10/2016
@version P11 R8   

@return Logico (.T. ou .F.)
*/
//--------------------------------------------------------------------------
User Function NTVLDTRANSP

Local aAreaDup	:= GetArea()
Local cPis			:= Space(12)
Local cCodMot		:=M->DUP_CODMOT
Local cCGC			:=""
Local cTipo		:=""
Local cCodigo		:=""
Local cLoja		:=""
Local cNome		:=""
Local cFornec		:=""
Local lRet			:= .T.

Private oGet1 
Private oDlg1		

//--Dados do motorista DA4-Codigo do motorista.
dbSelectArea("DA4")
dbSetOrder(1)
If dbSeek(xFilial("DA4")+cCodMot)

	cNome	:=DA4->DA4_NOME
	cTipo	:=DA4->DA4_TIPMOT
	cFornec:=DA4->DA4_FORNEC
	cLoja	:=DA4->DA4_LOJA
	cCgc	:=DA4->DA4_CGC
EndIf

//--Motorista terceiro
If cTipo == "2" //1=Proprio 2=Terceiro 3=Agregado.
	
	//--Dados do fornecedor SA2-Cadastro de fornecedores.
	dbSelectArea("SA2")
	dbSetOrder(1)
	If dbSeek(xFilial("SA2")+Padr(cFornec,8,"")+Padr(cLoja,4,""))

		If Empty(SA2->A2_N_PIS)
			lRet := .F.

			//--Solicita ao usuario que informe o PIS do autonomo.
			DEFINE MSDIALOG oDlg1 FROM 190,367 TO 250,750 PIXEL TITLE OemToAnsi("Informe o PIS do Transportador.")

			TSay():New(012,005,{||OemToAnsi("PIS:")},oDlg1,,,,,,.T.,CLR_BLUE,CLR_WHITE,032,008)
			oGet1:=TGet():New(010,040,{|u| if(PCount()>0,cPis:=u,cPis)},oDlg1,050,010,"@E 999999999999 ",,,,,,,.T.,,,,,,,,,,"cPis")
			
			@ 10,100 BUTTON  oButton PROMPT "Confirmar" OF oDlg1 PIXEL ACTION  fGravPis(cFornec,cLoja,cPis)
	
			Activate MsDialog oDlg1 Center
		Else	
			lRet:=.T.
		EndIf
	EndIf
EndIf

RestArea(aAreaDup)
Return(lRet)


//--------------------------------------------------------------------------
/* {Protheus.doc} fGravPis
Função para realizar a gravação do PIS do Transportador autonomo.

Empresa - Copyright - P2P Nutratta Nutrição Animal.
@author Davidson Clayton
@since 10/10/2016
@version P11 R8   

*/
//--------------------------------------------------------------------------
Static Function fGravPis(cFornec,cLoja,cPis)

If Empty(cPis)

	Aviso("Nutrata","Favor preencher o numero do PIS do motorista.",{"Voltar"})
	lRet:=.F.
Else

	//--Grava o PIS do autonomo.
	dbSelectArea("SA2")
	dbSetOrder(1)
	If dbSeek(xFilial("SA2")+cFornec+cLoja)

		RecLock("SA2",.F.)
		Replace SA2->A2_N_PIS  With  cPis
		MSUnlock()

		MSgInfo("PIS gravado com sucesso!!!")
		oDlg1:End()
	EndIf
EndIf
Return		
		
		


