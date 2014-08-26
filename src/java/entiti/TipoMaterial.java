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
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Administrador
 * @author Wellington Duarte
 */
@Entity
@Table(name = "tipo_material")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "TipoMaterial.findAll", query = "SELECT t FROM TipoMaterial t"),
    @NamedQuery(name = "TipoMaterial.findByIdTipoMaterial", query = "SELECT t FROM TipoMaterial t WHERE t.idTipoMaterial = :idTipoMaterial"),
    @NamedQuery(name = "TipoMaterial.findByNomeMaterial", query = "SELECT t FROM TipoMaterial t WHERE t.nomeMaterial = :nomeMaterial"),
    @NamedQuery(name = "TipoMaterial.findByEspecMaterial", query = "SELECT t FROM TipoMaterial t WHERE t.especMaterial = :especMaterial")})
public class TipoMaterial implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_tipo_material")
    private Integer idTipoMaterial;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 45)
    @Column(name = "nome_material")
    private String nomeMaterial;
    @Size(max = 60)
    @Column(name = "espec_material")
    private String especMaterial;

    public TipoMaterial() {
    }

    public TipoMaterial(Integer idTipoMaterial) {
        this.idTipoMaterial = idTipoMaterial;
    }

    public TipoMaterial(Integer idTipoMaterial, String nomeMaterial) {
        this.idTipoMaterial = idTipoMaterial;
        this.nomeMaterial = nomeMaterial;
    }

    public Integer getIdTipoMaterial() {
        return idTipoMaterial;
    }

    public void setIdTipoMaterial(Integer idTipoMaterial) {
        this.idTipoMaterial = idTipoMaterial;
    }

    public String getNomeMaterial() {
        return nomeMaterial;
    }

    public void setNomeMaterial(String nomeMaterial) {
        this.nomeMaterial = nomeMaterial;
    }

    public String getEspecMaterial() {
        return especMaterial;
    }

    public void setEspecMaterial(String especMaterial) {
        this.especMaterial = especMaterial;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idTipoMaterial != null ? idTipoMaterial.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof TipoMaterial)) {
            return false;
        }
        TipoMaterial other = (TipoMaterial) object;
        if ((this.idTipoMaterial == null && other.idTipoMaterial != null) || (this.idTipoMaterial != null && !this.idTipoMaterial.equals(other.idTipoMaterial))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.TipoMaterial[ idTipoMaterial=" + idTipoMaterial + " ]";
    }

}
