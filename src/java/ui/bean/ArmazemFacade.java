/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package ui.bean;

import entiti.Armazem;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

/**
 *
 * @author Administrador
 * @author Wellington Duarte
 */
@Stateless
public class ArmazemFacade extends AbstractFacade<Armazem> {
    @PersistenceContext(unitName = "slcpp_AcademicoPU")
    private EntityManager em;

    @Override
    public EntityManager getEntityManager() {
        return em;
    }

    public ArmazemFacade() {
        super(Armazem.class);
    }

}
