/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ui.bean;

import entiti.StatusArmazem;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 *
 * @author Administrador
 * @author Wellington Duarte
 */
@Stateless
public class StatusArmazemFacade extends AbstractFacade<StatusArmazem> {

    @PersistenceContext(unitName = "slcpp_AcademicoPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public StatusArmazemFacade() {
        super(StatusArmazem.class);
    }

}
