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
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author sacramento
 */
@Entity
@Table(name = "end_armazem")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "EndArmazem.findAll", query = "SELECT e FROM EndArmazem e"),
    @NamedQuery(name = "EndArmazem.findByIdEndarmazem", query = "SELECT e FROM EndArmazem e WHERE e.idEndarmazem = :idEndarmazem"),
    @NamedQuery(name = "EndArmazem.findByRuaEndArmazem", query = "SELECT e FROM EndArmazem e WHERE e.ruaEndArmazem = :ruaEndArmazem"),
    @NamedQuery(name = "EndArmazem.findByEstatos", query = "SELECT e FROM EndArmazem e WHERE e.estatos = :estatos")})
public class EndArmazem implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_endarmazem")
    private Integer idEndarmazem;
    @Size(max = 255)
    @Column(name = "rua_end_armazem")
    private String ruaEndArmazem;
    @Column(name = "estatos")
    private Boolean estatos;

    public EndArmazem() {
    }

    public EndArmazem(Integer idEndarmazem) {
        this.idEndarmazem = idEndarmazem;
    }

    public Integer getIdEndarmazem() {
        return idEndarmazem;
    }

    public void setIdEndarmazem(Integer idEndarmazem) {
        this.idEndarmazem = idEndarmazem;
    }

    public String getRuaEndArmazem() {
        return ruaEndArmazem;
    }

    public void setRuaEndArmazem(String ruaEndArmazem) {
        this.ruaEndArmazem = ruaEndArmazem;
    }

    public Boolean getEstatos() {
        return estatos;
    }

    public void setEstatos(Boolean estatos) {
        this.estatos = estatos;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idEndarmazem != null ? idEndarmazem.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof EndArmazem)) {
            return false;
        }
        EndArmazem other = (EndArmazem) object;
        if ((this.idEndarmazem == null && other.idEndarmazem != null) || (this.idEndarmazem != null && !this.idEndarmazem.equals(other.idEndarmazem))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.EndArmazem[ idEndarmazem=" + idEndarmazem + " ]";
    }

    
}
