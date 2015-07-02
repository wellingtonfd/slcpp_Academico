package ui.factory;

import entiti.Movimentacao;
import static java.sql.DriverManager.println;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.inject.Inject;
import utils.armazenagem.ArmazenagemUtil;

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
     * metodo utilizado para realizar a armazenagem a partir da movimentacao realizada
     */
    public void salvaArmazenagem(){
    
        ArmazenagemUtil armazenagemUtil = new ArmazenagemUtil();
        armazenagemUtil.insereUltimaMovimentacao();
        
      
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
