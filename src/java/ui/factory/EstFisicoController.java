package ui.factory;

import entiti.EstFisico;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.inject.Inject;

@Named(value = "estFisicoController")
@ViewScoped
public class EstFisicoController extends AbstractController<EstFisico> {

    @Inject
    private ProdutoController produtoListController;

    public EstFisicoController() {
        // Inform the Abstract parent controller of the concrete EstFisico?cap_first Entity
        super(EstFisico.class);
    }

    /**
     * Resets the "selected" attribute of any parent Entity controllers.
     */
    public void resetParents() {
    }

    /**
     * Sets the "items" attribute with a List of Produto entities that are
     * retrieved from EstFisico?cap_first and returns the navigation outcome.
     *
     * @return navigation outcome for Produto page
     */
    public String navigateProdutoList() {
        if (this.getSelected() != null) {
            FacesContext.getCurrentInstance().getExternalContext().getRequestMap().put("Produto_items", this.getSelected().getProdutoList());
        }
        return "/entiti/produto/index";
    }

}
