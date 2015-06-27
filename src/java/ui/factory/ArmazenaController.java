package ui.factory;

import entiti.Movimentacao;
import entiti.Produto;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.inject.Inject;
import utils.armazenagem.ArmazenagemUtil;

@Named(value = "armazenaController")
@ViewScoped
public class ArmazenaController extends AbstractController<Movimentacao> {


    @Inject
    private Produto produto;
    @Inject
    private ArmazenagemUtil armazenagemUtil;
    
    private double qtd;
    private int qdtPalete;
    
 
    public void armazena(){
        armazenagemUtil.armazenaProduto(produto, qtd, qdtPalete);
    }

    public Produto getProduto() {
        return produto;
    }

    public void setProduto(Produto produto) {
        this.produto = produto;
    }

    public ArmazenagemUtil getArmazenagemUtil() {
        return armazenagemUtil;
    }

    public void setArmazenagemUtil(ArmazenagemUtil armazenagemUtil) {
        this.armazenagemUtil = armazenagemUtil;
    }

    public double getQtd() {
        return qtd;
    }

    public void setQtd(double qtd) {
        this.qtd = qtd;
    }

    public int getQdtPalete() {
        return qdtPalete;
    }

    public void setQdtPalete(int qdtPalete) {
        this.qdtPalete = qdtPalete;
    }
    
 
}
