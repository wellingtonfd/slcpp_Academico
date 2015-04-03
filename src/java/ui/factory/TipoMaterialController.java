package ui.factory;

import entiti.TipoMaterial;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.faces.context.FacesContext;

@Named(value = "tipoMaterialController")
@ViewScoped
public class TipoMaterialController extends AbstractController<TipoMaterial> {

    public TipoMaterialController() {
        // Inform the Abstract parent controller of the concrete TipoMaterial?cap_first Entity
        super(TipoMaterial.class);
    }

}
