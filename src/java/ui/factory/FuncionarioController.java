package ui.factory;

import entiti.Funcionario;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.inject.Inject;
import org.primefaces.event.FlowEvent;

@Named(value = "funcionarioController")
@ViewScoped
public class FuncionarioController extends AbstractController<Funcionario> {

    @Inject
    private TipoSolicitacaoController tipoSolicitacaoListController;
    @Inject
    private MovimentacaoController movimentacaoListController;
    @Inject
    private UsuarioController idUsuarioController;
    @Inject
    private EnderecoController enderecoIdEnderecoController;
    @Inject
    private ContatosController contatosIdContatoController;
    
    private boolean skip;
    
      public boolean isSkip() {
        return skip;
    }
 
    public void setSkip(boolean skip) {
        this.skip = skip;
    }

    public FuncionarioController() {
        // Inform the Abstract parent controller of the concrete Funcionario?cap_first Entity
        super(Funcionario.class);
    }

    /**
     * Resets the "selected" attribute of any parent Entity controllers.
     */
    public void resetParents() {
        idUsuarioController.setSelected(null);
        enderecoIdEnderecoController.setSelected(null);
        contatosIdContatoController.setSelected(null);
    }

    /**
     * Sets the "items" attribute with a List of TipoSolicitacao entities
     * that are retrieved from Funcionario?cap_first and returns the navigation
     * outcome.
     *
     * @return navigation outcome for TipoSolicitacao page
     */
    public String navigateTipoSolicitacaoList() {
        if (this.getSelected() != null) {
            FacesContext.getCurrentInstance().getExternalContext().getRequestMap().put("TipoSolicitacao_items", this.getSelected().getTipoSolicitacaoList());
        }
        return "/entiti/tipoSolicitacao/index";
    }

    /**
     * Sets the "items" attribute with a List of Movimentacao entities
     * that are retrieved from Funcionario?cap_first and returns the navigation
     * outcome.
     *
     * @return navigation outcome for Movimentacao page
     */
    public String navigateMovimentacaoList() {
        if (this.getSelected() != null) {
            FacesContext.getCurrentInstance().getExternalContext().getRequestMap().put("Movimentacao_items", this.getSelected().getMovimentacaoList());
        }
        return "/entiti/movimentacao/index";
    }

    /**
     * Sets the "selected" attribute of the Usuario controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
    public void prepareIdUsuario(ActionEvent event) {
        if (this.getSelected() != null && idUsuarioController.getSelected() == null) {
            idUsuarioController.setSelected(this.getSelected().getIdUsuario());
        }
    }

    /**
     * Sets the "selected" attribute of the Endereco controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
    public void prepareEnderecoIdEndereco(ActionEvent event) {
        if (this.getSelected() != null && enderecoIdEnderecoController.getSelected() == null) {
            enderecoIdEnderecoController.setSelected(this.getSelected().getEnderecoIdEndereco());
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
