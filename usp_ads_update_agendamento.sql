/*
	Nome: usp_ads_update_agendamento
	Descricao : Atualiza um agendamento.
	Filtros:
		@COD_AGDM		BIGINT,		--OBRIGATORIO
		@COD_CPF_USER	CHAR(11),
		@COD_CPF_VOL	CHAR(11),
		@COD_CEP		CHAR(8),
		@DATA_AGDM		DATETIME,
		@TXT_EXT		VARCHAR(200)
	Exemplo de execu��o:
		EXEC usp_ads_update_agendamento @COD_AGDM = '', @COD_CPF_USER='', @COD_CPF_VOL='', @COD_CEP ='', @DATA_AGDM='20210816 00:00', @TXT_EXT=''
		 
*/
--CRIACAO OU ALTERACAO PROCEDURE
CREATE OR ALTER PROCEDURE usp_ads_update_agendamento(
	@COD_AGDM		BIGINT,
	@COD_CPF_USER	CHAR(11),
	@COD_CPF_VOL	CHAR(11),
	@COD_CEP		CHAR(8),
	@DATA_AGDM		DATETIME,
	@TXT_EXT		VARCHAR(200)
)
AS
BEGIN

	BEGIN TRY
		BEGIN TRAN;            
			IF @COD_CPF_USER <> ''
				BEGIN
					UPDATE TB_ADS_AGDM 
						SET COD_CPF_USER = @COD_CPF_USER
					WHERE COD_AGDM =  @COD_AGDM;
				END
			IF @COD_CPF_VOL <> ''
				BEGIN
					UPDATE TB_ADS_AGDM 
						SET COD_CPF_VOL = @COD_CPF_VOL
					WHERE COD_AGDM =  @COD_AGDM;
				END
			IF @COD_CEP <> ''
				BEGIN
					UPDATE TB_ADS_AGDM 
						SET COD_CEP = @COD_CEP
					WHERE COD_AGDM =  @COD_AGDM;
				END
			IF @DATA_AGDM <> ''
				BEGIN
					UPDATE TB_ADS_AGDM 
						SET DAT_AGDM = @DATA_AGDM
					WHERE COD_AGDM =  @COD_AGDM;
				END
			IF @TXT_EXT <> ''
				BEGIN
					UPDATE TB_ADS_AGDM 
						SET TXT_EXT = @TXT_EXT
					WHERE COD_AGDM =  @COD_AGDM;
				END

			SELECT * FROM TB_ADS_AGDM WHERE COD_AGDM =  @COD_AGDM;
		COMMIT TRAN;   
    END TRY
    BEGIN CATCH
		IF(@@TRANCOUNT > 0)
			ROLLBACK TRAN; 
        SELECT
            ERROR_NUMBER() AS ErrorNumber
           ,ERROR_MESSAGE() AS ErrorMessage;
    END CATCH					
END
GO