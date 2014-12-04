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
 * @author Administrador
 * @author Wellington Duarte
 */
@Entity
@Table(name = "tipo_equipamento")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "TipoEquipamento.findAll", query = "SELECT t FROM TipoEquipamento t"),
    @NamedQuery(name = "TipoEquipamento.findByIdTipoEquipamento", query = "SELECT t FROM TipoEquipamento t WHERE t.idTipoEquipamento = :idTipoEquipamento"),
    @NamedQuery(name = "TipoEquipamento.findByEspcTipoEquipamento", query = "SELECT t FROM TipoEquipamento t WHERE t.espcTipoEquipamento = :espcTipoEquipamento"),
    @NamedQuery(name = "TipoEquipamento.findByIdEmbalagem", query = "SELECT t FROM TipoEquipamento t WHERE t.idEmbalagem = :idEmbalagem"),
    @NamedQuery(name = "TipoEquipamento.findByIdEpe", query = "SELECT t FROM TipoEquipamento t WHERE t.idEpe = :idEpe"),
    @NamedQuery(name = "TipoEquipamento.findByNomeTipoEquipamento", query = "SELECT t FROM TipoEquipamento t WHERE t.nomeTipoEquipamento = :nomeTipoEquipamento")})
public class TipoEquipamento implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_tipo_equipamento")
    private Integer idTipoEquipamento;
    @Size(max = 255)
    @Column(name = "espc_tipo_equipamento")
    private String espcTipoEquipamento;
    @Column(name = "id_embalagem")
    private Integer idEmbalagem;
    @Column(name = "id_epe")
    private Integer idEpe;
    @Size(max = 255)
    @Column(name = "nome_tipo_equipamento")
    private String nomeTipoEquipamento;
    @JoinColumn(name = "id_veiculo", referencedColumnName = "id_veiculo")
    @ManyToOne
    private Veiculo idVeiculo;
    @JoinColumn(name = "id_epi", referencedColumnName = "id_epi")
    @ManyToOne
    private Epi idEpi;
    @JoinColumn(name = "epe_id_epe", referencedColumnName = "id_epe")
    @ManyToOne
    private Epe epeIdEpe;
    @OneToMany(mappedBy = "tipoEquipamentoIdTipoEquipamento")
    private List<DetNota> detNotaList;

    public TipoEquipamento() {
    }

    public TipoEquipamento(Integer idTipoEquipamento) {
        this.idTipoEquipamento = idTipoEquipamento;
    }

    public Integer getIdTipoEquipamento() {
        return idTipoEquipamento;
    }

    public void setIdTipoEquipamento(Integer idTipoEquipamento) {
        this.idTipoEquipamento = idTipoEquipamento;
    }

    public String getEspcTipoEquipamento() {
        return espcTipoEquipamento;
    }

    public void setEspcTipoEquipamento(String espcTipoEquipamento) {
        this.espcTipoEquipamento = espcTipoEquipamento;
    }

    public Integer getIdEmbalagem() {
        return idEmbalagem;
    }

    public void setIdEmbalagem(Integer idEmbalagem) {
        this.idEmbalagem = idEmbalagem;
    }

    public Integer getIdEpe() {
        return idEpe;
    }

    public void setIdEpe(Integer idEpe) {
        this.idEpe = idEpe;
    }

    public String getNomeTipoEquipamento() {
        return nomeTipoEquipamento;
    }

    public void setNomeTipoEquipamento(String nomeTipoEquipamento) {
        this.nomeTipoEquipamento = nomeTipoEquipamento;
    }

    public Veiculo getIdVeiculo() {
        return idVeiculo;
    }

    public void setIdVeiculo(Veiculo idVeiculo) {
        this.idVeiculo = idVeiculo;
    }

    public Epi getIdEpi() {
        return idEpi;
    }

    public void setIdEpi(Epi idEpi) {
        this.idEpi = idEpi;
    }

    public Epe getEpeIdEpe() {
        return epeIdEpe;
    }

    public void setEpeIdEpe(Epe epeIdEpe) {
        this.epeIdEpe = epeIdEpe;
    }

    @XmlTransient
    public List<DetNota> getDetNotaList() {
        return detNotaList;
    }

    public void setDetNotaList(List<DetNota> detNotaList) {
        this.detNotaList = detNotaList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idTipoEquipamento != null ? idTipoEquipamento.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof TipoEquipamento)) {
            return false;
        }
        TipoEquipamento other = (TipoEquipamento) object;
        if ((this.idTipoEquipamento == null && other.idTipoEquipamento != null) || (this.idTipoEquipamento != null && !this.idTipoEquipamento.equals(other.idTipoEquipamento))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.TipoEquipamento[ idTipoEquipamento=" + idTipoEquipamento + " ]";
    }

}
