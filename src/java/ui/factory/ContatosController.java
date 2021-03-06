package ui.factory;

import entiti.Contatos;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.inject.Inject;

@Named(value = "contatosController")
@ViewScoped
public class ContatosController extends AbstractController<Contatos> {

    @Inject
    private FornecedorController fornecedorListController;
    @Inject
    private FuncionarioController funcionarioListController;

    public ContatosController() {
        // Inform the Abstract parent controller of the concrete Contatos?cap_first Entity
        super(Contatos.class);
    }

    /**
     * Resets the "selected" attribute of any parent Entity controllers.
     */
    public void resetParents() {
    }

    /**
     * Sets the "items" attribute with a List of Fornecedor entities that
     * are retrieved from Contatos?cap_first and returns the navigation outcome.
     *
     * @return navigation outcome for Fornecedor page
     */
    public String navigateFornecedorList() {
        if (this.getSelected() != null) {
            FacesContext.getCurrentInstance().getExternalContext().getRequestMap().put("Fornecedor_items", this.getSelected().getFornecedorList());
        }
        return "/entiti/fornecedor/index";
    }

    /**
     * Sets the "items" attribute with a List of Funcionario entities that
     * are retrieved from Contatos?cap_first and returns the navigation outcome.
     *
     * @return navigation outcome for Funcionario page
     */
    public String navigateFuncionarioList() {
        if (this.getSelected() != null) {
            FacesContext.getCurrentInstance().getExternalContext().getRequestMap().put("Funcionario_items", this.getSelected());
        }
        return "/entiti/funcionario/index";
    }

}
