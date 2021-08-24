/*
	Nome: usp_ads_inter_volume_agdm_minuto
	Descricao : retorna volumetria e percentual de agendamentos por minuto.
	parametros:
		@data_agdm		DATE,	--OBRIGATORIO
		@hr_agdm_ini	TIME,	--OBRIGATORIO
		@hr_agdm_fim	TIME,	--OBRIGATORIO
		@cpf_user		CHAR(11),
		@cpf_vol		CHAR(11),
		@cep			CHAR(8),
		@lote			INT,
	Exemplo de execução:
		EXEC usp_ads_inter_volume_agdm_minuto @data_agdm='20210813',@hr_agdm_ini='00:00',@hr_agdm_fim='23:59', @cpf_user = '' , @cpf_vol = '', @cep = '13188021',@lote = 2

*/
--CRIACAO OU ALTERACAO PROCEDURE
CREATE OR ALTER PROCEDURE usp_ads_inter_volume_agdm_minuto(
	@data_agdm		DATE, 
	@hr_agdm_ini	TIME,
	@hr_agdm_fim	TIME,
	@cpf_user		VARCHAR(11),
	@cpf_vol		VARCHAR(11),
	@cep			VARCHAR(8),
	@lote			INT
)
AS
BEGIN
	
	--CRIACAO DE VARIAVEIS AUXILIARES
	DECLARE @cmdsql VARCHAR(1000) = ''
	DECLARE @condicionais VARCHAR(1000) = ''

	--CRIACAO DE TABELA TEMPORARIA PARA CONSOLIDAR DADOS DE RETORNO
	CREATE TABLE #RETORNO(
		HORA CHAR(5),
		VOLUME INT,
		PERCENTUAL DECIMAL(6,3)
	); 
	
	--SETANDO VALORES PADROES NOS FILTROS CASO SEJAM VAZIOS
	IF @hr_agdm_ini = ''
			SET @hr_agdm_ini = CAST('00:00' as TIME)
                
	IF @hr_agdm_fim = ''
			SET @hr_agdm_fim = CAST('23:59' as TIME)
    
	--CONVERTENDO FILTROS EM DATETIME
	DECLARE @dat_hr_agdm_ini DATETIME = CAST(@data_agdm as DATETIME) + CAST(@hr_agdm_ini as DATETIME);
	DECLARE @dat_hr_agdm_fim DATETIME = CAST(@data_agdm as DATETIME) + CAST(@hr_agdm_fim as DATETIME);

	--VERIFICACAO DE FILTROS PARA CRIACAO DE CONDICAO DINAMICA
	IF @cpf_user <> ''
    	SET @condicionais = 'AND  AGDM.COD_CPF_USER = ''' + @cpf_user + '''  '
    IF @cpf_vol <> ''
    	SET @condicionais = @condicionais+ 'AND  AGDM.COD_CPF_VOL = ''' + @cpf_vol + '''  '
    IF @cep <> ''
    	SET @condicionais = @condicionais+ 'AND  AGDM.COD_CEP = ''' + @cep + '''  '  
	IF @lote <> ''
    	SET @condicionais = @condicionais+ 'AND  AGDM.COD_LOTE = ''' + CAST(@lote AS VARCHAR(11)) + '''  '  

	--CRIACAO COMANDO SQL DINAMICO
	SET @cmdsql =	'INSERT INTO #RETORNO(HORA,VOLUME)'+
					'	SELECT '+ 
					'		FORMAT(AGDM.DAT_AGDM ,''HH:mm''), '+ 
					'		COUNT(AGDM.COD_AGDM) '+ 
					'	FROM TB_ADS_AGDM AGDM '+ 
					'	WHERE	AGDM.DAT_AGDM BETWEEN ''' + CAST( @dat_hr_agdm_ini as VARCHAR(23)) + '''  AND ''' + CAST( @dat_hr_agdm_fim   as VARCHAR(23)) + ''' '+
							@condicionais+
					'	GROUP BY '+ 
					'		FORMAT(AGDM.DAT_AGDM ,''HH:mm'') ';
	--EXECUCAO COMANDO
	EXEC(@cmdsql);
    
	--CRIANDO VARIAVEL AUXILIAR PARA GUARDAR TOTAL DE TRANSACOES
	DECLARE @total DECIMAL(6,3) = (SELECT SUM(VOLUME) FROM #RETORNO); 

	--CALCULANDO PERCENTUAL DO VOLUME POR MINUTO
	UPDATE #RETORNO
		SET PERCENTUAL = CAST(VOLUME AS DECIMAL(6,3))*100/@total;

	--RETORNANDO DADOS DA TABELA TEMPORARIA
	SELECT
		R.HORA,
		R.VOLUME,
		R.PERCENTUAL
	FROM 
		#RETORNO R

END
GO
