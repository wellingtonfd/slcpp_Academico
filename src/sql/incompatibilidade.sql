CREATE OR REPLACE FUNCTION incompatibilidade(p_numonu integer)
	RETURNS TABLE (
		numonu integer
		) AS
		$$
		BEGIN
			RETURN QUERY
			SELECT 
				c.numonu
			FROM 
				produto p,
				tipo_comp t,
				compatibilidade c
			WHERE
				p.num_onu = p_numonu
				AND
				p_numonu != c.numonu
				AND
				p.classe = t.id_classe
				AND
				t.id_tipo_comp = c.id_tipo_comp;

		END;
		$$
			LANGUAGE plpgsql;
	ALTER FUNCTION incompatibilidade(integer)
	OWNER TO slcpp;