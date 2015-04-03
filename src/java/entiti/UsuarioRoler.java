/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package entiti;

import java.io.Serializable;
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
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author sacramento
 */
@Entity
@Table(name = "usuario_roler")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "UsuarioRoler.findAll", query = "SELECT u FROM UsuarioRoler u"),
    @NamedQuery(name = "UsuarioRoler.findById", query = "SELECT u FROM UsuarioRoler u WHERE u.id = :id")})
public class UsuarioRoler implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;
    @JoinColumn(name = "login", referencedColumnName = "id_usuario")
    @ManyToOne
    private Usuario login;
    @JoinColumn(name = "roler", referencedColumnName = "id_roler")
    @ManyToOne
    private Roler roler;

    public UsuarioRoler() {
    }

    public UsuarioRoler(Integer id) {
        this.id = id;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Usuario getLogin() {
        return login;
    }

    public void setLogin(Usuario login) {
        this.login = login;
    }

    public Roler getRoler() {
        return roler;
    }

    public void setRoler(Roler roler) {
        this.roler = roler;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof UsuarioRoler)) {
            return false;
        }
        UsuarioRoler other = (UsuarioRoler) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.UsuarioRoler[ id=" + id + " ]";
    }
    
}
