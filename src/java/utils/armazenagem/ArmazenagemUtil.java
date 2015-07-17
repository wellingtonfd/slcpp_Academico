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
import entiti.Movimentacao;
import entiti.Produto;
import java.security.Provider.Service;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * Classe para realizar os calculos referentes ao processo de armazenagem
 */
public class ArmazenagemUtil {

    // estamos arbitrando que o tamanho do palete é 1x1;
    final Dimensoes tamanhoPalete;

    ArmazenagemService armazenagemService = new ArmazenagemService();

       
    public ArmazenagemUtil() {
        this.tamanhoPalete = new Dimensoes(1.0, 1.0);
    }

    /**
     * Metodo que calcula o tamanho do lote de acordo com as dimnsoes do armazem
     * e do proprio palete Atenção estamos arbitrando que todo palete possui o
     * tamanho de 1x1m
     *
     * @param armazen armazem onde será armazenado o produto
     * @param numeroPaletes
     * @return Dimensoes
     */
    public Dimensoes getTamanhoNecessarioLote(Armazem armazen, int numeroPaletes) {
        double y = armazen.getTamanhoEspacoArmazenagem();
        int qtdY = (int) (y / tamanhoPalete.getLargura());
        int qtdX = 1;
        while ((qtdY * qtdX) < numeroPaletes) {
            qtdX++;
        }
        Dimensoes dimensoesLote = new Dimensoes(y, qtdX * tamanhoPalete.getComprimento());
        return dimensoesLote;
    }

    /**
     * metodo retorno o tamaho fisico restante do armazem no eixo x
     *
     * @param armazem
     * @return
     */
    public double getTamanhoRestanteArmazem(Armazem armazem) {
        double resultado = 0;
        Dimensoes dim = armazem.getDimensoes();
        return resultado;
    }

    /**
     * Metodo para calcular quantos paletes serão utilizados para armazenar
     * determinada quantidade do produto
     *
     * @param qtbPorPalete
     * @param quantidadeTotal
     * @return
     */
    public int getNumeroPaletes(double qtbPorPalete, double quantidadeTotal) {
        return (int) Math.ceil(quantidadeTotal / qtbPorPalete);
    }

    /**
     * Metodo para calcular quantos paletes serão utilizados para armazenar
     * determinada quantidade do produto
     *
     * @param produto
     * @param quantidadeTotal
     * @return
     */
    public int getNumeroPaletes(Produto produto, double quantidadeTotal) {
        return (int) Math.ceil(quantidadeTotal / produto.getQuantidadePorPalete());
    }

    /**
     * metodo com a logica de negocio para definir onde o produto sera
     * armazenado
     *
     * @param produto
     * @param armazem
     * @param numeroPaletes
     * @param totalProduto
     */
    public void armazenaProduto(Armazem armazem, Integer produtoId, int numeroPaletes, double totalProduto, Integer idMovimentacao) {

        Lote lote = null;
        Integer armazemId = armazem.getIdArmazem();

        if (armazenagemService.verificaArmazemVazio(armazem.getIdArmazem())) {
            lote = new Lote();
            lote.setArmazem(armazem);
            lote.setIdProduto(produtoId);
            lote.setNumeroPaletesArmazenados(numeroPaletes);
            lote.setQuantidadeProduto(totalProduto);
            lote.setSequencial(1);
            lote.setLado("E");
            lote.setDimensoes(getTamanhoNecessarioLote(armazem, numeroPaletes));
            lote.setIdArmazem(armazemId);
            armazenagemService.persistDimensoes(lote.getDimensoes());
            lote.setIdDimensoes(armazenagemService.getUltimaDimensao());
            lote.setEstado(3);
            lote.setIdMovimentacao(idMovimentacao);
            armazenagemService.persistLote(lote);
            armazenagemService.persistMovimentacao(lote, 0);
            
            return;
        }

        List<Lote> lotes = armazenagemService.getLotesdisponiveis(armazemId);
        if (lotes != null && lotes.size() <0) {
            for (Lote loteExistente : lotes) {
                if (armazenagemService.verificaLotesVizinhosCompativeis(armazenagemService.getLotesVizinhos(loteExistente, armazemId), produtoId)) {
                     lote.setIdMovimentacao(idMovimentacao);
                    armazenagemService.persistLote(loteExistente);
                    armazenagemService.persistMovimentacao(lote, 0);
                }
            }
        }
        else{
          if (armazenagemService.verificaCompatibilidade(armazenagemService.getUltimoLote(armazemId).getIdProduto(), produtoId)) {
          
            lote = criaNovoLote(armazem, produtoId, numeroPaletes, totalProduto);
           armazenagemService.persistDimensoes(lote.getDimensoes());
           lote.setIdDimensoes(armazenagemService.getUltimaDimensao());
           lote.setIdMovimentacao(idMovimentacao);
           armazenagemService.persistLote(lote);
           armazenagemService.persistMovimentacao(lote, 0);
          
          }else{
          
              lote = criaLoteVazio(armazem);
              armazenagemService.persistLote(lote);
              armazenagemService.persistMovimentacao(lote, 0);
         
          } 
         
        }
    }

