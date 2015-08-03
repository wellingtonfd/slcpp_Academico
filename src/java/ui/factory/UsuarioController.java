package ui.factory;

import entiti.Usuario;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.inject.Inject;

@Named(value = "usuarioController")
@ViewScoped
public class UsuarioController extends AbstractController<Usuario> {

    public UsuarioController() {
        // Inform the Abstract parent controller of the concrete Usuario?cap_first Entity
        super(Usuario.class);
    }

    /**
     * Resets the "selected" attribute of any parent Entity controllers.
     */
    public void resetParents() {
    }

    /**
     * Sets the "selected" attribute of the Roler controller in order to display
     * its data in a dialog. This is reusing existing the existing View dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
    /**
    public void prepareIdRoler(ActionEvent event) {
        if (this.getSelected() != null && idRolerController.getSelected() == null) {
            idRolerController.setSelected(this.getSelected().getIdRoler());
        }
    }
    * /

    /**
     * Sets the "items" attribute with a List of Funcionario entities that
     * are retrieved from Usuario?cap_first and returns the navigation outcome.
     *
     * @return navigation outcome for Funcionario page
     */
    public String navigateFuncionarioList() {
        if (this.getSelected() != null) {
            FacesContext.getCurrentInstance().getExternalContext().getRequestMap().put("Funcionario_items", this.getSelected().getFuncionarioList());
        }
        return "/entiti/funcionario/index";
    }
    
    public String navigateUsuarioRolerList(){
        if (this.getSelected() != null) {
            FacesContext.getCurrentInstance().getExternalContext().getRequestMap().put("UsuarioRoler_items", this.getSelected().getUsuarioRolerList());
        }
        return "/entiti/usuarioroler/index";
    }

}
