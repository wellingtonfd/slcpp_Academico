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
@Table(name = "est_fisico")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "EstFisico.findAll", query = "SELECT e FROM EstFisico e"),
    @NamedQuery(name = "EstFisico.findByIdEstFisico", query = "SELECT e FROM EstFisico e WHERE e.idEstFisico = :idEstFisico"),
    @NamedQuery(name = "EstFisico.findByEspEstFisico", query = "SELECT e FROM EstFisico e WHERE e.espEstFisico = :espEstFisico"),
    @NamedQuery(name = "EstFisico.findByNomeEstFisico", query = "SELECT e FROM EstFisico e WHERE e.nomeEstFisico = :nomeEstFisico")})
public class EstFisico implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_est_fisico")
    private Integer idEstFisico;
    @Size(max = 255)
    @Column(name = "esp_est_fisico")
    private String espEstFisico;
    @Size(max = 255)
    @Column(name = "nome_est_fisico")
    private String nomeEstFisico;
    @OneToMany(mappedBy = "idEstFisico")
    private List<Produto> produtoList;

    public EstFisico() {
    }

    public EstFisico(Integer idEstFisico) {
        this.idEstFisico = idEstFisico;
    }

    public Integer getIdEstFisico() {
        return idEstFisico;
    }

    public void setIdEstFisico(Integer idEstFisico) {
        this.idEstFisico = idEstFisico;
    }

    public String getEspEstFisico() {
        return espEstFisico;
    }

    public void setEspEstFisico(String espEstFisico) {
        this.espEstFisico = espEstFisico;
    }

    public String getNomeEstFisico() {
        return nomeEstFisico;
    }

    public void setNomeEstFisico(String nomeEstFisico) {
        this.nomeEstFisico = nomeEstFisico;
    }

    @XmlTransient
    public List<Produto> getProdutoList() {
        return produtoList;
    }

    public void setProdutoList(List<Produto> produtoList) {
        this.produtoList = produtoList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idEstFisico != null ? idEstFisico.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof EstFisico)) {
            return false;
        }
        EstFisico other = (EstFisico) object;
        if ((this.idEstFisico == null && other.idEstFisico != null) || (this.idEstFisico != null && !this.idEstFisico.equals(other.idEstFisico))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.EstFisico[ idEstFisico=" + idEstFisico + " ]";
    }
    
}
