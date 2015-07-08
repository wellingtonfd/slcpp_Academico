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
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
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
@Table(name = "epi")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Epi.findAll", query = "SELECT e FROM Epi e"),
    @NamedQuery(name = "Epi.findByIdEpi", query = "SELECT e FROM Epi e WHERE e.idEpi = :idEpi"),
    @NamedQuery(name = "Epi.findByEspecEpi", query = "SELECT e FROM Epi e WHERE e.especEpi = :especEpi"),
    @NamedQuery(name = "Epi.findByGrupoEpi", query = "SELECT e FROM Epi e WHERE e.grupoEpi = :grupoEpi"),
    @NamedQuery(name = "Epi.findByNomeEpi", query = "SELECT e FROM Epi e WHERE e.nomeEpi = :nomeEpi")})
public class Epi implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_epi")
    private Integer idEpi;
    @Size(max = 255)
    @Column(name = "espec_epi")
    private String especEpi;
    @Size(max = 255)
    @Column(name = "grupo_epi")
    private String grupoEpi;
    @Size(max = 255)
    @Column(name = "nome_epi")
    private String nomeEpi;
    @OneToMany(mappedBy = "idEpi")
    private List<TipoEquipamento> tipoEquipamentoList;
    @JoinColumn(name = "id_tipo_material", referencedColumnName = "id_tipo_material")
    @ManyToOne
    private TipoMaterial idMaterial;
    //Inserido  
    @JoinColumn(name = "id_fornecedor", referencedColumnName = "id_fornecedor")
    @ManyToOne
    private Fornecedor idFornecedor = new Fornecedor();
    
     public Fornecedor getIdFornecedor() {
        return idFornecedor;
    }

    public void setIdFornecedor(Fornecedor idFornecedor) {
        this.idFornecedor = idFornecedor;
    }
    

    public Epi() {
    }

    public Epi(Integer idEpi) {
        this.idEpi = idEpi;
    }

    public Integer getIdEpi() {
        return idEpi;
    }

    public void setIdEpi(Integer idEpi) {
        this.idEpi = idEpi;
    }

    public String getEspecEpi() {
        return especEpi;
    }

    public void setEspecEpi(String especEpi) {
        this.especEpi = especEpi;
    }

    public String getGrupoEpi() {
        return grupoEpi;
    }

    public void setGrupoEpi(String grupoEpi) {
        this.grupoEpi = grupoEpi;
    }

    public String getNomeEpi() {
        return nomeEpi;
    }

    public void setNomeEpi(String nomeEpi) {
        this.nomeEpi = nomeEpi;
    }

    @XmlTransient
    public List<TipoEquipamento> getTipoEquipamentoList() {
        return tipoEquipamentoList;
    }

    public void setTipoEquipamentoList(List<TipoEquipamento> tipoEquipamentoList) {
        this.tipoEquipamentoList = tipoEquipamentoList;
    }

    public TipoMaterial getIdMaterial() {
        return idMaterial;
    }

    public void setIdMaterial(TipoMaterial idMaterial) {
        this.idMaterial = idMaterial;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idEpi != null ? idEpi.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Epi)) {
            return false;
        }
        Epi other = (Epi) object;
        if ((this.idEpi == null && other.idEpi != null) || (this.idEpi != null && !this.idEpi.equals(other.idEpi))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.Epi[ idEpi=" + idEpi + " ]";
    }
    
}
