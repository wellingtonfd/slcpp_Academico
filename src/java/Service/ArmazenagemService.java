/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Service;

import entiti.Armazem;
import entiti.Dimensoes;
import entiti.Lote;
import entiti.Movimentacao;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import reports.jasperConnection;

/**
 * Classe service para tratar das interações [com o banco de dados da classe
 * armazenagem Util
 *obs: metodos de inserção utilizando o commit automatico do banco
 */
public class ArmazenagemService {

    public ArmazenagemService() {

    }

    /**
     * Verifica se o produto a ser inserido ja está armazenado
     *
     * @param produtoId
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
            retorno = rs.next();

            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
           
        }

        return retorno;
    }

    /**
     * metodo que retorna a lista de lotes onde o produto está armazenado
     *
     * @param produtoId
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
                lote.setQuantidadeProduto(rs.getDouble("quantidade_produtos"));
                lote.setSequencial(rs.getInt("sequencial"));
                lote.setLado(rs.getString("lado"));
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

    /**
     * Metodo retorna a lista de lotes de um determinado armazem
     * @param armazemId
     * @return 
     */
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
                lote.setQuantidadeProduto(rs.getDouble("quantidade_produtos"));
                lote.setSequencial(rs.getInt("sequencial"));
                lote.setLado(rs.getString("lado"));
                
