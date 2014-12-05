/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package entiti;

import java.io.Serializable;
import java.math.BigInteger;
import java.util.Date;
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
import javax.persistence.TemporalType;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author sacramento
 */
@Entity
@Table(name = "det_nota")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "DetNota.findAll", query = "SELECT d FROM DetNota d"),
    @NamedQuery(name = "DetNota.findByIdDetalheNota", query = "SELECT d FROM DetNota d WHERE d.idDetalheNota = :idDetalheNota"),
    @NamedQuery(name = "DetNota.findByDtPedido", query = "SELECT d FROM DetNota d WHERE d.dtPedido = :dtPedido"),
    @NamedQuery(name = "DetNota.findByIdFornecedor", query = "SELECT d FROM DetNota d WHERE d.idFornecedor = :idFornecedor"),
    @NamedQuery(name = "DetNota.findByIdTipoEquipamento", query = "SELECT d FROM DetNota d WHERE d.idTipoEquipamento = :idTipoEquipamento"),
    @NamedQuery(name = "DetNota.findByNumNota", query = "SELECT d FROM DetNota d WHERE d.numNota = :numNota"),
    @NamedQuery(name = "DetNota.findByValorTotal", query = "SELECT d FROM DetNota d WHERE d.valorTotal = :valorTotal"),
    @NamedQuery(name = "DetNota.findByValorUnitario", query = "SELECT d FROM DetNota d WHERE d.valorUnitario = :valorUnitario")})
public class DetNota implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_detalhe_nota")
    private Integer idDetalheNota;
    @Column(name = "dt_pedido")
    @Temporal(TemporalType.DATE)
    private Date dtPedido;
    @Column(name = "id_fornecedor")
    private Integer idFornecedor;
    @Column(name = "id_tipo_equipamento")
    private Integer idTipoEquipamento;
    @Size(max = 255)
    @Column(name = "num_nota")
    private String numNota;
    @Column(name = "valor_total")
    private BigInteger valorTotal;
    @Column(name = "valor_unitario")
    private Integer valorUnitario;
    @JoinColumn(name = "fornecedor_id_fornecedor", referencedColumnName = "id_fornecedor")
    @ManyToOne
    private Fornecedor fornecedorIdFornecedor;
    @JoinColumn(name = "id_produto", referencedColumnName = "id_produto")
    @ManyToOne
    private Produto idProduto;
    @JoinColumn(name = "tipo_equipamento_id_tipo_equipamento", referencedColumnName = "id_tipo_equipamento")
    @ManyToOne
    private TipoEquipamento tipoEquipamentoIdTipoEquipamento;

    public DetNota() {
    }

    public DetNota(Integer idDetalheNota) {
        this.idDetalheNota = idDetalheNota;
    }

    public Integer getIdDetalheNota() {
        return idDetalheNota;
    }

    public void setIdDetalheNota(Integer idDetalheNota) {
        this.idDetalheNota = idDetalheNota;
    }

    public Date getDtPedido() {
        return dtPedido;
    }

    public void setDtPedido(Date dtPedido) {
        this.dtPedido = dtPedido;
    }

    public Integer getIdFornecedor() {
        return idFornecedor;
    }

    public void setIdFornecedor(Integer idFornecedor) {
        this.idFornecedor = idFornecedor;
    }

    public Integer getIdTipoEquipamento() {
        return idTipoEquipamento;
    }

    public void setIdTipoEquipamento(Integer idTipoEquipamento) {
        this.idTipoEquipamento = idTipoEquipamento;
    }

    public String getNumNota() {
        return numNota;
    }

    public void setNumNota(String numNota) {
        this.numNota = numNota;
    }

    public BigInteger getValorTotal() {
        return valorTotal;
    }

    public void setValorTotal(BigInteger valorTotal) {
        this.valorTotal = valorTotal;
    }

    public Integer getValorUnitario() {
        return valorUnitario;
    }

    public void setValorUnitario(Integer valorUnitario) {
        this.valorUnitario = valorUnitario;
    }

    public Fornecedor getFornecedorIdFornecedor() {
        return fornecedorIdFornecedor;
    }

    public void setFornecedorIdFornecedor(Fornecedor fornecedorIdFornecedor) {
        this.fornecedorIdFornecedor = fornecedorIdFornecedor;
    }

    public Produto getIdProduto() {
        return idProduto;
    }

    public void setIdProduto(Produto idProduto) {
        this.idProduto = idProduto;
    }

    public TipoEquipamento getTipoEquipamentoIdTipoEquipamento() {
        return tipoEquipamentoIdTipoEquipamento;
    }

    public void setTipoEquipamentoIdTipoEquipamento(TipoEquipamento tipoEquipamentoIdTipoEquipamento) {
        this.tipoEquipamentoIdTipoEquipamento = tipoEquipamentoIdTipoEquipamento;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idDetalheNota != null ? idDetalheNota.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof DetNota)) {
            return false;
        }
        DetNota other = (DetNota) object;
        if ((this.idDetalheNota == null && other.idDetalheNota != null) || (this.idDetalheNota != null && !this.idDetalheNota.equals(other.idDetalheNota))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.DetNota[ idDetalheNota=" + idDetalheNota + " ]";
    }
    
}
