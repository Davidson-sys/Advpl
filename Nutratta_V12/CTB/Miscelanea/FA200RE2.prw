#include "PROTHEUS.ch"
 

/*
__________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  � FA200RE2  � Utilizador � CARLOS GOMES� Data � 23/09/13���
��+----------+------------------------------------------------------------���
���Descri��o � Ponto de Entrada na rejei��o do titulo                     ���
���          � Utilizado para definir a variavel STRLCTPAD				  ���
���          � 															  ���
��+----------+------------------------------------------------------------���
��� Uso      �                                                    ���    
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  

User Function FA200RE2()

PutGlbValue("STRLCTPAD",SE1->E1_SITUACA)
GlbUnLock()

Return