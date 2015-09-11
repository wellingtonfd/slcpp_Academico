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
     * @param armazem
     * @param produtoId
     * @param numeroPaletes
     * @param totalProduto
     * @param idMovimentacao
     */
    public void armazenaProduto(Armazem armazem, Integer produtoId, int numeroPaletes, double totalProduto, Integer idMovimentacao) {

        try {

            Lote lote = null;
            Integer armazemId = armazem.getIdArmazem();
            boolean armazenou = false;

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
            } else {

                List<Lote> lotes = armazenagemService.getLotesdisponiveis(armazemId);
                if (lotes != null && lotes.size() > 0) {
                    for (Lote loteExistente : lotes) {
                        if (armazenagemService.verificaLotesVizinhosCompativeis(armazenagemService.getLotesVizinhos(loteExistente, armazemId), produtoId) && !armazenou) {
                            loteExistente.setIdMovimentacao(idMovimentacao);
                            loteExistente.setIdProduto(produtoId);
                            loteExistente.setNumeroPaletesArmazenados(numeroPaletes);
                            loteExistente.setQuantidadeProduto(totalProduto);
                            loteExistente.setEstado(3);
                            armazenagemService.persistLote(loteExistente);
                            armazenagemService.persistMovimentacao(loteExistente, 0);
                            armazenou = true;
                        }
                    }
                }
                if (!armazenou) {
                    if (armazenagemService.verificaCompatibilidade(armazenagemService.getUltimoLote(armazemId).getIdProduto(), produtoId)) {

                        lote = criaNovoLote(armazem, produtoId, numeroPaletes, totalProduto);
                        armazenagemService.persistDimensoes(lote.getDimensoes());
                        lote.setIdDimensoes(armazenagemService.getUltimaDimensao());
                        lote.setIdMovimentacao(idMovimentacao);
                        lote.setEstado(3);
                        armazenagemService.persistLote(lote);
                        armazenagemService.persistMovimentacao(lote, 0);

                    } else {

                        // caso do produto incompativel primerio cria um lote vazio
                        lote = criaLoteVazio(armazem);
                        armazenagemService.persistLoteVazio(lote);

                        // depois armazena o produto de forma normal
                        lote = criaNovoLote(armazem, produtoId, numeroPaletes, totalProduto);
                        armazenagemService.persistDimensoes(lote.getDimensoes());
                        lote.setIdDimensoes(armazenagemService.getUltimaDimensao());
                        lote.setIdMovimentacao(idMovimentacao);
                        armazenagemService.persistLote(lote);

                        armazenagemService.persistMovimentacao(lote, 0);
                    }
                }

            }
        } catch (Exception e) {
            e.printStackTrace();
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
        armazenaProduto(armazem, produtoId, numeroDePaletes, quantidadeTotal, IdMovimentacao);
    }

    /**
     * retira a determinada quantidade do produto armazenado
     * retorno true caso todo o produto do lote seja retirado 
     * @param produto
     * @param quantidade
     * @return
     */
    public boolean retiraProtudo(Integer produtoId, Double quantidade) {
        return armazenagemService.retiraProtudo(produtoId, quantidade);
    }

    /**
     * Metoto utilizado para retorno dos lotes vazios
     * @param armazem
     * @return
     */
    public List<Lote> getlotesDisponiveis(Armazem armazem) {
        return armazenagemService.getLotesdisponiveis(armazem.getIdArmazem());
    }

    /**
     * Metodo retorna a quantidade total de um produto
     * @param produto
     * @return
     */
    public Double getQuantidadeTotalProduto(Integer produtoId) {
        return (Double) armazenagemService.getQuantidadeTotalProduto(produtoId);
    }

    /**
     * retorna lista de armazens disponiveis
     * @return
     */
    public List<Armazem> getArmazens() {
        return armazenagemService.getAllArmazens();
    }

    /**
     * Cria um novo Lote
     *
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
     * Cria um lote vazio que será usado como espaço entre produtos
     * incompativeis
     *
     * @param armazem
     * @return
     */
    public Lote criaLoteVazio(Armazem armazem) {

        Integer armazemId = armazem.getIdArmazem();
        Lote lote = new Lote();

        Double comprimento = lote.getComprimentoPadrao();
        Double largura = armazem.getTamanhoEspacoArmazenagem();
        Dimensoes dimensoes = new Dimensoes(largura, comprimento);
        lote.setIdArmazem(armazemId);
        lote.setDimensoes(dimensoes);
        armazenagemService.persistDimensoes(dimensoes);
        lote.setIdDimensoes(armazenagemService.getUltimaDimensao());

        lote.setSequencial(armazenagemService.getProximoSequencial(armazemId).intValue() + 1);
        if (armazenagemService.verificaEspacoVazioArmazem(armazemId, "E", armazem.getDimensoes().getComprimento())) {
            lote.setLado("E");
        } else {
            lote.setLado("D");
        }

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
    public void insereUltimaMovimentacao() {
        Movimentacao movimentacao = new Movimentacao();
        try {
            movimentacao = armazenagemService.getUltimaMovimentacao();

            if (movimentacao.getTipo()== 0) { // necessario preparar a chamada anterior para carregar este parametro
                armazenaProduto(movimentacao.getNumeroOnu(), movimentacao.getQuantidadeTotal(), movimentacao.getQuantidadePorPalete(), movimentacao.getIdMovimentacao());
            } else {
                retiraProtudo(movimentacao.getNumeroOnu(), movimentacao.getQuantidadeTotal());
            }

        } catch (Exception ex) {
            Logger.getLogger(ArmazenagemUtil.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    /**
     * retorna todos os lotes de um determinado amrmazem
     */
    public List<Lote> getLotesPorArmazem(Integer armazemId) {

        return armazenagemService.getLotesPorAramazem(armazemId);
    }

    /**
     * rertona a lista de lotes onde um determinado produto está armazenado
     *
     * @param produtoId
     * @return
     */
    public List<Lote> getLotesProdutoArmazenado(Integer produtoId) {
        return armazenagemService.getLocalProdutoArmazenado(produtoId);

    }

    /**
     * verifica o estado que o lote está devidas inserçoes e retiradas VAZIO(1),
     * SEMIPREENCHIDO(2), CHEIO(3)
     *
     * @param numeroProdutos
     * @param qtdPorPalete
     * @param dimensoes
     * @return
     */
    public Integer verificaEstadolote(Integer numeroProdutos, Integer qtdPorPalete, Dimensoes dimensoes) {
        Integer estado = 0;
        return estado;
    }

    /**
     * Verifica o estado do lote VAZIO(1), SEMIPREENCHIDO(2), CHEIO(3) de acordo
     * com as dimensões do mesmo e a quantidade de paletes
     * @param numeroPaletes
     * @param dimensoes
     * @return
     */
    public Integer verificaEstadolote(Integer numeroPaletes, Dimensoes dimensoes) {

        Integer estado = 1;

        if (numeroPaletes == 0) {
            return 1;
        }

        Double comprimento = dimensoes.getComprimento();
        Double largura = dimensoes.getLargura();

        double y = largura;
        int qtdY = (int) (y / tamanhoPalete.getLargura());
        int qtdX = 1;
        while ((qtdY * qtdX) < numeroPaletes) {
            qtdX++;
        }
        Dimensoes dimensoesLote = new Dimensoes(y, qtdX * tamanhoPalete.getComprimento());

        return estado;

    }

}