                lote.setDimensoes(getDimensoes(lote.getIdDimensoes()));
                
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
     * @param armazemId
     * @return
     */
    public List<Lote> getLotesdisponiveis(Integer armazemId) {

        List<Lote> lotes = new ArrayList<Lote>();
        ResultSet rs;
        try {
            Connection connection = jasperConnection.getConexao();

            String query = "select * from lote where id_armazem = " + armazemId + " AND estado = 1  order by sequencial; ";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();

            while (rs.next()) {
                Lote lote = new Lote();
                lote.setIdLote(rs.getInt("id_lote"));
                lote.setIdArmazem(rs.getInt("id_armazem"));
                lote.setIdDimensoes(rs.getInt("fk_id_dimensoes"));
                lote.setIdProduto(rs.getInt("num_onu"));
                lote.setQuantidadeProduto(rs.getDouble("quantidade_produtos"));
                lote.setSequencial(rs.getInt("sequencial"));
                lote.setLado(rs.getString("lado"));
                
                lote.setDimensoes(getDimensoes(lote.getIdDimensoes()));
                
                lotes.add(lote);

            }
            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return lotes;

    }

    /**
     * Verifica se o armazem esta vazio para o caso inicial
     * @param armazemId
     * @return 
     */
    public boolean verificaArmazemVazio(Integer armazemId) {

        boolean retorno = false;
        ResultSet rs = null;
        try {
            Connection connection = jasperConnection.getConexao();

            String query = "select * from lote where id_armazem = "+armazemId + "; ";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();
            
            retorno =  (!rs.next());
            
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
     * @param produtoId
     * @param quantidade
     * @return
     */
    public boolean retiraProtudo(Integer produtoId, Double quantidadeRetirada) {
        List<Lote> lotes = getLocalProdutoArmazenado(produtoId);
         Double quantidade;
         for (Lote lote : lotes) {
            quantidade = lote.getQuantidadeProduto();
           if(quantidade > quantidadeRetirada ){
               lote.setQuantidadeProduto(quantidade - quantidadeRetirada);
               lote.setEstado(2);
               lote.setIdProduto(produtoId);
               atualizaLote(lote);
               return true;
            }else{
               lote.setQuantidadeProduto(0);
               lote.setEstado(1);
               lote.setIdProduto(null);
               atualizaLote(lote);
               quantidadeRetirada = quantidadeRetirada - quantidade;
           
           }   
        }
  
        
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

            String query = "select SUM(quantidade_produtos)as total FROM Lote where num_onu = " +produtoId + "; ";
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
     * @param armazemId
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
             String insert = "insert into lote(numero_paletes_armazenados, lado, sequencial, quantidade_produtos,"
                    + "id_armazem, num_onu, fk_id_dimensoes, estado ) values(?,?,?,?,?,?,?,?) "; 
            PreparedStatement prepared = connection.prepareStatement(insert);
             
            prepared.setInt(1, lote.getNumeroPaletesArmazenados());
            prepared.setString(2, lote.getLado());
            prepared.setInt(3, lote.getSequencial());
            prepared.setDouble(4, lote.getQuantidadeProduto());
            prepared.setInt(5, lote.getIdArmazem());
            prepared.setInt(6, lote.getIdProduto());
            prepared.setInt(7, lote.getIdDimensoes());
            prepared.setInt(8, lote.getEstado());
            
            
            prepared.executeUpdate();
                        
            
          //  connection.commit();
            
            prepared.close();
            connection.close();
        } catch (Exception e) {
        }
     
    }
    /**
     * Persist lote Vazio metodo para persiistencia de um lote vazio para garantir a 
     * compatilbilidade entre produtos adjacentes
     *
     * @param lote
     */
    public void persistLoteVazio(Lote lote) {
        try {
           Connection connection = jasperConnection.getConexao();
             String insert = "insert into lote(lado, sequencial, "
                    + "id_armazem, fk_id_dimensoes, estado ) values(?,?,?,?,?) "; 
            PreparedStatement prepared = connection.prepareStatement(insert);
             
            prepared.setString(1, lote.getLado());
            prepared.setInt(2, lote.getSequencial());
            prepared.setInt(3, lote.getIdArmazem());
            prepared.setInt(4, lote.getIdDimensoes());
            prepared.setInt(5, 1);
            
            
            prepared.executeUpdate();
           
                            
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
          List<Integer> retorno = new ArrayList<Integer>();
           ResultSet rs = null;
           Connection connection = null;

        try {
             connection = jasperConnection.getConexao();

            String query = " SELECT " +
"				c.numonu " +
"			        FROM " +
"				produto p, " +
"				tipo_comp t, " +
"				compatibilidade c " +
"		        WHERE " +
"				p.num_onu = " + nOnu+ 
"				AND " +
                                nOnu +	" != c.numonu " +
"				AND " +
"				p.classe = t.id_classe " +
"				AND " +
"				t.id_tipo_comp = c.id_tipo_comp; ";
          
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();

            while (rs.next()) {
                retorno.add(rs.getInt("numonu"));
               
            }
        connection.close();
            
        } catch (SQLException ex) {
            Logger.getLogger(ArmazenagemService.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(ArmazenagemService.class.getName()).log(Level.SEVERE, null, ex);
        }
         
    
        
        return retorno;
        
        
    }

    /**
     * Verifica se Existe lote disponivel no armazem
     *
     * @param armazemId
     * @return
     */
    public boolean verificaLoteDisponivel(Integer armazemId) {
        boolean retorno = false;
        ResultSet rs;
        try {
            Connection connection = jasperConnection.getConexao();

            String query = "select * from lote where id_armazem = " + armazemId + " AND estado = 1 order by sequencial; ";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();
            retorno = rs.next();
             
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
     * @param armazemId
     * @param lado
     * @param comprimentoArmazem
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
     * @param armazemId
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

            String query = "select * from lote where id_armazem = " + armazemId + " AND lado = '" +lado + "' AND (sequencial = " + seqA + " OR sequencial = " + seqB +"  ) order by sequencial; ";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();

            while (rs.next()) {
                Lote novoLote = new Lote();
                novoLote.setIdLote(rs.getInt("id_lote"));
                novoLote.setIdArmazem(rs.getInt("id_armazem"));
                novoLote.setIdDimensoes(rs.getInt("fk_id_dimensoes"));
                novoLote.setIdProduto(rs.getInt("num_onu"));
                novoLote.setQuantidadeProduto(rs.getDouble("quantidade_produtos"));
                novoLote.setSequencial(rs.getInt("sequencial"));
                novoLote.setLado(rs.getString("lado"));

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
                movimentacao.setIdMovimentacao(rs.getInt("id_movimentacao"));
                movimentacao.setTipo(rs.getInt("tipo"));

            }

            connection.close();
        } catch (SQLException ex) {
            Logger.getLogger(ArmazenagemService.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(ArmazenagemService.class.getName()).log(Level.SEVERE, null, ex);
        }
        return movimentacao;

    }


  /**
   * Retorna a Dimensoes
   * @param DimencoesId
   * @return 
   */
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
    
    
    
    /**
     * persist objeto dimensoes
     * @param dimensoes 
     */
    public void persistDimensoes(Dimensoes dimensoes ) {
        try {
           Connection connection = jasperConnection.getConexao();
             String insert = "insert into dimensoes(lar_dimensao, comp_dimensao)  values(?,?)"; 
            PreparedStatement prepared = connection.prepareStatement(insert);
             
            prepared.setDouble(1, dimensoes.getLargura());
            prepared.setDouble(2, dimensoes.getComprimento());
        
            prepared.executeUpdate();
            
          //  connection.commit();
            
            prepared.close();
            connection.close();
        } catch (Exception e) {
        }
     
    }
    
       /**
        * retorna o Id da ultima dimensao persistida
        * @return 
        */
       public Integer getUltimaDimensao() {
        
        ResultSet rs = null;
        Integer retorno = 2;

        try {
            Connection connection = jasperConnection.getConexao();

            String query = "select * from dimensoes m where m.id_dimensoes = (select MAX(b.id_dimensoes) from dimensoes b); ";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();

            while (rs.next()) {
                retorno = rs.getInt("id_dimensoes");
            }

             connection.close();
        } catch (SQLException ex) {
            Logger.getLogger(ArmazenagemService.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(ArmazenagemService.class.getName()).log(Level.SEVERE, null, ex);
        }
        return retorno;

    }

       
       /**
        * atualiza a movimentação de acordo com a realização do armazenametto do produto
     * @param lote
     * @param sucesso
        */
      public void persistMovimentacao(Lote lote, Integer sucesso ) {
          String referenciaLote = lote.getLado() + Integer.toString(lote.getSequencial());
          
          try {
           Connection connection = jasperConnection.getConexao();
             String insert = "Update movimentacao set referencia_lote = ? , sucesso = ? where id_movimentacao=?"; 
            PreparedStatement prepared = connection.prepareStatement(insert);
             
            prepared.setString(1, referenciaLote);
            prepared.setInt(2, sucesso);
            prepared.setInt(3, lote.getIdMovimentacao());
        
            prepared.executeUpdate();
            
         //   connection.commit();
            
            prepared.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
     
    }
      
      
      /**
       * Metodo retorna o ultimo lote do armazem, q
       * @param armazemId
       * @return 
       */
        public Lote getUltimoLote(Integer armazemId) {

       Lote lote = new Lote();
        ResultSet rs;
        try {
            Connection connection = jasperConnection.getConexao();

            String query = "select * from lote l where l.id_armazem = " + armazemId + " AND l.sequencial = (select MAX(b.sequencial) from lote b where b.id_armazem =  " + armazemId +  ");";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();

            while (rs.next()) {
               
                lote.setIdLote(rs.getInt("id_lote"));
                lote.setIdArmazem(rs.getInt("id_armazem"));
                lote.setIdDimensoes(rs.getInt("fk_id_dimensoes"));
                lote.setIdProduto(rs.getInt("num_onu"));
                lote.setQuantidadeProduto(rs.getDouble("quantidade_produtos"));
                lote.setSequencial(rs.getInt("sequencial"));
                
                lote.setDimensoes(getDimensoes(lote.getIdDimensoes()));
                
                           }
            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return lote;

    }
        /**
         *Atualiza o lote deve ser usado para retirada do produto
         */
       public void atualizaLote(Lote lote){
       try {
           Connection connection = jasperConnection.getConexao();
            String insert = "Update lote set estado = ? , quantidade_produtos = ?, num_onu = ? where id_lote=?"; 
            PreparedStatement prepared = connection.prepareStatement(insert);
                       
            prepared.setInt(1, lote.getEstado());
            prepared.setDouble(2, lote.getQuantidadeProduto());
            if(lote.getIdProduto() == null){
                prepared.setNull(3, java.sql.Types.INTEGER);
            }else{
                prepared.setInt(3, lote.getIdProduto());
            }
            
            prepared.setInt(4, lote.getIdLote());
            
            prepared.executeUpdate();
              
           // connection.commit();
            
            prepared.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
       
       
       } 
       
       
       
       /**
        * Retorna o espaço disponivel na rua para a criação de um novo lote, assim 
        * podemos verificar se temos espaço suficiente para o lote naquela rua
        * @param armazemId
        * @param lado
        * @return 
        */
        public Double getEspacoDisponivelLado(Integer armazemId, String lado) {

        List<Lote> lotes = new ArrayList<>();
        ResultSet rs;
        try {
            try (Connection connection = jasperConnection.getConexao()) {
                String query = "select * from lote where id_armazem = " + armazemId + " AND lado ='"+ lado +"'; ";
                PreparedStatement prepared = connection.prepareStatement(query);
                rs = prepared.executeQuery();
                
                while (rs.next()) {
                    Lote lote = new Lote();
                    lote.setIdLote(rs.getInt("id_lote"));
                    lote.setIdArmazem(rs.getInt("id_armazem"));
                    lote.setIdDimensoes(rs.getInt("fk_id_dimensoes"));
                    lote.setIdProduto(rs.getInt("num_onu"));
                    lote.setQuantidadeProduto(rs.getDouble("quantidade_produtos"));
                    lote.setSequencial(rs.getInt("sequencial"));
                    
                    lote.setDimensoes(getDimensoes(lote.getIdDimensoes()));
                    
                    lotes.add(lote);
                    
                }
                 connection.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        
        
        Double tamanhoUsado = 0.0;
        for(Lote loteUsado:lotes){
          
           tamanhoUsado += loteUsado.getDimensoes().getComprimento();
            
        }
        
        return tamanhoUsado;

    }

        

}
