package ui.factory;

import entiti.Movimentacao;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.inject.Inject;

@Named(value = "movimentacaoController")
@ViewScoped
public class MovimentacaoController extends AbstractController<Movimentacao> {

    @Inject
    private TipoSolicitacaoController idTipoSolicitacaoController;
    @Inject
    private TipoEquipamentoController idTipoEquipamentoController;
    @Inject
    private ProdutoController idProdutoController;
    @Inject
    private FuncionarioController idFuncionarioController;
    @Inject
    private EndArmazemController idEndarmazemController;
    @Inject
    private DetNotaController idDetalheNotaController;
    @Inject
    private ArmazemController idArmazemController;

    public MovimentacaoController() {
        // Inform the Abstract parent controller of the concrete Movimentacao?cap_first Entity
        super(Movimentacao.class);
    }

    /**
     * Resets the "selected" attribute of any parent Entity controllers.
     */
    public void resetParents() {
        idTipoSolicitacaoController.setSelected(null);
        idTipoEquipamentoController.setSelected(null);
        idProdutoController.setSelected(null);
        idFuncionarioController.setSelected(null);
        idEndarmazemController.setSelected(null);
        idDetalheNotaController.setSelected(null);
        idArmazemController.setSelected(null);
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
     * Sets the "selected" attribute of the EndArmazem controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
    public void prepareIdEndarmazem(ActionEvent event) {
        if (this.getSelected() != null && idEndarmazemController.getSelected() == null) {
            idEndarmazemController.setSelected(this.getSelected().getIdEndarmazem());
        }
    }

    

  
}
