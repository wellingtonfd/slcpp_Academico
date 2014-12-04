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
@Table(name = "end_armazem")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "EndArmazem.findAll", query = "SELECT e FROM EndArmazem e"),
    @NamedQuery(name = "EndArmazem.findByIdEndarmazem", query = "SELECT e FROM EndArmazem e WHERE e.idEndarmazem = :idEndarmazem"),
    @NamedQuery(name = "EndArmazem.findByCorEndArmazem", query = "SELECT e FROM EndArmazem e WHERE e.corEndArmazem = :corEndArmazem"),
    @NamedQuery(name = "EndArmazem.findByLadoEndArmazem", query = "SELECT e FROM EndArmazem e WHERE e.ladoEndArmazem = :ladoEndArmazem"),
    @NamedQuery(name = "EndArmazem.findByNivelEndArmazem", query = "SELECT e FROM EndArmazem e WHERE e.nivelEndArmazem = :nivelEndArmazem"),
    @NamedQuery(name = "EndArmazem.findByPosicaoEndArmazem", query = "SELECT e FROM EndArmazem e WHERE e.posicaoEndArmazem = :posicaoEndArmazem"),
    @NamedQuery(name = "EndArmazem.findByRuaEndArmazem", query = "SELECT e FROM EndArmazem e WHERE e.ruaEndArmazem = :ruaEndArmazem")})
public class EndArmazem implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_endarmazem")
    private Integer idEndarmazem;
    @Size(max = 255)
    @Column(name = "cor_end_armazem")
    private String corEndArmazem;
    @Size(max = 255)
    @Column(name = "lado_end_armazem")
    private String ladoEndArmazem;
    @Size(max = 255)
    @Column(name = "nivel_end_armazem")
    private String nivelEndArmazem;
    @Size(max = 255)
    @Column(name = "posicao_end_armazem")
    private String posicaoEndArmazem;
    @Size(max = 255)
    @Column(name = "rua_end_armazem")
    private String ruaEndArmazem;
    @OneToMany(mappedBy = "idEndarmazem")
    private List<Produto> produtoList;
    @OneToMany(mappedBy = "idEndarmazem")
    private List<Armazem> armazemList;

    public EndArmazem() {
    }

    public EndArmazem(Integer idEndarmazem) {
        this.idEndarmazem = idEndarmazem;
    }

    public Integer getIdEndarmazem() {
        return idEndarmazem;
    }

    public void setIdEndarmazem(Integer idEndarmazem) {
        this.idEndarmazem = idEndarmazem;
    }

    public String getCorEndArmazem() {
        return corEndArmazem;
    }

    public void setCorEndArmazem(String corEndArmazem) {
        this.corEndArmazem = corEndArmazem;
    }

    public String getLadoEndArmazem() {
        return ladoEndArmazem;
    }

    public void setLadoEndArmazem(String ladoEndArmazem) {
        this.ladoEndArmazem = ladoEndArmazem;
    }

    public String getNivelEndArmazem() {
        return nivelEndArmazem;
    }

    public void setNivelEndArmazem(String nivelEndArmazem) {
        this.nivelEndArmazem = nivelEndArmazem;
    }

    public String getPosicaoEndArmazem() {
        return posicaoEndArmazem;
    }

    public void setPosicaoEndArmazem(String posicaoEndArmazem) {
        this.posicaoEndArmazem = posicaoEndArmazem;
    }

    public String getRuaEndArmazem() {
        return ruaEndArmazem;
    }

    public void setRuaEndArmazem(String ruaEndArmazem) {
        this.ruaEndArmazem = ruaEndArmazem;
    }

    @XmlTransient
    public List<Produto> getProdutoList() {
        return produtoList;
    }

    public void setProdutoList(List<Produto> produtoList) {
        this.produtoList = produtoList;
    }

    @XmlTransient
    public List<Armazem> getArmazemList() {
        return armazemList;
    }

    public void setArmazemList(List<Armazem> armazemList) {
        this.armazemList = armazemList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idEndarmazem != null ? idEndarmazem.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof EndArmazem)) {
            return false;
        }
        EndArmazem other = (EndArmazem) object;
        if ((this.idEndarmazem == null && other.idEndarmazem != null) || (this.idEndarmazem != null && !this.idEndarmazem.equals(other.idEndarmazem))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.EndArmazem[ idEndarmazem=" + idEndarmazem + " ]";
    }

}
