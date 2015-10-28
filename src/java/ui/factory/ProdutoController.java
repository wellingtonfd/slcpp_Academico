package ui.factory;

import entiti.Produto;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.faces.context.FacesContext;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.TypedQuery;
import reports.jasperConnection;

@Named(value = "produtoController")
@ViewScoped
public class ProdutoController extends AbstractController<Produto> {

   
   
    @Inject
    private LegendaCompatibilidadeController idLegendaCompatibilidadeController;
    @Inject
    private CompatibilidadeController idCompatibilidadeController;
    @Inject
    private ClasseController idClasseController;
    @PersistenceContext
    private EntityManager em;
    
     List<Produto> produtos = null;

    public ProdutoController() {
        // Inform the Abstract parent controller of the concrete Produto?cap_first Entity
        super(Produto.class);
    }

    /**
     * Resets the "selected" attribute of any parent Entity controllers.
     */
    public void resetParents() {
        idLegendaCompatibilidadeController.setSelected(null);
        idCompatibilidadeController.setSelected(null);
        idClasseController.setSelected(null);
        
    }
      
    public List<Produto> getProdutoSaida(){
 
         boolean num = true;
        try{
            Query query = em.createNamedQuery("Produto.findAllByLote").setParameter("num", num);
            produtos = query.getResultList();
        }catch(Exception e){
            e.printStackTrace();
        }
        return produtos;
    }
    
    public List<Produto> getProdutoEntrada(){  

        try{
            Query query = em.createNamedQuery("Produto.findAll");
            produtos = query.getResultList();
        }catch(Exception e){
            e.printStackTrace();
        }    
        return produtos;    
    }



    /**
     * Sets the "items" attribute with a List of Movimentacao entities
     * that are retrieved from Produto?cap_first and returns the navigation
     * outcome.
     *
     * @return navigation outcome for Movimentacao page
     */
    public String navigateMovimentacaoList() {
        if (this.getSelected() != null) {
            FacesContext.getCurrentInstance().getExternalContext().getRequestMap().put("Movimentacao_items", this.getSelected());
        }
        return "/entiti/movimentacao/index";
    }

    /**
     * Sets the "items" attribute with a List of DetNota entities that are
     * retrieved from Produto?cap_first and returns the navigation outcome.
     *
     * @return navigation outcome for DetNota page
     */
    public String navigateDetNotaList() {
        if (this.getSelected() != null) {
            FacesContext.getCurrentInstance().getExternalContext().getRequestMap().put("DetNota_items", this.getSelected());
        }
        return "/entiti/detNota/index";
    }

}
