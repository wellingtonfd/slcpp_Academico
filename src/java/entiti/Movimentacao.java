/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package entiti;

import java.io.Serializable;
import java.util.Date;
import java.util.Calendar;
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
import javax.persistence.Temporal;
import javax.persistence.Transient;
import javax.xml.bind.annotation.XmlRootElement;
import org.springframework.format.annotation.DateTimeFormat;

/**
 *
 * @author sacramento
 */
@Entity
@Table(name = "movimentacao")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Movimentacao.findAll", query = "SELECT m FROM Movimentacao m"),
    @NamedQuery(name = "Movimentacao.findByIdMovimentacao", query = "SELECT m FROM Movimentacao m WHERE m.idMovimentacao = :idMovimentacao"),
    @NamedQuery(name = "Movimentacao.findByQuantidadeTotal", query = "SELECT m FROM Movimentacao m WHERE m.quantidadeTotal = :quantidadeTotal"),
    @NamedQuery(name = "Movimentacao.findByQuantitdadePorPalete", query = "SELECT m FROM Movimentacao m WHERE m.quantidadePorPalete = :quantidadePorPalete")})
public class Movimentacao implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_movimentacao")
    private Integer idMovimentacao;
    @JoinColumn(name = "id_produto", referencedColumnName = "num_onu")
    @ManyToOne
    private Produto idProduto;
    @Column(name = "qtdtotal")
    private Double quantidadeTotal;
    @Column(name = "qtdporpalete")
    private Integer quantidadePorPalete;
    @Column(name = "dt_movimentacao", updatable = false)
    @Temporal(javax.persistence.TemporalType.DATE)
    @DateTimeFormat(pattern = "dd/MM/yyyy")
    private Date dtMovimentacao = Calendar.getInstance().getTime();
    @Column(name = "referencia_lote")
    private String referencia;
    @Column(name = "tipo")
    private Integer tipo;

    @Transient
    private Integer numeroOnu;

    public Movimentacao() {
    }

    public Movimentacao(Integer idMovimentacao) {
        this.idMovimentacao = idMovimentacao;
    }

    public Integer getIdMovimentacao() {
        return idMovimentacao;
    }

    public void setIdMovimentacao(Integer idMovimentacao) {
        this.idMovimentacao = idMovimentacao;
    }

    public Produto getIdProduto() {
        return idProduto;
    }

    public void setIdProduto(Produto idProduto) {
        this.idProduto = idProduto;
        this.numeroOnu = idProduto.getNumOnu();
    }

    public Double getQuantidadeTotal() {
        return quantidadeTotal;
    }

    public void setQuantidadeTotal(Double quantidadeTotal) {
        this.quantidadeTotal = quantidadeTotal;
    }

    public Integer getQuantidadePorPalete() {
        return quantidadePorPalete;
    }

    public void setQuantidadePorPalete(Integer quantidadePorPalete) {
        this.quantidadePorPalete = quantidadePorPalete;
    }

    public Integer getNumeroOnu() {
        return numeroOnu;
    }

    public void setNumeroOnu(Integer numeroOnu) {
        this.numeroOnu = numeroOnu;
    }

    public Integer getTipo() {
        return tipo;
    }

    public void setTipo(Integer tipo) {
        this.tipo = tipo;
    }

    public Date getDtMovimentacao() {
        return dtMovimentacao;
    }

    public String getReferencia() {
        return referencia;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idMovimentacao != null ? idMovimentacao.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Movimentacao)) {
            return false;
        }
        Movimentacao other = (Movimentacao) object;
        if ((this.idMovimentacao == null && other.idMovimentacao != null) || (this.idMovimentacao != null && !this.idMovimentacao.equals(other.idMovimentacao))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.Movimentacao[ idMovimentacao=" + idMovimentacao + " quantidadePOrpalete: " + quantidadePorPalete + " total " + quantidadeTotal + " produto " + idProduto + "   ]";
    }

}
