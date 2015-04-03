package ui.factory;

import entiti.Epi;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.inject.Inject;

@Named(value = "epiController")
@ViewScoped
public class EpiController extends AbstractController<Epi> {

    @Inject
    private TipoEquipamentoController tipoEquipamentoListController;

    public EpiController() {
        // Inform the Abstract parent controller of the concrete Epi?cap_first Entity
        super(Epi.class);
    }

    /**
     * Resets the "selected" attribute of any parent Entity controllers.
     */
    public void resetParents() {
    }

    /**
     * Sets the "items" attribute with a List of TipoEquipamento entities
     * that are retrieved from Epi?cap_first and returns the navigation outcome.
     *
     * @return navigation outcome for TipoEquipamento page
     *
    public String navigateTipoEquipamentoList() {
        if (this.getSelected() != null) {
            FacesContext.getCurrentInstance().getExternalContext().getRequestMap().put("TipoEquipamento_items", this.getSelected().);
        }
        return "/entiti/tipoEquipamento/index";
    }*/

}
