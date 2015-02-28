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
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

/**
 *
 * @author wellington
 */
@Entity
@Table(name = "produto")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Produto.findAll", query = "SELECT p FROM Produto p"),
    @NamedQuery(name = "Produto.findByNumOnu", query = "SELECT p FROM Produto p WHERE p.numOnu = :numOnu"),
    @NamedQuery(name = "Produto.findByDescProduto", query = "SELECT p FROM Produto p WHERE p.descProduto = :descProduto")})
public class Produto implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Column(name = "num_onu")
    private Integer numOnu;
    @Size(max = 300)
    @Column(name = "desc_produto")
    private String descProduto;
    @JoinColumn(name = "classe", referencedColumnName = "id_classe")
    @ManyToOne
    private Classe classe;
    @OneToMany(mappedBy = "numonu")
    private List<Compatibilidade> compatibilidadeList;

    public Produto() {
    }

    public Produto(Integer numOnu) {
        this.numOnu = numOnu;
    }

    public Integer getNumOnu() {
        return numOnu;
    }

    public void setNumOnu(Integer numOnu) {
        this.numOnu = numOnu;
    }

    public String getDescProduto() {
        return descProduto;
    }

    public void setDescProduto(String descProduto) {
        this.descProduto = descProduto;
    }

    public Classe getClasse() {
        return classe;
    }

    public void setClasse(Classe classe) {
        this.classe = classe;
    }

    @XmlTransient
    public List<Compatibilidade> getCompatibilidadeList() {
        return compatibilidadeList;
    }

    public void setCompatibilidadeList(List<Compatibilidade> compatibilidadeList) {
        this.compatibilidadeList = compatibilidadeList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (numOnu != null ? numOnu.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Produto)) {
            return false;
        }
        Produto other = (Produto) object;
        if ((this.numOnu == null && other.numOnu != null) || (this.numOnu != null && !this.numOnu.equals(other.numOnu))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.Produto[ numOnu=" + numOnu + " ]";
    }
    
}
