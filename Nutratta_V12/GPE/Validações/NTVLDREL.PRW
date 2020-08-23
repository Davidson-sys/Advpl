#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

//--------------------------------------------------------------------------
/*{Protheus.doc} fVldPCPGPE
Função para validar o usuario PCP nos relatorios GPE
Empresa - Copyright -Nutratta Nutrição Animal.
@author Davidson Clayton
@since 09/08/2018
@version P11 R8
*/
//--------------------------------------------------------------------------

User Function  fVldPCPGPe() 
    
Local _cUsuarios :='000064/000075/000150/000160/000161/000162/000166'   

/*--------------------------------------------------------------------------
'000064' - THIAGO GODOI 
'000075' - GRAZIELE AQUINO
'000150' - ROMARIO SILVA
'000160' - WILSON SENSU
'000161' - ERICK SIQUEIRA
'000162' - FELIPE MACHADO
'000166' - TESTE TI   
--------------------------------------------------------------------------*/
 
                                                            
//*1-Relatorios Periodicos /Folha pagamento
_cCodUser :=	RetCodUsr()

If FUNNAME()=="GPER040" 			//GPE106R4 - Pergunta utilizada

	If _cCodUser $ _cUsuarios 
	
	   mv_par06 :='50000'+'-'+'60000' 
	EndIf  
EndIf                   


//2-Ferias/Programação de ferias 
If FUNNAME()=="GPER400" 			//GP400RA-- Pergunta utilizada                                                                                                                                                                                                                                                        			
	If _cCodUser $ _cUsuarios 
	
	   mv_par02 :='50000'+'-'+'60000'  
	
	EndIf
EndIf  


//3-Relatorio de banco de horas
If FUNNAME()=="PONR100"  			//PN100R-- Pergunta utilizada                                                                                                                                                                                                                                                         -- Pergunta utilizada  			
	If _cCodUser $ _cUsuarios 
	 
	   mv_par02 :='50000'+'-'+'60000'  
	
	EndIf
EndIf 

//4-Extrato de banco de horas
If FUNNAME()=="EXTRABH" 			//EXTRBH-- Pergunta utilizada		
	If _cCodUser $ _cUsuarios 
	
		mv_par03 :='50000'  
		mv_par04 :='60000'  
	EndIf
EndIf
 
Return 

 
