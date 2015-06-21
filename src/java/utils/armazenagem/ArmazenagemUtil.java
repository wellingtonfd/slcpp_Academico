/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utils.armazenagem;

import Service.ArmazenagemService;
import entiti.Armazem;
import entiti.Dimensoes;
import entiti.Lote;
import entiti.Produto;
import java.util.List;

/**
 *
 * @author Gustavo
 * Classe para realizar os calculos referentes ao processo 
 * de armazenagem
 */

public class ArmazenagemUtil {
    
    // estamos arbitrando que o tamanho do palete é 1x1;
    final Dimensoes tamanhoPalete;
    
    ArmazenagemService armazenagemService;

    public ArmazenagemUtil() {
        this.tamanhoPalete = new Dimensoes(1.0,1.0);
    }
    
   
     /**
     * Metodo que calcula o tamanho do lote de acordo com as dimnsoes do armazem
     * e do proprio palete
     * Atenção estamos arbitrando que todo palete possui o tamanho de 1x1m
     * @param  armazen armazem onde será armazenado o produto
     * @param  numeroPaletes 
     * @return Dimensoes
     */
    public Dimensoes getTamanhoNecessarioLote(Armazem armazen, int numeroPaletes){
            
        double y = armazen.getTamanhoEspacoArmazenagem();       
    
        int qtdY = (int) (y/ tamanhoPalete.getLargura());
        
        int qtdX = 1;
        
        while((qtdY * qtdX) < numeroPaletes){
             qtdX++;
        }
        
        Dimensoes dimensoesLote = new Dimensoes(y, qtdX* tamanhoPalete.getComprimento());
        
        return dimensoesLote;
        
    }  
        
    /**
     * metodo retorno o tamaho fisico restante do armazem no eixo x
     * @param armazem
     * @return 
     */
    public double getTamanhoRestanteArmazem(Armazem armazem){
    
        double resultado = 0;
        
        Dimensoes dim =  armazem.getDimensoes();
                        
        return resultado;
    }
    
   
    /**
     * Metodo para calcular quantos paletes serão utilizados para armazenar determinada quantidade do produto
     * @param qtbPorPalete
     * @param quantidadeTotal
     * @return 
     */
    public double getNumeroPaletes(double qtbPorPalete, double quantidadeTotal){
        return  Math.ceil(quantidadeTotal/qtbPorPalete);
    }
    
    /**
     * Metodo para calcular quantos paletes serão utilizados para armazenar determinada quantidade do produto
     * @param produto
     * @param quantidadeTotal
     * @return 
     */
     public double getNumeroPaletes(Produto produto, double quantidadeTotal){
        return   Math.ceil(quantidadeTotal/produto.getQuantidadePorPalete());
     }
    
    
    /**metodo com a logica de negocio para definir onde o produto sera
     * armazenado
     * @param produto
     * @param armazem 
     * @param numeroPaletes 
     */
    public void armazenaProduto(Armazem armazem,Produto produto, int numeroPaletes){
    
        Lote lote;
     
        lote = armazenagemService.getLotedisponivel(produto);
        if(lote !=null){
           
             armazenagemService.armazenaProduto(produto, lote, numeroPaletes);
        }
        
        else
           armazenagemService.armazenaProdutoNovo(produto, getTamanhoNecessarioLote(armazem, numeroPaletes), numeroPaletes);
    
       }
    
    /**retorna lista de lotes onde o produto está armazenado
     * 
     * @param produto
     * @return 
     */
    public List<Lote> getLocalProdutoArmazenado(Produto produto){
    
        return armazenagemService.getLocalProdutoArmazenado(produto);
    }
    
    /**
     * armazena o produto
     * @param produto
     * @param numeroPaletes
     * @return 
     */
    public boolean armazenaProduto(Produto produto, int numeroPaletes){
    
        Armazem armazem;
                     
         return false;         
     }
    
    
    /** 
     * retira a determinada quantidade do produto armazenado
     * @param produto
     * @param quantidade
     * @return 
     */
    public boolean retiraProtudo(Produto produto, int quantidade){
    
        return armazenagemService.retiraProtudo(produto, quantidade);
        
    }
    
    /**
     * Metoto utilizado para retorno do primeiro lote vazio
     * @param armazem
     * @return 
     */
    public Lote getPrimerioLoteVazio(Armazem armazem){
        Lote lote = new Lote();
        
        return lote;
                
                
    }
     
}
