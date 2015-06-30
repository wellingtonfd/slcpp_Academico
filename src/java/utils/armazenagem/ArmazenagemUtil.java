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
import static java.lang.System.out;
import java.util.List;

/**
 * 
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
    public int getNumeroPaletes(double qtbPorPalete, double quantidadeTotal){
        return  (int)Math.ceil(quantidadeTotal/qtbPorPalete);
    }
    
    /**
     * Metodo para calcular quantos paletes serão utilizados para armazenar determinada quantidade do produto
     * @param produto
     * @param quantidadeTotal
     * @return 
     */
     public int getNumeroPaletes(Produto produto, double quantidadeTotal){
        return  (int) Math.ceil(quantidadeTotal/produto.getQuantidadePorPalete());
     }
    
    
    /**metodo com a logica de negocio para definir onde o produto sera
     * armazenado
     * @param produto
     * @param armazem 
     * @param numeroPaletes 
     * @param totalProduto 
     */
    public void armazenaProduto (Armazem armazem,Produto produto, int numeroPaletes, double totalProduto){
    
        Lote lote = null; 
             
        if(armazenagemService.verificaArmazemVazio(armazem)){
             lote = new Lote(); 
             lote.setArmazem(armazem);
             lote.setProduto(produto);
             lote.setNumeroPaletesArmazenados(numeroPaletes);
             lote.setQuantidadeProduto(totalProduto);
             lote.setSequencial(1);
             lote.setLado("E");
             lote.setDimensoes(getTamanhoNecessarioLote(armazem, numeroPaletes));
             armazenagemService.persistLote(lote);
             return;
        }
        
       List<Lote> lotes = armazenagemService.getLotesdisponiveis(armazem);
        if(lotes !=null){
            for (Lote loteExistente : lotes) {
            }
            lote = criaNovoLote(armazem, produto, numeroPaletes, totalProduto);
            armazenagemService.persistLote(lote);
        }
      //  else
         //  armazenagemService.armazenaProdutoNovo(produto, getTamanhoNecessarioLote(armazem, numeroPaletes), numeroPaletes);
        }
    
    /**retorna lista de lotes onde o produto está armazenado
     * @param produto
     * @return 
     */
    public List<Lote> getLocalProdutoArmazenado(Produto produto){
       return armazenagemService.getLocalProdutoArmazenado(produto);
    }
         
   /**
    * metodo de armazenamento do produto usado pelo controller 
    * @param produto
    * @param quantidadeTotal
    * @param quantidadePorPalete 
    */ 
   public void armazenaProduto(Produto produto, double quantidadeTotal, int quantidadePorPalete) {
         Armazem armazem =  verificaArmazemDisponivel(getArmazens());
         if(armazem == null){
             return;
         }
         int numeroDePaletes =  getNumeroPaletes(quantidadePorPalete, quantidadeTotal);
         System.out.println("armazem: " + armazem + "numero paletes: " + numeroDePaletes);
         armazenaProduto(armazem,produto, numeroDePaletes, quantidadeTotal);
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
     * Metoto utilizado para retorno dos lotes vazios
     * @param armazem
     * @return 
     */
    public List<Lote> getlotesDisponiveis(Armazem armazem){
        return armazenagemService.getLotesdisponiveis(armazem);
   }
    
   /**
    * Metodo retorna a quantidade total de um produto
    * @param produto
    * @return 
    */  
   public Double getQuantidadeTotalProduto(Produto produto){
        return (Double)armazenagemService.getQuantidadeTotalProduto(produto);
   } 
    
   /**
    * retorna lista de armazens disponiveis
    * @return 
    */
    public List<Armazem> getArmazens(){
        return armazenagemService.getAllArmazens();
   }
    
    public Lote criaNovoLote(Armazem armazem,Produto produto, int numeroPaletes, double totalProduto){
      return new Lote();
    }
     
    
    /**
     * MMetodo verica e retorna o armazem que será utilizado
     * @param armazens
     * @return 
     */
   public Armazem verificaArmazemDisponivel(List<Armazem> armazens){
       Armazem retorno = null;
       for (Armazem armazem : armazens) {
           if(armazenagemService.verificaEspacoVazioArmazem(armazem)){
               return armazem;
           }
       }
         return retorno;
    }
}
