/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package entiti;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

/**
 *
 * @author sacramento
 */
@Entity
@Table(name = "roler", catalog = "slcpp", schema = "public")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Roler.findAll", query = "SELECT r FROM Roler r"),
    @NamedQuery(name = "Roler.findByIdRoler", query = "SELECT r FROM Roler r WHERE r.idRoler = :idRoler"),
    @NamedQuery(name = "Roler.findByDescricao", query = "SELECT r FROM Roler r WHERE r.descricao = :descricao"),
    @NamedQuery(name = "Roler.findByNomeRoler", query = "SELECT r FROM Roler r WHERE r.nomeRoler = :nomeRoler")})
public class Roler implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_roler", nullable = false)
    private Integer idRoler;
    @Size(max = 255)
    @Column(name = "descricao", length = 255)
    private String descricao;
    @Size(max = 255)
    @Column(name = "nome_roler", length = 255)
    private String nomeRoler;
    @ManyToMany
    private List<Usuario> usuarioList;

    public Roler() {
    }

    public Roler(Integer idRoler) {
        this.idRoler = idRoler;
    }

    public Integer getIdRoler() {
        return idRoler;
    }

    public void setIdRoler(Integer idRoler) {
        this.idRoler = idRoler;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public String getNomeRoler() {
        return nomeRoler;
    }

    public void setNomeRoler(String nomeRoler) {
        this.nomeRoler = nomeRoler;
    }

    public List<Usuario> getUsuarioList() {
        return usuarioList;
    }

    public void setUsuarioList(List<Usuario> usuarioList) {
        this.usuarioList = usuarioList;
    }


    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idRoler != null ? idRoler.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Roler)) {
            return false;
        }
        Roler other = (Roler) object;
        if ((this.idRoler == null && other.idRoler != null) || (this.idRoler != null && !this.idRoler.equals(other.idRoler))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.Roler[ idRoler=" + idRoler + " ]";
    }
    
}
