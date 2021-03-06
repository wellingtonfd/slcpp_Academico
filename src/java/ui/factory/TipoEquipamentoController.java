package ui.factory;

import entiti.TipoEquipamento;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.inject.Inject;

@Named(value = "tipoEquipamentoController")
@ViewScoped
public class TipoEquipamentoController extends AbstractController<TipoEquipamento> {

    @Inject
    private MovimentacaoController movimentacaoListController;
    @Inject
    private VeiculoController idVeiculoController;
    @Inject
    private EpiController idEpiController;
    @Inject
    private EpeController epeIdEpeController;
    @Inject
    private DetNotaController detNotaListController;

    public TipoEquipamentoController() {
        // Inform the Abstract parent controller of the concrete TipoEquipamento?cap_first Entity
        super(TipoEquipamento.class);
    }

    /**
     * Resets the "selected" attribute of any parent Entity controllers.
     */
    public void resetParents() {
        idVeiculoController.setSelected(null);
        idEpiController.setSelected(null);
        epeIdEpeController.setSelected(null);
    }

    /**
     * Sets the "items" attribute with a List of Movimentacao entities
     * that are retrieved from TipoEquipamento?cap_first and returns the
     * navigation outcome.
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
     * Sets the "selected" attribute of the Veiculo controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
    public void prepareIdVeiculo(ActionEvent event) {
        if (this.getSelected() != null && idVeiculoController.getSelected() == null) {
            idVeiculoController.setSelected(this.getSelected().getIdVeiculo());
        }
    }

    /**
     * Sets the "selected" attribute of the Epi controller in order to display
     * its data in a dialog. This is reusing existing the existing View dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
    public void prepareIdEpi(ActionEvent event) {
        if (this.getSelected() != null && idEpiController.getSelected() == null) {
            idEpiController.setSelected(this.getSelected().getIdEpi());
        }
    }

    /**
     * Sets the "selected" attribute of the Epe controller in order to display
     * its data in a dialog. This is reusing existing the existing View dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
    public void prepareEpeIdEpe(ActionEvent event) {
        if (this.getSelected() != null && epeIdEpeController.getSelected() == null) {
            epeIdEpeController.setSelected(this.getSelected().getEpeIdEpe());
        }
    }

    /**
     * Sets the "items" attribute with a List of DetNota entities that are
     * retrieved from TipoEquipamento?cap_first and returns the navigation
     * outcome.
     *
     * @return navigation outcome for DetNota page
     */
    public String navigateDetNotaList() {
        if (this.getSelected() != null) {
            FacesContext.getCurrentInstance().getExternalContext().getRequestMap().put("DetNota_items", this.getSelected().getDetNotaList());
        }
        return "/entiti/detNota/index";
    }

}
