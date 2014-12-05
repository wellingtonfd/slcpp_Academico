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
@Table(name = "produto")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Produto.findAll", query = "SELECT p FROM Produto p"),
    @NamedQuery(name = "Produto.findByIdProduto", query = "SELECT p FROM Produto p WHERE p.idProduto = :idProduto"),
    @NamedQuery(name = "Produto.findByAcoesEmerg", query = "SELECT p FROM Produto p WHERE p.acoesEmerg = :acoesEmerg"),
    @NamedQuery(name = "Produto.findByComposicao", query = "SELECT p FROM Produto p WHERE p.composicao = :composicao"),
    @NamedQuery(name = "Produto.findByDescProduto", query = "SELECT p FROM Produto p WHERE p.descProduto = :descProduto"),
    @NamedQuery(name = "Produto.findByDtFab", query = "SELECT p FROM Produto p WHERE p.dtFab = :dtFab"),
    @NamedQuery(name = "Produto.findByDtVal", query = "SELECT p FROM Produto p WHERE p.dtVal = :dtVal"),
    @NamedQuery(name = "Produto.findByFormulaProduto", query = "SELECT p FROM Produto p WHERE p.formulaProduto = :formulaProduto"),
    @NamedQuery(name = "Produto.findByIdArmazem", query = "SELECT p FROM Produto p WHERE p.idArmazem = :idArmazem"),
    @NamedQuery(name = "Produto.findByIdEmbalagem", query = "SELECT p FROM Produto p WHERE p.idEmbalagem = :idEmbalagem"),
    @NamedQuery(name = "Produto.findByNLote", query = "SELECT p FROM Produto p WHERE p.nLote = :nLote"),
    @NamedQuery(name = "Produto.findByNomeGenerico", query = "SELECT p FROM Produto p WHERE p.nomeGenerico = :nomeGenerico"),
    @NamedQuery(name = "Produto.findByNumRisco", query = "SELECT p FROM Produto p WHERE p.numRisco = :numRisco"),
    @NamedQuery(name = "Produto.findByOdorProduto", query = "SELECT p FROM Produto p WHERE p.odorProduto = :odorProduto"),
    @NamedQuery(name = "Produto.findByOrigem", query = "SELECT p FROM Produto p WHERE p.origem = :origem"),
    @NamedQuery(name = "Produto.findByPainelSeguranca", query = "SELECT p FROM Produto p WHERE p.painelSeguranca = :painelSeguranca"),
    @NamedQuery(name = "Produto.findByRotuloProduto", query = "SELECT p FROM Produto p WHERE p.rotuloProduto = :rotuloProduto")})
