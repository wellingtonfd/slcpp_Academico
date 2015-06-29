/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utils.armazenagem;

import entiti.Movimentacao;
import javax.faces.event.ActionEvent;

/**
 *
 * @author sacramento
 */
public class Armazena {
  
    public Movimentacao movimentacao = null;
    
    public ArmazenagemUtil armazenagemUtil = null;
  
    public void armazena(ActionEvent event){
        armazenagemUtil.armazenaProduto(movimentacao.getIdProduto(), movimentacao.getQuantidadeTotal(), movimentacao.getQuantidadePorPalete());
    }
    
}
