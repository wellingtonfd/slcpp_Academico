package ui.factory;

import entiti.Movimentacao;
import entiti.Produto;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.faces.application.FacesMessage;
import javax.faces.event.ActionEvent;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import org.primefaces.context.RequestContext;
import reports.jasperConnection;
import utils.armazenagem.ArmazenagemUtil;

@Named(value = "movimentacaoController")
@ViewScoped
public class MovimentacaoController extends AbstractController<Movimentacao> {

    @Inject
    private ProdutoController idProdutoController;
    @PersistenceContext
    EntityManager em;

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
     * metodo utilizado para realizar a armazenagem a partir da movimentacao
     * realizada
     *
     * @return
     */
    public int salvaArmazenagem() {

        ArmazenagemUtil armazenagemUtil = new ArmazenagemUtil();
        armazenagemUtil.insereUltimaMovimentacao();
        return 0;

    }

    public void informacao2() {
        FacesMessage message = null;
        if (+getSelected().getTipo() == 0) {
            message = new FacesMessage(FacesMessage.SEVERITY_INFO, "Produto " + getSelected().getIdProduto().getDescProduto(), "Foi armanazenado com sucesso");
        }
        if (+getSelected().getTipo() == 1) {
            message = new FacesMessage(FacesMessage.SEVERITY_INFO, "Produto " + getSelected().getIdProduto().getDescProduto(), "Foi retirado com sucesso");
        }
        RequestContext.getCurrentInstance().showMessageInDialog(message);
    }

    /**
     * Sets the "selected" attribute of the Produto controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     * @return
     */
//    public void prepareIdProduto(ActionEvent event) {
//        if (this.getSelected() != null && idProdutoController.getSelected() == null) {
//            idProdutoController.setSelected(this.getSelected().getIdProduto());
//        }
//    }


    public Number getTotalProduto() {
        Number retorno = 0;

        String sql = "SELECT SUM(l.quantidadeProduto) FROM Lote l WHERE l.produto = :numonu";

        try {

            Query query = em.createQuery(sql);
            query.setParameter("numonu", getSelected().getIdProduto());
            retorno = (Number) query.getSingleResult();

        } catch (Exception e) {
            retorno = 0;
        }

        return retorno;
    }
}