public class Produto implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_produto")
    private Integer idProduto;
    @Size(max = 255)
    @Column(name = "acoes_emerg")
    private String acoesEmerg;
    @Size(max = 255)
    @Column(name = "composicao")
    private String composicao;
    @Size(max = 255)
    @Column(name = "desc_produto")
    private String descProduto;
    @Column(name = "dt_fab")
    @Temporal(TemporalType.DATE)
    private Date dtFab;
    @Column(name = "dt_val")
    @Temporal(TemporalType.DATE)
    private Date dtVal;
    @Size(max = 255)
    @Column(name = "formula_produto")
    private String formulaProduto;
    @Column(name = "id_armazem")
    private Integer idArmazem;
    @Column(name = "id_embalagem")
    private Integer idEmbalagem;
    @Column(name = "n_lote")
    private Integer nLote;
    @Size(max = 255)
    @Column(name = "nome_generico")
    private String nomeGenerico;
    @Column(name = "num_risco")
    private Integer numRisco;
    @Size(max = 255)
    @Column(name = "odor_produto")
    private String odorProduto;
    @Size(max = 255)
    @Column(name = "origem")
    private String origem;
    @Size(max = 255)
    @Column(name = "painel_seguranca")
    private String painelSeguranca;
    @Size(max = 255)
    @Column(name = "rotulo_produto")
    private String rotuloProduto;
    @OneToMany(mappedBy = "idProduto")
    private List<DetNota> detNotaList;
    @JoinColumn(name = "armazem_id_armazem", referencedColumnName = "id_armazem")
    @ManyToOne
    private Armazem armazemIdArmazem;
    @JoinColumn(name = "id_classe", referencedColumnName = "id_classe")
    @ManyToOne
    private Classe idClasse;
    @JoinColumn(name = "id_compatibilidade", referencedColumnName = "id_compatibilidade")
    @ManyToOne
    private Compatibilidade idCompatibilidade;
    @JoinColumn(name = "id_endarmazem", referencedColumnName = "id_endarmazem")
    @ManyToOne
    private EndArmazem idEndarmazem;
    @JoinColumn(name = "id_est_fisico", referencedColumnName = "id_est_fisico")
    @ManyToOne
    private EstFisico idEstFisico;
    @JoinColumn(name = "id_legenda_compatibilidade", referencedColumnName = "id_legenda_compatibilidade")
    @ManyToOne
    private LegendaCompatibilidade idLegendaCompatibilidade;
    @JoinColumn(name = "id_num_cas", referencedColumnName = "id_num_cas")
    @ManyToOne
    private NumCas idNumCas;
    @JoinColumn(name = "id_num_onu", referencedColumnName = "id_num_onu")
    @ManyToOne
    private NumOnu idNumOnu;

    public Produto() {
    }

    public Produto(Integer idProduto) {
        this.idProduto = idProduto;
    }

    public Integer getIdProduto() {
        return idProduto;
    }

    public void setIdProduto(Integer idProduto) {
        this.idProduto = idProduto;
    }

    public String getAcoesEmerg() {
        return acoesEmerg;
    }

    public void setAcoesEmerg(String acoesEmerg) {
        this.acoesEmerg = acoesEmerg;
    }

    public String getComposicao() {
        return composicao;
    }

    public void setComposicao(String composicao) {
        this.composicao = composicao;
    }

    public String getDescProduto() {
        return descProduto;
    }

    public void setDescProduto(String descProduto) {
        this.descProduto = descProduto;
    }

    public Date getDtFab() {
        return dtFab;
    }

    public void setDtFab(Date dtFab) {
        this.dtFab = dtFab;
    }

    public Date getDtVal() {
        return dtVal;
    }

    public void setDtVal(Date dtVal) {
        this.dtVal = dtVal;
    }

    public String getFormulaProduto() {
        return formulaProduto;
    }

    public void setFormulaProduto(String formulaProduto) {
        this.formulaProduto = formulaProduto;
    }

    public Integer getIdArmazem() {
        return idArmazem;
    }

    public void setIdArmazem(Integer idArmazem) {
        this.idArmazem = idArmazem;
    }

    public Integer getIdEmbalagem() {
        return idEmbalagem;
    }

    public void setIdEmbalagem(Integer idEmbalagem) {
        this.idEmbalagem = idEmbalagem;
    }

    public Integer getNLote() {
        return nLote;
    }

    public void setNLote(Integer nLote) {
        this.nLote = nLote;
    }

    public String getNomeGenerico() {
        return nomeGenerico;
    }

    public void setNomeGenerico(String nomeGenerico) {
        this.nomeGenerico = nomeGenerico;
    }

    public Integer getNumRisco() {
        return numRisco;
    }

    public void setNumRisco(Integer numRisco) {
        this.numRisco = numRisco;
    }

    public String getOdorProduto() {
        return odorProduto;
    }

    public void setOdorProduto(String odorProduto) {
        this.odorProduto = odorProduto;
    }

    public String getOrigem() {
        return origem;
    }

    public void setOrigem(String origem) {
        this.origem = origem;
    }

    public String getPainelSeguranca() {
        return painelSeguranca;
    }

    public void setPainelSeguranca(String painelSeguranca) {
        this.painelSeguranca = painelSeguranca;
    }

    public String getRotuloProduto() {
        return rotuloProduto;
    }

    public void setRotuloProduto(String rotuloProduto) {
        this.rotuloProduto = rotuloProduto;
    }

    @XmlTransient
    public List<DetNota> getDetNotaList() {
        return detNotaList;
    }

    public void setDetNotaList(List<DetNota> detNotaList) {
        this.detNotaList = detNotaList;
    }

    public Armazem getArmazemIdArmazem() {
        return armazemIdArmazem;
    }

    public void setArmazemIdArmazem(Armazem armazemIdArmazem) {
        this.armazemIdArmazem = armazemIdArmazem;
    }

    public Classe getIdClasse() {
        return idClasse;
    }

    public void setIdClasse(Classe idClasse) {
        this.idClasse = idClasse;
    }

    public Compatibilidade getIdCompatibilidade() {
        return idCompatibilidade;
    }

    public void setIdCompatibilidade(Compatibilidade idCompatibilidade) {
        this.idCompatibilidade = idCompatibilidade;
    }

    public EndArmazem getIdEndarmazem() {
        return idEndarmazem;
    }

    public void setIdEndarmazem(EndArmazem idEndarmazem) {
        this.idEndarmazem = idEndarmazem;
    }

    public EstFisico getIdEstFisico() {
        return idEstFisico;
    }

    public void setIdEstFisico(EstFisico idEstFisico) {
        this.idEstFisico = idEstFisico;
    }

    public LegendaCompatibilidade getIdLegendaCompatibilidade() {
        return idLegendaCompatibilidade;
    }

    public void setIdLegendaCompatibilidade(LegendaCompatibilidade idLegendaCompatibilidade) {
        this.idLegendaCompatibilidade = idLegendaCompatibilidade;
    }

    public NumCas getIdNumCas() {
        return idNumCas;
    }

    public void setIdNumCas(NumCas idNumCas) {
        this.idNumCas = idNumCas;
    }

    public NumOnu getIdNumOnu() {
        return idNumOnu;
    }

    public void setIdNumOnu(NumOnu idNumOnu) {
        this.idNumOnu = idNumOnu;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idProduto != null ? idProduto.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Produto)) {
            return false;
        }
        Produto other = (Produto) object;
        if ((this.idProduto == null && other.idProduto != null) || (this.idProduto != null && !this.idProduto.equals(other.idProduto))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entiti.Produto[ idProduto=" + idProduto + " ]";
    }
    
}
