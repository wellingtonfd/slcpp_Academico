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
@Table(name = "fornecedor")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Fornecedor.findAll", query = "SELECT f FROM Fornecedor f"),
    @NamedQuery(name = "Fornecedor.findByIdFornecedor", query = "SELECT f FROM Fornecedor f WHERE f.idFornecedor = :idFornecedor"),
    @NamedQuery(name = "Fornecedor.findByCnpj", query = "SELECT f FROM Fornecedor f WHERE f.cnpj = :cnpj"),
    @NamedQuery(name = "Fornecedor.findByIdContato", query = "SELECT f FROM Fornecedor f WHERE f.idContato = :idContato"),
    @NamedQuery(name = "Fornecedor.findByInscSocial", query = "SELECT f FROM Fornecedor f WHERE f.inscSocial = :inscSocial"),
    @NamedQuery(name = "Fornecedor.findByNomeFantasia", query = "SELECT f FROM Fornecedor f WHERE f.nomeFantasia = :nomeFantasia"),
    @NamedQuery(name = "Fornecedor.findByRazaoSocial", query = "SELECT f FROM Fornecedor f WHERE f.razaoSocial = :razaoSocial")})
public class Fornecedor implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_fornecedor")
    private Integer idFornecedor;
    @Size(max = 255)
    @Column(name = "cnpj")
    private String cnpj;
    @Column(name = "id_contato")
    private Integer idContato;
    @Size(max = 255)
    @Column(name = "insc_social")
    private String inscSocial;
    @Size(max = 255)
    @Column(name = "nome_fantasia")
    private String nomeFantasia;
    @Size(max = 255)
    @Column(name = "razao_social")
    private String razaoSocial;
    @OneToMany(mappedBy = "fornecedorIdFornecedor")
    private List<TipoSolicitacao> tipoSolicitacaoList;
    @OneToMany(mappedBy = "fornecedorIdFornecedor")
    private List<DetNota> detNotaList;
    @JoinColumn(name = "id_endereco", referencedColumnName = "id_endereco")
    @ManyToOne
    private Endereco idEndereco = new Endereco();
    @JoinColumn(name = "contatos_id_contato", referencedColumnName = "id_contato")
    @ManyToOne
    private Contatos contatosIdContato = new Contatos();

    public Fornecedor() {
    }

    public Fornecedor(Integer idFornecedor) {
        this.idFornecedor = idFornecedor;
    }

    public Integer getIdFornecedor() {
        return idFornecedor;
    }

    public void setIdFornecedor(Integer idFornecedor) {
        this.idFornecedor = idFornecedor;
    }

    public String getCnpj() {
        return cnpj;
    }

    public void setCnpj(String cnpj) {
        this.cnpj = cnpj;
    }

    public Integer getIdContato() {
        return idContato;
    }

    public void setIdContato(Integer idContato) {
        this.idContato = idContato;
    }

    public String getInscSocial() {
        return inscSocial;
    }

    public void setInscSocial(String inscSocial) {
        this.inscSocial = inscSocial;
    }

    public String getNomeFantasia() {
        return nomeFantasia;
    }

    public void setNomeFantasia(String nomeFantasia) {
        this.nomeFantasia = nomeFantasia;
    }

    public String getRazaoSocial() {
        return razaoSocial;
    }

    public void setRazaoSocial(String razaoSocial) {
        this.razaoSocial = razaoSocial;
    }

    @XmlTransient
    public List<TipoSolicitacao> getTipoSolicitacaoList() {
        return tipoSolicitacaoList;
    }

    public void setTipoSolicitacaoList(List<TipoSolicitacao> tipoSolicitacaoList) {
        this.tipoSolicitacaoList = tipoSolicitacaoList;
    }

    @XmlTransient
    public List<DetNota> getDetNotaList() {
        return detNotaList;
    }

    public void setDetNotaList(List<DetNota> detNotaList) {
        this.detNotaList = detNotaList;
    }

    public Endereco getIdEndereco() {
        return idEndereco;
    }

    public void setIdEndereco(Endereco idEndereco) {
        this.idEndereco = idEndereco;
    }

    public Contatos getContatosIdContato() {
        return contatosIdContato;
    }

    public void setContatosIdContato(Contatos contatosIdContato) {
        this.contatosIdContato = contatosIdContato;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idFornecedor != null ? idFornecedor.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Fornecedor)) {
            return false;
        }
        Fornecedor other = (Fornecedor) object;
        if ((this.idFornecedor == null && other.idFornecedor != null) || (this.idFornecedor != null && !this.idFornecedor.equals(other.idFornecedor))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.Fornecedor[ idFornecedor=" + idFornecedor + " ]";
    }
    
}
