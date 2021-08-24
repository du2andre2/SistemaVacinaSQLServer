/*
	Nome: usp_ads_delete_agendamento
	Descricao : Deleta um agendamento.
	Filtros:
		@COD_AGDM		BIGINT,		--OBRIGATORIO
	Exemplo de execução:
		EXEC usp_ads_delete_agendamento @COD_AGDM = 1419
		 
*/
--CRIACAO OU ALTERACAO PROCEDURE
CREATE OR ALTER PROCEDURE usp_ads_delete_agendamento(
	@COD_AGDM	BIGINT
)
AS
BEGIN

	BEGIN TRY
		--EXECUCAO COMANDO
		DELETE FROM TB_ADS_AGDM WHERE COD_AGDM = @COD_AGDM ;
    END TRY
    BEGIN CATCH
        SELECT
            ERROR_NUMBER() AS ErrorNumber
           ,ERROR_MESSAGE() AS ErrorMessage;
    END CATCH					
END
GO