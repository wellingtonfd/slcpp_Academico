/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Service;

import entiti.Armazem;
import entiti.Dimensoes;
import entiti.Lote;
import entiti.Produto;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 *
 * @author Gustavo
 */
@Stateless
public class ArmazenagemService {

    @PersistenceContext(unitName = "slcpp_AcademicoPU")
    private EntityManager em;

    /**
     * Verifica de o produto a ser inserido ja está armazenado
     *
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
            lotes =  em.createNamedQuery("Lote.findAllByProduto")
                    .setParameter("produto", produto)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        }
      
        return lotes  ;
     }
      
     
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
                    .setParameter("produto", armazem) 
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        }
      
        return lotes  ;
     
     }
     
     
     /**
      * 
      * @param produto
      * @return 
      */     
     public Lote getLotedisponivel (Produto produto){
            return null;
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
        
        return false;
    } 
     
     
}
