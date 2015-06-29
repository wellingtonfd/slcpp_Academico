package ui.factory;

import entiti.Movimentacao;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.inject.Inject;

@Named(value = "movimentacaoController")
@ViewScoped
public class MovimentacaoController extends AbstractController<Movimentacao> {

    @Inject
    private ProdutoController idProdutoController;

    public MovimentacaoController() {
        // Inform the Abstract parent controller of the concrete Movimentacao?cap_first Entity
        super(Movimentacao.class);
    }

    /**
     * Resets the "selected" attribute of any parent Entity controllers.
     */
    public void resetParents() {
        idProdutoController.setSelected(null);
    }

 


    /**
     * Sets the "selected" attribute of the Produto controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
//    public void prepareIdProduto(ActionEvent event) {
//        if (this.getSelected() != null && idProdutoController.getSelected() == null) {
//            idProdutoController.setSelected(this.getSelected().getIdProduto());
//        }
//    }



  
}
