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
@Table(name = "num_cas")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "NumCas.findAll", query = "SELECT n FROM NumCas n"),
    @NamedQuery(name = "NumCas.findByIdNumCas", query = "SELECT n FROM NumCas n WHERE n.idNumCas = :idNumCas"),
    @NamedQuery(name = "NumCas.findByEspcNumCas", query = "SELECT n FROM NumCas n WHERE n.espcNumCas = :espcNumCas"),
    @NamedQuery(name = "NumCas.findByNumCas", query = "SELECT n FROM NumCas n WHERE n.numCas = :numCas")})
public class NumCas implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_num_cas")
    private Integer idNumCas;
    @Size(max = 255)
    @Column(name = "espc_num_cas")
    private String espcNumCas;
    @Size(max = 255)
    @Column(name = "num_cas")
    private String numCas;
    @OneToMany(mappedBy = "idNumCas")
    private List<Produto> produtoList;

    public NumCas() {
    }

    public NumCas(Integer idNumCas) {
        this.idNumCas = idNumCas;
    }

    public Integer getIdNumCas() {
        return idNumCas;
    }

    public void setIdNumCas(Integer idNumCas) {
        this.idNumCas = idNumCas;
    }

    public String getEspcNumCas() {
        return espcNumCas;
    }

    public void setEspcNumCas(String espcNumCas) {
        this.espcNumCas = espcNumCas;
    }

    public String getNumCas() {
        return numCas;
    }

    public void setNumCas(String numCas) {
        this.numCas = numCas;
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
        hash += (idNumCas != null ? idNumCas.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof NumCas)) {
            return false;
        }
        NumCas other = (NumCas) object;
        if ((this.idNumCas == null && other.idNumCas != null) || (this.idNumCas != null && !this.idNumCas.equals(other.idNumCas))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.NumCas[ idNumCas=" + idNumCas + " ]";
    }

}
