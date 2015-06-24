/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Service;

import entiti.Armazem;
import entiti.Dimensoes;
import entiti.Lote;
import entiti.Lote.EstadoArmazenagem;
import entiti.Produto;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

/**
 *
 * @author Gustavo
 */
@Stateless
public class ArmazenagemService {

    @PersistenceContext(unitName = "slcpp_AcademicoPU")
    private EntityManager em;

    /**
     * Verifica se o produto a ser inserido ja está armazenado
     * @param produto
     * @return boolean
     */
    public boolean verificaExisteProduto(Produto produto) {

        Lote lote = null;
        try {
            lote = (Lote) em.createNamedQuery("Lote.findByProduto")
                    .setParameter("produto", produto)
                    .getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
        }
      
        return (lote!=null) ;
    }

  
       /**
       * metodo que retorna a lista de lotes onde o produto está armazenado
       * @param produto
       * @return 
       */
     public List<Lote> getLocalProdutoArmazenado(Produto produto){
         
        List<Lote> lotes = null;
        try {
            lotes =  em.createNamedQuery("Lote.findByProduto")
                    .setParameter("produto", produto)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lotes  ;
     }
      
         
     /**
      * retorna todos os lotes
      * @return List Lote
      */
     public List<Lote> getAllLotes(){
     
            List<Lote> lotes = null;
        try {
            lotes =  em.createNamedQuery("Lote.findAllBy")
                     .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lotes  ;
     
     }
     
      public List<Lote> getLotesPorAramazem(Armazem armazem){
     
            List<Lote> lotes = null;
        try {
            lotes =  em.createNamedQuery("Lote.findAllByArmazem")
                    .setParameter("armazem", armazem) 
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        }
      
        return lotes  ;
    }
          
     /**
     * retorna a lista de lotes vazios em um determibnado armazem
     * @param armazem
     * @return 
      */     
     public List<Lote> getLotesdisponiveis (Armazem armazem){
        Query query = em.createQuery("SELECT l FROM Lote l WHERE l.estadoArmazenagem = :estadoArmazenagem AND l.armazem = :armazem order by l.sequencial")
                        .setParameter("armazem", armazem)  
                        .setParameter("estadoArmazenagem", EstadoArmazenagem.VAZIO);
        return  query.getResultList();
    }
     
     public boolean verificaArmazemVazio(Armazem armazem){
     
         Query query = em.createQuery("SELECT l FROM Lote l WHERE l.armazem = :armazem")
                        .setParameter("armazem", armazem);  
         return  query.getResultList() == null;
     
     }
     
         
     
     public boolean verificaCompatibilidade(Produto produto){
            
     return false;
     }
     
     
    /**
     * Aramazena o produto que que já esta armazenado anteriormente
     * @param produto
     * @param lote
     * @param numeroPaletes
     * @return 
     */ 
     public boolean armazenaProduto (Produto produto, Lote lote, int numeroPaletes){
      
         return true;
    }
     
     /**
      * armazena um novo produto
      * @param produto
      * @param dimensoesLote
      * @param numeroPaletes
      * @return 
      */
    public boolean armazenaProdutoNovo (Produto produto, Dimensoes dimensoesLote, int numeroPaletes){
               
         return true;
    }
       
     
    /**
     * retira o produto
     * @param produto
     * @param quantidade
     * @return 
     */
    public boolean retiraProtudo(Produto produto, int quantidade){
        List<Lote> lotes =  getLocalProdutoArmazenado(produto);
      
        
        return false;
    } 
     
        
       
    /**
     * retorna a quanidade total de um determinado produto
     * @param produto
     * @return 
     */
    public  Number getQuantidadeTotalProduto(Produto produto) {
        Query query = em.createQuery("SELECT SUM(l.quantidadeProduto) FROM Lote l  WHERE l.produto = :produto");
        return (Number) query.getSingleResult();
    }
    
    
   /**
    * retorna o proximo sequencial a ser utilizado para o 
    * enrereçamento do lote
    * @param produto
    * @return 
    */
     public  Number getProximoSequencial(Produto produto) {
        Query query = em.createQuery("SELECT SUM(l.quantidadeProduto) FROM Lote l  WHERE l.produto = :produto");
        return (Number) query.getSingleResult();
    }
    
    /**
     * Persist lote
     * @param lote
      */
    public void  persistLote(Lote lote){
         em.getTransaction().begin();
         em.persist(lote);
         em.getTransaction().commit();
    }
            
}
