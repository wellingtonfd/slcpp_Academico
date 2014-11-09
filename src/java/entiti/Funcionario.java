/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package entiti;

import java.io.Serializable;
import java.util.Date;
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
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

/**
 *
 * @author sacramento
 */
@Entity
@Table(name = "funcionario")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Funcionario.findAll", query = "SELECT f FROM Funcionario f"),
    @NamedQuery(name = "Funcionario.findByIdFuncionario", query = "SELECT f FROM Funcionario f WHERE f.idFuncionario = :idFuncionario"),
    @NamedQuery(name = "Funcionario.findByCargo", query = "SELECT f FROM Funcionario f WHERE f.cargo = :cargo"),
    @NamedQuery(name = "Funcionario.findByCpf", query = "SELECT f FROM Funcionario f WHERE f.cpf = :cpf"),
    @NamedQuery(name = "Funcionario.findByDtAdmissao", query = "SELECT f FROM Funcionario f WHERE f.dtAdmissao = :dtAdmissao"),
    @NamedQuery(name = "Funcionario.findByDtNasc", query = "SELECT f FROM Funcionario f WHERE f.dtNasc = :dtNasc"),
    @NamedQuery(name = "Funcionario.findByEspecializacao", query = "SELECT f FROM Funcionario f WHERE f.especializacao = :especializacao"),
    @NamedQuery(name = "Funcionario.findByFuncao", query = "SELECT f FROM Funcionario f WHERE f.funcao = :funcao"),
    @NamedQuery(name = "Funcionario.findByIdContato", query = "SELECT f FROM Funcionario f WHERE f.idContato = :idContato"),
    @NamedQuery(name = "Funcionario.findByMatFuncionario", query = "SELECT f FROM Funcionario f WHERE f.matFuncionario = :matFuncionario"),
    @NamedQuery(name = "Funcionario.findByNivelFuncionario", query = "SELECT f FROM Funcionario f WHERE f.nivelFuncionario = :nivelFuncionario"),
    @NamedQuery(name = "Funcionario.findByNomeFuncionario", query = "SELECT f FROM Funcionario f WHERE f.nomeFuncionario = :nomeFuncionario"),
    @NamedQuery(name = "Funcionario.findByRg", query = "SELECT f FROM Funcionario f WHERE f.rg = :rg"),
    @NamedQuery(name = "Funcionario.findBySbNomeFuncionario", query = "SELECT f FROM Funcionario f WHERE f.sbNomeFuncionario = :sbNomeFuncionario"),
    @NamedQuery(name = "Funcionario.findBySexo", query = "SELECT f FROM Funcionario f WHERE f.sexo = :sexo")})
