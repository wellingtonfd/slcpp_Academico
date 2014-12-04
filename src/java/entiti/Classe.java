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
 * @author Administrador
 * @author Wellington Duarte
 */
@Entity
@Table(name = "classe")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Classe.findAll", query = "SELECT c FROM Classe c"),
    @NamedQuery(name = "Classe.findByIdClasse", query = "SELECT c FROM Classe c WHERE c.idClasse = :idClasse"),
    @NamedQuery(name = "Classe.findByEspecClasse", query = "SELECT c FROM Classe c WHERE c.especClasse = :especClasse"),
    @NamedQuery(name = "Classe.findByNumClasse", query = "SELECT c FROM Classe c WHERE c.numClasse = :numClasse"),
    @NamedQuery(name = "Classe.findByNumSubclasse", query = "SELECT c FROM Classe c WHERE c.numSubclasse = :numSubclasse")})
public class Classe implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_classe")
    private Integer idClasse;
    @Size(max = 255)
    @Column(name = "espec_classe")
    private String especClasse;
    @Size(max = 3)
    @Column(name = "num_classe")
    private String numClasse;
    @Size(max = 3)
    @Column(name = "num_subclasse")
    private String numSubclasse;
    @OneToMany(mappedBy = "idClasse")
    private List<Produto> produtoList;

    public Classe() {
    }

    public Classe(Integer idClasse) {
        this.idClasse = idClasse;
    }

    public Integer getIdClasse() {
        return idClasse;
    }

    public void setIdClasse(Integer idClasse) {
        this.idClasse = idClasse;
    }

    public String getEspecClasse() {
        return especClasse;
    }

    public void setEspecClasse(String especClasse) {
        this.especClasse = especClasse;
    }

    public String getNumClasse() {
        return numClasse;
    }

    public void setNumClasse(String numClasse) {
        this.numClasse = numClasse;
    }

    public String getNumSubclasse() {
        return numSubclasse;
    }

    public void setNumSubclasse(String numSubclasse) {
        this.numSubclasse = numSubclasse;
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
        hash += (idClasse != null ? idClasse.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Classe)) {
            return false;
        }
        Classe other = (Classe) object;
        if ((this.idClasse == null && other.idClasse != null) || (this.idClasse != null && !this.idClasse.equals(other.idClasse))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.Classe[ idClasse=" + idClasse + " ]";
    }

}
