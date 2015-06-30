/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package ui.bean;

import entiti.Movimentacao;
import static java.lang.System.out;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import utils.armazenagem.ArmazenagemUtil;

/**
 *
 * @author Administrador
 * @author Wellington Duarte
 */
@Stateless
public class MovimentacaoFacade extends AbstractFacade<Movimentacao> {
    @PersistenceContext(unitName = "slcpp_AcademicoPU")
    private EntityManager em;
    
    private ArmazenagemUtil armazenagemUtil;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public MovimentacaoFacade() {
        super(Movimentacao.class);
    }

    @Override
    public void create(Movimentacao entity) {
        System.out.println("ENTITY  1" + entity);
        out.println("teste 2");
       // super.create(entity); //To change body of generated methods, choose Tools | Templates.
        armazenagemUtil = new ArmazenagemUtil();
        System.out.println("ENTITY " + entity);
        armazenagemUtil.armazenaProduto(entity.getIdProduto(), entity.getQuantidadeTotal(), entity.getQuantidadePorPalete());
       
        
    }
    
    

}
