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
@Table(name = "armazem")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Armazem.findAll", query = "SELECT a FROM Armazem a"),
    @NamedQuery(name = "Armazem.findByIdArmazem", query = "SELECT a FROM Armazem a WHERE a.idArmazem = :idArmazem"),
    @NamedQuery(name = "Armazem.findByCapacidadeArmazem", query = "SELECT a FROM Armazem a WHERE a.capacidadeArmazem = :capacidadeArmazem"),
    @NamedQuery(name = "Armazem.findByCertificacaoArmazem", query = "SELECT a FROM Armazem a WHERE a.certificacaoArmazem = :certificacaoArmazem"),
    @NamedQuery(name = "Armazem.findByEspecArmazem", query = "SELECT a FROM Armazem a WHERE a.especArmazem = :especArmazem"),
    @NamedQuery(name = "Armazem.findByEstoqueMax", query = "SELECT a FROM Armazem a WHERE a.estoqueMax = :estoqueMax"),
    @NamedQuery(name = "Armazem.findByEstoqueMin", query = "SELECT a FROM Armazem a WHERE a.estoqueMin = :estoqueMin"),
    @NamedQuery(name = "Armazem.findByIdLocalOper", query = "SELECT a FROM Armazem a WHERE a.idLocalOper = :idLocalOper"),
    @NamedQuery(name = "Armazem.findByTipoArmazem", query = "SELECT a FROM Armazem a WHERE a.tipoArmazem = :tipoArmazem")})
public class Armazem implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_armazem")
    private Integer idArmazem;
    @Size(max = 255)
    @Column(name = "capacidade_armazem")
    private String capacidadeArmazem;
    @Size(max = 255)
    @Column(name = "certificacao_armazem")
    private String certificacaoArmazem;
    @Size(max = 255)
    @Column(name = "espec_armazem")
    private String especArmazem;
    @Size(max = 255)
    @Column(name = "estoque_max")
    private String estoqueMax;
    @Size(max = 255)
    @Column(name = "estoque_min")
    private String estoqueMin;
    @Column(name = "id_local_oper")
    private Integer idLocalOper;
    @Size(max = 255)
    @Column(name = "tipo_armazem")
    private String tipoArmazem;
    @JoinColumn(name = "id_compatibilidade", referencedColumnName = "id_compatibilidade")
    @ManyToOne
    private Compatibilidade idCompatibilidade;
    @JoinColumn(name = "id_endarmazem", referencedColumnName = "id_endarmazem")
    @ManyToOne
    private EndArmazem idEndarmazem;
    @JoinColumn(name = "local_operacao_id_local_oper", referencedColumnName = "id_local_oper")
    @ManyToOne
    private LocalOperacao localOperacaoIdLocalOper;
    @JoinColumn(name = "id_status_armazem", referencedColumnName = "id_status_armazem")
    @ManyToOne
    private StatusArmazem idStatusArmazem;
    @JoinColumn(name = "status_armazem_id_status_armazem", referencedColumnName = "id_status_armazem")
    @ManyToOne
    private StatusArmazem statusArmazemIdStatusArmazem;
    

    public Armazem() {
    }

    public Armazem(Integer idArmazem) {
        this.idArmazem = idArmazem;
    }

    public Integer getIdArmazem() {
        return idArmazem;
    }

    public void setIdArmazem(Integer idArmazem) {
        this.idArmazem = idArmazem;
    }

    public String getCapacidadeArmazem() {
        return capacidadeArmazem;
    }

    public void setCapacidadeArmazem(String capacidadeArmazem) {
        this.capacidadeArmazem = capacidadeArmazem;
    }

    public String getCertificacaoArmazem() {
        return certificacaoArmazem;
    }

    public void setCertificacaoArmazem(String certificacaoArmazem) {
        this.certificacaoArmazem = certificacaoArmazem;
    }

    public String getEspecArmazem() {
        return especArmazem;
    }

    public void setEspecArmazem(String especArmazem) {
        this.especArmazem = especArmazem;
    }

    public String getEstoqueMax() {
        return estoqueMax;
    }

    public void setEstoqueMax(String estoqueMax) {
        this.estoqueMax = estoqueMax;
    }

    public String getEstoqueMin() {
        return estoqueMin;
    }

    public void setEstoqueMin(String estoqueMin) {
        this.estoqueMin = estoqueMin;
    }

    public Integer getIdLocalOper() {
        return idLocalOper;
    }

    public void setIdLocalOper(Integer idLocalOper) {
        this.idLocalOper = idLocalOper;
    }

    public String getTipoArmazem() {
        return tipoArmazem;
    }

    public void setTipoArmazem(String tipoArmazem) {
        this.tipoArmazem = tipoArmazem;
    }

    public Compatibilidade getIdCompatibilidade() {
        return idCompatibilidade;
    }

    public void setIdCompatibilidade(Compatibilidade idCompatibilidade) {
        this.idCompatibilidade = idCompatibilidade;
    }

    public EndArmazem getIdEndarmazem() {
        return idEndarmazem;
    }

    public void setIdEndarmazem(EndArmazem idEndarmazem) {
        this.idEndarmazem = idEndarmazem;
    }

    public LocalOperacao getLocalOperacaoIdLocalOper() {
        return localOperacaoIdLocalOper;
    }

    public void setLocalOperacaoIdLocalOper(LocalOperacao localOperacaoIdLocalOper) {
        this.localOperacaoIdLocalOper = localOperacaoIdLocalOper;
    }

    public StatusArmazem getIdStatusArmazem() {
        return idStatusArmazem;
    }

    public void setIdStatusArmazem(StatusArmazem idStatusArmazem) {
        this.idStatusArmazem = idStatusArmazem;
    }

    public StatusArmazem getStatusArmazemIdStatusArmazem() {
        return statusArmazemIdStatusArmazem;
    }

    public void setStatusArmazemIdStatusArmazem(StatusArmazem statusArmazemIdStatusArmazem) {
        this.statusArmazemIdStatusArmazem = statusArmazemIdStatusArmazem;
    }

    

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idArmazem != null ? idArmazem.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Armazem)) {
            return false;
        }
        Armazem other = (Armazem) object;
        if ((this.idArmazem == null && other.idArmazem != null) || (this.idArmazem != null && !this.idArmazem.equals(other.idArmazem))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.Armazem[ idArmazem=" + idArmazem + " ]";
    }
    
}
