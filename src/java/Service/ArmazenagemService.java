/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Service;

import com.sun.xml.internal.ws.org.objectweb.asm.Type;
import entiti.Armazem;
import entiti.Dimensoes;
import entiti.Lote;
import entiti.Lote.EstadoArmazenagem;
import entiti.Movimentacao;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import reports.jasperConnection;

/**
 * Classe service para tratar das interações [com o banco de dados da classe
 * armazenagem Util
 *
 */
public class ArmazenagemService {

    public ArmazenagemService() {

    }

    /**
     * Verifica se o produto a ser inserido ja está armazenado
     *
     * @param produto
     * @return boolean
     */
    public boolean verificaExisteProduto(String produtoId) {

        Lote lote = new Lote();
        ResultSet rs;
        boolean retorno = false;

        try {
            Connection connection = jasperConnection.getConexao();

            String query = "select * from lote l where l.num_onu = " + produtoId + "; ";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();
            retorno = (rs != null);

            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return retorno;
    }

    /**
     * metodo que retorna a lista de lotes onde o produto está armazenado
     *
     * @param produto
     * @return
     */
    public List<Lote> getLocalProdutoArmazenado(Integer produtoId) {

        List<Lote> lotes = new ArrayList<Lote>();

        ResultSet rs;
        try {
            Connection connection = jasperConnection.getConexao();

            String query = "select * from lote l where l.num_onu = " + produtoId + "; ";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();

            while (rs.next()) {
                Lote lote = new Lote();
                lote.setIdLote(rs.getInt("id_lote"));
                lote.setIdArmazem(rs.getInt("id_armazem"));
                lote.setIdDimensoes(rs.getInt("fk_id_dimensoes"));
                lote.setIdProduto(rs.getInt("num_onu"));
                lote.setQuantidadeProduto(rs.getDouble("quantidade_produto"));
                lote.setSequencial(rs.getInt("sequencial"));

                lotes.add(lote);

            }
            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lotes;
    }

    /**
     * retorna todos os lotes
     *
     * @return List Lote
     */
    public List<Lote> getAllLotes() {

        List<Lote> lotes = new ArrayList<Lote>();
        ResultSet rs;
        try {
            Connection connection = jasperConnection.getConexao();

            String query = "select * from armazem; ";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();

            while (rs.next()) {
                Lote lote = new Lote();
                lote.setIdLote(rs.getInt("id_lote"));
                lote.setIdArmazem(rs.getInt("id_armazem"));
                lote.setIdDimensoes(rs.getInt("fk_id_dimensoes"));
                lote.setIdProduto(rs.getInt("num_onu"));
                lote.setQuantidadeProduto(rs.getDouble("quantidade_produto"));
                lote.setSequencial(rs.getInt("sequencial"));

                lotes.add(lote);

            }
            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return lotes;

    }

    /**
     * retorna todos os lotes
     *
     * @return List Armazem
     */
    public List<Armazem> getAllArmazens() {

        List<Armazem> armazens = new ArrayList<Armazem>();
        ResultSet rs;
        try {
            Connection connection = jasperConnection.getConexao();

            String query = "select * from armazem; ";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();

            while (rs.next()) {
                Armazem armazem = new Armazem();
                armazem.setIdArmazem(rs.getInt("id_armazem"));
                armazem.setTamanhoEspacoArmazenagem(rs.getDouble("tamanho_espaco_armazenagem"));
                armazem.setIdDimensao(rs.getInt("fk_id_dimensoes"));

                Dimensoes dimensoes = new Dimensoes();
                dimensoes = getDimensoes(armazem.getIdDimensao());
                armazem.setDimensoes(dimensoes);
                
                armazens.add(armazem);

            }
            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return armazens;

    }

    public List<Lote> getLotesPorAramazem(Integer armazemId) {

        List<Lote> lotes = new ArrayList<Lote>();
        ResultSet rs;
        try {
            Connection connection = jasperConnection.getConexao();

            String query = "select * from lote where id_armazem = " + armazemId + "; ";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();

            while (rs.next()) {
                Lote lote = new Lote();
                lote.setIdLote(rs.getInt("id_lote"));
                lote.setIdArmazem(rs.getInt("id_armazem"));
                lote.setIdDimensoes(rs.getInt("fk_id_dimensoes"));
                lote.setIdProduto(rs.getInt("num_onu"));
                lote.setQuantidadeProduto(rs.getDouble("quantidade_produto"));
                lote.setSequencial(rs.getInt("sequencial"));

                lotes.add(lote);

            }
            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return lotes;
    }

    /**
     * retorna a lista de lotes vazios em um determibnado armazem
     *
     * @param armazem
     * @return
     */
    public List<Lote> getLotesdisponiveis(Integer armazemId) {

        List<Lote> lotes = new ArrayList<Lote>();
        ResultSet rs;
        try {
            Connection connection = jasperConnection.getConexao();

            String query = "select * from lote where id_armazem = " + armazemId + " AND estado " + EstadoArmazenagem.VAZIO + " order by sequencial; ";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();

            while (rs.next()) {
                Lote lote = new Lote();
                lote.setIdLote(rs.getInt("id_lote"));
                lote.setIdArmazem(rs.getInt("id_armazem"));
                lote.setIdDimensoes(rs.getInt("fk_id_dimensoes"));
                lote.setIdProduto(rs.getInt("num_onu"));
                lote.setQuantidadeProduto(rs.getDouble("quantidade_produto"));
                lote.setSequencial(rs.getInt("sequencial"));

                lotes.add(lote);

            }
            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return lotes;

    }

    public boolean verificaArmazemVazio(Integer armazemId) {

        boolean retorno = false;
        ResultSet rs;
        try {
            Connection connection = jasperConnection.getConexao();

            String query = "select * from armazem where id_armazem = "+armazemId + "; ";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();
            
            retorno = rs != null;
            
            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return retorno;
    }

    /**
     * Metodo verifica se o produto que será armazenado é compativel com o
     * produto vizinho ja armazenado
     *
     * @param produtoParaArmazenar
     * @param produtoVizinho
     * @return
     */
    public boolean verificaCompatibilidade(Integer produtoParaArmazenar, Integer produtoVizinho) {
        List<Integer> numeros;
        numeros = getProdutosIncompativeis(produtoParaArmazenar);
        return !numeros.contains(produtoVizinho);
    }

    /**
     * retira o produto
     *
     * @param produto
     * @param quantidade
     * @return
     */
    public boolean retiraProtudo(Integer produtoId, int quantidade) {
        List<Lote> lotes = getLocalProdutoArmazenado(produtoId);

        return false;
    }

    /**
     * retorna a quanidade total de um determinado produto
     *
     * @param produto
     * @return
     */
    public Double getQuantidadeTotalProduto(Integer produtoId) {

        Double retorno = 0.0;            
        ResultSet rs;
        try {
            Connection connection = jasperConnection.getConexao();

            String query = "select SUM(quantidade_produto)as total FROM Lote where num_onu = " +produtoId + "; ";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();

            while (rs.next()) {
               retorno = rs.getDouble("total");

            }
            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return retorno;
        
        
    }

    /**
     * retorna o proximo sequencial a ser utilizado para o enrereçamento do lote
     *
     * @param produto
     * @return
     */
    public Integer getProximoSequencial(Integer armazemId) {
        Integer retorno = 0;            
        ResultSet rs;
        try {
            Connection connection = jasperConnection.getConexao();

            String query = "select MAX(sequencial) as valor FROM Lote where id_armazem = " +armazemId + "; ";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();

            while (rs.next()) {
               retorno = rs.getInt("valor");

            }
            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return retorno;
        
        
    }

    /**
     * Persist lote
     *
     * @param lote
     */
    public void persistLote(Lote lote) {
        try {
           Connection connection = jasperConnection.getConexao();
             String insert = "insert into lote(numero_paletes_armazenados,lado,sequencial,quantidade_produto"
                    + "id_armazem,num_onu) values(?,?,?,?,?,?) "; 
            PreparedStatement prepared = connection.prepareStatement(insert);
             
            prepared.setInt(1, lote.getNumeroPaletesArmazenados());
            prepared.setString(2, lote.getLado());
            prepared.setInt(3, lote.getSequencial());
            prepared.setDouble(4, lote.getQuantidadeProduto());
            prepared.setInt(5, lote.getIdArmazem());
            prepared.setInt(6, lote.getIdProduto());
            
            
            prepared.execute();
            
            connection.commit();
            prepared.close();
            connection.close();
        } catch (Exception e) {
        }
     
    }

    /**
     * Metodo que executa procedure para buscar os produtos inconpativeis
     *
     * @param nOnu
     * @return
     */
    public List<Integer> getProdutosIncompativeis(int nOnu) {

//        StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("incompatibilidade");
//        // set parametros
//        storedProcedure.registerStoredProcedureParameter("p_numonu ", Integer.class, ParameterMode.IN);
//        storedProcedure.registerStoredProcedureParameter("numonu", Integer.class, ParameterMode.OUT);
//        storedProcedure.setParameter("p_numonu", nOnu);
//        // executa SP
//        storedProcedure.execute();
//        // get resultado
//        List<Integer> resultado = (List<Integer>) storedProcedure.getOutputParameterValue("numonu");
          List<Integer> retorno = new ArrayList<Integer>();
        
        try { 
            
            Connection connection = jasperConnection.getConexao();
           
            CallableStatement proc =  connection.prepareCall(" { call incompatibilidade(?) } ");
           
            proc.registerOutParameter(1,Type.INT);
            proc.setInt(2, nOnu);
            proc.execute();
            
            Integer numero;
            ResultSet rs =  proc.getResultSet();
            while(rs.next()){
                
                numero = rs.getInt(1);
                
                retorno.add(numero);
            }
            
            proc.close();
        } catch (Exception e) {
        }
        
        return retorno;
        
        
    }

    /**
     * Verifica se Existe lote disponivel no armazem
     *
     * @param armazem
     * @return
     */
    public boolean verificaLoteDisponivel(Integer armazemId) {
        boolean retorno = false;
        ResultSet rs;
        try {
            Connection connection = jasperConnection.getConexao();

            String query = "select * from lote where id_armazem = " + armazemId + " AND estado " + EstadoArmazenagem.VAZIO + " order by sequencial; ";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();
            retorno = rs != null;
             
            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return retorno;
        
    }

    /**
     * Metodo verifica o espaço vazio dentro do armazem. Usado para a criação de
     * um novo lote
     *
     * @param armazem
     * @return
     */
    public boolean verificaEspacoVazioArmazem(Integer armazemId, String lado, double comprimentoArmazem) {

        double comprimento = 0;
        if (verificaLoteDisponivel(armazemId)) {
            return true;
        } else {
            List<Lote> lotes = getLotesPorAramazem(armazemId);
            for (Lote lote : lotes) {
                if (lote.getLado().equals(lado)) {
                    comprimento += lote.getDimensoes().getComprimento();
                }
            }
            if (comprimento < comprimentoArmazem) {
                return true;
            }
        }
        return false;
    }

    /**
     * retorno os lotes vizinhos a um lote já criado porem vazio assim podemos
     * reaproveitar os lotes vazios no meio do armazem
     *
     * @param lote
     * @return
     */
    public List<Lote> getLotesVizinhos(Lote lote, Integer armazemId) {
        int seqA = lote.getSequencial() - 1;
        int seqB = lote.getSequencial() + 1;
        String lado = null;
     
        if (lote.getLado().equals("E")) {
            lado = "E";
        } else {
            lado = "D";
        }
         
        List<Lote> lotes = new ArrayList<Lote>();
        ResultSet rs;
        try {
            Connection connection = jasperConnection.getConexao();

            String query = "select * from lote where id_armazem = " + armazemId + " AND estado " + EstadoArmazenagem.VAZIO + " AND lado = '" +lado + "' order by sequencial; ";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();

            while (rs.next()) {
                Lote novoLote = new Lote();
                novoLote.setIdLote(rs.getInt("id_lote"));
                novoLote.setIdArmazem(rs.getInt("id_armazem"));
                novoLote.setIdDimensoes(rs.getInt("fk_id_dimensoes"));
                novoLote.setIdProduto(rs.getInt("num_onu"));
                novoLote.setQuantidadeProduto(rs.getDouble("quantidade_produto"));
                novoLote.setSequencial(rs.getInt("sequencial"));

                lotes.add(novoLote);

            }
            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return lotes;

        

    }

    /**
     * Passado um produto e uma lsta de lotes, os lotes vizinhos metodo verifica
     * a compatibilidade
     *
     * @param lotes
     * @param produtoArmazenar
     * @return
     */
    public boolean verificaLotesVizinhosCompativeis(List<Lote> lotes, Integer produtoArmazenar) {

        boolean retorno = true;
        for (Lote lote : lotes) {
            retorno = retorno && verificaCompatibilidade(produtoArmazenar, lote.getIdProduto());
        }
        return retorno;
    }

    
    /**
     * retorna a ultima movimentação inserida no banco de dados que será usada 
     * para armazenagem
     * @return 
     */
    public Movimentacao getUltimaMovimentacao() {
        Movimentacao movimentacao = new Movimentacao();
        ResultSet rs = null;

        try {
            Connection connection = jasperConnection.getConexao();

            String query = "select * from movimentacao m where m.id_movimentacao = (select MAX(b.id_movimentacao) from movimentacao b); ";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();

            while (rs.next()) {
                movimentacao.setQuantidadePorPalete(rs.getInt("qtdporpalete"));
                movimentacao.setQuantidadeTotal(rs.getDouble("qtdtotal"));
                movimentacao.setNumeroOnu(rs.getInt("id_produto"));

            }

        } catch (SQLException ex) {
            Logger.getLogger(ArmazenagemService.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(ArmazenagemService.class.getName()).log(Level.SEVERE, null, ex);
        }
        return movimentacao;

    }


  
    public Dimensoes getDimensoes(Integer DimencoesId){
    
          ResultSet rs;
          Dimensoes dimencoes = new Dimensoes();
        try {
            Connection connection = jasperConnection.getConexao();

            String query = "select * from dimensoes l where l.id_dimensoes = " + DimencoesId + "; ";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();

            while (rs.next()) {
                dimencoes.setComprimento(rs.getDouble("comp_dimensao"));
                dimencoes.setLargura(rs.getDouble("lar_dimensao"));
            
            }
            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

       return dimencoes;
    }
    
}
