/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package entiti;

import static entiti.Lote.EstadoArmazenagem;
import java.io.Serializable;
import java.util.Objects;
import java.util.logging.Logger;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Transient;

/**
 *
 * classe lote representa o espaço ocupado pelo produto
 * armazenado todo armazem será dividido em lotes; O endereço do lote é definido
 * de acordo com o armazem que ele está locado, o lado do armazem onde ele está,
 * Esquerda ou Direita e o sequencial para indicar a posição onde o lote esta
 * naquela Rua do Armazem
 */
@Entity
@Table(name = "lote")
@NamedQueries({
    @NamedQuery(name = "Lote.findAll", query = "SELECT l FROM Lote l"),
    @NamedQuery(name = "Lote.findByIdLote", query = "SELECT l FROM Lote l WHERE l.idLote = :idLote"),
    @NamedQuery(name = "Lote.findByLado", query = "SELECT l FROM Lote l WHERE l.lado = :lado"),
    @NamedQuery(name = "Lote.findBySequencial", query = "SELECT l FROM Lote l WHERE l.sequencial = :sequencial"),
    @NamedQuery(name = "Lote.findByQuantidadeProduto", query = "SELECT l FROM Lote l WHERE l.quantidadeProduto = :quantidadeProduto"),
    @NamedQuery(name = "Lote.findByNumeroPaletesArmazenados", query = "SELECT l FROM Lote l WHERE l.numeroPaletesArmazenados = :numeroPaletesArmazenados"),
    @NamedQuery(name = "Lote.findLoteVazio", query = "SELECT l FROM Lote l WHERE l.estadoArmazenagem = :estadoArmazenagem"  ),
    @NamedQuery(name = "Lote.findByProduto", query = "SELECT l FROM Lote l WHERE l.produto = :produto"),
    @NamedQuery(name = "Lote.findByEndereco", query = "SELECT l FROM Lote l WHERE l.sequencial = :sequencial and l.lado = :lado"),
    @NamedQuery(name = "Lote.findByArmazem", query = "SELECT l FROM Lote l WHERE l.armazem = :armazem")})
public class Lote implements Serializable {

    
      /**
     * Enum para representar o estado do lote
     */
    public static enum EstadoArmazenagem {

        VAZIO(1), SEMIPREENCHIDO(2), CHEIO(3);
        public  int codigo;

        EstadoArmazenagem(int codigo) {
            this.codigo = codigo;
        }

        int codigo() {
            return codigo;
        }

        public static EstadoArmazenagem porCodigo(int codigo) {
            for (EstadoArmazenagem estado : EstadoArmazenagem.values()) {
                if (codigo == estado.codigo()) {
                    return estado;
                }
            }
            throw new IllegalArgumentException("codigo invalido");
        }

    }
    
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_lote")
    private Integer idLote;
    @Column(name = "numero_paletes_armazenados")
    private int numeroPaletesArmazenados;
    @Column(name = "lado")
    private String lado;
    @Column(name = "sequencial")
    private int sequencial;    // Sequencial que identifica a posição do lote no armazem
    @Column(name = "quantidade_produtos")
    private double quantidadeProduto; // quantidade de um produto para necessidade de retiradas parciais
    @JoinColumn(name = "id_armazem", referencedColumnName = "id_armazem")
    @ManyToOne
    private Armazem armazem;
    @JoinColumn(name = "fk_id_dimensoes", referencedColumnName = "id_dimensoes")
    @ManyToOne
    private Dimensoes dimensoes;
    @JoinColumn(name = "num_onu", referencedColumnName = "num_onu")
    @ManyToOne
    private Produto produto;
    //Comprimento padrão para o caso onde é necessário criar o lote vazio
    double comprimentoPadrao = 4.0;
   
    
   @Transient
   private Integer IdArmazem;
   
   @Transient
   private Integer IdDimensoes;
   
   @Transient
   private Integer IdProduto;

   @Transient 
   private Integer estado;
 
    
    EstadoArmazenagem estadoArmazenagem = EstadoArmazenagem.VAZIO;
        
    public Lote(Dimensoes dimensoes) {

        this.dimensoes = dimensoes;
    }

    public Lote() {

        Dimensoes dim = new Dimensoes(comprimentoPadrao, 0);
        this.dimensoes = dim;
    }

    private static final Logger LOG = Logger.getLogger(Lote.class.getName());

    public Integer getIdLote() {
        return idLote;
    }

    public void setIdLote(Integer idLote) {
        this.idLote = idLote;
    }

    public Dimensoes getDimensoes() {
        return dimensoes;
    }

    public void setDimensoes(Dimensoes dimensoes) {
        this.dimensoes = dimensoes;
    }

    public Produto getProduto() {
        return produto;
    }

    public void setProduto(Produto produto) {
        this.produto = produto;
    }

    public int getNumeroPaletesArmazenados() {
        return numeroPaletesArmazenados;
    }

    public void setNumeroPaletesArmazenados(int numeroPaletesArmazenados) {
        this.numeroPaletesArmazenados = numeroPaletesArmazenados;
    }

    public double getComprimentoPadrao() {
        return comprimentoPadrao;
    }

    public void setComprimentoPadrao(double comprimentoPadrao) {
        this.comprimentoPadrao = comprimentoPadrao;
    }

    public String getLado() {
        return lado;
    }

    public void setLado(String lado) {
        this.lado = lado;
    }

    public int getSequencial() {
        return sequencial;
    }

    public void setSequencial(int sequencial) {
        this.sequencial = sequencial;
    }

    public double getQuantidadeProduto() {
        return quantidadeProduto;
    }

    public void setQuantidadeProduto(double quantidadeProduto) {
        this.quantidadeProduto = quantidadeProduto;
    }

    public Armazem getArmazem() {
        return armazem;
    }

    public void setArmazem(Armazem armazem) {
        this.armazem = armazem;
    }

    public EstadoArmazenagem getEstadoArmazenamento() {
        return estadoArmazenagem;
    }

    public void setEstadoArmazenamento(EstadoArmazenagem estadoArmazenamento) {
        this.estadoArmazenagem = estadoArmazenamento;
    }

    public Integer getIdArmazem() {
        return IdArmazem;
    }

    public void setIdArmazem(Integer IdArmazem) {
        this.IdArmazem = IdArmazem;
    }

    public Integer getIdDimensoes() {
        return IdDimensoes;
    }

    public void setIdDimensoes(Integer IdDimensoes) {
        this.IdDimensoes = IdDimensoes;
    }

    public Integer getIdProduto() {
        return IdProduto;
    }

    public void setIdProduto(Integer IdProduto) {
        this.IdProduto = IdProduto;
    }

    public Integer getEstado() {
        return estado;
    }

    public void setEstado(Integer estado) {
        this.estado = estado;
    }
    
    
    
    @Override
    public int hashCode() {
        int hash = 5;
        hash = 67 * hash + Objects.hashCode(this.produto);
        hash = 67 * hash + Objects.hashCode(this.lado);
        hash = 67 * hash + this.sequencial;
        hash = 67 * hash + Objects.hashCode(this.armazem);
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Lote other = (Lote) obj;
        return true;
    }

}
