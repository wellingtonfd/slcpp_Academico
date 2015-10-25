package ui.factory;

import entiti.Usuario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.inject.Inject;
import reports.jasperConnection;

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
    
    public void setAtivo(ActionEvent event){
       
        boolean update = false;
        
        try{ 
           
            
            if(getSelected().getAtivo()==false){
            update = true;
            }
            if(getSelected().getAtivo()==true){
                update = false;
            }
            
            getSelected().setAtivo(update);
            save(event);
            
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
 }
