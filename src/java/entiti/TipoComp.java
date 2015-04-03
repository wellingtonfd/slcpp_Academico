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
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

/**
 *
 * @author wellington
 */
@Entity
@Table(name = "tipo_comp")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "TipoComp.findAll", query = "SELECT t FROM TipoComp t"),
    @NamedQuery(name = "TipoComp.findByIdTipoComp", query = "SELECT t FROM TipoComp t WHERE t.idTipoComp = :idTipoComp")})
public class TipoComp implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Column(name = "id_tipo_comp")
    private Integer idTipoComp;
    @JoinColumn(name = "id_legenda", referencedColumnName = "id_legenda_compatibilidade")
    @ManyToOne
    private LegendaCompatibilidade idLegenda;
    @JoinColumn(name = "id_classe", referencedColumnName = "id_classe")
    @ManyToOne
    private Classe idClasse;
    @OneToMany(mappedBy = "idTipoComp")
    private List<Compatibilidade> compatibilidadeList;

    public TipoComp() {
    }

    public TipoComp(Integer idTipoComp) {
        this.idTipoComp = idTipoComp;
    }

    public Integer getIdTipoComp() {
        return idTipoComp;
    }

    public void setIdTipoComp(Integer idTipoComp) {
        this.idTipoComp = idTipoComp;
    }

    public LegendaCompatibilidade getIdLegenda() {
        return idLegenda;
    }

    public void setIdLegenda(LegendaCompatibilidade idLegenda) {
        this.idLegenda = idLegenda;
    }

    public Classe getIdClasse() {
        return idClasse;
    }

    public void setIdClasse(Classe idClasse) {
        this.idClasse = idClasse;
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
        hash += (idTipoComp != null ? idTipoComp.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof TipoComp)) {
            return false;
        }
        TipoComp other = (TipoComp) object;
        if ((this.idTipoComp == null && other.idTipoComp != null) || (this.idTipoComp != null && !this.idTipoComp.equals(other.idTipoComp))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.TipoComp[ idTipoComp=" + idTipoComp + " ]";
    }
    
}
