/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package entiti;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author wellington
 */
@Entity
@Table(name = "compatibilidade")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Compatibilidade.findAll", query = "SELECT c FROM Compatibilidade c"),
    @NamedQuery(name = "Compatibilidade.findByIdComptibilidade", query = "SELECT c FROM Compatibilidade c WHERE c.idComptibilidade = :idComptibilidade")})
public class Compatibilidade implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Column(name = "id_comptibilidade")
    private Integer idComptibilidade;
    @JoinColumn(name = "id_tipo_comp", referencedColumnName = "id_tipo_comp")
    @ManyToOne
    private TipoComp idTipoComp;
    @JoinColumn(name = "numonu", referencedColumnName = "num_onu")
    @ManyToOne
    private Produto numonu;

    public Compatibilidade() {
    }

    public Compatibilidade(Integer idComptibilidade) {
        this.idComptibilidade = idComptibilidade;
    }

    public Integer getIdComptibilidade() {
        return idComptibilidade;
    }

    public void setIdComptibilidade(Integer idComptibilidade) {
        this.idComptibilidade = idComptibilidade;
    }

    public TipoComp getIdTipoComp() {
        return idTipoComp;
    }

    public void setIdTipoComp(TipoComp idTipoComp) {
        this.idTipoComp = idTipoComp;
    }

    public Produto getNumonu() {
        return numonu;
    }

    public void setNumonu(Produto numonu) {
        this.numonu = numonu;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idComptibilidade != null ? idComptibilidade.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Compatibilidade)) {
            return false;
        }
        Compatibilidade other = (Compatibilidade) object;
        if ((this.idComptibilidade == null && other.idComptibilidade != null) || (this.idComptibilidade != null && !this.idComptibilidade.equals(other.idComptibilidade))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.Compatibilidade[ idComptibilidade=" + idComptibilidade + " ]";
    }
    
}
