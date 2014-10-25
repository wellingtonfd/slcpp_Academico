/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package entiti;

import java.io.Serializable;
import java.util.List;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

/**
 *
 * @author sacramento
 */
@Entity
@Table(name = "legenda_compatibilidade")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "LegendaCompatibilidade.findAll", query = "SELECT l FROM LegendaCompatibilidade l"),
    @NamedQuery(name = "LegendaCompatibilidade.findByIdLegendaCompatibilidade", query = "SELECT l FROM LegendaCompatibilidade l WHERE l.idLegendaCompatibilidade = :idLegendaCompatibilidade"),
    @NamedQuery(name = "LegendaCompatibilidade.findByEspecLegenda", query = "SELECT l FROM LegendaCompatibilidade l WHERE l.especLegenda = :especLegenda"),
    @NamedQuery(name = "LegendaCompatibilidade.findByLegenda", query = "SELECT l FROM LegendaCompatibilidade l WHERE l.legenda = :legenda")})
public class LegendaCompatibilidade implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_legenda_compatibilidade")
    private Integer idLegendaCompatibilidade;
    @Size(max = 255)
    @Column(name = "espec_legenda")
    private String especLegenda;
    @Size(max = 255)
    @Column(name = "legenda")
    private String legenda;
    @OneToMany(mappedBy = "idLegendaCompatibilidade")
    private List<Produto> produtoList;
    @OneToMany(mappedBy = "idLegendaCompatibilidade")
    private List<Compatibilidade> compatibilidadeList;

    public LegendaCompatibilidade() {
    }

    public LegendaCompatibilidade(Integer idLegendaCompatibilidade) {
        this.idLegendaCompatibilidade = idLegendaCompatibilidade;
    }

    public Integer getIdLegendaCompatibilidade() {
        return idLegendaCompatibilidade;
    }

    public void setIdLegendaCompatibilidade(Integer idLegendaCompatibilidade) {
        this.idLegendaCompatibilidade = idLegendaCompatibilidade;
    }

    public String getEspecLegenda() {
        return especLegenda;
    }

    public void setEspecLegenda(String especLegenda) {
        this.especLegenda = especLegenda;
    }

    public String getLegenda() {
        return legenda;
    }

    public void setLegenda(String legenda) {
        this.legenda = legenda;
    }

    @XmlTransient
    public List<Produto> getProdutoList() {
        return produtoList;
    }

    public void setProdutoList(List<Produto> produtoList) {
        this.produtoList = produtoList;
    }

    @XmlTransient
    public List<Compatibilidade> getCompatibilidadeList() {
        return compatibilidadeList;
    }

    public void setCompatibilidadeList(List<Compatibilidade> compatibilidadeList) {
        this.compatibilidadeList = compatibilidadeList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idLegendaCompatibilidade != null ? idLegendaCompatibilidade.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof LegendaCompatibilidade)) {
            return false;
        }
        LegendaCompatibilidade other = (LegendaCompatibilidade) object;
        if ((this.idLegendaCompatibilidade == null && other.idLegendaCompatibilidade != null) || (this.idLegendaCompatibilidade != null && !this.idLegendaCompatibilidade.equals(other.idLegendaCompatibilidade))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.LegendaCompatibilidade[ idLegendaCompatibilidade=" + idLegendaCompatibilidade + " ]";
    }
    
}
