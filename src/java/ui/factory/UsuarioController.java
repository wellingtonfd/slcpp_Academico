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
    
    @Inject
    private RolerController idRolerController;

    public UsuarioController() {
        // Inform the Abstract parent controller of the concrete Usuario?cap_first Entity
        super(Usuario.class);
    }

    /**
     * Resets the "selected" attribute of any parent Entity controllers.
     */
    public void resetParents() {
        idRolerController.setSelected(null);
    }
    
 }
