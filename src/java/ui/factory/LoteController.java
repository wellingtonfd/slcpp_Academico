package ui.factory;

import entiti.Lote;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.inject.Inject;

@Named(value = "loteController")
@ViewScoped
public class LoteController extends AbstractController<Lote> {

    @Inject
    private ProdutoController produtoListController;
    @Inject
    private CompatibilidadeController compatibilidadeListController;

    public LoteController() {
        // Inform the Abstract parent controller of the concrete LegendaCompatibilidade?cap_first Entity
        super(Lote.class);
    }

    /**
     * Resets the "selected" attribute of any parent Entity controllers.
     */
    public void resetParents() {
    }

    /**
     * Sets the "items" attribute with a List of Produto entities that are
     * retrieved from LegendaCompatibilidade?cap_first and returns the
     * navigation outcome.
     *
     * @return navigation outcome for Produto page
     */
//    public String navigateProdutoList() {
//        if (this.getSelected() != null) {
//            FacesContext.getCurrentInstance().getExternalContext().getRequestMap().put("Produto_items", this.getSelected().getProdutoList());
//        }
//        return "/entiti/produto/index";
//    }

    /**
     * Sets the "items" attribute with a List of Compatibilidade entities
     * that are retrieved from LegendaCompatibilidade?cap_first and returns the
     * navigation outcome.
     *
     * @return navigation outcome for Compatibilidade page
     */


}
