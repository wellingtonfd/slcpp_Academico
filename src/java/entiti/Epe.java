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
@Table(name = "epe")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Epe.findAll", query = "SELECT e FROM Epe e"),
    @NamedQuery(name = "Epe.findByIdEpe", query = "SELECT e FROM Epe e WHERE e.idEpe = :idEpe"),
    @NamedQuery(name = "Epe.findByAgenteEpe", query = "SELECT e FROM Epe e WHERE e.agenteEpe = :agenteEpe"),
    @NamedQuery(name = "Epe.findByClasseEpe", query = "SELECT e FROM Epe e WHERE e.classeEpe = :classeEpe"),
    @NamedQuery(name = "Epe.findByNomeEpe", query = "SELECT e FROM Epe e WHERE e.nomeEpe = :nomeEpe") })
public class Epe implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_epe")
    private Integer idEpe;
    @Size(max = 255)
    @Column(name = "agente_epe")
    private String agenteEpe;
    @Size(max = 255)
    @Column(name = "classe_epe")
    private String classeEpe;
    @Size(max = 255)
    @Column(name = "nome_epe")
    private String nomeEpe;
    @OneToMany(mappedBy = "epeIdEpe")
    private List<TipoEquipamento> tipoEquipamentoList;
    //Inserido  
    @JoinColumn(name = "id_fornecedor", referencedColumnName = "id_fornecedor")
    @ManyToOne
    private Fornecedor idFornecedor = new Fornecedor();
    @JoinColumn(name = "id_tipo_material", referencedColumnName = "id_tipo_material")
    @ManyToOne
    private TipoMaterial idTipoMaterial = new TipoMaterial();

    public Epe() {
    }

    public Epe(Integer idEpe) {
        this.idEpe = idEpe;
    }
    
      public TipoMaterial getIdTipoMaterial() {
        return idTipoMaterial;
    }

    public void setIdTipoMaterial(TipoMaterial idTipoMaterial) {
        this.idTipoMaterial = idTipoMaterial;
    }
    
    public Fornecedor getIdFornecedor() {
        return idFornecedor;
    }

    public void setIdFornecedor(Fornecedor idFornecedor) {
        this.idFornecedor = idFornecedor;
    }

    public Integer getIdEpe() {
        return idEpe;
    }

    public void setIdEpe(Integer idEpe) {
        this.idEpe = idEpe;
    }

    public String getAgenteEpe() {
        return agenteEpe;
    }

    public void setAgenteEpe(String agenteEpe) {
        this.agenteEpe = agenteEpe;
    }

    public String getClasseEpe() {
        return classeEpe;
    }

    public void setClasseEpe(String classeEpe) {
        this.classeEpe = classeEpe;
    }

    public String getNomeEpe() {
        return nomeEpe;
    }

    public void setNomeEpe(String nomeEpe) {
        this.nomeEpe = nomeEpe;
    }

    @XmlTransient
    public List<TipoEquipamento> getTipoEquipamentoList() {
        return tipoEquipamentoList;
    }

    public void setTipoEquipamentoList(List<TipoEquipamento> tipoEquipamentoList) {
        this.tipoEquipamentoList = tipoEquipamentoList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idEpe != null ? idEpe.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Epe)) {
            return false;
        }
        Epe other = (Epe) object;
        if ((this.idEpe == null && other.idEpe != null) || (this.idEpe != null && !this.idEpe.equals(other.idEpe))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.Epe[ idEpe=" + idEpe + " ]";
    }
    
}
