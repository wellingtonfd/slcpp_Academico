package ui.factory;

import entiti.TipoComp;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.inject.Inject;

@Named(value = "tipoCompController")
@ViewScoped
public class TipoCompController extends AbstractController<TipoComp> {

    @Inject
    private LegendaCompatibilidadeController idLegendaCompatibilidadeController;
    @Inject
    private ClasseController idClasseController;

    public TipoCompController() {
        // Inform the Abstract parent controller of the concrete DetNota?cap_first Entity
        super(TipoComp.class);
    }

    /**
     * Resets the "selected" attribute of any parent Entity controllers.
     */
    public void resetParents() {
        idLegendaCompatibilidadeController.setSelected(null);
        idClasseController.setSelected(null);
       
    }

    /**
     * Sets the "items" attribute with a List of Movimentacao entities
     * that are retrieved from DetNota?cap_first and returns the navigation
     * outcome.
     *
     * @return navigation outcome for Movimentacao page
     */
//    public String navigateMovimentacaoList() {
//        if (this.getSelected() != null) {
//            FacesContext.getCurrentInstance().getExternalContext().getRequestMap().put("Movimentacao_items", this.getSelected());
//        }
//        return "/entiti/movimentacao/index";
//    }

    /**
     * Sets the "selected" attribute of the TipoEquipamento controller in order
     * to display its data in a dialog. This is reusing existing the existing
     * View dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
  
 public void prepareClasseIdClasse(ActionEvent event){
     if(this.getSelected() != null && idClasseController.getSelected() == null){
         idClasseController.setSelected(this.getSelected().getIdClasse());
     }
     
 }
    /**
     * Sets the "selected" attribute of the Produto controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
//    public void prepareIdProduto(ActionEvent event) {
//        if (this.getSelected() != null && idProdutoController.getSelected() == null) {
//            idProdutoController.setSelected(this.getSelected().getIdProduto());
//        }
//    }

    /**
     * Sets the "selected" attribute of the Fornecedor controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
 
 public void prepareidLegendaCompatibilidadeController(ActionEvent event){
     if(this.getSelected() != null && idLegendaCompatibilidadeController.getSelected() == null){
         idLegendaCompatibilidadeController.setSelected(this.getSelected().getIdLegenda());
     }
     
 }
 
  
}