public class Funcionario implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_funcionario")
    private Integer idFuncionario;
    @Size(max = 255)
    @Column(name = "cargo")
    private String cargo;
    @Size(max = 255)
    @Column(name = "cpf")
    private String cpf;
    @Column(name = "dt_admissao")
    @Temporal(TemporalType.DATE)
    private Date dtAdmissao;
    @Column(name = "dt_nasc")
    @Temporal(TemporalType.DATE)
    private Date dtNasc;
    @Size(max = 255)
    @Column(name = "especializacao")
    private String especializacao;
    @Size(max = 255)
    @Column(name = "funcao")
    private String funcao;
    @Column(name = "id_contato")
    private Integer idContato;
    @Column(name = "mat_funcionario")
    private Integer matFuncionario;
    @Size(max = 255)
    @Column(name = "nivel_funcionario")
    private String nivelFuncionario;
    @Size(max = 255)
    @Column(name = "nome_funcionario")
    private String nomeFuncionario;
    @Size(max = 255)
    @Column(name = "rg")
    private String rg;
    @Size(max = 255)
    @Column(name = "sb_nome_funcionario")
    private String sbNomeFuncionario;
    @Size(max = 255)
    @Column(name = "sexo")
    private String sexo;
    @OneToMany(mappedBy = "idFuncionario")
    private List<TipoSolicitacao> tipoSolicitacaoList;
    @OneToMany(mappedBy = "idFuncionario")
    private List<Movimentacao> movimentacaoList;
    @JoinColumn(name = "id_usuario", referencedColumnName = "id_usuario")
    @ManyToOne
    private Usuario idUsuario;
    @JoinColumn(name = "endereco_id_endereco", referencedColumnName = "id_endereco")
    @ManyToOne
    private Endereco enderecoIdEndereco = new Endereco();
    @JoinColumn(name = "contatos_id_contato", referencedColumnName = "id_contato")
    @ManyToOne
    private Contatos contatosIdContato = new Contatos();

    public Funcionario() {
    }

    public Funcionario(Integer idFuncionario) {
        this.idFuncionario = idFuncionario;
    }

    public Integer getIdFuncionario() {
        return idFuncionario;
    }

    public void setIdFuncionario(Integer idFuncionario) {
        this.idFuncionario = idFuncionario;
    }

    public String getCargo() {
        return cargo;
    }

    public void setCargo(String cargo) {
        this.cargo = cargo;
    }

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    public Date getDtAdmissao() {
        return dtAdmissao;
    }

    public void setDtAdmissao(Date dtAdmissao) {
        this.dtAdmissao = dtAdmissao;
    }

    public Date getDtNasc() {
        return dtNasc;
    }

    public void setDtNasc(Date dtNasc) {
        this.dtNasc = dtNasc;
    }

    public String getEspecializacao() {
        return especializacao;
    }

    public void setEspecializacao(String especializacao) {
        this.especializacao = especializacao;
    }

    public String getFuncao() {
        return funcao;
    }

    public void setFuncao(String funcao) {
        this.funcao = funcao;
    }

    public Integer getIdContato() {
        return idContato;
    }

    public void setIdContato(Integer idContato) {
        this.idContato = idContato;
    }

    public Integer getMatFuncionario() {
        return matFuncionario;
    }

    public void setMatFuncionario(Integer matFuncionario) {
        this.matFuncionario = matFuncionario;
    }

    public String getNivelFuncionario() {
        return nivelFuncionario;
    }

    public void setNivelFuncionario(String nivelFuncionario) {
        this.nivelFuncionario = nivelFuncionario;
    }

    public String getNomeFuncionario() {
        return nomeFuncionario;
    }

    public void setNomeFuncionario(String nomeFuncionario) {
        this.nomeFuncionario = nomeFuncionario;
    }

    public String getRg() {
        return rg;
    }

    public void setRg(String rg) {
        this.rg = rg;
    }

    public String getSbNomeFuncionario() {
        return sbNomeFuncionario;
    }

    public void setSbNomeFuncionario(String sbNomeFuncionario) {
        this.sbNomeFuncionario = sbNomeFuncionario;
    }

    public String getSexo() {
        return sexo;
    }

    public void setSexo(String sexo) {
        this.sexo = sexo;
    }

    @XmlTransient
    public List<TipoSolicitacao> getTipoSolicitacaoList() {
        return tipoSolicitacaoList;
    }

    public void setTipoSolicitacaoList(List<TipoSolicitacao> tipoSolicitacaoList) {
        this.tipoSolicitacaoList = tipoSolicitacaoList;
    }

    @XmlTransient
    public List<Movimentacao> getMovimentacaoList() {
        return movimentacaoList;
    }

    public void setMovimentacaoList(List<Movimentacao> movimentacaoList) {
        this.movimentacaoList = movimentacaoList;
    }

    public Usuario getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(Usuario idUsuario) {
        this.idUsuario = idUsuario;
    }

    public Endereco getEnderecoIdEndereco() {
        return enderecoIdEndereco;
    }

    public void setEnderecoIdEndereco(Endereco enderecoIdEndereco) {
        this.enderecoIdEndereco = enderecoIdEndereco;
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
        hash += (idFuncionario != null ? idFuncionario.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Funcionario)) {
            return false;
        }
        Funcionario other = (Funcionario) object;
        if ((this.idFuncionario == null && other.idFuncionario != null) || (this.idFuncionario != null && !this.idFuncionario.equals(other.idFuncionario))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.Funcionario[ idFuncionario=" + idFuncionario + " ]";
    }
    
}
