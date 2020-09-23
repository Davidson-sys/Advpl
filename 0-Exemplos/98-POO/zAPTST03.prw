#INCLUDE "protheus.ch"

// --------------------------------------------------
// Fonte de teste da classe APBUTTON herdando tButton
User Function APPTST03()

    Local oDlg , oBtn1, oBtn2

    DEFINE DIALOG oDlg TITLE "Exemplo de Heran�a" FROM 10,10 TO 150,300 COLOR CLR_BLACK,CLR_WHITE PIXEL

    // Cria um botao normal
    // e seta cor diferenciada para o bot�o
    @ 10,5 BUTTON oBtn1 PROMPT 'TBUTTON' ;
        ACTION ( oBtn2:Show() , oBtn1:Hide() ) ;
        SIZE 040, 013 OF oDlg PIXEL

    // Cria um botao usando a classe implementada
    oBtn2 := APBUTTON():NEW(oDlg, "APBUTTON", 30, 5, 40, 13, {|| oBtn1:Show(),oBtn2:Hide() })

    ACTIVATE DIALOG oDlg CENTER
Return

// ------------------------------------------------------------
CLASS APBUTTON FROM TBUTTON
    METHOD New() CONSTRUCTOR
    METHOD Hide()
    METHOD Show()
ENDCLASS

// Construtor da classe inicializa construtor do bot�o 
// e j� seta todas as propriedades e comportamentos desejados
// ( Troca fonte, seta cor e esconde o bot�o ) 
METHOD New(oParent,cCaption,nTop,nLeft,nWidth,nHeight,bAction) CLASS APBUTTON
    :New(nTop,nLeft,cCaption,oParent,bAction,nWidth,nHeight,NIL,NIL,NIL,.T.)
    ::SetColor(CLR_WHITE,CLR_BLACK)
    ::SetFont( TFont():New("Courier New",,14))
    _Super:Hide()
Return self

METHOD Hide() CLASS APBUTTON
    MsgInfo("Escondendo o bot�o ["+::cCaption+"]")
Return _Super:Hide()

METHOD Show() CLASS APBUTTON
    MsgInfo("Mostrando o bot�o ["+::cCaption+"]")
Return _Super:Show()
