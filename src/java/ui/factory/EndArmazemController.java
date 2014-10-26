package ui.factory;

import entiti.EndArmazem;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.inject.Inject;

@Named(value = "endArmazemController")
@ViewScoped
public class EndArmazemController extends AbstractController<EndArmazem> {

    @Inject
    private ProdutoController produtoListController;
    @Inject
    private MovimentacaoController movimentacaoListController;
    @Inject
    private ArmazemController armazemListController;

    public EndArmazemController() {
        // Inform the Abstract parent controller of the concrete EndArmazem?cap_first Entity
        super(EndArmazem.class);
    }

    /**
     * Resets the "selected" attribute of any parent Entity controllers.
     */
    public void resetParents() {
    }

    /**
     * Sets the "items" attribute with a List of Produto entities that are
     * retrieved from EndArmazem?cap_first and returns the navigation outcome.
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
     * Sets the "items" attribute with a List of Movimentacao entities
     * that are retrieved from EndArmazem?cap_first and returns the navigation
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
     * Sets the "items" attribute with a List of Armazem entities that are
     * retrieved from EndArmazem?cap_first and returns the navigation outcome.
     *
     * @return navigation outcome for Armazem page
     */
    public String navigateArmazemList() {
        if (this.getSelected() != null) {
            FacesContext.getCurrentInstance().getExternalContext().getRequestMap().put("Armazem_items", this.getSelected().getArmazemList());
        }
        return "/entiti/armazem/index";
    }

}
