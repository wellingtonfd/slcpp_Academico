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
import javax.persistence.ParameterMode;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.StoredProcedureQuery;

/**
 * Classe service para tratar das interações [com o banco de dados da classe
 * armazenagem Util
 *
 */
@Stateless
public class ArmazenagemService {

    @PersistenceContext(unitName = "slcpp_AcademicoPU")
    private EntityManager em;

    /**
     * Verifica se o produto a ser inserido ja está armazenado
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
        return (lote != null);
    }

    /**
     * metodo que retorna a lista de lotes onde o produto está armazenado
     *
     * @param produto
     * @return
     */
    public List<Lote> getLocalProdutoArmazenado(Produto produto) {

        List<Lote> lotes = null;
        try {
            lotes = em.createNamedQuery("Lote.findByProduto")
                    .setParameter("produto", produto)
                    .getResultList();
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

        List<Lote> lotes = null;
        try {
            lotes = em.createNamedQuery("Lote.findAll")
                    .getResultList();
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

        List<Armazem> armazens = null;
        try {
            armazens = em.createNamedQuery("Armazem.findAll")
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return armazens;

    }

    public List<Lote> getLotesPorAramazem(Armazem armazem) {

        List<Lote> lotes = null;
        try {
            lotes = em.createNamedQuery("Lote.findAllByArmazem")
                    .setParameter("armazem", armazem)
                    .getResultList();
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
    public List<Lote> getLotesdisponiveis(Armazem armazem) {
        Query query = em.createQuery("SELECT l FROM Lote l WHERE l.estadoArmazenagem = :estadoArmazenagem AND l.armazem = :armazem order by l.sequencial")
                .setParameter("armazem", armazem)
                .setParameter("estadoArmazenagem", EstadoArmazenagem.VAZIO);
        return query.getResultList();
    }

    public boolean verificaArmazemVazio(Armazem armazem) {
        Query query = em.createQuery("SELECT l FROM Lote l WHERE l.armazem = :armazem")
                .setParameter("armazem", armazem);
        return query.getResultList() == null;
    }

    /**
     * Metodo verifica se o produto que será armazenado é compativel com o
     * produto vizinho ja armazenado
     *
     * @param produtoParaArmazenar
     * @param produtoVizinho
     * @return
     */
    public boolean verificaCompatibilidade(Produto produtoParaArmazenar, Produto produtoVizinho) {
        List<Integer> numeros;
        numeros = getProdutosIncompativeis(produtoParaArmazenar.getNumOnu());
        return !numeros.contains(produtoVizinho.getNumOnu());
    }

    /**
     * Aramazena o produto que que já esta armazenado anteriormente
     * @param produto
     * @param lote
     * @param numeroPaletes
     * @return
     */
    public boolean armazenaProduto(Produto produto, Lote lote, int numeroPaletes) {

        return true;
    }

    /**
     * armazena um novo produto
     *
     * @param produto
     * @param dimensoesLote
     * @param numeroPaletes
     * @return
     */
    public boolean armazenaProdutoNovo(Produto produto, Dimensoes dimensoesLote, int numeroPaletes) {

        return true;
    }

    /**
     * retira o produto
     *
     * @param produto
     * @param quantidade
     * @return
     */
    public boolean retiraProtudo(Produto produto, int quantidade) {
        List<Lote> lotes = getLocalProdutoArmazenado(produto);

        
        
        return false;
    }

    /**
     * retorna a quanidade total de um determinado produto
     *
     * @param produto
     * @return
     */
    public Number getQuantidadeTotalProduto(Produto produto) {
        Query query = em.createQuery("SELECT SUM(l.quantidadeProduto) FROM Lote l  WHERE l.produto = :produto");
        return (Number) query.getSingleResult();
    }

    /**
     * retorna o proximo sequencial a ser utilizado para o enrereçamento do lote
     *
     * @param produto
     * @return
     */
    public Number getProximoSequencial(Produto produto) {
        Query query = em.createQuery("SELECT SUM(l.quantidadeProduto) FROM Lote l  WHERE l.produto = :produto");
        return (Number) query.getSingleResult();
    }

    /**
     * Persist lote
     *
     * @param lote
     */
    public void persistLote(Lote lote) {
        em.getTransaction().begin();
        em.persist(lote);
        em.getTransaction().commit();
    }

    /**
     * Metodo que executa procedure para buscar os produtos inconpativeis
     *
     * @param nOnu
     * @return
     */
    public List<Integer> getProdutosIncompativeis(int nOnu) {

        StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("incompatibilidade");
        // set parametros
        storedProcedure.registerStoredProcedureParameter("p_numonu ", Integer.class, ParameterMode.IN);
        storedProcedure.registerStoredProcedureParameter("numonu", Integer.class, ParameterMode.OUT);
        storedProcedure.setParameter("p_numonu", nOnu);
        // executa SP
        storedProcedure.execute();
        // get resultado
        List<Integer> resultado = (List<Integer>) storedProcedure.getOutputParameterValue("numonu");
        return resultado;
    }

    /**
     * Verifica se Existe lote disponivel no armazem
     *
     * @param armazem
     * @return
     */
    public boolean verificaLoteDisponivel(Armazem armazem) {
        Query query = em.createQuery("SELECT l FROM Lote l WHERE l.estadoArmazenagem = :estadoArmazenagem AND l.armazem = :armazem order by l.sequencial")
                .setParameter("armazem", armazem)
                .setParameter("estadoArmazenagem", EstadoArmazenagem.VAZIO);
        return query.getResultList() != null;
    }

    /**
     * Metodo verifica o espaço vazio dentro do armazem. Usado para a criação de
     * um novo lote
     *
     * @param armazem
     * @return
     */
    public boolean verificaEspacoVazioArmazem(Armazem armazem) {

        double comprimento = 0;
        if (verificaLoteDisponivel(armazem)) {
            return true;
        } else {
            List<Lote> lotes = getLotesPorAramazem(armazem);
            for (Lote lote : lotes) {
                comprimento += lote.getDimensoes().getComprimento();
            }
            if (comprimento < armazem.getDimensoes().getComprimento()) {
                return true;
            }
        }
        return false;
    }
    
    public List<Lote> getLotesVizinhos(Lote lote){
        if(lote.getLado().equals("E")){
        
        Query query = em.createQuery("SELECT l FROM Lote l WHERE l.estadoArmazenagem = :estadoArmazenagem AND l.armazem = :armazem order by l.sequencial")
                .setParameter("armazem", lote.getArmazem())
                .setParameter("estadoArmazenagem", EstadoArmazenagem.VAZIO);
        return query.getResultList();
        }else{
        
          Query query = em.createQuery("SELECT l FROM Lote l WHERE l.estadoArmazenagem = :estadoArmazenagem AND l.armazem = :armazem order by l.sequencial")
                .setParameter("armazem", lote.getArmazem())
                .setParameter("estadoArmazenagem", EstadoArmazenagem.VAZIO);
        return query.getResultList();
        
        
        }
            
    }

}
