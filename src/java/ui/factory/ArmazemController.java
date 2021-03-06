package ui.factory;

import entiti.Armazem;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.inject.Inject;

@Named(value = "armazemController")
@ViewScoped
public class ArmazemController extends AbstractController<Armazem> {

    @Inject
    private ProdutoController produtoListController;
    @Inject
    private TipoSolicitacaoController tipoSolicitacaoListController;
    @Inject
    private MovimentacaoController movimentacaoListController;
    @Inject
    private StatusArmazemController statusArmazemIdStatusArmazemController;
    @Inject
    private LocalOperacaoController localOperacaoIdLocalOperController;
    @Inject
    private EndArmazemController idEndarmazemController;

    public ArmazemController() {
        // Inform the Abstract parent controller of the concrete Armazem?cap_first Entity
        super(Armazem.class);
    }

    /**
     * Resets the "selected" attribute of any parent Entity controllers.
     */
    public void resetParents() {
        statusArmazemIdStatusArmazemController.setSelected(null);
        localOperacaoIdLocalOperController.setSelected(null);
        idEndarmazemController.setSelected(null);
    }

    /**
     * Sets the "items" attribute with a List of Produto entities that are
     * retrieved from Armazem?cap_first and returns the navigation outcome.
     *
     * @return navigation outcome for Produto page
     */
    public String navigateProdutoList() {
        if (this.getSelected() != null) {
            FacesContext.getCurrentInstance().getExternalContext().getRequestMap().put("Produto_items", this.getSelected().getProdutoList());
        }
        return "/entiti/produto/index";
    }

    /**
     * Sets the "items" attribute with a List of TipoSolicitacao entities
     * that are retrieved from Armazem?cap_first and returns the navigation
     * outcome.
     *
     * @return navigation outcome for TipoSolicitacao page
     */
    public String navigateTipoSolicitacaoList() {
        if (this.getSelected() != null) {
            FacesContext.getCurrentInstance().getExternalContext().getRequestMap().put("TipoSolicitacao_items", this.getSelected());
        }
        return "/entiti/tipoSolicitacao/index";
    }

    /**
     * Sets the "items" attribute with a List of Movimentacao entities
     * that are retrieved from Armazem?cap_first and returns the navigation
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
     * Sets the "selected" attribute of the StatusArmazem controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
    public void prepareStatusArmazemIdStatusArmazem(ActionEvent event) {
        if (this.getSelected() != null && statusArmazemIdStatusArmazemController.getSelected() == null) {
            statusArmazemIdStatusArmazemController.setSelected(this.getSelected().getStatusArmazemIdStatusArmazem());
        }
    }

    /**
     * Sets the "selected" attribute of the LocalOperacao controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
    public void prepareLocalOperacaoIdLocalOper(ActionEvent event) {
        if (this.getSelected() != null && localOperacaoIdLocalOperController.getSelected() == null) {
            localOperacaoIdLocalOperController.setSelected(this.getSelected().getLocalOperacaoIdLocalOper());
        }
    }

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
