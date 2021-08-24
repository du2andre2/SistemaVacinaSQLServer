/*
    Nome: TRG_ATUALIZA_LOTE
    Descricao : ATUALIZA A QUANTIDADE DE LOTE TODA VEZ QUE FOR ADICIONADO UM AGENDAMETO
*/
CREATE OR ALTER TRIGGER TRG_ATUALIZA_LOTE
ON TB_ADS_AGDM
FOR INSERT
AS BEGIN
	DECLARE @COD_LOTE INT

	SELECT @COD_LOTE = COD_LOTE FROM INSERTED

	UPDATE TB_ADS_LOTE SET QTD_VAC = QTD_VAC - 1
	WHERE COD_LOTE = @COD_LOTE;
END;