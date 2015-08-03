package ui.factory;

import entiti.LocalOperacao;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.faces.context.FacesContext;
import javax.inject.Inject;

@Named(value = "localOperacaoController")
@ViewScoped
public class LocalOperacaoController extends AbstractController<LocalOperacao> {



    public LocalOperacaoController() {
        // Inform the Abstract parent controller of the concrete LocalOperacao?cap_first Entity
        super(LocalOperacao.class);
    }

    /**
     * Resets the "selected" attribute of any parent Entity controllers.
     */
    public void resetParents() {
    }

    /**
     * Sets the "items" attribute with a List of Armazem entities that are
     * retrieved from LocalOperacao?cap_first and returns the navigation
     * outcome.
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
