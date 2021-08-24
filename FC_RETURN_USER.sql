/*
    Nome: FC_RETURN_USER
    Descricao : retorna o usuario
    Parametros:
        @CPF            CHAR(11),
    Exemplo de execução:
        SELECT dbo.FC_RETURN_USER('21312313123')
*/
--CRIACAO OU ALTERACAO FUNCTION
CREATE OR ALTER FUNCTION FC_RETURN_USER (@CPF CHAR(11))
RETURNS VARCHAR(50)
BEGIN 
	RETURN(
		SELECT 
			USR.NOM_USER
		FROM TB_ADS_USER USR
		WHERE 
			USR.COD_CPF = @CPF
	); 
END;