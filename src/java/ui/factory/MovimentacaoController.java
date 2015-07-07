package ui.factory;

import entiti.Movimentacao;
import javax.faces.application.FacesMessage;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.inject.Inject;
import org.primefaces.context.RequestContext;
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
    public int salvaArmazenagem(){
    
        ArmazenagemUtil armazenagemUtil = new ArmazenagemUtil();
        armazenagemUtil.insereUltimaMovimentacao();
        return 0;  
      
    }
    
    

    
    public void informacao2() {
        FacesMessage message = new FacesMessage(FacesMessage.SEVERITY_INFO, "Produto "+getSelected().getIdProduto().getDescProduto(), "Foi armanazenado com sucesso");
         
        RequestContext.getCurrentInstance().showMessageInDialog(message);
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
