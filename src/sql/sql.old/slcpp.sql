--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: salvadel; Type: SCHEMA; Schema: -; Owner: slcpp
--

CREATE SCHEMA salvadel;


ALTER SCHEMA salvadel OWNER TO slcpp;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: lado_char; Type: DOMAIN; Schema: public; Owner: slcpp
--

CREATE DOMAIN lado_char AS character(1)
	CONSTRAINT lote_char_check CHECK ((VALUE = ANY (ARRAY['D'::bpchar, 'E'::bpchar])));


ALTER DOMAIN public.lado_char OWNER TO slcpp;

--
-- Name: incompatibilidade(integer); Type: FUNCTION; Schema: public; Owner: slcpp
--

CREATE FUNCTION incompatibilidade(p_numonu integer) RETURNS TABLE(numonu integer)
    LANGUAGE plpgsql
    AS $$
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
		$$;


ALTER FUNCTION public.incompatibilidade(p_numonu integer) OWNER TO slcpp;

--
-- Name: salva_deletado_movimentacao(); Type: FUNCTION; Schema: public; Owner: slcpp
--

CREATE FUNCTION salva_deletado_movimentacao() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	begin
		insert into salvadel.movimentacao values (old.id_movimentacao,old.id_endarmazem,old.id_produto);
		return null;
	end;
	$$;


ALTER FUNCTION public.salva_deletado_movimentacao() OWNER TO slcpp;

--
-- Name: update_endereco(); Type: FUNCTION; Schema: public; Owner: slcpp
--

CREATE FUNCTION update_endereco() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
	--
		-- Ao inserir em movimentação o endereço inserido sera
		-- atualizado na tabela endereço de armazenagem
		--

		IF (TG_OP = 'INSERT') THEN
			-- se estatos for true retornar null
			UPDATE end_armazem SET estatos = false WHERE id_endarmazem = NEW.id_endarmazem;
			IF NOT FOUND THEN RETURN NULL; END IF;
			RETURN NEW;
		ELSIF (TG_OP = 'DELETE') THEN
			RETURN OLD;
		END IF;
	END;
$$;


ALTER FUNCTION public.update_endereco() OWNER TO slcpp;

--
-- Name: update_endereco_arm(); Type: FUNCTION; Schema: public; Owner: slcpp
--

CREATE FUNCTION update_endereco_arm() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
		--
		-- Ao inserir em movimentação o endereço inserido sera
		-- atualizado na tabela endereço de armazenagem
		--

		IF (TG_OP = 'INSERT') THEN
			-- se estatos for true retornar null
			UPDATE end_armazem SET estatos = true WHERE id_endarmazem = NEW.id_endarmazem;
			IF NOT FOUND THEN RETURN NULL; END IF;
			RETURN NEW;
		ELSIF (TG_OP = 'DELETE') THEN
			UPDATE end_armazem SET estatos = false WHERE id_endarmazem = OLD.id_endarmazem;
			IF NOT FOUND THEN RETURN NULL; END IF;
			RETURN OLD;
		END IF;
	END;
$$;


ALTER FUNCTION public.update_endereco_arm() OWNER TO slcpp;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: armazem; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE armazem (
    id_armazem integer NOT NULL,
    capacidade_armazem character varying(255),
    certificacao_armazem character varying(255),
    espec_armazem character varying(255),
    estoque_max character varying(255),
    estoque_min character varying(255),
    id_compatibilidade integer,
    id_legenda_compatibilidade integer,
    id_local_oper integer,
    id_status_armazem integer,
    tipo_armazem character varying(255),
    id_capacidade integer,
    id_endarmazem integer,
    local_operacao_id_local_oper integer,
    status_armazem_id_status_armazem integer,
    fk_id_dimensoes integer,
    fk_id_empresa integer,
    tamanho_espaco_armazenagem numeric
);


ALTER TABLE public.armazem OWNER TO slcpp;

--
-- Name: armazem_id_armazem_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE armazem_id_armazem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.armazem_id_armazem_seq OWNER TO slcpp;

--
-- Name: armazem_id_armazem_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE armazem_id_armazem_seq OWNED BY armazem.id_armazem;


--
-- Name: capacidade; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE capacidade (
    id_capacidade integer NOT NULL,
    tipo_capacidade character varying(255)
);


ALTER TABLE public.capacidade OWNER TO slcpp;

--
-- Name: capacidade_id_capacidade_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE capacidade_id_capacidade_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.capacidade_id_capacidade_seq OWNER TO slcpp;

--
-- Name: capacidade_id_capacidade_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE capacidade_id_capacidade_seq OWNED BY capacidade.id_capacidade;


--
-- Name: cidade; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE cidade (
    id_cidade integer NOT NULL,
    nome_cidade character varying(255),
    id_estado integer
);


ALTER TABLE public.cidade OWNER TO slcpp;

--
-- Name: cidade_id_cidade_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE cidade_id_cidade_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cidade_id_cidade_seq OWNER TO slcpp;

--
-- Name: cidade_id_cidade_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE cidade_id_cidade_seq OWNED BY cidade.id_cidade;


--
-- Name: classe; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE classe (
    id_classe integer NOT NULL,
    num_classe numeric,
    desc_classe character varying(450)
);


ALTER TABLE public.classe OWNER TO slcpp;

--
-- Name: combustivel; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE combustivel (
    id_combustivel integer NOT NULL,
    espec_combustivel character varying(255),
    nome_combustivel character varying(255)
);


ALTER TABLE public.combustivel OWNER TO slcpp;

--
-- Name: combustivel_id_combustivel_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE combustivel_id_combustivel_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.combustivel_id_combustivel_seq OWNER TO slcpp;

--
-- Name: combustivel_id_combustivel_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE combustivel_id_combustivel_seq OWNED BY combustivel.id_combustivel;


--
-- Name: compatibilidade; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE compatibilidade (
    id_comptibilidade integer NOT NULL,
    numonu integer,
    id_tipo_comp integer
);


ALTER TABLE public.compatibilidade OWNER TO slcpp;

--
-- Name: contatos; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE contatos (
    id_contato integer NOT NULL,
    celular character varying(255),
    email character varying(255),
    radio character varying(255),
    site character varying(255),
    tel character varying(255)
);


ALTER TABLE public.contatos OWNER TO slcpp;

--
-- Name: contatos_id_contato_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE contatos_id_contato_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contatos_id_contato_seq OWNER TO slcpp;

--
-- Name: contatos_id_contato_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE contatos_id_contato_seq OWNED BY contatos.id_contato;


--
-- Name: det_nota; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE det_nota (
    id_detalhe_nota integer NOT NULL,
    dt_pedido date,
    id_fornecedor integer,
    id_tipo_equipamento integer,
    num_nota character varying(255),
    valor_total bigint,
    valor_unitario integer,
    fornecedor_id_fornecedor integer,
    id_produto integer,
    tipo_equipamento_id_tipo_equipamento integer
);


ALTER TABLE public.det_nota OWNER TO slcpp;

--
-- Name: det_nota_id_detalhe_nota_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE det_nota_id_detalhe_nota_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.det_nota_id_detalhe_nota_seq OWNER TO slcpp;

--
-- Name: det_nota_id_detalhe_nota_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE det_nota_id_detalhe_nota_seq OWNED BY det_nota.id_detalhe_nota;


--
-- Name: dimensoes; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE dimensoes (
    id_dimensoes integer NOT NULL,
    alt_dimensao numeric,
    lar_dimensao numeric,
    comp_dimensao numeric
);


ALTER TABLE public.dimensoes OWNER TO slcpp;

--
-- Name: dimensoes_id_dimensoes_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE dimensoes_id_dimensoes_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dimensoes_id_dimensoes_seq OWNER TO slcpp;

--
-- Name: dimensoes_id_dimensoes_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE dimensoes_id_dimensoes_seq OWNED BY dimensoes.id_dimensoes;


--
-- Name: embalagem; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE embalagem (
    id_embalagem integer NOT NULL,
    capacid_pressao character varying(255),
    espec_emabalagem character varying(255),
    id_tipo_material integer,
    pt_ebulicao character varying(255),
    pt_fulgor character varying(255),
    id_capacidade integer,
    id_compatibilidade integer,
    id_grupo_embalagem integer
);


ALTER TABLE public.embalagem OWNER TO slcpp;

--
-- Name: embalagem_id_embalagem_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE embalagem_id_embalagem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.embalagem_id_embalagem_seq OWNER TO slcpp;

--
-- Name: embalagem_id_embalagem_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE embalagem_id_embalagem_seq OWNED BY embalagem.id_embalagem;


--
-- Name: empresa; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE empresa (
    id_empresa integer NOT NULL,
    razao_social character varying(255),
    endereco integer
);


ALTER TABLE public.empresa OWNER TO slcpp;

--
-- Name: empresa_id_empresa_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE empresa_id_empresa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.empresa_id_empresa_seq OWNER TO slcpp;

--
-- Name: empresa_id_empresa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE empresa_id_empresa_seq OWNED BY empresa.id_empresa;


--
-- Name: end_armazem; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE end_armazem (
    id_endarmazem integer NOT NULL,
    rua_end_armazem character varying(255),
    estatos boolean
);


ALTER TABLE public.end_armazem OWNER TO slcpp;

--
-- Name: end_armazem_id_endarmazem_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE end_armazem_id_endarmazem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.end_armazem_id_endarmazem_seq OWNER TO slcpp;

--
-- Name: end_armazem_id_endarmazem_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE end_armazem_id_endarmazem_seq OWNED BY end_armazem.id_endarmazem;


--
-- Name: end_estatos_false; Type: VIEW; Schema: public; Owner: slcpp
--

CREATE VIEW end_estatos_false AS
 SELECT end_armazem.id_endarmazem
   FROM end_armazem
  WHERE (end_armazem.estatos = false);


ALTER TABLE public.end_estatos_false OWNER TO slcpp;

--
-- Name: endereco; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE endereco (
    id_endereco integer NOT NULL,
    bairro character varying(255),
    cep character varying(255),
    complemento character varying(255),
    logadouro character varying(255),
    numero integer,
    id_cidade integer,
    id_estado integer,
    id_pais integer
);


ALTER TABLE public.endereco OWNER TO slcpp;

--
-- Name: endereco_id_endereco_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE endereco_id_endereco_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.endereco_id_endereco_seq OWNER TO slcpp;

--
-- Name: endereco_id_endereco_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE endereco_id_endereco_seq OWNED BY endereco.id_endereco;


--
-- Name: epe; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE epe (
    id_epe integer NOT NULL,
    agente_epe character varying(255),
    classe_epe character varying(255),
    nome_epe character varying(255),
    tipo_material_id_material integer
);


ALTER TABLE public.epe OWNER TO slcpp;

--
-- Name: epe_id_epe_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE epe_id_epe_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.epe_id_epe_seq OWNER TO slcpp;

--
-- Name: epe_id_epe_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE epe_id_epe_seq OWNED BY epe.id_epe;


--
-- Name: epi; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE epi (
    id_epi integer NOT NULL,
    espec_epi character varying(255),
    grupo_epi character varying(255),
    nome_epi character varying(255),
    id_material integer
);


ALTER TABLE public.epi OWNER TO slcpp;

--
-- Name: epi_id_epi_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE epi_id_epi_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.epi_id_epi_seq OWNER TO slcpp;

--
-- Name: epi_id_epi_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE epi_id_epi_seq OWNED BY epi.id_epi;


--
-- Name: est_fisico; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE est_fisico (
    id_est_fisico integer NOT NULL,
    esp_est_fisico character varying(255),
    nome_est_fisico character varying(255)
);


ALTER TABLE public.est_fisico OWNER TO slcpp;

--
-- Name: est_fisico_id_est_fisico_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE est_fisico_id_est_fisico_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.est_fisico_id_est_fisico_seq OWNER TO slcpp;

--
-- Name: est_fisico_id_est_fisico_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE est_fisico_id_est_fisico_seq OWNED BY est_fisico.id_est_fisico;


--
-- Name: estado; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE estado (
    id_estado integer NOT NULL,
    nome_estado character varying(255),
    sigla_estado character varying(255),
    id_pais integer
);


ALTER TABLE public.estado OWNER TO slcpp;

--
-- Name: estado_id_estado_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE estado_id_estado_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.estado_id_estado_seq OWNER TO slcpp;

--
-- Name: estado_id_estado_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE estado_id_estado_seq OWNED BY estado.id_estado;


--
-- Name: fornecedor; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE fornecedor (
    id_fornecedor integer NOT NULL,
    cnpj character varying(255),
    id_contato integer,
    insc_social character varying(255),
    nome_fantasia character varying(255),
    razao_social character varying(255),
    contatos_id_contato integer,
    id_endereco integer
);


ALTER TABLE public.fornecedor OWNER TO slcpp;

--
-- Name: fornecedor_id_fornecedor_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE fornecedor_id_fornecedor_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fornecedor_id_fornecedor_seq OWNER TO slcpp;

--
-- Name: fornecedor_id_fornecedor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE fornecedor_id_fornecedor_seq OWNED BY fornecedor.id_fornecedor;


--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE funcionario (
    id_funcionario integer NOT NULL,
    cargo character varying(255),
    cpf character varying(255),
    dt_admissao date,
    dt_nasc date,
    especializacao character varying(255),
    funcao character varying(255),
    id_contato integer,
    id_endereco integer,
    mat_funcionario integer,
    nivel_funcionario character varying(255),
    nome_funcionario character varying(255),
    rg character varying(255),
    sb_nome_funcionario character varying(255),
    sexo character varying(255),
    contatos_id_contato integer,
    endereco_id_endereco integer,
    id_usuario integer
);


ALTER TABLE public.funcionario OWNER TO slcpp;

--
-- Name: funcionario_id_funcionario_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE funcionario_id_funcionario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.funcionario_id_funcionario_seq OWNER TO slcpp;

--
-- Name: funcionario_id_funcionario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE funcionario_id_funcionario_seq OWNED BY funcionario.id_funcionario;


--
-- Name: grupo_embalagem; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE grupo_embalagem (
    id_grupo_embalagem integer NOT NULL,
    espec_grupo_embalagem character varying(255),
    nome_grupo_embalagem character varying(255)
);


ALTER TABLE public.grupo_embalagem OWNER TO slcpp;

--
-- Name: grupo_embalagem_id_grupo_embalagem_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE grupo_embalagem_id_grupo_embalagem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grupo_embalagem_id_grupo_embalagem_seq OWNER TO slcpp;

--
-- Name: grupo_embalagem_id_grupo_embalagem_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE grupo_embalagem_id_grupo_embalagem_seq OWNED BY grupo_embalagem.id_grupo_embalagem;


--
-- Name: item_pedido_produto; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE item_pedido_produto (
    id_pedido_produto integer NOT NULL,
    id_pedido_fk integer,
    id_produto_fk integer,
    qtd_produto numeric
);


ALTER TABLE public.item_pedido_produto OWNER TO slcpp;

--
-- Name: item_pedido_produto_id_pedido_produto_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE item_pedido_produto_id_pedido_produto_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.item_pedido_produto_id_pedido_produto_seq OWNER TO slcpp;

--
-- Name: item_pedido_produto_id_pedido_produto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE item_pedido_produto_id_pedido_produto_seq OWNED BY item_pedido_produto.id_pedido_produto;


--
-- Name: legenda_compatibilidade; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE legenda_compatibilidade (
    id_legenda_compatibilidade integer NOT NULL,
    legenda character varying(10),
    desc_legenda character varying(150)
);


ALTER TABLE public.legenda_compatibilidade OWNER TO slcpp;

--
-- Name: legenda_compatibilidade_id_legenda_compatibilidade_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE legenda_compatibilidade_id_legenda_compatibilidade_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.legenda_compatibilidade_id_legenda_compatibilidade_seq OWNER TO slcpp;

--
-- Name: legenda_compatibilidade_id_legenda_compatibilidade_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE legenda_compatibilidade_id_legenda_compatibilidade_seq OWNED BY legenda_compatibilidade.id_legenda_compatibilidade;


--
-- Name: local_operacao; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE local_operacao (
    id_local_oper integer NOT NULL,
    desc__local_oper character varying(255),
    local_oper character varying(255)
);


ALTER TABLE public.local_operacao OWNER TO slcpp;

--
-- Name: local_operacao_id_local_oper_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE local_operacao_id_local_oper_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.local_operacao_id_local_oper_seq OWNER TO slcpp;

--
-- Name: local_operacao_id_local_oper_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE local_operacao_id_local_oper_seq OWNED BY local_operacao.id_local_oper;


--
-- Name: lote; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE lote (
    id_lote integer NOT NULL,
    fk_id_dimensoes integer,
    estado character varying(7),
    num_onu integer,
    lado lado_char,
    numero_paletes_armazenados numeric,
    quantidade_produtos numeric,
    id_armazem integer,
    sequencial numeric
);


ALTER TABLE public.lote OWNER TO slcpp;

--
-- Name: lote_id_lote_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE lote_id_lote_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lote_id_lote_seq OWNER TO slcpp;

--
-- Name: lote_id_lote_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE lote_id_lote_seq OWNED BY lote.id_lote;


--
-- Name: movimentacao; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE movimentacao (
    id_movimentacao integer NOT NULL,
    id_endarmazem integer,
    id_produto integer
);


ALTER TABLE public.movimentacao OWNER TO slcpp;

--
-- Name: movimentacao_id_movimentacao_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE movimentacao_id_movimentacao_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.movimentacao_id_movimentacao_seq OWNER TO slcpp;

--
-- Name: movimentacao_id_movimentacao_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE movimentacao_id_movimentacao_seq OWNED BY movimentacao.id_movimentacao;


--
-- Name: num_cas; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE num_cas (
    id_num_cas integer NOT NULL,
    espc_num_cas character varying(255),
    num_cas character varying(255)
);


ALTER TABLE public.num_cas OWNER TO slcpp;

--
-- Name: num_cas_id_num_cas_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE num_cas_id_num_cas_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.num_cas_id_num_cas_seq OWNER TO slcpp;

--
-- Name: num_cas_id_num_cas_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE num_cas_id_num_cas_seq OWNED BY num_cas.id_num_cas;


--
-- Name: num_onu; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE num_onu (
    id_num_onu integer NOT NULL,
    desc_prod character varying(255),
    nome_prod character varying(255),
    num_onu character varying(255)
);


ALTER TABLE public.num_onu OWNER TO slcpp;

--
-- Name: num_onu_id_num_onu_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE num_onu_id_num_onu_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.num_onu_id_num_onu_seq OWNER TO slcpp;

--
-- Name: num_onu_id_num_onu_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE num_onu_id_num_onu_seq OWNED BY num_onu.id_num_onu;


--
-- Name: pais; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE pais (
    id_pais integer NOT NULL,
    nome_pais character varying(255),
    siglapais character varying(255)
);


ALTER TABLE public.pais OWNER TO slcpp;

--
-- Name: pais_id_pais_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE pais_id_pais_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pais_id_pais_seq OWNER TO slcpp;

--
-- Name: pais_id_pais_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE pais_id_pais_seq OWNED BY pais.id_pais;


--
-- Name: pedido; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE pedido (
    id_pedido integer NOT NULL,
    situacao_pedido integer,
    data date
);


ALTER TABLE public.pedido OWNER TO slcpp;

--
-- Name: pedido_id_pedido_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE pedido_id_pedido_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pedido_id_pedido_seq OWNER TO slcpp;

--
-- Name: pedido_id_pedido_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE pedido_id_pedido_seq OWNED BY pedido.id_pedido;


--
-- Name: produto; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE produto (
    num_onu integer NOT NULL,
    desc_produto character varying(300),
    classe integer,
    qtd_por_palete numeric
);


ALTER TABLE public.produto OWNER TO slcpp;

--
-- Name: roler; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE roler (
    id_roler integer NOT NULL,
    descricao character varying(255),
    nome_roler character varying(255)
);


ALTER TABLE public.roler OWNER TO slcpp;

--
-- Name: roler_id_roler_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE roler_id_roler_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roler_id_roler_seq OWNER TO slcpp;

--
-- Name: roler_id_roler_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE roler_id_roler_seq OWNED BY roler.id_roler;


--
-- Name: status_armazem; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE status_armazem (
    id_status_armazem integer NOT NULL,
    espec_status_armazem character varying(255),
    tipo_status_armazem character varying(255)
);


ALTER TABLE public.status_armazem OWNER TO slcpp;

--
-- Name: status_armazem_id_status_armazem_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE status_armazem_id_status_armazem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.status_armazem_id_status_armazem_seq OWNER TO slcpp;

--
-- Name: status_armazem_id_status_armazem_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE status_armazem_id_status_armazem_seq OWNED BY status_armazem.id_status_armazem;


--
-- Name: tipo_comp; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE tipo_comp (
    id_tipo_comp integer NOT NULL,
    id_classe integer,
    id_legenda integer
);


ALTER TABLE public.tipo_comp OWNER TO slcpp;

--
-- Name: tipo_equipamento; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE tipo_equipamento (
    id_tipo_equipamento integer NOT NULL,
    espc_tipo_equipamento character varying(255),
    id_epe integer,
    nome_tipo_equipamento character varying(255),
    epe_id_epe integer,
    id_embalagem integer,
    id_epi integer,
    id_veiculo integer
);


ALTER TABLE public.tipo_equipamento OWNER TO slcpp;

--
-- Name: tipo_equipamento_id_tipo_equipamento_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE tipo_equipamento_id_tipo_equipamento_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipo_equipamento_id_tipo_equipamento_seq OWNER TO slcpp;

--
-- Name: tipo_equipamento_id_tipo_equipamento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE tipo_equipamento_id_tipo_equipamento_seq OWNED BY tipo_equipamento.id_tipo_equipamento;


--
-- Name: tipo_material; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE tipo_material (
    id_tipo_material integer NOT NULL,
    espec_material character varying(255),
    nome_material character varying(255)
);


ALTER TABLE public.tipo_material OWNER TO slcpp;

--
-- Name: tipo_material_id_tipo_material_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE tipo_material_id_tipo_material_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipo_material_id_tipo_material_seq OWNER TO slcpp;

--
-- Name: tipo_material_id_tipo_material_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE tipo_material_id_tipo_material_seq OWNED BY tipo_material.id_tipo_material;


--
-- Name: tipo_solicitacao; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE tipo_solicitacao (
    id_tipo_solicitacao integer NOT NULL,
    espec_tipo_solicitacao character varying(255),
    id_fornecedor integer,
    solicitante character varying(255),
    tipo_solicitacao character varying(255),
    fornecedor_id_fornecedor integer,
    id_armazem integer,
    id_funcionario integer
);


ALTER TABLE public.tipo_solicitacao OWNER TO slcpp;

--
-- Name: tipo_solicitacao_id_tipo_solicitacao_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE tipo_solicitacao_id_tipo_solicitacao_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tipo_solicitacao_id_tipo_solicitacao_seq OWNER TO slcpp;

--
-- Name: tipo_solicitacao_id_tipo_solicitacao_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE tipo_solicitacao_id_tipo_solicitacao_seq OWNED BY tipo_solicitacao.id_tipo_solicitacao;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE usuario (
    id_usuario integer NOT NULL,
    ativo boolean,
    login character varying(255),
    senha character varying(255)
);


ALTER TABLE public.usuario OWNER TO slcpp;

--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE usuario_id_usuario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_id_usuario_seq OWNER TO slcpp;

--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE usuario_id_usuario_seq OWNED BY usuario.id_usuario;


--
-- Name: usuario_roler; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE usuario_roler (
    id integer NOT NULL,
    login integer,
    roler integer
);


ALTER TABLE public.usuario_roler OWNER TO slcpp;

--
-- Name: usuario_roler_id_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE usuario_roler_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_roler_id_seq OWNER TO slcpp;

--
-- Name: usuario_roler_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE usuario_roler_id_seq OWNED BY usuario_roler.id;


--
-- Name: usuario_roler_view; Type: VIEW; Schema: public; Owner: slcpp
--

CREATE VIEW usuario_roler_view AS
 SELECT usuario.login,
    roler.nome_roler
   FROM ((usuario_roler
     JOIN usuario ON ((usuario_roler.login = usuario.id_usuario)))
     JOIN roler ON ((usuario_roler.roler = roler.id_roler)));


ALTER TABLE public.usuario_roler_view OWNER TO slcpp;

--
-- Name: veiculo; Type: TABLE; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE TABLE veiculo (
    id_veiculo integer NOT NULL,
    ano_veiculo character varying(255),
    chassi_veiculo character varying(255),
    cor_veiculo character varying(255),
    fabricante_veiculo character varying(255),
    modelo_veiculo character varying(255),
    nome_veiculo character varying(255),
    placa_veiculo character varying(255),
    id_combustivel integer
);


ALTER TABLE public.veiculo OWNER TO slcpp;

--
-- Name: veiculo_id_veiculo_seq; Type: SEQUENCE; Schema: public; Owner: slcpp
--

CREATE SEQUENCE veiculo_id_veiculo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.veiculo_id_veiculo_seq OWNER TO slcpp;

--
-- Name: veiculo_id_veiculo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: slcpp
--

ALTER SEQUENCE veiculo_id_veiculo_seq OWNED BY veiculo.id_veiculo;


SET search_path = salvadel, pg_catalog;

--
-- Name: movimentacao; Type: TABLE; Schema: salvadel; Owner: slcpp; Tablespace: 
--

CREATE TABLE movimentacao (
    id_movimentacao integer NOT NULL,
    id_endarmazem integer,
    id_produto integer
);


ALTER TABLE salvadel.movimentacao OWNER TO slcpp;

SET search_path = public, pg_catalog;

--
-- Name: id_armazem; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY armazem ALTER COLUMN id_armazem SET DEFAULT nextval('armazem_id_armazem_seq'::regclass);


--
-- Name: id_capacidade; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY capacidade ALTER COLUMN id_capacidade SET DEFAULT nextval('capacidade_id_capacidade_seq'::regclass);


--
-- Name: id_cidade; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY cidade ALTER COLUMN id_cidade SET DEFAULT nextval('cidade_id_cidade_seq'::regclass);


--
-- Name: id_combustivel; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY combustivel ALTER COLUMN id_combustivel SET DEFAULT nextval('combustivel_id_combustivel_seq'::regclass);


--
-- Name: id_contato; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY contatos ALTER COLUMN id_contato SET DEFAULT nextval('contatos_id_contato_seq'::regclass);


--
-- Name: id_detalhe_nota; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY det_nota ALTER COLUMN id_detalhe_nota SET DEFAULT nextval('det_nota_id_detalhe_nota_seq'::regclass);


--
-- Name: id_dimensoes; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY dimensoes ALTER COLUMN id_dimensoes SET DEFAULT nextval('dimensoes_id_dimensoes_seq'::regclass);


--
-- Name: id_embalagem; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY embalagem ALTER COLUMN id_embalagem SET DEFAULT nextval('embalagem_id_embalagem_seq'::regclass);


--
-- Name: id_empresa; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY empresa ALTER COLUMN id_empresa SET DEFAULT nextval('empresa_id_empresa_seq'::regclass);


--
-- Name: id_endarmazem; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY end_armazem ALTER COLUMN id_endarmazem SET DEFAULT nextval('end_armazem_id_endarmazem_seq'::regclass);


--
-- Name: id_endereco; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY endereco ALTER COLUMN id_endereco SET DEFAULT nextval('endereco_id_endereco_seq'::regclass);


--
-- Name: id_epe; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY epe ALTER COLUMN id_epe SET DEFAULT nextval('epe_id_epe_seq'::regclass);


--
-- Name: id_epi; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY epi ALTER COLUMN id_epi SET DEFAULT nextval('epi_id_epi_seq'::regclass);


--
-- Name: id_est_fisico; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY est_fisico ALTER COLUMN id_est_fisico SET DEFAULT nextval('est_fisico_id_est_fisico_seq'::regclass);


--
-- Name: id_estado; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY estado ALTER COLUMN id_estado SET DEFAULT nextval('estado_id_estado_seq'::regclass);


--
-- Name: id_fornecedor; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY fornecedor ALTER COLUMN id_fornecedor SET DEFAULT nextval('fornecedor_id_fornecedor_seq'::regclass);


--
-- Name: id_funcionario; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY funcionario ALTER COLUMN id_funcionario SET DEFAULT nextval('funcionario_id_funcionario_seq'::regclass);


--
-- Name: id_grupo_embalagem; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY grupo_embalagem ALTER COLUMN id_grupo_embalagem SET DEFAULT nextval('grupo_embalagem_id_grupo_embalagem_seq'::regclass);


--
-- Name: id_pedido_produto; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY item_pedido_produto ALTER COLUMN id_pedido_produto SET DEFAULT nextval('item_pedido_produto_id_pedido_produto_seq'::regclass);


--
-- Name: id_legenda_compatibilidade; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY legenda_compatibilidade ALTER COLUMN id_legenda_compatibilidade SET DEFAULT nextval('legenda_compatibilidade_id_legenda_compatibilidade_seq'::regclass);


--
-- Name: id_local_oper; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY local_operacao ALTER COLUMN id_local_oper SET DEFAULT nextval('local_operacao_id_local_oper_seq'::regclass);


--
-- Name: id_lote; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY lote ALTER COLUMN id_lote SET DEFAULT nextval('lote_id_lote_seq'::regclass);


--
-- Name: id_movimentacao; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY movimentacao ALTER COLUMN id_movimentacao SET DEFAULT nextval('movimentacao_id_movimentacao_seq'::regclass);


--
-- Name: id_num_cas; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY num_cas ALTER COLUMN id_num_cas SET DEFAULT nextval('num_cas_id_num_cas_seq'::regclass);


--
-- Name: id_num_onu; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY num_onu ALTER COLUMN id_num_onu SET DEFAULT nextval('num_onu_id_num_onu_seq'::regclass);


--
-- Name: id_pais; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY pais ALTER COLUMN id_pais SET DEFAULT nextval('pais_id_pais_seq'::regclass);


--
-- Name: id_pedido; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY pedido ALTER COLUMN id_pedido SET DEFAULT nextval('pedido_id_pedido_seq'::regclass);


--
-- Name: id_roler; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY roler ALTER COLUMN id_roler SET DEFAULT nextval('roler_id_roler_seq'::regclass);


--
-- Name: id_status_armazem; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY status_armazem ALTER COLUMN id_status_armazem SET DEFAULT nextval('status_armazem_id_status_armazem_seq'::regclass);


--
-- Name: id_tipo_equipamento; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY tipo_equipamento ALTER COLUMN id_tipo_equipamento SET DEFAULT nextval('tipo_equipamento_id_tipo_equipamento_seq'::regclass);


--
-- Name: id_tipo_material; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY tipo_material ALTER COLUMN id_tipo_material SET DEFAULT nextval('tipo_material_id_tipo_material_seq'::regclass);


--
-- Name: id_tipo_solicitacao; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY tipo_solicitacao ALTER COLUMN id_tipo_solicitacao SET DEFAULT nextval('tipo_solicitacao_id_tipo_solicitacao_seq'::regclass);


--
-- Name: id_usuario; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY usuario ALTER COLUMN id_usuario SET DEFAULT nextval('usuario_id_usuario_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY usuario_roler ALTER COLUMN id SET DEFAULT nextval('usuario_roler_id_seq'::regclass);


--
-- Name: id_veiculo; Type: DEFAULT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY veiculo ALTER COLUMN id_veiculo SET DEFAULT nextval('veiculo_id_veiculo_seq'::regclass);


--
-- Data for Name: armazem; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY armazem (id_armazem, capacidade_armazem, certificacao_armazem, espec_armazem, estoque_max, estoque_min, id_compatibilidade, id_legenda_compatibilidade, id_local_oper, id_status_armazem, tipo_armazem, id_capacidade, id_endarmazem, local_operacao_id_local_oper, status_armazem_id_status_armazem, fk_id_dimensoes, fk_id_empresa, tamanho_espaco_armazenagem) FROM stdin;
\.


--
-- Name: armazem_id_armazem_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('armazem_id_armazem_seq', 1, false);


--
-- Data for Name: capacidade; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY capacidade (id_capacidade, tipo_capacidade) FROM stdin;
\.


--
-- Name: capacidade_id_capacidade_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('capacidade_id_capacidade_seq', 1, false);


--
-- Data for Name: cidade; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY cidade (id_cidade, nome_cidade, id_estado) FROM stdin;
1	Abadia de Goiás	9
2	Abadia dos Dourados	13
3	Abadiânia	9
4	Abaeté	13
5	Abaetetuba	14
6	Abaiara	6
7	Abaíra	5
8	Abaré	5
9	Abatiá	16
10	Abdon Batista	24
11	Abelardo Luz	24
12	Abel Figueiredo	14
13	Abre-Campo	13
14	Abreu e Lima	17
15	Abreulândia	27
16	Acaiaca	13
17	Açailândia	10
18	Acajutiba	5
19	Acará	14
20	Acarape	6
21	Acaraú	6
22	Acari	20
23	Acauã	18
24	Aceguá	21
25	Acopiara	6
26	Acorizal	11
27	Acrelândia	1
28	Acreúna	9
29	Açu	20
30	Açucena	13
31	Adamantina	25
32	Adelândia	9
33	Adolfo	25
34	Adrianópolis	16
35	Adustina	5
36	Afogados da Ingazeira	17
37	Afonso Bezerra	20
38	Afonso Cláudio	8
39	Afonso Cunha	10
40	Afrânio	17
41	Afuá	14
42	Agrestina	17
43	Agricolândia	18
44	Agrolândia	24
45	Agronômica	24
46	Água Azul do Norte	14
47	Água Boa	13
48	Água Boa	11
49	Água Branca	2
50	Água Branca	15
51	Água Branca	18
52	Água Clara	12
53	Água Comprida	13
54	Água Doce	24
55	Água Doce do Maranhão	10
56	Água Doce do Norte	8
57	Água Fria	5
58	Água Fria de Goiás	9
59	Aguaí	25
60	Água Limpa	9
61	Aguanil	13
62	Água Nova	20
63	Água Preta	17
64	Água Santa	21
65	Águas Belas	17
66	Águas da Prata	25
67	Águas de Chapecó	24
68	Águas de Lindóia	25
69	Águas de Santa Bárbara	25
70	Águas de São Pedro	25
71	Águas Formosas	13
72	Águas Frias	24
73	Águas Lindas de Goiás	9
74	Águas Mornas	24
75	Águas Vermelhas	13
76	Agudo	21
77	Agudos	25
78	Agudos do Sul	16
79	Águia Branca	8
80	Aguiar	15
81	Aguiarnópolis	27
82	Aimorés	13
83	Aiquara	5
84	Aiuaba	6
85	Aiuruoca	13
86	Ajuricaba	21
87	Alagoa	13
88	Alagoa Grande	15
89	Alagoa Nova	15
90	Alagoinha	15
91	Alagoinha	17
92	Alagoinha do Piauí	18
93	Alagoinhas	5
94	Alambari	25
95	Albertina	13
96	Alcântara	10
97	Alcântaras	6
98	Alcantil	15
99	Alcinópolis	12
100	Alcobaça	5
101	Aldeias Altas	10
102	Alecrim	21
103	Alegre	8
104	Alegrete	21
105	Alegrete do Piauí	18
106	Alegria	21
107	Além Paraíba	13
108	Alenquer	14
109	Alexandria	20
110	Alexânia	9
111	Alfenas	13
112	Alfredo Chaves	8
113	Alfredo Marcondes	25
114	Alfredo Vasconcelos	13
115	Alfredo Wagner	24
116	Algodão de Jandaíra	15
117	Alhandra	15
118	Aliança	17
119	Aliança do Tocantins	27
120	Almadina	5
121	Almas	27
122	Almenara	13
123	Almeirim	14
124	Almino Afonso	20
125	Almirante Tamandaré	16
126	Almirante Tamandaré do Sul	21
127	Aloândia	9
128	Alpercata	13
129	Alpestre	21
130	Alpinópolis	13
131	Alta Floresta	11
132	Alta Floresta d'Oeste	22
133	Altair	25
134	Altamira	14
135	Altamira do Maranhão	10
136	Altamira do Paraná	16
137	Altaneira	6
138	Alterosa	13
139	Altinho	17
140	Altinópolis	25
141	Alto Alegre	23
142	Alto Alegre	21
143	Alto Alegre	25
144	Alto Alegre do Maranhão	10
145	Alto Alegre do Pindaré	10
146	Alto Alegre dos Parecis	22
147	Alto Araguaia	11
148	Alto Bela Vista	24
149	Alto Caparaó	13
150	Alto da Boa Vista	11
151	Alto do Rodrigues	20
152	Alto Feliz	21
153	Alto Garças	11
154	Alto Horizonte	9
155	Alto Jequitibá	13
156	Alto Longá	18
157	Altônia	16
158	Alto Paraguai	11
159	Alto Paraíso	16
160	Alto Paraíso	22
161	Alto Paraíso de Goiás	9
162	Alto Paraná	16
163	Alto Parnaíba	10
164	Alto Piquiri	16
165	Alto Rio Doce	13
166	Alto Rio Novo	8
167	Altos	18
168	Alto Santo	6
169	Alto Taquari	11
170	Alumínio	25
171	Alvarães	4
172	Alvarenga	13
173	Álvares Florence	25
174	Álvares Machado	25
175	Álvaro de Carvalho	25
176	Alvinlândia	25
177	Alvinópolis	13
178	Alvorada	21
179	Alvorada	27
180	Alvorada de Minas	13
181	Alvorada d'Oeste	22
182	Alvorada do Gurguéia	18
183	Alvorada do Norte	9
184	Alvorada do Sul	16
185	Amajari	23
186	Amambai	12
187	Amapá	3
188	Amapá do Maranhão	10
189	Amaporã	16
190	Amaraji	17
191	Amaral Ferrador	21
192	Amaralina	9
193	Amarante	18
194	Amarante do Maranhão	10
195	Amargosa	5
196	Amaturá	4
197	Amélia Rodrigues	5
198	América Dourada	5
199	Americana	25
200	Americano do Brasil	9
201	Américo Brasiliense	25
202	Américo de Campos	25
203	Ametista do Sul	21
204	Amontada	6
205	Amorinópolis	9
206	Amparo	15
207	Amparo	25
208	Amparo da Serra	13
209	Amparo de São Francisco	26
210	Ampére	16
211	Anadia	2
212	Anagé	5
213	Anahy	16
214	Anajás	14
215	Anajatuba	10
216	Analândia	25
217	Anamã	4
218	Ananás	27
219	Ananindeua	14
220	Anápolis	9
221	Anapu	14
222	Anapurus	10
223	Anastácio	12
224	Anaurilândia	12
225	Anchieta	8
226	Anchieta	24
227	Andaraí	5
228	Andirá	16
229	Andorinha	5
230	Andradas	13
231	Andradina	25
232	André da Rocha	21
233	Andrelândia	13
234	Angatuba	25
235	Angelândia	13
236	Angélica	12
237	Angelim	17
238	Angelina	24
239	Angical	5
240	Angical do Piauí	18
241	Angico	27
242	Angicos	20
243	Angra dos Reis	19
244	Anguera	5
245	Ângulo	16
246	Anhanguera	9
247	Anhembi	25
248	Anhumas	25
249	Anicuns	9
250	Anísio de Abreu	18
251	Anita Garibaldi	24
252	Anitápolis	24
253	Anori	4
254	Anta Gorda	21
255	Antas	5
256	Antonina	16
257	Antonina do Norte	6
258	Antônio Almeida	18
259	Antônio Cardoso	5
260	Antônio Carlos	13
261	Antônio Carlos	24
262	Antônio Dias	13
263	Antônio Gonçalves	5
264	Antônio João	12
265	Antônio Martins	20
266	Antônio Olinto	16
267	Antônio Prado	21
268	Antônio Prado de Minas	13
269	Aparecida	15
270	Aparecida	25
271	Aparecida de Goiânia	9
272	Aparecida d'Oeste	25
273	Aparecida do Rio Doce	9
274	Aparecida do Rio Negro	27
275	Aparecida do Taboado	12
276	Aperibé	19
277	Apiacá	8
278	Apiacás	11
279	Apiaí	25
280	Apicum-Açu	10
281	Apiúna	24
282	Apodi	20
283	Aporá	5
284	Aporé	9
285	Apuarema	5
286	Apucarana	16
287	Apuí	4
288	Apuiarés	6
289	Aquidabã	26
290	Aquidauana	12
291	Aquiraz	6
292	Arabutã	24
293	Araçagi	15
294	Araçaí	13
295	Aracaju	26
296	Araçariguama	25
297	Araçás	5
298	Aracati	6
299	Aracatu	5
300	Araçatuba	25
301	Araci	5
302	Aracitaba	13
303	Aracoiaba	6
304	Araçoiaba	17
305	Araçoiaba da Serra	25
306	Aracruz	8
307	Araçu	9
308	Araçuaí	13
309	Aragarças	9
310	Aragoiânia	9
311	Aragominas	27
312	Araguacema	27
313	Araguaçu	27
314	Araguaiana	11
315	Araguaína	27
316	Araguainha	11
317	Araguanã	10
318	Araguanã	27
319	Araguapaz	9
320	Araguari	13
321	Araguatins	27
322	Araioses	10
323	Aral Moreira	12
324	Aramari	5
325	Arambaré	21
326	Arame	10
327	Aramina	25
328	Arandu	25
329	Arantina	13
330	Arapeí	25
331	Arapiraca	2
332	Arapoema	27
333	Araponga	13
334	Arapongas	16
335	Araporã	13
336	Arapoti	16
337	Arapuá	13
338	Arapuã	16
339	Araputanga	11
340	Araquari	24
341	Arara	15
342	Araranguá	24
343	Araraquara	25
344	Araras	25
345	Ararendá	6
346	Arari	10
347	Araricá	21
348	Araripe	6
349	Araripina	17
350	Araruama	19
351	Araruna	15
352	Araruna	16
353	Arataca	5
354	Aratiba	21
355	Aratuba	6
356	Aratuípe	5
357	Arauá	26
358	Araucária	16
359	Araújos	13
360	Araxá	13
361	Arceburgo	13
362	Arco-Íris	25
363	Arcos	13
364	Arcoverde	17
365	Areado	13
366	Areal	19
367	Arealva	25
368	Areia	15
369	Areia Branca	20
370	Areia Branca	26
371	Areia de Baraúnas	15
372	Areial	15
373	Areias	25
374	Areiópolis	25
375	Arenápolis	11
376	Arenópolis	9
377	Arês	20
378	Argirita	13
379	Aricanduva	13
380	Arinos	13
381	Aripuanã	11
382	Ariquemes	22
383	Ariranha	25
384	Ariranha do Ivaí	16
385	Armação dos Búzios	19
386	Armazém	24
387	Arneiroz	6
388	Aroazes	18
389	Aroeiras	15
390	Aroeiras do Itaim	18
391	Arraial	18
392	Arraial do Cabo	19
393	Arraias	27
394	Arroio do Meio	21
395	Arroio do Padre	21
396	Arroio do Sal	21
397	Arroio dos Ratos	21
398	Arroio do Tigre	21
399	Arroio Grande	21
400	Arroio Trinta	24
401	Artur Nogueira	25
402	Aruanã	9
403	Arujá	25
404	Arvoredo	24
405	Arvorezinha	21
406	Ascurra	24
407	Aspásia	25
408	Assaí	16
409	Assaré	6
410	Assis	25
411	Assis Brasil	1
412	Assis Chateaubriand	16
413	Assunção do Piauí	18
414	Assunção	15
415	Astolfo Dutra	13
416	Astorga	16
417	Atalaia	2
418	Atalaia	16
419	Atalaia do Norte	4
420	Atalanta	24
421	Ataléia	13
422	Atibaia	25
423	Atílio Vivácqua	8
424	Augustinópolis	27
425	Augusto Corrêa	14
426	Augusto de Lima	13
427	Augusto Pestana	21
428	Áurea	21
429	Aurelino Leal	5
430	Auriflama	25
431	Aurilândia	9
432	Aurora	6
433	Aurora	24
434	Aurora do Pará	14
435	Aurora do Tocantins	27
436	Autazes	4
437	Avaí	25
438	Avanhandava	25
439	Avaré	25
440	Aveiro	14
441	Avelino Lopes	18
442	Avelinópolis	9
443	Axixá	10
444	Axixá do Tocantins	27
445	Babaçulândia	27
446	Bacabal	10
447	Bacabeira	10
448	Bacuri	10
449	Bacurituba	10
450	Bady Bassitt	25
451	Baependi	13
452	Bagé	21
453	Bagre	14
454	Baía da Traição	15
455	Baía Formosa	20
456	Baianópolis	5
457	Baião	14
458	Baixa Grande	5
459	Baixa Grande do Ribeiro	18
460	Baixio	6
461	Baixo Guandu	8
462	Balbinos	25
463	Baldim	13
464	Baliza	9
465	Balneário Arroio do Silva	24
466	Balneário Barra do Sul	24
467	Balneário Camboriú	24
468	Balneário Gaivota	24
469	Balneário Piçarras	24
470	Balneário Pinhal	21
471	Bálsamo	25
472	Balsa Nova	16
473	Balsas	10
474	Bambuí	13
475	Banabuiú	6
476	Bananal	25
477	Bananeiras	15
478	Bandeira	13
479	Bandeira do Sul	13
480	Bandeirante	24
481	Bandeirantes	12
482	Bandeirantes	16
483	Bandeirantes do Tocantins	27
484	Bannach	14
485	Banzaê	5
486	Barão	21
487	Barão de Antonina	25
488	Barão de Cocais	13
489	Barão de Cotegipe	21
490	Barão de Grajaú	10
491	Barão de Melgaço	11
492	Barão de Monte Alto	13
493	Barão do Triunfo	21
494	Baraúna	15
495	Baraúna	20
496	Barbacena	13
497	Barbalha	6
498	Barbosa	25
499	Barbosa Ferraz	16
500	Barcarena	14
501	Barcelona	20
502	Barcelos	4
503	Bariri	25
504	Barra	5
505	Barra Bonita	24
506	Barra Bonita	25
507	Barracão	16
508	Barracão	21
509	Barra da Estiva	5
510	Barra d'Alcântara	18
511	Barra de Guabiraba	17
512	Barra de Santana	15
513	Barra de Santa Rosa	15
514	Barra de Santo Antônio	2
515	Barra de São Francisco	8
516	Barra de São Miguel	2
517	Barra de São Miguel	15
518	Barra do Bugres	11
519	Barra do Chapéu	25
520	Barra do Choça	5
521	Barra do Corda	10
522	Barra do Garças	11
523	Barra do Guarita	21
524	Barra do Jacaré	16
525	Barra do Mendes	5
526	Barra do Ouro	27
527	Barra do Piraí	19
528	Barra do Quaraí	21
529	Barra do Ribeiro	21
530	Barra do Rio Azul	21
531	Barra do Rocha	5
532	Barra dos Coqueiros	26
533	Barra do Turvo	25
534	Barra Funda	21
535	Barra Longa	13
536	Barra Mansa	19
537	Barras	18
538	Barra Velha	24
539	Barreira	6
540	Barreiras	5
541	Barreiras do Piauí	18
542	Barreirinha	4
543	Barreirinhas	10
544	Barreiros	17
545	Barretos	25
546	Barrinha	25
547	Barro	6
548	Barro Alto	5
549	Barro Alto	9
550	Barrocas	5
551	Barro Duro	18
552	Barrolândia	27
553	Barro Preto	5
554	Barroquinha	6
555	Barros Cassal	21
556	Barroso	13
557	Barueri	25
558	Bastos	25
559	Bataguaçu	12
560	Batalha	2
561	Batalha	18
562	Batatais	25
563	Batayporã	12
564	Baturité	6
565	Bauru	25
566	Bayeux	15
567	Bebedouro	25
568	Beberibe	6
569	Bela Cruz	6
570	Belágua	10
571	Bela Vista	12
572	Bela Vista da Caroba	16
573	Bela Vista de Goiás	9
574	Bela Vista de Minas	13
575	Bela Vista do Maranhão	10
576	Bela Vista do Paraíso	16
577	Bela Vista do Piauí	18
578	Bela Vista do Toldo	24
579	Belém	2
580	Belém	14
581	Belém	15
582	Belém de Maria	17
583	Belém do Brejo do Cruz	15
584	Belém do Piauí	18
585	Belém do São Francisco	17
586	Belford Roxo	19
587	Belmiro Braga	13
588	Belmonte	5
589	Belmonte	24
590	Belo Campo	5
591	Belo Horizonte	13
592	Belo Jardim	17
593	Belo Monte	2
594	Belo Oriente	13
595	Belo Vale	13
596	Belterra	14
597	Beneditinos	18
598	Benedito Leite	10
599	Benedito Novo	24
600	Benevides	14
601	Benjamin Constant	4
602	Benjamin Constant do Sul	21
603	Bento de Abreu	25
604	Bento Fernandes	20
605	Bento Gonçalves	21
606	Bequimão	10
607	Berilo	13
608	Berizal	13
609	Bernardino Batista	15
610	Bernardino de Campos	25
611	Bernardo do Mearim	10
612	Bernardo Sayão	27
613	Bertioga	25
614	Bertolínia	18
615	Bertópolis	13
616	Beruri	4
617	Betânia	17
618	Betânia do Piauí	18
619	Betim	13
620	Bezerros	17
621	Bias Fortes	13
622	Bicas	13
623	Biguaçu	24
624	Bilac	25
625	Biquinhas	13
626	Birigui	25
627	Biritiba Mirim	25
628	Biritinga	5
629	Bituruna	16
630	Blumenau	24
631	Boa Esperança	8
632	Boa Esperança	13
633	Boa Esperança	16
634	Boa Esperança do Iguaçu	16
635	Boa Esperança do Sul	25
636	Boa Hora	18
637	Boa Nova	5
638	Boa Saúde	20
639	Boa Ventura	15
640	Boa Ventura de São Roque	16
641	Boa Viagem	6
642	Boa Vista	15
643	Boa Vista	23
644	Boa Vista da Aparecida	16
645	Boa Vista das Missões	21
646	Boa Vista do Buricá	21
647	Boa Vista do Cadeado	21
648	Boa Vista do Gurupi	10
649	Boa Vista do Incra	21
650	Boa Vista do Ramos	4
651	Boa Vista do Sul	21
652	Boa Vista do Tupim	5
653	Boca da Mata	2
654	Boca do Acre	4
655	Bocaina	18
656	Bocaina	25
657	Bocaina de Minas	13
658	Bocaina do Sul	24
659	Bocaiuva	13
660	Bocaiuva do Sul	16
661	Bodó	20
662	Bodocó	17
663	Bodoquena	12
664	Bofete	25
665	Boituva	25
666	Bombinhas	24
667	Bom Conselho	17
668	Bom Despacho	13
669	Bom Jardim	10
670	Bom Jardim	17
671	Bom Jardim	19
672	Bom Jardim da Serra	24
673	Bom Jardim de Goiás	9
674	Bom Jardim de Minas	13
675	Bom Jesus	15
676	Bom Jesus	18
677	Bom Jesus	20
678	Bom Jesus	21
679	Bom Jesus	24
680	Bom Jesus da Lapa	5
681	Bom Jesus da Penha	13
682	Bom Jesus da Serra	5
683	Bom Jesus das Selvas	10
684	Bom Jesus de Goiás	9
685	Bom Jesus do Amparo	13
686	Bom Jesus do Araguaia	11
687	Bom Jesus do Galho	13
688	Bom Jesus do Itabapoana	19
689	Bom Jesus do Norte	8
690	Bom Jesus do Oeste	24
691	Bom Jesus dos Perdões	25
692	Bom Jesus do Sul	16
693	Bom Jesus do Tocantins	14
694	Bom Jesus do Tocantins	27
695	Bom Lugar	10
696	Bom Princípio	21
697	Bom Princípio do Piauí	18
698	Bom Progresso	21
699	Bom Repouso	13
700	Bom Retiro	24
701	Bom Retiro do Sul	21
702	Bom Sucesso	13
703	Bom Sucesso	15
704	Bom Sucesso	16
705	Bom Sucesso de Itararé	25
706	Bom Sucesso do Sul	16
707	Bonfim	13
708	Bonfim	23
709	Bonfim do Piauí	18
710	Bonfinópolis	9
711	Bonfinópolis de Minas	13
712	Boninal	5
713	Bonito	5
714	Bonito	12
715	Bonito	14
716	Bonito	17
717	Bonito de Minas	13
718	Bonito de Santa Fé	15
719	Bonópolis	9
720	Boqueirão	15
721	Boqueirão do Leão	21
722	Boqueirão do Piauí	18
723	Boquim	26
724	Boquira	5
725	Borá	25
726	Boracéia	25
727	Borba	4
728	Borborema	15
729	Borborema	25
730	Borda da Mata	13
731	Borebi	25
732	Borrazópolis	16
733	Bossoroca	21
734	Botelhos	13
735	Botucatu	25
736	Botumirim	13
737	Botuporã	5
738	Botuverá	24
739	Bozano	21
740	Braço do Norte	24
741	Braço do Trombudo	24
742	Braga	21
743	Bragança	14
744	Bragança Paulista	25
745	Braganey	16
746	Branquinha	2
747	Brasilândia	12
748	Brasilândia de Minas	13
749	Brasilândia do Sul	16
750	Brasilândia do Tocantins	27
751	Brasileia	1
752	Brasileira	18
753	Brasília	7
754	Brasília de Minas	13
755	Brasil Novo	14
756	Brasnorte	11
757	Brasópolis	13
758	Brás Pires	13
759	Braúna	25
760	Braúnas	13
761	Brazabrantes	9
762	Brejão	17
763	Brejetuba	8
764	Brejinho	17
765	Brejinho	20
766	Brejinho de Nazaré	27
767	Brejo	10
768	Brejo Alegre	25
769	Brejo da Madre de Deus	17
770	Brejo de Areia	10
771	Brejo do Cruz	15
772	Brejo do Piauí	18
773	Brejo dos Santos	15
774	Brejões	5
775	Brejo Grande	26
776	Brejo Grande do Araguaia	14
777	Brejolândia	5
778	Brejo Santo	6
779	Breu Branco	14
780	Breves	14
781	Britânia	9
782	Brochier	21
783	Brodowski	25
784	Brotas	25
785	Brotas de Macaúbas	5
786	Brumadinho	13
787	Brumado	5
788	Brunópolis	24
789	Brusque	24
790	Bueno Brandão	13
791	Buenópolis	13
792	Buenos Aires	17
793	Buerarema	5
794	Bugre	13
795	Buíque	17
796	Bujari	1
797	Bujaru	14
798	Buri	25
799	Buritama	25
800	Buriti	10
801	Buriti Alegre	9
802	Buriti Bravo	10
803	Buriticupu	10
804	Buriti de Goiás	9
805	Buriti dos Lopes	18
806	Buriti dos Montes	18
807	Buriti do Tocantins	27
808	Buritinópolis	9
809	Buritirama	5
810	Buritirana	10
811	Buritis	13
812	Buritis	22
813	Buritizal	25
814	Buritizeiro	13
815	Butiá	21
816	Caapiranga	4
817	Caaporã	15
818	Caarapó	12
819	Caatiba	5
820	Cabaceiras	15
821	Cabaceiras do Paraguaçu	5
822	Cabeceira Grande	13
823	Cabeceiras	9
824	Cabeceiras do Piauí	18
825	Cabedelo	15
826	Cabixi	22
827	Cabo de Santo Agostinho	17
828	Cabo Frio	19
829	Cabo Verde	13
830	Cabrália Paulista	25
831	Cabreúva	25
832	Cabrobó	17
833	Caçador	24
834	Caçapava	25
835	Caçapava do Sul	21
836	Cacaulândia	22
837	Cacequi	21
838	Cáceres	11
839	Cachoeira	5
840	Cachoeira Alta	9
841	Cachoeira da Prata	13
842	Cachoeira de Goiás	9
843	Cachoeira de Minas	13
844	Cachoeira de Pajeú	13
845	Cachoeira do Arari	14
846	Cachoeira do Piriá	14
847	Cachoeira dos Índios	15
848	Cachoeira do Sul	21
849	Cachoeira Dourada	9
850	Cachoeira Dourada	13
851	Cachoeira Grande	10
852	Cachoeira Paulista	25
853	Cachoeiras de Macacu	19
854	Cachoeirinha	17
855	Cachoeirinha	21
856	Cachoeirinha	27
857	Cachoeiro de Itapemirim	8
858	Cacimba de Areia	15
859	Cacimba de Dentro	15
860	Cacimbas	15
861	Cacimbinhas	2
862	Cacique Doble	21
863	Cacoal	22
864	Caconde	25
865	Caçu	9
866	Caculé	5
867	Caém	5
868	Caetanópolis	13
869	Caetanos	5
870	Caeté	13
871	Caetés	17
872	Caetité	5
873	Cafarnaum	5
874	Cafeara	16
875	Cafelândia	16
876	Cafelândia	25
877	Cafezal do Sul	16
878	Caiabu	25
879	Caiana	13
880	Caiapônia	9
881	Caibaté	21
882	Caibi	24
883	Caiçara	15
884	Caiçara	21
885	Caiçara do Norte	20
886	Caiçara do Rio do Vento	20
887	Caicó	20
888	Caieiras	25
889	Cairu	5
890	Caiuá	25
891	Cajamar	25
892	Cajapió	10
893	Cajari	10
894	Cajati	25
895	Cajazeiras	15
896	Cajazeiras do Piauí	18
897	Cajazeirinhas	15
898	Cajobi	25
899	Cajueiro	2
900	Cajueiro da Praia	18
901	Cajuri	13
902	Cajuru	25
903	Calçado	17
904	Calçoene	3
905	Caldas	13
906	Caldas Brandão	15
907	Caldas Novas	9
908	Caldazinha	9
909	Caldeirão Grande	5
910	Caldeirão Grande do Piauí	18
911	Califórnia	16
912	Calmon	24
913	Calumbi	17
914	Camacan	5
915	Camaçari	5
916	Camacho	13
917	Camalaú	15
918	Camamu	5
919	Camanducaia	13
920	Camapuã	12
921	Camaquã	21
922	Camaragibe	17
923	Camargo	21
924	Cambará	16
925	Cambará do Sul	21
926	Cambé	16
927	Cambira	16
928	Camboriú	24
929	Cambuci	19
930	Cambuí	13
931	Cambuquira	13
932	Cametá	14
933	Camocim	6
934	Camocim de São Félix	17
935	Campanário	13
936	Campanha	13
937	Campestre	2
938	Campestre	13
939	Campestre da Serra	21
940	Campestre de Goiás	9
941	Campestre do Maranhão	10
942	Campinaçu	9
943	Campina da Lagoa	16
944	Campina das Missões	21
945	Campina do Monte Alegre	25
946	Campina do Simão	16
947	Campina Grande	15
948	Campina Grande do Sul	16
949	Campinápolis	11
950	Campinas	25
951	Campinas do Piauí	18
952	Campinas do Sul	21
953	Campina Verde	13
954	Campinorte	9
955	Campo Alegre	2
956	Campo Alegre	24
957	Campo Alegre de Goiás	9
958	Campo Alegre de Lourdes	5
959	Campo Alegre do Fidalgo	18
960	Campo Azul	13
961	Campo Belo	13
962	Campo Belo do Sul	24
963	Campo Bom	21
964	Campo Bonito	16
965	Campo do Brito	26
966	Campo do Meio	13
967	Campo do Tenente	16
968	Campo Erê	24
969	Campo Florido	13
970	Campo Formoso	5
971	Campo Grande	2
972	Campo Grande	12
973	Campo Grande	20
974	Campo Grande do Piauí	18
975	Campo Largo	16
976	Campo Largo do Piauí	18
977	Campo Limpo de Goiás	9
978	Campo Limpo Paulista	25
979	Campo Magro	16
980	Campo Maior	18
981	Campo Mourão	16
982	Campo Novo	21
983	Campo Novo de Rondônia	22
984	Campo Novo do Parecis	11
985	Campo Redondo	20
986	Campos Altos	13
987	Campos Belos	9
988	Campos Borges	21
989	Campos de Júlio	11
990	Campos do Jordão	25
991	Campos dos Goytacazes	19
992	Campos Gerais	13
993	Campos Lindos	27
994	Campos Novos	24
995	Campos Novos Paulista	25
996	Campos Sales	6
997	Campos Verdes	9
998	Campo Verde	11
999	Camutanga	17
1000	Canaã	13
1001	Canaã dos Carajás	14
1002	Canabrava do Norte	11
1003	Cananéia	25
1004	Canapi	2
1005	Canápolis	5
1006	Canápolis	13
1007	Canarana	5
1008	Canarana	11
1009	Canas	25
1010	Cana Verde	13
1011	Canavieira	18
1012	Canavieiras	5
1013	Candeal	5
1014	Candeias	5
1015	Candeias	13
1016	Candeias do Jamari	22
1017	Candelária	21
1018	Candiba	5
1019	Cândido de Abreu	16
1020	Cândido Godói	21
1021	Cândido Mendes	10
1022	Cândido Mota	25
1023	Cândido Rodrigues	25
1024	Cândido Sales	5
1025	Candiota	21
1026	Candói	16
1027	Canela	21
1028	Canelinha	24
1029	Canguaretama	20
1030	Canguçu	21
1031	Canhoba	26
1032	Canhotinho	17
1033	Canindé	6
1034	Canindé de São Francisco	26
1035	Canitar	25
1036	Canoas	21
1037	Canoinhas	24
1038	Cansanção	5
1039	Cantagalo	13
1040	Cantagalo	16
1041	Cantagalo	19
1042	Cantanhede	10
1043	Cantá	23
1044	Canto do Buriti	18
1045	Canudos	5
1046	Canudos do Vale	21
1047	Canutama	4
1048	Capanema	14
1049	Capanema	16
1050	Capão Alto	24
1051	Capão Bonito	25
1052	Capão Bonito do Sul	21
1053	Capão da Canoa	21
1054	Capão do Cipó	21
1055	Capão do Leão	21
1056	Caparaó	13
1057	Capela	2
1058	Capela	26
1059	Capela de Santana	21
1060	Capela do Alto	25
1061	Capela do Alto Alegre	5
1062	Capela Nova	13
1063	Capelinha	13
1064	Capetinga	13
1065	Capim	15
1066	Capim Branco	13
1067	Capim Grosso	5
1068	Capinópolis	13
1069	Capinzal	24
1070	Capinzal do Norte	10
1071	Capistrano	6
1072	Capitão	21
1073	Capitão Andrade	13
1074	Capitão de Campos	18
1075	Capitão Enéas	13
1076	Capitão Gervásio Oliveira	18
1077	Capitão Leônidas Marques	16
1078	Capitão Poço	14
1079	Capitólio	13
1080	Capivari	25
1081	Capivari de Baixo	24
1082	Capivari do Sul	21
1083	Capixaba	1
1084	Capoeiras	17
1085	Caputira	13
1086	Caraá	21
1087	Caracaraí	23
1088	Caracol	12
1089	Caracol	18
1090	Caraguatatuba	25
1091	Caraí	13
1092	Caraíbas	5
1093	Carambeí	16
1094	Caranaíba	13
1095	Carandaí	13
1096	Carangola	13
1097	Carapebus	19
1098	Carapicuíba	25
1099	Caratinga	13
1100	Carauari	4
1101	Caraúbas	15
1102	Caraúbas	20
1103	Caraúbas do Piauí	18
1104	Caravelas	5
1105	Carazinho	21
1106	Carbonita	13
1107	Cardeal da Silva	5
1108	Cardoso	25
1109	Cardoso Moreira	19
1110	Careaçu	13
1111	Careiro	4
1112	Careiro da Várzea	4
1113	Cariacica	8
1114	Caridade	6
1115	Caridade do Piauí	18
1116	Carinhanha	5
1117	Carira	26
1118	Cariré	6
1119	Caririaçu	6
1120	Cariri do Tocantins	27
1121	Cariús	6
1122	Carlinda	11
1123	Carlópolis	16
1124	Carlos Barbosa	21
1125	Carlos Chagas	13
1126	Carlos Gomes	21
1127	Carmésia	13
1128	Carmo	19
1129	Carmo da Cachoeira	13
1130	Carmo da Mata	13
1131	Carmo de Minas	13
1132	Carmo do Cajuru	13
1133	Carmo do Paranaíba	13
1134	Carmo do Rio Claro	13
1135	Carmo do Rio Verde	9
1136	Carmolândia	27
1137	Carmópolis	26
1138	Carmópolis de Minas	13
1139	Carnaíba	17
1140	Carnaúba dos Dantas	20
1141	Carnaubais	20
1142	Carnaubal	6
1143	Carnaubeira da Penha	17
1144	Carneirinho	13
1145	Carneiros	2
1146	Caroebe	23
1147	Carolina	10
1148	Carpina	17
1149	Carrancas	13
1150	Carrapateira	15
1151	Carrasco Bonito	27
1152	Caruaru	17
1153	Carutapera	10
1154	Carvalhópolis	13
1155	Carvalhos	13
1156	Casa Branca	25
1157	Casa Grande	13
1158	Casa Nova	5
1159	Casca	21
1160	Cascalho Rico	13
1161	Cascavel	6
1162	Cascavel	16
1163	Caseara	27
1164	Caseiros	21
1165	Casimiro de Abreu	19
1166	Casinhas	17
1167	Casserengue	15
1168	Cássia	13
1169	Cássia dos Coqueiros	25
1170	Cassilândia	12
1171	Castanhal	14
1172	Castanheira	11
1173	Castanheiras	22
1174	Castelândia	9
1175	Castelo	8
1176	Castelo do Piauí	18
1177	Castilho	25
1178	Castro	16
1179	Castro Alves	5
1180	Cataguases	13
1181	Catalão	9
1182	Catanduva	25
1183	Catanduvas	16
1184	Catanduvas	24
1185	Catarina	6
1186	Catas Altas	13
1187	Catas Altas da Noruega	13
1188	Catende	17
1189	Catiguá	25
1190	Catingueira	15
1191	Catolândia	5
1192	Catolé do Rocha	15
1193	Catu	5
1194	Catuípe	21
1195	Catuji	13
1196	Catunda	6
1197	Caturaí	9
1198	Caturama	5
1199	Caturité	15
1200	Catuti	13
1201	Caucaia	6
1202	Cavalcante	9
1203	Caxambu	13
1204	Caxambu do Sul	24
1205	Caxias	10
1206	Caxias do Sul	21
1207	Caxingó	18
1208	Ceará-Mirim	20
1209	Cedral	10
1210	Cedral	25
1211	Cedro	6
1212	Cedro	17
1213	Cedro de São João	26
1214	Cedro do Abaeté	13
1215	Celso Ramos	24
1216	Centenário	21
1217	Centenário	27
1218	Centenário do Sul	16
1219	Central	5
1220	Central de Minas	13
1221	Central do Maranhão	10
1222	Centralina	13
1223	Centro do Guilherme	10
1224	Centro Novo do Maranhão	10
1225	Cerejeiras	22
1226	Ceres	9
1227	Cerqueira César	25
1228	Cerquilho	25
1229	Cerrito	21
1230	Cerro Azul	16
1231	Cerro Branco	21
1232	Cerro Corá	20
1233	Cerro Grande	21
1234	Cerro Grande do Sul	21
1235	Cerro Largo	21
1236	Cerro Negro	24
1237	Cesário Lange	25
1238	Céu Azul	16
1239	Cezarina	9
1240	Chácara	13
1241	Chã de Alegria	17
1242	Chã Grande	17
1243	Chalé	13
1244	Chapada	21
1245	Chapada de Areia	27
1246	Chapada da Natividade	27
1247	Chapada do Norte	13
1248	Chapada dos Guimarães	11
1249	Chapada Gaúcha	13
1250	Chapadão do Céu	9
1251	Chapadão do Lageado	24
1252	Chapadão do Sul	12
1253	Chapadinha	10
1254	Chapecó	24
1255	Chã Preta	2
1256	Charqueada	25
1257	Charqueadas	21
1258	Charrua	21
1259	Chaval	6
1260	Chavantes	25
1261	Chaves	14
1262	Chiador	13
1263	Chiapetta	21
1264	Chopinzinho	16
1265	Choró	6
1266	Chorozinho	6
1267	Chorrochó	5
1268	Chuí	21
1269	Chupinguaia	22
1270	Chuvisca	21
1271	Cianorte	16
1272	Cícero Dantas	5
1273	Cidade Gaúcha	16
1274	Cidade Ocidental	9
1275	Cidelândia	10
1276	Cidreira	21
1277	Cipó	5
1278	Cipotânea	13
1279	Ciríaco	21
1280	Claraval	13
1281	Claro dos Poções	13
1282	Cláudia	11
1283	Cláudio	13
1284	Clementina	25
1285	Clevelândia	16
1286	Coaraci	5
1287	Coari	4
1288	Cocal	18
1289	Cocal de Telha	18
1290	Cocal dos Alves	18
1291	Cocal do Sul	24
1292	Cocalinho	11
1293	Cocalzinho de Goiás	9
1294	Cocos	5
1295	Codajás	4
1296	Codó	10
1297	Coelho Neto	10
1298	Coimbra	13
1299	Coité do Noia	2
1300	Coivaras	18
1301	Colares	14
1302	Colatina	8
1303	Colíder	11
1304	Colina	25
1305	Colinas	10
1306	Colinas	21
1307	Colinas do Sul	9
1308	Colinas do Tocantins	27
1309	Colméia	27
1310	Colniza	11
1311	Colômbia	25
1312	Colombo	16
1313	Colônia do Gurguéia	18
1314	Colônia do Piauí	18
1315	Colônia Leopoldina	2
1316	Colorado	16
1317	Colorado	21
1318	Colorado do Oeste	22
1319	Coluna	13
1320	Combinado	27
1321	Comendador Gomes	13
1322	Comendador Levy Gasparian	19
1323	Comercinho	13
1324	Comodoro	11
1325	Conceição	15
1326	Conceição da Aparecida	13
1327	Conceição da Barra de Minas	13
1328	Conceição da Barra	8
1329	Conceição da Feira	5
1330	Conceição das Alagoas	13
1331	Conceição das Pedras	13
1332	Conceição de Ipanema	13
1333	Conceição de Macabu	19
1334	Conceição do Almeida	5
1335	Conceição do Araguaia	14
1336	Conceição do Canindé	18
1337	Conceição do Castelo	8
1338	Conceição do Coité	5
1339	Conceição do Jacuípe	5
1340	Conceição do Lago Açu	10
1341	Conceição do Mato Dentro	13
1342	Conceição do Pará	13
1343	Conceição do Rio Verde	13
1344	Conceição dos Ouros	13
1345	Conceição do Tocantins	27
1346	Conchal	25
1347	Conchas	25
1348	Concórdia	24
1349	Concórdia do Pará	14
1350	Condado	15
1351	Condado	17
1352	Conde	5
1353	Conde	15
1354	Condeúba	5
1355	Condor	21
1356	Cônego Marinho	13
1357	Confins	13
1358	Confresa	11
1359	Congo	15
1360	Congonhal	13
1361	Congonhas	13
1362	Congonhas do Norte	13
1363	Congonhinhas	16
1364	Conquista	13
1365	Conquista d'Oeste	11
1366	Conselheiro Lafaiete	13
1367	Conselheiro Mairinck	16
1368	Conselheiro Pena	13
1369	Consolação	13
1370	Constantina	21
1371	Contagem	13
1372	Contenda	16
1373	Contendas do Sincorá	5
1374	Coqueiral	13
1375	Coqueiro Baixo	21
1376	Coqueiros do Sul	21
1377	Coqueiro Seco	2
1378	Coração de Jesus	13
1379	Coração de Maria	5
1380	Corbélia	16
1381	Cordeiro	19
1382	Cordeirópolis	25
1383	Cordeiros	5
1384	Cordilheira Alta	24
1385	Cordisburgo	13
1386	Cordislândia	13
1387	Coreaú	6
1388	Coremas	15
1389	Corguinho	12
1390	Coribe	5
1391	Corinto	13
1392	Cornélio Procópio	16
1393	Coroaci	13
1394	Coroados	25
1395	Coroatá	10
1396	Coromandel	13
1397	Coronel Barros	21
1398	Coronel Bicaco	21
1399	Coronel Domingos Soares	16
1400	Coronel Ezequiel	20
1401	Coronel Fabriciano	13
1402	Coronel Freitas	24
1403	Coronel João Pessoa	20
1404	Coronel João Sá	5
1405	Coronel José Dias	18
1406	Coronel Macedo	25
1407	Coronel Martins	24
1408	Coronel Murta	13
1409	Coronel Pacheco	13
1410	Coronel Pilar	21
1411	Coronel Sapucaia	12
1412	Coronel Vivida	16
1413	Coronel Xavier Chaves	13
1414	Córrego Danta	13
1415	Córrego do Bom Jesus	13
1416	Córrego do Ouro	9
1417	Córrego Fundo	13
1418	Córrego Novo	13
1419	Correia Pinto	24
1420	Corrente	18
1421	Correntes	17
1422	Correntina	5
1423	Cortês	17
1424	Corumbá	12
1425	Corumbá de Goiás	9
1426	Corumbaíba	9
1427	Corumbataí	25
1428	Corumbataí do Sul	16
1429	Corumbiara	22
1430	Corupá	24
1431	Coruripe	2
1432	Cosmópolis	25
1433	Cosmorama	25
1434	Costa Marques	22
1435	Costa Rica	12
1436	Cotegipe	5
1437	Cotia	25
1438	Cotiporã	21
1439	Cotriguaçu	11
1440	Couto de Magalhães	27
1441	Couto de Magalhães de Minas	13
1442	Coxilha	21
1443	Coxim	12
1444	Coxixola	15
1445	Craíbas	2
1446	Crateús	6
1447	Crato	6
1448	Cravinhos	25
1449	Cravolândia	5
1450	Criciúma	24
1451	Crisólita	13
1452	Crisópolis	5
1453	Crissiumal	21
1454	Cristais	13
1455	Cristais Paulista	25
1456	Cristal	21
1457	Cristalândia	27
1458	Cristalândia do Piauí	18
1459	Cristal do Sul	21
1460	Cristália	13
1461	Cristalina	9
1462	Cristiano Otoni	13
1463	Cristianópolis	9
1464	Cristina	13
1465	Cristinápolis	26
1466	Cristino Castro	18
1467	Cristópolis	5
1468	Crixás	9
1469	Crixás do Tocantins	27
1470	Croatá	6
1471	Cromínia	9
1472	Crucilândia	13
1473	Cruz	6
1474	Cruzália	25
1475	Cruz Alta	21
1476	Cruzaltense	21
1477	Cruz das Almas	5
1478	Cruz do Espírito Santo	15
1479	Cruzeiro	25
1480	Cruzeiro da Fortaleza	13
1481	Cruzeiro do Iguaçu	16
1482	Cruzeiro do Oeste	16
1483	Cruzeiro do Sul	1
1484	Cruzeiro do Sul	16
1485	Cruzeiro do Sul	21
1486	Cruzeta	20
1487	Cruzília	13
1488	Cruz Machado	16
1489	Cruzmaltina	16
1490	Cubatão	25
1491	Cubati	15
1492	Cuiabá	11
1493	Cuité	15
1494	Cuité de Mamanguape	15
1495	Cuitegi	15
1496	Cujubim	22
1497	Cumari	9
1498	Cumaru	17
1499	Cumaru do Norte	14
1500	Cumbe	26
1501	Cunha	25
1502	Cunha Porã	24
1503	Cunhataí	24
1504	Cuparaque	13
1505	Cupira	17
1506	Curaçá	5
1507	Curimatá	18
1508	Curionópolis	14
1509	Curitiba	16
1510	Curitibanos	24
1511	Curiúva	16
1512	Currais	18
1513	Currais Novos	20
1514	Curral de Cima	15
1515	Curral de Dentro	13
1516	Curralinho	14
1517	Curralinhos	18
1518	Curral Novo do Piauí	18
1519	Curral Velho	15
1520	Curuá	14
1521	Curuçá	14
1522	Cururupu	10
1523	Curvelândia	11
1524	Curvelo	13
1525	Custódia	17
1526	Cutias	3
1527	Damianópolis	9
1528	Damião	15
1529	Damolândia	9
1530	Darcinópolis	27
1531	Dário Meira	5
1532	Datas	13
1533	David Canabarro	21
1534	Davinópolis	9
1535	Davinópolis	10
1536	Delfim Moreira	13
1537	Delfinópolis	13
1538	Delmiro Gouveia	2
1539	Delta	13
1540	Demerval Lobão	18
1541	Denise	11
1542	Deodápolis	12
1543	Deputado Irapuan Pinheiro	6
1544	Derrubadas	21
1545	Descalvado	25
1546	Descanso	24
1547	Descoberto	13
1548	Desterro	15
1549	Desterro de Entre Rios	13
1550	Desterro do Melo	13
1551	Dezesseis de Novembro	21
1552	Diadema	25
1553	Diamante	15
1554	Diamante d'Oeste	16
1555	Diamante do Norte	16
1556	Diamante do Sul	16
1557	Diamantina	13
1558	Diamantino	11
1559	Dianópolis	27
1560	Dias d'Ávila	5
1561	Dilermando de Aguiar	21
1562	Diogo de Vasconcelos	13
1563	Dionísio	13
1564	Dionísio Cerqueira	24
1565	Diorama	9
1566	Dirce Reis	25
1567	Dirceu Arcoverde	18
1568	Divina Pastora	26
1569	Divinésia	13
1570	Divino	13
1571	Divino das Laranjeiras	13
1572	Divino de São Lourenço	8
1573	Divinolândia	25
1574	Divinolândia de Minas	13
1575	Divinópolis	13
1576	Divinópolis de Goiás	9
1577	Divinópolis do Tocantins	27
1578	Divisa Alegre	13
1579	Divisa Nova	13
1580	Divisópolis	13
1581	Dobrada	25
1582	Dois Córregos	25
1583	Dois Irmãos	21
1584	Dois Irmãos das Missões	21
1585	Dois Irmãos do Buriti	12
1586	Dois Irmãos do Tocantins	27
1587	Dois Lajeados	21
1588	Dois Riachos	2
1589	Dois Vizinhos	16
1590	Dolcinópolis	25
1591	Dom Aquino	11
1592	Dom Basílio	5
1593	Dom Bosco	13
1594	Dom Cavati	13
1595	Dom Eliseu	14
1596	Dom Expedito Lopes	18
1597	Dom Feliciano	21
1598	Domingos Martins	8
1599	Domingos Mourão	18
1600	Dom Inocêncio	18
1601	Dom Joaquim	13
1602	Dom Macedo Costa	5
1603	Dom Pedrito	21
1604	Dom Pedro	10
1605	Dom Pedro de Alcântara	21
1606	Dom Silvério	13
1607	Dom Viçoso	13
1608	Dona Emma	24
1609	Dona Eusébia	13
1610	Dona Francisca	21
1611	Dona Inês	15
1612	Dores de Campos	13
1613	Dores de Guanhães	13
1614	Dores do Indaiá	13
1615	Dores do Rio Preto	8
1616	Dores do Turvo	13
1617	Doresópolis	13
1618	Dormentes	17
1619	Douradina	12
1620	Douradina	16
1621	Dourado	25
1622	Douradoquara	13
1623	Dourados	12
1624	Doutor Camargo	16
1625	Doutor Maurício Cardoso	21
1626	Doutor Pedrinho	24
1627	Doutor Ricardo	21
1628	Doutor Severiano	20
1629	Doutor Ulysses	16
1630	Doverlândia	9
1631	Dracena	25
1632	Duartina	25
1633	Duas Barras	19
1634	Duas Estradas	15
1635	Dueré	27
1636	Dumont	25
1637	Duque Bacelar	10
1638	Duque de Caxias	19
1639	Durandé	13
1640	Echaporã	25
1641	Ecoporanga	8
1642	Edealina	9
1643	Edéia	9
1644	Eirunepé	4
1645	Eldorado	12
1646	Eldorado	25
1647	Eldorado dos Carajás	14
1648	Eldorado do Sul	21
1649	Elesbão Veloso	18
1650	Elias Fausto	25
1651	Eliseu Martins	18
1652	Elisiário	25
1653	Elísio Medrado	5
1654	Elói Mendes	13
1655	Emas	15
1656	Embaúba	25
1657	Embu	25
1658	Embu-Guaçu	25
1659	Emilianópolis	25
1660	Encantado	21
1661	Encanto	20
1662	Encruzilhada	5
1663	Encruzilhada do Sul	21
1664	Enéas Marques	16
1665	Engenheiro Beltrão	16
1666	Engenheiro Caldas	13
1667	Engenheiro Coelho	25
1668	Engenheiro Navarro	13
1669	Engenheiro Paulo de Frontin	19
1670	Engenho Velho	21
1671	Entre Folhas	13
1672	Entre Ijuís	21
1673	Entre Rios	5
1674	Entre Rios	24
1675	Entre Rios de Minas	13
1676	Entre Rios do Oeste	16
1677	Entre Rios do Sul	21
1678	Envira	4
1679	Epitaciolândia	1
1680	Equador	20
1681	Erebango	21
1682	Erechim	21
1683	Ererê	6
1684	Érico Cardoso	5
1685	Ermo	24
1686	Ernestina	21
1687	Erval Grande	21
1688	Ervália	13
1689	Erval Seco	21
1690	Erval Velho	24
1691	Escada	17
1692	Esmeralda	21
1693	Esmeraldas	13
1694	Espera Feliz	13
1695	Esperança	15
1696	Esperança do Sul	21
1697	Esperança Nova	16
1698	Esperantina	18
1699	Esperantina	27
1700	Esperantinópolis	10
1701	Espigão Alto do Iguaçu	16
1702	Espigão d'Oeste	22
1703	Espinosa	13
1704	Espírito Santo	20
1705	Espírito Santo do Dourado	13
1706	Espírito Santo do Pinhal	25
1707	Espírito Santo do Turvo	25
1708	Esplanada	5
1709	Espumoso	21
1710	Estação	21
1711	Estância	26
1712	Estância Velha	21
1713	Esteio	21
1714	Estiva	13
1715	Estiva Gerbi	25
1716	Estreito	10
1717	Estrela	21
1718	Estrela Dalva	13
1719	Estrela de Alagoas	2
1720	Estrela d'Oeste	25
1721	Estrela do Indaiá	13
1722	Estrela do Norte	9
1723	Estrela do Norte	25
1724	Estrela do Sul	13
1725	Estrela Velha	21
1726	Euclides da Cunha	5
1727	Euclides da Cunha Paulista	25
1728	Eugênio de Castro	21
1729	Eugenópolis	13
1730	Eunápolis	5
1731	Eusébio	6
1732	Ewbank da Câmara	13
1733	Extrema	13
1734	Extremoz	20
1735	Exu	17
1736	Fagundes	15
1737	Fagundes Varela	21
1738	Faina	9
1739	Fama	13
1740	Faria Lemos	13
1741	Farias Brito	6
1742	Faro	14
1743	Farol	16
1744	Farroupilha	21
1745	Fartura	25
1746	Fartura do Piauí	18
1747	Fátima	5
1748	Fátima	27
1749	Fátima do Sul	12
1750	Faxinal	16
1751	Faxinal dos Guedes	24
1752	Faxinal do Soturno	21
1753	Faxinalzinho	21
1754	Fazenda Nova	9
1755	Fazenda Rio Grande	16
1756	Fazenda Vilanova	21
1757	Feijó	1
1758	Feira da Mata	5
1759	Feira de Santana	5
1760	Feira Grande	2
1761	Feira Nova	17
1762	Feira Nova	26
1763	Feira Nova do Maranhão	10
1764	Felício dos Santos	13
1765	Felipe Guerra	20
1766	Felisburgo	13
1767	Felixlândia	13
1768	Feliz	21
1769	Feliz Deserto	2
1770	Feliz Natal	11
1771	Fênix	16
1772	Fernandes Pinheiro	16
1773	Fernandes Tourinho	13
1774	Fernando de Noronha	17
1775	Fernando Falcão	10
1776	Fernando Pedroza	20
1777	Fernandópolis	25
1778	Fernando Prestes	25
1779	Fernão	25
1780	Ferraz de Vasconcelos	25
1781	Ferreira Gomes	3
1782	Ferreiros	17
1783	Ferros	13
1784	Fervedouro	13
1785	Figueira	16
1786	Figueirão	12
1787	Figueirópolis	27
1788	Figueirópolis d'Oeste	11
1789	Filadélfia	5
1790	Filadélfia	27
1791	Firmino Alves	5
1792	Firminópolis	9
1793	Flexeiras	2
1794	Floraí	16
1795	Florânia	20
1796	Flora Rica	25
1797	Flor da Serra do Sul	16
1798	Flor do Sertão	24
1799	Floreal	25
1800	Flores	17
1801	Flores da Cunha	21
1802	Flores de Goiás	9
1803	Flores do Piauí	18
1804	Floresta	17
1805	Floresta	16
1806	Floresta Azul	5
1807	Floresta do Araguaia	14
1808	Floresta do Piauí	18
1809	Florestal	13
1810	Florestópolis	16
1811	Floriano	18
1812	Floriano Peixoto	21
1813	Florianópolis	24
1814	Flórida	16
1815	Flórida Paulista	25
1816	Florínea	25
1817	Fonte Boa	4
1818	Fontoura Xavier	21
1819	Formiga	13
1820	Formigueiro	21
1821	Formosa	9
1822	Formosa da Serra Negra	10
1823	Formosa do Oeste	16
1824	Formosa do Rio Preto	5
1825	Formosa do Sul	24
1826	Formoso	9
1827	Formoso	13
1828	Formoso do Araguaia	27
1829	Forquetinha	21
1830	Forquilha	6
1831	Forquilhinha	24
1832	Fortaleza	6
1833	Fortaleza de Minas	13
1834	Fortaleza dos Nogueiras	10
1835	Fortaleza dos Valos	21
1836	Fortaleza do Tabocão	27
1837	Fortim	6
1838	Fortuna	10
1839	Fortuna de Minas	13
1840	Foz do Iguaçu	16
1841	Foz do Jordão	16
1842	Fraiburgo	24
1843	Franca	25
1844	Francinópolis	18
1845	Francisco Alves	16
1846	Francisco Ayres	18
1847	Francisco Badaró	13
1848	Francisco Beltrão	16
1849	Francisco Dantas	20
1850	Francisco Dumont	13
1851	Francisco Macedo	18
1852	Francisco Morato	25
1853	Franciscópolis	13
1854	Francisco Sá	13
1855	Francisco Santos	18
1856	Franco da Rocha	25
1857	Frecheirinha	6
1858	Frederico Westphalen	21
1859	Frei Gaspar	13
1860	Frei Inocêncio	13
1861	Frei Lagonegro	13
1862	Frei Martinho	15
1863	Frei Miguelinho	17
1864	Frei Paulo	26
1865	Frei Rogério	24
1866	Fronteira	13
1867	Fronteira dos Vales	13
1868	Fronteiras	18
1869	Fruta de Leite	13
1870	Frutal	13
1871	Frutuoso Gomes	20
1872	Fundão	8
1873	Funilândia	13
1874	Gabriel Monteiro	25
1875	Gado Bravo	15
1876	Gália	25
1877	Galileia	13
1878	Galinhos	20
1879	Galvão	24
1880	Gameleira	17
1881	Gameleira de Goiás	9
1882	Gameleiras	13
1883	Gandu	5
1884	Garanhuns	17
1885	Gararu	26
1886	Garça	25
1887	Garibaldi	21
1888	Garopaba	24
1889	Garrafão do Norte	14
1890	Garruchos	21
1891	Garuva	24
1892	Gaspar	24
1893	Gastão Vidigal	25
1894	Gaúcha do Norte	11
1895	Gaurama	21
1896	Gavião	5
1897	Gavião Peixoto	25
1898	Geminiano	18
1899	General Câmara	21
1900	General Carneiro	11
1901	General Carneiro	16
1902	General Maynard	26
1903	General Salgado	25
1904	General Sampaio	6
1905	Gentil	21
1906	Gentio do Ouro	5
1907	Getulina	25
1908	Getúlio Vargas	21
1909	Gilbués	18
1910	Girau do Ponciano	2
1911	Giruá	21
1912	Glaucilândia	13
1913	Glicério	25
1914	Glória	5
1915	Glória de Dourados	12
1916	Glória d'Oeste	11
1917	Glória do Goitá	17
1918	Glorinha	21
1919	Godofredo Viana	10
1920	Godoy Moreira	16
1921	Goiabeira	13
1922	Goiana	17
1923	Goianá	13
1924	Goianápolis	9
1925	Goiandira	9
1926	Goianésia	9
1927	Goianésia do Pará	14
1928	Goiânia	9
1929	Goianinha	20
1930	Goianira	9
1931	Goianorte	27
1932	Goiás	9
1933	Goiatins	27
1934	Goiatuba	9
1935	Goioerê	16
1936	Goioxim	16
1937	Gonçalves	13
1938	Gonçalves Dias	10
1939	Gongogi	5
1940	Gonzaga	13
1941	Gouvêia	13
1942	Gouvelândia	9
1943	Governador Archer	10
1944	Governador Celso Ramos	24
1945	Governador Dix-Sept Rosado	20
1946	Governador Edison Lobão	10
1947	Governador Eugênio Barros	10
1948	Governador Jorge Teixeira	22
1949	Governador Lindenberg	8
1950	Governador Luiz Rocha	10
1951	Governador Mangabeira	5
1952	Governador Newton Bello	10
1953	Governador Nunes Freire	10
1954	Governador Valadares	13
1955	Graça	6
1956	Graça Aranha	10
1957	Graccho Cardoso	26
1958	Grajaú	10
1959	Gramado	21
1960	Gramado dos Loureiros	21
1961	Gramado Xavier	21
1962	Grandes Rios	16
1963	Granito	17
1964	Granja	6
1965	Granjeiro	6
1966	Grão Mogol	13
1967	Grão Pará	24
1968	Gravatá	17
1969	Gravataí	21
1970	Gravatal	24
1971	Groaíras	6
1972	Grossos	20
1973	Grupiara	13
1974	Guabiju	21
1975	Guabiruba	24
1976	Guaçuí	8
1977	Guadalupe	18
1978	Guaíba	21
1979	Guaiçara	25
1980	Guaimbê	25
1981	Guaíra	16
1982	Guaíra	25
1983	Guairaçá	16
1984	Guaiuba	6
1985	Guajará	4
1986	Guajará-Mirim	22
1987	Guajeru	5
1988	Guamaré	20
1989	Guamiranga	16
1990	Guanambi	5
1991	Guanhães	13
1992	Guapé	13
1993	Guapiaçu	25
1994	Guapiara	25
1995	Guapimirim	19
1996	Guapirama	16
1997	Guapó	9
1998	Guaporema	16
1999	Guaporé	21
2000	Guará	25
2001	Guarabira	15
2002	Guaraçaí	25
2003	Guaraci	16
2004	Guaraci	25
2005	Guaraciaba	13
2006	Guaraciaba	24
2007	Guaraciaba do Norte	6
2008	Guaraciama	13
2009	Guaraí	27
2010	Guaraíta	9
2011	Guaramiranga	6
2012	Guaramirim	24
2013	Guaranésia	13
2014	Guarani	13
2015	Guaraniaçu	16
2016	Guarani das Missões	21
2017	Guarani de Goiás	9
2018	Guarani d'Oeste	25
2019	Guarantã	25
2020	Guarantã do Norte	11
2021	Guarapari	8
2022	Guarapuava	16
2023	Guaraqueçaba	16
2024	Guarará	13
2025	Guararapes	25
2026	Guararema	25
2027	Guaratinga	5
2028	Guaratinguetá	25
2029	Guaratuba	16
2030	Guarda-Mor	13
2031	Guareí	25
2032	Guariba	25
2033	Guaribas	18
2034	Guarinos	9
2035	Guarujá	25
2036	Guarujá do Sul	24
2037	Guarulhos	25
2038	Guatambu	24
2039	Guatapará	25
2040	Guaxupé	13
2041	Guia Lopes da Laguna	12
2042	Guidoval	13
2043	Guimarães	10
2044	Guimarânia	13
2045	Guiratinga	11
2046	Guiricema	13
2047	Gurinhatã	13
2048	Gurinhém	15
2049	Gurjão	15
2050	Gurupá	14
2051	Gurupi	27
2052	Guzolândia	25
2053	Harmonia	21
2054	Heitoraí	9
2055	Heliodora	13
2056	Heliópolis	5
2057	Herculândia	25
2058	Herval	21
2059	Herval d'Oeste	24
2060	Herveiras	21
2061	Hidrolândia	6
2062	Hidrolândia	9
2063	Hidrolina	9
2064	Holambra	25
2065	Honório Serpa	16
2066	Horizonte	6
2067	Horizontina	21
2068	Hortolândia	25
2069	Hugo Napoleão	18
2070	Hulha Negra	21
2071	Humaitá	4
2072	Humaitá	21
2073	Humberto de Campos	10
2074	Iacanga	25
2075	Iaciara	9
2076	Iacri	25
2077	Iaçu	5
2078	Iapu	13
2079	Iaras	25
2080	Iati	17
2081	Ibaiti	16
2082	Ibarama	21
2083	Ibaté	25
2084	Ibaretama	6
2085	Ibateguara	2
2086	Ibatiba	8
2087	Ibema	16
2088	Ibertioga	13
2089	Ibiá	13
2090	Ibiaçá	21
2091	Ibiaí	13
2092	Ibiam	24
2093	Ibiapina	6
2094	Ibiara	15
2095	Ibiassucê	5
2096	Ibicaraí	5
2097	Ibicaré	24
2098	Ibicoara	5
2099	Ibicuí	5
2100	Ibicuitinga	6
2101	Ibimirim	17
2102	Ibipeba	5
2103	Ibipitanga	5
2104	Ibiporã	16
2105	Ibiquera	5
2106	Ibirá	25
2107	Ibiracatu	13
2108	Ibiraci	13
2109	Ibiraçu	8
2110	Ibiraiaras	21
2111	Ibirajuba	17
2112	Ibirama	24
2113	Ibirapitanga	5
2114	Ibirapuã	5
2115	Ibirapuitã	21
2116	Ibirarema	25
2117	Ibirataia	5
2118	Ibirité	13
2119	Ibirubá	21
2120	Ibitiara	5
2121	Ibitinga	25
2122	Ibitirama	8
2123	Ibititá	5
2124	Ibitiúra de Minas	13
2125	Ibituruna	13
2126	Ibiúna	25
2127	Ibotirama	5
2128	Icapuí	6
2129	Içara	24
2130	Icaraí de Minas	13
2131	Icaraíma	16
2132	Icatu	10
2133	Icém	25
2134	Ichu	5
2135	Icó	6
2136	Iconha	8
2137	Ielmo Marinho	20
2138	Iepê	25
2139	Igaci	2
2140	Igaporã	5
2141	Igaraçu do Tietê	25
2142	Igaracy	15
2143	Igarapava	25
2144	Igarapé	13
2145	Igarapé-Açu	14
2146	Igarapé do Meio	10
2147	Igarapé Grande	10
2148	Igarapé-Mirim	14
2149	Igarassu	17
2150	Igaratá	25
2151	Igaratinga	13
2152	Igrapiúna	5
2153	Igreja Nova	2
2154	Igrejinha	21
2155	Iguaba Grande	19
2156	Iguaí	5
2157	Iguape	25
2158	Iguaraci	17
2159	Iguaraçu	16
2160	Iguatama	13
2161	Iguatemi	12
2162	Iguatu	6
2163	Iguatu	16
2164	Ijaci	13
2165	Ijuí	21
2166	Ilhabela	25
2167	Ilha Comprida	25
2168	Ilha das Flores	26
2169	Ilha de Itamaracá	17
2170	Ilha Grande	18
2171	Ilha Solteira	25
2172	Ilhéus	5
2173	Ilhota	24
2174	Ilicínea	13
2175	Ilópolis	21
2176	Imaculada	15
2177	Imaruí	24
2178	Imbaú	16
2179	Imbé	21
2180	Imbé de Minas	13
2181	Imbituba	24
2182	Imbituva	16
2183	Imbuia	24
2184	Imigrante	21
2185	Imperatriz	10
2186	Inaciolândia	9
2187	Inácio Martins	16
2188	Inajá	17
2189	Inajá	16
2190	Inconfidentes	13
2191	Indaiabira	13
2192	Indaial	24
2193	Indaiatuba	25
2194	Independência	6
2195	Independência	21
2196	Indiana	25
2197	Indianópolis	13
2198	Indianópolis	16
2199	Indiaporã	25
2200	Indiara	9
2201	Indiaroba	26
2202	Indiavaí	11
2203	Ingá	15
2204	Ingaí	13
2205	Ingazeira	17
2206	Inhacorá	21
2207	Inhambupe	5
2208	Inhangapi	14
2209	Inhapi	2
2210	Inhapim	13
2211	Inhaúma	13
2212	Inhuma	18
2213	Inhumas	9
2214	Inimutaba	13
2215	Inocência	12
2216	Inúbia Paulista	25
2217	Iomerê	24
2218	Ipaba	13
2219	Ipameri	9
2220	Ipanema	13
2221	Ipanguaçu	20
2222	Ipaporanga	6
2223	Ipatinga	13
2224	Ipaussu	25
2225	Ipaumirim	6
2226	Ipê	21
2227	Ipecaetá	5
2228	Iperó	25
2229	Ipeúna	25
2230	Ipiaçu	13
2231	Ipiaú	5
2232	Ipiguá	25
2233	Ipirá	5
2234	Ipiranga	16
2235	Ipiranga de Goiás	9
2236	Ipiranga do Norte	11
2237	Ipiranga do Piauí	18
2238	Ipiranga do Sul	21
2239	Ipira	24
2240	Ipixuna	4
2241	Ipixuna do Pará	14
2242	Ipojuca	17
2243	Iporá	9
2244	Iporã	16
2245	Iporã do Oeste	24
2246	Iporanga	25
2247	Ipu	6
2248	Ipuã	25
2249	Ipuaçu	24
2250	Ipubi	17
2251	Ipueira	20
2252	Ipueiras	6
2253	Ipueiras	27
2254	Ipuiuna	13
2255	Ipumirim	24
2256	Ipupiara	5
2257	Iracema	6
2258	Iracema	23
2259	Iracema do Oeste	16
2260	Iracemápolis	25
2261	Iraceminha	24
2262	Iraí	21
2263	Iraí de Minas	13
2264	Irajuba	5
2265	Iramaia	5
2266	Iranduba	4
2267	Irani	24
2268	Irapuã	25
2269	Irapuru	25
2270	Iraquara	5
2271	Irará	5
2272	Irati	16
2273	Irati	24
2274	Irauçuba	6
2275	Irecê	5
2276	Iretama	16
2277	Irineópolis	24
2278	Irituia	14
2279	Irupi	8
2280	Isaías Coelho	18
2281	Israelândia	9
2282	Itá	24
2283	Itaara	21
2284	Itabaiana	15
2285	Itabaiana	26
2286	Itabaianinha	26
2287	Itabela	5
2288	Itaberaba	5
2289	Itaberá	25
2290	Itaberaí	9
2291	Itabi	26
2292	Itabira	13
2293	Itabirinha	13
2294	Itabirito	13
2295	Itaboraí	19
2296	Itabuna	5
2297	Itacajá	27
2298	Itacambira	13
2299	Itacarambi	13
2300	Itacaré	5
2301	Itacoatiara	4
2302	Itacuruba	17
2303	Itacurubi	21
2304	Itaeté	5
2305	Itagi	5
2306	Itagibá	5
2307	Itagimirim	5
2308	Itaguaçu da Bahia	5
2309	Itaguaçu	8
2310	Itaguaí	19
2311	Itaguajé	16
2312	Itaguara	13
2313	Itaguari	9
2314	Itaguaru	9
2315	Itaguatins	27
2316	Itaí	25
2317	Itaíba	17
2318	Itaiçaba	6
2319	Itainópolis	18
2320	Itaiópolis	24
2321	Itaipava do Grajaú	10
2322	Itaipé	13
2323	Itaipulândia	16
2324	Itaitinga	6
2325	Itaituba	14
2326	Itajá	9
2327	Itajá	20
2328	Itajaí	24
2329	Itajobi	25
2330	Itaju	25
2331	Itajubá	13
2332	Itaju do Colônia	5
2333	Itajuípe	5
2334	Italva	19
2335	Itamaraju	5
2336	Itamarandiba	13
2337	Itamarati	4
2338	Itamarati de Minas	13
2339	Itamari	5
2340	Itambacuri	13
2341	Itambaracá	16
2342	Itambé	5
2343	Itambé	17
2344	Itambé	16
2345	Itambé do Mato Dentro	13
2346	Itamogi	13
2347	Itamonte	13
2348	Itanagra	5
2349	Itanhaém	25
2350	Itanhandu	13
2351	Itanhangá	11
2352	Itanhém	5
2353	Itanhomi	13
2354	Itaobim	13
2355	Itaocara	19
2356	Itaóca	25
2357	Itapaci	9
2358	Itapajé	6
2359	Itapagipe	13
2360	Itaparica	5
2361	Itapé	5
2362	Itapebi	5
2363	Itapecerica	13
2364	Itapecerica da Serra	25
2365	Itapecuru-Mirim	10
2366	Itapejara d'Oeste	16
2367	Itapema	24
2368	Itapemirim	8
2369	Itaperuçu	16
2370	Itaperuna	19
2371	Itapetim	17
2372	Itapetinga	5
2373	Itapetininga	25
2374	Itapeva	13
2375	Itapeva	25
2376	Itapevi	25
2377	Itapicuru	5
2378	Itapipoca	6
2379	Itapira	25
2380	Itapiranga	4
2381	Itapiranga	24
2382	Itapirapuã	9
2383	Itapirapuã Paulista	25
2384	Itapiratins	27
2385	Itapissuma	17
2386	Itapitanga	5
2387	Itapiúna	6
2388	Itapoá	24
2389	Itápolis	25
2390	Itaporã	12
2391	Itaporã do Tocantins	27
2392	Itaporanga	15
2393	Itaporanga	25
2394	Itaporanga d'Ajuda	26
2395	Itapororoca	15
2396	Itapuã do Oeste	22
2397	Itapuca	21
2398	Itapuí	25
2399	Itapura	25
2400	Itapuranga	9
2401	Itaquaquecetuba	25
2402	Itaquara	5
2403	Itaqui	21
2404	Itaquiraí	12
2405	Itaquitinga	17
2406	Itarana	8
2407	Itarantim	5
2408	Itararé	25
2409	Itarema	6
2410	Itariri	25
2411	Itarumã	9
2412	Itati	21
2413	Itatiaia	19
2414	Itatiaiuçu	13
2415	Itatiba	25
2416	Itatiba do Sul	21
2417	Itatim	5
2418	Itatinga	25
2419	Itatira	6
2420	Itatuba	15
2421	Itaú	20
2422	Itaubal	3
2423	Itaúba	11
2424	Itauçu	9
2425	Itaú de Minas	13
2426	Itaueira	18
2427	Itaúna	13
2428	Itaúna do Sul	16
2429	Itaverava	13
2430	Itinga	13
2431	Itinga do Maranhão	10
2432	Itiquira	11
2433	Itirapina	25
2434	Itirapuã	25
2435	Itiruçu	5
2436	Itiúba	5
2437	Itobi	25
2438	Itororó	5
2439	Itu	25
2440	Ituaçu	5
2441	Ituberá	5
2442	Itueta	13
2443	Ituiutaba	13
2444	Itumbiara	9
2445	Itumirim	13
2446	Itupeva	25
2447	Itupiranga	14
2448	Ituporanga	24
2449	Iturama	13
2450	Itutinga	13
2451	Ituverava	25
2452	Iuiú	5
2453	Iúna	8
2454	Ivaí	16
2455	Ivaiporã	16
2456	Ivaté	16
2457	Ivatuba	16
2458	Ivinhema	12
2459	Ivolândia	9
2460	Ivorá	21
2461	Ivoti	21
2462	Jaboatão dos Guararapes	17
2463	Jaborá	24
2464	Jaborandi	5
2465	Jaborandi	25
2466	Jaboticaba	21
2467	Jaboticabal	25
2468	Jaboticatubas	13
2469	Jaboti	16
2470	Jaçanã	20
2471	Jacaraci	5
2472	Jacaraú	15
2473	Jacareacanga	14
2474	Jacaré dos Homens	2
2475	Jacareí	25
2476	Jacarezinho	16
2477	Jaci	25
2478	Jaciara	11
2479	Jacinto	13
2480	Jacinto Machado	24
2481	Jacobina	5
2482	Jacobina do Piauí	18
2483	Jacuí	13
2484	Jacuípe	2
2485	Jacuizinho	21
2486	Jacundá	14
2487	Jacupiranga	25
2488	Jacutinga	13
2489	Jacutinga	21
2490	Jaguapitã	16
2491	Jaguaquara	5
2492	Jaguaraçu	13
2493	Jaguarão	21
2494	Jaguarari	5
2495	Jaguaré	8
2496	Jaguaretama	6
2497	Jaguari	21
2498	Jaguariaíva	16
2499	Jaguaribara	6
2500	Jaguaribe	6
2501	Jaguaripe	5
2502	Jaguariúna	25
2503	Jaguaruana	6
2504	Jaguaruna	24
2505	Jaíba	13
2506	Jaicós	18
2507	Jales	25
2508	Jambeiro	25
2509	Jampruca	13
2510	Janaúba	13
2511	Jandaia	9
2512	Jandaia do Sul	16
2513	Jandaíra	5
2514	Jandaíra	20
2515	Jandira	25
2516	Janduís	20
2517	Jangada	11
2518	Janiópolis	16
2519	Januária	13
2520	Japaraíba	13
2521	Japaratinga	2
2522	Japaratuba	26
2523	Japeri	19
2524	Japi	20
2525	Japira	16
2526	Japoatã	26
2527	Japonvar	13
2528	Japorã	12
2529	Japurá	4
2530	Japurá	16
2531	Jaqueira	17
2532	Jaquirana	21
2533	Jaraguá	9
2534	Jaraguá do Sul	24
2535	Jaraguari	12
2536	Jaramataia	2
2537	Jardim	6
2538	Jardim	12
2539	Jardim Alegre	16
2540	Jardim de Angicos	20
2541	Jardim de Piranhas	20
2542	Jardim do Mulato	18
2543	Jardim do Seridó	20
2544	Jardim Olinda	16
2545	Jardinópolis	24
2546	Jardinópolis	25
2547	Jari	21
2548	Jarinu	25
2549	Jaru	22
2550	Jataí	9
2551	Jataizinho	16
2552	Jataúba	17
2553	Jateí	12
2554	Jati	6
2555	Jatobá	10
2556	Jatobá	17
2557	Jatobá do Piauí	18
2558	Jaú	25
2559	Jaú do Tocantins	27
2560	Jaupaci	9
2561	Jauru	11
2562	Jeceaba	13
2563	Jenipapo de Minas	13
2564	Jenipapo dos Vieiras	10
2565	Jequeri	13
2566	Jequiá da Praia	2
2567	Jequié	5
2568	Jequitaí	13
2569	Jequitibá	13
2570	Jequitinhonha	13
2571	Jeremoabo	5
2572	Jericó	15
2573	Jeriquara	25
2574	Jerônimo Monteiro	8
2575	Jerumenha	18
2576	Jesuânia	13
2577	Jesuítas	16
2578	Jesúpolis	9
2579	Jijoca de Jericoacoara	6
2580	Ji-Paraná	22
2581	Jiquiriçá	5
2582	Jitaúna	5
2583	Joaçaba	24
2584	Joaíma	13
2585	Joanésia	13
2586	Joanópolis	25
2587	João Alfredo	17
2588	João Câmara	20
2589	João Costa	18
2590	João Dias	20
2591	João Dourado	5
2592	João Lisboa	10
2593	João Monlevade	13
2594	João Neiva	8
2595	João Pessoa	15
2596	João Pinheiro	13
2597	João Ramalho	25
2598	Joaquim Felício	13
2599	Joaquim Gomes	2
2600	Joaquim Nabuco	17
2601	Joaquim Pires	18
2602	Joaquim Távora	16
2603	Joca Marques	18
2604	Jóia	21
2605	Joinville	24
2606	Jordânia	13
2607	Jordão	1
2608	José Boiteux	24
2609	José Bonifácio	25
2610	José da Penha	20
2611	José de Freitas	18
2612	José Gonçalves de Minas	13
2613	Joselândia	10
2614	Josenópolis	13
2615	José Raydan	13
2616	Joviânia	9
2617	Juara	11
2618	Juarez Távora	15
2619	Juarina	27
2620	Juatuba	13
2621	Juazeirinho	15
2622	Juazeiro	5
2623	Juazeiro do Norte	6
2624	Juazeiro do Piauí	18
2625	Jucás	6
2626	Jucati	17
2627	Jucuruçu	5
2628	Jucurutu	20
2629	Juína	11
2630	Juiz de Fora	13
2631	Júlio Borges	18
2632	Júlio de Castilhos	21
2633	Júlio Mesquita	25
2634	Jumirim	25
2635	Junco do Maranhão	10
2636	Junco do Seridó	15
2637	Jundiá	2
2638	Jundiá	20
2639	Jundiaí	25
2640	Jundiaí do Sul	16
2641	Junqueiro	2
2642	Junqueirópolis	25
2643	Jupi	17
2644	Jupiá	24
2645	Juquiá	25
2646	Juquitiba	25
2647	Juramento	13
2648	Juranda	16
2649	Jurema	17
2650	Jurema	18
2651	Juripiranga	15
2652	Juru	15
2653	Juruá	4
2654	Juruaia	13
2655	Juruena	11
2656	Juruti	14
2657	Juscimeira	11
2658	Jussara	5
2659	Jussara	9
2660	Jussara	16
2661	Jussari	5
2662	Jussiape	5
2663	Jutaí	4
2664	Juti	12
2665	Juvenília	13
2666	Kaloré	16
2667	Lábrea	4
2668	Lacerdópolis	24
2669	Ladainha	13
2670	Ladário	12
2671	Lafaiete Coutinho	5
2672	Lagamar	13
2673	Lagarto	26
2674	Lages	24
2675	Lagoa	15
2676	Lagoa Alegre	18
2677	Lagoa Bonita do Sul	21
2678	Lagoa da Canoa	2
2679	Lagoa da Confusão	27
2680	Lagoa d'Anta	20
2681	Lagoa da Prata	13
2682	Lagoa de Dentro	15
2683	Lagoa de Itaenga	17
2684	Lagoa de Pedras	20
2685	Lagoa de São Francisco	18
2686	Lagoa de Velhos	20
2687	Lagoa do Barro do Piauí	18
2688	Lagoa do Carro	17
2689	Lagoa do Mato	10
2690	Lagoa do Ouro	17
2691	Lagoa do Piauí	18
2692	Lagoa dos Gatos	17
2693	Lagoa do Sítio	18
2694	Lagoa dos Patos	13
2695	Lagoa dos Três Cantos	21
2696	Lagoa do Tocantins	27
2697	Lagoa Dourada	13
2698	Lagoa Formosa	13
2699	Lagoa Grande	13
2700	Lagoa Grande	17
2701	Lagoa Grande do Maranhão	10
2702	Lagoa Nova	20
2703	Lagoão	21
2704	Lagoa Real	5
2705	Lagoa Salgada	20
2706	Lagoa Santa	9
2707	Lagoa Santa	13
2708	Lagoa Seca	15
2709	Lagoa Vermelha	21
2710	Lago da Pedra	10
2711	Lago do Junco	10
2712	Lago dos Rodrigues	10
2713	Lagoinha	25
2714	Lagoinha do Piauí	18
2715	Lago Verde	10
2716	Laguna	24
2717	Laguna Carapã	12
2718	Laje	5
2719	Lajeado	21
2720	Lajeado	27
2721	Lajeado do Bugre	21
2722	Lajeado Grande	24
2723	Lajeado Novo	10
2724	Lajedão	5
2725	Lajedinho	5
2726	Lajedo	17
2727	Lajedo do Tabocal	5
2728	Laje do Muriaé	19
2729	Lajes	20
2730	Lajes Pintadas	20
2731	Lajinha	13
2732	Lamarão	5
2733	Lambari	13
2734	Lambari d'Oeste	11
2735	Lamim	13
2736	Landri Sales	18
2737	Lapa	16
2738	Lapão	5
2739	Laranja da Terra	8
2740	Laranjal	13
2741	Laranjal	16
2742	Laranjal do Jari	3
2743	Laranjal Paulista	25
2744	Laranjeiras	26
2745	Laranjeiras do Sul	16
2746	Lassance	13
2747	Lastro	15
2748	Laurentino	24
2749	Lauro de Freitas	5
2750	Lauro Müller	24
2751	Lavandeira	27
2752	Lavínia	25
2753	Lavras	13
2754	Lavras da Mangabeira	6
2755	Lavras do Sul	21
2756	Lavrinhas	25
2757	Leandro Ferreira	13
2758	Lebon Régis	24
2759	Leme	25
2760	Leme do Prado	13
2761	Lençóis	5
2762	Lençóis Paulista	25
2763	Leoberto Leal	24
2764	Leopoldina	13
2765	Leopoldo de Bulhões	9
2766	Leópolis	16
2767	Liberato Salzano	21
2768	Liberdade	13
2769	Licínio de Almeida	5
2770	Lidianópolis	16
2771	Lima Campos	10
2772	Lima Duarte	13
2773	Limeira	25
2774	Limeira do Oeste	13
2775	Limoeiro	17
2776	Limoeiro de Anadia	2
2777	Limoeiro do Ajuru	14
2778	Limoeiro do Norte	6
2779	Lindoeste	16
2780	Lindóia	25
2781	Lindóia do Sul	24
2782	Lindolfo Collor	21
2783	Linha Nova	21
2784	Linhares	8
2785	Lins	25
2786	Livramento	15
2787	Livramento de Nossa Senhora	5
2788	Lizarda	27
2789	Loanda	16
2790	Lobato	16
2791	Logradouro	15
2792	Londrina	16
2793	Lontra	13
2794	Lontras	24
2795	Lorena	25
2796	Loreto	10
2797	Lourdes	25
2798	Louveira	25
2799	Lucas do Rio Verde	11
2800	Lucélia	25
2801	Lucena	15
2802	Lucianópolis	25
2803	Luciara	11
2804	Lucrécia	20
2805	Luís Antônio	25
2806	Luisburgo	13
2807	Luís Alves	24
2808	Luís Correia	18
2809	Luís Domingues	10
2810	Luís Eduardo Magalhães	5
2811	Luís Gomes	20
2812	Luisiana	16
2813	Luisiânia	25
2814	Luislândia	13
2815	Luminárias	13
2816	Lunardelli	16
2817	Lupércio	25
2818	Lupionópolis	16
2819	Lutécia	25
2820	Luz	13
2821	Luzerna	24
2822	Luziânia	9
2823	Luzilândia	18
2824	Luzinópolis	27
2825	Macaé	19
2826	Macaíba	20
2827	Macajuba	5
2828	Maçambara	21
2829	Macambira	26
2830	Macapá	3
2831	Macaparana	17
2832	Macarani	5
2833	Macatuba	25
2834	Macau	20
2835	Macaubal	25
2836	Macaúbas	5
2837	Macedônia	25
2838	Maceió	2
2839	Machacalis	13
2840	Machadinho	21
2841	Machadinho d'Oeste	22
2842	Machado	13
2843	Machados	17
2844	Macieira	24
2845	Macuco	19
2846	Macururé	5
2847	Madalena	6
2848	Madeiro	18
2849	Madre de Deus	5
2850	Madre de Deus de Minas	13
2851	Mãe d'Água	15
2852	Mãe do Rio	14
2853	Maetinga	5
2854	Mafra	24
2855	Magalhães Barata	14
2856	Magalhães de Almeida	10
2857	Magda	25
2858	Magé	19
2859	Maiquinique	5
2860	Mairi	5
2861	Mairinque	25
2862	Mairiporã	25
2863	Mairipotaba	9
2864	Major Gercino	24
2865	Major Isidoro	2
2866	Major Sales	20
2867	Major Vieira	24
2868	Malacacheta	13
2869	Malhada	5
2870	Malhada de Pedras	5
2871	Malhada dos Bois	26
2872	Malhador	26
2873	Mallet	16
2874	Malta	15
2875	Mamanguape	15
2876	Mambaí	9
2877	Mamborê	16
2878	Mamonas	13
2879	Mampituba	21
2880	Manacapuru	4
2881	Manaíra	15
2882	Manaquiri	4
2883	Manari	17
2884	Manaus	4
2885	Mâncio Lima	1
2886	Mandaguaçu	16
2887	Mandaguari	16
2888	Mandirituba	16
2889	Manduri	25
2890	Manfrinópolis	16
2891	Manga	13
2892	Mangaratiba	19
2893	Mangueirinha	16
2894	Manhuaçu	13
2895	Manhumirim	13
2896	Manicoré	4
2897	Manoel Emídio	18
2898	Manoel Ribas	16
2899	Manoel Urbano	1
2900	Manoel Viana	21
2901	Manoel Vitorino	5
2902	Mansidão	5
2903	Mantena	13
2904	Mantenópolis	8
2905	Maquiné	21
2906	Maraã	4
2907	Marabá	14
2908	Marabá Paulista	25
2909	Maracaçumé	10
2910	Maracaí	25
2911	Maracajá	24
2912	Maracaju	12
2913	Maracanã	14
2914	Maracanaú	6
2915	Maracás	5
2916	Maragogi	2
2917	Maragogipe	5
2918	Maraial	17
2919	Marajá do Sena	10
2920	Maranguape	6
2921	Maranhãozinho	10
2922	Marapanim	14
2923	Marapoama	25
2924	Mara Rosa	9
2925	Maratá	21
2926	Marataízes	8
2927	Maraú	5
2928	Marau	21
2929	Maravilha	2
2930	Maravilha	24
2931	Maravilhas	13
2932	Marcação	15
2933	Marcelândia	11
2934	Marcelino Ramos	21
2935	Marcelino Vieira	20
2936	Marcionílio Souza	5
2937	Marco	6
2938	Marcolândia	18
2939	Marcos Parente	18
2940	Mar de Espanha	13
2941	Marechal Cândido Rondon	16
2942	Marechal Deodoro	2
2943	Marechal Floriano	8
2944	Marechal Thaumaturgo	1
2945	Marema	24
2946	Mari	15
2947	Maria da Fé	13
2948	Maria Helena	16
2949	Marialva	16
2950	Mariana	13
2951	Mariana Pimentel	21
2952	Mariano Moro	21
2953	Marianópolis do Tocantins	27
2954	Mariápolis	25
2955	Maribondo	2
2956	Maricá	19
2957	Marilac	13
2958	Marilândia	8
2959	Marilândia do Sul	16
2960	Marilena	16
2961	Marília	25
2962	Mariluz	16
2963	Maringá	16
2964	Marinópolis	25
2965	Mário Campos	13
2966	Mariópolis	16
2967	Maripá	16
2968	Maripá de Minas	13
2969	Marituba	14
2970	Marizópolis	15
2971	Marliéria	13
2972	Marmeleiro	16
2973	Marmelópolis	13
2974	Marques de Souza	21
2975	Marquinho	16
2976	Martinho Campos	13
2977	Martinópole	6
2978	Martinópolis	25
2979	Martins	20
2980	Martins Soares	13
2981	Maruim	26
2982	Marumbi	16
2983	Mar Vermelho	2
2984	Marzagão	9
2985	Mascote	5
2986	Massapê	6
2987	Massapê do Piauí	18
2988	Massaranduba	15
2989	Massaranduba	24
2990	Mata	21
2991	Mata de São João	5
2992	Mata Grande	2
2993	Matão	25
2994	Mataraca	15
2995	Mata Roma	10
2996	Mata Verde	13
2997	Mateiros	27
2998	Matelândia	16
2999	Materlândia	13
3000	Mateus Leme	13
3001	Mathias Lobato	13
3002	Matias Barbosa	13
3003	Matias Cardoso	13
3004	Matias Olímpio	18
3005	Matina	5
3006	Matinha	10
3007	Matinhas	15
3008	Matinhos	16
3009	Matipó	13
3010	Mato Castelhano	21
3011	Matões	10
3012	Matões do Norte	10
3013	Mato Grosso	15
3014	Mato Leitão	21
3015	Mato Queimado	21
3016	Mato Rico	16
3017	Matos Costa	24
3018	Mato Verde	13
3019	Matozinhos	13
3020	Matrinchã	9
3021	Matriz de Camaragibe	2
3022	Matupá	11
3023	Maturéia	15
3024	Matutina	13
3025	Mauá	25
3026	Mauá da Serra	16
3027	Maués	4
3028	Maurilândia	9
3029	Maurilândia do Tocantins	27
3030	Mauriti	6
3031	Maxaranguape	20
3032	Maximiliano de Almeida	21
3033	Mazagão	3
3034	Medeiros	13
3035	Medeiros Neto	5
3036	Medianeira	16
3037	Medicilândia	14
3038	Medina	13
3039	Meleiro	24
3040	Melgaço	14
3041	Mendes	19
3042	Mendes Pimentel	13
3043	Mendonça	25
3044	Mercedes	16
3045	Mercês	13
3046	Meridiano	25
3047	Meruoca	6
3048	Mesópolis	25
3049	Mesquita	13
3050	Mesquita	19
3051	Messias	2
3052	Messias Targino	20
3053	Miguel Alves	18
3054	Miguel Calmon	5
3055	Miguel Leão	18
3056	Miguelópolis	25
3057	Miguel Pereira	19
3058	Milagres	5
3059	Milagres	6
3060	Milagres do Maranhão	10
3061	Milhã	6
3062	Milton Brandão	18
3063	Mimoso de Goiás	9
3064	Mimoso do Sul	8
3065	Minaçu	9
3066	Minador do Negrão	2
3067	Minas do Leão	21
3068	Minas Novas	13
3069	Minduri	13
3070	Mineiros	9
3071	Mineiros do Tietê	25
3072	Ministro Andreazza	22
3073	Mirabela	13
3074	Miracatu	25
3075	Miracema	19
3076	Miracema do Tocantins	27
3077	Mirador	10
3078	Mirador	16
3079	Miradouro	13
3080	Mira Estrela	25
3081	Miraguaí	21
3082	Miraí	13
3083	Miraíma	6
3084	Miranda	12
3085	Miranda do Norte	10
3086	Mirandiba	17
3087	Mirandópolis	25
3088	Mirangaba	5
3089	Miranorte	27
3090	Mirante	5
3091	Mirante da Serra	22
3092	Mirante do Paranapanema	25
3093	Miraselva	16
3094	Mirassol	25
3095	Mirassolândia	25
3096	Mirassol d'Oeste	11
3097	Miravânia	13
3098	Mirim Doce	24
3099	Mirinzal	10
3100	Missal	16
3101	Missão Velha	6
3102	Mocajuba	14
3103	Mococa	25
3104	Modelo	24
3105	Moeda	13
3106	Moema	13
3107	Mogeiro	15
3108	Mogi das Cruzes	25
3109	Mogi Guaçu	25
3110	Mogi Mirim	25
3111	Moiporá	9
3112	Moita Bonita	26
3113	Moju	14
3114	Mombaça	6
3115	Mombuca	25
3116	Monção	10
3117	Monções	25
3118	Mondaí	24
3119	Mongaguá	25
3120	Monjolos	13
3121	Monsenhor Gil	18
3122	Monsenhor Hipólito	18
3123	Monsenhor Paulo	13
3124	Monsenhor Tabosa	6
3125	Montadas	15
3126	Montalvânia	13
3127	Montanha	8
3128	Montanhas	20
3129	Montauri	21
3130	Monte Alegre	14
3131	Monte Alegre	20
3132	Monte Alegre de Goiás	9
3133	Monte Alegre de Minas	13
3134	Monte Alegre de Sergipe	26
3135	Monte Alegre do Piauí	18
3136	Monte Alegre dos Campos	21
3137	Monte Alegre do Sul	25
3138	Monte Alto	25
3139	Monte Aprazível	25
3140	Monte Azul	13
3141	Monte Azul Paulista	25
3142	Monte Belo	13
3143	Monte Belo do Sul	21
3144	Monte Carlo	24
3145	Monte Carmelo	13
3146	Monte Castelo	24
3147	Monte Castelo	25
3148	Monte das Gameleiras	20
3149	Monte do Carmo	27
3150	Monte Formoso	13
3151	Monte Horebe	15
3152	Monteiro	15
3153	Monteiro Lobato	25
3154	Monteirópolis	2
3155	Monte Mor	25
3156	Montenegro	21
3157	Monte Negro	22
3158	Montes Altos	10
3159	Monte Santo	5
3160	Monte Santo de Minas	13
3161	Monte Santo do Tocantins	27
3162	Montes Claros	13
3163	Montes Claros de Goiás	9
3164	Monte Sião	13
3165	Montezuma	13
3166	Montividiu	9
3167	Montividiu do Norte	9
3168	Morada Nova	6
3169	Morada Nova de Minas	13
3170	Moraújo	6
3171	Moreilândia	17
3172	Moreira Sales	16
3173	Moreno	17
3174	Mormaço	21
3175	Morpará	5
3176	Morretes	16
3177	Morrinhos	6
3178	Morrinhos	9
3179	Morrinhos do Sul	21
3180	Morro Agudo	25
3181	Morro Agudo de Goiás	9
3182	Morro Cabeça no Tempo	18
3183	Morro da Fumaça	24
3184	Morro da Garça	13
3185	Morro do Chapéu	5
3186	Morro do Chapéu do Piauí	18
3187	Morro do Pilar	13
3188	Morro Grande	24
3189	Morro Redondo	21
3190	Morro Reuter	21
3191	Morros	10
3192	Mortugaba	5
3193	Morungaba	25
3194	Mossâmedes	9
3195	Mossoró	20
3196	Mostardas	21
3197	Motuca	25
3198	Mozarlândia	9
3199	Muaná	14
3200	Mucajaí	23
3201	Mucambo	6
3202	Mucugê	5
3203	Muçum	21
3204	Mucuri	5
3205	Mucurici	8
3206	Muitos Capões	21
3207	Muliterno	21
3208	Mulungu	6
3209	Mulungu	15
3210	Mulungu do Morro	5
3211	Mundo Novo	5
3212	Mundo Novo	9
3213	Mundo Novo	12
3214	Munhoz	13
3215	Munhoz de Melo	16
3216	Muniz Ferreira	5
3217	Muniz Freire	8
3218	Muquém de São Francisco	5
3219	Muqui	8
3220	Muriaé	13
3221	Muribeca	26
3222	Murici	2
3223	Murici dos Portelas	18
3224	Muricilândia	27
3225	Muritiba	5
3226	Murutinga do Sul	25
3227	Mutuípe	5
3228	Mutum	13
3229	Mutunópolis	9
3230	Muzambinho	13
3231	Nacip Raydan	13
3232	Nantes	25
3233	Nanuque	13
3234	Não-Me-Toque	21
3235	Naque	13
3236	Narandiba	25
3237	Natal	20
3238	Natalândia	13
3239	Natércia	13
3240	Natividade	19
3241	Natividade	27
3242	Natividade da Serra	25
3243	Natuba	15
3244	Navegantes	24
3245	Naviraí	12
3246	Nazaré	5
3247	Nazaré	27
3248	Nazaré da Mata	17
3249	Nazaré do Piauí	18
3250	Nazareno	13
3251	Nazaré Paulista	25
3252	Nazarezinho	15
3253	Nazária	18
3254	Nazário	9
3255	Neópolis	26
3256	Nepomuceno	13
3257	Nerópolis	9
3258	Neves Paulista	25
3259	Nhamundá	4
3260	Nhandeara	25
3261	Nicolau Vergueiro	21
3262	Nilo Peçanha	5
3263	Nilópolis	19
3264	Nina Rodrigues	10
3265	Ninheira	13
3266	Nioaque	12
3267	Nipoã	25
3268	Niquelândia	9
3269	Nísia Floresta	20
3270	Niterói	19
3271	Nobres	11
3272	Nonoai	21
3273	Nordestina	5
3274	Normandia	23
3275	Nortelândia	11
3276	Nossa Senhora Aparecida	26
3277	Nossa Senhora da Glória	26
3278	Nossa Senhora das Dores	26
3279	Nossa Senhora das Graças	16
3280	Nossa Senhora de Lourdes	26
3281	Nossa Senhora de Nazaré	18
3282	Nossa Senhora do Livramento	11
3283	Nossa Senhora do Socorro	26
3284	Nossa Senhora dos Remédios	18
3285	Nova Aliança	25
3286	Nova Aliança do Ivaí	16
3287	Nova Alvorada	21
3288	Nova Alvorada do Sul	12
3289	Nova América	9
3290	Nova América da Colina	16
3291	Nova Andradina	12
3292	Nova Araçá	21
3293	Nova Aurora	9
3294	Nova Aurora	16
3295	Nova Bandeirantes	11
3296	Nova Bassano	21
3297	Nova Belém	13
3298	Nova Boa Vista	21
3299	Nova Brasilândia	11
3300	Nova Brasilândia d'Oeste	22
3301	Nova Bréscia	21
3302	Nova Campina	25
3303	Nova Canaã	5
3304	Nova Canaã do Norte	11
3305	Nova Canaã Paulista	25
3306	Nova Candelária	21
3307	Nova Cantu	16
3308	Nova Castilho	25
3309	Nova Colinas	10
3310	Nova Crixás	9
3311	Nova Cruz	20
3312	Nova Era	13
3313	Nova Erechim	24
3314	Nova Esperança	16
3315	Nova Esperança do Piriá	14
3316	Nova Esperança do Sudoeste	16
3317	Nova Esperança do Sul	21
3318	Nova Europa	25
3319	Nova Fátima	5
3320	Nova Fátima	16
3321	Nova Floresta	15
3322	Nova Friburgo	19
3323	Nova Glória	9
3324	Nova Granada	25
3325	Nova Guarita	11
3326	Nova Guataporanga	25
3327	Nova Hartz	21
3328	Nova Ibiá	5
3329	Nova Iguaçu	19
3330	Nova Iguaçu de Goiás	9
3331	Nova Independência	25
3332	Nova Iorque	10
3333	Nova Ipixuna	14
3334	Novais	25
3335	Nova Itaberaba	24
3336	Nova Itarana	5
3337	Nova Lacerda	11
3338	Nova Laranjeiras	16
3339	Nova Lima	13
3340	Nova Londrina	16
3341	Nova Luzitânia	25
3342	Nova Mamoré	22
3343	Nova Marilândia	11
3344	Nova Maringá	11
3345	Nova Módica	13
3346	Nova Monte Verde	11
3347	Nova Mutum	11
3348	Nova Nazaré	11
3349	Nova Odessa	25
3350	Nova Olímpia	11
3351	Nova Olímpia	16
3352	Nova Olinda	6
3353	Nova Olinda	15
3354	Nova Olinda	27
3355	Nova Olinda do Maranhão	10
3356	Nova Olinda do Norte	4
3357	Nova Pádua	21
3358	Nova Palma	21
3359	Nova Palmeira	15
3360	Nova Petrópolis	21
3361	Nova Ponte	13
3362	Nova Porteirinha	13
3363	Nova Prata	21
3364	Nova Prata do Iguaçu	16
3365	Nova Ramada	21
3366	Nova Redenção	5
3367	Nova Resende	13
3368	Nova Roma	9
3369	Nova Roma do Sul	21
3370	Nova Rosalândia	27
3371	Nova Russas	6
3372	Nova Santa Bárbara	16
3373	Nova Santa Helena	11
3374	Nova Santa Rita	18
3375	Nova Santa Rita	21
3376	Nova Santa Rosa	16
3377	Nova Serrana	13
3378	Nova Soure	5
3379	Nova Tebas	16
3380	Nova Timboteua	14
3381	Nova Trento	24
3382	Nova Ubiratã	11
3383	Nova União	13
3384	Nova União	22
3385	Nova Venécia	8
3386	Nova Veneza	9
3387	Nova Veneza	24
3388	Nova Viçosa	5
3389	Nova Xavantina	11
3390	Novo Acordo	27
3391	Novo Alegre	27
3392	Novo Aripuanã	4
3393	Novo Airão	4
3394	Novo Barreiro	21
3395	Novo Brasil	9
3396	Novo Cabrais	21
3397	Novo Cruzeiro	13
3398	Novo Gama	9
3399	Novo Hamburgo	21
3400	Novo Horizonte	5
3401	Novo Horizonte	24
3402	Novo Horizonte	25
3403	Novo Horizonte do Norte	11
3404	Novo Horizonte do Oeste	22
3405	Novo Horizonte do Sul	12
3406	Novo Itacolomi	16
3407	Novo Jardim	27
3408	Novo Lino	2
3409	Novo Machado	21
3410	Novo Mundo	11
3411	Novo Oriente	6
3412	Novo Oriente de Minas	13
3413	Novo Oriente do Piauí	18
3414	Novo Planalto	9
3415	Novo Progresso	14
3416	Novo Repartimento	14
3417	Novorizonte	13
3418	Novo Santo Antônio	11
3419	Novo Santo Antônio	18
3420	Novo São Joaquim	11
3421	Novo Tiradentes	21
3422	Novo Triunfo	5
3423	Novo Xingu	21
3424	Nuporanga	25
3425	Óbidos	14
3426	Ocara	6
3427	Ocauçu	25
3428	Oeiras	18
3429	Oeiras do Pará	14
3430	Oiapoque	3
3431	Olaria	13
3432	Óleo	25
3433	Olho d'Água	15
3434	Olho d'Água das Cunhãs	10
3435	Olho d'Água das Flores	2
3436	Olho d'Água do Borges	20
3437	Olho d'Água do Casado	2
3438	Olho d'Água do Piauí	18
3439	Olho d'Água Grande	2
3440	Olhos-d'Água	13
3441	Olímpia	25
3442	Olímpio Noronha	13
3443	Olinda	17
3444	Olinda Nova do Maranhão	10
3445	Olindina	5
3446	Olivedos	15
3447	Oliveira	13
3448	Oliveira de Fátima	27
3449	Oliveira dos Brejinhos	5
3450	Oliveira Fortes	13
3451	Olivença	2
3452	Onça de Pitangui	13
3453	Onda Verde	25
3454	Oratórios	13
3455	Oriente	25
3456	Orindiúva	25
3457	Oriximiná	14
3458	Orizânia	13
3459	Orizona	9
3460	Orlândia	25
3461	Orleans	24
3462	Orobó	17
3463	Orocó	17
3464	Orós	6
3465	Ortigueira	16
3466	Osasco	25
3467	Oscar Bressane	25
3468	Osório	21
3469	Osvaldo Cruz	25
3470	Otacílio Costa	24
3471	Ourém	14
3472	Ouriçangas	5
3473	Ouricuri	17
3474	Ourilândia do Norte	14
3475	Ourinhos	25
3476	Ourizona	16
3477	Ouro	24
3478	Ouro Branco	2
3479	Ouro Branco	13
3480	Ouro Branco	20
3481	Ouroeste	25
3482	Ouro Fino	13
3483	Ourolândia	5
3484	Ouro Preto	13
3485	Ouro Preto do Oeste	22
3486	Ouro Velho	15
3487	Ouro Verde	24
3488	Ouro Verde	25
3489	Ouro Verde de Goiás	9
3490	Ouro Verde de Minas	13
3491	Ouro Verde do Oeste	16
3492	Ouvidor	9
3493	Pacaembu	25
3494	Pacajá	14
3495	Pacajus	6
3496	Pacaraima	23
3497	Pacatuba	6
3498	Pacatuba	26
3499	Paço do Lumiar	10
3500	Pacoti	6
3501	Pacujá	6
3502	Padre Bernardo	9
3503	Padre Carvalho	13
3504	Padre Marcos	18
3505	Padre Paraíso	13
3506	Paes Landim	18
3507	Paial	24
3508	Paiçandu	16
3509	Paim Filho	21
3510	Paineiras	13
3511	Painel	24
3512	Pains	13
3513	Pai Pedro	13
3514	Paiva	13
3515	Pajeú do Piauí	18
3516	Palestina	2
3517	Palestina	25
3518	Palestina de Goiás	9
3519	Palestina do Pará	14
3520	Palhano	6
3521	Palhoça	24
3522	Palma	13
3523	Palmácia	6
3524	Palmares	17
3525	Palmares do Sul	21
3526	Palmares Paulista	25
3527	Palmas	16
3528	Palmas	27
3529	Palmas de Monte Alto	5
3530	Palma Sola	24
3531	Palmeira	16
3532	Palmeira	24
3533	Palmeira das Missões	21
3534	Palmeira d'Oeste	25
3535	Palmeira do Piauí	18
3536	Palmeira dos Índios	2
3537	Palmeirais	18
3538	Palmeirândia	10
3539	Palmeirante	27
3540	Palmeiras	5
3541	Palmeiras de Goiás	9
3542	Palmeiras do Tocantins	27
3543	Palmeirina	17
3544	Palmeirópolis	27
3545	Palmelo	9
3546	Palminópolis	9
3547	Palmital	16
3548	Palmital	25
3549	Palmitinho	21
3550	Palmitos	24
3551	Palmópolis	13
3552	Palotina	16
3553	Panamá	9
3554	Panambi	21
3555	Pancas	8
3556	Panelas	17
3557	Panorama	25
3558	Pantano Grande	21
3559	Pão de Açúcar	2
3560	Papagaios	13
3561	Papanduva	24
3562	Paquetá	18
3563	Paracambi	19
3564	Paracatu	13
3565	Paracuru	6
3566	Pará de Minas	13
3567	Paragominas	14
3568	Paraguaçu	13
3569	Paraguaçu Paulista	25
3570	Paraí	21
3571	Paraíba do Sul	19
3572	Paraibano	10
3573	Paraibuna	25
3574	Paraipaba	6
3575	Paraíso	24
3576	Paraíso	25
3577	Paraíso das Águas	12
3578	Paraíso do Norte	16
3579	Paraíso do Sul	21
3580	Paraíso do Tocantins	27
3581	Paraisópolis	13
3582	Parambu	6
3583	Paramirim	5
3584	Paramoti	6
3585	Paraná	20
3586	Paranã	27
3587	Paranacity	16
3588	Paranaguá	16
3589	Paranaíba	12
3590	Paranaiguara	9
3591	Paranaíta	11
3592	Paranapanema	25
3593	Paranapoema	16
3594	Paranapuã	25
3595	Paranatama	17
3596	Paranatinga	11
3597	Paranavaí	16
3598	Paranhos	12
3599	Paraopeba	13
3600	Parapuã	25
3601	Parari	15
3602	Paratinga	5
3603	Paraty	19
3604	Paraú	20
3605	Parauapebas	14
3606	Paraúna	9
3607	Parazinho	20
3608	Pardinho	25
3609	Pareci Novo	21
3610	Parecis	22
3611	Parelhas	20
3612	Pariconha	2
3613	Parintins	4
3614	Paripiranga	5
3615	Paripueira	2
3616	Pariquera-Açu	25
3617	Parisi	25
3618	Parnaguá	18
3619	Parnaíba	18
3620	Parnamirim	17
3621	Parnamirim	20
3622	Parnarama	10
3623	Parobé	21
3624	Passabém	13
3625	Passa-e-Fica	20
3626	Passagem	15
3627	Passagem	20
3628	Passagem Franca	10
3629	Passagem Franca do Piauí	18
3630	Passa-Quatro	13
3631	Passa-Sete	21
3632	Passa Tempo	13
3633	Passa-Vinte	13
3634	Passira	17
3635	Passo de Camaragibe	2
3636	Passo de Torres	24
3637	Passo do Sobrado	21
3638	Passo Fundo	21
3639	Passos	13
3640	Passos Maia	24
3641	Pastos Bons	10
3642	Patis	13
3643	Pato Bragado	16
3644	Pato Branco	16
3645	Patos	15
3646	Patos de Minas	13
3647	Patos do Piauí	18
3648	Patrocínio	13
3649	Patrocínio do Muriaé	13
3650	Patrocínio Paulista	25
3651	Patu	20
3652	Paty do Alferes	19
3653	Pau Brasil	5
3654	Paudalho	17
3655	Pau-d'Arco	14
3656	Pau-d'Arco	27
3657	Pau-d'Arco do Piauí	18
3658	Pau dos Ferros	20
3659	Pauini	4
3660	Paula Cândido	13
3661	Paula Freitas	16
3662	Paulicéia	25
3663	Paulínia	25
3664	Paulino Neves	10
3665	Paulista	15
3666	Paulista	17
3667	Paulistana	18
3668	Paulistânia	25
3669	Paulistas	13
3670	Paulo Afonso	5
3671	Paulo Bento	21
3672	Paulo de Faria	25
3673	Paulo Frontin	16
3674	Paulo Jacinto	2
3675	Paulo Lopes	24
3676	Paulo Ramos	10
3677	Pavão	13
3678	Paverama	21
3679	Pavussu	18
3680	Peabiru	16
3681	Peçanha	13
3682	Pederneiras	25
3683	Pé de Serra	5
3684	Pedra	17
3685	Pedra Azul	13
3686	Pedra Bela	25
3687	Pedra Bonita	13
3688	Pedra Branca	6
3689	Pedra Branca	15
3690	Pedra Branca do Amapari	3
3691	Pedra do Anta	13
3692	Pedra do Indaiá	13
3693	Pedra Dourada	13
3694	Pedra Grande	20
3695	Pedra Lavrada	15
3696	Pedralva	13
3697	Pedra Mole	26
3698	Pedranópolis	25
3699	Pedrão	5
3700	Pedra Preta	11
3701	Pedra Preta	20
3702	Pedras Altas	21
3703	Pedras de Fogo	15
3704	Pedras de Maria da Cruz	13
3705	Pedras Grandes	24
3706	Pedregulho	25
3707	Pedreira	25
3708	Pedreiras	10
3709	Pedrinhas	26
3710	Pedrinhas Paulista	25
3711	Pedrinópolis	13
3712	Pedro Afonso	27
3713	Pedro Alexandre	5
3714	Pedro Avelino	20
3715	Pedro Canário	8
3716	Pedro de Toledo	25
3717	Pedro do Rosário	10
3718	Pedro Gomes	12
3719	Pedro II	18
3720	Pedro Laurentino	18
3721	Pedro Leopoldo	13
3722	Pedro Osório	21
3723	Pedro Régis	15
3724	Pedro Teixeira	13
3725	Pedro Velho	20
3726	Peixe	27
3727	Peixe-Boi	14
3728	Peixoto de Azevedo	11
3729	Pejuçara	21
3730	Pelotas	21
3731	Penaforte	6
3732	Penalva	10
3733	Penápolis	25
3734	Pendências	20
3735	Penedo	2
3736	Penha	24
3737	Pentecoste	6
3738	Pequeri	13
3739	Pequi	13
3740	Pequizeiro	27
3741	Perdigão	13
3742	Perdizes	13
3743	Perdões	13
3744	Pereira Barreto	25
3745	Pereiras	25
3746	Pereiro	6
3747	Peri Mirim	10
3748	Periquito	13
3749	Peritiba	24
3750	Peritoró	10
3751	Perobal	16
3752	Pérola	16
3753	Pérola d'Oeste	16
3754	Perolândia	9
3755	Peruíbe	25
3756	Pescador	13
3757	Pesqueira	17
3758	Petrolândia	17
3759	Petrolândia	24
3760	Petrolina	17
3761	Petrolina de Goiás	9
3762	Petrópolis	19
3763	Piaçabuçu	2
3764	Piacatu	25
3765	Piancó	15
3766	Piatã	5
3767	Piau	13
3768	Picada Café	21
3769	Piçarra	14
3770	Picos	18
3771	Picuí	15
3772	Piedade	25
3773	Piedade de Caratinga	13
3774	Piedade de Ponte Nova	13
3775	Piedade do Rio Grande	13
3776	Piedade dos Gerais	13
3777	Piên	16
3778	Pilão Arcado	5
3779	Pilar	2
3780	Pilar	15
3781	Pilar de Goiás	9
3782	Pilar do Sul	25
3783	Pilões	15
3784	Pilões	20
3785	Pilõezinhos	15
3786	Pimenta	13
3787	Pimenta Bueno	22
3788	Pimenteiras	18
3789	Pimenteiras do Oeste	22
3790	Pindaí	5
3791	Pindamonhangaba	25
3792	Pindaré-Mirim	10
3793	Pindoba	2
3794	Pindobaçu	5
3795	Pindorama	25
3796	Pindorama do Tocantins	27
3797	Pindoretama	6
3798	Pingo d'Água	13
3799	Pinhais	16
3800	Pinhal	21
3801	Pinhalão	16
3802	Pinhal da Serra	21
3803	Pinhal de São Bento	16
3804	Pinhal Grande	21
3805	Pinhalzinho	24
3806	Pinhalzinho	25
3807	Pinhão	16
3808	Pinhão	26
3809	Pinheiral	19
3810	Pinheirinho do Vale	21
3811	Pinheiro	10
3812	Pinheiro Machado	21
3813	Pinheiro Preto	24
3814	Pinheiros	8
3815	Pintadas	5
3816	Pintópolis	13
3817	Pio IX	18
3818	Pio XII	10
3819	Piquerobi	25
3820	Piquet Carneiro	6
3821	Piquete	25
3822	Piracaia	25
3823	Piracanjuba	9
3824	Piracema	13
3825	Piracicaba	25
3826	Piracuruca	18
3827	Piraí	19
3828	Piraí do Norte	5
3829	Piraí do Sul	16
3830	Piraju	25
3831	Pirajuba	13
3832	Pirajuí	25
3833	Pirambu	26
3834	Piranga	13
3835	Pirangi	25
3836	Piranguçu	13
3837	Piranguinho	13
3838	Piranhas	2
3839	Piranhas	9
3840	Pirapemas	10
3841	Pirapetinga	13
3842	Pirapó	21
3843	Pirapora	13
3844	Pirapora do Bom Jesus	25
3845	Pirapozinho	25
3846	Piraquara	16
3847	Piraquê	27
3848	Pirassununga	25
3849	Piratini	21
3850	Piratininga	25
3851	Piratuba	24
3852	Piraúba	13
3853	Pirenópolis	9
3854	Pires do Rio	9
3855	Pires Ferreira	6
3856	Piripá	5
3857	Piripiri	18
3858	Piritiba	5
3859	Pirpirituba	15
3860	Pitanga	16
3861	Pitangueiras	16
3862	Pitangueiras	25
3863	Pitangui	13
3864	Pitimbu	15
3865	Pium	27
3866	Piúma	8
3867	Piumhi	13
3868	Placas	14
3869	Plácido de Castro	1
3870	Planaltina	9
3871	Planaltina do Paraná	16
3872	Planaltino	5
3873	Planalto	5
3874	Planalto	16
3875	Planalto	21
3876	Planalto	25
3877	Planalto Alegre	24
3878	Planalto da Serra	11
3879	Planura	13
3880	Platina	25
3881	Poá	25
3882	Poção	17
3883	Poção de Pedras	10
3884	Pocinhos	15
3885	Poço Branco	20
3886	Poço Dantas	15
3887	Poço das Antas	21
3888	Poço das Trincheiras	2
3889	Poço de José de Moura	15
3890	Poções	5
3891	Poço Fundo	13
3892	Poconé	11
3893	Poço Redondo	26
3894	Poços de Caldas	13
3895	Poço Verde	26
3896	Pocrane	13
3897	Pojuca	5
3898	Poloni	25
3899	Pombal	15
3900	Pombos	17
3901	Pomerode	24
3902	Pompeia	25
3903	Pompéu	13
3904	Pongaí	25
3905	Ponta de Pedras	14
3906	Ponta Grossa	16
3907	Pontal	25
3908	Pontal do Araguaia	11
3909	Pontal do Paraná	16
3910	Pontalina	9
3911	Pontalinda	25
3912	Pontão	21
3913	Ponta Porã	12
3914	Ponte Alta	24
3915	Ponte Alta do Bom Jesus	27
3916	Ponte Alta do Norte	24
3917	Ponte Alta do Tocantins	27
3918	Ponte Branca	11
3919	Ponte Nova	13
3920	Ponte Preta	21
3921	Pontes e Lacerda	11
3922	Ponte Serrada	24
3923	Pontes Gestal	25
3924	Ponto Belo	8
3925	Ponto Chique	13
3926	Ponto dos Volantes	13
3927	Ponto Novo	5
3928	Populina	25
3929	Porangaba	25
3930	Poranga	6
3931	Porangatu	9
3932	Porciúncula	19
3933	Porecatu	16
3934	Portalegre	20
3935	Portão	21
3936	Porteirão	9
3937	Porteiras	6
3938	Porteirinha	13
3939	Portel	14
3940	Portelândia	9
3941	Porto	18
3942	Porto Acre	1
3943	Porto Alegre	21
3944	Porto Alegre do Norte	11
3945	Porto Alegre do Piauí	18
3946	Porto Alegre do Tocantins	27
3947	Porto Amazonas	16
3948	Porto Barreiro	16
3949	Porto Belo	24
3950	Porto Calvo	2
3951	Porto da Folha	26
3952	Porto de Moz	14
3953	Porto de Pedras	2
3954	Porto do Mangue	20
3955	Porto dos Gaúchos	11
3956	Porto Esperidião	11
3957	Porto Estrela	11
3958	Porto Feliz	25
3959	Porto Ferreira	25
3960	Porto Firme	13
3961	Porto Franco	10
3962	Porto Grande	3
3963	Porto Lucena	21
3964	Porto Mauá	21
3965	Porto Murtinho	12
3966	Porto Nacional	27
3967	Porto Real	19
3968	Porto Real do Colégio	2
3969	Porto Rico	16
3970	Porto Rico do Maranhão	10
3971	Porto Seguro	5
3972	Porto União	24
3973	Porto Velho	22
3974	Porto Vera Cruz	21
3975	Porto Vitória	16
3976	Porto Walter	1
3977	Porto Xavier	21
3978	Posse	9
3979	Poté	13
3980	Potengi	6
3981	Potim	25
3982	Potiraguá	5
3983	Potirendaba	25
3984	Potiretama	6
3985	Pouso Alegre	13
3986	Pouso Alto	13
3987	Pouso Novo	21
3988	Pouso Redondo	24
3989	Poxoréu	11
3990	Pracinha	25
3991	Pracuuba	3
3992	Prado	5
3993	Prado Ferreira	16
3994	Pradópolis	25
3995	Prados	13
3996	Praia Grande	24
3997	Praia Grande	25
3998	Praia Norte	27
3999	Prainha	14
4000	Pranchita	16
4001	Prata	13
4002	Prata	15
4003	Prata do Piauí	18
4004	Pratânia	25
4005	Pratápolis	13
4006	Pratinha	13
4007	Presidente Alves	25
4008	Presidente Bernardes	13
4009	Presidente Bernardes	25
4010	Presidente Castelo Branco	16
4011	Presidente Castelo Branco	24
4012	Presidente Dutra	5
4013	Presidente Dutra	10
4014	Presidente Epitácio	25
4015	Presidente Figueiredo	4
4016	Presidente Getúlio	24
4017	Presidente Jânio Quadros	5
4018	Presidente Juscelino	10
4019	Presidente Juscelino	13
4020	Presidente Kennedy	8
4021	Presidente Kennedy	27
4022	Presidente Kubitschek	13
4023	Presidente Lucena	21
4024	Presidente Médici	10
4025	Presidente Médici	22
4026	Presidente Nereu	24
4027	Presidente Olegário	13
4028	Presidente Prudente	25
4029	Presidente Sarney	10
4030	Presidente Tancredo Neves	5
4031	Presidente Vargas	10
4032	Presidente Venceslau	25
4033	Primavera	14
4034	Primavera	17
4035	Primavera de Rondônia	22
4036	Primavera do Leste	11
4037	Primeira Cruz	10
4038	Primeiro de Maio	16
4039	Princesa	24
4040	Princesa Isabel	15
4041	Professor Jamil	9
4042	Progresso	21
4043	Promissão	25
4044	Propriá	26
4045	Protásio Alves	21
4046	Prudente de Morais	13
4047	Prudentópolis	16
4048	Pugmil	27
4049	Pureza	20
4050	Putinga	21
4051	Puxinanã	15
4052	Quadra	25
4053	Quaraí	21
4054	Quartel Geral	13
4055	Quarto Centenário	16
4056	Quatá	25
4057	Quatiguá	16
4058	Quatipuru	14
4059	Quatis	19
4060	Quatro Barras	16
4061	Quatro Irmãos	21
4062	Quatro Pontes	16
4063	Quebrangulo	2
4064	Quedas do Iguaçu	16
4065	Queimada Nova	18
4066	Queimadas	5
4067	Queimadas	15
4068	Queimados	19
4069	Queiroz	25
4070	Queluzito	13
4071	Queluz	25
4072	Querência do Norte	16
4073	Querência	11
4074	Quevedos	21
4075	Quijingue	5
4076	Quilombo	24
4077	Quinta do Sol	16
4078	Quintana	25
4079	Quinze de Novembro	21
4080	Quipapá	17
4081	Quirinópolis	9
4082	Quissamã	19
4083	Quitandinha	16
4084	Quiterianópolis	6
4085	Quixaba	15
4086	Quixaba	17
4087	Quixabeira	5
4088	Quixadá	6
4089	Quixelô	6
4090	Quixeramobim	6
4091	Quixeré	6
4092	Rafael Fernandes	20
4093	Rafael Godeiro	20
4094	Rafael Jambeiro	5
4095	Rafard	25
4096	Ramilândia	16
4097	Rancharia	25
4098	Rancho Alegre d'Oeste	16
4099	Rancho Alegre	16
4100	Rancho Queimado	24
4101	Raposa	10
4102	Raposos	13
4103	Raul Soares	13
4104	Realeza	16
4105	Rebouças	16
4106	Recife	17
4107	Recreio	13
4108	Recursolândia	27
4109	Redenção	6
4110	Redenção	14
4111	Redenção da Serra	25
4112	Redenção do Gurguéia	18
4113	Redentora	21
4114	Reduto	13
4115	Regeneração	18
4116	Regente Feijó	25
4117	Reginópolis	25
4118	Registro	25
4119	Relvado	21
4120	Remanso	5
4121	Remígio	15
4122	Renascença	16
4123	Reriutaba	6
4124	Resende	19
4125	Resende Costa	13
4126	Reserva do Cabaçal	11
4127	Reserva do Iguaçu	16
4128	Reserva	16
4129	Resplendor	13
4130	Ressaquinha	13
4131	Restinga	25
4132	Restinga Seca	21
4133	Retirolândia	5
4134	Riachão	10
4135	Riachão	15
4136	Riachão das Neves	5
4137	Riachão do Bacamarte	15
4138	Riachão do Dantas	26
4139	Riachão do Jacuípe	5
4140	Riachão do Poço	15
4141	Riachinho	13
4142	Riachinho	27
4143	Riacho da Cruz	20
4144	Riacho das Almas	17
4145	Riacho de Santana	5
4146	Riacho de Santana	20
4147	Riacho de Santo Antônio	15
4148	Riacho dos Cavalos	15
4149	Riacho dos Machados	13
4150	Riacho Frio	18
4151	Riachuelo	20
4152	Riachuelo	26
4153	Rialma	9
4154	Rianápolis	9
4155	Ribamar Fiquene	10
4156	Ribas do Rio Pardo	12
4157	Ribeira	25
4158	Ribeira do Amparo	5
4159	Ribeira do Piauí	18
4160	Ribeira do Pombal	5
4161	Ribeirão	17
4162	Ribeirão Bonito	25
4163	Ribeirão Branco	25
4164	Ribeirão Cascalheira	11
4165	Ribeirão Claro	16
4166	Ribeirão Corrente	25
4167	Ribeirão das Neves	13
4168	Ribeirão do Largo	5
4169	Ribeirão do Pinhal	16
4170	Ribeirão dos Índios	25
4171	Ribeirão do Sul	25
4172	Ribeirão Grande	25
4173	Ribeirão Pires	25
4174	Ribeirão Preto	25
4175	Ribeirão Vermelho	13
4176	Ribeirãozinho	11
4177	Ribeiro Gonçalves	18
4178	Ribeirópolis	26
4179	Rifaina	25
4180	Rincão	25
4181	Rinópolis	25
4182	Rio Acima	13
4183	Rio Azul	16
4184	Rio Bananal	8
4185	Rio Bom	16
4186	Rio Bonito	19
4187	Rio Bonito do Iguaçu	16
4188	Rio Branco	1
4189	Rio Branco	11
4190	Rio Branco do Ivaí	16
4191	Rio Branco do Sul	16
4192	Rio Brilhante	12
4193	Rio Casca	13
4194	Rio Claro	19
4195	Rio Claro	25
4196	Rio Crespo	22
4197	Rio da Conceição	27
4198	Rio das Antas	24
4199	Rio das Flores	19
4200	Rio das Ostras	19
4201	Rio das Pedras	25
4202	Rio de Contas	5
4203	Rio de Janeiro	19
4204	Rio do Antônio	5
4205	Rio do Campo	24
4206	Rio Doce	13
4207	Rio do Fogo	20
4208	Rio do Oeste	24
4209	Rio do Pires	5
4210	Rio do Prado	13
4211	Rio dos Bois	27
4212	Rio dos Cedros	24
4213	Rio dos Índios	21
4214	Rio do Sul	24
4215	Rio Espera	13
4216	Rio Formoso	17
4217	Rio Fortuna	24
4218	Rio Grande	21
4219	Rio Grande da Serra	25
4220	Rio Grande do Piauí	18
4221	Riolândia	25
4222	Rio Largo	2
4223	Rio Manso	13
4224	Rio Maria	14
4225	Rio Negrinho	24
4226	Rio Negro	12
4227	Rio Negro	16
4228	Rio Novo	13
4229	Rio Novo do Sul	8
4230	Rio Paranaíba	13
4231	Rio Pardo	21
4232	Rio Pardo de Minas	13
4233	Rio Piracicaba	13
4234	Rio Pomba	13
4235	Rio Preto	13
4236	Rio Preto da Eva	4
4237	Rio Quente	9
4238	Rio Real	5
4239	Rio Rufino	24
4240	Rio Sono	27
4241	Rio Tinto	15
4242	Rio Verde	9
4243	Rio Verde de Mato Grosso	12
4244	Rio Vermelho	13
4245	Riozinho	21
4246	Riqueza	24
4247	Ritápolis	13
4248	Riversul	25
4249	Roca Sales	21
4250	Rochedo	12
4251	Rochedo de Minas	13
4252	Rodeio	24
4253	Rodeio Bonito	21
4254	Rodeiro	13
4255	Rodelas	5
4256	Rodolfo Fernandes	20
4257	Rodrigues Alves	1
4258	Rolador	21
4259	Rolândia	16
4260	Rolante	21
4261	Rolim de Moura	22
4262	Romaria	13
4263	Romelândia	24
4264	Roncador	16
4265	Ronda Alta	21
4266	Rondinha	21
4267	Rondolândia	11
4268	Rondon	16
4269	Rondon do Pará	14
4270	Rondonópolis	11
4271	Roque Gonzales	21
4272	Rorainópolis	23
4273	Rosana	25
4274	Rosário	10
4275	Rosário da Limeira	13
4276	Rosário do Catete	26
4277	Rosário do Ivaí	16
4278	Rosário do Sul	21
4279	Rosário Oeste	11
4280	Roseira	25
4281	Roteiro	2
4282	Rubelita	13
4283	Rubiácea	25
4284	Rubiataba	9
4285	Rubim	13
4286	Rubinéia	25
4287	Rurópolis	14
4288	Russas	6
4289	Ruy Barbosa	5
4290	Ruy Barbosa	20
4291	Sabará	13
4292	Sabáudia	16
4293	Sabinópolis	13
4294	Sabino	25
4295	Saboeiro	6
4296	Sacramento	13
4297	Sagrada Família	21
4298	Sagres	25
4299	Sairé	17
4300	Saldanha Marinho	21
4301	Sales	25
4302	Sales Oliveira	25
4303	Salesópolis	25
4304	Salete	24
4305	Salgadinho	15
4306	Salgadinho	17
4307	Salgado	26
4308	Salgado de São Félix	15
4309	Salgado Filho	16
4310	Salgueiro	17
4311	Salinas	13
4312	Salinas da Margarida	5
4313	Salinópolis	14
4314	Salitre	6
4315	Salmourão	25
4316	Saloá	17
4317	Saltinho	24
4318	Saltinho	25
4319	Salto	25
4320	Salto da Divisa	13
4321	Salto de Pirapora	25
4322	Salto do Céu	11
4323	Salto do Itararé	16
4324	Salto do Jacuí	21
4325	Salto do Lontra	16
4326	Salto Grande	25
4327	Salto Veloso	24
4328	Salvador	5
4329	Salvador das Missões	21
4330	Salvador do Sul	21
4331	Salvaterra	14
4332	Sambaíba	10
4333	Sampaio	27
4334	Sananduva	21
4335	Sanclerlândia	9
4336	Sandolândia	27
4337	Sandovalina	25
4338	Sangão	24
4339	Sanharó	17
4340	Santa Adélia	25
4341	Santa Albertina	25
4342	Santa Amélia	16
4343	Santa Bárbara	5
4344	Santa Bárbara	13
4345	Santa Bárbara de Goiás	9
4346	Santa Bárbara d'Oeste	25
4347	Santa Bárbara do Leste	13
4348	Santa Bárbara do Monte Verde	13
4349	Santa Bárbara do Pará	14
4350	Santa Bárbara do Sul	21
4351	Santa Bárbara do Tugúrio	13
4352	Santa Branca	25
4353	Santa Brígida	5
4354	Santa Carmem	11
4355	Santa Cecília	15
4356	Santa Cecília	24
4357	Santa Cecília do Pavão	16
4358	Santa Cecília do Sul	21
4359	Santa Clara d'Oeste	25
4360	Santa Clara do Sul	21
4361	Santa Cruz	15
4362	Santa Cruz	17
4363	Santa Cruz	20
4364	Santa Cruz Cabrália	5
4365	Santa Cruz da Baixa Verde	17
4366	Santa Cruz da Conceição	25
4367	Santa Cruz da Esperança	25
4368	Santa Cruz da Vitória	5
4369	Santa Cruz das Palmeiras	25
4370	Santa Cruz de Goiás	9
4371	Santa Cruz de Minas	13
4372	Santa Cruz de Monte Castelo	16
4373	Santa Cruz de Salinas	13
4374	Santa Cruz do Arari	14
4375	Santa Cruz do Capibaribe	17
4376	Santa Cruz do Escalvado	13
4377	Santa Cruz do Piauí	18
4378	Santa Cruz do Rio Pardo	25
4379	Santa Cruz do Sul	21
4380	Santa Cruz do Xingu	11
4381	Santa Cruz dos Milagres	18
4382	Santa Efigênia de Minas	13
4383	Santa Ernestina	25
4384	Santa Fé	16
4385	Santa Fé de Goiás	9
4386	Santa Fé de Minas	13
4387	Santa Fé do Araguaia	27
4388	Santa Fé do Sul	25
4389	Santa Filomena	17
4390	Santa Filomena	18
4391	Santa Filomena do Maranhão	10
4392	Santa Gertrudes	25
4393	Santa Helena	10
4394	Santa Helena	15
4395	Santa Helena	16
4396	Santa Helena	24
4397	Santa Helena de Goiás	9
4398	Santa Helena de Minas	13
4399	Santa Inês	5
4400	Santa Inês	10
4401	Santa Inês	15
4402	Santa Inês	16
4403	Santa Isabel	9
4404	Santa Isabel	25
4405	Santa Isabel do Ivaí	16
4406	Santa Isabel do Pará	14
4407	Santa Isabel do Rio Negro	4
4408	Santa Izabel do Oeste	16
4409	Santa Juliana	13
4410	Santa Leopoldina	8
4411	Santa Lúcia	16
4412	Santa Lúcia	25
4413	Santaluz	5
4414	Santa Luz	18
4415	Santa Luzia	5
4416	Santa Luzia	10
4417	Santa Luzia	13
4418	Santa Luzia	15
4419	Santa Luzia d'Oeste	22
4420	Santa Luzia do Itanhy	26
4421	Santa Luzia do Norte	2
4422	Santa Luzia do Pará	14
4423	Santa Luzia do Paruá	10
4424	Santa Margarida	13
4425	Santa Margarida do Sul	21
4426	Santa Maria	20
4427	Santa Maria	21
4428	Santa Maria da Boa Vista	17
4429	Santa Maria das Barreiras	14
4430	Santa Maria da Serra	25
4431	Santa Maria da Vitória	5
4432	Santa Maria de Itabira	13
4433	Santa Maria do Cambucá	17
4434	Santa Maria do Herval	21
4435	Santa Maria de Jetibá	8
4436	Santa Maria do Oeste	16
4437	Santa Maria do Pará	14
4438	Santa Maria do Salto	13
4439	Santa Maria do Suaçuí	13
4440	Santa Maria do Tocantins	27
4441	Santa Maria Madalena	19
4442	Santa Mariana	16
4443	Santa Mercedes	25
4444	Santa Mônica	16
4445	Santana	3
4446	Santana	5
4447	Santana da Boa Vista	21
4448	Santana da Ponte Pensa	25
4449	Santana da Vargem	13
4450	Santana de Cataguases	13
4451	Santana de Mangueira	15
4452	Santana de Parnaíba	25
4453	Santana de Pirapama	13
4454	Santana do Acaraú	6
4455	Santana do Araguaia	14
4456	Santana do Cariri	6
4457	Santana do Deserto	13
4458	Santana do Garambéu	13
4459	Santana do Ipanema	2
4460	Santana do Itararé	16
4461	Santana do Jacaré	13
4462	Santana do Livramento	21
4463	Santana do Manhuaçu	13
4464	Santana do Maranhão	10
4465	Santana do Matos	20
4466	Santana do Mundaú	2
4467	Santana do Paraíso	13
4468	Santana do Piauí	18
4469	Santana do Riacho	13
4470	Santana do São Francisco	26
4471	Santana do Seridó	20
4472	Santana dos Garrotes	15
4473	Santana dos Montes	13
4474	Santanópolis	5
4475	Santa Quitéria	6
4476	Santa Quitéria do Maranhão	10
4477	Santarém	14
4478	Santarém	15
4479	Santarém Novo	14
4480	Santa Rita	10
4481	Santa Rita	15
4482	Santa Rita de Caldas	13
4483	Santa Rita de Cássia	5
4484	Santa Rita de Jacutinga	13
4485	Santa Rita de Minas	13
4486	Santa Rita do Araguaia	9
4487	Santa Rita d'Oeste	25
4488	Santa Rita de Ibitipoca	13
4489	Santa Rita do Itueto	13
4490	Santa Rita do Novo Destino	9
4491	Santa Rita do Pardo	12
4492	Santa Rita do Passa Quatro	25
4493	Santa Rita do Sapucaí	13
4494	Santa Rita do Tocantins	27
4495	Santa Rita do Trivelato	11
4496	Santa Rosa	21
4497	Santa Rosa da Serra	13
4498	Santa Rosa de Goiás	9
4499	Santa Rosa de Lima	24
4500	Santa Rosa de Lima	26
4501	Santa Rosa de Viterbo	25
4502	Santa Rosa do Piauí	18
4503	Santa Rosa do Purus	1
4504	Santa Rosa do Sul	24
4505	Santa Rosa do Tocantins	27
4506	Santa Salete	25
4507	Santa Teresa	8
4508	Santa Teresinha	5
4509	Santa Teresinha	15
4510	Santa Tereza	21
4511	Santa Tereza de Goiás	9
4512	Santa Tereza do Oeste	16
4513	Santa Tereza do Tocantins	27
4514	Santa Terezinha	11
4515	Santa Terezinha	17
4516	Santa Terezinha	24
4517	Santa Terezinha de Goiás	9
4518	Santa Terezinha de Itaipu	16
4519	Santa Terezinha do Progresso	24
4520	Santa Terezinha do Tocantins	27
4521	Santa Vitória	13
4522	Santa Vitória do Palmar	21
4523	Santiago	21
4524	Santiago do Sul	24
4525	Santo Afonso	11
4526	Santo Amaro	5
4527	Santo Amaro da Imperatriz	24
4528	Santo Amaro das Brotas	26
4529	Santo Amaro do Maranhão	10
4530	Santo Anastácio	25
4531	Santo André	15
4532	Santo André	25
4533	Santo Ângelo	21
4534	Santo Antônio	20
4535	Santo Antônio da Alegria	25
4536	Santo Antônio da Barra	9
4537	Santo Antônio da Patrulha	21
4538	Santo Antônio da Platina	16
4539	Santo Antônio das Missões	21
4540	Santo Antônio de Goiás	9
4541	Santo Antônio de Jesus	5
4542	Santo Antônio de Lisboa	18
4543	Santo Antônio de Pádua	19
4544	Santo Antônio de Posse	25
4545	Santo Antônio do Amparo	13
4546	Santo Antônio do Aracanguá	25
4547	Santo Antônio do Aventureiro	13
4548	Santo Antônio do Caiuá	16
4549	Santo Antônio do Descoberto	9
4550	Santo Antônio do Grama	13
4551	Santo Antônio do Içá	4
4552	Santo Antônio do Itambé	13
4553	Santo Antônio do Jacinto	13
4554	Santo Antônio do Jardim	25
4555	Santo Antônio do Leste	11
4556	Santo Antônio do Leverger	11
4557	Santo Antônio do Monte	13
4558	Santo Antônio do Palma	21
4559	Santo Antônio do Paraíso	16
4560	Santo Antônio do Pinhal	25
4561	Santo Antônio do Planalto	21
4562	Santo Antônio do Retiro	13
4563	Santo Antônio do Rio Abaixo	13
4564	Santo Antônio dos Lopes	10
4565	Santo Antônio dos Milagres	18
4566	Santo Antônio do Sudoeste	16
4567	Santo Antônio do Tauá	14
4568	Santo Augusto	21
4569	Santo Cristo	21
4570	Santo Estêvão	5
4571	Santo Expedito	25
4572	Santo Expedito do Sul	21
4573	Santo Hipólito	13
4574	Santo Inácio	16
4575	Santo Inácio do Piauí	18
4576	Santópolis do Aguapeí	25
4577	Santos	25
4578	Santos Dumont	13
4579	São Benedito	6
4580	São Benedito do Rio Preto	10
4581	São Benedito do Sul	17
4582	São Bento	10
4583	São Bento	15
4584	São Bento Abade	13
4585	São Bento de Pombal	15
4586	São Bento do Norte	20
4587	São Bento do Sapucaí	25
4588	São Bento do Sul	24
4589	São Bento do Tocantins	27
4590	São Bento do Trairi	20
4591	São Bento do Una	17
4592	São Bernardino	24
4593	São Bernardo	10
4594	São Bernardo do Campo	25
4595	São Bonifácio	24
4596	São Borja	21
4597	São Brás	2
4598	São Brás do Suaçuí	13
4599	São Braz do Piauí	18
4600	São Caetano	17
4601	São Caetano de Odivelas	14
4602	São Caetano do Sul	25
4603	São Carlos	24
4604	São Carlos	25
4605	São Carlos do Ivaí	16
4606	São Cristóvão	26
4607	São Cristóvão do Sul	24
4608	São Desidério	5
4609	São Domingos	5
4610	São Domingos	9
4611	São Domingos	15
4612	São Domingos	24
4613	São Domingos	26
4614	São Domingos das Dores	13
4615	São Domingos do Araguaia	14
4616	São Domingos do Azeitão	10
4617	São Domingos do Capim	14
4618	São Domingos do Cariri	15
4619	São Domingos do Maranhão	10
4620	São Domingos do Norte	8
4621	São Domingos do Prata	13
4622	São Domingos do Sul	21
4623	São Felipe	5
4624	São Felipe d'Oeste	22
4625	São Félix	5
4626	São Félix de Balsas	10
4627	São Félix de Minas	13
4628	São Félix do Araguaia	11
4629	São Félix do Coribe	5
4630	São Félix do Piauí	18
4631	São Félix do Tocantins	27
4632	São Félix do Xingu	14
4633	São Fernando	20
4634	São Fidélis	19
4635	São Francisco	13
4636	São Francisco	15
4637	São Francisco	26
4638	São Francisco	25
4639	São Francisco de Assis	21
4640	São Francisco de Assis do Piauí	18
4641	São Francisco de Goiás	9
4642	São Francisco de Itabapoana	19
4643	São Francisco de Paula	13
4644	São Francisco de Paula	21
4645	São Francisco de Sales	13
4646	São Francisco do Brejão	10
4647	São Francisco do Conde	5
4648	São Francisco do Glória	13
4649	São Francisco do Guaporé	22
4650	São Francisco do Maranhão	10
4651	São Francisco do Oeste	20
4652	São Francisco do Pará	14
4653	São Francisco do Piauí	18
4654	São Francisco do Sul	24
4655	São Gabriel	5
4656	São Gabriel	21
4657	São Gabriel da Cachoeira	4
4658	São Gabriel da Palha	8
4659	São Gabriel do Oeste	12
4660	São Geraldo	13
4661	São Geraldo da Piedade	13
4662	São Geraldo do Araguaia	14
4663	São Geraldo do Baixio	13
4664	São Gonçalo	19
4665	São Gonçalo do Abaeté	13
4666	São Gonçalo do Amarante	6
4667	São Gonçalo do Amarante	20
4668	São Gonçalo do Gurguéia	18
4669	São Gonçalo do Pará	13
4670	São Gonçalo do Piauí	18
4671	São Gonçalo do Rio Abaixo	13
4672	São Gonçalo do Rio Preto	13
4673	São Gonçalo do Sapucaí	13
4674	São Gonçalo dos Campos	5
4675	São Gotardo	13
4676	São Jerônimo	21
4677	São Jerônimo da Serra	16
4678	São João	17
4679	São João	16
4680	São João Batista	10
4681	São João Batista	24
4682	São João Batista do Glória	13
4683	São João da Baliza	23
4684	São João da Barra	19
4685	São João da Boa Vista	25
4686	São João da Canabrava	18
4687	São João da Fronteira	18
4688	São João da Lagoa	13
4689	São João d'Aliança	9
4690	São João da Mata	13
4691	São João da Paraúna	9
4692	São João da Ponta	14
4693	São João da Ponte	13
4694	São João das Duas Pontes	25
4695	São João da Serra	18
4696	São João das Missões	13
4697	São João da Urtiga	21
4698	São João da Varjota	18
4699	São João de Iracema	25
4700	São João del-Rei	13
4701	São João de Meriti	19
4702	São João de Pirabas	14
4703	São João do Araguaia	14
4704	São João do Arraial	18
4705	São João do Caiuá	16
4706	São João do Cariri	15
4707	São João do Caru	10
4708	São João do Itaperiú	24
4709	São João do Ivaí	16
4710	São João do Jaguaribe	6
4711	São João do Manhuaçu	13
4712	São João do Manteninha	13
4713	São João do Oeste	24
4714	São João do Oriente	13
4715	São João do Pacuí	13
4716	São João do Paraíso	10
4717	São João do Paraíso	13
4718	São João do Pau-d'Alho	25
4719	São João do Piauí	18
4720	São João do Polêsine	21
4721	São João do Rio do Peixe	15
4722	São João do Sabugi	20
4723	São João do Soter	10
4724	São João dos Patos	10
4725	São João do Sul	24
4726	São João do Tigre	15
4727	São João do Triunfo	16
4728	São João Evangelista	13
4729	São João Nepomuceno	13
4730	São Joaquim	24
4731	São Joaquim da Barra	25
4732	São Joaquim de Bicas	13
4733	São Joaquim do Monte	17
4734	São Jorge	21
4735	São Jorge d'Oeste	16
4736	São Jorge do Ivaí	16
4737	São Jorge do Patrocínio	16
4738	São José	24
4739	São José da Barra	13
4740	São José da Bela Vista	25
4741	São José da Boa Vista	16
4742	São José da Coroa Grande	17
4743	São José da Lagoa Tapada	15
4744	São José da Laje	2
4745	São José da Lapa	13
4746	São José da Safira	13
4747	São José das Missões	21
4748	São José das Palmeiras	16
4749	São José da Tapera	2
4750	São José da Varginha	13
4751	São José da Vitória	5
4752	São José de Caiana	15
4753	São José de Espinharas	15
4754	São José de Mipibu	20
4755	São José de Piranhas	15
4756	São José de Princesa	15
4757	São José de Ribamar	10
4758	São José de Ubá	19
4759	São José do Alegre	13
4760	São José do Barreiro	25
4761	São José do Belmonte	17
4762	São José do Bonfim	15
4763	São José do Brejo do Cruz	15
4764	São José do Calçado	8
4765	São José do Campestre	20
4766	São José do Cedro	24
4767	São José do Cerrito	24
4768	São José do Divino	13
4769	São José do Divino	18
4770	São José do Egito	17
4771	São José do Goiabal	13
4772	São José do Herval	21
4773	São José do Hortêncio	21
4774	São José do Inhacorá	21
4775	São José do Jacuípe	5
4776	São José do Jacuri	13
4777	São José do Mantimento	13
4778	São José do Norte	21
4779	São José do Ouro	21
4780	São José do Peixe	18
4781	São José do Piauí	18
4782	São José do Povo	11
4783	São José do Rio Claro	11
4784	São José do Rio Pardo	25
4785	São José do Rio Preto	25
4786	São José do Sabugi	15
4787	São José dos Ausentes	21
4788	São José dos Basílios	10
4789	São José dos Campos	25
4790	São José dos Cordeiros	15
4791	São José do Seridó	20
4792	São José dos Pinhais	16
4793	São José dos Quatro Marcos	11
4794	São José dos Ramos	15
4795	São José do Sul	21
4796	São José do Vale do Rio Preto	19
4797	São José do Xingu	11
4798	São Julião	18
4799	São Leopoldo	21
4800	São Lourenço	13
4801	São Lourenço da Mata	17
4802	São Lourenço da Serra	25
4803	São Lourenço do Oeste	24
4804	São Lourenço do Piauí	18
4805	São Lourenço do Sul	21
4806	São Ludgero	24
4807	São Luís	10
4808	São Luís	23
4809	São Luís de Montes Belos	9
4810	São Luís do Curu	6
4811	São Luís do Norte	9
4812	São Luís do Piauí	18
4813	São Luís do Quitunde	2
4814	São Luiz do Paraitinga	25
4815	São Luiz Gonzaga	21
4816	São Luís Gonzaga do Maranhão	10
4817	São Mamede	15
4818	São Manoel do Paraná	16
4819	São Manuel	25
4820	São Marcos	21
4821	São Martinho	21
4822	São Martinho	24
4823	São Martinho da Serra	21
4824	São Mateus	8
4825	São Mateus do Maranhão	10
4826	São Mateus do Sul	16
4827	São Miguel	20
4828	São Miguel Arcanjo	25
4829	São Miguel da Baixa Grande	18
4830	São Miguel da Boa Vista	24
4831	São Miguel das Matas	5
4832	São Miguel das Missões	21
4833	São Miguel de Taipu	15
4834	São Miguel do Aleixo	26
4835	São Miguel do Anta	13
4836	São Miguel do Araguaia	9
4837	São Miguel do Fidalgo	18
4838	São Miguel do Gostoso	20
4839	São Miguel do Guamá	14
4840	São Miguel do Guaporé	22
4841	São Miguel do Iguaçu	16
4842	São Miguel do Oeste	24
4843	São Miguel do Passa-Quatro	9
4844	São Miguel dos Campos	2
4845	São Miguel dos Milagres	2
4846	São Miguel do Tapuio	18
4847	São Miguel do Tocantins	27
4848	São Nicolau	21
4849	São Patrício	9
4850	São Paulo	25
4851	São Paulo das Missões	21
4852	São Paulo de Olivença	4
4853	São Paulo do Potengi	20
4854	São Pedro	20
4855	São Pedro	25
4856	São Pedro da Água Branca	10
4857	São Pedro da Aldeia	19
4858	São Pedro da Cipa	11
4859	São Pedro da Serra	21
4860	São Pedro das Missões	21
4861	São Pedro da União	13
4862	São Pedro de Alcântara	24
4863	São Pedro do Butiá	21
4864	São Pedro do Iguaçu	16
4865	São Pedro do Ivaí	16
4866	São Pedro do Paraná	16
4867	São Pedro do Piauí	18
4868	São Pedro dos Crentes	10
4869	São Pedro dos Ferros	13
4870	São Pedro do Suaçuí	13
4871	São Pedro do Sul	21
4872	São Pedro do Turvo	25
4873	São Rafael	20
4874	São Raimundo das Mangabeiras	10
4875	São Raimundo do Doca Bezerra	10
4876	São Raimundo Nonato	18
4877	São Roberto	10
4878	São Romão	13
4879	São Roque	25
4880	São Roque de Minas	13
4881	São Roque do Canaã	8
4882	São Salvador do Tocantins	27
4883	São Sebastião	2
4884	São Sebastião	25
4885	São Sebastião da Amoreira	16
4886	São Sebastião da Bela Vista	13
4887	São Sebastião da Boa Vista	14
4888	São Sebastião da Grama	25
4889	São Sebastião da Vargem Alegre	13
4890	São Sebastião de Lagoa de Roça	15
4891	São Sebastião do Alto	19
4892	São Sebastião do Anta	13
4893	São Sebastião do Caí	21
4894	São Sebastião do Maranhão	13
4895	São Sebastião do Oeste	13
4896	São Sebastião do Paraíso	13
4897	São Sebastião do Passé	5
4898	São Sebastião do Rio Preto	13
4899	São Sebastião do Rio Verde	13
4900	São Sebastião do Tocantins	27
4901	São Sebastião do Uatumã	4
4902	São Sebastião do Umbuzeiro	15
4903	São Sepé	21
4904	São Simão	9
4905	São Simão	25
4906	São Thomé das Letras	13
4907	São Tiago	13
4908	São Tomás de Aquino	13
4909	São Tomé	16
4910	São Tomé	20
4911	São Valentim do Sul	21
4912	São Valentim	21
4913	São Valério da Natividade	27
4914	São Valério do Sul	21
4915	São Vendelino	21
4916	São Vicente	20
4917	São Vicente	25
4918	São Vicente de Minas	13
4919	São Vicente do Sul	21
4920	São Vicente Ferrer	10
4921	São Vicente Ferrer	17
4922	Sapé	15
4923	Sapeaçu	5
4924	Sapezal	11
4925	Sapiranga	21
4926	Sapopema	16
4927	Sapucaia	14
4928	Sapucaia	19
4929	Sapucaia do Sul	21
4930	Sapucaí-Mirim	13
4931	Saquarema	19
4932	Sarandi	16
4933	Sarandi	21
4934	Sarapuí	25
4935	Sardoá	13
4936	Sarutaiá	25
4937	Sarzedo	13
4938	Sátiro Dias	5
4939	Satuba	2
4940	Satubinha	10
4941	Saubara	5
4942	Saudade do Iguaçu	16
4943	Saudades	24
4944	Saúde	5
4945	Schroeder	24
4946	Seabra	5
4947	Seara	24
4948	Sebastianópolis do Sul	25
4949	Sebastião Barros	18
4950	Sebastião Laranjeiras	5
4951	Sebastião Leal	18
4952	Seberi	21
4953	Sede Nova	21
4954	Segredo	21
4955	Selbach	21
4956	Selvíria	12
4957	Sem-Peixe	13
4958	Senador Alexandre Costa	10
4959	Senador Amaral	13
4960	Senador Canedo	9
4961	Senador Cortes	13
4962	Senador Elói de Souza	20
4963	Senador Firmino	13
4964	Senador Georgino Avelino	20
4965	Senador Guiomard	1
4966	Senador José Bento	13
4967	Senador José Porfírio	14
4968	Senador La Rocque	10
4969	Senador Modestino Gonçalves	13
4970	Senador Pompeu	6
4971	Senador Rui Palmeira	2
4972	Senador Sá	6
4973	Senador Salgado Filho	21
4974	Sena Madureira	1
4975	Sengés	16
4976	Senhora de Oliveira	13
4977	Senhora do Porto	13
4978	Senhora dos Remédios	13
4979	Senhor do Bonfim	5
4980	Sentinela do Sul	21
4981	Sento Sé	5
4982	Serafina Corrêa	21
4983	Sericita	13
4984	Seridó	15
4985	Seringueiras	22
4986	Sério	21
4987	Seritinga	13
4988	Seropédica	19
4989	Serra	8
4990	Serra Alta	24
4991	Serra Azul	25
4992	Serra Azul de Minas	13
4993	Serra Branca	15
4994	Serra Caiada	20
4995	Serra da Raiz	15
4996	Serra da Saudade	13
4997	Serra de São Bento	20
4998	Serra do Mel	20
4999	Serra do Navio	3
5000	Serra do Ramalho	5
5001	Serra dos Aimorés	13
5002	Serra do Salitre	13
5003	Serra Dourada	5
5004	Serra Grande	15
5005	Serrana	25
5006	Serrania	13
5007	Serra Negra	25
5008	Serra Negra do Norte	20
5009	Serrano do Maranhão	10
5010	Serranópolis	9
5011	Serranópolis de Minas	13
5012	Serranópolis do Iguaçu	16
5013	Serranos	13
5014	Serra Nova Dourada	11
5015	Serra Preta	5
5016	Serra Redonda	15
5017	Serraria	15
5018	Serra Talhada	17
5019	Serrinha	5
5020	Serrinha	20
5021	Serrinha dos Pintos	20
5022	Serrita	17
5023	Serro	13
5024	Serrolândia	5
5025	Sertaneja	16
5026	Sertânia	17
5027	Sertanópolis	16
5028	Sertão	21
5029	Sertão Santana	21
5030	Sertãozinho	15
5031	Sertãozinho	25
5032	Sete Barras	25
5033	Sete de Setembro	21
5034	Sete Lagoas	13
5035	Sete Quedas	12
5036	Setubinha	13
5037	Severiano de Almeida	21
5038	Severiano Melo	20
5039	Severínia	25
5040	Siderópolis	24
5041	Sidrolândia	12
5042	Sigefredo Pacheco	18
5043	Silva Jardim	19
5044	Silvânia	9
5045	Silvanópolis	27
5046	Silveira Martins	21
5047	Silveirânia	13
5048	Silveiras	25
5049	Silves	4
5050	Silvianópolis	13
5051	Simão Dias	26
5052	Simão Pereira	13
5053	Simões	18
5054	Simões Filho	5
5055	Simolândia	9
5056	Simonésia	13
5057	Simplício Mendes	18
5058	Sinimbu	21
5059	Sinop	11
5060	Siqueira Campos	16
5061	Sirinhaém	17
5062	Siriri	26
5063	Sítio d'Abadia	9
5064	Sítio do Mato	5
5065	Sítio do Quinto	5
5066	Sítio Novo	10
5067	Sítio Novo	20
5068	Sítio Novo do Tocantins	27
5069	Sobradinho	5
5070	Sobradinho	21
5071	Sobrado	15
5072	Sobral	6
5073	Sobrália	13
5074	Socorro	25
5075	Socorro do Piauí	18
5076	Solânea	15
5077	Soledade	15
5078	Soledade	21
5079	Soledade de Minas	13
5080	Solidão	17
5081	Solonópole	6
5082	Sombrio	24
5083	Sonora	12
5084	Sooretama	8
5085	Sorocaba	25
5086	Sorriso	11
5087	Sossêgo	15
5088	Soure	14
5089	Sousa	15
5090	Souto Soares	5
5091	Sucupira	27
5092	Sucupira do Norte	10
5093	Sucupira do Riachão	10
5094	Sud Mennucci	25
5095	Sul Brasil	24
5096	Sulina	16
5097	Sumaré	25
5098	Sumé	15
5099	Sumidouro	19
5100	Surubim	17
5101	Sussuapara	18
5102	Suzanápolis	25
5103	Suzano	25
5104	Tabaí	21
5105	Tabaporã	11
5106	Tabapuã	25
5107	Tabatinga	4
5108	Tabatinga	25
5109	Tabira	17
5110	Taboão da Serra	25
5111	Tabocas do Brejo Velho	5
5112	Taboleiro Grande	20
5113	Tabuleiro do Norte	6
5114	Tabuleiro	13
5115	Tacaimbó	17
5116	Tacaratu	17
5117	Taciba	25
5118	Tacima	15
5119	Tacuru	12
5120	Taguaí	25
5121	Taguatinga	27
5122	Taiaçu	25
5123	Tailândia	14
5124	Taiobeiras	13
5125	Taió	24
5126	Taipas do Tocantins	27
5127	Taipu	20
5128	Taiuva	25
5129	Talismã	27
5130	Tamandaré	17
5131	Tamarana	16
5132	Tambaú	25
5133	Tamboara	16
5134	Tamboril	6
5135	Tamboril do Piauí	18
5136	Tanabi	25
5137	Tangará	20
5138	Tangará	24
5139	Tangará da Serra	11
5140	Tanguá	19
5141	Tanhaçu	5
5142	Tanque d'Arca	2
5143	Tanque do Piauí	18
5144	Tanque Novo	5
5145	Tanquinho	5
5146	Taparuba	13
5147	Tapauá	4
5148	Tapejara	16
5149	Tapejara	21
5150	Tapera	21
5151	Taperoá	5
5152	Taperoá	15
5153	Tapes	21
5154	Tapira	13
5155	Tapira	16
5156	Tapiraí	13
5157	Tapiraí	25
5158	Tapiramutá	5
5159	Tapiratiba	25
5160	Tapurah	11
5161	Taquara	21
5162	Taquaraçu de Minas	13
5163	Taquaral	25
5164	Taquaral de Goiás	9
5165	Taquarana	2
5166	Taquari	21
5167	Taquaritinga	25
5168	Taquaritinga do Norte	17
5169	Taquarituba	25
5170	Taquarivaí	25
5171	Taquaruçu do Sul	21
5172	Taquarussu	12
5173	Tarabai	25
5174	Tarauacá	1
5175	Tarrafas	6
5176	Tartarugalzinho	3
5177	Tarumã	25
5178	Tarumirim	13
5179	Tasso Fragoso	10
5180	Tatuí	25
5181	Tauá	6
5182	Taubaté	25
5183	Tavares	15
5184	Tavares	21
5185	Tefé	4
5186	Teixeira	15
5187	Teixeira de Freitas	5
5188	Teixeira Soares	16
5189	Teixeiras	13
5190	Teixeirópolis	22
5191	Tejuçuoca	6
5192	Tejupá	25
5193	Telêmaco Borba	16
5194	Telha	26
5195	Tenente Ananias	20
5196	Tenente Laurentino Cruz	20
5197	Tenente Portela	21
5198	Tenório	15
5199	Teodoro Sampaio	5
5200	Teodoro Sampaio	25
5201	Teofilândia	5
5202	Teófilo Otoni	13
5203	Teolândia	5
5204	Teotônio Vilela	2
5205	Terenos	12
5206	Teresina	18
5207	Teresina de Goiás	9
5208	Teresópolis	19
5209	Terezinha	17
5210	Terezópolis de Goiás	9
5211	Terra Alta	14
5212	Terra Boa	16
5213	Terra de Areia	21
5214	Terra Nova	5
5215	Terra Nova	17
5216	Terra Nova do Norte	11
5217	Terra Rica	16
5218	Terra Roxa	16
5219	Terra Roxa	25
5220	Terra Santa	14
5221	Tesouro	11
5222	Teutônia	21
5223	Theobroma	22
5224	Tianguá	6
5225	Tibagi	16
5226	Tibau do Sul	20
5227	Tibau	20
5228	Tietê	25
5229	Tigrinhos	24
5230	Tijucas	24
5231	Tijucas do Sul	16
5232	Timbaúba	17
5233	Timbaúba dos Batistas	20
5234	Timbé do Sul	24
5235	Timbiras	10
5236	Timbó	24
5237	Timbó Grande	24
5238	Timburi	25
5239	Timon	10
5240	Timóteo	13
5241	Tio Hugo	21
5242	Tiradentes	13
5243	Tiradentes do Sul	21
5244	Tiros	13
5245	Tobias Barreto	26
5246	Tocantínia	27
5247	Tocantinópolis	27
5248	Tocantins	13
5249	Tocos do Moji	13
5250	Toledo	13
5251	Toledo	16
5252	Tomar do Geru	26
5253	Tomazina	16
5254	Tombos	13
5255	Tomé-Açu	14
5256	Tonantins	4
5257	Toritama	17
5258	Torixoréu	11
5259	Toropi	21
5260	Torre de Pedra	25
5261	Torres	21
5262	Torrinha	25
5263	Touros	20
5264	Trabiju	25
5265	Tracuateua	14
5266	Tracunhaém	17
5267	Traipu	2
5268	Trairão	14
5269	Trairi	6
5270	Trajano de Moraes	19
5271	Tramandaí	21
5272	Travesseiro	21
5273	Tremedal	5
5274	Tremembé	25
5275	Três Arroios	21
5276	Três Barras do Paraná	16
5277	Três Barras	24
5278	Três Cachoeiras	21
5279	Três Corações	13
5280	Três Coroas	21
5281	Três de Maio	21
5282	Três Forquilhas	21
5283	Três Fronteiras	25
5284	Três Lagoas	12
5285	Três Marias	13
5286	Três Palmeiras	21
5287	Três Passos	21
5288	Três Pontas	13
5289	Três Ranchos	9
5290	Três Rios	19
5291	Treviso	24
5292	Treze de Maio	24
5293	Treze Tílias	24
5294	Trizidela do Vale	10
5295	Trindade	9
5296	Trindade	17
5297	Trindade do Sul	21
5298	Triunfo	15
5299	Triunfo	17
5300	Triunfo	21
5301	Triunfo Potiguar	20
5302	Trombas	9
5303	Trombudo Central	24
5304	Tubarão	24
5305	Tucano	5
5306	Tucumã	14
5307	Tucunduva	21
5308	Tucuruí	14
5309	Tufilândia	10
5310	Tuiuti	25
5311	Tumiritinga	13
5312	Tunápolis	24
5313	Tunas do Paraná	16
5314	Tunas	21
5315	Tuneiras do Oeste	16
5316	Tuntum	10
5317	Tupaciguara	13
5318	Tupanatinga	17
5319	Tupanci do Sul	21
5320	Tupanciretã	21
5321	Tupandi	21
5322	Tuparendi	21
5323	Tuparetama	17
5324	Tupã	25
5325	Tupãssi	16
5326	Tupi Paulista	25
5327	Tupirama	27
5328	Tupiratins	27
5329	Turiaçu	10
5330	Turilândia	10
5331	Turiúba	25
5332	Turmalina	13
5333	Turmalina	25
5334	Turuçu	21
5335	Tururu	6
5336	Turvânia	9
5337	Turvelândia	9
5338	Turvo	16
5339	Turvo	24
5340	Turvolândia	13
5341	Tutóia	10
5342	Uarini	4
5343	Uauá	5
5344	Ubá	13
5345	Ubaí	13
5346	Ubaíra	5
5347	Ubaitaba	5
5348	Ubajara	6
5349	Ubaporanga	13
5350	Ubarana	25
5351	Ubatã	5
5352	Ubatuba	25
5353	Uberaba	13
5354	Uberlândia	13
5355	Ubirajara	25
5356	Ubiratã	16
5357	Ubiretama	21
5358	Uchoa	25
5359	Uibaí	5
5360	Uiramutã	23
5361	Uirapuru	9
5362	Uiraúna	15
5363	Ulianópolis	14
5364	Umari	6
5365	Umarizal	20
5366	Umbaúba	26
5367	Umburanas	5
5368	Umburatiba	13
5369	Umbuzeiro	15
5370	Umirim	6
5371	Umuarama	16
5372	Una	5
5373	Unaí	13
5374	União	18
5375	União da Serra	21
5376	União da Vitória	16
5377	União de Minas	13
5378	União do Oeste	24
5379	União dos Palmares	2
5380	União do Sul	11
5381	União Paulista	25
5382	Uniflor	16
5383	Unistalda	21
5384	Upanema	20
5385	Uraí	16
5386	Urandi	5
5387	Urânia	25
5388	Urbano Santos	10
5389	Uru	25
5390	Uruaçu	9
5391	Uruana	9
5392	Uruana de Minas	13
5393	Uruará	14
5394	Urubici	24
5395	Uruburetama	6
5396	Urucânia	13
5397	Urucará	4
5398	Uruçuca	5
5399	Uruçuí	18
5400	Urucuia	13
5401	Urucurituba	4
5402	Uruguaiana	21
5403	Uruoca	6
5404	Urupá	22
5405	Urupema	24
5406	Urupês	25
5407	Urussanga	24
5408	Urutaí	9
5409	Utinga	5
5410	Vacaria	21
5411	Vale de São Domingos	11
5412	Vale do Anari	22
5413	Vale do Paraíso	22
5414	Vale do Sol	21
5415	Valença	5
5416	Valença	19
5417	Valença do Piauí	18
5418	Valente	5
5419	Valentim Gentil	25
5420	Vale Real	21
5421	Vale Verde	21
5422	Valinhos	25
5423	Valparaíso	25
5424	Valparaíso de Goiás	9
5425	Vanini	21
5426	Vargeão	24
5427	Vargem	24
5428	Vargem	25
5429	Vargem Alegre	13
5430	Vargem Alta	8
5431	Vargem Bonita	13
5432	Vargem Bonita	24
5433	Vargem Grande	10
5434	Vargem Grande do Rio Pardo	13
5435	Vargem Grande do Sul	25
5436	Vargem Grande Paulista	25
5437	Varginha	13
5438	Varjão	9
5439	Varjão de Minas	13
5440	Varjota	6
5441	Varre-Sai	19
5442	Várzea	15
5443	Várzea	20
5444	Várzea Alegre	6
5445	Várzea Branca	18
5446	Várzea da Palma	13
5447	Várzea da Roça	5
5448	Várzea do Poço	5
5449	Várzea Grande	11
5450	Várzea Grande	18
5451	Várzea Nova	5
5452	Várzea Paulista	25
5453	Varzedo	5
5454	Varzelândia	13
5455	Vassouras	19
5456	Vazante	13
5457	Venâncio Aires	21
5458	Venda Nova do Imigrante	8
5459	Venha-Ver	20
5460	Ventania	16
5461	Venturosa	17
5462	Vera	11
5463	Vera Cruz	5
5464	Vera Cruz	20
5465	Vera Cruz	21
5466	Vera Cruz	25
5467	Vera Cruz do Oeste	16
5468	Vera Mendes	18
5469	Veranópolis	21
5470	Verdejante	17
5471	Verdelândia	13
5472	Verê	16
5473	Vereda	5
5474	Veredinha	13
5475	Veríssimo	13
5476	Vermelho Novo	13
5477	Vertente do Lério	17
5478	Vertentes	17
5479	Vespasiano	13
5480	Vespasiano Corrêa	21
5481	Viadutos	21
5482	Viamão	21
5483	Viana	8
5484	Viana	10
5485	Vianópolis	9
5486	Vicência	17
5487	Vicente Dutra	21
5488	Vicentina	12
5489	Vicentinópolis	9
5490	Viçosa	2
5491	Viçosa	13
5492	Viçosa	20
5493	Viçosa do Ceará	6
5494	Victor Graeff	21
5495	Vidal Ramos	24
5496	Videira	24
5497	Vieiras	13
5498	Vieirópolis	15
5499	Vigia	14
5500	Vila Bela da Santíssima Trindade	11
5501	Vila Boa	9
5502	Vila Flores	21
5503	Vila Flor	20
5504	Vila Lângaro	21
5505	Vila Maria	21
5506	Vila Nova do Piauí	18
5507	Vila Nova dos Martírios	10
5508	Vila Nova do Sul	21
5509	Vila Pavão	8
5510	Vila Propício	9
5511	Vila Rica	11
5512	Vila Valério	8
5513	Vila Velha	8
5514	Vilhena	22
5515	Vinhedo	25
5516	Viradouro	25
5517	Virgem da Lapa	13
5518	Virgínia	13
5519	Virginópolis	13
5520	Virgolândia	13
5521	Virmond	16
5522	Visconde do Rio Branco	13
5523	Vista Alegre	21
5524	Vista Alegre do Alto	25
5525	Vista Alegre do Prata	21
5526	Vista Gaúcha	21
5527	Vista Serrana	15
5528	Vitória	8
5529	Vitória Brasil	25
5530	Vitória da Conquista	5
5531	Vitória das Missões	21
5532	Vitória de Santo Antão	17
5533	Vitória do Jari	3
5534	Vitória do Mearim	10
5535	Vitória do Xingu	14
5536	Vitorino	16
5537	Vitorino Freire	10
5538	Vitor Meireles	24
5539	Viseu	14
5540	Volta Grande	13
5541	Volta Redonda	19
5542	Votorantim	25
5543	Votuporanga	25
5544	Wagner	5
5545	Wall Ferraz	18
5546	Wanderlândia	27
5547	Wanderley	5
5548	Wenceslau Braz	13
5549	Wenceslau Braz	16
5550	Wenceslau Guimarães	5
5551	Westfália	21
5552	Witmarsum	24
5553	Xambioá	27
5554	Xambrê	16
5555	Xangri-lá	21
5556	Xanxerê	24
5557	Xapuri	1
5558	Xavantina	24
5559	Xaxim	24
5560	Xexéu	17
5561	Xinguara	14
5562	Xique-Xique	5
5563	Zabelê	15
5564	Zacarias	25
5565	Zé Doca	10
5566	Zortéa	24
\.


--
-- Name: cidade_id_cidade_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('cidade_id_cidade_seq', 1, false);


--
-- Data for Name: classe; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY classe (id_classe, num_classe, desc_classe) FROM stdin;
1	1.1	Substâncias e artigos com risco de explosão em Massa
2	1.2	Substâncias e artigos com risco de projeção, mas sem risco de explosão em massa.
3	1.3	Substâncias e artigos com risco de fogo e com pequeno risco de explosão, de projeção, ou ambos, mas sem risco de explosão em massa.
4	1.4	Substâncias e artigos que não apresentam risco significativo.
5	1.5	Substâncias muito insensíveis, com um risco de explosão em massa
6	1.6	Artigos extremamente insensíveis, sem risco de explosão em massa.
7	2.1	Gases inflamáveis
8	2.2	Gases não-inflamáveis, não-tóxicos
9	2.3	Gases tóxicos
10	3	LÍQUIDOS INFLAMÁVEIS
11	4.1	Sólidos inflamáveis
12	4.2	Substâncias sujeitas a combustão espontânea
13	4.3	Substâncias que, em contato com a água, emitem gases inflamáveis
14	5.1	Substâncias oxidantes
15	5.2	Peróxidos orgânicos
16	6.1	Substâncias tóxicas (venenosas)
17	6.2	Substâncias infectantes
18	7	MATERIAIS RADIOATIVOS
19	8	CORROSIVOS
20	9	SUBSTÂNCIAS PERIGOSAS DIVERSAS
\.


--
-- Data for Name: combustivel; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY combustivel (id_combustivel, espec_combustivel, nome_combustivel) FROM stdin;
\.


--
-- Name: combustivel_id_combustivel_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('combustivel_id_combustivel_seq', 1, false);


--
-- Data for Name: compatibilidade; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY compatibilidade (id_comptibilidade, numonu, id_tipo_comp) FROM stdin;
1	1005	1
2	1008	1
3	1016	1
4	1017	1
5	1023	1
6	1026	1
7	1040	1
8	1041	1
9	1045	1
10	1048	1
11	1050	1
12	1053	1
13	1062	1
14	1064	1
15	1067	1
16	1069	1
17	1076	1
18	1079	1
19	1581	1
20	1582	1
21	1589	1
22	1612	1
23	1660	1
24	1703	1
25	1705	1
26	1741	1
27	1749	1
28	1859	1
29	1911	1
30	1953	1
31	1955	1
32	1967	1
33	1975	1
34	2186	1
35	2188	1
36	2189	1
37	2190	1
38	2191	1
39	2192	1
40	2194	1
41	2195	1
42	2196	1
43	2197	1
44	2198	1
45	2199	1
46	2202	1
47	2204	1
48	2417	1
49	2418	1
50	2420	1
51	2421	1
52	2451	1
53	2534	1
54	2548	1
55	2600	1
56	2676	1
57	2901	1
58	3057	1
59	3070	1
60	3083	1
61	3160	1
62	3162	1
63	3168	1
64	3169	1
65	3101	3
66	3102	3
67	3111	3
68	3112	3
69	1051	4
70	1092	4
71	1098	4
72	1163	4
73	1182	4
74	1238	4
75	1239	4
76	1244	4
77	1259	4
78	1541	4
79	1553	4
80	1560	4
81	1565	4
82	1570	4
83	1575	4
84	1580	4
85	1595	4
86	1613	4
87	1614	4
88	1626	4
89	1647	4
90	1649	4
91	1670	4
92	1672	4
93	1680	4
94	1689	4
95	1692	4
96	1694	4
97	1698	4
98	1699	4
99	1713	4
100	1889	4
101	1892	4
102	1994	4
103	2249	4
104	2316	4
105	2317	4
106	2334	4
107	2471	4
108	2480	4
109	2558	4
110	2628	4
111	2629	4
112	2630	4
113	2642	4
114	2646	4
115	2740	4
116	3048	4
117	3246	4
118	3101	7
119	3102	7
120	3111	7
121	3112	7
122	1001	9
123	1010	9
124	1011	9
125	1012	9
126	1027	9
127	1030	9
128	1032	9
129	1033	9
130	1035	9
131	1036	9
132	1037	9
133	1038	9
134	1039	9
135	1049	9
136	1052	9
137	1055	9
138	1057	9
139	1060	9
140	1061	9
141	1063	9
142	1071	9
143	1075	9
144	1077	9
145	1081	9
146	1082	9
147	1083	9
148	1085	9
149	1086	9
150	1087	9
151	1088	9
152	1089	9
153	1090	9
154	1091	9
155	1093	9
156	1099	9
157	1100	9
158	1104	9
159	1105	9
160	1106	9
161	1107	9
162	1108	9
163	1109	9
164	1110	9
165	1111	9
166	1112	9
167	1113	9
168	1114	9
169	1118	9
170	1120	9
171	1123	9
172	1125	9
173	1126	9
174	1127	9
175	1128	9
176	1129	9
177	1130	9
178	1131	9
179	1133	9
180	1134	9
181	1136	9
182	1139	9
183	1143	9
184	1144	9
185	1145	9
186	1146	9
187	1147	9
188	1148	9
189	1149	9
190	1150	9
191	1152	9
192	1153	9
193	1154	9
194	1155	9
195	1156	9
196	1157	9
197	1158	9
198	1159	9
199	1160	9
200	1161	9
201	1162	9
202	1164	9
203	1165	9
204	1166	9
205	1167	9
206	1169	9
207	1170	9
208	1171	9
209	1172	9
210	1173	9
211	1175	9
212	1176	9
213	1177	9
214	1178	9
215	1179	9
216	1180	9
217	1183	9
218	1184	9
219	1188	9
220	1189	9
221	1190	9
222	1191	9
223	1192	9
224	1193	9
225	1194	9
226	1195	9
227	1196	9
228	1197	9
229	1198	9
230	1199	9
231	1201	9
232	1202	9
233	1203	9
234	1204	9
235	1206	9
236	1207	9
237	1208	9
238	1210	9
239	1212	9
240	1213	9
241	1214	9
242	1216	9
243	1218	9
244	1219	9
245	1220	9
246	1221	9
247	1222	9
248	1223	9
249	1224	9
250	1228	9
251	1229	9
252	1230	9
253	1231	9
254	1233	9
255	1234	9
256	1235	9
257	1237	9
258	1242	9
259	1243	9
260	1245	9
261	1246	9
262	1247	9
263	1248	9
264	1249	9
265	1250	9
266	1251	9
267	1255	9
268	1256	9
269	1257	9
270	1261	9
271	1262	9
272	1263	9
273	1264	9
274	1265	9
275	1266	9
276	1267	9
277	1268	9
278	1270	9
279	1271	9
280	1272	9
281	1274	9
282	1275	9
283	1276	9
284	1277	9
285	1278	9
286	1279	9
287	1280	9
288	1281	9
289	1282	9
290	1286	9
291	1287	9
292	1288	9
293	1289	9
294	1292	9
295	1293	9
296	1294	9
297	1295	9
298	1296	9
299	1297	9
300	1298	9
301	1299	9
302	1300	9
303	1301	9
304	1302	9
305	1303	9
306	1304	9
307	1305	9
308	1306	9
309	1307	9
310	1308	9
311	1309	9
312	1310	9
313	1312	9
314	1313	9
315	1314	9
316	1318	9
317	1320	9
318	1321	9
319	1322	9
320	1323	9
321	1324	9
322	1325	9
323	1326	9
324	1327	9
325	1328	9
326	1330	9
327	1331	9
328	1332	9
329	1333	9
330	1334	9
331	1336	9
332	1337	9
333	1338	9
334	1339	9
335	1340	9
336	1341	9
337	1343	9
338	1344	9
339	1345	9
340	1346	9
341	1347	9
342	1348	9
343	1349	9
344	1350	9
345	1352	9
346	1353	9
347	1354	9
348	1355	9
349	1356	9
350	1357	9
351	1358	9
352	1360	9
353	1361	9
354	1362	9
355	1363	9
356	1364	9
357	1365	9
358	1366	9
359	1369	9
360	1370	9
361	1373	9
362	1374	9
363	1376	9
364	1378	9
365	1379	9
366	1380	9
367	1381	9
368	1382	9
369	1383	9
370	1384	9
371	1385	9
372	1386	9
373	1389	9
374	1390	9
375	1391	9
376	1392	9
377	1393	9
378	1394	9
379	1395	9
380	1396	9
381	1397	9
382	1398	9
383	1400	9
384	1401	9
385	1402	9
386	1403	9
387	1404	9
388	1405	9
389	1407	9
390	1408	9
391	1409	9
392	1410	9
393	1411	9
394	1413	9
395	1414	9
396	1415	9
397	1417	9
398	1418	9
399	1419	9
400	1420	9
401	1421	9
402	1422	9
403	1423	9
404	1426	9
405	1427	9
406	1428	9
407	1431	9
408	1432	9
409	1433	9
410	1435	9
411	1436	9
412	1437	9
413	1438	9
414	1439	9
415	1442	9
416	1444	9
417	1445	9
418	1446	9
419	1447	9
420	1448	9
421	1449	9
422	1450	9
423	1451	9
424	1452	9
425	1453	9
426	1454	9
427	1455	9
428	1456	9
429	1457	9
430	1458	9
431	1459	9
432	1461	9
433	1462	9
434	1463	9
435	1465	9
436	1466	9
437	1467	9
438	1469	9
439	1470	9
440	1471	9
441	1472	9
442	1473	9
443	1474	9
444	1475	9
445	1476	9
446	1477	9
447	1479	9
448	1481	9
449	1482	9
450	1483	9
451	1484	9
452	1485	9
453	1486	9
454	1487	9
455	1488	9
456	1489	9
457	1490	9
458	1491	9
459	1492	9
460	1493	9
461	1494	9
462	1495	9
463	1496	9
464	1498	9
465	1499	9
466	1500	9
467	1502	9
468	1503	9
469	1504	9
470	1505	9
471	1506	9
472	1507	9
473	1508	9
474	1509	9
475	1510	9
476	1511	9
477	1512	9
478	1513	9
479	1514	9
480	1515	9
481	1516	9
482	1517	9
483	1571	9
484	1604	9
485	1648	9
486	1714	9
487	1715	9
488	1716	9
489	1717	9
490	1718	9
491	1719	9
492	1722	9
493	1723	9
494	1724	9
495	1725	9
496	1726	9
497	1727	9
498	1728	9
499	1729	9
500	1730	9
501	1731	9
502	1732	9
503	1733	9
504	1736	9
505	1739	9
506	1740	9
507	1742	9
508	1743	9
509	1744	9
510	1745	9
511	1746	9
512	1747	9
513	1748	9
514	1752	9
515	1753	9
516	1754	9
517	1755	9
518	1756	9
519	1757	9
520	1758	9
521	1759	9
522	1760	9
523	1761	9
524	1762	9
525	1763	9
526	1764	9
527	1765	9
528	1766	9
529	1767	9
530	1768	9
531	1769	9
532	1770	9
533	1771	9
534	1773	9
535	1774	9
536	1775	9
537	1776	9
538	1777	9
539	1778	9
540	1779	9
541	1780	9
542	1781	9
543	1782	9
544	1783	9
545	1784	9
546	1786	9
547	1787	9
548	1788	9
549	1789	9
550	1790	9
551	1791	9
552	1792	9
553	1793	9
554	1794	9
555	1796	9
556	1798	9
557	1799	9
558	1800	9
559	1801	9
560	1802	9
561	1803	9
562	1804	9
563	1805	9
564	1806	9
565	1807	9
566	1808	9
567	1809	9
568	1810	9
569	1811	9
570	1813	9
571	1814	9
572	1815	9
573	1816	9
574	1817	9
575	1818	9
576	1819	9
577	1823	9
578	1824	9
579	1825	9
580	1826	9
581	1827	9
582	1828	9
583	1829	9
584	1830	9
585	1831	9
586	1832	9
587	1833	9
588	1834	9
589	1835	9
590	1836	9
591	1837	9
592	1838	9
593	1839	9
594	1840	9
595	1847	9
596	1848	9
597	1849	9
598	1854	9
599	1855	9
600	1860	9
601	1862	9
602	1863	9
603	1864	9
604	1865	9
605	1866	9
606	1868	9
607	1869	9
608	1870	9
609	1871	9
610	1872	9
611	1873	9
612	1898	9
613	1902	9
614	1903	9
615	1905	9
616	1906	9
617	1907	9
618	1908	9
619	1910	9
620	1914	9
621	1915	9
622	1917	9
623	1918	9
624	1919	9
625	1920	9
626	1921	9
627	1922	9
628	1923	9
629	1928	9
630	1929	9
631	1932	9
632	1938	9
633	1939	9
634	1940	9
635	1942	9
636	1944	9
637	1945	9
638	1954	9
639	1957	9
640	1959	9
641	1960	9
642	1961	9
643	1962	9
644	1964	9
645	1965	9
646	1966	9
647	1969	9
648	1971	9
649	1972	9
650	1978	9
651	1986	9
652	1987	9
653	1988	9
654	1989	9
655	1991	9
656	1992	9
657	1993	9
658	1999	9
659	2000	9
660	2001	9
661	2002	9
662	2003	9
663	2004	9
664	2005	9
665	2006	9
666	2008	9
667	2009	9
668	2010	9
669	2011	9
670	2012	9
671	2013	9
672	2014	9
673	2015	9
674	2028	9
675	2029	9
676	2030	9
677	2031	9
678	2032	9
679	2033	9
680	2034	9
681	2035	9
682	2044	9
683	2045	9
684	2046	9
685	2047	9
686	2048	9
687	2049	9
688	2050	9
689	2051	9
690	2052	9
691	2053	9
692	2054	9
693	2055	9
694	2056	9
695	2057	9
696	2058	9
697	2059	9
698	2067	9
699	2068	9
700	2069	9
701	2070	9
702	2072	9
703	2079	9
704	2200	9
705	2203	9
706	2208	9
707	2209	9
708	2210	9
709	2213	9
710	2214	9
711	2215	9
712	2217	9
713	2218	9
714	2219	9
715	2222	9
716	2225	9
717	2226	9
718	2227	9
719	2234	9
720	2238	9
721	2240	9
722	2241	9
723	2242	9
724	2243	9
725	2244	9
726	2245	9
727	2246	9
728	2247	9
729	2248	9
730	2251	9
731	2252	9
732	2254	9
733	2256	9
734	2257	9
735	2258	9
736	2259	9
737	2260	9
738	2262	9
739	2263	9
740	2264	9
741	2265	9
742	2266	9
743	2267	9
744	2269	9
745	2270	9
746	2271	9
747	2275	9
748	2276	9
749	2277	9
750	2278	9
751	2280	9
752	2282	9
753	2283	9
754	2284	9
755	2286	9
756	2287	9
757	2288	9
758	2289	9
759	2293	9
760	2296	9
761	2297	9
762	2298	9
763	2301	9
764	2302	9
765	2303	9
766	2304	9
767	2305	9
768	2308	9
769	2309	9
770	2310	9
771	2313	9
772	2318	9
773	2319	9
774	2320	9
775	2323	9
776	2324	9
777	2325	9
778	2326	9
779	2327	9
780	2329	9
781	2330	9
782	2331	9
783	2332	9
784	2333	9
785	2335	9
786	2336	9
787	2338	9
788	2339	9
789	2340	9
790	2341	9
791	2342	9
792	2343	9
793	2344	9
794	2345	9
795	2346	9
796	2347	9
797	2348	9
798	2350	9
799	2351	9
800	2352	9
801	2353	9
802	2354	9
803	2356	9
804	2357	9
805	2358	9
806	2359	9
807	2360	9
808	2361	9
809	2362	9
810	2363	9
811	2364	9
812	2366	9
813	2367	9
814	2368	9
815	2370	9
816	2371	9
817	2372	9
818	2373	9
819	2374	9
820	2375	9
821	2376	9
822	2377	9
823	2378	9
824	2379	9
825	2380	9
826	2381	9
827	2382	9
828	2383	9
829	2384	9
830	2385	9
831	2386	9
832	2387	9
833	2388	9
834	2389	9
835	2390	9
836	2391	9
837	2392	9
838	2393	9
839	2394	9
840	2395	9
841	2396	9
842	2397	9
843	2398	9
844	2399	9
845	2400	9
846	2401	9
847	2402	9
848	2403	9
849	2404	9
850	2405	9
851	2406	9
852	2407	9
853	2409	9
854	2410	9
855	2411	9
856	2412	9
857	2413	9
858	2414	9
859	2416	9
860	2419	9
861	2426	9
862	2427	9
863	2428	9
864	2429	9
865	2434	9
866	2435	9
867	2436	9
868	2437	9
869	2438	9
870	2439	9
871	2440	9
872	2441	9
873	2442	9
874	2443	9
875	2444	9
876	2445	9
877	2447	9
878	2448	9
879	2452	9
880	2453	9
881	2454	9
882	2456	9
883	2457	9
884	2458	9
885	2459	9
886	2460	9
887	2461	9
888	2463	9
889	2464	9
890	2465	9
891	2466	9
892	2467	9
893	2468	9
894	2469	9
895	2475	9
896	2477	9
897	2478	9
898	2481	9
899	2482	9
900	2483	9
901	2484	9
902	2485	9
903	2486	9
904	2491	9
905	2493	9
906	2495	9
907	2496	9
908	2497	9
909	2498	9
910	2502	9
911	2503	9
912	2506	9
913	2507	9
914	2508	9
915	2509	9
916	2511	9
917	2513	9
918	2514	9
919	2517	9
920	2520	9
921	2521	9
922	2524	9
923	2526	9
924	2527	9
925	2528	9
926	2529	9
927	2530	9
928	2531	9
929	2535	9
930	2536	9
931	2538	9
932	2541	9
933	2542	9
934	2545	9
935	2546	9
936	2547	9
937	2553	9
938	2554	9
939	2555	9
940	2556	9
941	2557	9
942	2560	9
943	2561	9
944	2564	9
945	2565	9
946	2571	9
947	2573	9
948	2576	9
949	2577	9
950	2578	9
951	2579	9
952	2580	9
953	2581	9
954	2582	9
955	2583	9
956	2584	9
957	2585	9
958	2586	9
959	2601	9
960	2603	9
961	2604	9
962	2605	9
963	2606	9
964	2607	9
965	2608	9
966	2610	9
967	2612	9
968	2614	9
969	2615	9
970	2616	9
971	2617	9
972	2618	9
973	2619	9
974	2620	9
975	2621	9
976	2622	9
977	2623	9
978	2624	9
979	2626	9
980	2627	9
981	2670	9
982	2672	9
983	2677	9
984	2678	9
985	2679	9
986	2680	9
987	2681	9
988	2682	9
989	2683	9
990	2684	9
991	2685	9
992	2686	9
993	2687	9
994	2691	9
995	2692	9
996	2693	9
997	2698	9
998	2699	9
999	2705	9
1000	2707	9
1001	2708	9
1002	2709	9
1003	2710	9
1004	2711	9
1005	2714	9
1006	2715	9
1007	2717	9
1008	2719	9
1009	2720	9
1010	2721	9
1011	2722	9
1012	2723	9
1013	2724	9
1014	2725	9
1015	2726	9
1016	2728	9
1017	2733	9
1018	2734	9
1019	2735	9
1020	2739	9
1021	2741	9
1022	2749	9
1023	2751	9
1024	2752	9
1025	2758	9
1026	2760	9
1027	2762	9
1028	2764	9
1029	2766	9
1030	2768	9
1031	2770	9
1032	2772	9
1033	2774	9
1034	2776	9
1035	2778	9
1036	2780	9
1037	2782	9
1038	2784	9
1039	2787	9
1040	2789	9
1041	2790	9
1042	2793	9
1043	2794	9
1044	2795	9
1045	2796	9
1046	2797	9
1047	2798	9
1048	2799	9
1049	2800	9
1050	2801	9
1051	2802	9
1052	2803	9
1053	2805	9
1054	2806	9
1055	2809	9
1056	2812	9
1057	2813	9
1058	2815	9
1059	2817	9
1060	2818	9
1061	2819	9
1062	2820	9
1063	2823	9
1064	2826	9
1065	2829	9
1066	2830	9
1067	2834	9
1068	2835	9
1069	2837	9
1070	2838	9
1071	2840	9
1072	2842	9
1073	2844	9
1074	2845	9
1075	2846	9
1076	2850	9
1077	2851	9
1078	2852	9
1079	2858	9
1080	2865	9
1081	2869	9
1082	2870	9
1083	2878	9
1084	2879	9
1085	2880	9
1086	2881	9
1087	2904	9
1088	2905	9
1089	2906	9
1090	2907	9
1091	2920	9
1092	2921	9
1093	2922	9
1094	2923	9
1095	2924	9
1096	2925	9
1097	2926	9
1098	2933	9
1099	2934	9
1100	2935	9
1101	2940	9
1102	2943	9
1103	2945	9
1104	2947	9
1105	2949	9
1106	2950	9
1107	2956	9
1108	2965	9
1109	2967	9
1110	2968	9
1111	2983	9
1112	2984	9
1113	2985	9
1114	2986	9
1115	2987	9
1116	2988	9
1117	2989	9
1118	3021	9
1119	3022	9
1120	3024	9
1121	3028	9
1122	3049	9
1123	3050	9
1124	3051	9
1125	3052	9
1126	3053	9
1127	3054	9
1128	3055	9
1129	3056	9
1130	3064	9
1131	3065	9
1132	3066	9
1133	3076	9
1134	3078	9
1135	3079	9
1136	3084	9
1137	3085	9
1138	3087	9
1139	3088	9
1140	3089	9
1141	3092	9
1142	3093	9
1143	3094	9
1144	3095	9
1145	3096	9
1146	3097	9
1147	3098	9
1148	3099	9
1149	3100	9
1150	3101	9
1151	3102	9
1152	3103	9
1153	3104	9
1154	3105	9
1155	3106	9
1156	3107	9
1157	3108	9
1158	3109	9
1159	3110	9
1160	3111	9
1161	3112	9
1162	3113	9
1163	3114	9
1164	3115	9
1165	3116	9
1166	3117	9
1167	3118	9
1168	3119	9
1169	3120	9
1170	3121	9
1171	3126	9
1172	3127	9
1173	3128	9
1174	3129	9
1175	3130	9
1176	3131	9
1177	3132	9
1178	3133	9
1179	3134	9
1180	3135	9
1181	3137	9
1182	3138	9
1183	3139	9
1184	3147	9
1185	3148	9
1186	3149	9
1187	3150	9
1188	3153	9
1189	3154	9
1190	3161	9
1191	3165	9
1192	3167	9
1193	3170	9
1194	3174	9
1195	3175	9
1196	3176	9
1197	3178	9
1198	3179	9
1199	3180	9
1200	3181	9
1201	3182	9
1202	3183	9
1203	3184	9
1204	3185	9
1205	3186	9
1206	3187	9
1207	3188	9
1208	3189	9
1209	3190	9
1210	3191	9
1211	3192	9
1212	3194	9
1213	3200	9
1214	3203	9
1215	3205	9
1216	3206	9
1217	3207	9
1218	3208	9
1219	3209	9
1220	3210	9
1221	3211	9
1222	3212	9
1223	3213	9
1224	3214	9
1225	3215	9
1226	3216	9
1227	3217	9
1228	3218	9
1229	3219	9
1230	3221	9
1231	3222	9
1232	3223	9
1233	3224	9
1234	3225	9
1235	3226	9
1236	3227	9
1237	3228	9
1238	3229	9
1239	3230	9
1240	3231	9
1241	3232	9
1242	3233	9
1243	3234	9
1244	3235	9
1245	3236	9
1246	3237	9
1247	3238	9
1248	3239	9
1249	3240	9
1250	3242	9
1251	3244	9
1252	3247	9
1253	3248	9
1254	3101	11
1255	3102	11
1256	3111	11
1257	3112	11
1258	1438	13
1259	1439	13
1260	1442	13
1261	1444	13
1262	1445	13
1263	1446	13
1264	1447	13
1265	1448	13
1266	1449	13
1267	1450	13
1268	1451	13
1269	1452	13
1270	1453	13
1271	1454	13
1272	1455	13
1273	1456	13
1274	1457	13
1275	1458	13
1276	1459	13
1277	1461	13
1278	1462	13
1279	1463	13
1280	1465	13
1281	1466	13
1282	1467	13
1283	1469	13
1284	1470	13
1285	1471	13
1286	1472	13
1287	1473	13
1288	1474	13
1289	1475	13
1290	1476	13
1291	1477	13
1292	1479	13
1293	1481	13
1294	1482	13
1295	1483	13
1296	1484	13
1297	1485	13
1298	1486	13
1299	1487	13
1300	1488	13
1301	1489	13
1302	1490	13
1303	1491	13
1304	1492	13
1305	1493	13
1306	1494	13
1307	1495	13
1308	1496	13
1309	1498	13
1310	1499	13
1311	1500	13
1312	1502	13
1313	1503	13
1314	1504	13
1315	1505	13
1316	1506	13
1317	1507	13
1318	1508	13
1319	1509	13
1320	1510	13
1321	1511	13
1322	1512	13
1323	1513	13
1324	1514	13
1325	1515	13
1326	1516	13
1327	1745	13
1328	1746	13
1329	1748	13
1330	1872	13
1331	1873	13
1332	1942	13
1333	2014	13
1334	2015	13
1335	2067	13
1336	2068	13
1337	2069	13
1338	2070	13
1339	2072	13
1340	2208	13
1341	2426	13
1342	2427	13
1343	2428	13
1344	2429	13
1345	2464	13
1346	2465	13
1347	2466	13
1348	2467	13
1349	2468	13
1350	2469	13
1351	2495	13
1352	2547	13
1353	2573	13
1354	2626	13
1355	2627	13
1356	2719	13
1357	2720	13
1358	2721	13
1359	2722	13
1360	2723	13
1361	2724	13
1362	2725	13
1363	2726	13
1364	2728	13
1365	2741	13
1366	2880	13
1367	2984	13
1368	3085	13
1369	3087	13
1370	3098	13
1371	3099	13
1372	3100	13
1373	3121	13
1374	3137	13
1375	3139	13
1376	3149	13
1377	3210	13
1378	3211	13
1379	3212	13
1380	3213	13
1381	3214	13
1382	3215	13
1383	3216	13
1384	3217	13
1385	3218	13
1386	3219	13
1387	3247	13
1388	1005	14
1389	1008	14
1390	1016	14
1391	1017	14
1392	1023	14
1393	1026	14
1394	1040	14
1395	1041	14
1396	1045	14
1397	1048	14
1398	1050	14
1399	1053	14
1400	1062	14
1401	1064	14
1402	1067	14
1403	1069	14
1404	1076	14
1405	1079	14
1406	1581	14
1407	1582	14
1408	1589	14
1409	1612	14
1410	1660	14
1411	1703	14
1412	1705	14
1413	1741	14
1414	1749	14
1415	1859	14
1416	1911	14
1417	1953	14
1418	1955	14
1419	1967	14
1420	1975	14
1421	2186	14
1422	2188	14
1423	2189	14
1424	2190	14
1425	2191	14
1426	2192	14
1427	2194	14
1428	2195	14
1429	2196	14
1430	2197	14
1431	2198	14
1432	2199	14
1433	2202	14
1434	2204	14
1435	2417	14
1436	2418	14
1437	2420	14
1438	2421	14
1439	2451	14
1440	2534	14
1441	2548	14
1442	2600	14
1443	2676	14
1444	2901	14
1445	3057	14
1446	3070	14
1447	3083	14
1448	3160	14
1449	3162	14
1450	3168	14
1451	3169	14
1452	3101	16
1453	3102	16
1454	3111	16
1455	3112	16
1456	1051	17
1457	1092	17
1458	1098	17
1459	1163	17
1460	1182	17
1461	1238	17
1462	1239	17
1463	1244	17
1464	1259	17
1465	1541	17
1466	1553	17
1467	1560	17
1468	1565	17
1469	1570	17
1470	1575	17
1471	1580	17
1472	1595	17
1473	1613	17
1474	1614	17
1475	1626	17
1476	1647	17
1477	1649	17
1478	1670	17
1479	1672	17
1480	1680	17
1481	1689	17
1482	1692	17
1483	1694	17
1484	1698	17
1485	1699	17
1486	1713	17
1487	1889	17
1488	1892	17
1489	1994	17
1490	2249	17
1491	2316	17
1492	2317	17
1493	2334	17
1494	2471	17
1495	2480	17
1496	2558	17
1497	2628	17
1498	2629	17
1499	2630	17
1500	2642	17
1501	2646	17
1502	2740	17
1503	3048	17
1504	3246	17
1505	1052	19
1506	1604	19
1507	1715	19
1508	1716	19
1509	1718	19
1510	1719	19
1511	1722	19
1512	1724	19
1513	1725	19
1514	1726	19
1515	1727	19
1516	1728	19
1517	1729	19
1518	1730	19
1519	1731	19
1520	1732	19
1521	1733	19
1522	1736	19
1523	1739	19
1524	1740	19
1525	1742	19
1526	1743	19
1527	1744	19
1528	1747	19
1529	1752	19
1530	1753	19
1531	1754	19
1532	1755	19
1533	1756	19
1534	1757	19
1535	1758	19
1536	1759	19
1537	1760	19
1538	1761	19
1539	1762	19
1540	1763	19
1541	1764	19
1542	1765	19
1543	1766	19
1544	1767	19
1545	1768	19
1546	1769	19
1547	1770	19
1548	1771	19
1549	1773	19
1550	1774	19
1551	1775	19
1552	1776	19
1553	1777	19
1554	1778	19
1555	1779	19
1556	1780	19
1557	1781	19
1558	1782	19
1559	1783	19
1560	1784	19
1561	1786	19
1562	1787	19
1563	1788	19
1564	1789	19
1565	1790	19
1566	1791	19
1567	1792	19
1568	1793	19
1569	1794	19
1570	1796	19
1571	1798	19
1572	1799	19
1573	1800	19
1574	1801	19
1575	1802	19
1576	1803	19
1577	1804	19
1578	1805	19
1579	1806	19
1580	1807	19
1581	1808	19
1582	1809	19
1583	1810	19
1584	1811	19
1585	1813	19
1586	1814	19
1587	1816	19
1588	1817	19
1589	1818	19
1590	1819	19
1591	1823	19
1592	1824	19
1593	1825	19
1594	1826	19
1595	1827	19
1596	1828	19
1597	1829	19
1598	1830	19
1599	1831	19
1600	1832	19
1601	1833	19
1602	1834	19
1603	1835	19
1604	1836	19
1605	1837	19
1606	1838	19
1607	1839	19
1608	1840	19
1609	1847	19
1610	1848	19
1611	1849	19
1612	1898	19
1613	1902	19
1614	1903	19
1615	1905	19
1616	1906	19
1617	1907	19
1618	1908	19
1619	1910	19
1620	1938	19
1621	1939	19
1622	1940	19
1623	2028	19
1624	2030	19
1625	2031	19
1626	2032	19
1627	2033	19
1628	2079	19
1629	2209	19
1630	2214	19
1631	2215	19
1632	2218	19
1633	2225	19
1634	2226	19
1635	2240	19
1636	2248	19
1637	2258	19
1638	2259	19
1639	2262	19
1640	2264	19
1641	2267	19
1642	2269	19
1643	2276	19
1644	2280	19
1645	2289	19
1646	2305	19
1647	2308	19
1648	2320	19
1649	2326	19
1650	2327	19
1651	2331	19
1652	2357	19
1653	2434	19
1654	2435	19
1655	2437	19
1656	2438	19
1657	2439	19
1658	2440	19
1659	2442	19
1660	2443	19
1661	2444	19
1662	2475	19
1663	2491	19
1664	2496	19
1665	2497	19
1666	2502	19
1667	2503	19
1668	2506	19
1669	2507	19
1670	2508	19
1671	2509	19
1672	2511	19
1673	2513	19
1674	2531	19
1675	2542	19
1676	2564	19
1677	2565	19
1678	2571	19
1679	2576	19
1680	2577	19
1681	2578	19
1682	2579	19
1683	2580	19
1684	2581	19
1685	2582	19
1686	2583	19
1687	2584	19
1688	2585	19
1689	2586	19
1690	2604	19
1691	2619	19
1692	2670	19
1693	2672	19
1694	2677	19
1695	2678	19
1696	2679	19
1697	2680	19
1698	2681	19
1699	2682	19
1700	2683	19
1701	2684	19
1702	2685	19
1703	2691	19
1704	2692	19
1705	2693	19
1706	2698	19
1707	2699	19
1708	2705	19
1709	2734	19
1710	2735	19
1711	2739	19
1712	2751	19
1713	2789	19
1714	2790	19
1715	2794	19
1716	2795	19
1717	2796	19
1718	2797	19
1719	2798	19
1720	2799	19
1721	2800	19
1722	2801	19
1723	2802	19
1724	2803	19
1725	2809	19
1726	2812	19
1727	2815	19
1728	2817	19
1729	2818	19
1730	2819	19
1731	2820	19
1732	2823	19
1733	2826	19
1734	2829	19
1735	2834	19
1736	2837	19
1737	2851	19
1738	2865	19
1739	2869	19
1740	2879	19
1741	2904	19
1742	2905	19
1743	2920	19
1744	2921	19
1745	2922	19
1746	2923	19
1747	2949	19
1748	2967	19
1749	2986	19
1750	2987	19
1751	3028	19
1752	3055	19
1753	3066	19
1754	3084	19
1755	3093	19
1756	3094	19
1757	3095	19
1758	3096	19
1759	3147	19
1760	3244	19
1761	1005	20
1762	1008	20
1763	1016	20
1764	1017	20
1765	1023	20
1766	1026	20
1767	1040	20
1768	1041	20
1769	1045	20
1770	1048	20
1771	1050	20
1772	1053	20
1773	1062	20
1774	1064	20
1775	1067	20
1776	1069	20
1777	1076	20
1778	1079	20
1779	1581	20
1780	1582	20
1781	1589	20
1782	1612	20
1783	1660	20
1784	1703	20
1785	1705	20
1786	1741	20
1787	1749	20
1788	1859	20
1789	1911	20
1790	1953	20
1791	1955	20
1792	1967	20
1793	1975	20
1794	2186	20
1795	2188	20
1796	2189	20
1797	2190	20
1798	2191	20
1799	2192	20
1800	2194	20
1801	2195	20
1802	2196	20
1803	2197	20
1804	2198	20
1805	2199	20
1806	2202	20
1807	2204	20
1808	2417	20
1809	2418	20
1810	2420	20
1811	2421	20
1812	2451	20
1813	2534	20
1814	2548	20
1815	2600	20
1816	2676	20
1817	2901	20
1818	3057	20
1819	3070	20
1820	3083	20
1821	3160	20
1822	3162	20
1823	3168	20
1824	3169	20
1825	3101	22
1826	3102	22
1827	3111	22
1828	3112	22
1829	1051	23
1830	1092	23
1831	1098	23
1832	1163	23
1833	1182	23
1834	1238	23
1835	1239	23
1836	1244	23
1837	1259	23
1838	1541	23
1839	1553	23
1840	1560	23
1841	1565	23
1842	1570	23
1843	1575	23
1844	1580	23
1845	1595	23
1846	1613	23
1847	1614	23
1848	1626	23
1849	1647	23
1850	1649	23
1851	1670	23
1852	1672	23
1853	1680	23
1854	1689	23
1855	1692	23
1856	1694	23
1857	1698	23
1858	1699	23
1859	1713	23
1860	1889	23
1861	1892	23
1862	1994	23
1863	2249	23
1864	2316	23
1865	2317	23
1866	2334	23
1867	2471	23
1868	2480	23
1869	2558	23
1870	2628	23
1871	2629	23
1872	2630	23
1873	2642	23
1874	2646	23
1875	2740	23
1876	3048	23
1877	3246	23
1878	1052	24
1879	1604	24
1880	1715	24
1881	1716	24
1882	1718	24
1883	1719	24
1884	1722	24
1885	1724	24
1886	1725	24
1887	1726	24
1888	1727	24
1889	1728	24
1890	1729	24
1891	1730	24
1892	1731	24
1893	1732	24
1894	1733	24
1895	1736	24
1896	1739	24
1897	1740	24
1898	1742	24
1899	1743	24
1900	1744	24
1901	1747	24
1902	1752	24
1903	1753	24
1904	1754	24
1905	1755	24
1906	1756	24
1907	1757	24
1908	1758	24
1909	1759	24
1910	1760	24
1911	1761	24
1912	1762	24
1913	1763	24
1914	1764	24
1915	1765	24
1916	1766	24
1917	1767	24
1918	1768	24
1919	1769	24
1920	1770	24
1921	1771	24
1922	1773	24
1923	1774	24
1924	1775	24
1925	1776	24
1926	1777	24
1927	1778	24
1928	1779	24
1929	1780	24
1930	1781	24
1931	1782	24
1932	1783	24
1933	1784	24
1934	1786	24
1935	1787	24
1936	1788	24
1937	1789	24
1938	1790	24
1939	1791	24
1940	1792	24
1941	1793	24
1942	1794	24
1943	1796	24
1944	1798	24
1945	1799	24
1946	1800	24
1947	1801	24
1948	1802	24
1949	1803	24
1950	1804	24
1951	1805	24
1952	1806	24
1953	1807	24
1954	1808	24
1955	1809	24
1956	1810	24
1957	1811	24
1958	1813	24
1959	1814	24
1960	1816	24
1961	1817	24
1962	1818	24
1963	1819	24
1964	1823	24
1965	1824	24
1966	1825	24
1967	1826	24
1968	1827	24
1969	1828	24
1970	1829	24
1971	1830	24
1972	1831	24
1973	1832	24
1974	1833	24
1975	1834	24
1976	1835	24
1977	1836	24
1978	1837	24
1979	1838	24
1980	1839	24
1981	1840	24
1982	1847	24
1983	1848	24
1984	1849	24
1985	1898	24
1986	1902	24
1987	1903	24
1988	1905	24
1989	1906	24
1990	1907	24
1991	1908	24
1992	1910	24
1993	1938	24
1994	1939	24
1995	1940	24
1996	2028	24
1997	2030	24
1998	2031	24
1999	2032	24
2000	2033	24
2001	2079	24
2002	2209	24
2003	2214	24
2004	2215	24
2005	2218	24
2006	2225	24
2007	2226	24
2008	2240	24
2009	2248	24
2010	2258	24
2011	2259	24
2012	2262	24
2013	2264	24
2014	2267	24
2015	2269	24
2016	2276	24
2017	2280	24
2018	2289	24
2019	2305	24
2020	2308	24
2021	2320	24
2022	2326	24
2023	2327	24
2024	2331	24
2025	2357	24
2026	2434	24
2027	2435	24
2028	2437	24
2029	2438	24
2030	2439	24
2031	2440	24
2032	2442	24
2033	2443	24
2034	2444	24
2035	2475	24
2036	2491	24
2037	2496	24
2038	2497	24
2039	2502	24
2040	2503	24
2041	2506	24
2042	2507	24
2043	2508	24
2044	2509	24
2045	2511	24
2046	2513	24
2047	2531	24
2048	2542	24
2049	2564	24
2050	2565	24
2051	2571	24
2052	2576	24
2053	2577	24
2054	2578	24
2055	2579	24
2056	2580	24
2057	2581	24
2058	2582	24
2059	2583	24
2060	2584	24
2061	2585	24
2062	2586	24
2063	2604	24
2064	2619	24
2065	2670	24
2066	2672	24
2067	2677	24
2068	2678	24
2069	2679	24
2070	2680	24
2071	2681	24
2072	2682	24
2073	2683	24
2074	2684	24
2075	2685	24
2076	2691	24
2077	2692	24
2078	2693	24
2079	2698	24
2080	2699	24
2081	2705	24
2082	2734	24
2083	2735	24
2084	2739	24
2085	2751	24
2086	2789	24
2087	2790	24
2088	2794	24
2089	2795	24
2090	2796	24
2091	2797	24
2092	2798	24
2093	2799	24
2094	2800	24
2095	2801	24
2096	2802	24
2097	2803	24
2098	2809	24
2099	2812	24
2100	2815	24
2101	2817	24
2102	2818	24
2103	2819	24
2104	2820	24
2105	2823	24
2106	2826	24
2107	2829	24
2108	2834	24
2109	2837	24
2110	2851	24
2111	2865	24
2112	2869	24
2113	2879	24
2114	2904	24
2115	2905	24
2116	2920	24
2117	2921	24
2118	2922	24
2119	2923	24
2120	2949	24
2121	2967	24
2122	2986	24
2123	2987	24
2124	3028	24
2125	3055	24
2126	3066	24
2127	3084	24
2128	3093	24
2129	3094	24
2130	3095	24
2131	3096	24
2132	3147	24
2133	3244	24
2134	1005	25
2135	1008	25
2136	1016	25
2137	1017	25
2138	1023	25
2139	1026	25
2140	1040	25
2141	1041	25
2142	1045	25
2143	1048	25
2144	1050	25
2145	1053	25
2146	1062	25
2147	1064	25
2148	1067	25
2149	1069	25
2150	1076	25
2151	1079	25
2152	1581	25
2153	1582	25
2154	1589	25
2155	1612	25
2156	1660	25
2157	1703	25
2158	1705	25
2159	1741	25
2160	1749	25
2161	1859	25
2162	1911	25
2163	1953	25
2164	1955	25
2165	1967	25
2166	1975	25
2167	2186	25
2168	2188	25
2169	2189	25
2170	2190	25
2171	2191	25
2172	2192	25
2173	2194	25
2174	2195	25
2175	2196	25
2176	2197	25
2177	2198	25
2178	2199	25
2179	2202	25
2180	2204	25
2181	2417	25
2182	2418	25
2183	2420	25
2184	2421	25
2185	2451	25
2186	2534	25
2187	2548	25
2188	2600	25
2189	2676	25
2190	2901	25
2191	3057	25
2192	3070	25
2193	3083	25
2194	3160	25
2195	3162	25
2196	3168	25
2197	3169	25
2198	3101	27
2199	3102	27
2200	3111	27
2201	3112	27
2202	1051	28
2203	1092	28
2204	1098	28
2205	1163	28
2206	1182	28
2207	1238	28
2208	1239	28
2209	1244	28
2210	1259	28
2211	1541	28
2212	1553	28
2213	1560	28
2214	1565	28
2215	1570	28
2216	1575	28
2217	1580	28
2218	1595	28
2219	1613	28
2220	1614	28
2221	1626	28
2222	1647	28
2223	1649	28
2224	1670	28
2225	1672	28
2226	1680	28
2227	1689	28
2228	1692	28
2229	1694	28
2230	1698	28
2231	1699	28
2232	1713	28
2233	1889	28
2234	1892	28
2235	1994	28
2236	2249	28
2237	2316	28
2238	2317	28
2239	2334	28
2240	2471	28
2241	2480	28
2242	2558	28
2243	2628	28
2244	2629	28
2245	2630	28
2246	2642	28
2247	2646	28
2248	2740	28
2249	3048	28
2250	3246	28
2251	1052	30
2252	1604	30
2253	1715	30
2254	1716	30
2255	1718	30
2256	1719	30
2257	1722	30
2258	1724	30
2259	1725	30
2260	1726	30
2261	1727	30
2262	1728	30
2263	1729	30
2264	1730	30
2265	1731	30
2266	1732	30
2267	1733	30
2268	1736	30
2269	1739	30
2270	1740	30
2271	1742	30
2272	1743	30
2273	1744	30
2274	1747	30
2275	1752	30
2276	1753	30
2277	1754	30
2278	1755	30
2279	1756	30
2280	1757	30
2281	1758	30
2282	1759	30
2283	1760	30
2284	1761	30
2285	1762	30
2286	1763	30
2287	1764	30
2288	1765	30
2289	1766	30
2290	1767	30
2291	1768	30
2292	1769	30
2293	1770	30
2294	1771	30
2295	1773	30
2296	1774	30
2297	1775	30
2298	1776	30
2299	1777	30
2300	1778	30
2301	1779	30
2302	1780	30
2303	1781	30
2304	1782	30
2305	1783	30
2306	1784	30
2307	1786	30
2308	1787	30
2309	1788	30
2310	1789	30
2311	1790	30
2312	1791	30
2313	1792	30
2314	1793	30
2315	1794	30
2316	1796	30
2317	1798	30
2318	1799	30
2319	1800	30
2320	1801	30
2321	1802	30
2322	1803	30
2323	1804	30
2324	1805	30
2325	1806	30
2326	1807	30
2327	1808	30
2328	1809	30
2329	1810	30
2330	1811	30
2331	1813	30
2332	1814	30
2333	1816	30
2334	1817	30
2335	1818	30
2336	1819	30
2337	1823	30
2338	1824	30
2339	1825	30
2340	1826	30
2341	1827	30
2342	1828	30
2343	1829	30
2344	1830	30
2345	1831	30
2346	1832	30
2347	1833	30
2348	1834	30
2349	1835	30
2350	1836	30
2351	1837	30
2352	1838	30
2353	1839	30
2354	1840	30
2355	1847	30
2356	1848	30
2357	1849	30
2358	1898	30
2359	1902	30
2360	1903	30
2361	1905	30
2362	1906	30
2363	1907	30
2364	1908	30
2365	1910	30
2366	1938	30
2367	1939	30
2368	1940	30
2369	2028	30
2370	2030	30
2371	2031	30
2372	2032	30
2373	2033	30
2374	2079	30
2375	2209	30
2376	2214	30
2377	2215	30
2378	2218	30
2379	2225	30
2380	2226	30
2381	2240	30
2382	2248	30
2383	2258	30
2384	2259	30
2385	2262	30
2386	2264	30
2387	2267	30
2388	2269	30
2389	2276	30
2390	2280	30
2391	2289	30
2392	2305	30
2393	2308	30
2394	2320	30
2395	2326	30
2396	2327	30
2397	2331	30
2398	2357	30
2399	2434	30
2400	2435	30
2401	2437	30
2402	2438	30
2403	2439	30
2404	2440	30
2405	2442	30
2406	2443	30
2407	2444	30
2408	2475	30
2409	2491	30
2410	2496	30
2411	2497	30
2412	2502	30
2413	2503	30
2414	2506	30
2415	2507	30
2416	2508	30
2417	2509	30
2418	2511	30
2419	2513	30
2420	2531	30
2421	2542	30
2422	2564	30
2423	2565	30
2424	2571	30
2425	2576	30
2426	2577	30
2427	2578	30
2428	2579	30
2429	2580	30
2430	2581	30
2431	2582	30
2432	2583	30
2433	2584	30
2434	2585	30
2435	2586	30
2436	2604	30
2437	2619	30
2438	2670	30
2439	2672	30
2440	2677	30
2441	2678	30
2442	2679	30
2443	2680	30
2444	2681	30
2445	2682	30
2446	2683	30
2447	2684	30
2448	2685	30
2449	2691	30
2450	2692	30
2451	2693	30
2452	2698	30
2453	2699	30
2454	2705	30
2455	2734	30
2456	2735	30
2457	2739	30
2458	2751	30
2459	2789	30
2460	2790	30
2461	2794	30
2462	2795	30
2463	2796	30
2464	2797	30
2465	2798	30
2466	2799	30
2467	2800	30
2468	2801	30
2469	2802	30
2470	2803	30
2471	2809	30
2472	2812	30
2473	2815	30
2474	2817	30
2475	2818	30
2476	2819	30
2477	2820	30
2478	2823	30
2479	2826	30
2480	2829	30
2481	2834	30
2482	2837	30
2483	2851	30
2484	2865	30
2485	2869	30
2486	2879	30
2487	2904	30
2488	2905	30
2489	2920	30
2490	2921	30
2491	2922	30
2492	2923	30
2493	2949	30
2494	2967	30
2495	2986	30
2496	2987	30
2497	3028	30
2498	3055	30
2499	3066	30
2500	3084	30
2501	3093	30
2502	3094	30
2503	3095	30
2504	3096	30
2505	3147	30
2506	3244	30
2507	1005	31
2508	1008	31
2509	1016	31
2510	1017	31
2511	1023	31
2512	1026	31
2513	1040	31
2514	1041	31
2515	1045	31
2516	1048	31
2517	1050	31
2518	1053	31
2519	1062	31
2520	1064	31
2521	1067	31
2522	1069	31
2523	1076	31
2524	1079	31
2525	1581	31
2526	1582	31
2527	1589	31
2528	1612	31
2529	1660	31
2530	1703	31
2531	1705	31
2532	1741	31
2533	1749	31
2534	1859	31
2535	1911	31
2536	1953	31
2537	1955	31
2538	1967	31
2539	1975	31
2540	2186	31
2541	2188	31
2542	2189	31
2543	2190	31
2544	2191	31
2545	2192	31
2546	2194	31
2547	2195	31
2548	2196	31
2549	2197	31
2550	2198	31
2551	2199	31
2552	2202	31
2553	2204	31
2554	2417	31
2555	2418	31
2556	2420	31
2557	2421	31
2558	2451	31
2559	2534	31
2560	2548	31
2561	2600	31
2562	2676	31
2563	2901	31
2564	3057	31
2565	3070	31
2566	3083	31
2567	3160	31
2568	3162	31
2569	3168	31
2570	3169	31
2571	3101	33
2572	3102	33
2573	3111	33
2574	3112	33
2575	1051	34
2576	1092	34
2577	1098	34
2578	1163	34
2579	1182	34
2580	1238	34
2581	1239	34
2582	1244	34
2583	1259	34
2584	1541	34
2585	1553	34
2586	1560	34
2587	1565	34
2588	1570	34
2589	1575	34
2590	1580	34
2591	1595	34
2592	1613	34
2593	1614	34
2594	1626	34
2595	1647	34
2596	1649	34
2597	1670	34
2598	1672	34
2599	1680	34
2600	1689	34
2601	1692	34
2602	1694	34
2603	1698	34
2604	1699	34
2605	1713	34
2606	1889	34
2607	1892	34
2608	1994	34
2609	2249	34
2610	2316	34
2611	2317	34
2612	2334	34
2613	2471	34
2614	2480	34
2615	2558	34
2616	2628	34
2617	2629	34
2618	2630	34
2619	2642	34
2620	2646	34
2621	2740	34
2622	3048	34
2623	3246	34
2624	1052	36
2625	1088	36
2626	1089	36
2627	1090	36
2628	1091	36
2629	1093	36
2630	1099	36
2631	1100	36
2632	1104	36
2633	1105	36
2634	1106	36
2635	1107	36
2636	1108	36
2637	1109	36
2638	1110	36
2639	1111	36
2640	1112	36
2641	1113	36
2642	1114	36
2643	1118	36
2644	1120	36
2645	1123	36
2646	1125	36
2647	1126	36
2648	1127	36
2649	1128	36
2650	1129	36
2651	1130	36
2652	1131	36
2653	1133	36
2654	1134	36
2655	1136	36
2656	1139	36
2657	1143	36
2658	1144	36
2659	1145	36
2660	1146	36
2661	1147	36
2662	1148	36
2663	1149	36
2664	1150	36
2665	1152	36
2666	1153	36
2667	1154	36
2668	1155	36
2669	1156	36
2670	1157	36
2671	1158	36
2672	1159	36
2673	1160	36
2674	1161	36
2675	1162	36
2676	1164	36
2677	1165	36
2678	1166	36
2679	1167	36
2680	1169	36
2681	1170	36
2682	1171	36
2683	1172	36
2684	1173	36
2685	1175	36
2686	1176	36
2687	1177	36
2688	1178	36
2689	1179	36
2690	1180	36
2691	1184	36
2692	1188	36
2693	1189	36
2694	1190	36
2695	1191	36
2696	1192	36
2697	1193	36
2698	1194	36
2699	1195	36
2700	1196	36
2701	1197	36
2702	1198	36
2703	1199	36
2704	1201	36
2705	1202	36
2706	1203	36
2707	1204	36
2708	1206	36
2709	1207	36
2710	1208	36
2711	1210	36
2712	1212	36
2713	1213	36
2714	1214	36
2715	1216	36
2716	1218	36
2717	1219	36
2718	1220	36
2719	1221	36
2720	1222	36
2721	1223	36
2722	1224	36
2723	1228	36
2724	1229	36
2725	1230	36
2726	1231	36
2727	1233	36
2728	1234	36
2729	1235	36
2730	1237	36
2731	1243	36
2732	1245	36
2733	1246	36
2734	1247	36
2735	1248	36
2736	1249	36
2737	1250	36
2738	1251	36
2739	1255	36
2740	1256	36
2741	1257	36
2742	1261	36
2743	1262	36
2744	1263	36
2745	1264	36
2746	1265	36
2747	1266	36
2748	1267	36
2749	1268	36
2750	1270	36
2751	1271	36
2752	1272	36
2753	1274	36
2754	1275	36
2755	1276	36
2756	1277	36
2757	1278	36
2758	1279	36
2759	1280	36
2760	1281	36
2761	1282	36
2762	1286	36
2763	1287	36
2764	1288	36
2765	1289	36
2766	1292	36
2767	1293	36
2768	1294	36
2769	1296	36
2770	1297	36
2771	1298	36
2772	1299	36
2773	1300	36
2774	1301	36
2775	1302	36
2776	1303	36
2777	1304	36
2778	1305	36
2779	1306	36
2780	1307	36
2781	1308	36
2782	1604	36
2783	1648	36
2784	1715	36
2785	1716	36
2786	1717	36
2787	1718	36
2788	1719	36
2789	1722	36
2790	1723	36
2791	1724	36
2792	1725	36
2793	1726	36
2794	1727	36
2795	1728	36
2796	1729	36
2797	1730	36
2798	1731	36
2799	1732	36
2800	1733	36
2801	1736	36
2802	1739	36
2803	1740	36
2804	1742	36
2805	1743	36
2806	1744	36
2807	1747	36
2808	1752	36
2809	1753	36
2810	1754	36
2811	1755	36
2812	1756	36
2813	1757	36
2814	1758	36
2815	1759	36
2816	1760	36
2817	1761	36
2818	1762	36
2819	1763	36
2820	1764	36
2821	1765	36
2822	1766	36
2823	1767	36
2824	1768	36
2825	1769	36
2826	1770	36
2827	1771	36
2828	1773	36
2829	1774	36
2830	1775	36
2831	1776	36
2832	1777	36
2833	1778	36
2834	1779	36
2835	1780	36
2836	1781	36
2837	1782	36
2838	1783	36
2839	1784	36
2840	1786	36
2841	1787	36
2842	1788	36
2843	1789	36
2844	1790	36
2845	1791	36
2846	1792	36
2847	1793	36
2848	1794	36
2849	1796	36
2850	1798	36
2851	1799	36
2852	1800	36
2853	1801	36
2854	1802	36
2855	1803	36
2856	1804	36
2857	1805	36
2858	1806	36
2859	1807	36
2860	1808	36
2861	1809	36
2862	1810	36
2863	1811	36
2864	1813	36
2865	1814	36
2866	1815	36
2867	1816	36
2868	1817	36
2869	1818	36
2870	1819	36
2871	1823	36
2872	1824	36
2873	1825	36
2874	1826	36
2875	1827	36
2876	1828	36
2877	1829	36
2878	1830	36
2879	1831	36
2880	1832	36
2881	1833	36
2882	1834	36
2883	1835	36
2884	1836	36
2885	1837	36
2886	1838	36
2887	1839	36
2888	1840	36
2889	1847	36
2890	1848	36
2891	1849	36
2892	1862	36
2893	1863	36
2894	1864	36
2895	1865	36
2896	1866	36
2897	1898	36
2898	1902	36
2899	1903	36
2900	1905	36
2901	1906	36
2902	1907	36
2903	1908	36
2904	1910	36
2905	1914	36
2906	1915	36
2907	1917	36
2908	1918	36
2909	1919	36
2910	1920	36
2911	1921	36
2912	1922	36
2913	1938	36
2914	1939	36
2915	1940	36
2916	1986	36
2917	1987	36
2918	1988	36
2919	1989	36
2920	1991	36
2921	1992	36
2922	1993	36
2923	1999	36
2924	2028	36
2925	2029	36
2926	2030	36
2927	2031	36
2928	2032	36
2929	2033	36
2930	2045	36
2931	2046	36
2932	2047	36
2933	2048	36
2934	2049	36
2935	2050	36
2936	2051	36
2937	2052	36
2938	2053	36
2939	2054	36
2940	2055	36
2941	2056	36
2942	2057	36
2943	2058	36
2944	2059	36
2945	2079	36
2946	2209	36
2947	2214	36
2948	2215	36
2949	2218	36
2950	2219	36
2951	2222	36
2952	2225	36
2953	2226	36
2954	2227	36
2955	2234	36
2956	2238	36
2957	2240	36
2958	2241	36
2959	2242	36
2960	2243	36
2961	2244	36
2962	2245	36
2963	2246	36
2964	2247	36
2965	2248	36
2966	2251	36
2967	2252	36
2968	2256	36
2969	2258	36
2970	2259	36
2971	2260	36
2972	2262	36
2973	2263	36
2974	2264	36
2975	2265	36
2976	2266	36
2977	2267	36
2978	2269	36
2979	2270	36
2980	2271	36
2981	2275	36
2982	2276	36
2983	2277	36
2984	2278	36
2985	2280	36
2986	2282	36
2987	2283	36
2988	2284	36
2989	2286	36
2990	2287	36
2991	2288	36
2992	2289	36
2993	2293	36
2994	2296	36
2995	2297	36
2996	2298	36
2997	2301	36
2998	2302	36
2999	2303	36
3000	2305	36
3001	2308	36
3002	2309	36
3003	2310	36
3004	2313	36
3005	2319	36
3006	2320	36
3007	2323	36
3008	2324	36
3009	2325	36
3010	2326	36
3011	2327	36
3012	2329	36
3013	2330	36
3014	2331	36
3015	2332	36
3016	2333	36
3017	2335	36
3018	2336	36
3019	2338	36
3020	2339	36
3021	2340	36
3022	2341	36
3023	2342	36
3024	2343	36
3025	2344	36
3026	2345	36
3027	2346	36
3028	2347	36
3029	2348	36
3030	2350	36
3031	2351	36
3032	2352	36
3033	2353	36
3034	2354	36
3035	2356	36
3036	2357	36
3037	2358	36
3038	2359	36
3039	2360	36
3040	2361	36
3041	2362	36
3042	2363	36
3043	2364	36
3044	2366	36
3045	2367	36
3046	2368	36
3047	2370	36
3048	2371	36
3049	2372	36
3050	2373	36
3051	2374	36
3052	2375	36
3053	2376	36
3054	2377	36
3055	2378	36
3056	2379	36
3057	2380	36
3058	2381	36
3059	2382	36
3060	2383	36
3061	2384	36
3062	2385	36
3063	2386	36
3064	2387	36
3065	2388	36
3066	2389	36
3067	2390	36
3068	2391	36
3069	2392	36
3070	2393	36
3071	2394	36
3072	2395	36
3073	2396	36
3074	2397	36
3075	2398	36
3076	2399	36
3077	2400	36
3078	2401	36
3079	2402	36
3080	2403	36
3081	2404	36
3082	2405	36
3083	2406	36
3084	2407	36
3085	2409	36
3086	2410	36
3087	2411	36
3088	2412	36
3089	2413	36
3090	2414	36
3091	2416	36
3092	2434	36
3093	2435	36
3094	2436	36
3095	2437	36
3096	2438	36
3097	2439	36
3098	2440	36
3099	2442	36
3100	2443	36
3101	2444	36
3102	2456	36
3103	2457	36
3104	2458	36
3105	2459	36
3106	2460	36
3107	2461	36
3108	2475	36
3109	2477	36
3110	2478	36
3111	2481	36
3112	2482	36
3113	2483	36
3114	2484	36
3115	2485	36
3116	2486	36
3117	2491	36
3118	2493	36
3119	2496	36
3120	2497	36
3121	2498	36
3122	2502	36
3123	2503	36
3124	2506	36
3125	2507	36
3126	2508	36
3127	2509	36
3128	2511	36
3129	2513	36
3130	2514	36
3131	2520	36
3132	2521	36
3133	2524	36
3134	2526	36
3135	2527	36
3136	2528	36
3137	2529	36
3138	2530	36
3139	2531	36
3140	2535	36
3141	2536	36
3142	2541	36
3143	2542	36
3144	2553	36
3145	2554	36
3146	2560	36
3147	2561	36
3148	2564	36
3149	2565	36
3150	2571	36
3151	2576	36
3152	2577	36
3153	2578	36
3154	2579	36
3155	2580	36
3156	2581	36
3157	2582	36
3158	2583	36
3159	2584	36
3160	2585	36
3161	2586	36
3162	2603	36
3163	2604	36
3164	2605	36
3165	2606	36
3166	2607	36
3167	2608	36
3168	2610	36
3169	2612	36
3170	2614	36
3171	2615	36
3172	2616	36
3173	2617	36
3174	2618	36
3175	2619	36
3176	2620	36
3177	2621	36
3178	2622	36
3179	2670	36
3180	2672	36
3181	2677	36
3182	2678	36
3183	2679	36
3184	2680	36
3185	2681	36
3186	2682	36
3187	2683	36
3188	2684	36
3189	2685	36
3190	2686	36
3191	2691	36
3192	2692	36
3193	2693	36
3194	2698	36
3195	2699	36
3196	2705	36
3197	2707	36
3198	2708	36
3199	2709	36
3200	2710	36
3201	2711	36
3202	2733	36
3203	2734	36
3204	2735	36
3205	2739	36
3206	2749	36
3207	2751	36
3208	2752	36
3209	2758	36
3210	2760	36
3211	2762	36
3212	2764	36
3213	2766	36
3214	2768	36
3215	2770	36
3216	2772	36
3217	2774	36
3218	2776	36
3219	2778	36
3220	2780	36
3221	2782	36
3222	2784	36
3223	2787	36
3224	2789	36
3225	2790	36
3226	2794	36
3227	2795	36
3228	2796	36
3229	2797	36
3230	2798	36
3231	2799	36
3232	2800	36
3233	2801	36
3234	2802	36
3235	2803	36
3236	2809	36
3237	2812	36
3238	2815	36
3239	2817	36
3240	2818	36
3241	2819	36
3242	2820	36
3243	2823	36
3244	2826	36
3245	2829	36
3246	2834	36
3247	2837	36
3248	2838	36
3249	2840	36
3250	2842	36
3251	2850	36
3252	2851	36
3253	2865	36
3254	2869	36
3255	2879	36
3256	2904	36
3257	2905	36
3258	2906	36
3259	2920	36
3260	2921	36
3261	2922	36
3262	2923	36
3263	2924	36
3264	2933	36
3265	2934	36
3266	2935	36
3267	2943	36
3268	2945	36
3269	2947	36
3270	2949	36
3271	2967	36
3272	2983	36
3273	2985	36
3274	2986	36
3275	2987	36
3276	3021	36
3277	3022	36
3278	3024	36
3279	3028	36
3280	3054	36
3281	3055	36
3282	3056	36
3283	3064	36
3284	3065	36
3285	3066	36
3286	3079	36
3287	3084	36
3288	3092	36
3289	3093	36
3290	3094	36
3291	3095	36
3292	3096	36
3293	3147	36
3294	3165	36
3295	3244	36
3296	3248	36
3297	1008	37
3298	1016	37
3299	1017	37
3300	1023	37
3301	1026	37
3302	1040	37
3303	1041	37
3304	1045	37
3305	1048	37
3306	1050	37
3307	1053	37
3308	1062	37
3309	1064	37
3310	1067	37
3311	1069	37
3312	1076	37
3313	1079	37
3314	1581	37
3315	1582	37
3316	1589	37
3317	1612	37
3318	1660	37
3319	1703	37
3320	1705	37
3321	1741	37
3322	1749	37
3323	1859	37
3324	1911	37
3325	1953	37
3326	1955	37
3327	1967	37
3328	1975	37
3329	2186	37
3330	2188	37
3331	2189	37
3332	2190	37
3333	2191	37
3334	2192	37
3335	2194	37
3336	2195	37
3337	2196	37
3338	2197	37
3339	2198	37
3340	2199	37
3341	2202	37
3342	2204	37
3343	2417	37
3344	2418	37
3345	2420	37
3346	2421	37
3347	2451	37
3348	2534	37
3349	2548	37
3350	2600	37
3351	2676	37
3352	2901	37
3353	3057	37
3354	3070	37
3355	3083	37
3356	3160	37
3357	3162	37
3358	3168	37
3359	3169	37
3360	3101	39
3361	3102	39
3362	3111	39
3363	3112	39
3364	1051	40
3365	1092	40
3366	1098	40
3367	1163	40
3368	1182	40
3369	1238	40
3370	1239	40
3371	1244	40
3372	1259	40
3373	1541	40
3374	1553	40
3375	1560	40
3376	1565	40
3377	1570	40
3378	1575	40
3379	1580	40
3380	1595	40
3381	1613	40
3382	1614	40
3383	1626	40
3384	1647	40
3385	1649	40
3386	1670	40
3387	1672	40
3388	1680	40
3389	1689	40
3390	1692	40
3391	1694	40
3392	1698	40
3393	1699	40
3394	1713	40
3395	1889	40
3396	1892	40
3397	1994	40
3398	2249	40
3399	2316	40
3400	2317	40
3401	2334	40
3402	2471	40
3403	2480	40
3404	2558	40
3405	2628	40
3406	2629	40
3407	2630	40
3408	2642	40
3409	2646	40
3410	2740	40
3411	3048	40
3412	3246	40
3413	1052	42
3414	1604	42
3415	1715	42
3416	1716	42
3417	1718	42
3418	1719	42
3419	1722	42
3420	1724	42
3421	1725	42
3422	1726	42
3423	1727	42
3424	1728	42
3425	1729	42
3426	1730	42
3427	1731	42
3428	1732	42
3429	1733	42
3430	1736	42
3431	1739	42
3432	1740	42
3433	1742	42
3434	1743	42
3435	1744	42
3436	1747	42
3437	1752	42
3438	1753	42
3439	1754	42
3440	1755	42
3441	1756	42
3442	1757	42
3443	1758	42
3444	1759	42
3445	1760	42
3446	1761	42
3447	1762	42
3448	1763	42
3449	1764	42
3450	1765	42
3451	1766	42
3452	1767	42
3453	1768	42
3454	1769	42
3455	1770	42
3456	1771	42
3457	1773	42
3458	1774	42
3459	1775	42
3460	1776	42
3461	1777	42
3462	1778	42
3463	1779	42
3464	1780	42
3465	1781	42
3466	1782	42
3467	1783	42
3468	1784	42
3469	1786	42
3470	1787	42
3471	1788	42
3472	1789	42
3473	1790	42
3474	1791	42
3475	1792	42
3476	1793	42
3477	1794	42
3478	1796	42
3479	1798	42
3480	1799	42
3481	1800	42
3482	1801	42
3483	1802	42
3484	1803	42
3485	1804	42
3486	1805	42
3487	1806	42
3488	1807	42
3489	1808	42
3490	1809	42
3491	1810	42
3492	1811	42
3493	1813	42
3494	1814	42
3495	1816	42
3496	1817	42
3497	1818	42
3498	1819	42
3499	1823	42
3500	1824	42
3501	1825	42
3502	1826	42
3503	1827	42
3504	1828	42
3505	1829	42
3506	1830	42
3507	1831	42
3508	1832	42
3509	1833	42
3510	1834	42
3511	1835	42
3512	1836	42
3513	1837	42
3514	1838	42
3515	1839	42
3516	1840	42
3517	1847	42
3518	1848	42
3519	1849	42
3520	1898	42
3521	1902	42
3522	1903	42
3523	1905	42
3524	1906	42
3525	1907	42
3526	1908	42
3527	1910	42
3528	1938	42
3529	1939	42
3530	1940	42
3531	2028	42
3532	2030	42
3533	2031	42
3534	2032	42
3535	2033	42
3536	2079	42
3537	2209	42
3538	2214	42
3539	2215	42
3540	2218	42
3541	2225	42
3542	2226	42
3543	2240	42
3544	2248	42
3545	2258	42
3546	2259	42
3547	2262	42
3548	2264	42
3549	2267	42
3550	2269	42
3551	2276	42
3552	2280	42
3553	2289	42
3554	2305	42
3555	2308	42
3556	2320	42
3557	2326	42
3558	2327	42
3559	2331	42
3560	2357	42
3561	2434	42
3562	2435	42
3563	2437	42
3564	2438	42
3565	2439	42
3566	2440	42
3567	2442	42
3568	2443	42
3569	2444	42
3570	2475	42
3571	2491	42
3572	2496	42
3573	2497	42
3574	2502	42
3575	2503	42
3576	2506	42
3577	2507	42
3578	2508	42
3579	2509	42
3580	2511	42
3581	2513	42
3582	2531	42
3583	2542	42
3584	2564	42
3585	2565	42
3586	2571	42
3587	2576	42
3588	2577	42
3589	2578	42
3590	2579	42
3591	2580	42
3592	2581	42
3593	2582	42
3594	2583	42
3595	2584	42
3596	2585	42
3597	2586	42
3598	2604	42
3599	2619	42
3600	2670	42
3601	2672	42
3602	2677	42
3603	2678	42
3604	2679	42
3605	2680	42
3606	2681	42
3607	2682	42
3608	2683	42
3609	2684	42
3610	2685	42
3611	2691	42
3612	2692	42
3613	2693	42
3614	2698	42
3615	2699	42
3616	2705	42
3617	2734	42
3618	2735	42
3619	2739	42
3620	2751	42
3621	2789	42
3622	2790	42
3623	2794	42
3624	2795	42
3625	2796	42
3626	2797	42
3627	2798	42
3628	2799	42
3629	2800	42
3630	2801	42
3631	2802	42
3632	2803	42
3633	2809	42
3634	2812	42
3635	2815	42
3636	2817	42
3637	2818	42
3638	2819	42
3639	2820	42
3640	2823	42
3641	2826	42
3642	2829	42
3643	2834	42
3644	2837	42
3645	2851	42
3646	2865	42
3647	2869	42
3648	2879	42
3649	2904	42
3650	2905	42
3651	2920	42
3652	2921	42
3653	2922	42
3654	2923	42
3655	2949	42
3656	2967	42
3657	2986	42
3658	2987	42
3659	3028	42
3660	3055	42
3661	3066	42
3662	3084	42
3663	3093	42
3664	3094	42
3665	3095	42
3666	3096	42
3667	3147	42
3668	3244	42
3669	1005	43
3670	1008	43
3671	1016	43
3672	1017	43
3673	1023	43
3674	1026	43
3675	1040	43
3676	1041	43
3677	1045	43
3678	1048	43
3679	1050	43
3680	1053	43
3681	1062	43
3682	1064	43
3683	1067	43
3684	1069	43
3685	1076	43
3686	1079	43
3687	1581	43
3688	1582	43
3689	1589	43
3690	1612	43
3691	1660	43
3692	1703	43
3693	1705	43
3694	1741	43
3695	1749	43
3696	1859	43
3697	1911	43
3698	1953	43
3699	1955	43
3700	1967	43
3701	1975	43
3702	2186	43
3703	2188	43
3704	2189	43
3705	2190	43
3706	2191	43
3707	2192	43
3708	2194	43
3709	2195	43
3710	2196	43
3711	2197	43
3712	2198	43
3713	2199	43
3714	2202	43
3715	2204	43
3716	2417	43
3717	2418	43
3718	2420	43
3719	2421	43
3720	2451	43
3721	2534	43
3722	2548	43
3723	2600	43
3724	2676	43
3725	2901	43
3726	3057	43
3727	3070	43
3728	3083	43
3729	3160	43
3730	3162	43
3731	3168	43
3732	3169	43
3733	3101	45
3734	3102	45
3735	3111	45
3736	3112	45
3737	1051	46
3738	1092	46
3739	1098	46
3740	1163	46
3741	1182	46
3742	1238	46
3743	1239	46
3744	1244	46
3745	1259	46
3746	1541	46
3747	1553	46
3748	1560	46
3749	1565	46
3750	1570	46
3751	1575	46
3752	1580	46
3753	1595	46
3754	1613	46
3755	1614	46
3756	1626	46
3757	1647	46
3758	1649	46
3759	1670	46
3760	1672	46
3761	1680	46
3762	1689	46
3763	1692	46
3764	1694	46
3765	1698	46
3766	1699	46
3767	1713	46
3768	1889	46
3769	1892	46
3770	1994	46
3771	2249	46
3772	2316	46
3773	2317	46
3774	2334	46
3775	2471	46
3776	2480	46
3777	2558	46
3778	2628	46
3779	2629	46
3780	2630	46
3781	2642	46
3782	2646	46
3783	2740	46
3784	3048	46
3785	3246	46
3786	3101	48
3787	3102	48
3788	3111	48
3789	3112	48
3790	1052	49
3791	1089	49
3792	1093	49
3793	1099	49
3794	1100	49
3795	1108	49
3796	1131	49
3797	1144	49
3798	1155	49
3799	1162	49
3800	1164	49
3801	1183	49
3802	1194	49
3803	1196	49
3804	1218	49
3805	1221	49
3806	1242	49
3807	1243	49
3808	1250	49
3809	1265	49
3810	1280	49
3811	1295	49
3812	1298	49
3813	1302	49
3814	1303	49
3815	1310	49
3816	1320	49
3817	1321	49
3818	1322	49
3819	1336	49
3820	1337	49
3821	1344	49
3822	1348	49
3823	1349	49
3824	1354	49
3825	1355	49
3826	1356	49
3827	1357	49
3828	1360	49
3829	1366	49
3830	1370	49
3831	1380	49
3832	1381	49
3833	1383	49
3834	1389	49
3835	1391	49
3836	1392	49
3837	1397	49
3838	1404	49
3839	1407	49
3840	1410	49
3841	1411	49
3842	1413	49
3843	1414	49
3844	1419	49
3845	1420	49
3846	1421	49
3847	1422	49
3848	1423	49
3849	1426	49
3850	1427	49
3851	1428	49
3852	1432	49
3853	1433	49
3854	1491	49
3855	1504	49
3856	1510	49
3857	1517	49
3858	1571	49
3859	1714	49
3860	1722	49
3861	1723	49
3862	1739	49
3863	1744	49
3864	1745	49
3865	1746	49
3866	1754	49
3867	1758	49
3868	1777	49
3869	1786	49
3870	1798	49
3871	1828	49
3872	1829	49
3873	1831	49
3874	1834	49
3875	1836	49
3876	1854	49
3877	1855	49
3878	1870	49
3879	1873	49
3880	1905	49
3881	1921	49
3882	1928	49
3883	1991	49
3884	2003	49
3885	2005	49
3886	2010	49
3887	2011	49
3888	2012	49
3889	2013	49
3890	2015	49
3891	2029	49
3892	2032	49
3893	2240	49
3894	2257	49
3895	2336	49
3896	2356	49
3897	2363	49
3898	2371	49
3899	2382	49
3900	2441	49
3901	2444	49
3902	2445	49
3903	2447	49
3904	2456	49
3905	2459	49
3906	2463	49
3907	2466	49
3908	2481	49
3909	2483	49
3910	2484	49
3911	2495	49
3912	2547	49
3913	2561	49
3914	2604	49
3915	2605	49
3916	2692	49
3917	2699	49
3918	2749	49
3919	2806	49
3920	2845	49
3921	2846	49
3922	2852	49
3923	2870	49
3924	2879	49
3925	2965	49
3926	2983	49
3927	2988	49
3928	3049	49
3929	3050	49
3930	3051	49
3931	3052	49
3932	3053	49
3933	3076	49
3934	3079	49
3935	3137	49
3936	3165	49
3937	3194	49
3938	3200	49
3939	3203	49
3940	3101	52
3941	3102	52
3942	3111	52
3943	3112	52
3944	1183	54
3945	1242	54
3946	1295	54
3947	1309	54
3948	1310	54
3949	1312	54
3950	1313	54
3951	1314	54
3952	1318	54
3953	1320	54
3954	1321	54
3955	1322	54
3956	1323	54
3957	1324	54
3958	1325	54
3959	1326	54
3960	1327	54
3961	1328	54
3962	1330	54
3963	1331	54
3964	1332	54
3965	1333	54
3966	1334	54
3967	1336	54
3968	1337	54
3969	1338	54
3970	1339	54
3971	1340	54
3972	1341	54
3973	1343	54
3974	1344	54
3975	1345	54
3976	1346	54
3977	1347	54
3978	1348	54
3979	1349	54
3980	1350	54
3981	1352	54
3982	1353	54
3983	1354	54
3984	1355	54
3985	1356	54
3986	1357	54
3987	1358	54
3988	1360	54
3989	1361	54
3990	1362	54
3991	1363	54
3992	1364	54
3993	1365	54
3994	1366	54
3995	1369	54
3996	1370	54
3997	1373	54
3998	1374	54
3999	1376	54
4000	1378	54
4001	1379	54
4002	1380	54
4003	1381	54
4004	1382	54
4005	1383	54
4006	1384	54
4007	1385	54
4008	1386	54
4009	1389	54
4010	1390	54
4011	1391	54
4012	1392	54
4013	1393	54
4014	1394	54
4015	1395	54
4016	1396	54
4017	1397	54
4018	1398	54
4019	1400	54
4020	1401	54
4021	1402	54
4022	1403	54
4023	1404	54
4024	1405	54
4025	1407	54
4026	1408	54
4027	1409	54
4028	1410	54
4029	1411	54
4030	1413	54
4031	1414	54
4032	1415	54
4033	1417	54
4034	1418	54
4035	1419	54
4036	1420	54
4037	1421	54
4038	1422	54
4039	1423	54
4040	1426	54
4041	1427	54
4042	1428	54
4043	1431	54
4044	1432	54
4045	1433	54
4046	1435	54
4047	1436	54
4048	1437	54
4049	1438	54
4050	1439	54
4051	1442	54
4052	1444	54
4053	1445	54
4054	1446	54
4055	1447	54
4056	1448	54
4057	1449	54
4058	1450	54
4059	1451	54
4060	1452	54
4061	1453	54
4062	1454	54
4063	1455	54
4064	1456	54
4065	1457	54
4066	1458	54
4067	1459	54
4068	1461	54
4069	1462	54
4070	1463	54
4071	1465	54
4072	1466	54
4073	1467	54
4074	1469	54
4075	1470	54
4076	1471	54
4077	1472	54
4078	1473	54
4079	1474	54
4080	1475	54
4081	1476	54
4082	1477	54
4083	1479	54
4084	1481	54
4085	1482	54
4086	1483	54
4087	1484	54
4088	1485	54
4089	1486	54
4090	1487	54
4091	1488	54
4092	1489	54
4093	1490	54
4094	1491	54
4095	1492	54
4096	1493	54
4097	1494	54
4098	1495	54
4099	1496	54
4100	1498	54
4101	1499	54
4102	1500	54
4103	1502	54
4104	1503	54
4105	1504	54
4106	1505	54
4107	1506	54
4108	1507	54
4109	1508	54
4110	1509	54
4111	1510	54
4112	1511	54
4113	1512	54
4114	1513	54
4115	1514	54
4116	1515	54
4117	1516	54
4118	1517	54
4119	1571	54
4120	1714	54
4121	1745	54
4122	1746	54
4123	1748	54
4124	1854	54
4125	1855	54
4126	1868	54
4127	1869	54
4128	1870	54
4129	1871	54
4130	1872	54
4131	1873	54
4132	1923	54
4133	1928	54
4134	1929	54
4135	1932	54
4136	1942	54
4137	1944	54
4138	1945	54
4139	2000	54
4140	2001	54
4141	2002	54
4142	2003	54
4143	2004	54
4144	2005	54
4145	2006	54
4146	2008	54
4147	2009	54
4148	2010	54
4149	2011	54
4150	2012	54
4151	2013	54
4152	2014	54
4153	2015	54
4154	2067	54
4155	2068	54
4156	2069	54
4157	2070	54
4158	2072	54
4159	2208	54
4160	2210	54
4161	2213	54
4162	2217	54
4163	2254	54
4164	2257	54
4165	2304	54
4166	2318	54
4167	2426	54
4168	2427	54
4169	2428	54
4170	2429	54
4171	2441	54
4172	2445	54
4173	2447	54
4174	2448	54
4175	2463	54
4176	2464	54
4177	2465	54
4178	2466	54
4179	2467	54
4180	2468	54
4181	2469	54
4182	2495	54
4183	2538	54
4184	2545	54
4185	2546	54
4186	2547	54
4187	2555	54
4188	2556	54
4189	2557	54
4190	2573	54
4191	2623	54
4192	2624	54
4193	2626	54
4194	2627	54
4195	2687	54
4196	2714	54
4197	2715	54
4198	2717	54
4199	2719	54
4200	2720	54
4201	2721	54
4202	2722	54
4203	2723	54
4204	2724	54
4205	2725	54
4206	2726	54
4207	2728	54
4208	2741	54
4209	2793	54
4210	2805	54
4211	2806	54
4212	2813	54
4213	2830	54
4214	2835	54
4215	2844	54
4216	2845	54
4217	2846	54
4218	2852	54
4219	2858	54
4220	2870	54
4221	2878	54
4222	2880	54
4223	2881	54
4224	2907	54
4225	2925	54
4226	2926	54
4227	2940	54
4228	2950	54
4229	2956	54
4230	2965	54
4231	2968	54
4232	2984	54
4233	2988	54
4234	2989	54
4235	3049	54
4236	3050	54
4237	3051	54
4238	3052	54
4239	3053	54
4240	3076	54
4241	3078	54
4242	3085	54
4243	3087	54
4244	3088	54
4245	3089	54
4246	3097	54
4247	3098	54
4248	3099	54
4249	3100	54
4250	3101	54
4251	3102	54
4252	3103	54
4253	3104	54
4254	3105	54
4255	3106	54
4256	3107	54
4257	3108	54
4258	3109	54
4259	3110	54
4260	3111	54
4261	3112	54
4262	3113	54
4263	3114	54
4264	3115	54
4265	3116	54
4266	3117	54
4267	3118	54
4268	3119	54
4269	3120	54
4270	3121	54
4271	3126	54
4272	3127	54
4273	3128	54
4274	3129	54
4275	3130	54
4276	3131	54
4277	3132	54
4278	3133	54
4279	3134	54
4280	3135	54
4281	3137	54
4282	3139	54
4283	3148	54
4284	3149	54
4285	3170	54
4286	3174	54
4287	3175	54
4288	3176	54
4289	3178	54
4290	3179	54
4291	3180	54
4292	3181	54
4293	3182	54
4294	3183	54
4295	3184	54
4296	3185	54
4297	3186	54
4298	3187	54
4299	3188	54
4300	3189	54
4301	3190	54
4302	3191	54
4303	3192	54
4304	3194	54
4305	3200	54
4306	3203	54
4307	3205	54
4308	3206	54
4309	3207	54
4310	3208	54
4311	3209	54
4312	3210	54
4313	3211	54
4314	3212	54
4315	3213	54
4316	3214	54
4317	3215	54
4318	3216	54
4319	3217	54
4320	3218	54
4321	3219	54
4322	3221	54
4323	3222	54
4324	3223	54
4325	3224	54
4326	3225	54
4327	3226	54
4328	3227	54
4329	3228	54
4330	3229	54
4331	3230	54
4332	3231	54
4333	3232	54
4334	3233	54
4335	3234	54
4336	3235	54
4337	3236	54
4338	3237	54
4339	3238	54
4340	3239	54
4341	3240	54
4342	3242	54
4343	3247	54
4344	1005	55
4345	1008	55
4346	1016	55
4347	1017	55
4348	1023	55
4349	1026	55
4350	1040	55
4351	1041	55
4352	1045	55
4353	1048	55
4354	1050	55
4355	1053	55
4356	1062	55
4357	1064	55
4358	1067	55
4359	1069	55
4360	1076	55
4361	1079	55
4362	1581	55
4363	1582	55
4364	1589	55
4365	1612	55
4366	1660	55
4367	1703	55
4368	1705	55
4369	1741	55
4370	1749	55
4371	1859	55
4372	1911	55
4373	1953	55
4374	1955	55
4375	1967	55
4376	1975	55
4377	2186	55
4378	2188	55
4379	2189	55
4380	2190	55
4381	2191	55
4382	2192	55
4383	2194	55
4384	2195	55
4385	2196	55
4386	2197	55
4387	2198	55
4388	2199	55
4389	2202	55
4390	2204	55
4391	2417	55
4392	2418	55
4393	2420	55
4394	2421	55
4395	2451	55
4396	2534	55
4397	2548	55
4398	2600	55
4399	2676	55
4400	2901	55
4401	3057	55
4402	3070	55
4403	3083	55
4404	3160	55
4405	3162	55
4406	3168	55
4407	3169	55
4408	1051	56
4409	1092	56
4410	1098	56
4411	1163	56
4412	1182	56
4413	1238	56
4414	1239	56
4415	1244	56
4416	1259	56
4417	1541	56
4418	1553	56
4419	1560	56
4420	1565	56
4421	1570	56
4422	1575	56
4423	1580	56
4424	1595	56
4425	1613	56
4426	1614	56
4427	1626	56
4428	1647	56
4429	1649	56
4430	1670	56
4431	1672	56
4432	1680	56
4433	1689	56
4434	1692	56
4435	1694	56
4436	1698	56
4437	1699	56
4438	1713	56
4439	1889	56
4440	1892	56
4441	1994	56
4442	2249	56
4443	2316	56
4444	2317	56
4445	2334	56
4446	2471	56
4447	2480	56
4448	2558	56
4449	2628	56
4450	2629	56
4451	2630	56
4452	2642	56
4453	2646	56
4454	2740	56
4455	3048	56
4456	3246	56
4457	1001	57
4458	1002	57
4459	1003	57
4460	1006	57
4461	1009	57
4462	1010	57
4463	1011	57
4464	1012	57
4465	1013	57
4466	1014	57
4467	1015	57
4468	1018	57
4469	1020	57
4470	1021	57
4471	1022	57
4472	1027	57
4473	1028	57
4474	1029	57
4475	1030	57
4476	1032	57
4477	1033	57
4478	1035	57
4479	1036	57
4480	1037	57
4481	1038	57
4482	1039	57
4483	1043	57
4484	1044	57
4485	1046	57
4486	1049	57
4487	1052	57
4488	1055	57
4489	1056	57
4490	1057	57
4491	1058	57
4492	1060	57
4493	1061	57
4494	1063	57
4495	1065	57
4496	1066	57
4497	1070	57
4498	1071	57
4499	1072	57
4500	1073	57
4501	1075	57
4502	1077	57
4503	1078	57
4504	1080	57
4505	1081	57
4506	1082	57
4507	1083	57
4508	1085	57
4509	1086	57
4510	1087	57
4511	1088	57
4512	1089	57
4513	1090	57
4514	1091	57
4515	1093	57
4516	1099	57
4517	1100	57
4518	1104	57
4519	1105	57
4520	1106	57
4521	1107	57
4522	1108	57
4523	1109	57
4524	1110	57
4525	1111	57
4526	1112	57
4527	1113	57
4528	1114	57
4529	1118	57
4530	1120	57
4531	1123	57
4532	1125	57
4533	1126	57
4534	1127	57
4535	1128	57
4536	1129	57
4537	1130	57
4538	1131	57
4539	1133	57
4540	1134	57
4541	1136	57
4542	1139	57
4543	1143	57
4544	1144	57
4545	1145	57
4546	1146	57
4547	1147	57
4548	1148	57
4549	1149	57
4550	1150	57
4551	1152	57
4552	1153	57
4553	1154	57
4554	1155	57
4555	1156	57
4556	1157	57
4557	1158	57
4558	1159	57
4559	1160	57
4560	1161	57
4561	1162	57
4562	1164	57
4563	1165	57
4564	1166	57
4565	1167	57
4566	1169	57
4567	1170	57
4568	1171	57
4569	1172	57
4570	1173	57
4571	1175	57
4572	1176	57
4573	1177	57
4574	1178	57
4575	1179	57
4576	1180	57
4577	1184	57
4578	1188	57
4579	1189	57
4580	1190	57
4581	1191	57
4582	1192	57
4583	1193	57
4584	1194	57
4585	1195	57
4586	1196	57
4587	1197	57
4588	1198	57
4589	1199	57
4590	1201	57
4591	1202	57
4592	1203	57
4593	1204	57
4594	1206	57
4595	1207	57
4596	1208	57
4597	1210	57
4598	1212	57
4599	1213	57
4600	1214	57
4601	1216	57
4602	1218	57
4603	1219	57
4604	1220	57
4605	1221	57
4606	1222	57
4607	1223	57
4608	1224	57
4609	1228	57
4610	1229	57
4611	1230	57
4612	1231	57
4613	1233	57
4614	1234	57
4615	1235	57
4616	1237	57
4617	1243	57
4618	1245	57
4619	1246	57
4620	1247	57
4621	1248	57
4622	1249	57
4623	1250	57
4624	1251	57
4625	1255	57
4626	1256	57
4627	1257	57
4628	1261	57
4629	1262	57
4630	1263	57
4631	1264	57
4632	1265	57
4633	1266	57
4634	1267	57
4635	1268	57
4636	1270	57
4637	1271	57
4638	1272	57
4639	1274	57
4640	1275	57
4641	1276	57
4642	1277	57
4643	1278	57
4644	1279	57
4645	1280	57
4646	1281	57
4647	1282	57
4648	1286	57
4649	1287	57
4650	1288	57
4651	1289	57
4652	1292	57
4653	1293	57
4654	1294	57
4655	1296	57
4656	1297	57
4657	1298	57
4658	1299	57
4659	1300	57
4660	1301	57
4661	1302	57
4662	1303	57
4663	1304	57
4664	1305	57
4665	1306	57
4666	1307	57
4667	1308	57
4668	1604	57
4669	1648	57
4670	1715	57
4671	1716	57
4672	1717	57
4673	1718	57
4674	1719	57
4675	1722	57
4676	1723	57
4677	1724	57
4678	1725	57
4679	1726	57
4680	1727	57
4681	1728	57
4682	1729	57
4683	1730	57
4684	1731	57
4685	1732	57
4686	1733	57
4687	1736	57
4688	1739	57
4689	1740	57
4690	1742	57
4691	1743	57
4692	1744	57
4693	1747	57
4694	1752	57
4695	1753	57
4696	1754	57
4697	1755	57
4698	1756	57
4699	1757	57
4700	1758	57
4701	1759	57
4702	1760	57
4703	1761	57
4704	1762	57
4705	1763	57
4706	1764	57
4707	1765	57
4708	1766	57
4709	1767	57
4710	1768	57
4711	1769	57
4712	1770	57
4713	1771	57
4714	1773	57
4715	1774	57
4716	1775	57
4717	1776	57
4718	1777	57
4719	1778	57
4720	1779	57
4721	1780	57
4722	1781	57
4723	1782	57
4724	1783	57
4725	1784	57
4726	1786	57
4727	1787	57
4728	1788	57
4729	1789	57
4730	1790	57
4731	1791	57
4732	1792	57
4733	1793	57
4734	1794	57
4735	1796	57
4736	1798	57
4737	1799	57
4738	1800	57
4739	1801	57
4740	1802	57
4741	1803	57
4742	1804	57
4743	1805	57
4744	1806	57
4745	1807	57
4746	1808	57
4747	1809	57
4748	1810	57
4749	1811	57
4750	1813	57
4751	1814	57
4752	1815	57
4753	1816	57
4754	1817	57
4755	1818	57
4756	1819	57
4757	1823	57
4758	1824	57
4759	1825	57
4760	1826	57
4761	1827	57
4762	1828	57
4763	1829	57
4764	1830	57
4765	1831	57
4766	1832	57
4767	1833	57
4768	1834	57
4769	1835	57
4770	1836	57
4771	1837	57
4772	1838	57
4773	1839	57
4774	1840	57
4775	1841	57
4776	1845	57
4777	1847	57
4778	1848	57
4779	1849	57
4780	1858	57
4781	1860	57
4782	1862	57
4783	1863	57
4784	1864	57
4785	1865	57
4786	1866	57
4787	1898	57
4788	1902	57
4789	1903	57
4790	1905	57
4791	1906	57
4792	1907	57
4793	1908	57
4794	1910	57
4795	1912	57
4796	1913	57
4797	1914	57
4798	1915	57
4799	1917	57
4800	1918	57
4801	1919	57
4802	1920	57
4803	1921	57
4804	1922	57
4805	1931	57
4806	1938	57
4807	1939	57
4808	1940	57
4809	1941	57
4810	1951	57
4811	1952	57
4812	1954	57
4813	1956	57
4814	1957	57
4815	1958	57
4816	1959	57
4817	1960	57
4818	1961	57
4819	1962	57
4820	1963	57
4821	1964	57
4822	1965	57
4823	1966	57
4824	1968	57
4825	1969	57
4826	1970	57
4827	1971	57
4828	1972	57
4829	1973	57
4830	1974	57
4831	1976	57
4832	1977	57
4833	1978	57
4834	1979	57
4835	1980	57
4836	1981	57
4837	1982	57
4838	1983	57
4839	1984	57
4840	1986	57
4841	1987	57
4842	1988	57
4843	1989	57
4844	1991	57
4845	1992	57
4846	1993	57
4847	1999	57
4848	2028	57
4849	2029	57
4850	2030	57
4851	2031	57
4852	2032	57
4853	2033	57
4854	2034	57
4855	2035	57
4856	2036	57
4857	2044	57
4858	2045	57
4859	2046	57
4860	2047	57
4861	2048	57
4862	2049	57
4863	2050	57
4864	2051	57
4865	2052	57
4866	2053	57
4867	2054	57
4868	2055	57
4869	2056	57
4870	2057	57
4871	2058	57
4872	2059	57
4873	2071	57
4874	2073	57
4875	2079	57
4876	2187	57
4877	2193	57
4878	2200	57
4879	2201	57
4880	2203	57
4881	2209	57
4882	2211	57
4883	2212	57
4884	2214	57
4885	2215	57
4886	2216	57
4887	2218	57
4888	2219	57
4889	2222	57
4890	2225	57
4891	2226	57
4892	2227	57
4893	2234	57
4894	2238	57
4895	2240	57
4896	2241	57
4897	2242	57
4898	2243	57
4899	2244	57
4900	2245	57
4901	2246	57
4902	2247	57
4903	2248	57
4904	2251	57
4905	2252	57
4906	2256	57
4907	2258	57
4908	2259	57
4909	2260	57
4910	2262	57
4911	2263	57
4912	2264	57
4913	2265	57
4914	2266	57
4915	2267	57
4916	2269	57
4917	2270	57
4918	2271	57
4919	2275	57
4920	2276	57
4921	2277	57
4922	2278	57
4923	2280	57
4924	2282	57
4925	2283	57
4926	2284	57
4927	2286	57
4928	2287	57
4929	2288	57
4930	2289	57
4931	2293	57
4932	2296	57
4933	2297	57
4934	2298	57
4935	2301	57
4936	2302	57
4937	2303	57
4938	2305	57
4939	2308	57
4940	2309	57
4941	2310	57
4942	2313	57
4943	2315	57
4944	2319	57
4945	2320	57
4946	2323	57
4947	2324	57
4948	2325	57
4949	2326	57
4950	2327	57
4951	2329	57
4952	2330	57
4953	2331	57
4954	2332	57
4955	2333	57
4956	2335	57
4957	2336	57
4958	2338	57
4959	2339	57
4960	2340	57
4961	2341	57
4962	2342	57
4963	2343	57
4964	2344	57
4965	2345	57
4966	2346	57
4967	2347	57
4968	2348	57
4969	2350	57
4970	2351	57
4971	2352	57
4972	2353	57
4973	2354	57
4974	2356	57
4975	2357	57
4976	2358	57
4977	2359	57
4978	2360	57
4979	2361	57
4980	2362	57
4981	2363	57
4982	2364	57
4983	2366	57
4984	2367	57
4985	2368	57
4986	2370	57
4987	2371	57
4988	2372	57
4989	2373	57
4990	2374	57
4991	2375	57
4992	2376	57
4993	2377	57
4994	2378	57
4995	2379	57
4996	2380	57
4997	2381	57
4998	2382	57
4999	2383	57
5000	2384	57
5001	2385	57
5002	2386	57
5003	2387	57
5004	2388	57
5005	2389	57
5006	2390	57
5007	2391	57
5008	2392	57
5009	2393	57
5010	2394	57
5011	2395	57
5012	2396	57
5013	2397	57
5014	2398	57
5015	2399	57
5016	2400	57
5017	2401	57
5018	2402	57
5019	2403	57
5020	2404	57
5021	2405	57
5022	2406	57
5023	2407	57
5024	2409	57
5025	2410	57
5026	2411	57
5027	2412	57
5028	2413	57
5029	2414	57
5030	2416	57
5031	2419	57
5032	2422	57
5033	2424	57
5034	2434	57
5035	2435	57
5036	2436	57
5037	2437	57
5038	2438	57
5039	2439	57
5040	2440	57
5041	2442	57
5042	2443	57
5043	2444	57
5044	2452	57
5045	2453	57
5046	2454	57
5047	2455	57
5048	2456	57
5049	2457	57
5050	2458	57
5051	2459	57
5052	2460	57
5053	2461	57
5054	2475	57
5055	2477	57
5056	2478	57
5057	2481	57
5058	2482	57
5059	2483	57
5060	2484	57
5061	2485	57
5062	2486	57
5063	2491	57
5064	2493	57
5065	2496	57
5066	2497	57
5067	2498	57
5068	2502	57
5069	2503	57
5070	2506	57
5071	2507	57
5072	2508	57
5073	2509	57
5074	2511	57
5075	2513	57
5076	2514	57
5077	2517	57
5078	2520	57
5079	2521	57
5080	2524	57
5081	2526	57
5082	2527	57
5083	2528	57
5084	2529	57
5085	2530	57
5086	2531	57
5087	2535	57
5088	2536	57
5089	2541	57
5090	2542	57
5091	2553	57
5092	2554	57
5093	2560	57
5094	2561	57
5095	2564	57
5096	2565	57
5097	2571	57
5098	2576	57
5099	2577	57
5100	2578	57
5101	2579	57
5102	2580	57
5103	2581	57
5104	2582	57
5105	2583	57
5106	2584	57
5107	2585	57
5108	2586	57
5109	2590	57
5110	2591	57
5111	2599	57
5112	2601	57
5113	2602	57
5114	2603	57
5115	2604	57
5116	2605	57
5117	2606	57
5118	2607	57
5119	2608	57
5120	2610	57
5121	2612	57
5122	2614	57
5123	2615	57
5124	2616	57
5125	2617	57
5126	2618	57
5127	2619	57
5128	2620	57
5129	2621	57
5130	2622	57
5131	2670	57
5132	2672	57
5133	2677	57
5134	2678	57
5135	2679	57
5136	2680	57
5137	2681	57
5138	2682	57
5139	2683	57
5140	2684	57
5141	2685	57
5142	2686	57
5143	2691	57
5144	2692	57
5145	2693	57
5146	2698	57
5147	2699	57
5148	2705	57
5149	2707	57
5150	2708	57
5151	2709	57
5152	2710	57
5153	2711	57
5154	2733	57
5155	2734	57
5156	2735	57
5157	2739	57
5158	2749	57
5159	2751	57
5160	2752	57
5161	2758	57
5162	2760	57
5163	2762	57
5164	2764	57
5165	2766	57
5166	2768	57
5167	2770	57
5168	2772	57
5169	2774	57
5170	2776	57
5171	2778	57
5172	2780	57
5173	2782	57
5174	2784	57
5175	2787	57
5176	2789	57
5177	2790	57
5178	2794	57
5179	2795	57
5180	2796	57
5181	2797	57
5182	2798	57
5183	2799	57
5184	2800	57
5185	2801	57
5186	2802	57
5187	2803	57
5188	2807	57
5189	2809	57
5190	2812	57
5191	2814	57
5192	2815	57
5193	2817	57
5194	2818	57
5195	2819	57
5196	2820	57
5197	2823	57
5198	2826	57
5199	2829	57
5200	2834	57
5201	2837	57
5202	2838	57
5203	2840	57
5204	2842	57
5205	2850	57
5206	2851	57
5207	2857	57
5208	2865	57
5209	2869	57
5210	2879	57
5211	2900	57
5212	2904	57
5213	2905	57
5214	2906	57
5215	2920	57
5216	2921	57
5217	2922	57
5218	2923	57
5219	2924	57
5220	2933	57
5221	2934	57
5222	2935	57
5223	2943	57
5224	2945	57
5225	2947	57
5226	2949	57
5227	2967	57
5228	2969	57
5229	2983	57
5230	2985	57
5231	2986	57
5232	2987	57
5233	2990	57
5234	3021	57
5235	3022	57
5236	3024	57
5237	3028	57
5238	3054	57
5239	3055	57
5240	3056	57
5241	3064	57
5242	3065	57
5243	3066	57
5244	3072	57
5245	3077	57
5246	3079	57
5247	3082	57
5248	3084	57
5249	3090	57
5250	3091	57
5251	3092	57
5252	3093	57
5253	3094	57
5254	3095	57
5255	3096	57
5256	3136	57
5257	3138	57
5258	3147	57
5259	3150	57
5260	3151	57
5261	3152	57
5262	3153	57
5263	3154	57
5264	3156	57
5265	3157	57
5266	3158	57
5267	3159	57
5268	3161	57
5269	3163	57
5270	3164	57
5271	3165	57
5272	3166	57
5273	3167	57
5274	3171	57
5275	3220	57
5276	3244	57
5277	3245	57
5278	3248	57
5279	3101	59
5280	3102	59
5281	3111	59
5282	3112	59
5283	3221	2
5284	3222	2
5285	3231	2
5286	3232	2
5287	3221	6
5288	3222	6
5289	3231	6
5290	3232	6
5291	3221	9
5292	3222	9
5293	3231	9
5294	3232	9
5295	3221	10
5296	3222	10
5297	3231	10
5298	3232	10
5299	3221	15
5300	3222	15
5301	3231	15
5302	3232	15
5303	3221	21
5304	3222	21
5305	3231	21
5306	3232	21
5307	3221	26
5308	3222	26
5309	3231	26
5310	3232	26
5311	3221	32
5312	3222	32
5313	3231	32
5314	3232	32
5315	3221	38
5316	3222	38
5317	3231	38
5318	3232	38
5319	3221	44
5320	3222	44
5321	3231	44
5322	3232	44
5323	3221	47
5324	3222	47
5325	3231	47
5326	3232	47
5327	3221	51
5328	3222	51
5329	3231	51
5330	3232	51
5331	3221	54
5332	3222	54
5333	3231	54
5334	3232	54
5335	3221	58
5336	3222	58
5337	3231	58
5338	3232	58
\.


--
-- Data for Name: contatos; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY contatos (id_contato, celular, email, radio, site, tel) FROM stdin;
2	(22)98128-2707	edilsonj.filho@gmail.com		\N	
3	(00)00000-0000	000000000		\N	
4	(22)22222-2222	a@a		\N	
5	\N	\N	\N	\N	\N
6	\N	\N	\N	\N	\N
7	(22)22222-2222	a@a		\N	
8	(22)22222-2222	2a@a		\N	
9	(22)22222-2222	a@a		\N	
10	(22)22222-2222	a@a		\N	
11	(22)22222-2222	o@o		\N	
12	(22)22222-2222	222@a		\N	
13	(22)22222-2222	a@a		\N	
14	\N	\N	\N	\N	\N
15	\N	\N	\N	\N	\N
16	(33)33333-3333	o@a		\N	
17	\N	\N	\N	\N	\N
\.


--
-- Name: contatos_id_contato_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('contatos_id_contato_seq', 17, true);


--
-- Data for Name: det_nota; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY det_nota (id_detalhe_nota, dt_pedido, id_fornecedor, id_tipo_equipamento, num_nota, valor_total, valor_unitario, fornecedor_id_fornecedor, id_produto, tipo_equipamento_id_tipo_equipamento) FROM stdin;
\.


--
-- Name: det_nota_id_detalhe_nota_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('det_nota_id_detalhe_nota_seq', 1, false);


--
-- Data for Name: dimensoes; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY dimensoes (id_dimensoes, alt_dimensao, lar_dimensao, comp_dimensao) FROM stdin;
\.


--
-- Name: dimensoes_id_dimensoes_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('dimensoes_id_dimensoes_seq', 1, false);


--
-- Data for Name: embalagem; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY embalagem (id_embalagem, capacid_pressao, espec_emabalagem, id_tipo_material, pt_ebulicao, pt_fulgor, id_capacidade, id_compatibilidade, id_grupo_embalagem) FROM stdin;
\.


--
-- Name: embalagem_id_embalagem_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('embalagem_id_embalagem_seq', 1, false);


--
-- Data for Name: empresa; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY empresa (id_empresa, razao_social, endereco) FROM stdin;
\.


--
-- Name: empresa_id_empresa_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('empresa_id_empresa_seq', 1, false);


--
-- Data for Name: end_armazem; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY end_armazem (id_endarmazem, rua_end_armazem, estatos) FROM stdin;
1	ab	t
2	ac	t
14	dm	t
15	du	f
13	lt	f
\.


--
-- Name: end_armazem_id_endarmazem_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('end_armazem_id_endarmazem_seq', 15, true);


--
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY endereco (id_endereco, bairro, cep, complemento, logadouro, numero, id_cidade, id_estado, id_pais) FROM stdin;
2	jardim	28920-046	\N	rua	109	828	19	1
3	euomaou	00000-000	\N	iumaum	0	828	19	1
4	kqvkvqkv	20000-000	\N	vqkvqkvqkv	1	828	22	1
5	\N	\N	\N	\N	\N	\N	\N	\N
6	\N	\N	\N	\N	\N	\N	\N	\N
7	sdmusdu	20000-000	\N	srurd	121321	828	19	1
8	sdmsdmsdm	20000-000	\N	vdsmsdm	152	5	5	1
9	1111111	11111-111	\N	1111111111	111111111	6	4	1
10	1111111	11111-111	\N	22222	111111	7	5	1
11	drsdnrsd	20000-000	\N	rsdnrrs	105	4	4	1
12	rnsdrnsd	20000-000	\N	sdnrsdnrsd	222	3	7	1
13	j esperança	28920-000	\N	treze	109	828	19	1
14	\N	\N	\N	\N	\N	\N	\N	\N
15	\N	\N	\N	\N	\N	\N	\N	\N
16	654654	20000-000	\N	2456465	654654	6	3	1
17	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Name: endereco_id_endereco_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('endereco_id_endereco_seq', 17, true);


--
-- Data for Name: epe; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY epe (id_epe, agente_epe, classe_epe, nome_epe, tipo_material_id_material) FROM stdin;
\.


--
-- Name: epe_id_epe_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('epe_id_epe_seq', 1, false);


--
-- Data for Name: epi; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY epi (id_epi, espec_epi, grupo_epi, nome_epi, id_material) FROM stdin;
\.


--
-- Name: epi_id_epi_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('epi_id_epi_seq', 1, false);


--
-- Data for Name: est_fisico; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY est_fisico (id_est_fisico, esp_est_fisico, nome_est_fisico) FROM stdin;
\.


--
-- Name: est_fisico_id_est_fisico_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('est_fisico_id_est_fisico_seq', 1, false);


--
-- Data for Name: estado; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY estado (id_estado, nome_estado, sigla_estado, id_pais) FROM stdin;
1	Acre	AC	1
2	Alagoas	AL	1
3	Amapá	AP	1
4	Amazonas	AM	1
5	Bahia	BA	1
6	Ceará	CE	1
7	Distrito Federal	DF	1
8	Espírito Santo	ES	1
9	Goiás	GO	1
10	Maranhão	MA	1
11	Mato Grosso	MT	1
12	Mato Grosso do Sul	MS	1
13	Minas Gerais	MG	1
14	Pará	PA	1
15	Paraíba	PB	1
16	Paraná	PR	1
17	Pernambuco	PE	1
18	Piauí	PI	1
19	Rio de Janeiro	RJ	1
20	Rio Grande do Norte	RN	1
21	Rio Grande do Sul	RS	1
22	Rondônia	RO	1
23	Roraima	RR	1
24	Santa Catarina	SC	1
25	São Paulo	SP	1
26	Sergipe	SE	1
27	Tocantins	TO	1
\.


--
-- Name: estado_id_estado_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('estado_id_estado_seq', 1, false);


--
-- Data for Name: fornecedor; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY fornecedor (id_fornecedor, cnpj, id_contato, insc_social, nome_fantasia, razao_social, contatos_id_contato, id_endereco) FROM stdin;
\.


--
-- Name: fornecedor_id_fornecedor_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('fornecedor_id_fornecedor_seq', 1, false);


--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY funcionario (id_funcionario, cargo, cpf, dt_admissao, dt_nasc, especializacao, funcao, id_contato, id_endereco, mat_funcionario, nivel_funcionario, nome_funcionario, rg, sb_nome_funcionario, sexo, contatos_id_contato, endereco_id_endereco, id_usuario) FROM stdin;
1	Analista de Suporte	104.912.307-70	2015-06-03	2015-06-02		Analista de Suporte	\N	\N	465465		Edilson	00000000-0	Jardim Filho	M	2	2	2
12	Suporte	104.912.307-70	2015-06-01	1985-02-17		Analista	\N	\N	456454		Edilson	00000000-0	J Filho	M	13	13	13
15	232132132	104.912.307-70	2015-06-02	2015-06-03	32132131	3213213	\N	\N	423132	321321	32132132	11111111-1	32132132132	M	16	16	16
\.


--
-- Name: funcionario_id_funcionario_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('funcionario_id_funcionario_seq', 16, true);


--
-- Data for Name: grupo_embalagem; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY grupo_embalagem (id_grupo_embalagem, espec_grupo_embalagem, nome_grupo_embalagem) FROM stdin;
\.


--
-- Name: grupo_embalagem_id_grupo_embalagem_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('grupo_embalagem_id_grupo_embalagem_seq', 1, false);


--
-- Data for Name: item_pedido_produto; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY item_pedido_produto (id_pedido_produto, id_pedido_fk, id_produto_fk, qtd_produto) FROM stdin;
\.


--
-- Name: item_pedido_produto_id_pedido_produto_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('item_pedido_produto_id_pedido_produto_seq', 1, false);


--
-- Data for Name: legenda_compatibilidade; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY legenda_compatibilidade (id_legenda_compatibilidade, legenda, desc_legenda) FROM stdin;
1	x	 Incompatível
2	A	Incompatível para produtos da subclasse 2.3 que apresentem toxicidade por inalação LC50 < 1000 ppm.
3	B	Incompatível apenas para os produtos da subclasse 4.1 com os seguintes números ONU: 3221, 3222, 3231 e 3232.
4	C	Incompatível apenas para os produtos da subclasse 5.2 com os seguintes números ONU: 3101, 3102, 3111 e 3112.
5	D	Incompatível apenas para os produtos da subclasse 6.1 do grupo de embalagem I.
6	E	Em caso de incompatibilidade química dentro de uma mesma classe ou subclasse de produtos perigosos, ver 4.4 
\.


--
-- Name: legenda_compatibilidade_id_legenda_compatibilidade_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('legenda_compatibilidade_id_legenda_compatibilidade_seq', 1, false);


--
-- Data for Name: local_operacao; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY local_operacao (id_local_oper, desc__local_oper, local_oper) FROM stdin;
\.


--
-- Name: local_operacao_id_local_oper_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('local_operacao_id_local_oper_seq', 1, false);


--
-- Data for Name: lote; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY lote (id_lote, fk_id_dimensoes, estado, num_onu, lado, numero_paletes_armazenados, quantidade_produtos, id_armazem, sequencial) FROM stdin;
\.


--
-- Name: lote_id_lote_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('lote_id_lote_seq', 1, false);


--
-- Data for Name: movimentacao; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY movimentacao (id_movimentacao, id_endarmazem, id_produto) FROM stdin;
11	1	5
39	2	9
47	14	402
\.


--
-- Name: movimentacao_id_movimentacao_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('movimentacao_id_movimentacao_seq', 50, true);


--
-- Data for Name: num_cas; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY num_cas (id_num_cas, espc_num_cas, num_cas) FROM stdin;
\.


--
-- Name: num_cas_id_num_cas_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('num_cas_id_num_cas_seq', 1, false);


--
-- Data for Name: num_onu; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY num_onu (id_num_onu, desc_prod, nome_prod, num_onu) FROM stdin;
\.


--
-- Name: num_onu_id_num_onu_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('num_onu_id_num_onu_seq', 1, false);


--
-- Data for Name: pais; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY pais (id_pais, nome_pais, siglapais) FROM stdin;
1	Brasil	BR
\.


--
-- Name: pais_id_pais_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('pais_id_pais_seq', 1, false);


--
-- Data for Name: pedido; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY pedido (id_pedido, situacao_pedido, data) FROM stdin;
\.


--
-- Name: pedido_id_pedido_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('pedido_id_pedido_seq', 1, false);


--
-- Data for Name: produto; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY produto (num_onu, desc_produto, classe, qtd_por_palete) FROM stdin;
4	PICRATO DE AMÔNIO, seco ou umedecido com menos de 10% de água, em massa	1	\N
5	CARTUCHOS PARA ARMAS, com carga de ruptura	1	\N
6	CARTUCHOS PARA ARMAS, com carga de ruptura	1	\N
7	CARTUCHOS PARA ARMAS, com carga de ruptura	2	\N
9	MUNIÇÃO INCENDIÁRIA, com ou sem ruptor, carga ejetora ou carga propelente	2	\N
10	MUNIÇÃO INCENDIÁRIA, com ou sem ruptor, carga ejetora ou carga propelente	3	\N
12	CARTUCHOS  PARA  ARMAS, PROJÉTEIS INERTES ou CARTUCHOS PARA ARMAS PORTÁTEIS	4	\N
14	CARTUCHOS PARA ARMAS, FESTIM ou CARTUCHOS PARA ARMAS PORTÁTEIS, FESTIM 	4	\N
15	MUNIÇÃO FUMÍGENA, com ou sem ruptor, carga ejetora ou carga propelente	2	\N
16	MUNIÇÃO FUMÍGENA, com ou sem ruptor, carga ejetora ou carga propelente	3	\N
18	MUNIÇÃO LACRIMOGÊNEA, com ruptor, carga ejetora ou carga propelente	2	\N
19	MUNIÇÃO LACRIMOGÊNEA, com ruptor, carga ejetora ou carga propelente 	3	\N
20	MUNIÇÃO TÓXICA, com ruptor, carga ejetora ou carga propelente	2	\N
21	MUNIÇÃO TÓXICA, com ruptor, carga ejetora ou carga propelente	3	\N
27	PÓLVORA NEGRA, granulada ou em pó	1	\N
28	PÓLVORA NEGRA, COMPRIMIDA ou PÓLVORA NEGRA, EM PASTILHAS	1	\N
29	DETONADORES, NÃO-ELÉTRICOS, para demolição	1	\N
30	DETONADORES, ELÉTRICOS, para demolição	1	\N
33	BOMBAS com carga de ruptura	1	\N
34	BOMBAS com carga de ruptura	1	\N
35	BOMBAS com carga de ruptura	2	\N
37	BOMBAS FOTO-ILUMINANTES	1	\N
38	BOMBAS FOTO-ILUMINANTES	1	\N
39	BOMBAS FOTO-ILUMINANTES	2	\N
42	REFORÇADORES sem detonador	1	\N
43	RUPTORES, explosivos	1	\N
44	INICIADORES, TIPO CÁPSULA	4	\N
48	CARGAS DE DEMOLIÇÃO	1	\N
49	CARTUCHOS ILUMINANTES	1	\N
50	CARTUCHOS ILUMINANTES	3	\N
54	CARTUCHOS PARA SINALIZAÇÃO	3	\N
55	ESTOJOS DE CARTUCHOS, VAZIOS, COM INICIADOR	4	\N
56	CARGAS DE PROFUNDIDADE	1	\N
59	CARGAS MOLDADAS, COMERCIAIS, sem detonador	1	\N
60	CARGAS SUPLEMENTARES, EXPLOSIVAS	1	\N
65	CORDEL DETONANTE, flexível	1	\N
66	CORDEL ACENDEDOR	4	\N
70	CORTA-CABOS, EXPLOSIVOS	4	\N
72	CICLOTRIMETILENOTRINITRAMINA (CICLONITA; HEXO-GÊNIO; RDX), UMEDECIDA com, no mínimo, 15% de água, em massa	1	\N
73	DETONADORES PARA MUNIÇÃO	1	\N
74	DIAZODINITROFENOL, UMEDECIDO com, no mínimo, 40% de água, ou mistura de álcool e água, em massa	1	\N
75	DINITRATO DE DIETILENOGLICOL, INSENSIBILIZADO, com  no mínimo 25%, em massa, de dessensibilizante não-volátil e insolúvel em água	1	\N
76	DINITROFENOL, seco ou umedecido com menos de 15% de água, em massa	1	\N
77	DINITROFENOLATOS, metais alcalinos, secos ou umedecidos com menos de 15% de água, em massa	3	\N
78	DINITRO-RESORCINOL, seco ou umedecido com menos de 15% de água, em massa	1	\N
79	HEXANITRODIFENILAMINA (DIPICRILAMINA; HEXIL)	1	\N
81	EXPLOSIVOS DE DEMOLIÇÃO, TIPO A	1	\N
82	EXPLOSIVOS DE DEMOLIÇÃO, TIPO B	1	\N
83	EXPLOSIVOS DE DEMOLIÇÃO, TIPO C	1	\N
84	EXPLOSIVOS DE DEMOLIÇÃO, TIPO D	1	\N
92	FACHOS DE SINALIZAÇÃO, DE SUPERFÍCIE	3	\N
93	FACHOS DE SINALIZAÇÃO, AÉREOS	3	\N
94	COMPOSIÇÃO ILUMINANTE, EM PÓ	1	\N
99	DISPOSITIVOS EXPLOSIVOS PARA FRATURAMENTO de poços de petróleo, sem detonador	1	\N
101	ESTOPIM RÁPIDO, NÃO-DETONANTE	3	\N
102	CORDEL DETONANTE, com revestimento metálico	2	\N
103	ACENDEDOR DE ESTOPIM, tubular, com revestimento metálico 	4	\N
104	CORDEL DETONANTE, DE EFEITO SUAVE, com revestimento metálico 	4	\N
105	ESTOPIM DE SEGURANÇA	4	\N
106	ESTOPILHA DE DETONAÇÃO	1	\N
107	ESTOPILHA DE DETONAÇÃO	2	\N
110	GRANADAS, PARA EXERCÍCIO, manuais ou para fuzil	4	\N
113	GUANILNITROSAMINO-GUANILIDENO HIDRAZINA, UMEDECIDA com, no mínimo, 30% de água, em massa	1	\N
114	GUANILNITROSAMINO-GUANILTETRAZENO (TETRAZENO), UMEDECIDO com, no mínimo, 30% de água, ou mistura de álcool e água, em massa	1	\N
118	HEXOLITA, seca ou umedecida com menos de 15% de água, em massa	1	\N
121	ACENDEDORES	1	\N
124	CANHÕES PARA JATO-PERFURAÇÃO em poços de petróleo, CARREGADOS, sem detonador	1	\N
129	AZIDA DE CHUMBO, UMEDECIDA com, no mínimo, 20% de água, ou mistura de álcool e água, em massa	1	\N
130	ESTIFINATO DE CHUMBO (TRINITRO-RESORCINATO DE  CHUMBO), UMEDECIDO com, no mínimo, 20% de água, ou mistura de álcool e água, em massa	1	\N
131	ACENDEDOR DE ESTOPIM	4	\N
132	SAIS METÁLICOS DEFLAGRANTES DE NITRODERIVADOS AROMÁTICOS, N.E 	3	\N
133	HEXANITRATO DE MANITOL (NITROMANITA), UMEDECIDO com, no mínimo, 40% de água, ou mistura de álcool e água, em massa	1	\N
135	FULMINATO DE MERCÚRIO, UMEDECIDO com, no mínimo, 20% de água, ou mistura de álcool e água, em massa	1	\N
136	MINAS, com carga de ruptura	1	\N
137	MINAS, com carga de ruptura	1	\N
138	MINAS, com carga de ruptura	2	\N
143	NITROGLICERINA, INSENSIBILIZADA com, no mínimo, 40%, em massa, de dessensibilizante não-volátil e insolúvel em água	1	\N
144	NITROGLICERINA, EM SOLUÇÃO ALCOÓLICA, com mais de 1% e até 10% de nitroglicerina	1	\N
146	NITROAMIDO, seco ou umedecido com menos de 20% de água, em massa	1	\N
147	NITROURÉIA	1	\N
150	TETRANITRATO DE PENTAERITRITA (TETRANITRATO DE   PENTAERITRITOL; PETN),  UMEDECIDO com, no mínimo, 25% de água, em massa, ou INSENSIBILIZADO com, no mínimo, 15% de dessensibilizante, em massa 	1	\N
151	PENTOLITA, seca ou umedecida com menos de 15% de água, em massa	1	\N
153	TRINITROANILINA (PICRAMIDA)	1	\N
154	TRINITROFENOL (ÁCIDO PÍCRICO) seco ou umedecido com menos de 30% de água, em massa	1	\N
155	TRINITROCLOROBENZENO (CLORETO DE PICRILA)	1	\N
158	SAIS DE POTÁSSIO DE NITRODERIVADOS AROMÁTICOS, explosivos	3	\N
159	PÓLVORA EM PASTA, UMEDECIDA com, no mínimo, 25% de água, em massa	3	\N
160	PÓLVORA SEM FUMAÇA	1	\N
161	PÓLVORA SEM FUMAÇA	3	\N
167	PROJÉTEIS, com carga de ruptura	1	\N
168	PROJÉTEIS, com carga de ruptura	1	\N
169	PROJÉTEIS, com carga de ruptura	2	\N
171	MUNIÇÃO ILUMINANTE, com ou sem ruptor, carga ejetora ou carga propelente	2	\N
173	DISPOSITIVOS EXPLOSIVOS DE ALÍVIO	4	\N
174	REBITES, EXPLOSIVOS	4	\N
180	FOGUETES, com carga de ruptura	1	\N
181	FOGUETES, com carga de ruptura	1	\N
182	FOGUETES, com carga de ruptura	2	\N
183	FOGUETES, com ogiva inerte	3	\N
186	MOTORES DE FOGUETES	3	\N
190	EXPLOSIVOS, AMOSTRAS, não-iniciantes	1	\N
191	SINALIZADORES MANUAIS	4	\N
192	SINALIZADORES EXPLOSIVOS PARA VIAS FÉRREAS	1	\N
193	SINALIZADORES EXPLOSIVOS PARA VIAS FÉRREAS	4	\N
194	SINALIZADORES DE EMERGÊNCIA, para navios	1	\N
195	SINALIZADORES DE EMERGÊNCIA, para navios	3	\N
196	SINALIZADORES DE FUMAÇA	1	\N
197	SINALIZADORES DE FUMAÇA	4	\N
203	SAIS DE SÓDIO DE NITRODERIVADOS AROMÁTICOS, N.E., explosivos	3	\N
204	DISPOSITIVOS EXPLOSIVOS DE SONDAGEM	2	\N
207	TETRANITROANILINA	1	\N
208	TRINITROFENILMETIL-NITRAMINA (TETRIL)	1	\N
209	TRINITROTOLUENO (TNT), seco ou umedecido com menos de 30% de água, em massa	1	\N
212	TRAÇANTES PARA MUNIÇÃO	3	\N
213	TRINITROANISOL	1	\N
214	TRINITROBENZENO, seco ou umedecido com menos de 30% de água, em massa	1	\N
215	ÁCIDO TRINITROBENZÓICO, seco ou umedecido com menos de 30% de água, em massa 	1	\N
216	TRINITRO-m-CRESOL	1	\N
217	TRINITRONAFTALENO	1	\N
218	TRINITROFENETOL	1	\N
219	TRINITRO-RESORCINOL (ÁCIDO ESTIFÍNICO), seco ou umedecido com menos de 20% de água, ou mistura de álcool e água, em massa	1	\N
220	NITRATO DE URÉIA, seco ou umedecido com menos de 20% de água, em massa	1	\N
221	OGIVAS DE TORPEDOS, com carga de ruptura	1	\N
222	NITRATO DE AMÔNIO, contendo mais de 0,2% de substâncias combustíveis, inclusive qualquer substância orgânica calculada como carbono, exclusive qualquer outra substância adicionada	1	\N
223	NITRATO DE AMÔNIO, FERTILIZANTE, mais suscetível a explosão que o nitrato de amônio com 0,2% de substâncias combustíveis, inclusive qualquer substância orgânica calculada como carbono,  exclusive qualquer outra substância adicionada	1	\N
224	AZIDA DE BÁRIO, seca ou umedecida  com menos de 50% de água, em massa 	1	\N
225	REFORÇADORES COM DETONADOR	1	\N
226	CICLOTETRAMETILENO TETRANITRAMINA (HMX, OCTO-GÊNIO), UMEDECIDA com, no mínimo, 15% de água, em massa	1	\N
234	DINITRO-o-CRESOLATO DE SÓDIO, seco ou umedecido com menos de 15% de água, em massa 	3	\N
235	PICRAMATO DE SÓDIO, seco ou umedecido com menos de 20% de água, em massa	3	\N
236	PICRAMATO DE ZIRCÔNIO, seco ou umedecido com menos de 20% de água, em massa	3	\N
237	CARGAS MOLDADAS, FLEXÍVEIS, LINEARES	4	\N
238	FOGUETES PARA LANÇAMENTO DE LINHA	2	\N
240	FOGUETES PARA LANÇAMENTO DE LINHA	3	\N
241	EXPLOSIVOS DE DEMOLIÇÃO, TIPO E	1	\N
242	CARGAS PROPELENTES, PARA CANHÃO	3	\N
243	MUNIÇÃO INCENDIÁRIA, À  BASE DE FÓSFORO BRANCO com ruptor, carga ejetora ou carga propelente	2	\N
244	MUNIÇÃO INCENDIÁRIA, À BASE DE FÓSFORO BRANCO com ruptor, carga ejetora ou carga propelente	3	\N
245	MUNIÇÃO FUMÍGENA, À BASE DE FÓSFORO BRANCO, com ruptor, carga ejetora ou carga propelente	2	\N
246	MUNIÇÃO FUMÍGENA, À BASE DE FÓSFORO BRANCO, com ruptor, carga ejetora ou carga propelente	3	\N
247	MUNIÇÃO INCENDIÁRIA, líquida ou gel, com ruptor, carga ejetora ou carga propelente	3	\N
248	DISPOSITIVOS ACIONÁVEIS POR ÁGUA, com ruptor, carga ejetora ou carga propelente	2	\N
249	DISPOSITIVOS ACIONÁVEIS POR ÁGUA, com ruptor, carga ejetora ou carga propelente	3	\N
250	MOTORES DE FOGUETES, CONTENDO LÍQUIDOS HIPERGÓLICOS, com ou sem carga ejetora	3	\N
254	MUNIÇÃO ILUMINANTE, com ou sem ruptor, carga ejetora ou carga propelente	3	\N
255	DETONADORES, ELÉTRICOS, para demolição	4	\N
257	ESTOPILHA DE DETONAÇÃO	4	\N
266	OCTOLITA (OCTOL), seca ou umedecida, com menos de 15% de água, em massa	1	\N
267	DETONADORES, NÃO-ELÉTRICOS, para demolição	4	\N
268	REFORÇADORES COM DETONADOR	2	\N
271	CARGAS PROPELENTES	1	\N
272	CARGAS PROPELENTES	3	\N
275	CARTUCHOS PARA DISPOSITIVO MECÂNICO	3	\N
276	CARTUCHOS PARA DISPOSITIVO MECÂNICO	4	\N
277	CARTUCHOS PARA POÇOS DE PETRÓLEO	3	\N
278	CARTUCHOS PARA POÇOS DE PETRÓLEO	4	\N
279	CARGAS PROPELENTES, PARA CANHÃO	1	\N
280	MOTORES DE FOGUETES	1	\N
281	MOTORES DE FOGUETES	2	\N
282	NITROGUANIDINA (PICRITA), seca ou umedecida, com menos de 20% de água, em massa 	1	\N
283	REFORÇADORES sem detonador	2	\N
284	GRANADAS, manuais ou para fuzil, com carga de ruptura	1	\N
285	GRANADAS, manuais ou para fuzil, com carga de ruptura	2	\N
286	OGIVAS DE FOGUETES, com carga de ruptura	1	\N
287	OGIVAS DE FOGUETES, com carga de ruptura	2	\N
288	CARGAS MOLDADAS, FLEXÍVEIS, LINEARES	1	\N
289	CORDEL DETONANTE, flexível	4	\N
290	CORDEL DETONANTE, com revestimento metálico	1	\N
291	BOMBAS com carga de ruptura	2	\N
292	GRANADAS, manuais ou para fuzil, com carga de ruptura	1	\N
293	GRANADAS, manuais ou para fuzil, com carga de ruptura	2	\N
294	MINAS, com carga de ruptura	2	\N
295	FOGUETES, com carga de ruptura	2	\N
296	DISPOSITIVOS EXPLOSIVOS DE SONDAGEM	1	\N
297	MUNIÇÃO ILUMINANTE, com ou sem ruptor, carga ejetora ou carga propelente	4	\N
299	BOMBAS FOTO-ILUMINANTES	3	\N
300	MUNIÇÃO INCENDIÁRIA, com ou sem ruptor, carga ejetora ou carga propelente	4	\N
301	MUNIÇÃO LACRIMOGÊNEA, com ruptor, carga ejetora ou carga propelente	4	\N
303	MUNIÇÃO FUMÍGENA, com ou sem ruptor, carga ejetora ou carga propelente	4	\N
305	COMPOSIÇÃO ILUMINANTE, EM PÓ	3	\N
306	TRAÇANTES PARA MUNIÇÃO	4	\N
312	CARTUCHOS PARA SINALIZAÇÃO	4	\N
313	SINALIZADORES DE FUMAÇA	2	\N
314	ACENDEDORES	2	\N
315	ACENDEDORES	3	\N
316	ESTOPILHA DE IGNIÇÃO	3	\N
317	ESTOPILHA DE IGNIÇÃO	4	\N
318	GRANADAS, PARA EXERCÍCIO, manuais ou para fuzil	3	\N
319	INICIADORES, TUBULARES	3	\N
320	INICIADORES, TUBULARES	4	\N
321	CARTUCHOS PARA ARMAS, com carga de ruptura	2	\N
322	MOTORES DE FOGUETES, CONTENDO LÍQUIDOS HIPERGÓLICOS, com ou sem carga ejetora	2	\N
323	CARTUCHOS PARA DISPOSITIVO MECÂNICO	4	\N
324	PROJÉTEIS, com carga de ruptura	2	\N
325	ACENDEDORES	4	\N
326	CARTUCHOS PARA ARMAS, FESTIM	1	\N
327	CARTUCHOS PARA ARMAS, FESTIM ou CARTUCHOS PARA  ARMAS PORTÁTEIS, FESTIM	3	\N
328	CARTUCHOS PARA ARMAS, PROJÉTEIS INERTES 	2	\N
329	TORPEDOS com carga de ruptura	1	\N
330	TORPEDOS com carga de ruptura	1	\N
331	EXPLOSIVOS DE DEMOLIÇÃO, TIPO B	5	\N
332	EXPLOSIVOS DE DEMOLIÇÃO, TIPO E	5	\N
333	FOGOS DE ARTIFÍCIO	1	\N
334	FOGOS DE ARTIFÍCIO	2	\N
335	FOGOS DE ARTIFÍCIO	3	\N
336	FOGOS DE ARTIFÍCIO	4	\N
337	FOGOS DE ARTIFÍCIO	4	\N
338	CARTUCHOS PARA ARMAS, FESTIM ou CARTUCHOS PARA ARMAS PORTÁTEIS, FESTIM	4	\N
339	CARTUCHOS PARA ARMAS, PROJÉTEIS INERTES ou CARTUCHOS PARA ARMAS, PORTÁTEIS	4	\N
340	NITROCELULOSE, seca ou umedecida com menos de 25% de água (ou álcool), em massa	1	\N
341	NITROCELULOSE, não-modificada, ou plastificada com menos de 18% de substância plastificante, em massa 	1	\N
342	NITROCELULOSE, UMEDECIDA com, no mínimo, 25% de álcool, em massa	3	\N
343	NITROCELULOSE, PLASTIFICADA  com, no mínimo, 18% de substância plastificante, em massa 	3	\N
344	PROJÉTEIS, com carga de ruptura	4	\N
345	PROJÉTEIS inertes, com traçante	4	\N
346	PROJÉTEIS, com ruptor ou carga ejetora	2	\N
347	PROJÉTEIS, com ruptor ou carga ejetora	4	\N
348	CARTUCHOS PARA ARMAS, com carga de ruptura	4	\N
349	ARTIGOS EXPLOSIVOS, N.E.	4	\N
350	ARTIGOS EXPLOSIVOS, N.E.	4	\N
351	ARTIGOS EXPLOSIVOS, N.E.	4	\N
352	ARTIGOS EXPLOSIVOS, N.E.	4	\N
353	ARTIGOS EXPLOSIVOS, N.E.	4	\N
354	ARTIGOS EXPLOSIVOS, N.E.	1	\N
355	ARTIGOS EXPLOSIVOS, N.E.	2	\N
356	ARTIGOS EXPLOSIVOS, N.E.	3	\N
357	SUBSTÂNCIAS EXPLOSIVAS, N.E.	1	\N
358	SUBSTÂNCIAS EXPLOSIVAS, N.E.	2	\N
359	SUBSTÂNCIAS EXPLOSIVAS, N.E.	3	\N
360	DETONADORES, CONJUNTOS MONTADOS, NÃO-ELÉTRICOS, para demolição	1	\N
361	DETONADORES, CONJUNTOS MONTADOS, NÃO-ELÉTRICOS, para demolição	4	\N
362	MUNIÇÃO PARA EXERCÍCIO	4	\N
363	MUNIÇÃO PARA PROVA	4	\N
364	DETONADORES PARA MUNIÇÃO	2	\N
365	DETONADORES PARA MUNIÇÃO	4	\N
366	DETONADORES PARA MUNIÇÃO	4	\N
367	ESTOPILHA DE DETONAÇÃO	4	\N
368	ESTOPILHA DE IGNIÇÃO	4	\N
369	OGIVAS DE FOGUETES, com carga de ruptura	1	\N
370	OGIVAS DE FOGUETES, com ruptor ou carga ejetora	4	\N
371	OGIVAS DE FOGUETES, com ruptor ou carga ejetora	4	\N
372	GRANADAS, PARA EXERCÍCIO, manuais ou para fuzil	2	\N
373	SINALIZADORES MANUAIS	4	\N
374	DISPOSITIVOS EXPLOSIVOS DE SONDAGEM	1	\N
375	DISPOSITIVOS EXPLOSIVOS DE SONDAGEM	2	\N
376	INICIADORES, TUBULARES	4	\N
377	INICIADORES, TIPO CÁPSULA	1	\N
378	INICIADORES, TIPO CÁPSULA	4	\N
379	ESTOJOS DE CARTUCHOS, VAZIOS, COM INICIADOR	4	\N
380	ARTIGOS PIROFÓRICOS	2	\N
381	CARTUCHOS PARA DISPOSITIVO MECÂNICO	2	\N
382	EXPLOSIVOS, COMPONENTES DE CADEIA, N.E.	2	\N
383	EXPLOSIVOS, COMPONENTES DE CADEIA, N.E.      	4	\N
384	EXPLOSIVOS, COMPONENTES DE CADEIA, N.E.	4	\N
385	5-NITROBENZOTRIAZOL	1	\N
386	ÁCIDO TRINITROBENZENOSSULFÔNICO	1	\N
387	TRINITROFLUORENONA	1	\N
388	MISTURA(S) DE TRINITROTOLUENO (TNT) E TRINITRO-BENZENO, ou DE TRINITROTOLUENO E HEXANITRO-ESTILBENO	1	\N
389	MISTURA(S) DE TRINITROTOLUENO (TNT), CONTENDO TRINITROBENZENO E HEXANITROESTILBENO	1	\N
390	TRITONAL	1	\N
391	CICLOTRIMETILENOTRINITRAMINA (CICLONITA; HEXOGÊ-NIO; RDX) E CICLOTETRAMETILENOTETRANITRAMINA (HMX; OCTOGÊNIO), MISTURAS UMEDECIDAS com, no mínimo 15% de água, em massa, ou INSENSIBILIZADAS com, no mínimo, 10% de dessensibilizante, em massa	1	\N
392	HEXANITROESTILBENO	1	\N
393	HEXATONAL, FUNDIDO	1	\N
394	TRINITRO-RESORCINOL (ÁCIDO ESTIFÍNICO) UMEDECIDO com, no mínimo, 20% de água, ou mistura de álcool e água, em massa 	1	\N
395	MOTORES DE FOGUETES, COM COMBUSTÍVEL LÍQUIDO	2	\N
396	MOTORES DE FOGUETES, COM COMBUSTÍVEL LÍQUIDO	3	\N
397	FOGUETES, COM COMBUSTÍVEL LÍQUIDO, com carga de ruptura 	1	\N
398	FOGUETES, COM COMBUSTÍVEL LÍQUIDO, com carga de ruptura	2	\N
399	BOMBAS COM LÍQUIDO INFLAMÁVEL, com carga de ruptura	1	\N
400	BOMBAS COM LÍQUIDO INFLAMÁVEL, com carga de ruptura	2	\N
401	SULFETO DE DIPICRILA, seco ou umedecido com menos de 10% de água,  em massa	1	\N
402	PERCLORATO DE AMÔNIO	1	\N
403	FACHOS DE SINALIZAÇÃO, AÉREOS	4	\N
404	FACHOS DE SINALIZAÇÃO, AÉREOS	4	\N
405	CARTUCHOS PARA SINALIZAÇÃO	4	\N
406	DINITROSOBENZENO	3	\N
407	ÁCIDO TETRAZOL-1-ACÉTICO	4	\N
408	ESTOPILHA DE DETONAÇÃO, com dispositivo de proteção	1	\N
409	ESTOPILHA DE DETONAÇÃO, com dispositivo de proteção	2	\N
410	ESTOPILHA DE DETONAÇÃO, com dispositivo de proteção	4	\N
411	TETRANITRATO DE PENTAERITRITA (TETRANITRATO DE PENTAERITRITOL;  PETN) com, no mínimo, 7% de cera, em massa 	1	\N
412	CARTUCHOS PARA ARMAS, com carga de ruptura	4	\N
413	CARTUCHOS PARA ARMAS, FESTIM	2	\N
414	CARGAS PROPELENTES, PARA CANHÃO	2	\N
415	CARGAS PROPELENTES	2	\N
417	CARTUCHOS PARA ARMAS, PROJÉTEIS INERTES ou CARTUCHOS PARA ARMAS PORTÁTEIS	3	\N
418	FACHOS DE SINALIZAÇÃO, DE SUPERFÍCIE	1	\N
419	FACHOS DE SINALIZAÇÃO, DE SUPERFÍCIE	2	\N
420	FACHOS DE SINALIZAÇÃO, AÉREOS	1	\N
421	FACHOS DE SINALIZAÇÃO, AÉREOS	2	\N
424	PROJÉTEIS inertes, com traçante    	3	\N
425	PROJÉTEIS inertes, com traçante	4	\N
426	PROJÉTEIS, com ruptor ou carga ejetora	2	\N
427	PROJÉTEIS, com ruptor ou carga ejetora	4	\N
428	ARTIGOS PIROTÉCNICOS, para fins técnicos	1	\N
429	ARTIGOS PIROTÉCNICOS, para fins técnicos	2	\N
430	ARTIGOS PIROTÉCNICOS, para fins técnicos	3	\N
431	ARTIGOS PIROTÉCNICOS, para fins técnicos	4	\N
432	ARTIGOS PIROTÉCNICOS, para fins técnicos	4	\N
433	PÓLVORA EM PASTA, UMEDECIDA com no mínimo 17% de álcool, em massa	1	\N
434	PROJÉTEIS, com ruptor ou carga ejetora	2	\N
435	PROJÉTEIS, com ruptor ou carga ejetora	4	\N
436	FOGUETES, com carga ejetora	2	\N
437	FOGUETES, com carga ejetora	3	\N
438	FOGUETES, com carga ejetora	4	\N
439	CARGAS MOLDADAS, COMERCIAIS, sem detonador	2	\N
440	CARGAS MOLDADAS, COMERCIAIS, sem detonador	4	\N
441	CARGAS MOLDADAS, COMERCIAIS, sem detonador	4	\N
442	CARGAS EXPLOSIVAS, COMERCIAIS, sem detonador	1	\N
443	CARGAS EXPLOSIVAS, COMERCIAIS, sem detonador	2	\N
444	CARGAS EXPLOSIVAS, COMERCIAIS, sem detonador	4	\N
445	CARGAS EXPLOSIVAS, COMERCIAIS, sem detonador	4	\N
446	ESTOJOS COMBUSTÍVEIS, VAZIOS, SEM INICIADOR	4	\N
447	ESTOJOS COMBUSTÍVEIS, VAZIOS, SEM INICIADOR	3	\N
448	ÁCIDO 5-MERCAPTOTETRAZOL-1-ACÉTICO	4	\N
449	TORPEDOS, COM COMBUSTÍVEL LÍQUIDO, com ou sem carga de ruptura	1	\N
450	TORPEDOS, COM COMBUSTÍVEL LÍQUIDO, com ogiva inerte	3	\N
451	TORPEDOS com carga de ruptura	1	\N
452	GRANADAS, PARA EXERCÍCIO, manuais ou para fuzil	4	\N
453	FOGUETES PARA LANÇAMENTO DE LINHA	4	\N
454	ACENDEDORES	4	\N
455	DETONADORES, NÃO-ELÉTRICOS, para demolição	4	\N
456	DETONADORES, ELÉTRICOS, para demolição	4	\N
457	CARGAS DE RUPTURA, COM AGLUTINANTE PLÁSTICO	1	\N
458	CARGAS DE RUPTURA, COM AGLUTINANTE PLÁSTICO	2	\N
459	CARGAS DE RUPTURA, COM AGLUTINANTE PLÁSTICO	4	\N
460	CARGAS DE RUPTURA, COM AGLUTINANTE PLÁSTICO	4	\N
461	EXPLOSIVOS, COMPONENTES DE CADEIA, N.E.	1	\N
462	ARTIGOS EXPLOSIVOS, N.E.	1	\N
463	ARTIGOS EXPLOSIVOS, N.E.	1	\N
464	ARTIGOS EXPLOSIVOS, N.E.	1	\N
465	ARTIGOS EXPLOSIVOS, N.E.	1	\N
466	ARTIGOS EXPLOSIVOS, N.E.	2	\N
467	ARTIGOS EXPLOSIVOS, N.E.	2	\N
468	ARTIGOS EXPLOSIVOS, N.E.	2	\N
469	ARTIGOS EXPLOSIVOS, N.E.	2	\N
470	ARTIGOS EXPLOSIVOS, N.E.	3	\N
471	ARTIGOS EXPLOSIVOS, N.E.	4	\N
472	ARTIGOS EXPLOSIVOS, N.E.	4	\N
473	SUBSTÂNCIAS EXPLOSIVAS, N.E.	1	\N
474	SUBSTÂNCIAS EXPLOSIVAS, N.E.	1	\N
475	SUBSTÂNCIAS EXPLOSIVAS, N.E.	1	\N
476	SUBSTÂNCIAS EXPLOSIVAS, N.E.	1	\N
477	SUBSTÂNCIAS EXPLOSIVAS, N.E.	3	\N
478	SUBSTÂNCIAS EXPLOSIVAS, N.E.	3	\N
479	SUBSTÂNCIAS EXPLOSIVAS, N.E.	4	\N
480	SUBSTÂNCIAS EXPLOSIVAS, N.E.	4	\N
481	SUBSTÂNCIAS EXPLOSIVAS, N.E.	4	\N
482	SUBSTÂNCIAS EXPLOSIVAS, MUITO INSENSÍVEIS, N.E.	5	\N
483	CICLOTRIMETILENOTRINITRAMINA (CICLONITA; HEXOGÊ- NIO; RDX), INSENSIBILIZADA 	1	\N
484	CICLOTETRAMETILENO TETRANITRAMINA (OCTOGÊNIO, HMX), INSENSIBILIZADA	1	\N
485	SUBSTÂNCIAS EXPLOSIVAS, N.E.	4	\N
486	ARTIGOS EXPLOSIVOS, EXTREMAMENTE INSENSÍVEIS	6	\N
487	SINALIZADORES DE FUMAÇA	3	\N
488	MUNIÇÃO PARA EXERCÍCIO	3	\N
489	DINITROGLICOLURILA(DINGU)	1	\N
490	NITROTRIAZOLONA (NTO)	1	\N
491	CARGAS PROPELENTES	4	\N
492	SINALIZADORES EXPLOSIVOS PARA VIAS FÉRREAS	3	\N
493	SINALIZADORES EXPLOSIVOS PARA VIAS FÉRREAS	4	\N
494	CANHÕES PARA JATO-PERFURAÇÃO em poços de petróleo, CARREGADOS, sem detonador	4	\N
1001	ACETILENO, DISSOLVIDO	7	\N
1002	AR COMPRIMIDO	8	\N
1003	AR, LÍQUIDO REFRIGERADO	8	\N
1005	AMÔNIA, ANIDRA, LIQUEFEITA, ou AMÔNIA  EM SOLUÇÃO aquosa, com densidade relativa inferior a 0,880 a 15ºC, com mais de 50% de amônia	9	\N
1006	ARGÔNIO, COMPRIMIDO	8	\N
1008	TRIFLUORETO DE BORO	9	\N
1009	BROMOTRIFLUORMETANO	8	\N
1010	BUTADIENOS, INIBIDOS	7	\N
1011	BUTANO ou MISTURAS DE BUTANO	7	\N
1012	BUTENO	7	\N
1013	DIÓXIDO DE CARBONO	8	\N
1014	MISTURA(S) DE OXIGÊNIO E DIÓXIDO DE CARBONO	8	\N
1015	MISTURA(S) DE DIÓXIDO DE CARBONO E ÓXIDO NITROSO	8	\N
1016	MONÓXIDO DE CARBONO	9	\N
1017	CLORO	9	\N
1018	CLORODIFLUORMETANO	8	\N
1020	CLOROPENTAFLUORETANO	8	\N
1021	1-CLORO-1,2,2,2-TETRAFLUORETANO	8	\N
1022	CLOROTRIFLUORMETANO	8	\N
1023	GÁS DE CARVÃO	9	\N
1026	CIANOGÊNIO, LIQUEFEITO	9	\N
1027	CICLOPROPANO, LIQUEFEITO	7	\N
1028	DICLORODIFLUORMETANO	8	\N
1029	DICLOROFLUORMETANO	8	\N
1030	DIFLUORETANO	7	\N
1032	DIMETILAMINA, ANIDRA	7	\N
1033	ÉTER DIMETÍLICO	7	\N
1035	ETANO, COMPRIMIDO	7	\N
1036	ETILAMINA	7	\N
1037	CLORETO DE ETILA	7	\N
1038	ETENO, LÍQUIDO REFRIGERADO	7	\N
1039	ÉTER ETILMETÍLICO	7	\N
1040	ÓXIDO DE ETENO, puro ou com nitrogênio	9	\N
1041	MISTURA(S) DE DIÓXIDO DE CARBONO E ÓXIDO DE ETENO, com mais de 6% de óxido de eteno	9	\N
1043	FERTILIZANTE, EM SOLUÇÃO AMONIACAL, contendo amônia livre	8	\N
1044	EXTINTOR DE INCÊNDIO, contendo gás comprimido ou liquefeito	8	\N
1045	FLÚOR, COMPRIMIDO	9	\N
1046	HÉLIO, COMPRIMIDO	8	\N
1048	BROMETO DE HIDROGÊNIO, ANIDRO	9	\N
1049	HIDROGÊNIO, COMPRIMIDO	7	\N
1050	CLORETO DE HIDROGÊNIO, ANIDRO	9	\N
1051	ÁCIDO CIANÍDRICO, ANIDRO, ESTABILIZADO	16	\N
1052	FLUORETO DE HIDROGÊNIO, ANIDRO	19	\N
1053	SULFETO DE HIDROGÊNIO, LIQUEFEITO	9	\N
1055	ISOBUTILENO	7	\N
1056	CRIPTÔNIO, COMPRIMIDO	8	\N
1057	ISQUEIROS ou CARGAS PARA ISQUEIROS (cigarros), contendo gás inflamável	7	\N
1058	GÁS LIQUEFEITO, não-inflamável, contendo nitrogênio, dióxido  de carbono ou ar	8	\N
1060	MISTURA(S) DE METILACETILENO E PROPADIENO, ESTABILIZADA(S)	7	\N
1061	METILAMINA, ANIDRA	7	\N
1062	BROMETO DE METILA	9	\N
1063	CLORETO DE METILA	7	\N
1064	METILMERCAPTANA	9	\N
1065	NEÔNIO, COMPRIMIDO	8	\N
1066	NITROGÊNIO, COMPRIMIDO	8	\N
1067	TETRÓXIDO DE DINITROGÊNIO (DIÓXIDO DE NITROGÊNIO), LIQUEFEITO	9	\N
1069	CLORETO DE NITROSILA	9	\N
1070	ÓXIDO NITROSO, COMPRIMIDO	8	\N
1071	GÁS DE ÓLEO	7	\N
1072	OXIGÊNIO, COMPRIMIDO	8	\N
1073	OXIGÊNIO, LÍQUIDO REFRIGERADO	8	\N
1075	GÁS LIQUEFEITO DE PETRÓLEO	7	\N
1076	FOSGÊNIO	9	\N
1077	PROPENO	7	\N
1078	GÁS REFRIGERANTE, N.E.	8	\N
1079	DIÓXIDO DE ENXOFRE, LIQUEFEITO	9	\N
1080	HEXAFLUORETO DE ENXOFRE	8	\N
1081	TETRAFLUORETENO, INIBIDO	7	\N
1082	TRIFLUORCLOROETENO, INIBIDO	7	\N
1083	TRIMETILAMINA, ANIDRA	7	\N
1085	BROMETO DE VINILA, INIBIDO	7	\N
1086	CLORETO DE VINILA, INIBIDO	7	\N
1087	ÉTER METILVINÍLICO, INIBIDO	7	\N
1088	ACETAL	10	\N
1089	ACETALDEÍDO	10	\N
1090	ACETONA	10	\N
1091	ÓLEOS DE ACETONA	10	\N
1092	ACROLEÍNA, INIBIDA	16	\N
1093	ACRILONITRILA, INIBIDA	10	\N
1098	ÁLCOOL ALÍLICO	16	\N
1099	BROMETO DE ALILA	10	\N
1100	CLORETO DE ALILA	10	\N
1104	ACETATO(S) DE AMILA	10	\N
1105	ÁLCOOL(IS) AMÍLICO(S)	10	\N
1106	AMILAMINA	10	\N
1107	CLORETO DE AMILA	10	\N
1108	n-AMILENO	10	\N
1109	FORMIATO(S) DE AMILA	10	\N
1110	AMILMETILCETONA	10	\N
1111	AMILMERCAPTANA	10	\N
1112	NITRATO DE AMILA	10	\N
1113	NITRITO DE AMILA	10	\N
1114	BENZENO	10	\N
1118	FLUIDO PARA FREIO, hidráulico	10	\N
1120	BUTANÓIS	10	\N
1123	ACETATO(S) DE BUTILA	10	\N
1125	n-BUTILAMINA	10	\N
1126	BROMETO DE n-BUTILA	10	\N
1127	CLOROBUTANOS	10	\N
1128	FORMIATO DE n-BUTILA	10	\N
1129	BUTIRALDEÍDO	10	\N
1130	ÓLEO DE CÂNFORA	10	\N
1131	DISSULFETO DE CARBONO	10	\N
1133	ADESIVOS, contendo líquido inflamável	10	\N
1134	CLOROBENZENO	10	\N
1135	ETILENOCLORIDRINA	16	\N
1136	DESTILADOS DE ALCATRÃO DE HULHA, INFLAMÁVEIS	10	\N
1139	REVESTIMENTO, SOLUÇÃO PARA	10	\N
1143	CROTONALDEÍDO, ESTABILIZADO	10	\N
1144	CROTONILENO	10	\N
1145	CICLO-HEXANO	10	\N
1146	CICLOPENTANO	10	\N
1147	DECA-HIDRONAFTALENO	10	\N
1148	DIACETONA ÁLCOOL	10	\N
1149	ÉTER(ES) DIBUTÍLICO(S)	10	\N
1150	DICLOROETENO	10	\N
1152	DICLOROPENTANOS	10	\N
1153	ÉTER DIETÍLICO DE ETILENOGLICOL	10	\N
1154	DIETILAMINA	10	\N
1155	ÉTER DIETÍLICO (ÉTER ETÍLICO)	10	\N
1156	DIETILCETONA	10	\N
1157	DIISOBUTILCETONA	10	\N
1158	DIISOPROPILAMINA	10	\N
1159	ÉTER DIISOPROPÍLICO	10	\N
1160	DIMETILAMINA, SOLUÇÃO	10	\N
1161	CARBONATO DE DIMETILA	10	\N
1162	DIMETILDICLOROSSILANO	10	\N
1163	DIMETIL-HIDRAZINA, ASSIMÉTRICA	16	\N
1164	SULFETO DE DIMETILA	10	\N
1165	DIOXANO	10	\N
1166	DIOXOLANO	10	\N
1167	ÉTER DIVINÍLICO, INIBIDO	10	\N
1169	EXTRATOS AROMÁTICOS, LÍQUIDOS	10	\N
1170	ETANOL (ÁLCOOL ETÍLICO) ou SOLUÇÕES DE ETANOL (SOLUCÕES DE ÁLCOOL ETÍLICO)	10	\N
1171	ÉTER MONOETÍLICO DE ETILENOGLICOL	10	\N
1172	ACETATO DE ÉTER MONOETÍLICO DE ETILENOGLICOL	10	\N
1173	ACETATO DE ETILA	10	\N
1175	ETILBENZENO	10	\N
1176	BORATO DE ETILA	10	\N
1177	ACETATO DE ETILBUTILA	10	\N
1178	2-ETILBUTIRALDEÍDO	10	\N
1179	ÉTER ETILBUTÍLICO	10	\N
1180	BUTIRATO DE ETILA	10	\N
1181	CLOROACETATO DE ETILA	16	\N
1182	CLOROFORMIATO DE ETILA	16	\N
1183	ETILDICLOROSSILANO	13	\N
1184	DICLORETO DE ETILENO	10	\N
1185	ETILENOIMINA, INIBIDA	16	\N
1188	ÉTER MONOMETÍLICO DE ETILENOGLICOL	10	\N
1189	ACETATO DE ÉTER MONOMETÍLICO  DE   ETILENOGLICOL	10	\N
1190	FORMIATO DE ETILA	10	\N
1191	ALDEÍDOS OCTÍLICOS, inflamáveis	10	\N
1192	LACTATO DE ETILA	10	\N
1193	ETILMETILCETONA (METILETILCETONA)	10	\N
1194	NITRITO DE ETILA, SOLUÇÕES	10	\N
1195	PROPIONATO DE ETILA	10	\N
1196	ETILTRICLOROSSILANO	10	\N
1197	EXTRATOS, AROMATIZANTES, LÍQUIDOS	10	\N
1198	FORMALDEÍDO, SOLUÇÕES, INFLAMÁVEIS	10	\N
1199	FURFURAL	10	\N
1201	ÓLEO DE FUSEL	10	\N
1202	GASÓLEO	10	\N
1203	COMBUSTÍVEL PARA MOTORES, inclusive GASOLINA	10	\N
1204	NITROGLICERINA, EM SOLUÇÃO ALCOÓLICA, com até 1% de nitroglicerina	10	\N
1206	HEPTANOS	10	\N
1207	HEXALDEÍDO	10	\N
1208	HEXANOS	10	\N
1210	TINTA PARA IMPRESSÃO, inflamável	10	\N
1212	ISOBUTANOL (ÁLCOOL ISOBUTÍLICO)	10	\N
1213	ACETATO DE ISOBUTILA	10	\N
1214	ISOBUTILAMINA	10	\N
1216	ISOOCTENO	10	\N
1218	ISOPRENO, INIBIDO	10	\N
1219	ISOPROPANOL (ÁLCOOL ISOPROPÍLICO)	10	\N
1220	ACETATO DE ISOPROPILA	10	\N
1221	ISOPROPILAMINA	10	\N
1222	NITRATO DE ISOPROPILA	10	\N
1223	QUEROSENE	10	\N
1224	CETONAS, LÍQUIDAS, N.E.	10	\N
1228	MERCAPTANAS, LÍQUIDAS, N.E., ou MISTURAS DE MERCAPTANAS, LÍQUIDAS, N.E., com PFg inferior a 23ºC	10	\N
1229	ÓXIDO DE MESITILA	10	\N
1230	METANOL (ÁLCOOL METÍLICO)	10	\N
1231	ACETATO DE METILA	10	\N
1233	ACETATO DE METILAMILA	10	\N
1234	METILAL	10	\N
1235	METILAMINA, SOLUÇÃO AQUOSA	10	\N
1237	BUTIRATO DE METILA	10	\N
1238	CLOROFORMIATO DE METILA	16	\N
1239	ÉTER METILCLOROMETÍLICO	16	\N
1242	METILDICLOROSSILANO	13	\N
1243	FORMIATO DE METILA	10	\N
1244	METIL-HIDRAZINA	16	\N
1245	METILISOBUTILCETONA	10	\N
1246	METILISOPROPENILCETONA, INIBIDA	10	\N
1247	METACRILATO DE METILA, MONÔMERO, INIBIDO	10	\N
1248	PROPIONATO DE METILA	10	\N
1249	METILPROPILCETONA	10	\N
1250	METILTRICLOROSSILANO	10	\N
1251	METILVINILCETONA	10	\N
1255	NAFTA, de petróleo	10	\N
1256	NAFTA, solvente	10	\N
1257	GASOLINA NATURAL	10	\N
1259	NIQUELCARBONILA	16	\N
1261	NITROMETANO	10	\N
1262	OCTANOS	10	\N
1263	TINTA (incluindo tintas, lacas, esmaltes, tinturas, goma-lacas, vernizes, polidores, enchimentos líquidos e bases líquidas para lacas) ou MATERIAL RELACIONADO COM TINTAS (incluindo  diluentes ou redutores para tintas)	10	\N
1264	PARALDEÍDO	10	\N
1265	n-PENTANO ou ISOPENTANO	10	\N
1266	PERFUMARIA, PRODUTOS contendo solventes inflamáveis	10	\N
1267	PETRÓLEO CRU	10	\N
1268	DESTILADOS DE PETRÓLEO, N.E.	10	\N
1270	PETRÓLEO, ÓLEO	10	\N
1271	ÉTER DE PETRÓLEO	10	\N
1272	ÓLEO DE PINHO	10	\N
1274	n-PROPANOL (ÁLCOOL PROPÍLICO NORMAL)	10	\N
1275	PROPIONALDEÍDO	10	\N
1276	ACETATO DE n-PROPILA	10	\N
1277	PROPILAMINA	10	\N
1278	CLORETO DE PROPILA	10	\N
1279	DICLOROPROPILENO	10	\N
1280	ÓXIDO DE PROPENO	10	\N
1281	FORMIATOS DE PROPILA	10	\N
1282	PIRIDINA	10	\N
1286	ÓLEO DE RESINA	10	\N
1287	BORRACHA, EM SOLUÇÃO	10	\N
1288	ÓLEO DE XISTO	10	\N
1289	METILATO DE SÓDIO, SOLUÇÕES alcoólicas	10	\N
1292	SILICATO DE TETRAETILA	10	\N
1293	TINTURAS, MEDICINAIS	10	\N
1294	TOLUENO	10	\N
1295	TRICLOROSSILANO	13	\N
1296	TRIETILAMINA	10	\N
1297	TRIMETILAMINA, SOLUÇÕES AQUOSAS, com até 50% de trimetilamina, em massa	10	\N
1298	TRIMETILCLOROSSILANO	10	\N
1299	TEREBENTINA	10	\N
1300	TEREBENTINA, SUBSTITUTOS	10	\N
1301	ACETATO DE VINILA, INIBIDO	10	\N
1302	ÉTER ETILVINÍLICO, INIBIDO	10	\N
1303	CLORETO DE VINILIDENO, INIBIDO	10	\N
1304	ÉTER ISOBUTILVINÍLICO, INIBIDO	10	\N
1305	VINILTRICLOROSSILANO	10	\N
1306	PRESERVATIVOS PARA MADEIRA, LÍQUIDOS	10	\N
1307	XILENOS	10	\N
1308	ZIRCÔNIO, SUSPENSÃO EM LÍQUIDO	10	\N
1309	ALUMÍNIO, EM PÓ, REVESTIDO	11	\N
1310	PICRATO DE AMÔNIO, UMEDECIDO com, no mínimo, 10% de água, em massa	11	\N
1312	BORNEOL	11	\N
1313	RESINATO DE CÁLCIO	11	\N
1314	RESINATO DE CÁLCIO, FUNDIDO	11	\N
1318	RESINATO DE COBALTO, PRECIPITADO	11	\N
1320	DINITROFENOL, UMEDECIDO com, no mínimo, 15% de água, em massa	11	\N
1321	DINITROFENOLATOS, UMEDECIDOS com, no mínimo, 15% de água, em massa	11	\N
1322	DINITRO-RESORCINOL, UMEDECIDO com, no mínimo, 15% de água, em massa	11	\N
1323	FERROCÉRIO	11	\N
1324	FILMES, À BASE DE NITROCELULOSE, revestidos de gelatina, exceto refugos	11	\N
1325	SÓLIDO INFLAMÁVEL, ORGÂNICO, N.E.	11	\N
1326		11	\N
1327	FENO ou PALHA, umedecido, encharcado ou contaminado com óleo	11	\N
1328	HEXAMINA	11	\N
1330	RESINATO DE MANGANÊS	11	\N
1331	FÓSFOROS, "RISQUE EM QUALQUER LUGAR"	11	\N
1332	METALDEÍDO	11	\N
1333	CÉRIO, chapas, lingotes ou barras	11	\N
1334	NAFTALENO, BRUTO ou REFINADO	11	\N
1336	NITROGUANIDINA (PICRITA), UMEDECIDA com, no mínimo, 20% de água, em massa	11	\N
1337	NITROAMIDO, UMEDECIDO com, no mínimo, 20% de água, em massa	11	\N
1338	FÓSFORO, AMORFO	11	\N
1339	HEPTASSULFETO DE FÓSFORO, isento de fósforo amarelo e branco	11	\N
1476	PERÓXIDO DE MAGNÉSIO	14	\N
1340	PENTASSULFETO DE FÓSFORO, isento de fósforo amarelo e branco	13	\N
1341	SESQUISSULFETO DE FÓSFORO, isento de fósforo amarelo e branco	11	\N
1343	TRISSULFETO DE FÓSFORO, isento de fósforo amarelo e branco	11	\N
1344	TRINITROFENOL, UMEDECIDO com, no mínimo, 30% de água, em massa	11	\N
1345	BORRACHA, RASPAS, APARAS ou REFUGOS, em pó ou em grãos de até 840 micra, contendo mais de 45% de borracha	11	\N
1346	SILÍCIO, EM PÓ, AMORFO	11	\N
1347	PICRATO DE PRATA, UMEDECIDO com, no mínimo, 30% de água, em massa 	11	\N
1348	DINITRO-o-CRESOLATO DE SÓDIO, UMEDECIDO com, no mínimo, 15% de água, em massa	11	\N
1349	PICRAMATO DE SÓDIO, UMEDECIDO com, no mínimo, 20% de água, em massa	11	\N
1350	ENXOFRE	11	\N
1352		11	\N
1353	FIBRAS ou TECIDOS, IMPREGNADOS COM NITROCELULOSE  FRACAMENTE NITRADA, N.E. 	11	\N
1354	TRINITROBENZENO, UMEDECIDO com, no mínimo, 30% de  água, em massa	11	\N
1355	ÁCIDO TRINITROBENZÓICO, UMEDECIDO com  30% ou mais de água, em massa 	11	\N
1356	TRINITROTOLUENO, UMEDECIDO com, no mínimo, 30% de água, em massa 	11	\N
1357	NITRATO DE URÉIA, UMEDECIDO com, no mínimo, 20% de água, em massa 	11	\N
1358		11	\N
1360	FOSFETO DE CÁLCIO	13	\N
1361	CARVÃO, de origem animal ou vegetal	12	\N
1362	CARVÃO ATIVADO	12	\N
1363	COPRA	12	\N
1364	ALGODÃO, RESÍDUOS OLEOSOS	12	\N
1365	ALGODÃO, ÚMIDO	12	\N
1366	DIETILZINCO	12	\N
1369	p-NITROSODIMETILANILINA	12	\N
1370	DIMETILZINCO	12	\N
1373	FIBRAS ou TECIDOS, ANIMAIS ou VEGETAIS, ou SINTÉTICOS, N.E. com óleo 	12	\N
1374	FARINHA DE PEIXE (RESTOS DE PEIXE), NÃO-ESTABILIZADA	12	\N
1376	ÓXIDO DE FERRO, USADO, ou FERRO-ESPONJA, USADO, obtido da purificação de gás de carvão	12	\N
1378	CATALISADOR METÁLICO UMEDECIDO, com visível excesso de líquido 	12	\N
1379	PAPEL, TRATADO COM ÓLEO NÃO-SATURADO, úmido (inclusive papel carbono)	12	\N
1380	PENTABORANA	12	\N
1381	FÓSFORO BRANCO ou AMARELO, SECO ou SOB ÁGUA ou EM SOLUÇÃO	12	\N
1382	SULFETO DE POTÁSSIO, ANIDRO ou SULFETO DE POTÁSSIO com menos de 30% de água de cristalização	12	\N
1383	METAIS PIROFÓRICOS, N.E. ou LIGAS PIROFÓRICAS, N.E.	12	\N
1384	DITIONITO DE SÓDIO (HIDROSSULFITO DE SÓDIO)	12	\N
1385	SULFETO DE SÓDIO, ANIDRO ou SULFETO DE SÓDIO com menos de 30% de água de cristalização	12	\N
1386	TORTAS OLEAGINOSAS com mais de 1,5% de óleo e até 11% de umidade	12	\N
1389	AMÁLGAMAS DE METAIS ALCALINOS	13	\N
1390	AMIDAS DE METAIS ALCALINOS	13	\N
1391	METAIS ALCALINOS, DISPERSÕES, ou METAIS ALCALINO-TERROSOS, DISPERSÕES	13	\N
1392	AMÁLGAMAS DE METAIS ALCALINO-TERROSOS	13	\N
1393	LIGAS DE METAIS ALCALINO-TERROSOS, N.E.	13	\N
1394	CARBURETO DE ALUMÍNIO	13	\N
1395	ALUMÍNIO-FERRO-SILÍCIO, EM PÓ	13	\N
1396	ALUMÍNIO, EM PÓ, NÃO-REVESTIDO	13	\N
1397	FOSFETO DE ALUMÍNIO	13	\N
1398	ALUMÍNIO-SILÍCIO, EM PÓ, NÃO-REVESTIDO	13	\N
1400	BÁRIO	13	\N
1401	CÁLCIO	13	\N
1402	CARBURETO DE CÁLCIO	13	\N
1403	CIANAMIDA CÁLCICA, contendo mais de 0,1% de carbureto de cálcio 	13	\N
1404	HIDRETO DE CÁLCIO	13	\N
1405	SILICIETO DE CÁLCIO	13	\N
1407	CÉSIO	13	\N
1408	FERRO-SILÍCIO com 30% ou mais de silício, mas menos de 90%	13	\N
1409	HIDRETOS METÁLICOS, QUE REAGEM COM ÁGUA, N.E.	13	\N
1410	HIDRETO DUPLO DE LÍTIO E ALUMÍNIO	13	\N
1411	HIDRETO DUPLO DE LÍTIO E ALUMÍNIO, EM ÉTER	13	\N
1413	BORO-HIDRETO DE LÍTIO	13	\N
1414	HIDRETO DE LÍTIO	13	\N
1415	LÍTIO	13	\N
1417	LÍTIO-SILÍCIO	13	\N
1418	MAGNÉSIO, EM PÓ, ou LIGAS DE MAGNÉSIO, EM PÓ	13	\N
1419	FOSFETO DUPLO DE MAGNÉSIO E ALUMÍNIO	13	\N
1420	LIGAS DE POTÁSSIO, METÁLICAS	13	\N
1421	LIGAS DE METAIS ALCALINOS, LÍQUIDAS, N.E.	13	\N
1422	LIGAS DE POTÁSSIO E SÓDIO	13	\N
1423	RUBÍDIO	13	\N
1426	BORO-HIDRETO DE SÓDIO	13	\N
1427	HIDRETO DE SÓDIO	13	\N
1428	SÓDIO	13	\N
1431	METILATO DE SÓDIO	12	\N
1432	FOSFETO DE SÓDIO	13	\N
1433	FOSFETOS ESTÂNICOS	13	\N
1435	ZINCO, CINZAS	13	\N
1436	ZINCO, EM PÓ	13	\N
1437	HIDRETO DE ZIRCÔNIO	11	\N
1438	NITRATO DE ALUMÍNIO	14	\N
1439	DICROMATO DE AMÔNIO	14	\N
1442	PERCLORATO DE AMÔNIO	14	\N
1444	PERSULFATO DE AMÔNIO	14	\N
1445	CLORATO DE BÁRIO	14	\N
1446	NITRATO DE BÁRIO	14	\N
1447	PERCLORATO DE BÁRIO	14	\N
1448	PERMANGANATO DE BÁRIO	14	\N
1449	PERÓXIDO DE BÁRIO	14	\N
1450	BROMATOS INORGÂNICOS, N.E.	14	\N
1451	NITRATO DE CÉSIO	14	\N
1452	CLORATO DE CÁLCIO	14	\N
1453	CLORITO DE CÁLCIO	14	\N
1454	NITRATO DE CÁLCIO	14	\N
1455	PERCLORATO DE CÁLCIO	14	\N
1456	PERMANGANATO DE CÁLCIO	14	\N
1457	PERÓXIDO DE CÁLCIO	14	\N
1458	MISTURAS(S) DE CLORATO E BORATO	14	\N
1459	MISTURA(S) DE CLORETO DE MAGNÉSIO E CLORATO	14	\N
1461	CLORATOS, INORGÂNICOS, N.E.	14	\N
1462	CLORITOS, INORGÂNICOS, N.E.	14	\N
1463	TRIÓXIDO DE CROMO, ANIDRO	14	\N
1465	NITRATO DE DIDÍMIO	14	\N
1466	NITRATO FÉRRICO	14	\N
1467	NITRATO DE GUANIDINA	14	\N
1469	NITRATO DE CHUMBO	14	\N
1470	PERCLORATO DE CHUMBO	14	\N
1471	HIPOCLORITO DE LÍTIO, SECO, ou MISTURAS DE HIPOCLORITO DE LÍTIO	14	\N
1472	PERÓXIDO DE LÍTIO	14	\N
1473	BROMATO DE MAGNÉSIO	14	\N
1474	NITRATO DE MAGNÉSIO	14	\N
1475	PERCLORATO DE MAGNÉSIO	14	\N
1477	NITRATOS INORGÂNICOS, N.E.	14	\N
1479	SÓLIDO OXIDANTE, N.E.	14	\N
1481	PERCLORATOS INORGÂNICOS, N.E.	14	\N
1482	PERMANGANATOS INORGÂNICOS, N.E.	14	\N
1483	PERÓXIDOS INORGÂNICOS, N.E.	14	\N
1484	BROMATO DE POTÁSSIO	14	\N
1485	CLORATO DE POTÁSSIO	14	\N
1486	NITRATO DE POTÁSSIO	14	\N
1487	MISTURA(S) DE NITRATO DE POTÁSSIO E NITRITO DE SÓDIO  	14	\N
1488	NITRITO DE POTÁSSIO	14	\N
1489	PERCLORATO DE POTÁSSIO	14	\N
1490	PERMANGANATO DE POTÁSSIO	14	\N
1491	PERÓXIDO DE POTÁSSIO	14	\N
1492	PERSULFATO DE POTÁSSIO	14	\N
1493	NITRATO DE PRATA	14	\N
1494	BROMATO DE SÓDIO	14	\N
1495	CLORATO DE SÓDIO	14	\N
1496	CLORITO DE SÓDIO	14	\N
1498	NITRATO DE SÓDIO	14	\N
1499	MISTURA(S) DE NITRATO DE SÓDIO E NITRATO DE POTÁSSIO	14	\N
1500	NITRITO DE SÓDIO	14	\N
1502	PERCLORATO DE SÓDIO	14	\N
1503	PERMANGANATO DE SÓDIO	14	\N
1504	PERÓXIDO DE SÓDIO	14	\N
1505	PERSULFATO DE SÓDIO	14	\N
1506	CLORATO DE ESTRÔNCIO	14	\N
1507	NITRATO DE ESTRÔNCIO	14	\N
1508	PERCLORATO DE ESTRÔNCIO	14	\N
1509	PERÓXIDO DE ESTRÔNCIO	14	\N
1510	TETRANITROMETANO	14	\N
1511	HIDROPERÓXIDO DE URÉIA	14	\N
1512	NITRITO DUPLO DE ZINCO E AMÔNIO	14	\N
1513	CLORATO DE ZINCO	14	\N
1514	NITRATO DE ZINCO	14	\N
1515	PERMANGANATO DE ZINCO	14	\N
1516	PERÓXIDO DE ZINCO	14	\N
1517	PICRAMATO DE ZIRCÔNIO, UMEDECIDO com, no mínimo, 20% de água, em massa	11	\N
1541	ACETONA-CIANIDRINA, ESTABILIZADA	16	\N
1544	ALCALÓIDES, SÓLIDOS, N.E., ou  SAIS DE ALCALÓIDES, SÓLIDOS N.E., tóxicos	16	\N
1545	ISOTIOCIANATO DE ALILA, INIBIDO	16	\N
1546	ARSENIATO DE AMÔNIO	16	\N
1547	ANILINA	16	\N
1548	CLORIDRATO DE ANILINA	16	\N
1549	ANTIMÔNIO, COMPOSTOS  INORGÂNICOS, SÓLIDOS, N.E.	16	\N
1550	LACTATO DE ANTIMÔNIO	16	\N
1551	TARTARATO DUPLO DE ANTIMÔNIO E POTÁSSIO	16	\N
1553	ÁCIDO ARSÊNICO, LÍQUIDO	16	\N
1554	ÁCIDO ARSÊNICO, SÓLIDO	16	\N
1555	BROMETO DE ARSÊNIO	16	\N
1556	ARSÊNIO, COMPOSTOS LÍQUIDOS, N.E., incluindo Arseniatos, n.e., Arsenitos, n.e., Sulfetos de arsênio, n.e. e Compostos orgânicos de arsênio, n.e.	16	\N
1557	ARSÊNIO, COMPOSTOS  SÓLIDOS, N.E., incluindo Arseniatos, n.e., Arsenitos, n.e., Sulfetos de arsênio, n.e. e Compostos orgânicos de arsênio, n.e. 	16	\N
1558	ARSÊNIO	16	\N
1559	PENTÓXIDO DE ARSÊNIO	16	\N
1560	TRICLORETO DE ARSÊNIO	16	\N
1561	TRIÓXIDO DE ARSÊNIO	16	\N
1562	PÓ DE COMPOSTOS DE ARSÊNIO	16	\N
1564	BÁRIO, COMPOSTOS, N.E.	16	\N
1565	CIANETO DE BÁRIO	16	\N
1566	BERÍLIO, COMPOSTOS, N.E.	16	\N
1567	BERÍLIO, EM PÓ	16	\N
1569	BROMOACETONA	16	\N
1570	BRUCINA	16	\N
1571	AZIDA DE BÁRIO, UMEDECIDA com, no mínimo, 50% de água, em massa 	11	\N
1572	ÁCIDO CACODÍLICO	16	\N
1573	ARSENIATO DE CÁLCIO	16	\N
1574	MISTURA(S) DE ARSENIATO DE CÁLCIO E ARSENITO DE  CÁLCIO, SÓLIDA(S)	16	\N
1575	CIANETO DE CÁLCIO	16	\N
1577	CLORODINITROBENZENOS	16	\N
1578	NITROBENZENOS CLORADOS	16	\N
1579	CLORIDRATO DE 4-CLORO-o-TOLUIDINA	16	\N
1580	CLOROPICRINA	16	\N
1581	MISTURA(S) DE CLOROPICRINA E BROMETO DE METILA	9	\N
1582	MISTURA(S) DE CLOROPICRINA E CLORETO DE METILA	9	\N
1583	MISTURA(S) DE CLOROPICRINA, N.E.	16	\N
1585	ACETOARSENITO DE COBRE	16	\N
1586	ARSENITO DE COBRE	16	\N
1587	CIANETO DE COBRE	16	\N
1588	CIANETOS INORGÂNICOS, N.E.	16	\N
1589	CLORETO DE CIANOGÊNIO, INIBIDO	9	\N
1590	DICLOROANILINAS	16	\N
1591	o-DICLOROBENZENO	16	\N
1593	DICLOROMETANO	16	\N
1594	SULFATO DE DIETILA	16	\N
1595	SULFATO DE DIMETILA	16	\N
1596	DINITROANILINAS	16	\N
1597	DINITROBENZENOS	16	\N
1598	DINITRO-o-CRESOL	16	\N
1599	DINITROFENOL, SOLUÇÕES	16	\N
1600	DINITROTOLUENOS, FUNDIDOS	16	\N
1601	DESINFETANTES, SÓLIDOS, N.E., tóxicos	16	\N
1602	CORANTES, LÍQUIDOS, N.E., ou INTERMEDIÁRIOS PARA CORANTES, LÍQUIDOS, N.E., tóxicos	16	\N
1603	ACETATO DE BROMOETILA	16	\N
1604	ETILENODIAMINA	19	\N
1605	DIBROMOETILENO	16	\N
1606	ARSENIATO FÉRRICO	16	\N
1607	ARSENITO FÉRRICO	16	\N
1608	ARSENIATO FERROSO	16	\N
1610	LÍQUIDO HALOGENADO IRRITANTE, N.E.	16	\N
1611	TETRAFOSFATO DE HEXAETILA	16	\N
1612	MISTURA(S) DE TETRAFOSFATO DE HEXAETILA E GÁS COMPRIMIDO	9	\N
1613	ÁCIDO CIANÍDRICO, SOLUÇÃO AQUOSA, com até 20% de ácido cianídrico 	16	\N
1614	ÁCIDO CIANÍDRICO, ANIDRO, ESTABILIZADO, absorvido em material inerte e poroso	16	\N
1616	ACETATO DE CHUMBO	16	\N
1617	ARSENIATO(S) DE CHUMBO	16	\N
1618	ARSENITO(S) DE CHUMBO	16	\N
1620	CIANETO DE CHUMBO	16	\N
1621	PÚRPURA DE LONDRES	16	\N
1622	ARSENIATO DE MAGNÉSIO	16	\N
1623	ARSENIATO MERCÚRICO	16	\N
1624	CLORETO MERCÚRICO	16	\N
1625	NITRATO MERCÚRICO	16	\N
1626	CIANETO DUPLO DE MERCÚRIO E POTÁSSIO	16	\N
1627	NITRATO MERCUROSO	16	\N
1629	ACETATO DE MERCÚRIO	16	\N
1630	CLORETO DUPLO DE MERCÚRIO E AMÔNIO	16	\N
1631	BENZOATO DE MERCÚRIO	16	\N
1634	BROMETO(S) DE MERCÚRIO	16	\N
1636	CIANETO DE MERCÚRIO	16	\N
1637	GLUCONATO DE MERCÚRIO	16	\N
1638	IODETO DE MERCÚRIO	16	\N
1639	NUCLEATO DE MERCÚRIO (Mercurol)	16	\N
1640	OLEATO DE MERCÚRIO	16	\N
1641	ÓXIDO DE MERCÚRIO	16	\N
1642	OXICIANETO DE MERCÚRIO, DESSENSIBILIZADO	16	\N
1643	IODETO DUPLO DE MERCÚRIO E POTÁSSIO	16	\N
1644	SALICILATO DE MERCÚRIO	16	\N
1645	SULFATO DE MERCÚRIO	16	\N
1646	TIOCIANATO DE MERCÚRIO	16	\N
1647	MISTURA(S) DE BROMETO DE METILA E DIBROMETO DE ETILENO, LÍQUIDA(S)	16	\N
1648	CIANETO DE METILA	10	\N
1649	MISTURA(S) ANTIDETONANTE(S), PARA COMBUSTÍVEL PARA MOTORES	16	\N
1650	beta-NAFTILAMINA	16	\N
1651	NAFTILTIOURÉIA	16	\N
1652	NAFTILURÉIA	16	\N
1653	CIANETO DE NÍQUEL	16	\N
1654	NICOTINA	16	\N
1655	NICOTINA, COMPOSTOS SÓLIDOS, N.E. ou PREPARAÇÕES SÓLIDAS N.E. 	16	\N
1656	CLORIDRATO DE NICOTINA ou SOLUÇÃO DE CLORIDRATO DE NICOTINA	16	\N
1657	SALICILATO DE NICOTINA	16	\N
1658	SULFATO DE NICOTINA, SÓLIDO ou SULFATO DE NICOTINA, EM SOLUÇÃO	16	\N
1659	TARTARATO DE NICOTINA	16	\N
1660	ÓXIDO NÍTRICO	9	\N
1661	NITROANILINAS (o-,m-,p-)	16	\N
1662	NITROBENZENO	16	\N
1663	NITROFENÓIS (o-,m-,p-)	16	\N
1664	NITROTOLUENOS (o-,m-,p-)	16	\N
1665	NITROXILENOS (o-,m-,p-)	16	\N
1669	PENTACLOROETANO	16	\N
1670	PERCLOROMETILMERCAPTANA	16	\N
1671	FENOL, SÓLIDO	16	\N
1672	CLORETO DE FENILCARBILAMINA	16	\N
1673	FENILENODIAMINAS (o-,m-,p-)	16	\N
1674	ACETATO DE FENILMERCÚRIO	16	\N
1677	ARSENIATO DE POTÁSSIO	16	\N
1678	ARSENITO DE POTÁSSIO	16	\N
1679	CUPROCIANETO DE POTÁSSIO	16	\N
1680	CIANETO DE POTÁSSIO	16	\N
1683	ARSENITO DE PRATA	16	\N
1684	CIANETO DE PRATA	16	\N
1685	ARSENIATO DE SÓDIO	16	\N
1686	ARSENITO DE SÓDIO, SOLUÇÕES AQUOSAS	16	\N
1687	AZIDA DE SÓDIO	16	\N
1688	CACODILATO DE SÓDIO	16	\N
1689	CIANETO DE SÓDIO	16	\N
1690	FLUORETO DE SÓDIO	16	\N
1691	ARSENITO DE ESTRÔNCIO	16	\N
1692	ESTRICNINA ou SAIS DE ESTRICNINA	16	\N
1693	GÁS LACRIMOGÊNEO, SUBSTÂNCIAS, LÍQUIDAS ou SÓLIDAS, N.E.	16	\N
1694	CIANETO(S) DE BROMOBENZILA	16	\N
1695	CLOROACETONA, ESTABILIZADA	16	\N
1697	CLOROACETOFENONA	16	\N
1698	DIFENILAMINA CLOROARSINA	16	\N
1699	DIFENILCLOROARSINA	16	\N
1700	GÁS LACRIMOGÊNEO, VELAS	16	\N
1701	BROMETO DE XILILA	16	\N
1702	TETRACLOROETANO	16	\N
1703	DITIOPIROFOSFATO DE TETRAETILA E GASES, EM SOLUÇÃO ou EM MISTURA	9	\N
1704	DITIOPIROFOSFATO DE TETRAETILA	16	\N
1705	MISTURA(S) DE PIROFOSFATO DE TETRAETILA E GÁS COMPRIMIDO	9	\N
1707	TÁLIO, COMPOSTOS, N.E.	16	\N
1708	TOLUIDINAS	16	\N
1709	2,4-TOLUENODIAMINA	16	\N
1710	TRICLOROETENO	16	\N
1711	XILIDINAS	16	\N
1712	ARSENIATO DE ZINCO, ARSENITO DE ZINCO ou MISTURAS DE  ARSENIATO DE ZINCO E ARSENITO DE ZINCO	16	\N
1713	CIANETO DE ZINCO	16	\N
1714	FOSFETO DE ZINCO	13	\N
1715	ANIDRIDO ACÉTICO	19	\N
1716	BROMETO DE ACETILA	19	\N
1717	CLORETO DE ACETILA	10	\N
1718	FOSFATO ÁCIDO DE BUTILA	19	\N
1719	LÍQUIDO ALCALINO CÁUSTICO, N.E.	19	\N
1722	CLOROFORMIATO DE ALILA	19	\N
1723	IODETO DE ALILA	10	\N
1724	ALILTRICLOROSSILANO, ESTABILIZADO	19	\N
1725	BROMETO DE ALUMÍNIO, ANIDRO	19	\N
1726	CLORETO DE ALUMÍNIO, ANIDRO	19	\N
1727	BIFLUORETO DE AMÔNIO, SÓLIDO	19	\N
1728	AMILTRICLOROSSILANO	19	\N
1729	CLORETO DE ANISOÍLA	19	\N
1730	PENTACLORETO DE ANTIMÔNIO, LÍQUIDO	19	\N
1731	PENTACLORETO DE ANTIMÔNIO, SOLUÇÃO	19	\N
1732	PENTAFLUORETO DE ANTIMÔNIO	19	\N
1733	TRICORETO DE ANTIMÔNIO	19	\N
1736	CLORETO DE BENZOÍLA	19	\N
1737	BROMETO DE BENZILA	16	\N
1738	CLORETO DE BENZILA	16	\N
1739	CLOROFOMIATO DE BENZILA	19	\N
1740	BIFLUORETOS, N.E.	19	\N
1741	TRICLORETO DE BORO	9	\N
1742	TRIFLUORETO DE BORO E ÁCIDO ACÉTICO, COMPLEXO DE	19	\N
1743	TRIFLUORETO DE BORO E ÁCIDO PROPIÔNICO, COMPLEXO DE	19	\N
1744	BROMO ou SOLUÇÕES DE BROMO	19	\N
1745	PENTAFLUORETO DE BROMO	14	\N
1746	TRIFLUORETO DE BROMO	14	\N
1747	BUTILTRICLOROSSILANO	19	\N
1748	HIPOCLORITO DE CÁLCIO, SECO ou MISTURAS DE HIPO- CLORITO DE CÁLCIO SECAS, com mais de 39% de cloro livre (8,8% de  oxigênio  livre)	14	\N
1749	TRIFLUORETO DE CLORO	9	\N
1750	ÁCIDO CLORACÉTICO, SOLUÇÃO	16	\N
1751	ÁCIDO CLORACÉTICO, SÓLIDO	16	\N
1752	CLORETO DE CLOROACETILA	19	\N
1753	CLOROFENILTRICLOROSSILANO	19	\N
1754	ÁCIDO CLOROSSULFÔNICO (com ou sem trióxido de enxofre)	19	\N
1755	ÁCIDO CRÔMICO, SOLUÇÃO	19	\N
1756	FLUORETO CRÔMICO, SÓLIDO	19	\N
1757	FLUORETO CRÔMICO, SOLUÇÃO	19	\N
1758	OXICLORETO DE CROMO	19	\N
1759	SÓLIDO CORROSIVO, N.E.	19	\N
1760	LÍQUIDO CORROSIVO, N.E.	19	\N
1761	ETILENODIAMINA CÚPRICA, SOLUÇÃO	19	\N
1762	CICLO-HEXENILTRICLOROSSILANO	19	\N
1763	CICLO-HEXILTRICLOROSSILANO	19	\N
1764	ÁCIDO DICLORACÉTICO	19	\N
1765	CLORETO DE DICLOROACETILA	19	\N
1766	DICLOROFENILTRICLOROSSILANO	19	\N
1767	DIETILDICLOROSSILANO	19	\N
1768	ÁCIDO DIFLUORFOSFÓRICO, ANIDRO	19	\N
1769	DIFENILDICLOROSSILANO	19	\N
1770	BROMETO DE DIFENILMETILA	19	\N
1771	DODECILTRICLOROSSILANO	19	\N
1773	CLORETO FÉRRICO	19	\N
1774	CARGAS PARA EXTINTOR DE INCÊNDIO, líquidas, corrosivas	19	\N
1775	ÁCIDO FLUORBÓRICO	19	\N
1776	ÁCIDO FLUORFOSFÓRICO, ANIDRO	19	\N
1777	ÁCIDO FLUORSULFÔNICO	19	\N
1778	ÁCIDO FLUORSILÍCICO	19	\N
1779	ÁCIDO FÓRMICO	19	\N
1780	CLORETO DE FUMARILA	19	\N
1781	HEXADECILTRICLOROSSILANO	19	\N
1782	ÁCIDO HEXAFLUORFOSFÓRICO	19	\N
1783	HEXAMETILENODIAMINA, SOLUÇÃO	19	\N
1784	HEXILTRICLOROSSILANO	19	\N
1786	MISTURA(S) DE ÁCIDO FLUORÍDRICO E ÁCIDO SULFÚRICO	19	\N
1787	ÁCIDO IODÍDRICO, SOLUÇÃO	19	\N
1788	ÁCIDO BROMÍDRICO, SOLUÇÃO	19	\N
1789	ÁCIDO CLORÍDRICO, SOLUÇÃO	19	\N
1790	ÁCIDO FLUORÍDRICO, SOLUÇÃO	19	\N
1791	HIPOCLORITO, SOLUÇÕES, com mais de 5% de cloro livre	19	\N
1792	MONOCLORETO DE IODO	19	\N
1793	FOSFATO ÁCIDO DE ISOPROPILA	19	\N
1794	SULFATO DE CHUMBO, com mais de 3% de ácido livre	19	\N
1796	MISTURA(S) NITRANTE(S) ÁCIDA(S)	19	\N
1798	MISTURA DE ÁCIDO NÍTRICO E ÁCIDO CLORÍDRICO (Água-régia)	19	\N
1799	NONILTRICLOROSSILANO	19	\N
1800	OCTADECILTRICLOROSSILANO	19	\N
1801	OCTILTRICLOROSSILANO	19	\N
1802	ÁCIDO PERCLÓRICO, com até 50% de ácido, em massa	19	\N
1803	ÁCIDO FENOLSULFÔNICO, LÍQUIDO	19	\N
1804	FENILTRICLOROSSILANO	19	\N
1805	ÁCIDO FOSFÓRICO	19	\N
1806	PENTACLORETO DE FÓSFORO	19	\N
1807	PENTÓXIDO DE FÓSFORO	19	\N
1808	TRIBROMETO DE FÓSFORO	19	\N
1809	TRICLORETO DE FÓSFORO	19	\N
1810	CLORETO DE FOSFORILA	19	\N
1811	BIFLUORETO DE POTÁSSIO	19	\N
1812	FLUORETO DE POTÁSSIO	16	\N
1813	HIDRÓXIDO DE POTÁSSIO, SÓLIDO	19	\N
1814	HIDRÓXIDO DE POTÁSSIO, SOLUÇÃO	19	\N
1815	CLORETO DE PROPIONILA	10	\N
1816	PROPILTRICLOROSSILANO	19	\N
1817	CLORETO DE PIROSSULFURILA	19	\N
1818	TETRACLORETO DE SILÍCIO	19	\N
1819	ALUMINATO DE SÓDIO, SOLUÇÃO	19	\N
1823	HIDRÓXIDO DE SÓDIO, SÓLIDO	19	\N
1824	HIDRÓXIDO DE SÓDIO, SOLUÇÃO	19	\N
1825	MONÓXIDO DE SÓDIO	19	\N
1826	MISTURA(S) NITRANTE(S) ÁCIDA(S), RESIDUAL(IS)	19	\N
1827	CLORETO ESTÂNICO, ANIDRO	19	\N
1828	CLORETO(S) DE ENXOFRE	19	\N
1829	TRIÓXIDO DE ENXOFRE, INIBIDO	19	\N
1830	ÁCIDO SULFÚRICO	19	\N
1831	ÁCIDO SULFÚRICO, FUMEGANTE	19	\N
1832	ÁCIDO SULFÚRICO, RESIDUAL	19	\N
1833	ÁCIDO SULFUROSO	19	\N
1834	CLORETO DE SULFURILA	19	\N
1835	HIDRÓXIDO DE TETRAMETILAMÔNIO	19	\N
1836	CLORETO DE TIONILA	19	\N
1837	CLORETO DE TIOFOSFORILA	19	\N
1838	TETRACLORETO DE TITÂNIO	19	\N
1839	ÁCIDO TRICLOROACÉTICO	19	\N
1840	CLORETO DE ZINCO, SOLUÇÃO	19	\N
1841	ACETALDEÍDO AMÔNIA	20	\N
1843	DINITRO-o-CRESOLATO DE AMÔNIO	16	\N
1845	DIÓXIDO DE CARBONO, SÓLIDO (GELO SECO)	20	\N
1846	TETRACLORETO DE CARBONO	16	\N
1847	SULFETO DE POTÁSSIO, HIDRATADO com, no mínimo, 30% de água de cristalização	19	\N
1848	ÁCIDO PROPIÔNICO	19	\N
1849	SULFETO DE SÓDIO, HIDRATADO com, no mínimo, 30% de água 	19	\N
1851	MEDICAMENTOS TÓXICOS, LÍQUIDOS, N.E.	16	\N
1854	LIGAS DE BÁRIO, PIROFÓRICAS	12	\N
1855	CÁLCIO, PIROFÓRICO ou LIGAS DE CÁLCIO, PIROFÓRICAS	12	\N
1858	HEXAFLUORPROPILENO	8	\N
1859	TETRAFLUORETO DE SILÍCIO	9	\N
1860	FLUORETO DE VINILA, INIBIDO	7	\N
1862	CROTONATO DE ETILA	10	\N
1863	COMBUSTÍVEL PARA AVIÕES A TURBINA	10	\N
1864	HIDROCARBONETOS GASOSOS, CONDENSADOS	10	\N
1865	NITRATO DE n-PROPILA	10	\N
1866	RESINA, SOLUÇÃO, inflamável	10	\N
1868	DECABORANO	11	\N
1869	MAGNÉSIO ou LIGAS DE MAGNÉSIO, com mais de 50% de magnésio, em grânulos, aparas ou fitas	11	\N
1870	BORO-HIDRETO DE POTÁSSIO	13	\N
1871	HIDRETO DE TITÂNIO	11	\N
1872	DIÓXIDO DE CHUMBO	14	\N
1873	ÁCIDO PERCLÓRICO, com mais de 50% e até 72% de ácido, em massa 	14	\N
1884	ÓXIDO DE BÁRIO	16	\N
1885	BENZIDINA	16	\N
1886	CLORETO DE BENZILIDENO	16	\N
1887	BROMOCLOROMETANO	16	\N
1888	CLOROFÓRMIO	16	\N
1889	BROMETO DE CIANOGÊNIO	16	\N
1891	BROMETO DE ETILA	16	\N
1892	ETILDICLOROARSINA	16	\N
1894	HIDRÓXIDO FENILMERCÚRICO	16	\N
1895	NITRATO FENILMERCÚRICO	16	\N
1897	TETRACLOROETENO	16	\N
1898	IODETO DE ACETILA	19	\N
1902	FOSFATO ÁCIDO DE DIISOOCTILA	19	\N
1903	DESINFETANTES, CORROSIVOS, LÍQUIDOS, N.E.	19	\N
1905	ÁCIDO SELÊNICO	19	\N
1906	LAMAS ÁCIDAS	19	\N
1907	CAL SODADA, com mais de 4% de hidróxido de sódio	19	\N
1908	CLORITO DE SÓDIO, SOLUÇÃO, com mais de 5% de cloro livre	19	\N
1910	ÓXIDO DE CÁLCIO	19	\N
1911	DIBORANO	9	\N
1912	MISTURA DE CLORETO DE METILA E CLORETO DE METILENO	8	\N
1913	NEÔNIO, LÍQUIDO REFRIGERADO	8	\N
1914	PROPIONATO DE BUTILA	10	\N
1915	CICLO-HEXANONA	10	\N
1916	ÉTER 2,2'-DICLORODIETÍLICO	16	\N
1917	ACRILATO DE ETILA, INIBIDO	10	\N
1918	ISOPROPILBENZENO	10	\N
1919	ACRILATO DE METILA, INIBIDO	10	\N
1920	NONANOS	10	\N
1921	PROPENOIMINA, INIBIDA	10	\N
1922	PIRROLIDINA	10	\N
2051	DIMETILETANOLAMINA	10	\N
1923	DITIONITO DE CÁLCIO (HIDROSSULFITO DE CÁLCIO)	12	\N
1928	BROMETO DE METILMAGNÉSIO EM ÉTER ETÍLICO	13	\N
1929	DITIONITO DE POTÁSSIO (HIDROSSULFITO DE POTÁSSIO)	12	\N
1931	DITIONITO DE ZINCO (HIDROSSULFITO DE ZINCO)	20	\N
1932	ZIRCÔNIO, APARAS	12	\N
1935	CIANETOS, SOLUÇÕES	16	\N
1938	ÁCIDO BROMOACÉTICO	19	\N
1939	OXIBROMETO DE FÓSFORO	19	\N
1940	ÁCIDO TIOGLICÓLICO	19	\N
1941	DIBROMODIFLUORMETANO	20	\N
1942	NITRATO DE AMÔNIO, contendo até 0,2% de substâncias combustíveis, inclusive qualquer substância orgânica calculada como carbono, exclusive qualquer outra substância adicionada	14	\N
1944	FÓSFOROS DE SEGURANÇA (carteiras, cartelas ou caixas)	11	\N
1945	FÓSFOROS, DE CERA VIRGEM	11	\N
1951	ARGÔNIO, LÍQUIDO REFRIGERADO	8	\N
1952	MISTURA(S) DE DIÓXIDO DE CARBONO E ÓXIDO DE ETENO,  com até 6% de óxido de eteno	8	\N
1953	GÁS TÓXICO, INFLAMÁVEL, COMPRIMIDO, N.E.	9	\N
1954	GÁS INFLAMÁVEL, COMPRIMIDO, N.E.	7	\N
1955	GÁS TÓXICO, COMPRIMIDO, N.E.	9	\N
1956	GÁS COMPRIMIDO, N.E.	8	\N
1957	DEUTÉRIO	7	\N
1958	DICLOROTETRAFLUORETANO	8	\N
1959	1,1-DIFLUORETILENO	7	\N
1960	FLUIDO PARA PARTIDA DE MOTORES, com gás inflamável	7	\N
1961	ETANO, LÍQUIDO REFRIGERADO	7	\N
1962	ETENO, COMPRIMIDO	7	\N
1963	HÉLIO, LÍQUIDO REFRIGERADO	8	\N
1964	HIDROCARBONETOS GASOSOS, COMPRIMIDOS, N.E. ou MISTURAS DE HIDROCARBONETOS GASOSOS, COMPRIMIDAS, N.E.	7	\N
1965	HIDROCARBONETOS GASOSOS, LIQUEFEITOS, N.E. ou MISTURAS DE HIDROCARBONETOS GASOSOS, LIQUEFEITAS, N.E.	7	\N
1966	HIDROGÊNIO, LÍQUIDO REFRIGERADO	7	\N
1967	INSETICIDA GASOSO, TÓXICO, N.E.	9	\N
1968	INSETICIDA GASOSO, N.E.	8	\N
1969	ISOBUTANO ou MISTURAS DE ISOBUTANO	7	\N
1970	CRIPTÔNIO, LÍQUIDO REFRIGERADO	8	\N
1971	METANO, COMPRIMIDO, ou GÁS NATURAL, COMPRIMIDO, com elevado teor de metano	7	\N
1972	METANO, LÍQUIDO REFRIGERADO ou GÁS NATURAL, LÍQUIDO REFRIGERADO, com alto teor de metano	7	\N
1973	MISTURA DE CLORODIFLUORMETANO E CLOROPENTA-FLUORETANO, com PE fixo, contendo cerca de 49% de clorodifluormetano	8	\N
1974	CLORODIFLUORBROMOMETANO	8	\N
1975	MISTURA(S) DE ÓXIDO NÍTRICO E TETRÓXIDO DE DINITROGÊNIO (MISTURAS DE ÓXIDO NÍTRICO E DIÓXIDO DE NITROGÊNIO)	9	\N
1976	OCTAFLUORCICLOBUTANO	8	\N
1977	NITROGÊNIO, LÍQUIDO REFRIGERADO	8	\N
1978	PROPANO ou MISTURAS DE PROPANO	7	\N
1979	MISTURA(S) DE GASES RAROS	8	\N
1980	MISTURA(S) DE GASES RAROS E OXIGÊNIO	8	\N
1981	MISTURA(S) DE GASES RAROS E NITROGÊNIO	8	\N
1982	TETRAFLUORMETANO	8	\N
1983	1-CLORO-2,2,2-TRIFLUORETANO	8	\N
1984	TRIFLUORMETANO	8	\N
1986	ÁLCOOIS, TÓXICOS, N.E.	10	\N
1987	ÁLCOOIS, N.E.	10	\N
1988	ALDEÍDOS, TÓXICOS, N.E.	10	\N
1989	ALDEÍDOS, N.E.	10	\N
1991	CLOROPRENO, INIBIDO	10	\N
1992	LÍQUIDO INFLAMÁVEL, TÓXICO, N.E.	10	\N
1993	LÍQUIDO INFLAMÁVEL, N.E.	10	\N
1994	FERROPENTACARBONILA	16	\N
1999	ALCATRÕES LÍQUIDOS, inclusive asfalto,  óleos, betumes e cutbacks rodoviários	10	\N
2000	CELULÓIDE, em blocos, barras, cilindros, folhas, tubos etc.,  exceto refugos	11	\N
2001	NAFTENATOS DE COBALTO, EM PÓ	11	\N
2002	CELULÓIDE, REFUGOS	12	\N
2003	ALQUIL METAIS, N.E., ou ARIL METAIS, N.E.	12	\N
2004	MAGNESIODIAMIDA	12	\N
2005	DIFENILMAGNÉSIO	12	\N
2006	PLÁSTICOS, À BASE DE NITROCELULOSE, SUJEITOS A AUTO-AQUECIMENTO, N.E.	12	\N
2008	ZIRCÔNIO, EM PÓ, SECO	12	\N
2009	ZIRCÔNIO, SECO, chapas acabadas, tiras ou bobinas de arame	12	\N
2010	HIDRETO DE MAGNÉSIO	13	\N
2011	FOSFETO DE MAGNÉSIO	13	\N
2012	FOSFETO DE POTÁSSIO	13	\N
2013	FOSFETO DE ESTRÔNCIO	13	\N
2014	PERÓXIDO DE HIDROGÊNIO, SOLUÇÕES AQUOSAS, com entre 20% e 60% de peróxido de hidrogênio (estabilizadas se necessário)	14	\N
2015	PERÓXIDO DE HIDROGÊNIO, ESTABILIZADO ou SOLUÇÕES  AQUOSAS DE PERÓXIDO DE HIDROGÊNIO, ESTABILIZADAS, com mais de 60% de peróxido de hidrogênio	14	\N
2016	MUNIÇÃO TÓXICA, NÃO-EXPLOSIVA, sem ruptor ou carga ejetora, sem espoleta	16	\N
2017	MUNIÇÃO LACRIMOGÊNEA, NÃO-EXPLOSIVA, sem ruptor ou carga ejetora, sem espoleta	16	\N
2018	CLOROANILINAS, SÓLIDAS	16	\N
2019	CLOROANILINAS, LÍQUIDAS	16	\N
2020	CLOROFENÓIS, SÓLIDOS	16	\N
2021	CLOROFENÓIS, LÍQUIDOS	16	\N
2022	ÁCIDO CRESÍLICO	16	\N
2023	EPICLORIDRINA	16	\N
2024	MERCÚRIO, COMPOSTOS LÍQUIDOS, N.E.	16	\N
2025	MERCÚRIO, COMPOSTOS SÓLIDOS, N.E.	16	\N
2026	FENILMERCÚRIO, COMPOSTOS, N.E.	16	\N
2027	ARSENITO DE SÓDIO, SÓLIDO	16	\N
2028	BOMBAS, FUMÍGENAS, NÃO-EXPLOSIVAS, com líquido corrosivo, sem dispositivo iniciador	19	\N
2029	HIDRAZINA ANIDRA ou SOLUÇÕES AQUOSAS DE HIDRAZINA, com mais de 64% de hidrazina, em massa	10	\N
2030	HIDRATO DE HIDRAZINA ou SOLUÇÕES AQUOSAS DE HIDRAZINA, com até 64% de hidrazina, em massa	19	\N
2031	ÁCIDO NÍTRICO, exceto fumegante	19	\N
2032	ÁCIDO NÍTRICO, FUMEGANTE	19	\N
2033	MONÓXIDO DE POTÁSSIO	19	\N
2034	MISTURA(S) DE HIDROGÊNIO E METANO, COMPRIMIDA(S)	7	\N
2035	TRIFLUORETANO, COMPRIMIDO	7	\N
2036	XENÔNIO	8	\N
2037	GÁS EM PEQUENOS RECIPIENTES não-recarregáveis, sem difusor 	7	\N
2038	DINITROTOLUENOS	16	\N
2044	2,2-DIMETILPROPANO, exceto pentano e isopentano	7	\N
2045	ISOBUTIRALDEÍDO (ALDEÍDO ISOBUTÍLICO)	10	\N
2046	CIMENOS	10	\N
2047	DICLOROPROPENO	10	\N
2048	DICICLOPENTADIENO	10	\N
2049	DIETILBENZENO	10	\N
2050	DIISOBUTILENO, COMPOSTOS ISOMÉRICOS	10	\N
2052	DIPENTENO	10	\N
2053	METILISOBUTILCARBINOL	10	\N
2054	MORFOLINA	10	\N
2055	ESTIRENO, MONÔMERO, INIBIDO	10	\N
2056	TETRA-HIDROFURANO	10	\N
2057	TRIPROPILENO	10	\N
2058	ALDEÍDO VALÉRICO	10	\N
2059	NITROCELULOSE, SOLUÇÕES, INFLAMÁVEIS, com até 12,6% de nitrogênio, em massa, e até 55% de nitrocelulose	10	\N
2067		14	\N
2068		14	\N
2069		14	\N
2070		14	\N
2071		20	\N
2072	NITRATO DE AMÔNIO, FERTILIZANTES, N.E.	14	\N
2073	AMÔNIA, SOLUÇÕES aquosas, com densidade relativa inferior a 0,880 a 15ºC, com mais de 35% e até 50% de amônia 	8	\N
2074	ACRILAMIDA	16	\N
2075	CLORAL, ANIDRO, INIBIDO	16	\N
2076	CRESÓIS (o-,m-,p-)	16	\N
2077	alfa-NAFTILAMINA	16	\N
2078	TOLUENO DIISOCIANATO	16	\N
2079	DIETILENOTRIAMINA	19	\N
2186	CLORETO DE HIDROGÊNIO, LÍQUIDO REFRIGERADO	9	\N
2187	DIÓXIDO DE CARBONO, LÍQUIDO REFRIGERADO	8	\N
2188	ARSINA	9	\N
2189	DICLOROSSILANO	9	\N
2190	DIFLUORETO DE OXIGÊNIO	9	\N
2191	FLUORETO DE SULFURILA	9	\N
2192	GERMÂNIO, HIDRETO	9	\N
2193	HEXAFLUORETANO	8	\N
2194	HEXAFLUORETO DE SELÊNIO	9	\N
2195	HEXAFLUORETO DE TELÚRIO	9	\N
2196	HEXAFLUORETO DE TUNGSTÊNIO	9	\N
2197	IODETO DE HIDROGÊNIO, ANIDRO	9	\N
2198	PENTAFLUORETO DE FÓSFORO	9	\N
2199	FOSFINA	9	\N
2200	PROPADIENO, INIBIDO	7	\N
2201	ÓXIDO NITROSO, LÍQUIDO REFRIGERADO	8	\N
2202	HIDRETO DE SELÊNIO, ANIDRO	9	\N
2203	SILANO	7	\N
2204	SULFETO DE CARBONILA	9	\N
2205	ADIPONITRILA	16	\N
2206	ISOCIANATOS, N.E. ou SOLUÇÕES DE ISOCIANATOS, N.E. com PFg superior a 60,5ºC e PE inferior a 300ºC	16	\N
2207	ISOCIANATOS, N.E. ou SOLUÇÕES DE ISOCIANATOS, N.E. com PE igual ou superior a 300ºC	16	\N
2208	MISTURA(S) DE HIPOCLORITO DE CÁLCIO, SECA(S), com mais de 10% e até 39% de cloro livre	14	\N
2209	FORMALDEÍDO, SOLUÇÕES, com no mínimo 25% de formaldeído	19	\N
2210	MANEB ou PREPARAÇÕES DE MANEB, com 60% ou mais de maneb	12	\N
2211	POLÍMEROS, GRANULADOS, EXPARSÍVEIS, que desprendem vapores inflamáveis	20	\N
2212	AMIANTO AZUL (crocidolita) ou  AMIANTO  MARROM (amosita, misorita) 	20	\N
2213	PARAFORMALDEÍDO	11	\N
2214	ANIDRIDO FTÁLICO, com mais de 0,05% de anidrido maléico 	19	\N
2215	ANIDRIDO MALÉICO	19	\N
2216	FARINHA DE PEIXE (RESTOS DE PEIXE), ESTABILIZADA	20	\N
2217	TORTAS OLEAGINOSAS com até 1,5% de óleo e até 11% de umidade 	12	\N
2218	ÁCIDO ACRÍLICO, INIBIDO	19	\N
2219	ÉTER ALILGLICIDÍLICO	10	\N
2222	ANISOL	10	\N
2224	BENZONITRILA	16	\N
2225	CLORETO DE BENZENO-SULFONILA	19	\N
2226	TRICLOROBENZENO	19	\N
2227	METACRILATO DE n-BUTILA	10	\N
2228	BUTILFENÓIS, LÍQUIDOS	16	\N
2229	BUTILFENÓIS, SÓLIDOS	16	\N
2232	CLOROACETALDEÍDO	16	\N
2233	CLOROANISIDINAS	16	\N
2234	TRIFLUORETO(S) DE CLOROBENZILA	10	\N
2235	CLORETO(S) DE CLOROBENZILA	16	\N
2236	ISOCIANATO DE 3-CLORO-4-METILFENILA	16	\N
2237	CLORONITROANILINAS	16	\N
2238	TOLUENOS CLORADOS	10	\N
2239	TOLUIDINAS CLORADAS	16	\N
2240	ÁCIDO CROMOSSULFÚRICO	19	\N
2241	CICLO-HEPTANO	10	\N
2242	CICLO-HEPTENO	10	\N
2243	ACETATO DE CICLO-HEXILA	10	\N
2244	CICLOPENTANOL	10	\N
2245	CICLOPENTANONA	10	\N
2246	CICLOPENTENO	10	\N
2247	n-DECANO	10	\N
2248	DI-(n-BUTIL) AMINA	19	\N
2249	ÉTER DICLORODIMETÍLICO, SIMÉTRICO	16	\N
2250	ISOCIANATO(S) DE DICLOROFENILA	16	\N
2251	2,5-NORBONADIENO (DICICLO-HEPTADIENO)	10	\N
2252	1,2-DIMETOXIETANO	10	\N
2253	N,N-DIMETILANILINA	16	\N
2254	FÓSFOROS, QUE SE CONSERVAM ACESOS AO VENTO	11	\N
2256	CICLO-HEXENO	10	\N
2257	POTÁSSIO	13	\N
2258	1,2-PROPENODIAMINA	19	\N
2259	TRIETILENOTETRAMINA	19	\N
2260	TRIPROPILAMINA	10	\N
2261	XILENÓIS	16	\N
2262	CLORETO DE DIMETILCARBAMILA (Cloreto de dimetil-carbamoíla)	19	\N
2263	DIMETILCICLO-HEXANOS	10	\N
2264	DIMETILCICLO-HEXILAMINA	19	\N
2265	N,N-DIMETILFORMAMIDA	10	\N
2266	DIMETIL-N-PROPILAMINA	10	\N
2267	CLORETO DE DIMETILTIOFOSFORILA	19	\N
2269	3,3'-IMINODIPROPILAMINA	19	\N
2270	ETILAMINA, SOLUÇÕES AQUOSAS, com entre 50% e 70% de etilamina	10	\N
2271	ETILAMILCETONA	10	\N
2272	N-ETILANILINA	16	\N
2273	2-ETILANILINA	16	\N
2274	N-ETIL-N-BENZILANILINA	16	\N
2275	2-ETILBUTANOL	10	\N
2276	2-ETIL-HEXILAMINA	19	\N
2277	METACRILATO DE ETILA	10	\N
2278	n-HEPTENO	10	\N
2279	HEXACLOROBUTADIENO	16	\N
2280	HEXAMETILENODIAMINA, SÓLIDA	19	\N
2281	HEXAMETILENO DIISOCIANATO	16	\N
2282	HEXANÓIS	10	\N
2283	METACRILATO DE ISOBUTILA	10	\N
2284	ISOBUTIRONITRILA	10	\N
2285	TRIFLUORETO(S) DE ISOBENZOCIANATO	16	\N
2286	PENTAMETIL-HEPTANO	10	\N
2287	ISO-HEPTENO	10	\N
2288	ISO-HEXENO	10	\N
2289	ISOFORONADIAMINA	19	\N
2290	ISOFORONADIISOCIANATO	16	\N
2291	CHUMBO, COMPOSTOS, SOLÚVEIS, N.E.	16	\N
2293	4-METÓXI-4-METILPENTAN-2-ONA	10	\N
2294	N-METILANILINA	16	\N
2295	CLOROACETATO DE METILA	16	\N
2296	METILCICLO-HEXANO	10	\N
2297	METILCICLO-HEXANONA	10	\N
2298	METILCICLOPENTANO	10	\N
2299	DICLOROACETATO DE METILA	16	\N
2300	2-METIL-5-ETILPIRIDINA	16	\N
2301	2-METILFURANO	10	\N
2302	5-METIL-HEXAN-2-ONA	10	\N
2303	ISOPROPENILBENZENO	10	\N
2304	NAFTALENO, FUNDIDO	11	\N
2305	ÁCIDO NITROBENZENOSSULFÔNICO	19	\N
2306	TRIFLUORETO(S) DE NITROBENZENO	16	\N
2307	TRIFLUORETO DE 3-NITRO-4-CLOROBENZENO	16	\N
2308	ÁCIDO NITROSILSULFÚRICO	19	\N
2309	OCTADIENO	10	\N
2310	PENTANO-2,4-DIONA	10	\N
2311	FENETIDINAS	16	\N
2312	FENOL, FUNDIDO	16	\N
2313	PICOLINAS	10	\N
2315	BIFENILAS POLICLORADAS	20	\N
2316	CUPROCIANETO DE SÓDIO, SÓLIDO	16	\N
2317	CUPROCIANETO DE SÓDIO, SOLUÇÃO	16	\N
2318	HIDRO-SULFETO DE SÓDIO, com menos de 25% de água de cristalização 	12	\N
2319	HIDROCARBONETOS TERPÊNICOS, N.E.	10	\N
2320	TETRAETILENOPENTAMINA	19	\N
2321	TRICLOROBENZENOS, LÍQUIDOS	16	\N
2322	TRICLOROBUTENO	16	\N
2323	FOSFITO DE TRIETILA	10	\N
2324	TRIISOBUTILENO	10	\N
2325	1,3,5-TRIMETILBENZENO	10	\N
2326	TRIMETILCICLO-HEXILAMINA	19	\N
2327	TRIMETIL-HEXAMETILENODIAMINAS	19	\N
2328	TRIMETIL-HEXAMETILENO DIISOCIANATO	16	\N
2329	FOSFITO DE TRIMETILA	10	\N
2330	UNDECANO	10	\N
2331	CLORETO DE ZINCO, ANIDRO	19	\N
2332	ACETALDEÍDO OXIMA	10	\N
2333	ACETATO DE ALILA	10	\N
2334	ALILAMINA	16	\N
2335	ÉTER ALILETÍLICO	10	\N
2336	FORMIATO DE ALILA	10	\N
2337	FENILMERCAPTANA	16	\N
2338	TRIFLUORBENZENO	10	\N
2339	2-BROMOBUTANO	10	\N
2340	ÉTER 2-BROMOETILETÍLICO	10	\N
2341	1-BROMO-3-METILBUTANO	10	\N
2342	BROMOMETILPROPANOS	10	\N
2343	2-BROMOPENTANO	10	\N
2344	2-BROMOPROPANO	10	\N
2345	3-BROMOPROPINO	10	\N
2346	BUTANODIONA	10	\N
2347	BUTILMERCAPTANA	10	\N
2348	ACRILATO DE BUTILA	10	\N
2350	ÉTER BUTILMETÍLICO	10	\N
2351	NITRITO(S) DE BUTILA	10	\N
2352	ÉTER BUTILVINÍLICO, INIBIDO	10	\N
2353	CLORETO DE BUTIRILA	10	\N
2354	ÉTER CLOROMETILETÍLICO	10	\N
2356	2-CLOROPROPANO	10	\N
2357	CICLO-HEXILAMINA	19	\N
2358	CICLOOCTATETRAENO	10	\N
2359	DIALILAMINA	10	\N
2360	ÉTER DIALÍLICO	10	\N
2361	DIISOBUTILAMINA	10	\N
2362	1,1-DICLOROETANO	10	\N
2363	ETILMERCAPTANA	10	\N
2364	n-PROPILBENZENO	10	\N
2366	CARBONATO DE DIETILA	10	\N
2367	alfa-METILVALERALDEÍDO	10	\N
2368	alfa-PINENO	10	\N
2369	ÉTER MONOBUTÍLICO DE ETILENOGLICOL	16	\N
2370	1-HEXENO	10	\N
2371	ISOPENTENOS	10	\N
2372	1,2-DI-(DIMETILAMINO) ETANO	10	\N
2373	DIETOXIMETANO	10	\N
2374	3,3-DIETOXIPROPENO	10	\N
2375	SULFETO DE DIETILA	10	\N
2376	2,3-DI-HIDROPIRANO	10	\N
2377	1,1-DIMETOXIETANO	10	\N
2378	2-DIMETILAMINOACETONITRILA	10	\N
2379	1,3-DIMETILBUTILAMINA	10	\N
2380	DIMETILDIETOXISSILANO	10	\N
2381	DISSULFETO DE DIMETILA	10	\N
2382	DIMETIL-HIDRAZINA, SIMÉTRICA	10	\N
2383	DIPROPILAMINA	10	\N
2384	ÉTER DIPROPÍLICO	10	\N
2385	ISOBUTIRATO DE ETILA	10	\N
2386	1-ETILPIPERIDINA	10	\N
2387	FLUORBENZENO	10	\N
2388	FLUORTOLUENOS	10	\N
2389	FURANO	10	\N
2390	2-IODOBUTANO	10	\N
2391	IODOMETILPROPANOS	10	\N
2392	IODOPROPANOS	10	\N
2393	FORMIATO DE ISOBUTILA	10	\N
2394	PROPIONATO DE ISOBUTILA	10	\N
2395	CLORETO DE ISOBUTIRILA	10	\N
2396	ALDEÍDO METACRÍLICO	10	\N
2397	3-METIL-BUTAN-2-ONA	10	\N
2398	ÉTER METIL-t-BUTÍLICO	10	\N
2399	1-METILPIPERIDINA	10	\N
2400	ISOVALERATO DE METILA	10	\N
2401	PIPERIDINA	10	\N
2402	PROPANOTIÓIS	10	\N
2403	ACETATO DE ISOPROPENILA	10	\N
2404	PROPIONITRILA	10	\N
2405	BUTIRATO DE ISOPROPILA	10	\N
2406	ISOBUTIRATO DE ISOPROPILA	10	\N
2407	CLOROFORMIATO DE ISOPROPILA	10	\N
2409	PROPIONATO DE ISOPROPILA	10	\N
2410	1,2,3,6-TETRA-HIDROPIRIDINA	10	\N
2411	BUTIRONITRILA	10	\N
2412	TETRA-HIDROTIOFENO	10	\N
2413	ORTOTITANATO DE TETRAPROPILA	10	\N
2414	TIOFENO	10	\N
2416	BORATO DE TRIMETILA	10	\N
2417	FLUORETO DE CARBONILA	9	\N
2418	TETRAFLUORETO DE ENXOFRE	9	\N
2419	BROMOTRIFLUORETILENO	7	\N
2420	HEXAFLUORACETONA	9	\N
2421	TRIÓXIDO DE NITROGÊNIO	9	\N
2422	OCTAFLÚOR-2-BUTENO	8	\N
2424	OCTAFLUORPROPANO	8	\N
2426	NITRATO DE AMÔNIO, LÍQUIDO (solução concentrada por aquecimento)	14	\N
2427	CLORATO DE POTÁSSIO, SOLUÇÃO AQUOSA	14	\N
2428	CLORATO DE SÓDIO, SOLUÇÃO AQUOSA	14	\N
2429	CLORATO DE CÁLCIO, SOLUÇÃO AQUOSA	14	\N
2430	ALQUIL  FENÓIS,  SÓLIDOS,   N.E. (incluindo  os homólogos  C2-C8)	16	\N
2431	ANISIDINAS	16	\N
2432	N,N-DIETILANILINA	16	\N
2433	NITROTOLUENOS CLORADOS	16	\N
2434	DIBENZILDICLOROSSILANO	19	\N
2435	ETILFENILDICLOROSSILANO	19	\N
2436	ÁCIDO TIOACÉTICO	10	\N
2437	METILFENILDICLOROSSILANO	19	\N
2438	CLORETO DE TRIMETILACETILA	19	\N
2439	BIFLUORETO DE SÓDIO	19	\N
2440	CLORETO ESTÂNICO, PENTAIDRATADO	19	\N
2441	TRICLORETO DE TITÂNIO, PIROFÓRICO ou MISTURAS DE TRICLORETO DE TITÂNIO, PIROFÓRICAS 	12	\N
2442	CLORETO DE TRICLOROACETILA	19	\N
2443	OXITRICLORETO DE VANÁDIO	19	\N
2444	TETRACLORETO DE VANÁDIO	19	\N
2445	LÍTIO-ALQUILAS	12	\N
2446	NITROCRESÓIS	16	\N
2447	FÓSFORO BRANCO, FUNDIDO	12	\N
2448	ENXOFRE, FUNDIDO	11	\N
2451	TRIFLUORETO DE NITROGÊNIO	9	\N
2452	ETILACETILENO, INIBIDO	7	\N
2453	FLUORETO DE ETILA	7	\N
2454	FLUORETO DE METILA	7	\N
2455	NITRITO DE METILA	8	\N
2456	2-CLOROPROPENO	10	\N
2457	2,3-DIMETILBUTANO	10	\N
2458	HEXADIENO	10	\N
2459	2-METIL-1-BUTENO	10	\N
2460	2-METIL-2-BUTENO	10	\N
2461	METILPENTADIENO	10	\N
2463	HIDRETO DE ALUMÍNIO	13	\N
2464	NITRATO DE BERÍLIO	14	\N
2465	ÁCIDO DICLOROISOCIANÚRICO, SECO, ou SAIS DE ÁCIDO DICLOROISOCIANÚRICO	14	\N
2466	SUPERÓXIDO DE POTÁSSIO	14	\N
2467	PERCARBONATOS DE SÓDIO	14	\N
2468	ÁCIDO TRICLOROISOCIANÚRICO, SECO	14	\N
2469	BROMATO DE ZINCO	14	\N
2470	FENILACETONITRILA, LÍQUIDA	16	\N
2471	TETRÓXIDO DE ÓSMIO	16	\N
2473	ARSANILATO DE SÓDIO	16	\N
2474	TIOFOSGÊNIO	16	\N
2475	TRICLORETO DE VANÁDIO	19	\N
2477	ISOTIOCIANATO DE METILA	10	\N
2478	ISOCIANATOS, N.E. ou SOLUÇÕES DE ISOCIANATOS, N.E. com PFg inferior a 23ºC	10	\N
2480	ISOCIANATO DE METILA	16	\N
2481	ISOCIANATO DE ETILA	10	\N
2482	ISOCIANATO DE n-PROPILA	10	\N
2483	ISOCIANATO DE ISOPROPILA	10	\N
2484	ISOCIANATO DE t-BUTILA	10	\N
2485	ISOCIANATO DE n-BUTILA	10	\N
2486	ISOCIANATO DE ISOBUTILA	10	\N
2487	ISOCIANATO DE FENILA	16	\N
2488	ISOCIANATO DE CICLO-HEXILA	16	\N
2489	DIFENILMETANO-4,4'-DIISOCIANATO	16	\N
2490	ÉTER DICLOROISOPROPÍLICO	16	\N
2491	ETANOLAMINA ou SOLUÇÕES DE ETANOLAMINA	19	\N
2493	HEXAMETILENOIMINA	10	\N
2495	PENTAFLUORETO DE IODO	14	\N
2496	ANIDRIDO PROPIÔNICO	19	\N
2497	FENOLATO DE SÓDIO, SÓLIDO	19	\N
2498	1,2,3,6-TETRA-HIDROBENZALDEÍDO	10	\N
2501	ÓXIDO DE TRI-(1-AZIRIDINIL) FOSFINA, SOLUÇÃO	16	\N
2502	CLORETO DE VALERILA	19	\N
2503	TETRACLORETO DE ZIRCÔNIO	19	\N
2504	TETRABROMOETANO	16	\N
2505	FLUORETO DE AMÔNIO	16	\N
2506	BISSULFATO DE AMÔNIO	19	\N
2507	ÁCIDO CLOROPLATÍNICO, SÓLIDO	19	\N
2508	PENTACLORETO DE MOLIBDÊNIO	19	\N
2509	BISSULFATO DE POTÁSSIO	19	\N
2511	ÁCIDO alfa-CLOROPROPIÔNICO	19	\N
2512	AMINOFENÓIS (o-,m-,p-)	16	\N
2513	BROMETO DE BROMOACETILA	19	\N
2514	BROMOBENZENO	10	\N
2515	BROMOFÓRMIO	16	\N
2516	TETRABROMETO DE CARBONO	16	\N
2517	CLORODIFLUORETANOS (DIFLUORCLOROETANOS)	7	\N
2518	1,5,9-CICLODODECATRIENO	16	\N
2520	CICLOOCTADIENOS	10	\N
2521	DICETENO, INIBIDO	10	\N
2522	METACRILATO DE DIMETILAMINOETILA	16	\N
2524	ORTOFORMIATO DE ETILA	10	\N
2525	OXALATO DE ETILA	16	\N
2526	FURFURILAMINA	10	\N
2527	ACRILATO DE ISOBUTILA	10	\N
2528	ISOBUTIRATO DE ISOBUTILA	10	\N
2529	ÁCIDO ISOBUTÍRICO	10	\N
2530	ANIDRIDO ISOBUTÍRICO	10	\N
2531	ÁCIDO METACRÍLICO, INIBIDO	19	\N
2533	TRICLOROACETATO DE METILA	16	\N
2534	METILCLOROSSILANO	9	\N
2535	METILMORFOLINA	10	\N
2536	METILTETRA-HIDROFURANO	10	\N
2538	NITRONAFTALENO	11	\N
2541	TERPINOLENO	10	\N
2542	TRIBUTILAMINA	19	\N
2545	HÁFNIO, EM PÓ, SECO	12	\N
2546	TITÂNIO, EM PÓ, SECO	12	\N
2547	SUPERÓXIDO DE SÓDIO	14	\N
2548	PENTAFLUORETO DE CLORO	9	\N
2552	HIDRATO DE HEXAFLUORACETONA	16	\N
2553	NAFTA	10	\N
2554	CLORETO DE METILALILA	10	\N
2555	NITROCELULOSE, COM ÁGUA  (no mínimo 25% de água, em  massa)	11	\N
2556	NITROCELULOSE COM ÁLCOOL (no mínimo 25% de álcool, em massa e com até 12,6% de nitrogênio, massa seca) 	11	\N
2557	NITROCELULOSE COM SUBSTÂNCIA PLASTIFICANTE (no mínimo 18% de substância plastificante, em massa  e com até 12,6% de nitrogênio, massa seca)	11	\N
2558	EPIBROMIDRINA	16	\N
2560	2-METILPENTAN-2-OL	10	\N
2561	3-METIL-1-BUTENO	10	\N
2564	ÁCIDO TRICLOROACÉTICO, SOLUÇÃO	19	\N
2565	DICICLO-HEXILAMINA	19	\N
2567	PENTACLOROFENATO DE SÓDIO	16	\N
2570	CÁDMIO, COMPOSTOS	16	\N
2571	ÁCIDO ETILSULFÚRICO	19	\N
2572	FENIL-HIDRAZINA	16	\N
2573	CLORATO DE TÁLIO	14	\N
2574	FOSFATO DE TRICRESILA, com mais de 3% de isômero orto	16	\N
2576	OXIBROMETO DE FÓSFORO, FUNDIDO	19	\N
2577	CLORETO DE FENILACETILA	19	\N
2578	TRIÓXIDO DE FÓSFORO	19	\N
2579	PIPERAZINA	19	\N
2580	BROMETO DE ALUMÍNIO, SOLUÇÃO	19	\N
2581	CLORETO DE ALUMÍNIO, SOLUÇÃO	19	\N
2582	CLORETO FÉRRICO, SOLUÇÃO	19	\N
2583	ÁCIDO ALQUIL, ARIL ou TOLUENO SULFÔNICO, SÓLIDO, com mais de 5% de ácido sulfúrico livre	19	\N
2584	ÁCIDO ALQUIL, ARIL ou TOLUENO SULFÔNICO,   LÍQUIDO, com mais de 5% de ácido sulfúrico livre	19	\N
2585	ÁCIDO ALQUIL, ARIL ou TOLUENO SULFÔNICO, SÓLIDO, com até 5% de ácido sulfúrico livre	19	\N
2586	ÁCIDO ALQUIL,  ARIL ou TOLUENO SULFÔNICO,  LÍQUIDO, com  até 5% de ácido sulfúrico livre	19	\N
2587	BENZOQUINONA	16	\N
2588	PESTICIDAS SÓLIDOS, TÓXICOS, N.E.	16	\N
2589	CLOROACETATO DE VINILA	16	\N
2590	AMIANTO BRANCO, (crisotila, actinólito, antofilita, tremolita)	20	\N
2591	XENÔNIO, LÍQUIDO REFRIGERADO	8	\N
2599	MISTURA  AZEOTRÓPICA DE CLOROTRIFLUORMETANO E  TRIFLUORMETANO, com aproximadamente 60% de cloro-trifluormetano	8	\N
2600	MISTURA DE HIDROGÊNIO E MONÓXIDO DE CARBONO	9	\N
2601	CICLOBUTANO	7	\N
2602	MISTURA AZEOTRÓPICA DE DICLORODIFLUORMETANO E DIFLUORETANO, com aproximadamente 74% de dicloro-difluormetano	8	\N
2603	CICLO-HEPTATRIENO	10	\N
2604	DIETILETERATO DE TRIFLUORETO DE BORO	19	\N
2605	ISOCIANATO DE METOXIMETILA	10	\N
2606	ORTO-SILICATO DE METILA	10	\N
2607	ACROLEÍNA, DIMERIZADA, ESTABILIZADA	10	\N
2608	NITROPROPANOS	10	\N
2609	BORATO DE TRIALILA	16	\N
2610	TRIALILAMINA	10	\N
2611	PROPENOCLORIDRINA	16	\N
2612	ÉTER METILPROPÍLICO	10	\N
2614	ÁLCOOL METALÍLICO	10	\N
2615	ÉTER ETILPROPÍLICO	10	\N
2616	BORATO DE TRIISOPROPILA	10	\N
2617	METILCICLO-HEXANÓIS, com ponto de fulgor até 60,5°C	10	\N
2618	VINILTOLUENO, INIBIDO, mistura de isômeros	10	\N
2619	BENZILDIMETILAMINA	19	\N
2620	BUTIRATO(S) DE AMILA	10	\N
2621	ACETILMETILCARBINOL	10	\N
2622	GLICIDALDEÍDO	10	\N
2623	ACENDEDORES, SÓLIDOS, com líquido inflamável	11	\N
2624	SILICIETO DE MAGNÉSIO	13	\N
2626	ÁCIDO CLÓRICO, SOLUÇÃO AQUOSA, com até 10% de ácido clórico 	14	\N
2627	NITRITOS INORGÂNICOS, N.E.	14	\N
2628	FLUORACETATO DE POTÁSSIO	16	\N
2629	FLUORACETATO DE SÓDIO	16	\N
2630	SELENATOS ou SELENITOS	16	\N
2642	ÁCIDO FLUORACÉTICO	16	\N
2643	ACETATO DE BROMOMETILA	16	\N
2644	IODETO DE METILA	16	\N
2645	BROMETO DE FENACILA	16	\N
2646	HEXACLOROCICLOPENTADIENO	16	\N
2647	MALONONITRILA	16	\N
2648	1,2-DIBROMOBUTAN-3-ONA	16	\N
2649	1,3-DICLOROACETONA	16	\N
2650	1,1-DICLORO-1-NITROETANO	16	\N
2651	4,4'-DIAMINODIFENILMETANO	16	\N
2653	IODETO DE BENZILA	16	\N
2655	FLUORSILICATO DE POTÁSSIO	16	\N
2656	QUINOLINA	16	\N
2657	DISSULFETO DE SELÊNIO	16	\N
2658	SELÊNIO, EM PÓ	16	\N
2659	CLOROACETATO DE SÓDIO	16	\N
2660	NITROTOLUIDINAS (MONO)	16	\N
2661	HEXACLOROACETONA	16	\N
2662	HIDROQUINONA	16	\N
2664	DIBROMOMETANO	16	\N
2666	CIANOACETATO DE ETILA	16	\N
2667	BUTILTOLUENOS	16	\N
2668	CLOROACETONITRILA	16	\N
2669	CLOROCRESÓIS	16	\N
2670	CLORETO CIANÚRICO	19	\N
2671	AMINOPIRIDINAS (o-,m-,p-)	16	\N
2672	AMÔNIA, SOLUÇÕES aquosas, com densidade relativa entre 0,880 e 0,957 a 15ºC, com mais de 10% e até 35% de amônia 	19	\N
2673	2-AMINO-4-CLOROFENOL	16	\N
2674	FLUORSILICATO DE SÓDIO	16	\N
2676	ESTIBINA	9	\N
2677	HIDRÓXIDO DE RUBÍDIO, SOLUÇÃO	19	\N
2678	HIDRÓXIDO DE RUBÍDIO	19	\N
2679	HIDRÓXIDO DE LÍTIO, SOLUÇÃO	19	\N
2680	HIDRÓXIDO DE LÍTIO, MONO-HIDRATADO	19	\N
2681	HIDRÓXIDO DE CÉSIO, SOLUÇÃO	19	\N
2682	HIDRÓXIDO DE CÉSIO	19	\N
2683	SULFETO DE AMÔNIO, SOLUÇÃO	19	\N
2684	DIETILAMINOPROPILAMINA	19	\N
2685	N,N-DIETILETILENODIAMINA	19	\N
2686	DIETILAMINOETANOL	10	\N
2687	NITRITO DE DICICLO-HEXILAMÔNIO	11	\N
2688	1-CLORO-3-BROMOPROPANO	16	\N
2689	GLICEROL-alfa-MONOCLORIDRINA	16	\N
2690	N,n-BUTILIMIDAZOL	16	\N
2691	PENTABROMETO DE FÓSFORO	19	\N
2692	TRIBROMETO DE BORO	19	\N
2693	BISSULFITOS INORGÂNICOS, SOLUÇÕES AQUOSAS, N.E.	19	\N
2698	ANIDRIDO(S)  TETRA-HIDROFTÁLICO(S), com mais e 0,05% de anidrido maléico	19	\N
2699	ÁCIDO TRIFLUORACÉTICO	19	\N
2705	1-PENTOL	19	\N
2707	DIMETILDIOXANAS	10	\N
2708	BUTOXIL	10	\N
2709	BUTILBENZENOS	10	\N
2710	DIPROPILCETONA	10	\N
2711	DIBROMOBENZENO	10	\N
2713	ACRIDINA	16	\N
2714	RESINATO DE ZINCO	11	\N
2715	RESINATO DE ALUMÍNIO	11	\N
2716	1,4-BUTINODIOL	16	\N
2717	CÂNFORA, sintética	11	\N
2719	BROMATO DE BÁRIO	14	\N
2720	NITRATO DE CROMO	14	\N
2721	CLORATO DE COBRE	14	\N
2722	NITRATO DE LÍTIO	14	\N
2723	CLORATO DE MAGNÉSIO	14	\N
2724	NITRATO DE MANGANÊS	14	\N
2725	NITRATO DE NÍQUEL	14	\N
2726	NITRITO DE NÍQUEL	14	\N
2727	NITRATO DE TÁLIO	16	\N
2728	NITRATO DE ZIRCÔNIO	14	\N
2729	HEXACLOROBENZENO	16	\N
2730	NITROANISOL	16	\N
2732	NITROBROMOBENZENO	16	\N
2733	ALQUILAMINAS, N.E., ou POLIALQUILAMINAS,  N.E., inflamáveis, corrosivas	10	\N
2734	ALQUILAMINAS, N.E., ou POLIALQUILAMINAS,  N.E., corrosivas, inflamáveis	19	\N
2735	ALQUILAMINAS, N.E., ou POLIALQUILAMINAS,  N.E., corrosivas 	19	\N
2738	N-BUTILANILINA	16	\N
2739	ANIDRIDO BUTÍRICO	19	\N
2740	CLOROFORMIATO DE n-PROPILA	16	\N
2741	HIPOCLORITO DE BÁRIO, com mais de 22% de cloro livre	14	\N
2742	CLOROFORMIATOS, N.E., com PFg maior ou igual a 23°C	16	\N
2743	CLOROFORMIATO DE n-BUTILA	16	\N
2744	CLOROFORMIATO DE CICLOBUTILA	16	\N
2745	CLOROFORMIATO DE CLOROMETILA	16	\N
2746	CLOROFORMIATO DE FENILA	16	\N
2747	CLOROFORMIATO DE t-BUTILCICLO-HEXILA	16	\N
2748	CLOROFORMIATO DE 2-ETIL-HEXILA	16	\N
2749	TETRAMETILSILANO	10	\N
2750	1,3-DICLOROPROPANOL-2	16	\N
2751	CLORETO DE DIETILTIOFOSFORILA	19	\N
2752	1,2-EPÓXI-3-ETOXIPROPANO	10	\N
2753	N-ETILBENZILTOLUIDINAS	16	\N
2754	N-ETILTOLUIDINAS	16	\N
2757	PESTICIDAS À BASE DE CARBAMATOS, SÓLIDOS, TÓXICOS,  N.E.	16	\N
2758	PESTICIDAS À BASE DE CARBAMATOS, LÍQUIDOS, INFLAMÁVEIS, TÓXICOS, N.E., com PFg inferior a 23ºC	10	\N
2759	PESTICIDAS À BASE DE ARSÊNIO, SÓLIDOS, TÓXICOS, N.E.	16	\N
2760	PESTICIDAS À BASE DE ARSÊNIO, LÍQUIDOS, INFLAMÁVEIS, TÓXICOS, N.E., com PFg inferior a 23ºC	10	\N
2761	PESTICIDAS À BASE DE ORGANOCLORADOS, SÓLIDOS, TÓXICOS, N.E.	16	\N
2762	PESTICIDAS À BASE DE ORGANOCLORADOS, LÍQUIDOS, INFLAMÁVEIS, TÓXICOS, N.E., com PFg inferior a 23ºC	10	\N
2763	PESTICIDAS À BASE DE TRIAZINA, SÓLIDOS, TÓXICOS, N.E.	16	\N
2764	PESTICIDAS À BASE DE TRIAZINA, LÍQUIDOS, INFLAMÁVEIS, TÓXICOS, N.E., com PFg inferior a 23ºC	10	\N
2765	PESTICIDAS À BASE DE FENÓXICOS, SÓLIDOS, TÓXICOS, N.E.	16	\N
2766	PESTICIDAS À BASE DE FENÓXICOS, LÍQUIDOS, INFLAMÁVEIS, TÓXICOS, N.E., com PFg inferior a 23ºC  	10	\N
2767	PESTICIDAS À BASE DE FENILURÉIA, SÓLIDOS, TÓXICOS, N.E. 	16	\N
2768	PESTICIDAS À BASE DE FENILURÉIA, LÍQUIDOS, INFLAMÁVEIS, TÓXICOS, N.E., com PFg inferior a 23ºC	10	\N
2769	PESTICIDAS À BASE DE DERIVADOS BENZÓICOS, SÓLIDOS, TÓXICOS, N.E.	16	\N
2770	PESTICIDAS À BASE DE DERIVADOS BENZÓICOS, LÍQUIDOS, INFLAMÁVEIS, TÓXICOS, N.E., com PFg inferior a  23º C 	10	\N
2771	PESTICIDAS À BASE DE DITIOCARBAMATOS, SÓLIDOS, TÓXICOS, N.E.	16	\N
2772	PESTICIDAS À BASE DE DITIOCARBAMATOS, LÍQUIDOS, INFLAMÁVEIS, TÓXICOS, N.E., com PFg inferior a 23ºC	10	\N
2773	PESTICIDAS À BASE DE DERIVADOS DE FTALIMIDAS, SÓLIDOS, TÓXICOS, N.E.	16	\N
2774	PESTICIDAS À BASE DE DERIVADOS DE FTALIMIDAS, LÍQUIDOS, INFLAMÁVEIS, TÓXICOS, N.E., com PFg inferior a 23ºC	10	\N
2775	PESTICIDAS À BASE DE COBRE, SÓLIDOS, TÓXICOS, N.E.	16	\N
2776	PESTICIDAS À BASE DE COBRE, LÍQUIDOS, INFLAMÁVEIS, TÓXICOS, N.E., com PFg inferior a 23ºC	10	\N
2777	PESTICIDAS À BASE DE MERCÚRIO, SÓLIDOS, TÓXICOS, N.E.	16	\N
2778	PESTICIDAS À BASE DE MERCÚRIO, LÍQUIDOS, INFLAMÁVEIS, TÓXICOS, N.E., com PFg inferior  a 23ºC	10	\N
2779	PESTICIDAS À BASE DE DERIVADOS DO NITROFENOL, SÓLIDOS, TÓXICOS, N.E.	16	\N
2780	PESTICIDAS À BASE DE DERIVADOS DO NITROFENOL, LÍQUIDOS, INFLAMÁVEIS, TÓXICOS, N.E., com PFg inferior a  23ºC	10	\N
2781	PESTICIDAS À BASE DE DIPIRIDÍLIO, SÓLIDOS, TÓXICOS, N.E.	16	\N
2782	PESTICIDAS À BASE DE DIPIRIDÍLIO, LÍQUIDOS, INFLAMÁVEIS, TÓXICOS, N.E., com PFg inferior a 23ºC	10	\N
2783	PESTICIDAS À BASE DE ORGANOFOSFORADOS, SÓLIDOS, TÓXICOS, N.E.	16	\N
2784	PESTICIDAS À BASE DE ORGANOFOSFORADOS, LÍQUIDOS, INFLAMÁVEIS, TÓXICOS, N.E., com PFg inferior a 23ºC	10	\N
2785	TIA-4-PENTANAL	16	\N
2786	PESTICIDAS À BASE DE COMPOSTOS ORGÂNICOS DE ESTANHO, SÓLIDOS, TÓXICOS, N.E.	16	\N
2787	PESTICIDAS À BASE DE COMPOSTOS ORGÂNICOS DE ESTANHO,  LÍQUIDOS, INFLAMÁVEIS, TÓXICOS, N.E., com PFg inferior a 23ºC	10	\N
2788	ESTANHO, COMPOSTOS ORGÂNICOS, LÍQUIDOS, N.E.	16	\N
2789	ÁCIDO ACÉTICO, GLACIAL ou SOLUÇÃO DE ÁCIDO ACÉTICO, com mais de 80% de ácido, em massa	19	\N
2790	ÁCIDO ACÉTICO, SOLUÇÃO, com mais de 10% e até 80% de ácido, em massa	19	\N
2793	METAL FERROSO, LIMALHAS, LASCAS, CAVACOS ou APARAS, sob forma passível de auto-aquecimento	12	\N
2794	BATERIAS ELÉTRICAS, ÚMIDAS, CONTENDO SOLUÇÕES ÁCIDAS	19	\N
2795	BATERIAS ELÉTRICAS, ÚMIDAS,  CONTENDO SOLUÇÕES ALCALINAS	19	\N
2796	FLUIDO ÁCIDO PARA BATERIAS	19	\N
2797	FLUIDO ALCALINO PARA BATERIAS	19	\N
2798	DICLORETO DE FOSFOROFENIL	19	\N
2799	DICLORETO DE FOSFOROTIOFENIL	19	\N
2800	BATERIAS ELÉTRICAS, ÚMIDAS, À  PROVA DE RESPINGOS	19	\N
2801	CORANTES, LÍQUIDOS, N.E., ou INTERMEDIÁRIOS PARA  CORANTES, LÍQUIDOS, N.E., corrosivos	19	\N
2802	CLORETO DE COBRE	19	\N
2803	GÁLIO	19	\N
2805	HIDRETO DE LÍTIO, SÓLIDO FUNDIDO	13	\N
2806	NITRETO DE LÍTIO	13	\N
2807	MATERIAL MAGNETIZADO	20	\N
2809	MERCÚRIO	19	\N
2810	LÍQUIDO TÓXICO, N.E.	16	\N
2811	SÓLIDO TÓXICO, N.E.	16	\N
2812	ALUMINATO DE SÓDIO, SÓLIDO	19	\N
2813	SÓLIDO QUE REAGE COM ÁGUA, N.E.	13	\N
2814	SUBSTÂNCIAS INFECTANTES, QUE AFETAM SERES HUMANOS	17	\N
2815	N-AMINOETILPIPERAZINA	19	\N
2817	BIFLUORETO DE AMÔNIO, SOLUÇÃO	19	\N
2818	POLISSULFETO DE AMÔNIO, SOLUÇÃO	19	\N
2819	FOSFATO ÁCIDO DE AMILA	19	\N
2820	ÁCIDO BUTÍRICO	19	\N
2821	FENOL, SOLUÇÕES	16	\N
2822	2-CLOROPIRIDINA	16	\N
2823	ÁCIDO CROTÔNICO	19	\N
2826	CLOROTIOFORMIATO DE ETILA	19	\N
2829	ÁCIDO CAPRÓICO	19	\N
2830	LÍTIO-FERRO-SILÍCIO	13	\N
2831	1,1,1-TRICLOROETANO	16	\N
2834	ÁCIDO ORTOFOSFOROSO	19	\N
2835	HIDRETO DUPLO DE SÓDIO E ALUMÍNIO	13	\N
2837	BISSULFATO DE SÓDIO, SOLUÇÃO	19	\N
2838	BUTIRATO DE VINILA, INIBIDO	10	\N
2839	ALDOL	16	\N
2840	BUTIRALDOXIMA	10	\N
2841	DI-n-AMILAMINA	16	\N
2842	NITROETANO	10	\N
2844	CÁLCIO-MANGANÊS-SILÍCIO	13	\N
2845	LÍQUIDO PIROFÓRICO, ORGÂNICO, N.E.	12	\N
2846	SÓLIDO PIROFÓRICO, ORGÂNICO, N.E.	12	\N
2849	3-CLOROPROPANOL-1	16	\N
2850	PROPENO TETRÂMERO	10	\N
2851	DI-HIDRATO DE TRIFLUORETO DE BORO	19	\N
2852	SULFETO DE DIPICRILA, UMEDECIDO com, no mínimo, 10% de água, em massa	11	\N
2853	FLUORSILICATO DE MAGNÉSIO	16	\N
2854	FLUORSILICATO DE AMÔNIO	16	\N
2855	FLUORSILICATO DE ZINCO	16	\N
2856	FLUORSILICATOS, N.E.	16	\N
2857	MÁQUINAS DE REFRIGERAÇÃO, contendo gás liquefeito, não-inflamável e não-tóxico	8	\N
2858	ZIRCÔNIO, SECO, bobinas de arame, chapas metálicas acabadas, tiras (mais delgadas que 254 micra, mas com espessura não-inferior a 18 micra)	11	\N
2859	METAVANADATO DE AMÔNIO	16	\N
2860	TRIÓXIDO DE VANÁDIO, não-fundido	16	\N
2861	POLIVANADATO DE AMÔNIO	16	\N
2862	PENTÓXIDO DE VANÁDIO, não-fundido	16	\N
2863	VANADATO DUPLO DE SÓDIO E AMÔNIO	16	\N
2864	METAVANADATO DE POTÁSSIO	16	\N
2865	SULFATO DE HIDROXILAMINA	19	\N
2869	MISTURA(S) DE TRICLORETO DE TITÂNIO	19	\N
2870	BORO-HIDRETO DE ALUMÍNIO ou DISPOSITIVOS DE BORO-HIDRETO DE ALUMÍNIO	12	\N
2871	ANTIMÔNIO, EM PÓ	16	\N
2872	DIBROMOCLOROPROPANOS	16	\N
2873	DIBUTILAMINOETANOL	16	\N
2874	ÁLCOOL FURFURÍLICO	16	\N
2875	HEXACLOROFENO	16	\N
2876	RESORCINOL	16	\N
2878	TITÂNIO ESPONJOSO, GRÂNULOS ou EM PÓ	11	\N
2879	OXICLORETO DE SELÊNIO	19	\N
2880	HIPOCLORITO DE CÁLCIO, HIDRATADO, ou MISTURAS HIDRATADAS DE HIPOCLORITO DE CÁLCIO, com entre 5,5% e 10% de  água 	14	\N
2881	CATALISADOR METÁLICO, SECO	12	\N
2900	SUBSTÂNCIAS INFECTANTES, QUE AFETAM apenas ANIMAIS	17	\N
2901	CLORETO DE BROMO	9	\N
2902	PESTICIDAS LÍQUIDOS, TÓXICOS, N.E.	16	\N
2903	PESTICIDAS LÍQUIDOS, TÓXICOS, INFLAMÁVEIS, N.E., com PFg igual ou superior a 23ºC	16	\N
2904	CLOROFENATOS, LÍQUIDOS	19	\N
2905	CLOROFENATOS, SÓLIDOS	19	\N
2906	TRIISOCIANATOISOCIANURATO DE ISOFORONADIISO-CIANATO, SOLUÇÃO (70%, em massa)	10	\N
2907	DINITRATO DE ISO-SORBIDE, MISTURA, com no mínimo 60% de lactose, manose, amido ou fosfato ácido de cálcio	11	\N
2910		18	\N
2912	MATERIAL RADIOATIVO, BAIXA ATIVIDADE ESPECÍFICA (BAE), N.E.	18	\N
2913	MATERIAL RADIOATIVO, OBJETOS CONTAMINADOS NA SUPERFÍCIE (OCS)	18	\N
2918	MATERIAL RADIOATIVO, FÍSSIL, N.E.	18	\N
2920	LÍQUIDO CORROSIVO, INFLAMÁVEL, N.E.	19	\N
2921	SÓLIDO CORROSIVO, INFLAMÁVEL, N.E.	19	\N
2922	LÍQUIDO CORROSIVO, TÓXICO, N.E.	19	\N
2923	SÓLIDO CORROSIVO, TÓXICO, N.E.	19	\N
2924	LÍQUIDO INFLAMÁVEL, CORROSIVO, N.E.	10	\N
2925	SÓLIDO INFLAMÁVEL, CORROSIVO, ORGÂNICO, N.E.	11	\N
2926	SÓLIDO INFLAMÁVEL, TÓXICO, ORGÂNICO, N.E.	11	\N
2927	LÍQUIDO TÓXICO, CORROSIVO, N.E.	16	\N
2928	SÓLIDO TÓXICO, CORROSIVO, N.E.	16	\N
2929	LÍQUIDO TÓXICO, INFLAMÁVEL, N.E.	16	\N
2930	SÓLIDO TÓXICO, INFLAMÁVEL, N.E.	16	\N
2931	SULFATO DE VANADILA	16	\N
2933	2-CLOROPROPIONATO DE METILA	10	\N
2934	ISOPROPIL-2-CLOROPROPIONATO	10	\N
2935	ETIL-2-CLOROPROPIONATO	10	\N
2936	ÁCIDO TIOLÁTICO	16	\N
2937	ÁLCOOL alfa-METILBENZÍLICO	16	\N
2938	BENZOATO DE METILA	16	\N
2940	9-FOSFABICICLONONANOS (FOSFINAS DE CICLOOCTA-DIENO)	12	\N
2941	FLUORANILINAS	16	\N
2942	2-TRIFLUORMETILANILINA	16	\N
2943	TETRA-HIDROFURFURILAMINA	10	\N
2945	N-METILBUTILAMINA	10	\N
2946	2-AMINO-5-DIETILAMINOPENTANO	16	\N
2947	CLOROACETATO DE ISOPROPILA	10	\N
2948	3-TRIFLUORMETILANILINA	16	\N
2949	HIDRO-SULFETO DE SÓDIO, com, no mínimo, 25% de água de cristalização	19	\N
2950	MAGNÉSIO, GRÂNULOS REVESTIDOS, partículas com dimensões não-inferiores a 149 micra	13	\N
2956	5-t-BUTIL-2,4,6-TRINITRO-m-XILENO	11	\N
2965	DIMETILETERATO DE TRIFLUORETO DE BORO	13	\N
2966	TIOGLICOL	16	\N
2967	ÁCIDO SULFÂMICO	19	\N
2968	MANEB, ESTABILIZADO, ou PREPARAÇÕES DE MANEB, ESTABILIZADAS contra auto-aquecimento	13	\N
2969	MAMONA, GRÃOS, FARINHA, PASTA, ou FLOCOS	20	\N
2974	MATERIAL RADIOATIVO, FORMA ESPECIAL, N.E.	18	\N
2975	TÓRIO, METÁLICO, PIROFÓRICO	18	\N
2976	NITRATO DE TÓRIO, SÓLIDO	18	\N
2977	HEXAFLUORETO DE URÂNIO, FÍSSIL, contendo mais de 1,0% de Urânio-235	18	\N
2978	HEXAFLUORETO DE URÂNIO, não-físsil ou físsil com isenção	18	\N
2979	URÂNIO METÁLICO, PIROFÓRICO	18	\N
2980	NITRATO DE URANILA HEXA-HIDRATADO, SOLUÇÃO	18	\N
2981	NITRATO DE URANILA, SÓLIDO	18	\N
2982	MATERIAL RADIOATIVO, N.E.	18	\N
2983	MISTURA(S) DE ÓXIDO DE ETENO E ÓXIDO DE PROPILENO, com até 30% de óxido de eteno	10	\N
2984	PERÓXIDO DE HIDROGÊNIO, SOLUÇÕES AQUOSAS, com 8% ou mais e menos de 20% de peróxido de hidrogênio (estabilizadas se necessário)	14	\N
2985	CLOROSSILANOS, N.E., com PFg abaixo de 23°C	10	\N
2986	CLOROSSILANOS, N.E., com PFg igual ou superior a 23°C	19	\N
2987	CLOROSSILANOS, N.E.	19	\N
2988	CLOROSSILANOS, N.E., que em contato com água emitem gases inflamáveis	13	\N
2989	FOSFITO DIBÁSICO DE CHUMBO	11	\N
2990	DISPOSITIVOS SALVA-VIDAS, AUTO-INFLÁVEIS	20	\N
2991	PESTICIDAS À BASE DE CARBAMATOS, LÍQUIDOS, TÓXICOS, INFLAMÁVEIS, N.E., com PFg igual ou superior a 23ºC	16	\N
2992	PESTICIDAS À BASE DE CARBAMATOS, LÍQUIDOS, TÓXICOS, N.E.	16	\N
2993	PESTICIDAS À BASE DE ARSÊNIO, LÍQUIDOS, TÓXICOS, INFLAMÁVEIS, N.E., com PFg igual ou superior a 23ºC	16	\N
2994	PESTICIDAS À BASE DE ARSÊNIO, LÍQUIDOS, TÓXICOS, N.E.	16	\N
2995	PESTICIDAS À BASE DE ORGANOCLORADOS, LÍQUIDOS, TÓXICOS, INFLAMÁVEIS, N.E., com PFg igual ou superior a 23ºC	16	\N
2996	PESTICIDAS À BASE DE ORGANOCLORADOS, LÍQUIDOS, TÓXICOS, N.E.	16	\N
2997	PESTICIDAS À BASE DE TRIAZINA, LÍQUIDOS, TÓXICOS, INFLAMÁVEIS, N.E., com PFg igual ou superior a 23ºC	16	\N
2998	PESTICIDAS À BASE DE TRIAZINA, LÍQUIDOS, TÓXICOS, N.E.	16	\N
2999	PESTICIDAS À BASE DE FENÓXICOS, LÍQUIDOS, TÓXICOS, INFLAMÁVEIS, N.E., com PFg igual ou superior a 23ºC	16	\N
3000	PESTICIDAS À BASE DE FENÓXICOS, LÍQUIDOS, TÓXICOS, N.E.	16	\N
3001	PESTICIDAS À BASE DE FENILURÉIA, LÍQUIDOS, TÓXICOS, INFLAMÁVEIS, N.E., com PFg igual  ou superior a 23ºC 	16	\N
3002	PESTICIDAS À BASE DE FENILURÉIA, LÍQUIDOS, TÓXICOS, N.E. 	16	\N
3003	PESTICIDAS À BASE DE DERIVADOS BENZÓICOS, LÍQUIDOS,  TÓXICOS, INFLAMÁVEIS, N.E., com PFg igual ou superior a 23ºC	16	\N
3004	PESTICIDAS À BASE DE DERIVADOS BENZÓICOS, LÍQUIDOS, TÓXICOS, N.E.	16	\N
3005	PESTICIDAS À BASE DE DITIOCARBAMATOS, LÍQUIDOS, TÓXICOS, INFLAMÁVEIS, N.E., com PFg igual ou superior a 23ºC	16	\N
3006	PESTICIDAS À BASE DE DITIOCARBAMATOS, LÍQUIDOS, TÓXICOS, N.E.	16	\N
3007	PESTICIDAS À BASE DE DERIVADOS DE FTALIMIDAS, LÍQUIDOS, TÓXICOS, INFLAMÁVEIS, N.E., com PFg igual ou superior a 23ºC	16	\N
3008	PESTICIDAS À BASE DE DERIVADOS DE FTALIMIDAS, LÍQUIDOS, TÓXICOS, N.E.	16	\N
3009	PESTICIDAS À BASE DE COBRE, LÍQUIDOS, TÓXICOS, INFLAMÁVEIS, N.E.,  com PFg igual ou superior a 23ºC	16	\N
3010	PESTICIDAS À BASE DE COBRE, LÍQUIDOS,  TÓXICOS, N.E.	16	\N
3011	PESTICIDAS À BASE DE MERCÚRIO, LÍQUIDOS, TÓXICOS, INFLAMÁVEIS, N.E., com PFg igual ou superior a 23ºC 	16	\N
3012	PESTICIDAS À BASE DE MERCÚRIO, LÍQUIDOS, TÓXICOS, N.E.	16	\N
3013	PESTICIDAS À BASE DE DERIVADOS DO NITROFENOL, LÍQUIDOS, TÓXICOS, INFLAMÁVEIS, N.E.,  com PFg igual ou superior a 23ºC	16	\N
3014	PESTICIDAS À BASE DE DERIVADOS DO NITROFENOL, LÍQUIDOS, TÓXICOS, N.E.	16	\N
3015	PESTICIDAS À BASE DE DIPIRIDÍLIO, LÍQUIDOS, TÓXICOS, INFLAMÁVEIS, N.E., com PFg igual ou superior a 23ºC	16	\N
3016	PESTICIDAS À BASE DE DIPIRIDÍLIO, LÍQUIDOS, TÓXICOS, N.E.	16	\N
3017	PESTICIDAS À BASE DE ORGANOFOSFORADOS, LÍQUIDOS, TÓXICOS, INFLAMÁVEIS, N.E.,  com PFg igual ou superior a 23ºC	16	\N
3018	PESTICIDAS À BASE DE ORGANOFOSFORADOS, LÍQUIDOS, TÓXICOS, N.E.	16	\N
3019	PESTICIDAS À BASE DE COMPOSTOS ORGÂNICOS DE ESTANHO, LÍQUIDOS,TÓXICOS, INFLAMÁVEIS, N.E., com PFg igual ou superior a 23º C	16	\N
3020	PESTICIDAS À BASE DE COMPOSTOS ORGÂNICOS DE ESTANHO, LÍQUIDOS, TÓXICOS, N.E.	16	\N
3021	PESTICIDAS LÍQUIDOS, INFLAMÁVEIS, TÓXICOS, N.E., com PFg inferior a 23ºC	10	\N
3022	ÓXIDO DE 1,2-BUTILENO, ESTABILIZADO	10	\N
3023	t-OCTILMERCAPTANA	16	\N
3024	PESTICIDAS À BASE DE DERIVADOS DA CUMARINA, LÍQUIDOS, INFLAMÁVEIS, TÓXICOS, N.E., com PFg inferior a 23ºC	10	\N
3025	PESTICIDAS À BASE DE DERIVADOS DA CUMARINA, LÍQUIDOS, TÓXICOS, INFLAMÁVEIS, N.E., com PFg igual ou superior a 23ºC	16	\N
3026	PESTICIDAS À BASE DE DERIVADOS DA CUMARINA, LÍQUIDOS, TÓXICOS, N.E.	16	\N
3027	PESTICIDAS À BASE DE DERIVADOS DA CUMARINA, SÓLIDOS, TÓXICOS, N.E.	16	\N
3028	BATERIAS ELÉTRICAS, SECAS, CONTENDO HIDRÓXIDO DE POTÁSSIO SÓLIDO	19	\N
3048	PESTICIDAS À BASE DE FOSFETO DE ALUMÍNIO	16	\N
3049	HALETOS DE ALQUIL METAIS, N.E. ou HALETOS DE ARIL METAIS, N.E.	12	\N
3050	HIDRETO(S) DE ALQUIL METAIS, N.E. ou HIDRETO(S) DE ARIL METAIS, N.E.	12	\N
3051	ALUMINIOALQUILAS	12	\N
3052	HALETOS DE ALUMÍNIOALQUILAS	12	\N
3053	MAGNESIOALQUILAS	12	\N
3054	CICLO-HEXIL MERCAPTANA	10	\N
3055	2-(2-AMINOETÓXI) ETANOL	19	\N
3056	n-HEPTALDEÍDO	10	\N
3057	CLORETO DE TRIFLUORACETILA	9	\N
3064	NITROGLICERINA, EM SOLUÇÃO ALCOÓLICA, com mais de 1% e até  5% de nitroglicerina	10	\N
3065	BEBIDAS ALCOÓLICAS	10	\N
3066	TINTA (incluindo tintas, lacas, esmaltes, tinturas, goma-lacas, vernizes, polidores, enchimentos líquidos e bases líquidas para lacas) ou MATERIAL RELACIONADO COM TINTAS (incluindo diluentes ou redutores para tintas)	19	\N
3070	MISTURA(S) DE DICLORODIFLUORMETANO E ÓXIDO DE ETENO, com até 12% de óxido de eteno	9	\N
3071	MERCAPTANAS, LÍQUIDAS, N.E., ou MISTURAS DE MERCAPTANAS, LÍQUIDAS, N.E., com PFg igual ou superior a 23ºC	16	\N
3072	DISPOSITIVOS SALVA-VIDAS, NÃO AUTO-INFLÁVEIS, contendo produtos perigosos como equipamento	20	\N
3073	VINILPIRIDINAS, INIBIDAS	16	\N
3076	HIDRETO(S) DE ALUMINIOALQUILAS	12	\N
3077	SUBSTÂNCIAS QUE APRESENTAM RISCO PARA O MEIO AMBIENTE, SÓLIDAS, N.E.	20	\N
3078	CÉRIO, aparas de torneamento ou pó de granulação grossa	13	\N
3079	METACRILONITRILA, INIBIDA	10	\N
3080	ISOCIANATOS, N.E. ou SOLUÇÕES DE ISOCIANATOS, N.E. com PFg entre 23ºC e 60,5ºC e PE inferior a 300ºC	16	\N
3082	SUBSTÂNCIAS QUE APRESENTAM RISCO PARA O MEIO AMBIENTE, LÍQUIDAS, N.E.	20	\N
3083	FLUORETO DE PERCLORILA	9	\N
3084	SÓLIDO CORROSIVO, OXIDANTE, N.E.	19	\N
3085	SÓLIDO OXIDANTE, CORROSIVO, N.E.	14	\N
3086	SÓLIDO TÓXICO, OXIDANTE, N.E.	16	\N
3087	SÓLIDO OXIDANTE, TÓXICO, N.E.	14	\N
3088	SÓLIDO SUJEITO A AUTO-AQUECIMENTO, ORGÂNICO, N.E.	12	\N
3089	METAIS EM PÓ, INFLAMÁVEIS, N.E.	11	\N
3090	BATERIAS DE LÍTIO	20	\N
3091	BATERIAS DE LÍTIO, CONTIDAS EM EQUIPAMENTOS	20	\N
3092	1-METÓXI-2-PROPANOL	10	\N
3093	LÍQUIDO CORROSIVO, OXIDANTE, N.E.	19	\N
3094	LÍQUIDO CORROSIVO, QUE REAGE COM ÁGUA, N.E.	19	\N
3095	SÓLIDO CORROSIVO, SUJEITO A AUTO-AQUECIMENTO, N.E.	19	\N
3096	SÓLIDO CORROSIVO, QUE REAGE COM ÁGUA, N.E.	19	\N
3097	SÓLIDO INFLAMÁVEL, OXIDANTE, N.E.	11	\N
3098	LÍQUIDO OXIDANTE, CORROSIVO, N.E.	14	\N
3099	LÍQUIDO OXIDANTE, TÓXICO, N.E.	14	\N
3100	SÓLIDO OXIDANTE, SUJEITO A AUTO-AQUECIMENTO, N.E.	14	\N
3101	PERÓXIDO ORGÂNICO TIPO B, LÍQUIDO	15	\N
3102	PERÓXIDO ORGÂNICO TIPO B, SÓLIDO	15	\N
3103	PERÓXIDO ORGÂNICO TIPO C,  LÍQUIDO	15	\N
3104	PERÓXIDO ORGÂNICO TIPO C, SÓLIDO	15	\N
3105	PERÓXIDO ORGÂNICO TIPO D, LÍQUIDO	15	\N
3106	PERÓXIDO ORGÂNICO TIPO D, SÓLIDO	15	\N
3107	PERÓXIDO ORGÂNICO TIPO E, LÍQUIDO	15	\N
3108	PERÓXIDO ORGÂNICO TIPO E, SÓLIDO	15	\N
3109	PERÓXIDO ORGÂNICO TIPO F, LÍQUIDO	15	\N
3110	PERÓXIDO ORGÂNICO TIPO F, SÓLIDO	15	\N
3111	PERÓXIDO ORGÂNICO TIPO B, LÍQUIDO, TEMPERATURA CONTROLADA	15	\N
3112	PERÓXIDO ORGÂNICO TIPO B, SÓLIDO, TEMPERATURA CONTROLADA	15	\N
3113	PERÓXIDO ORGÂNICO TIPO C, LÍQUIDO, TEMPERATURA CONTROLADA	15	\N
3114	PERÓXIDO ORGÂNICO TIPO C, SÓLIDO, TEMPERATURA CONTROLADA	15	\N
3115	PERÓXIDO ORGÂNICO TIPO D, LÍQUIDO, TEMPERATURA CONTROLADA	15	\N
3116	PERÓXIDO ORGÂNICO TIPO D, SÓLIDO, TEMPERATURA CONTROLADA	15	\N
3117	PERÓXIDO ORGÂNICO TIPO E, LÍQUIDO, TEMPERATURA CONTROLADA	15	\N
3118	PERÓXIDO ORGÂNICO TIPO E, SÓLIDO, TEMPERATURA CONTROLADA	15	\N
3119	PERÓXIDO ORGÂNICO TIPO F, LÍQUIDO, TEMPERATURA CONTROLADA	15	\N
3120	PERÓXIDO ORGÂNICO TIPO F, SÓLIDO, TEMPERATURA CONTROLADA	15	\N
3121	SÓLIDO OXIDANTE, QUE REAGE COM ÁGUA, N.E.	14	\N
3122	LÍQUIDO TÓXICO, OXIDANTE, N.E.	16	\N
3123	LÍQUIDO TÓXICO, QUE REAGE COM ÁGUA, N.E.	16	\N
3124	SÓLIDO TÓXICO, SUJEITO A AUTO-AQUECIMENTO, N.E.	16	\N
3125	SÓLIDO TÓXICO, QUE REAGE COM ÁGUA, N.E.	16	\N
3126	SÓLIDO SUJEITO A AUTO-AQUECIMENTO, CORROSIVO, ORGÂNICO, N.E.	12	\N
3127	SÓLIDO SUJEITO A AUTO-AQUECIMENTO, OXIDANTE, N.E.	12	\N
3128	SÓLIDO SUJEITO A AUTO-AQUECIMENTO, TÓXICO, ORGÂNICO, N.E.	12	\N
3129	LÍQUIDO QUE REAGE COM ÁGUA, CORROSIVO, N.E.	13	\N
3130	LÍQUIDO QUE REAGE COM ÁGUA, TÓXICO, N.E.	13	\N
3131	SÓLIDO QUE REAGE COM ÁGUA, CORROSIVO, N.E.	13	\N
3132	SÓLIDO QUE REAGE COM ÁGUA, INFLAMÁVEL, N.E.	13	\N
3133	SÓLIDO QUE REAGE COM ÁGUA, OXIDANTE, N.E.	13	\N
3134	SÓLIDO QUE REAGE COM ÁGUA, TÓXICO, N.E.	13	\N
3135	SÓLIDO QUE REAGE COM ÁGUA, SUJEITO A AUTO-AQUECIMENTO, N.E.	13	\N
3136	TRIFLUORMETANO, LÍQUIDO REFRIGERADO	8	\N
3137	SÓLIDO OXIDANTE, INFLAMÁVEL, N.E.	14	\N
3138	MISTURA(S) DE ETENO, ACETILENO E PROPENO, LÍQUIDA(S), REFRIGERADA(S), contendo, no mínimo, 71,5% de eteno, até 22,5% de acetileno e até 6% de propeno 	7	\N
3139	LÍQUIDO OXIDANTE, N.E.	14	\N
3140	ALCALÓIDES, LÍQUIDOS, N.E., ou SAIS DE ALCALÓIDES, LÍQUIDOS, N.E., tóxicos	16	\N
3141	ANTIMÔNIO, COMPOSTOS INORGÂNICOS, LÍQUIDOS, N.E.	16	\N
3142	DESINFETANTES, LÍQUIDOS, N.E., tóxicos	16	\N
3143	CORANTES, SÓLIDOS, N.E., ou INTERMEDIÁRIOS PARA CORANTES. SÓLIDOS, N.E., tóxicos	16	\N
3144	NICOTINA, COMPOSTOS LÍQUIDOS, N.E., ou PREPARAÇÕES  LÍQUIDAS, N.E.	16	\N
3145	ALQUIL  FENÓIS,  LÍQUIDOS, N.E.   (incluindo  os  homólogos C2-C8)	16	\N
3146	ESTANHO, COMPOSTOS ORGÂNICOS, SÓLIDOS, N.E.	16	\N
3147	CORANTES, SÓLIDOS, N.E., ou INTERMEDIÁRIOS PARA CORANTES, SÓLIDOS, N.E., corrosivos	19	\N
3148	LÍQUIDO QUE REAGE COM ÁGUA, N.E.	13	\N
3149	MISTURA DE PERÓXIDO DE HIDROGÊNIO E ÁCIDO PERACÉTICO, com ácido(s), água e, no máximo 5% de ácido peracético, estabilizada 	14	\N
3150	DISPOSITIVOS, PEQUENOS, ACIONADOS POR HIDRO-CARBONETOS GASOSOS, ou CARGAS DE HIDRO-CARBONETOS GASOSOS PARA PEQUENOS DISPOSITIVOS, com difusor 	7	\N
3151	BIFENILAS POLI-HALOGENADAS, LÍQUIDAS ou TERFENILAS POLI-HALOGENADAS, LÍQUIDAS	20	\N
3152	BIFENILAS POLI-HALOGENADAS, SÓLIDAS, ou TERFENILAS  POLI-HALOGENADAS, SÓLIDAS	20	\N
3153	ÉTER PERFLUORMETILVINÍLICO	7	\N
3154	ÉTER PERFLUORETILVINÍLICO	7	\N
3155	PENTACLOROFENOL	16	\N
3156	GÁS OXIDANTE, COMPRIMIDO, N.E.	8	\N
3157	GÁS OXIDANTE, LIQUEFEITO, N.E.	8	\N
3158	GÁS LÍQUIDO REFRIGERADO, N.E.	8	\N
3159	1,1,1,2 - TETRAFLUORETANO	8	\N
3160	GÁS TÓXICO, INFLAMÁVEL, LIQUEFEITO, N.E.	9	\N
3161	GÁS INFLAMÁVEL, LIQUEFEITO, N.E.	7	\N
3162	GÁS TÓXICO, LIQUEFEITO, N.E.	9	\N
3163	GÁS LIQUEFEITO, N.E.	8	\N
3164	ARTIGOS PRESSURIZADOS PNEUMÁTICOS ou HIDRÁULICOS  (contendo gás não-inflamável)	8	\N
3165	TANQUE DE COMBUSTÍVEL DE UNIDADE DE FORÇA HIDRÁULICA PARA AERONAVE (contendo mistura de hidrazina anidra e metil-hidrazina) (combustível M86)	10	\N
3166	MOTORES DE COMBUSTÃO INTERNA, inclusive quando instalados em máquinas ou veículos	20	\N
3167	GÁS INFLAMÁVEL, NÃO-PRESSURIZADO, AMOSTRAS, N.E., não altamente refrigerado	7	\N
3168	GÁS TÓXICO, INFLAMÁVEL, NÃO-PRESSURIZADO, AMOSTRAS, N.E., não-altamente refrigerado	9	\N
3169	GÁS TÓXICO, NÃO-PRESSURIZADO, AMOSTRAS, N.E., não- altamente refrigerado 	9	\N
3170	ESCÓRIA DE ALUMÍNIO	13	\N
3171	CADEIRA DE RODAS, ELÉTRICA, com baterias	20	\N
3172	TOXINAS EXTRAÍDAS DE FONTES VIVAS, N.E.	16	\N
3174	DISSULFETO DE TITÂNIO	12	\N
3175	SÓLIDO(S) CONTENDO LÍQUIDOS INFLAMÁVEIS, N.E.	11	\N
3176	SÓLIDO INFLAMÁVEL, ORGÂNICO, FUNDIDO, N.E.	11	\N
3178	SÓLIDO INFLAMÁVEL, INORGÂNICO, N.E.	11	\N
3179	SÓLIDO INFLAMÁVEL, TÓXICO, INORGÂNICO, N.E.	11	\N
3180	SÓLIDO INFLAMÁVEL, CORROSIVO, INORGÂNICO, N.E.	11	\N
3181	SAIS METÁLICOS DE COMPOSTOS ORGÂNICOS, INFLAMÁVEIS, N.E.	11	\N
3182	HIDRETOS METÁLICOS, INFLAMÁVEIS, N.E.	11	\N
3183	LÍQUIDO SUJEITO A AUTO-AQUECIMENTO, ORGÂNICO, N.E.	12	\N
3184	LÍQUIDO SUJEITO A AUTO-AQUECIMENTO, TÓXICO, ORGÂNICO, N.E.	12	\N
3185	LÍQUIDO SUJEITO A AUTO-AQUECIMENTO, CORROSIVO,  ORGÂNICO, N.E.	12	\N
3186	LÍQUIDO SUJEITO A AUTO-AQUECIMENTO, INORGÂNICO, N.E.	12	\N
3187	LÍQUIDO SUJEITO A AUTO-AQUECIMENTO, TÓXICO, INORGÂNICO, N.E.	12	\N
3188	LÍQUIDO SUJEITO A AUTO-AQUECIMENTO, CORROSIVO, INORGÂNICO, N.E.	12	\N
3189	METAIS EM PÓ, SUJEITOS A AUTO-AQUECIMENTO, N.E.	12	\N
3190	SÓLIDO SUJEITO A AUTO-AQUECIMENTO, INORGÂNICO, N.E. 	12	\N
3191	SÓLIDO SUJEITO A AUTO-AQUECIMENTO, TÓXICO, INORGÂNICO, N.E.	12	\N
3192	SÓLIDO SUJEITO A AUTO-AQUECIMENTO, CORROSIVO, INORGÂNICO, N.E.	12	\N
3194	LÍQUIDO PIROFÓRICO, INORGÂNICO, N.E.	12	\N
3200	SÓLIDO PIROFÓRICO, INORGÂNICO, N.E.	12	\N
3203	COMPOSTOS ORGANOMETÁLICOS, PIROFÓRICOS, N.E.	12	\N
3205	ALCOOLATOS  DE  METAIS  ALCALINO-TERROSOS, N.E	12	\N
3206	ALCOOLATOS DE METAIS ALCALINOS, N.E.	12	\N
3207	COMPOSTOS, ou SOLUÇÕES, ou DISPERSÕES ORGANO-METÁLICOS, QUE REAGEM COM ÁGUA, INFLAMÁVEIS, N.E.	13	\N
3208	SUBSTÂNCIAS METÁLICAS, QUE REAGEM COM ÁGUA, N.E.	13	\N
3209	SUBSTÂNCIAS METÁLICAS, QUE REAGEM COM ÁGUA, SUJEITAS A AUTO-AQUECIMENTO, N.E.	13	\N
3210	CLORATOS INORGÂNICOS, SOLUÇÕES AQUOSAS, N.E.	14	\N
3211	PERCLORATOS INORGÂNICOS, SOLUÇÕES AQUOSAS, N.E.	14	\N
3212	HIPOCLORITOS INORGÂNICOS, N.E.	14	\N
3213	BROMATOS INORGÂNICOS, SOLUÇÕES AQUOSAS, N.E.	14	\N
3214	PERMANGANATOS INORGÂNICOS, SOLUÇÕES AQUOSAS, N.E.	14	\N
3215	PERSULFATOS INORGÂNICOS, N.E.	14	\N
3216	PERSULFATOS INORGÂNICOS, SOLUÇÕES AQUOSAS, N.E.	14	\N
3217	PERCARBONATOS INORGÂNICOS, N.E.	14	\N
3218	NITRATOS INORGÂNICOS, SOLUÇÕES AQUOSAS, N.E.	14	\N
3219	NITRITOS INORGÂNICOS, SOLUÇÕES AQUOSAS, N.E.	14	\N
3220	PENTAFLUORETANO	8	\N
3221	LÍQUIDO AUTO-REAGENTE, TIPO B	11	\N
3222	SÓLIDO AUTO-REAGENTE, TIPO B	11	\N
3223	LÍQUIDO AUTO-REAGENTE, TIPO C	11	\N
3224	SÓLIDO AUTO-REAGENTE, TIPO C	11	\N
3225	LÍQUIDO AUTO-REAGENTE, TIPO D	11	\N
3226	SÓLIDO AUTO-REAGENTE, TIPO D	11	\N
3227	LÍQUIDO AUTO-REAGENTE, TIPO E	11	\N
3228	SÓLIDO AUTO-REAGENTE, TIPO E	11	\N
3229	LÍQUIDO AUTO-REAGENTE, TIPO F	11	\N
3230	SÓLIDO AUTO-REAGENTE, TIPO F	11	\N
3231	LÍQUIDO AUTO-REAGENTE, TIPO B, TEMPERATURA CONTROLADA	11	\N
3232	SÓLIDO AUTO-REAGENTE, TIPO B, TEMPERATURA CONTROLADA	11	\N
3233	LÍQUIDO AUTO-REAGENTE, TIPO C, TEMPERATURA CONTROLADA	11	\N
3234	SÓLIDO AUTO-REAGENTE, TIPO C, TEMPERATURA CONTROLADA	11	\N
3235	LÍQUIDO AUTO-REAGENTE, TIPO D, TEMPERATURA CONTROLADA	11	\N
3236	SÓLIDO AUTO-REAGENTE, TIPO D, TEMPERATURA CONTROLADA	11	\N
3237	LÍQUIDO AUTO-REAGENTE, TIPO E, TEMPERATURA CONTROLADA	11	\N
3238	SÓLIDO AUTO-REAGENTE, TIPO E, TEMPERATURA CONTROLADA	11	\N
3239	LÍQUIDO AUTO-REAGENTE, TIPO F, TEMPERATURA CONTROLADA	11	\N
3240	SÓLIDO AUTO-REAGENTE, TIPO F, TEMPERATURA CONTROLADA	11	\N
3241	2-BROMO-2-NITROPROPANO-1,3-DIOL	16	\N
3242	AZODICARBONAMIDA	11	\N
3243	SÓLIDO(S) CONTENDO LÍQUIDOS TÓXICOS, N.E.	16	\N
3244	SÓLIDO(S) CONTENDO LÍQUIDOS CORROSIVOS, N.E.	19	\N
3245	MICROORGANISMOS GENETICAMENTE MODIFICADOS	20	\N
3246	CLORETO DE METANO-SULFONILA	16	\N
3247	PEROXOBORATO DE SÓDIO, ANIDRO	14	\N
3248	MEDICAMENTOS INFLAMÁVEIS, TÓXICOS, LÍQUIDOS, N.E.	10	\N
3249	MEDICAMENTOS TÓXICOS, SÓLIDOS,  N.E.	16	\N
3250	ÁCIDO CLORACÉTICO, FUNDIDO	16	\N
\.


--
-- Data for Name: roler; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY roler (id_roler, descricao, nome_roler) FROM stdin;
2	Operador	ROLE_OPE
3	Supervisor	ROLE_SUP
4	Diretor	ROLE_DIR
1	Administrador	ROLE_ADMIN
\.


--
-- Name: roler_id_roler_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('roler_id_roler_seq', 4, true);


--
-- Data for Name: status_armazem; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY status_armazem (id_status_armazem, espec_status_armazem, tipo_status_armazem) FROM stdin;
\.


--
-- Name: status_armazem_id_status_armazem_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('status_armazem_id_status_armazem_seq', 1, false);


--
-- Data for Name: tipo_comp; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY tipo_comp (id_tipo_comp, id_classe, id_legenda) FROM stdin;
1	7	2
2	7	3
3	7	4
4	7	5
6	8	3
7	8	4
9	9	2
10	9	3
11	9	4
13	10	1
14	10	2
15	10	3
16	10	4
17	10	5
19	11	1
20	11	2
21	11	3
22	11	4
23	11	5
24	12	1
25	12	2
26	12	3
27	12	4
28	12	5
30	13	1
31	13	2
32	13	3
33	13	4
34	13	5
36	14	1
37	14	2
38	14	3
39	14	4
40	14	5
42	15	1
43	15	2
44	15	3
45	15	4
46	15	5
47	16	3
48	16	4
49	16	5
51	17	3
52	17	4
54	19	1
55	19	2
56	19	5
57	19	6
58	20	3
59	20	4
\.


--
-- Data for Name: tipo_equipamento; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY tipo_equipamento (id_tipo_equipamento, espc_tipo_equipamento, id_epe, nome_tipo_equipamento, epe_id_epe, id_embalagem, id_epi, id_veiculo) FROM stdin;
\.


--
-- Name: tipo_equipamento_id_tipo_equipamento_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('tipo_equipamento_id_tipo_equipamento_seq', 1, false);


--
-- Data for Name: tipo_material; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY tipo_material (id_tipo_material, espec_material, nome_material) FROM stdin;
\.


--
-- Name: tipo_material_id_tipo_material_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('tipo_material_id_tipo_material_seq', 1, false);


--
-- Data for Name: tipo_solicitacao; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY tipo_solicitacao (id_tipo_solicitacao, espec_tipo_solicitacao, id_fornecedor, solicitante, tipo_solicitacao, fornecedor_id_fornecedor, id_armazem, id_funcionario) FROM stdin;
\.


--
-- Name: tipo_solicitacao_id_tipo_solicitacao_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('tipo_solicitacao_id_tipo_solicitacao_seq', 1, false);


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY usuario (id_usuario, ativo, login, senha) FROM stdin;
1	t	slcpp	b6b62460067685e76f573b8caaae8646
7	f	eao	d41d8cd98f00b204e9800998ecf8427e
8	t	ao	d41d8cd98f00b204e9800998ecf8427e
9	f	dmudm	d41d8cd98f00b204e9800998ecf8427e
10	f	dmdu	d41d8cd98f00b204e9800998ecf8427e
11	f	umdu	d41d8cd98f00b204e9800998ecf8427e
12	f	udm	d41d8cd98f00b204e9800998ecf8427e
2	t	udmu	d41d8cd98f00b204e9800998ecf8427e
3	f	dmudmmud	d41d8cd98f00b204e9800998ecf8427e
4	t	dmu	d41d8cd98f00b204e9800998ecf8427e
5	\N	dmudm	d41d8cd98f00b204e9800998ecf8427e
6	\N	dmu	d41d8cd98f00b204e9800998ecf8427e
13	t	sacramento	e10adc3949ba59abbe56e057f20f883e
14	\N	\N	\N
15	\N	\N	\N
16	f	32321321	359e1929df6a3c40f13811f0414b1843
17	\N	\N	\N
\.


--
-- Name: usuario_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('usuario_id_usuario_seq', 17, true);


--
-- Data for Name: usuario_roler; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY usuario_roler (id, login, roler) FROM stdin;
1	1	1
2	1	2
3	1	3
4	1	4
\.


--
-- Name: usuario_roler_id_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('usuario_roler_id_seq', 4, true);


--
-- Data for Name: veiculo; Type: TABLE DATA; Schema: public; Owner: slcpp
--

COPY veiculo (id_veiculo, ano_veiculo, chassi_veiculo, cor_veiculo, fabricante_veiculo, modelo_veiculo, nome_veiculo, placa_veiculo, id_combustivel) FROM stdin;
\.


--
-- Name: veiculo_id_veiculo_seq; Type: SEQUENCE SET; Schema: public; Owner: slcpp
--

SELECT pg_catalog.setval('veiculo_id_veiculo_seq', 1, false);


SET search_path = salvadel, pg_catalog;

--
-- Data for Name: movimentacao; Type: TABLE DATA; Schema: salvadel; Owner: slcpp
--

COPY movimentacao (id_movimentacao, id_endarmazem, id_produto) FROM stdin;
34	3	5
33	3	6
23	2	4
37	2	335
40	5	12
41	11	12
42	12	3247
43	13	9
44	13	7
45	13	1310
46	13	12
48	13	196
49	13	223
\.


SET search_path = public, pg_catalog;

--
-- Name: armazem_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY armazem
    ADD CONSTRAINT armazem_pkey PRIMARY KEY (id_armazem);


--
-- Name: capacidade_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY capacidade
    ADD CONSTRAINT capacidade_pkey PRIMARY KEY (id_capacidade);


--
-- Name: cidade_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY cidade
    ADD CONSTRAINT cidade_pkey PRIMARY KEY (id_cidade);


--
-- Name: classe_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY classe
    ADD CONSTRAINT classe_pkey PRIMARY KEY (id_classe);


--
-- Name: combustivel_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY combustivel
    ADD CONSTRAINT combustivel_pkey PRIMARY KEY (id_combustivel);


--
-- Name: compatibilidade_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY compatibilidade
    ADD CONSTRAINT compatibilidade_pkey PRIMARY KEY (id_comptibilidade);


--
-- Name: contatos_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY contatos
    ADD CONSTRAINT contatos_pkey PRIMARY KEY (id_contato);


--
-- Name: det_nota_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY det_nota
    ADD CONSTRAINT det_nota_pkey PRIMARY KEY (id_detalhe_nota);


--
-- Name: dimensoes_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY dimensoes
    ADD CONSTRAINT dimensoes_pkey PRIMARY KEY (id_dimensoes);


--
-- Name: embalagem_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY embalagem
    ADD CONSTRAINT embalagem_pkey PRIMARY KEY (id_embalagem);


--
-- Name: empresa_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY empresa
    ADD CONSTRAINT empresa_pkey PRIMARY KEY (id_empresa);


--
-- Name: end_armazem_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY end_armazem
    ADD CONSTRAINT end_armazem_pkey PRIMARY KEY (id_endarmazem);


--
-- Name: endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (id_endereco);


--
-- Name: epe_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY epe
    ADD CONSTRAINT epe_pkey PRIMARY KEY (id_epe);


--
-- Name: epi_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY epi
    ADD CONSTRAINT epi_pkey PRIMARY KEY (id_epi);


--
-- Name: est_fisico_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY est_fisico
    ADD CONSTRAINT est_fisico_pkey PRIMARY KEY (id_est_fisico);


--
-- Name: estado_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY estado
    ADD CONSTRAINT estado_pkey PRIMARY KEY (id_estado);


--
-- Name: fornecedor_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY fornecedor
    ADD CONSTRAINT fornecedor_pkey PRIMARY KEY (id_fornecedor);


--
-- Name: funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (id_funcionario);


--
-- Name: grupo_embalagem_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY grupo_embalagem
    ADD CONSTRAINT grupo_embalagem_pkey PRIMARY KEY (id_grupo_embalagem);


--
-- Name: item_pedido_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY item_pedido_produto
    ADD CONSTRAINT item_pedido_produto_pkey PRIMARY KEY (id_pedido_produto);


--
-- Name: legenda_compatibilidade_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY legenda_compatibilidade
    ADD CONSTRAINT legenda_compatibilidade_pkey PRIMARY KEY (id_legenda_compatibilidade);


--
-- Name: local_operacao_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY local_operacao
    ADD CONSTRAINT local_operacao_pkey PRIMARY KEY (id_local_oper);


--
-- Name: lote_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY lote
    ADD CONSTRAINT lote_pkey PRIMARY KEY (id_lote);


--
-- Name: movimentacao_id_endarmazem_key; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY movimentacao
    ADD CONSTRAINT movimentacao_id_endarmazem_key UNIQUE (id_endarmazem);


--
-- Name: movimentacao_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY movimentacao
    ADD CONSTRAINT movimentacao_pkey PRIMARY KEY (id_movimentacao);


--
-- Name: num_cas_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY num_cas
    ADD CONSTRAINT num_cas_pkey PRIMARY KEY (id_num_cas);


--
-- Name: num_onu_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY num_onu
    ADD CONSTRAINT num_onu_pkey PRIMARY KEY (id_num_onu);


--
-- Name: pais_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY pais
    ADD CONSTRAINT pais_pkey PRIMARY KEY (id_pais);


--
-- Name: pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (id_pedido);


--
-- Name: produto_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY produto
    ADD CONSTRAINT produto_pkey PRIMARY KEY (num_onu);


--
-- Name: roler_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY roler
    ADD CONSTRAINT roler_pkey PRIMARY KEY (id_roler);


--
-- Name: status_armazem_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY status_armazem
    ADD CONSTRAINT status_armazem_pkey PRIMARY KEY (id_status_armazem);


--
-- Name: tipoComp_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY tipo_comp
    ADD CONSTRAINT "tipoComp_pkey" PRIMARY KEY (id_tipo_comp);


--
-- Name: tipo_equipamento_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY tipo_equipamento
    ADD CONSTRAINT tipo_equipamento_pkey PRIMARY KEY (id_tipo_equipamento);


--
-- Name: tipo_material_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY tipo_material
    ADD CONSTRAINT tipo_material_pkey PRIMARY KEY (id_tipo_material);


--
-- Name: tipo_solicitacao_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY tipo_solicitacao
    ADD CONSTRAINT tipo_solicitacao_pkey PRIMARY KEY (id_tipo_solicitacao);


--
-- Name: usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);


--
-- Name: usuario_roler_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY usuario_roler
    ADD CONSTRAINT usuario_roler_pkey PRIMARY KEY (id);


--
-- Name: veiculo_pkey; Type: CONSTRAINT; Schema: public; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY veiculo
    ADD CONSTRAINT veiculo_pkey PRIMARY KEY (id_veiculo);


SET search_path = salvadel, pg_catalog;

--
-- Name: movimentacao_pkey; Type: CONSTRAINT; Schema: salvadel; Owner: slcpp; Tablespace: 
--

ALTER TABLE ONLY movimentacao
    ADD CONSTRAINT movimentacao_pkey PRIMARY KEY (id_movimentacao);


SET search_path = public, pg_catalog;

--
-- Name: fki_armazem; Type: INDEX; Schema: public; Owner: slcpp; Tablespace: 
--

CREATE INDEX fki_armazem ON lote USING btree (id_armazem);


--
-- Name: salva_deletado_movimentacao; Type: TRIGGER; Schema: public; Owner: slcpp
--

CREATE TRIGGER salva_deletado_movimentacao AFTER DELETE ON movimentacao FOR EACH ROW EXECUTE PROCEDURE salva_deletado_movimentacao();


--
-- Name: up_endereco; Type: TRIGGER; Schema: public; Owner: slcpp
--

CREATE TRIGGER up_endereco AFTER INSERT OR DELETE ON end_armazem FOR EACH ROW EXECUTE PROCEDURE update_endereco();


--
-- Name: up_endereco_arm; Type: TRIGGER; Schema: public; Owner: slcpp
--

CREATE TRIGGER up_endereco_arm AFTER INSERT OR DELETE ON movimentacao FOR EACH ROW EXECUTE PROCEDURE update_endereco_arm();


--
-- Name: armazem_fk_id_dimensoes_fkey; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY armazem
    ADD CONSTRAINT armazem_fk_id_dimensoes_fkey FOREIGN KEY (fk_id_dimensoes) REFERENCES dimensoes(id_dimensoes);


--
-- Name: armazem_fk_id_empresa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY armazem
    ADD CONSTRAINT armazem_fk_id_empresa_fkey FOREIGN KEY (fk_id_empresa) REFERENCES empresa(id_empresa);


--
-- Name: compatibilidade_id_tipo_comp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY compatibilidade
    ADD CONSTRAINT compatibilidade_id_tipo_comp_fkey FOREIGN KEY (id_tipo_comp) REFERENCES tipo_comp(id_tipo_comp);


--
-- Name: compatibilidade_numonu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY compatibilidade
    ADD CONSTRAINT compatibilidade_numonu_fkey FOREIGN KEY (numonu) REFERENCES produto(num_onu);


--
-- Name: fk_armazem; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY lote
    ADD CONSTRAINT fk_armazem FOREIGN KEY (id_armazem) REFERENCES armazem(id_armazem);


--
-- Name: fk_armazem_id_capacidade; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY armazem
    ADD CONSTRAINT fk_armazem_id_capacidade FOREIGN KEY (id_capacidade) REFERENCES capacidade(id_capacidade);


--
-- Name: fk_armazem_id_endarmazem; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY armazem
    ADD CONSTRAINT fk_armazem_id_endarmazem FOREIGN KEY (id_endarmazem) REFERENCES end_armazem(id_endarmazem);


--
-- Name: fk_armazem_local_operacao_id_local_oper; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY armazem
    ADD CONSTRAINT fk_armazem_local_operacao_id_local_oper FOREIGN KEY (local_operacao_id_local_oper) REFERENCES local_operacao(id_local_oper);


--
-- Name: fk_armazem_status_armazem_id_status_armazem; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY armazem
    ADD CONSTRAINT fk_armazem_status_armazem_id_status_armazem FOREIGN KEY (status_armazem_id_status_armazem) REFERENCES status_armazem(id_status_armazem);


--
-- Name: fk_cidade_id_estado; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY cidade
    ADD CONSTRAINT fk_cidade_id_estado FOREIGN KEY (id_estado) REFERENCES estado(id_estado);


--
-- Name: fk_det_nota_fornecedor_id_fornecedor; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY det_nota
    ADD CONSTRAINT fk_det_nota_fornecedor_id_fornecedor FOREIGN KEY (fornecedor_id_fornecedor) REFERENCES fornecedor(id_fornecedor);


--
-- Name: fk_det_nota_tipo_equipamento_id_tipo_equipamento; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY det_nota
    ADD CONSTRAINT fk_det_nota_tipo_equipamento_id_tipo_equipamento FOREIGN KEY (tipo_equipamento_id_tipo_equipamento) REFERENCES tipo_equipamento(id_tipo_equipamento);


--
-- Name: fk_embalagem_id_capacidade; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY embalagem
    ADD CONSTRAINT fk_embalagem_id_capacidade FOREIGN KEY (id_capacidade) REFERENCES capacidade(id_capacidade);


--
-- Name: fk_embalagem_id_grupo_embalagem; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY embalagem
    ADD CONSTRAINT fk_embalagem_id_grupo_embalagem FOREIGN KEY (id_grupo_embalagem) REFERENCES grupo_embalagem(id_grupo_embalagem);


--
-- Name: fk_endereco_id_cidade; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY endereco
    ADD CONSTRAINT fk_endereco_id_cidade FOREIGN KEY (id_cidade) REFERENCES cidade(id_cidade);


--
-- Name: fk_endereco_id_estado; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY endereco
    ADD CONSTRAINT fk_endereco_id_estado FOREIGN KEY (id_estado) REFERENCES estado(id_estado);


--
-- Name: fk_endereco_id_pais; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY endereco
    ADD CONSTRAINT fk_endereco_id_pais FOREIGN KEY (id_pais) REFERENCES pais(id_pais);


--
-- Name: fk_epe_tipo_material_id_material; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY epe
    ADD CONSTRAINT fk_epe_tipo_material_id_material FOREIGN KEY (tipo_material_id_material) REFERENCES tipo_material(id_tipo_material);


--
-- Name: fk_epi_id_material; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY epi
    ADD CONSTRAINT fk_epi_id_material FOREIGN KEY (id_material) REFERENCES tipo_material(id_tipo_material);


--
-- Name: fk_estado_id_pais; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY estado
    ADD CONSTRAINT fk_estado_id_pais FOREIGN KEY (id_pais) REFERENCES pais(id_pais);


--
-- Name: fk_fornecedor_contatos_id_contato; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY fornecedor
    ADD CONSTRAINT fk_fornecedor_contatos_id_contato FOREIGN KEY (contatos_id_contato) REFERENCES contatos(id_contato);


--
-- Name: fk_fornecedor_id_endereco; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY fornecedor
    ADD CONSTRAINT fk_fornecedor_id_endereco FOREIGN KEY (id_endereco) REFERENCES endereco(id_endereco);


--
-- Name: fk_funcionario_contatos_id_contato; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY funcionario
    ADD CONSTRAINT fk_funcionario_contatos_id_contato FOREIGN KEY (contatos_id_contato) REFERENCES contatos(id_contato);


--
-- Name: fk_funcionario_endereco_id_endereco; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY funcionario
    ADD CONSTRAINT fk_funcionario_endereco_id_endereco FOREIGN KEY (endereco_id_endereco) REFERENCES endereco(id_endereco);


--
-- Name: fk_funcionario_id_usuario; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY funcionario
    ADD CONSTRAINT fk_funcionario_id_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario);


--
-- Name: fk_tipo_equipamento_epe_id_epe; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY tipo_equipamento
    ADD CONSTRAINT fk_tipo_equipamento_epe_id_epe FOREIGN KEY (epe_id_epe) REFERENCES epe(id_epe);


--
-- Name: fk_tipo_equipamento_id_embalagem; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY tipo_equipamento
    ADD CONSTRAINT fk_tipo_equipamento_id_embalagem FOREIGN KEY (id_embalagem) REFERENCES embalagem(id_embalagem);


--
-- Name: fk_tipo_equipamento_id_epi; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY tipo_equipamento
    ADD CONSTRAINT fk_tipo_equipamento_id_epi FOREIGN KEY (id_epi) REFERENCES epi(id_epi);


--
-- Name: fk_tipo_equipamento_id_veiculo; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY tipo_equipamento
    ADD CONSTRAINT fk_tipo_equipamento_id_veiculo FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo);


--
-- Name: fk_tipo_solicitacao_fornecedor_id_fornecedor; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY tipo_solicitacao
    ADD CONSTRAINT fk_tipo_solicitacao_fornecedor_id_fornecedor FOREIGN KEY (fornecedor_id_fornecedor) REFERENCES fornecedor(id_fornecedor);


--
-- Name: fk_tipo_solicitacao_id_armazem; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY tipo_solicitacao
    ADD CONSTRAINT fk_tipo_solicitacao_id_armazem FOREIGN KEY (id_armazem) REFERENCES armazem(id_armazem);


--
-- Name: fk_tipo_solicitacao_id_funcionario; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY tipo_solicitacao
    ADD CONSTRAINT fk_tipo_solicitacao_id_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario);


--
-- Name: fk_usuario_roler_login; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY usuario_roler
    ADD CONSTRAINT fk_usuario_roler_login FOREIGN KEY (login) REFERENCES usuario(id_usuario);


--
-- Name: fk_usuario_roler_roler; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY usuario_roler
    ADD CONSTRAINT fk_usuario_roler_roler FOREIGN KEY (roler) REFERENCES roler(id_roler);


--
-- Name: fk_veiculo_id_combustivel; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY veiculo
    ADD CONSTRAINT fk_veiculo_id_combustivel FOREIGN KEY (id_combustivel) REFERENCES combustivel(id_combustivel);


--
-- Name: item_pedido_produto_id_pedido_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY item_pedido_produto
    ADD CONSTRAINT item_pedido_produto_id_pedido_fk_fkey FOREIGN KEY (id_pedido_fk) REFERENCES pedido(id_pedido);


--
-- Name: item_pedido_produto_id_produto_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY item_pedido_produto
    ADD CONSTRAINT item_pedido_produto_id_produto_fk_fkey FOREIGN KEY (id_produto_fk) REFERENCES produto(num_onu);


--
-- Name: lote_fk_id_dimensoes_fkey; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY lote
    ADD CONSTRAINT lote_fk_id_dimensoes_fkey FOREIGN KEY (fk_id_dimensoes) REFERENCES dimensoes(id_dimensoes);


--
-- Name: lote_num_onu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY lote
    ADD CONSTRAINT lote_num_onu_fkey FOREIGN KEY (num_onu) REFERENCES produto(num_onu);


--
-- Name: movimentacao_id_endarmazem_fkey; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY movimentacao
    ADD CONSTRAINT movimentacao_id_endarmazem_fkey FOREIGN KEY (id_endarmazem) REFERENCES end_armazem(id_endarmazem);


--
-- Name: movimentacao_id_produto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY movimentacao
    ADD CONSTRAINT movimentacao_id_produto_fkey FOREIGN KEY (id_produto) REFERENCES produto(num_onu);


--
-- Name: produto_classe_fkey; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY produto
    ADD CONSTRAINT produto_classe_fkey FOREIGN KEY (classe) REFERENCES classe(id_classe);


--
-- Name: tipo_comp_id_classe_fkey; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY tipo_comp
    ADD CONSTRAINT tipo_comp_id_classe_fkey FOREIGN KEY (id_classe) REFERENCES classe(id_classe);


--
-- Name: tipo_comp_id_legenda_fkey; Type: FK CONSTRAINT; Schema: public; Owner: slcpp
--

ALTER TABLE ONLY tipo_comp
    ADD CONSTRAINT tipo_comp_id_legenda_fkey FOREIGN KEY (id_legenda) REFERENCES legenda_compatibilidade(id_legenda_compatibilidade);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

