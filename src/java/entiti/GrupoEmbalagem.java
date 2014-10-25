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
@Table(name = "grupo_embalagem")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "GrupoEmbalagem.findAll", query = "SELECT g FROM GrupoEmbalagem g"),
    @NamedQuery(name = "GrupoEmbalagem.findByIdGrupoEmbalagem", query = "SELECT g FROM GrupoEmbalagem g WHERE g.idGrupoEmbalagem = :idGrupoEmbalagem"),
    @NamedQuery(name = "GrupoEmbalagem.findByEspecGrupoEmbalagem", query = "SELECT g FROM GrupoEmbalagem g WHERE g.especGrupoEmbalagem = :especGrupoEmbalagem"),
    @NamedQuery(name = "GrupoEmbalagem.findByNomeGrupoEmbalagem", query = "SELECT g FROM GrupoEmbalagem g WHERE g.nomeGrupoEmbalagem = :nomeGrupoEmbalagem")})
public class GrupoEmbalagem implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_grupo_embalagem")
    private Integer idGrupoEmbalagem;
    @Size(max = 255)
    @Column(name = "espec_grupo_embalagem")
    private String especGrupoEmbalagem;
    @Size(max = 255)
    @Column(name = "nome_grupo_embalagem")
    private String nomeGrupoEmbalagem;
    @OneToMany(mappedBy = "idGrupoEmbalagem")
    private List<Embalagem> embalagemList;

    public GrupoEmbalagem() {
    }

    public GrupoEmbalagem(Integer idGrupoEmbalagem) {
        this.idGrupoEmbalagem = idGrupoEmbalagem;
    }

    public Integer getIdGrupoEmbalagem() {
        return idGrupoEmbalagem;
    }

    public void setIdGrupoEmbalagem(Integer idGrupoEmbalagem) {
        this.idGrupoEmbalagem = idGrupoEmbalagem;
    }

    public String getEspecGrupoEmbalagem() {
        return especGrupoEmbalagem;
    }

    public void setEspecGrupoEmbalagem(String especGrupoEmbalagem) {
        this.especGrupoEmbalagem = especGrupoEmbalagem;
    }

    public String getNomeGrupoEmbalagem() {
        return nomeGrupoEmbalagem;
    }

    public void setNomeGrupoEmbalagem(String nomeGrupoEmbalagem) {
        this.nomeGrupoEmbalagem = nomeGrupoEmbalagem;
    }

    @XmlTransient
    public List<Embalagem> getEmbalagemList() {
        return embalagemList;
    }

    public void setEmbalagemList(List<Embalagem> embalagemList) {
        this.embalagemList = embalagemList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idGrupoEmbalagem != null ? idGrupoEmbalagem.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof GrupoEmbalagem)) {
            return false;
        }
        GrupoEmbalagem other = (GrupoEmbalagem) object;
        if ((this.idGrupoEmbalagem == null && other.idGrupoEmbalagem != null) || (this.idGrupoEmbalagem != null && !this.idGrupoEmbalagem.equals(other.idGrupoEmbalagem))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.GrupoEmbalagem[ idGrupoEmbalagem=" + idGrupoEmbalagem + " ]";
    }
    
}
