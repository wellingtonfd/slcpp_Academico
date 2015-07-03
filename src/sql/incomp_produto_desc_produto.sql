CREATE OR REPLACE FUNCTION incomp_produto_desc_produto(IN p_numonu integer)
  RETURNS SETOF integer AS
$BODY$
		BEGIN
			RETURN QUERY
			SELECT p2.numonu , p1.desc_produto from incompatibilidade(p_numonu) as p2 inner join produto as p1 on p1.num_onu = p2.numonu;

		END;
		$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;