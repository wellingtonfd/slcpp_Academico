package ui.factory;

import entiti.Fornecedor;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.inject.Inject;
import org.primefaces.event.FlowEvent;

@Named(value = "fornecedorController")
@ViewScoped
public class FornecedorController extends AbstractController<Fornecedor> {

    @Inject
    private TipoSolicitacaoController tipoSolicitacaoListController;
    @Inject
    private DetNotaController detNotaListController;
    @Inject
    private EnderecoController idEnderecoController;
    @Inject
    private ContatosController contatosIdContatoController;
    
     private boolean skip;

    public FornecedorController() {
        // Inform the Abstract parent controller of the concrete Fornecedor?cap_first Entity
        super(Fornecedor.class);
    }

    /**
     * Resets the "selected" attribute of any parent Entity controllers.
     */
    public void resetParents() {
        idEnderecoController.setSelected(null);
        contatosIdContatoController.setSelected(null);
    }

    /**
     * Sets the "items" attribute with a List of TipoSolicitacao entities
     * that are retrieved from Fornecedor?cap_first and returns the navigation
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
     * Sets the "items" attribute with a List of DetNota entities that are
     * retrieved from Fornecedor?cap_first and returns the navigation outcome.
     *
     * @return navigation outcome for DetNota page
     */
    public String navigateDetNotaList() {
        if (this.getSelected() != null) {
            FacesContext.getCurrentInstance().getExternalContext().getRequestMap().put("DetNota_items", this.getSelected().getDetNotaList());
        }
        return "/entiti/detNota/index";
    }

    /**
     * Sets the "selected" attribute of the Endereco controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
    public void prepareIdEndereco(ActionEvent event) {
        if (this.getSelected() != null && idEnderecoController.getSelected() == null) {
            idEnderecoController.setSelected(this.getSelected().getIdEndereco());
        }
    }

    /**
     * Sets the "selected" attribute of the Contatos controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
    public void prepareContatosIdContato(ActionEvent event) {
        if (this.getSelected() != null && contatosIdContatoController.getSelected() == null) {
            contatosIdContatoController.setSelected(this.getSelected().getContatosIdContato());
        }
    }
        public String onFlowProcess(FlowEvent event) {
        if(skip) {
            skip = false;   //reset in case user goes back
            return "confirm";
        }
        else {
            return event.getNewStep();
        }
    }
}