    /**
     * retorna lista de lotes onde o produto está armazenado
     * @param produto
     * @return
     */
    public List<Lote> getLocalProdutoArmazenado(Integer produtoId) {
        return armazenagemService.getLocalProdutoArmazenado(produtoId);
    }

    /**
     * metodo de armazenamento do produto usado pelo controller
     *
     * @param produto
     * @param quantidadeTotal
     * @param quantidadePorPalete
     */
    public void armazenaProduto(Integer produtoId, double quantidadeTotal, int quantidadePorPalete, Integer IdMovimentacao) {
        Armazem armazem = verificaArmazemDisponivel(getArmazens());
        if (armazem == null) {
            return;
        }
        int numeroDePaletes = getNumeroPaletes(quantidadePorPalete, quantidadeTotal);
        System.out.println("armazem: " + armazem + "numero paletes: " + numeroDePaletes);
        armazenaProduto(armazem, produtoId, numeroDePaletes, quantidadeTotal, IdMovimentacao);
    }

    /**
     * retira a determinada quantidade do produto armazenado
     *
     * @param produto
     * @param quantidade
     * @return
     */
    public boolean retiraProtudo(Integer produtoId, int quantidade) {
        return armazenagemService.retiraProtudo(produtoId, quantidade);
    }

    /**
     * Metoto utilizado para retorno dos lotes vazios
     *
     * @param armazem
     * @return
     */
    public List<Lote> getlotesDisponiveis(Armazem armazem) {
        return armazenagemService.getLotesdisponiveis(armazem.getIdArmazem());
    }

    /**
     * Metodo retorna a quantidade total de um produto
     *
     * @param produto
     * @return
     */
    public Double getQuantidadeTotalProduto(Integer produtoId) {
        return (Double) armazenagemService.getQuantidadeTotalProduto(produtoId);
    }

    /**
     * retorna lista de armazens disponiveis
     *
     * @return
     */
    public List<Armazem> getArmazens() {
        return armazenagemService.getAllArmazens();
    }

    
    /**
     * Cria um novo Lote
     * @param armazem
     * @param produtoId
     * @param numeroPaletes
     * @param totalProduto
     * @return 
     */
    public Lote criaNovoLote(Armazem armazem, Integer produtoId, int numeroPaletes, double totalProduto) {
       
        Integer armazemId = armazem.getIdArmazem();
        Lote lote = new Lote();
        lote.setArmazem(armazem);
        lote.setDimensoes(getTamanhoNecessarioLote(armazem, numeroPaletes));
        lote.setQuantidadeProduto(totalProduto);
        lote.setIdArmazem(armazemId);
        lote.setIdProduto(produtoId);
        lote.setEstado(3);
        lote.setSequencial(armazenagemService.getProximoSequencial(armazemId).intValue() + 1);
        if (armazenagemService.verificaEspacoVazioArmazem(armazemId, "E", armazem.getDimensoes().getComprimento())) {
            lote.setLado("E");
        } else {
            lote.setLado("D");
        }

        return lote;
    }
    
    
    /**
     * Cria um lote vazio que será usado comom espaço entre produtos incompativeis
     * @param armazem
     * @return 
     */
    public Lote criaLoteVazio(Armazem armazem){
    
        Integer armazemId = armazem.getIdArmazem();
        Lote lote = new Lote();
        
        Double comprimento = lote.getComprimentoPadrao();
        Double largura = armazem.getTamanhoEspacoArmazenagem();
        Dimensoes dimensoes = new Dimensoes(comprimento, largura);       
        
        lote.setIdArmazem(armazemId);
          
        lote.setDimensoes(dimensoes);
        armazenagemService.persistDimensoes(dimensoes);
        lote.setIdDimensoes(armazenagemService.getUltimaDimensao());
               
        return lote;
    
    }

    /**
     * MMetodo verica e retorna o armazem que será utilizado
     *
     * @param armazens
     * @return
     */
    public Armazem verificaArmazemDisponivel(List<Armazem> armazens) {
        Armazem retorno = null;
        for (Armazem armazem : armazens) {
            if (armazenagemService.verificaEspacoVazioArmazem(armazem.getIdArmazem(), "E", armazem.getDimensoes().getComprimento()) || armazenagemService.verificaEspacoVazioArmazem(armazem.getIdArmazem(), "D", armazem.getDimensoes().getComprimento())) {
                return armazem;
            }
        }
        return retorno;
    }
    
    /**
     * Realiza o armazenamento no lote a partir da ultima movimentação realizada
     */
    public void insereUltimaMovimentacao(){
      Movimentacao  movimentacao = new Movimentacao();
        try {
            movimentacao = armazenagemService.getUltimaMovimentacao();
            armazenaProduto(movimentacao.getNumeroOnu(), movimentacao.getQuantidadeTotal(), movimentacao.getQuantidadePorPalete(), movimentacao.getIdMovimentacao());
            
        } catch (Exception ex) {
            Logger.getLogger(ArmazenagemUtil.class.getName()).log(Level.SEVERE, null, ex);
        }
 
    
    }
}
