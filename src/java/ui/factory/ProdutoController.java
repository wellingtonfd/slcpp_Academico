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
    
    public List<Produto> getProduto(){
        
        List<Produto> produtos = new ArrayList<Produto>();
        
        ResultSet rs;
        try{
            Connection connection = jasperConnection.getConexao();
            
            String query = "SELECT p.num_onu, p.desc_produto FROM produto p WHERE EXISTS (SELECT 1 FROM lote l WHERE l.num_onu = p.num_onu) ORDER BY num_onu;";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();
            
            while(rs.next()){
                Produto produto = new Produto();
                produto.setNumOnu(rs.getInt("num_onu"));
                produto.setDescProduto(rs.getString("desc_produto"));
                produtos.add(produto);
            }
            connection.close();
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        
        return produtos;
        
    }
    
    public List<Produto> getProdutoCreate(){
        
        List<Produto> produtos = new ArrayList<Produto>();
        
        ResultSet rs;
        try{
            Connection connection = jasperConnection.getConexao();
            
            String query = "SELECT p.num_onu, p.desc_produto FROM produto p ORDER BY p.num_onu;";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();
            
            while(rs.next()){
                Produto produto = new Produto();
                produto.setNumOnu(rs.getInt("num_onu"));
                produto.setDescProduto(rs.getString("desc_produto"));
                produtos.add(produto);
            }
            connection.close();
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        
        return produtos;
        
    }

    /**
     * Sets the "selected" attribute of the NumOnu controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
   

    /**
     * Sets the "selected" attribute of the NumCas controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
  

    /**
     * Sets the "selected" attribute of the LegendaCompatibilidade controller in
     * order to display its data in a dialog. This is reusing existing the
     * existing View dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
    
    /**
     * Sets the "selected" attribute of the EstFisico controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
   

    /**
     * Sets the "selected" attribute of the EndArmazem controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
   

    /**
     * Sets the "selected" attribute of the Compatibilidade controller in order
     * to display its data in a dialog. This is reusing existing the existing
     * View dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
   

    /**
     * Sets the "selected" attribute of the Classe controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
   

    /**
     * Sets the "selected" attribute of the Armazem controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
  

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
