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
@Table(name = "veiculo")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Veiculo.findAll", query = "SELECT v FROM Veiculo v"),
    @NamedQuery(name = "Veiculo.findByIdVeiculo", query = "SELECT v FROM Veiculo v WHERE v.idVeiculo = :idVeiculo"),
    @NamedQuery(name = "Veiculo.findByAnoVeiculo", query = "SELECT v FROM Veiculo v WHERE v.anoVeiculo = :anoVeiculo"),
    @NamedQuery(name = "Veiculo.findByChassiVeiculo", query = "SELECT v FROM Veiculo v WHERE v.chassiVeiculo = :chassiVeiculo"),
    @NamedQuery(name = "Veiculo.findByCorVeiculo", query = "SELECT v FROM Veiculo v WHERE v.corVeiculo = :corVeiculo"),
    @NamedQuery(name = "Veiculo.findByFabricanteVeiculo", query = "SELECT v FROM Veiculo v WHERE v.fabricanteVeiculo = :fabricanteVeiculo"),
    @NamedQuery(name = "Veiculo.findByModeloVeiculo", query = "SELECT v FROM Veiculo v WHERE v.modeloVeiculo = :modeloVeiculo"),
    @NamedQuery(name = "Veiculo.findByNomeVeiculo", query = "SELECT v FROM Veiculo v WHERE v.nomeVeiculo = :nomeVeiculo"),
    @NamedQuery(name = "Veiculo.findByPlacaVeiculo", query = "SELECT v FROM Veiculo v WHERE v.placaVeiculo = :placaVeiculo")})
public class Veiculo implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_veiculo")
    private Integer idVeiculo;
    @Size(max = 255)
    @Column(name = "ano_veiculo")
    private String anoVeiculo;
    @Size(max = 255)
    @Column(name = "chassi_veiculo")
    private String chassiVeiculo;
    @Size(max = 255)
    @Column(name = "cor_veiculo")
    private String corVeiculo;
    @Size(max = 255)
    @Column(name = "fabricante_veiculo")
    private String fabricanteVeiculo;
    @Size(max = 255)
    @Column(name = "modelo_veiculo")
    private String modeloVeiculo;
    @Size(max = 255)
    @Column(name = "nome_veiculo")
    private String nomeVeiculo;
    @Size(max = 255)
    @Column(name = "placa_veiculo")
    private String placaVeiculo;
    @JoinColumn(name = "id_combustivel", referencedColumnName = "id_combustivel")
    @ManyToOne
    private Combustivel idCombustivel;
    @OneToMany(mappedBy = "idVeiculo")
    private List<TipoEquipamento> tipoEquipamentoList;

    public Veiculo() {
    }

    public Veiculo(Integer idVeiculo) {
        this.idVeiculo = idVeiculo;
    }

    public Integer getIdVeiculo() {
        return idVeiculo;
    }

    public void setIdVeiculo(Integer idVeiculo) {
        this.idVeiculo = idVeiculo;
    }

    public String getAnoVeiculo() {
        return anoVeiculo;
    }

    public void setAnoVeiculo(String anoVeiculo) {
        this.anoVeiculo = anoVeiculo;
    }

    public String getChassiVeiculo() {
        return chassiVeiculo;
    }

    public void setChassiVeiculo(String chassiVeiculo) {
        this.chassiVeiculo = chassiVeiculo;
    }

    public String getCorVeiculo() {
        return corVeiculo;
    }

    public void setCorVeiculo(String corVeiculo) {
        this.corVeiculo = corVeiculo;
    }

    public String getFabricanteVeiculo() {
        return fabricanteVeiculo;
    }

    public void setFabricanteVeiculo(String fabricanteVeiculo) {
        this.fabricanteVeiculo = fabricanteVeiculo;
    }

    public String getModeloVeiculo() {
        return modeloVeiculo;
    }

    public void setModeloVeiculo(String modeloVeiculo) {
        this.modeloVeiculo = modeloVeiculo;
    }

    public String getNomeVeiculo() {
        return nomeVeiculo;
    }

    public void setNomeVeiculo(String nomeVeiculo) {
        this.nomeVeiculo = nomeVeiculo;
    }

    public String getPlacaVeiculo() {
        return placaVeiculo;
    }

    public void setPlacaVeiculo(String placaVeiculo) {
        this.placaVeiculo = placaVeiculo;
    }

    public Combustivel getIdCombustivel() {
        return idCombustivel;
    }

    public void setIdCombustivel(Combustivel idCombustivel) {
        this.idCombustivel = idCombustivel;
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
        hash += (idVeiculo != null ? idVeiculo.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Veiculo)) {
            return false;
        }
        Veiculo other = (Veiculo) object;
        if ((this.idVeiculo == null && other.idVeiculo != null) || (this.idVeiculo != null && !this.idVeiculo.equals(other.idVeiculo))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.Veiculo[ idVeiculo=" + idVeiculo + " ]";
    }
    
}
