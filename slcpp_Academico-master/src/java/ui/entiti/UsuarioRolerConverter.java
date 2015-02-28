/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package ui.entiti;

import entiti.UsuarioRoler;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.convert.Converter;
import javax.faces.convert.FacesConverter;
import javax.inject.Inject;
import ui.bean.UsuarioRolerFacade;
import ui.factory.util.JsfUtil;

/**
 *
 * @author sacramento
 */
@FacesConverter(value = "usuarioRolerConverter")
public class UsuarioRolerConverter implements Converter{
    
    @Inject
    private UsuarioRolerFacade ejbFacade;
    
    @Override
    public Object getAsObject(FacesContext facesContext, UIComponent component, String value){
        if (value == null || value.length() == 0 || JsfUtil.isDummySelectItem(component, value)){
            return null;
        }
        return this.ejbFacade.find(getkey(value));
    }
    
    java.lang.Integer getkey(String value){
        java.lang.Integer key;
        key = Integer.valueOf(value);
        return key;
    }
    
    String getStringKey(java.lang.Integer value){
        StringBuffer sb = new StringBuffer();
        sb.append(value);
        return sb.toString();
    }
    
    @Override
    public String getAsString(FacesContext facesContext, UIComponent component, Object object){
        if(object == null
                || (object instanceof String && ((String) object).length() == 0)) {
            return null;
        }
        if (object instanceof UsuarioRoler){
            UsuarioRoler o = (UsuarioRoler) object;
            return getStringKey(o.getId());
        }else{
            Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, "object {0} is of type {1}; expected type: {2}", new Object[]{object, object.getClass().getName(), UsuarioRoler.class.getName()});
            return null;
        }
    }
}
