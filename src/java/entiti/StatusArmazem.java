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
@Table(name = "status_armazem")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "StatusArmazem.findAll", query = "SELECT s FROM StatusArmazem s"),
    @NamedQuery(name = "StatusArmazem.findByIdStatusArmazem", query = "SELECT s FROM StatusArmazem s WHERE s.idStatusArmazem = :idStatusArmazem"),
    @NamedQuery(name = "StatusArmazem.findByEspecStatusArmazem", query = "SELECT s FROM StatusArmazem s WHERE s.especStatusArmazem = :especStatusArmazem"),
    @NamedQuery(name = "StatusArmazem.findByTipoStatusArmazem", query = "SELECT s FROM StatusArmazem s WHERE s.tipoStatusArmazem = :tipoStatusArmazem")})
public class StatusArmazem implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_status_armazem")
    private Integer idStatusArmazem;
    @Size(max = 255)
    @Column(name = "espec_status_armazem")
    private String especStatusArmazem;
    @Size(max = 255)
    @Column(name = "tipo_status_armazem")
    private String tipoStatusArmazem;
    @OneToMany(mappedBy = "statusArmazemIdStatusArmazem")
    private List<Armazem> armazemList;

    public StatusArmazem() {
    }

    public StatusArmazem(Integer idStatusArmazem) {
        this.idStatusArmazem = idStatusArmazem;
    }

    public Integer getIdStatusArmazem() {
        return idStatusArmazem;
    }

    public void setIdStatusArmazem(Integer idStatusArmazem) {
        this.idStatusArmazem = idStatusArmazem;
    }

    public String getEspecStatusArmazem() {
        return especStatusArmazem;
    }

    public void setEspecStatusArmazem(String especStatusArmazem) {
        this.especStatusArmazem = especStatusArmazem;
    }

    public String getTipoStatusArmazem() {
        return tipoStatusArmazem;
    }

    public void setTipoStatusArmazem(String tipoStatusArmazem) {
        this.tipoStatusArmazem = tipoStatusArmazem;
    }

    @XmlTransient
    public List<Armazem> getArmazemList() {
        return armazemList;
    }

    public void setArmazemList(List<Armazem> armazemList) {
        this.armazemList = armazemList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idStatusArmazem != null ? idStatusArmazem.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof StatusArmazem)) {
            return false;
        }
        StatusArmazem other = (StatusArmazem) object;
        if ((this.idStatusArmazem == null && other.idStatusArmazem != null) || (this.idStatusArmazem != null && !this.idStatusArmazem.equals(other.idStatusArmazem))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.StatusArmazem[ idStatusArmazem=" + idStatusArmazem + " ]";
    }
    
}
