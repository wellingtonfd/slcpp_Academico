CREATE or REPLACE FUNCTION incompatibilidade (IN p_numonu INTEGER) RETURNS TABLE (numonu integer ) AS $$
BEGIN
		CASE
		WHEN (SELECT p.classe FROM produto p WHERE p.num_onu = p_numonu) = 16 AND (SELECT p.grp_embalagem FROM produto p WHERE p.num_onu = p_numonu) = 'I' THEN RETURN QUERY SELECT p.num_onu FROM produto p WHERE p.classe = ANY('{7,10,11,12,13,14,15,19}');
		WHEN (SELECT p.classe FROM produto p WHERE p.num_onu = p_numonu) = ANY('{7,10,11,12,13,14,15,19}') THEN RETURN QUERY SELECT p.num_onu FROM produto p WHERE p.classe = 16 AND p.grp_embalagem = 'I';
		WHEN (SELECT p.classe FROM produto p WHERE p.num_onu = p_numonu) = 15 THEN RETURN QUERY SELECT p.num_onu FROM produto p WHERE p.num_onu = ANY('{3101,3102,3111,3112}');
		WHEN (SELECT p.num_onu FROM produto p WHERE p.num_onu = p_numonu) = ANY('{3101,3102,3111,3112}') THEN RETURN QUERY SELECT p.num_onu FROM produto p WHERE p.classe = 15;
		WHEN (SELECT p.classe FROM produto p WHERE p.num_onu = p_numonu) = 11 THEN RETURN QUERY SELECT p.num_onu FROM produto p WHERE p.num_onu = ANY('{3221,3222,3231,3232}');
		WHEN (SELECT p.num_onu FROM produto p WHERE p.num_onu = p_numonu) = ANY('{3221,3222,3231,3232}') THEN RETURN QUERY SELECT p.num_onu FROM produto p WHERE p.classe = 11;
		WHEN (SELECT p.classe FROM produto p WHERE p.num_onu = p_numonu) = 10 THEN RETURN QUERY SELECT p.num_onu FROM produto p WHERE p.classe = 14;
		WHEN (SELECT p.classe FROM produto p WHERE p.num_onu = p_numonu) = 14 THEN RETURN QUERY SELECT p.num_onu FROM produto p WHERE p.classe = 10;
		WHEN (SELECT p.classe FROM produto p WHERE p.num_onu = p_numonu) = 8 THEN RETURN QUERY SELECT p.num_onu FROM produto p WHERE p.classe = ANY('{11,12,13,14,15}');
		WHEN (SELECT p.classe FROM produto p WHERE p.num_onu = p_numonu) = ANY('{11,12,13,14,15}') THEN RETURN QUERY SELECT p.num_onu FROM produto p WHERE p.classe = 8;
		ELSE null;
		END CASE;
END ;
$$ LANGUAGE plpgsql;