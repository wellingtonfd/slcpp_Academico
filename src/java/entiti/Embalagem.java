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
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author sacramento
 */
@Entity
@Table(name = "embalagem")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Embalagem.findAll", query = "SELECT e FROM Embalagem e"),
    @NamedQuery(name = "Embalagem.findByIdEmbalagem", query = "SELECT e FROM Embalagem e WHERE e.idEmbalagem = :idEmbalagem"),
    @NamedQuery(name = "Embalagem.findByCapacidPressao", query = "SELECT e FROM Embalagem e WHERE e.capacidPressao = :capacidPressao"),
    @NamedQuery(name = "Embalagem.findByEspecEmabalagem", query = "SELECT e FROM Embalagem e WHERE e.especEmabalagem = :especEmabalagem"),
    @NamedQuery(name = "Embalagem.findByIdTipoMaterial", query = "SELECT e FROM Embalagem e WHERE e.idTipoMaterial = :idTipoMaterial"),
    @NamedQuery(name = "Embalagem.findByPtEbulicao", query = "SELECT e FROM Embalagem e WHERE e.ptEbulicao = :ptEbulicao"),
    @NamedQuery(name = "Embalagem.findByPtFulgor", query = "SELECT e FROM Embalagem e WHERE e.ptFulgor = :ptFulgor")})
public class Embalagem implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_embalagem")
    private Integer idEmbalagem;
    @Size(max = 255)
    @Column(name = "capacid_pressao")
    private String capacidPressao;
    @Size(max = 255)
    @Column(name = "espec_emabalagem")
    private String especEmabalagem;
    @Column(name = "id_tipo_material")
    private Integer idTipoMaterial;
    @Size(max = 255)
    @Column(name = "pt_ebulicao")
    private String ptEbulicao;
    @Size(max = 255)
    @Column(name = "pt_fulgor")
    private String ptFulgor;
    @JoinColumn(name = "id_grupo_embalagem", referencedColumnName = "id_grupo_embalagem")
    @ManyToOne
    private GrupoEmbalagem idGrupoEmbalagem;
    @JoinColumn(name = "id_compatibilidade", referencedColumnName = "id_compatibilidade")
    @ManyToOne
    private Compatibilidade idCompatibilidade;
    @JoinColumn(name = "id_capacidade", referencedColumnName = "id_capacidade")
    @ManyToOne
    private Capacidade idCapacidade;

    
    //TODO: mapeamento de dimensões 
    
    private double largura;
    private double altura;
    private double comprimento;
    
    
    
    public Embalagem() {
    }

    public Embalagem(Integer idEmbalagem) {
        this.idEmbalagem = idEmbalagem;
    }

    public Integer getIdEmbalagem() {
        return idEmbalagem;
    }

    public void setIdEmbalagem(Integer idEmbalagem) {
        this.idEmbalagem = idEmbalagem;
    }

    public String getCapacidPressao() {
        return capacidPressao;
    }

    public void setCapacidPressao(String capacidPressao) {
        this.capacidPressao = capacidPressao;
    }

    public String getEspecEmabalagem() {
        return especEmabalagem;
    }

    public void setEspecEmabalagem(String especEmabalagem) {
        this.especEmabalagem = especEmabalagem;
    }

    public Integer getIdTipoMaterial() {
        return idTipoMaterial;
    }

    public void setIdTipoMaterial(Integer idTipoMaterial) {
        this.idTipoMaterial = idTipoMaterial;
    }

    public String getPtEbulicao() {
        return ptEbulicao;
    }

    public void setPtEbulicao(String ptEbulicao) {
        this.ptEbulicao = ptEbulicao;
    }

    public String getPtFulgor() {
        return ptFulgor;
    }

    public void setPtFulgor(String ptFulgor) {
        this.ptFulgor = ptFulgor;
    }

    public GrupoEmbalagem getIdGrupoEmbalagem() {
        return idGrupoEmbalagem;
    }

    public void setIdGrupoEmbalagem(GrupoEmbalagem idGrupoEmbalagem) {
        this.idGrupoEmbalagem = idGrupoEmbalagem;
    }

    public Compatibilidade getIdCompatibilidade() {
        return idCompatibilidade;
    }

    public void setIdCompatibilidade(Compatibilidade idCompatibilidade) {
        this.idCompatibilidade = idCompatibilidade;
    }

    public Capacidade getIdCapacidade() {
        return idCapacidade;
    }

    public void setIdCapacidade(Capacidade idCapacidade) {
        this.idCapacidade = idCapacidade;
    }

    public double getLargura() {
        return largura;
    }

    public void setLargura(double largura) {
        this.largura = largura;
    }

    public double getAltura() {
        return altura;
    }

    public void setAltura(double altura) {
        this.altura = altura;
    }

    public double getComprimento() {
        return comprimento;
    }

    public void setComprimento(double comprimento) {
        this.comprimento = comprimento;
    }

    
    
    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idEmbalagem != null ? idEmbalagem.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Embalagem)) {
            return false;
        }
        Embalagem other = (Embalagem) object;
        if ((this.idEmbalagem == null && other.idEmbalagem != null) || (this.idEmbalagem != null && !this.idEmbalagem.equals(other.idEmbalagem))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.Embalagem[ idEmbalagem=" + idEmbalagem + " ]";
    }
    
}
