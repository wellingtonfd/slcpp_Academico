/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utils.armazenagem;

import entiti.Produto;
import javax.annotation.ManagedBean;
import javax.faces.event.ActionEvent;
import javax.inject.Named;

/**
 *
 * @author sacramento
 */
@Named(value = "armazena")
public class Armazena {
  
   
    private Produto idProduto;
    private double qtdTotal;
    private int qtdPalete;

    public Produto getIdProduto() {
        return idProduto;
    }

    public void setIdProduto(Produto idProduto) {
        this.idProduto = idProduto;
    }

    public double getQtdTotal() {
        return qtdTotal;
    }

    public void setQtdTotal(double qtdTotal) {
        this.qtdTotal = qtdTotal;
    }

    public int getQtdPalete() {
        return qtdPalete;
    }

    public void setQtdPalete(int qtdPalete) {
        this.qtdPalete = qtdPalete;
    }
    
    ArmazenagemUtil armazenagemUtil= new ArmazenagemUtil();
  
    public void armazena(ActionEvent event){
        armazenagemUtil.armazenaProduto(idProduto, qtdTotal, qtdPalete);
    }
    
}
