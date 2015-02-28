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
 * @author wellington
 */
@Entity
@Table(name = "legenda_compatibilidade")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "LegendaCompatibilidade.findAll", query = "SELECT l FROM LegendaCompatibilidade l"),
    @NamedQuery(name = "LegendaCompatibilidade.findByIdLegendaCompatibilidade", query = "SELECT l FROM LegendaCompatibilidade l WHERE l.idLegendaCompatibilidade = :idLegendaCompatibilidade"),
    @NamedQuery(name = "LegendaCompatibilidade.findByLegenda", query = "SELECT l FROM LegendaCompatibilidade l WHERE l.legenda = :legenda"),
    @NamedQuery(name = "LegendaCompatibilidade.findByDescLegenda", query = "SELECT l FROM LegendaCompatibilidade l WHERE l.descLegenda = :descLegenda")})
public class LegendaCompatibilidade implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_legenda_compatibilidade")
    private Integer idLegendaCompatibilidade;
    @Size(max = 10)
    @Column(name = "legenda")
    private String legenda;
    @Size(max = 150)
    @Column(name = "desc_legenda")
    private String descLegenda;
    @OneToMany(mappedBy = "idLegenda")
    private List<TipoComp> tipoCompList;

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

    public String getLegenda() {
        return legenda;
    }

    public void setLegenda(String legenda) {
        this.legenda = legenda;
    }

    public String getDescLegenda() {
        return descLegenda;
    }

    public void setDescLegenda(String descLegenda) {
        this.descLegenda = descLegenda;
    }

    @XmlTransient
    public List<TipoComp> getTipoCompList() {
        return tipoCompList;
    }

    public void setTipoCompList(List<TipoComp> tipoCompList) {
        this.tipoCompList = tipoCompList;
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
