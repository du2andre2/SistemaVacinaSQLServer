/*
	Nome: usp_ads_inter_retorna_agendamentos
	Descricao : retorna lista de agendamentos.
	parametros:
		@dt_hr_agdm_ini	DATETIME,	--OBRIGATORIO
		@dt_hr_agdm_fim	DATETIME,	--OBRIGATORIO
		@cpf_user		CHAR(11),
		@cpf_vol		CHAR(11),
		@cep			CHAR(8),
		@lote			INT,
		@codagdm		BIGINT,
	Exemplo de execução:
		EXEC usp_ads_inter_retorna_agendamentos @dt_hr_agdm_ini='20210816 00:00',@dt_hr_agdm_fim='20210817 23:59', @cpf_user = '' , @cpf_vol = '', @cep = ''	,	@lote = '' ,@codagdm = ''
		 
*/
--CRIACAO OU ALTERACAO PROCEDURE
CREATE OR ALTER PROCEDURE usp_ads_inter_retorna_agendamentos(
	@dt_hr_agdm_ini	DATETIME,
	@dt_hr_agdm_fim	DATETIME,S
	@cpf_user		VARCHAR(11),
	@cpf_vol		VARCHAR(11),
	@cep			VARCHAR(8),
	@lote			INT,
	@codagdm		BIGINT
)
AS
BEGIN
	
	--CRIACAO DE VARIAVEIS AUXILIARES
	DECLARE @cmdsql VARCHAR(2000) = ''
	DECLARE @condicionais VARCHAR(1000) = ''

	--VERIFICACAO DE FILTROS PARA CRIACAO DE CONDICAO DINAMICA
	IF @codagdm <> ''
    	SET @condicionais = 'AND  AGDM.COD_AGDM = ''' + CAST(@codagdm AS VARCHAR(11)) + '''  '
	IF @cpf_user <> ''
    	SET @condicionais = 'AND  AGDM.COD_CPF_USER = ''' + @cpf_user + '''  '
    IF @cpf_vol <> ''
    	SET @condicionais = @condicionais+ 'AND  AGDM.COD_CPF_VOL = ''' + @cpf_vol + '''  '
    IF @cep <> ''
    	SET @condicionais = @condicionais+ 'AND  AGDM.COD_CEP = ''' + @cep + '''  '  
	 IF @lote <> ''
    	SET @condicionais = @condicionais+ 'AND  AGDM.COD_LOTE  = ''' + CAST(@lote AS VARCHAR(11)) + '''  '  

	--CRIACAO COMANDO SQL DINAMICO
	SET @cmdsql =	'SELECT '+ 
					'	AGDM.COD_AGDM AS AGENDAMENTO, '+ 
					'	AGDM.COD_CPF_USER AS CPF_USUARIO, '+ 
					'	DBO.FC_RETURN_USER(AGDM.COD_CPF_USER) AS NOME_USUARIO, '+ 
					'	AGDM.COD_CPF_VOL AS CPF_VOLUNTARIO, '+ 
					'	DBO.FC_RETURN_USER(AGDM.COD_CPF_VOL) AS NOME_VOLUNTARIO, '+ 
					'	LOC.COD_CEP AS CEP, '+ 
					'	DBO.FC_MONTA_END(LOC.COD_CEP,LOC.NUM) AS ENDERECO, '+ 
					'	AGDM.DAT_AGDM AS DATA, '+ 
					'	LOTE.COD_LOTE AS LOTE, '+ 
					'	EMPS.NOM_EMPS AS EMPRESA, '+ 
					'	AGDM.TXT_EXT AS TEXTO_EXTRA '+ 
					'FROM TB_ADS_AGDM AGDM '+ 
					'INNER JOIN TB_ADS_LOC LOC '+
					'	ON  AGDM.COD_CEP = LOC.COD_CEP '+
					'INNER JOIN TB_ADS_LOTE LOTE '+
					'	ON  AGDM.COD_LOTE = LOTE.COD_LOTE '+
					'INNER JOIN TB_ADS_EMPS EMPS '+
					'	ON  EMPS.COD_EMPS = LOTE.COD_EMPS '+
					'WHERE	AGDM.DAT_AGDM BETWEEN ''' + CAST( @dt_hr_agdm_ini as VARCHAR(23)) + '''  AND ''' + CAST( @dt_hr_agdm_fim   as VARCHAR(23)) + ''' '+
							@condicionais;
	--EXECUCAO COMANDO
	EXEC(@cmdsql);
					
END
GO