#Include "Rwmake.ch"
#Include "Colors.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"
#Include "Totvs.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} NT_TRANSFCLI
Rotina para realizar a transferencia entre carteiras.
@author 	Davidson-P2P
@since 		08/02/2018
@version 	P11 R8
@param   	
@return   
u_NT_TRANSFCLI()
@obs     
xxx......
/*/
//-------------------------------------------------------------------
User Function NT_TRANSFCLI()

	Local _cVendedor	:=	SA3->A3_COD
	Local _cNomVend		:=	SA3->A3_NOME

	Private oDlg
	Private oLbx1,oLbx2,oLbx4,oLbx5
	Private oFld
	Private oBtn
	Private oFont1     	:= TFont():New( "Calibri",0,16,,.T.,0,,700,.T.,.F.,,,,,, )
	Private oFont2		:= TFont():New( "Arial",0,24,,.T.,,,,.F.,.F.,,,,,, )

	Private aTitles		:= {"Transf. Clientes",}
	Private aCliente	:= {{"","",""}}

	oDlg := MsDialog():New(000,000,550,950,"Transferencia carteiras",,,.F.,,,,,,.T.,,,.T.)

	oFld := tFolder():New(025,005,aTitles,{},oDlg,,,,.T.,.F.,468,228)
	//oFld:bSetOption:={|nIndo|FldMuda(nIndo,oFld:nOption,@oDlg,@oFld)}

	//Realiza a carga dos dados do cliente
	fCarregaDados(_cVendedor)

	//Cliente ======================================================================
	@ 005,005 LISTBOX oLbx1 FIELDS HEADER "Codigo","Loja","Nome" SIZE 180,205 PIXEL OF oFld:aDialogs[1]
	oLbx1:SetArray(aCliente)
	oLbx1:bLine := { || {	aCliente[oLbx1:nAt,01],	aCliente[oLbx1:nAt,02],	aCliente[oLbx1:nAt,03]}}

	oBtn := tButton():New(258,435,"Sair",oDlg,{||zFechaTela()},036,012,,,,.T.,,"",,,,.F.)

	ACTIVATE MSDIALOG oDlg CENTERED

Return( NIL )


//-------------------------------------------------------------------
/*/{Protheus.doc} fCarregaDados.
Reaizar a carga dos dados do cliente
@Author   Davidson Carvalho
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	Retorno da Static Function
xxxxx
/*/
//-----------------------------------------------------------------------------------------------------------
Static Function fCarregaDados(_cVendedor)

	Local cAliasFor := GetNextAlias()
	Local cAliasProd := GetNextAlias()
	Local cSql      := ""

	// 1º  Folder Cliente
	dbSelectArea("SA1")
	SA1->( dbSetOrder(1) )
	SA1->( dbGoTop())

	aCliente := {}

	While ! SA1->( EOF() )

		If SA1->A1_VEND ==	_cVendedor

			aAdd ( aCliente, { SA1->A1_COD   ,;
				SA1->A1_LOJA  ,;
				SA1->A1_NREDUZ,;
				SA1->A1_EST   ,;
				IIF( SA1->A1_MSBLQL <> "1" , "Não","Sim" ) } )
		EndIf
		SA1->(dbSkip())
	EndDo

	If Empty(aCliente)
		aCliente	:=	{{"","",""}}

	EndIf
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} zFechaTela.
Fecha da tela aberta
@Author   Davidson Carvalho
@Since 	   99/99/9999
@Version 	12.1.25
@param   	n/t
@return  	Retorno da Static Function
xxxxx
/*/
//-----------------------------------------------------------------------------------------------------------
Static Function zFechaTela()

	oDlg:END()

Return(NIL)

