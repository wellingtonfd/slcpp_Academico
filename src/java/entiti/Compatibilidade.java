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
@Table(name = "compatibilidade")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Compatibilidade.findAll", query = "SELECT c FROM Compatibilidade c"),
    @NamedQuery(name = "Compatibilidade.findByIdCompatibilidade", query = "SELECT c FROM Compatibilidade c WHERE c.idCompatibilidade = :idCompatibilidade"),
    @NamedQuery(name = "Compatibilidade.findByCodClassifi", query = "SELECT c FROM Compatibilidade c WHERE c.codClassifi = :codClassifi"),
    @NamedQuery(name = "Compatibilidade.findByDescCompatibilidade", query = "SELECT c FROM Compatibilidade c WHERE c.descCompatibilidade = :descCompatibilidade"),
    @NamedQuery(name = "Compatibilidade.findByGrupoCompatibilidade", query = "SELECT c FROM Compatibilidade c WHERE c.grupoCompatibilidade = :grupoCompatibilidade")})
public class Compatibilidade implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_compatibilidade")
    private Integer idCompatibilidade;
    @Size(max = 255)
    @Column(name = "cod_classifi")
    private String codClassifi;
    @Size(max = 255)
    @Column(name = "desc_compatibilidade")
    private String descCompatibilidade;
    @Size(max = 255)
    @Column(name = "grupo_compatibilidade")
    private String grupoCompatibilidade;
    @OneToMany(mappedBy = "idCompatibilidade")
    private List<Embalagem> embalagemList;
    @OneToMany(mappedBy = "idCompatibilidade")
    private List<Produto> produtoList;
    @JoinColumn(name = "id_legenda_compatibilidade", referencedColumnName = "id_legenda_compatibilidade")
    @ManyToOne
    private LegendaCompatibilidade idLegendaCompatibilidade = new LegendaCompatibilidade();
    @OneToMany(mappedBy = "idCompatibilidade")
    private List<Armazem> armazemList;

    public Compatibilidade() {
    }

    public Compatibilidade(Integer idCompatibilidade) {
        this.idCompatibilidade = idCompatibilidade;
    }

    public Integer getIdCompatibilidade() {
        return idCompatibilidade;
    }

    public void setIdCompatibilidade(Integer idCompatibilidade) {
        this.idCompatibilidade = idCompatibilidade;
    }

    public String getCodClassifi() {
        return codClassifi;
    }

    public void setCodClassifi(String codClassifi) {
        this.codClassifi = codClassifi;
    }

    public String getDescCompatibilidade() {
        return descCompatibilidade;
    }

    public void setDescCompatibilidade(String descCompatibilidade) {
        this.descCompatibilidade = descCompatibilidade;
    }

    public String getGrupoCompatibilidade() {
        return grupoCompatibilidade;
    }

    public void setGrupoCompatibilidade(String grupoCompatibilidade) {
        this.grupoCompatibilidade = grupoCompatibilidade;
    }

    @XmlTransient
    public List<Embalagem> getEmbalagemList() {
        return embalagemList;
    }

    public void setEmbalagemList(List<Embalagem> embalagemList) {
        this.embalagemList = embalagemList;
    }

    @XmlTransient
    public List<Produto> getProdutoList() {
        return produtoList;
    }

    public void setProdutoList(List<Produto> produtoList) {
        this.produtoList = produtoList;
    }

    public LegendaCompatibilidade getIdLegendaCompatibilidade() {
        return idLegendaCompatibilidade;
    }

    public void setIdLegendaCompatibilidade(LegendaCompatibilidade idLegendaCompatibilidade) {
        this.idLegendaCompatibilidade = idLegendaCompatibilidade;
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
        hash += (idCompatibilidade != null ? idCompatibilidade.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Compatibilidade)) {
            return false;
        }
        Compatibilidade other = (Compatibilidade) object;
        if ((this.idCompatibilidade == null && other.idCompatibilidade != null) || (this.idCompatibilidade != null && !this.idCompatibilidade.equals(other.idCompatibilidade))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.Compatibilidade[ idCompatibilidade=" + idCompatibilidade + " ]";
    }
    
}
