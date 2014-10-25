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
@Table(name = "num_onu")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "NumOnu.findAll", query = "SELECT n FROM NumOnu n"),
    @NamedQuery(name = "NumOnu.findByIdNumOnu", query = "SELECT n FROM NumOnu n WHERE n.idNumOnu = :idNumOnu"),
    @NamedQuery(name = "NumOnu.findByDescProd", query = "SELECT n FROM NumOnu n WHERE n.descProd = :descProd"),
    @NamedQuery(name = "NumOnu.findByNomeProd", query = "SELECT n FROM NumOnu n WHERE n.nomeProd = :nomeProd"),
    @NamedQuery(name = "NumOnu.findByNumOnu", query = "SELECT n FROM NumOnu n WHERE n.numOnu = :numOnu")})
public class NumOnu implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_num_onu")
    private Integer idNumOnu;
    @Size(max = 255)
    @Column(name = "desc_prod")
    private String descProd;
    @Size(max = 255)
    @Column(name = "nome_prod")
    private String nomeProd;
    @Column(name = "num_onu")
    private Integer numOnu;
    @OneToMany(mappedBy = "idNumOnu")
    private List<Produto> produtoList;

    public NumOnu() {
    }

    public NumOnu(Integer idNumOnu) {
        this.idNumOnu = idNumOnu;
    }

    public Integer getIdNumOnu() {
        return idNumOnu;
    }

    public void setIdNumOnu(Integer idNumOnu) {
        this.idNumOnu = idNumOnu;
    }

    public String getDescProd() {
        return descProd;
    }

    public void setDescProd(String descProd) {
        this.descProd = descProd;
    }

    public String getNomeProd() {
        return nomeProd;
    }

    public void setNomeProd(String nomeProd) {
        this.nomeProd = nomeProd;
    }

    public Integer getNumOnu() {
        return numOnu;
    }

    public void setNumOnu(Integer numOnu) {
        this.numOnu = numOnu;
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
        hash += (idNumOnu != null ? idNumOnu.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof NumOnu)) {
            return false;
        }
        NumOnu other = (NumOnu) object;
        if ((this.idNumOnu == null && other.idNumOnu != null) || (this.idNumOnu != null && !this.idNumOnu.equals(other.idNumOnu))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.NumOnu[ idNumOnu=" + idNumOnu + " ]";
    }
    
}
