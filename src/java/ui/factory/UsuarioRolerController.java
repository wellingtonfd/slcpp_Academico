/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ui.factory;

import entiti.UsuarioRoler;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.faces.view.ViewScoped;
import javax.inject.Inject;
import javax.inject.Named;

/**
 *
 * @author sacramento
 */
@Named(value = "usuarioRolerController")
@ViewScoped
public class UsuarioRolerController extends AbstractController<UsuarioRoler> {

    @Inject
    private UsuarioController idUsuarioController;
    @Inject
    private RolerController idRolerController;

    public UsuarioRolerController() {
        super(UsuarioRoler.class);
    }

    public void resetParents() {
        idRolerController.setSelected(null);
        idUsuarioController.setSelected(null);

    }

    public void prepareIdUsuario(ActionEvent event) {
        if (this.getSelected() != null && idUsuarioController.getSelected() == null) {
            idUsuarioController.setSelected(this.getSelected().getLogin());
        }
    }

    public void prepareIdRoler(ActionEvent event) {
        if (this.getSelected() != null && idRolerController.getSelected() == null) {
            idRolerController.setSelected(this.getSelected().getRoler());
        }
    }
}
