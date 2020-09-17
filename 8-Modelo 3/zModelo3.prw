#Include "Rwmake.ch"
#Include "Colors.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"
#include "Totvs.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} zModelo3.
Versões: Microsiga Protheus 8.11 , Protheus 10
Exibe formulário para cadastro contendo uma enchoice e uma getdados.
@Author   Davidson Carvalho
@Since 	   31/08/2020
@Version 	12.1.25
@param   	n/t
@return  	n/t
@obs.......  
o	Especifico nome da empresa/cliente.

u_zModelo3() 		//Chamar no executor.

Programa Fonte:
MATXATU.PRW
Sintaxe:
Modelo3 ( cTitulocAliascAlias2 [ aMyEncho ] [ cLinhaOk ] [ cTudoOk ] [ nOpcE ] [ nOpcG ] [ cFieldOk ] [ lVirtual ] [ nLinhas ] [ aAltEnchoice ] [ nFreeze ] [ aButtons ] [ aCordW ] [ nSizeHeader ] ) --> lRet

Retorno:
lRet(logico)
Retorno .T. Confirma / .F. Abandona
xxx......
/*/
//--------------------------------------------------------------------
User Function zModelo3()

    Local _ni

    aRotina := {{ "Pesquisa","AxPesqui", 0 , 1},;
        { "Visual","AxVisual", 0 , 2},;
        { "Inclui","AxInclui", 0 , 3},;
        { "Altera","AxAltera", 0 , 4, 20 },;
        { "Exclui","AxDeleta", 0 , 5, 21 }}

    cOpcao := "INCLUIR"

    Do Case
    Case cOpcao == "INCLUIR"
        nOpcE := 3
        nOpcG := 3

    Case cOpcao == "ALTERAR"
        nOpcE := 3
        nOpcG := 3

    Case cOpcao == "VISUALIZAR"
        nOpcE := 2
        nOpcG := 2
    EndCase

    DbSelectArea("SC5")
    DbSetOrder(1)
    DbGotop()

    //Cria variaveis M->????? da Enchoice
    RegToMemory("SC5",(cOpcao == "INCLUIR"))

    //Cria aHeader e aCols da GetDados
    nUsado := 0
    dbSelectArea("SX3")
    DbSetOrder(1)
    DbSeek("SC6")

    aHeader := {}

    While !Eof() .And. (x3_arquivo == "SC6")
        If Alltrim(x3_campo) == "C6_ITEM"
            dbSkip()
            Loop
        Endif

        If X3USO(x3_usado) .And. cNivel >= x3_nivel
            nUsado := nUsado+1
            Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
                x3_tamanho, x3_decimal,"AllwaysTrue()",;
                x3_usado, x3_tipo, x3_arquivo, x3_context } )
        Endif

        dbSkip()

        If cOpcao == "INCLUIR"
            aCols := {Array(nUsado+1)}
            aCols[1,nUsado+1] := .F.

            For _ni := 1 to nUsado
                aCols[1,_ni] := CriaVar(aHeader[_ni,2])
            Next

            aCols := {}

            dbSelectArea("SC6")
            dbSetOrder(1)
            dbSeek(xFilial()+M->C5_NUM)
            While !eof() .And. SC6->C6_NUM == M->C5_NUM

                AADD(aCols,Array(nUsado+1))

                For _ni := 1 to nUsado
                    aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
                Next

                aCols[Len(aCols),nUsado+1] :=.F.
                dbSkip()
            End

            If Len(aCols)>0

                cTitulo := "Teste de Modelo3()"
                cAliasEnchoice := "SC5"
                cAliasGetD := "SC6"
                cLinOk := "AllwaysTrue()"
                cTudOk := "AllwaysTrue()"
                cFieldOk := "AllwaysTrue()"//aCpoEnchoice:={} //{"C5_CLIENTE"}
                _lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)

                If _lRet
                    Aviso("Modelo3()","Confirmada operacao!",{"Ok"})
                
                Endif
            Endif
        EndIf
    End
Return

//IF(!INCLUI,Posicione("DHB",1,xFilial("DHB")+SC5->C5_CODMOT,"DHB_NOMMOT"),"") 
//Resultado: em 31/08/2020 Davidson  ---> Teste com a rotina - 0% Erro inicializador padrão.
