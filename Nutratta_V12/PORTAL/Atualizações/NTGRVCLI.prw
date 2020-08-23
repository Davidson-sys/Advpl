#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

/*/{Protheus.doc} NTGRVCLI
// Executado apos a efetivação do prospect (apos gravacao SA1)
// Uso: Usuado pelo cliente para tratar campos customizados do prospect para o cliente.
// No ponto de entrada, está posicionado na SA1 e na SUS, basta fazer reclock e gravar os registros customizados
@author Daniel Ratkevicius
@since 14/06/2017
@version 1.0
@type function
/*/

User Function NTGRVCLI()
	
	DbSelectArea("SA1")
	SA1->(Reclock("SA1",.F.))
	SA1->A1_PESSOA	:= SUS->US_PESSOA
	SA1->A1_NREDUZ	:= SUS->US_NOME	
	SA1->A1_COD_MUN	:= SUS->US_COD_MUN
	SA1->A1_DTNASC	:= SUS->US_DTNASC	
	SA1->A1_CGC		:= SUS->US_CGC
	SA1->A1_PAIS	:= SUS->US_PAIS
	SA1->A1_DDD		:= SUS->US_DDD          
	SA1->A1_ZTELFIX	:= SUS->US_ZTELFIX                
	SA1->A1_ZDDFX	:= SUS->US_ZDDFX 
	SA1->A1_TEL		:= SUS->US_TEL 
	SA1->A1_EMAIL	:= SUS->US_EMAIL 
	SA1->A1_PFISICA	:= SUS->US_PFISICA 
	SA1->A1_NATUREZ	:= SUS->US_NATUREZ
	SA1->A1_CODPAIS	:= "01058"	                        
	SA1->A1_REGIAO	:= "005" //Região do cliente	                          
	SA1->A1_MSBLQL	:= '1' //Bloqueado.	                          
	
	SA1->(MsUnlock())
	
Return(Nil)