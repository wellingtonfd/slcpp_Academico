package ui.factory;

import entiti.Cidade;
import entiti.Funcionario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.inject.Named;
import javax.faces.view.ViewScoped;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.inject.Inject;
import org.primefaces.event.FlowEvent;
import reports.jasperConnection;

@Named(value = "funcionarioController")
@ViewScoped
public class FuncionarioController extends AbstractController<Funcionario> {

    @Inject
    private TipoSolicitacaoController tipoSolicitacaoListController;
    @Inject
    private MovimentacaoController movimentacaoListController;
    @Inject
    private UsuarioController idUsuarioController;
    @Inject
    private EnderecoController enderecoIdEnderecoController;
    @Inject
    private ContatosController contatosIdContatoController;
    
    private boolean skip;
    
      public boolean isSkip() {
        return skip;
    }
 
    public void setSkip(boolean skip) {
        this.skip = skip;
    }

    public FuncionarioController() {
        // Inform the Abstract parent controller of the concrete Funcionario?cap_first Entity
        super(Funcionario.class);
    }

    /**
     * Resets the "selected" attribute of any parent Entity controllers.
     */
    public void resetParents() {
        idUsuarioController.setSelected(null);
        enderecoIdEnderecoController.setSelected(null);
        contatosIdContatoController.setSelected(null);
    }

    /**
     * Sets the "items" attribute with a List of TipoSolicitacao entities
     * that are retrieved from Funcionario?cap_first and returns the navigation
     * outcome.
     *
     * @return navigation outcome for TipoSolicitacao page
     */
    public String navigateTipoSolicitacaoList() {
        if (this.getSelected() != null) {
            FacesContext.getCurrentInstance().getExternalContext().getRequestMap().put("TipoSolicitacao_items", this.getSelected().getTipoSolicitacaoList());
        }
        return "/entiti/tipoSolicitacao/index";
    }

    

    /**
     * Sets the "selected" attribute of the Usuario controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
    public void prepareIdUsuario(ActionEvent event) {
        if (this.getSelected() != null && idUsuarioController.getSelected() == null) {
            idUsuarioController.setSelected(this.getSelected().getIdUsuario());
        }
    }

    /**
     * Sets the "selected" attribute of the Endereco controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
    public void prepareEnderecoIdEndereco(ActionEvent event) {
        if (this.getSelected() != null && enderecoIdEnderecoController.getSelected() == null) {
            enderecoIdEnderecoController.setSelected(this.getSelected().getEnderecoIdEndereco());
        }
    }

    /**
     * Sets the "selected" attribute of the Contatos controller in order to
     * display its data in a dialog. This is reusing existing the existing View
     * dialog.
     *
     * @param event Event object for the widget that triggered an action
     */
    public void prepareContatosIdContato(ActionEvent event) {
        if (this.getSelected() != null && contatosIdContatoController.getSelected() == null) {
            contatosIdContatoController.setSelected(this.getSelected().getContatosIdContato());
        }
    }
    
    public String onFlowProcess(FlowEvent event) {
        if(skip) {
            skip = false;   //reset in case user goes back
            return "confirm";
        }
        else {
            return event.getNewStep();
        }
    }
    
    public List<Cidade> getCidade(){
        List<Cidade> cidades = new ArrayList<Cidade>();
        String query = null;
        
        ResultSet rs;
        try{
            Connection connection = jasperConnection.getConexao();
            
            try{
            query = "SELECT c.id_cidade, c.nome_cidade, c.id_estado FROM cidade c where c.id_estado = " + getSelected().getEnderecoIdEndereco().getIdEstado().getIdEstado() + ";";
            }catch(Exception e){
                query = "SELECT * FROM cidade;";
            }
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();
            
            while(rs.next()){
                Cidade cidade = new Cidade();
                cidade.setIdCidade(rs.getInt("id_cidade"));
                cidade.setNomeCidade(rs.getString("nome_cidade"));
                cidades.add(cidade);
            }
            
            connection.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return cidades;
         
    }
    
}
