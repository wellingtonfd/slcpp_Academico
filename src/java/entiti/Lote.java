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
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToOne;
import javax.persistence.Table;

/**
 *
 * @author Gustavo
 * classe lote representa o espaço ocupado pelo produto armazenado
 * todo armazem será dividido em lotes; 
 * O endereço do lote é definido de acordo com o armazem 
 * que ele está locado, o lado do armazem onde ele está, Esquerda ou Direita
 * e o sequencial para indicar a posição onde o lote esta naquela Rua do Armazem
  */
 @Entity
    @Table(name = "lote")
    @NamedQueries({
    @NamedQuery(name = "Lote.findAll", query = "SELECT a FROM Lote a")})

 public class Lote implements Serializable {
    
         
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_lote")
    private Integer idLote;
    
    
    //Comprimento padrão para o caso onde é necessário criar o lote vazio
    double comprimentoPadrao = 4.0;
    
    //TODO mapeamento do banco
  
    /**
     * Enum para representar o estado do lote
     */
    public static enum EstadoArmazenagem {
 
      VAZIO(1), SEMIPREENCHIDO(2), CHEIO(3);
      private final int codigo;

    EstadoArmazenagem(int codigo) { this.codigo = codigo; }

    int codigo() { return codigo; }

    public static EstadoArmazenagem porCodigo(int codigo) {
        for (EstadoArmazenagem estado: EstadoArmazenagem.values()) {
            if (codigo == estado.codigo()) return estado;
        }
        throw new IllegalArgumentException("codigo invalido");
    }
     
 }
  
    @OneToOne
    private Dimensoes dimensoes;
    
    private Produto produto;

    private int numeroPaletesArmazenados;
    
    // D para direta do armazem; E para esquerda do armazem
    private String lado;
    
    // Sequencial que identifica a posição do lote no armazem
    private int sequencial;
    
    
    // quantidade de um produto para necessidade de retiradas parciais
    private double quantidadeProduto;
    
    private Armazem armazem;
    
    
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
