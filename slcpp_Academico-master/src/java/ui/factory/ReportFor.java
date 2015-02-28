/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ui.factory;

import java.util.HashMap;
import javax.faces.bean.ManagedBean;
import org.primefaces.model.StreamedContent;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.application.FacesMessage;
import reports.RelatorioFor;
 


/**
 *
 * @author sacramento
 */

@ManagedBean(name = "reportFor")
public class ReportFor {
 
    private StreamedContent arquivoRetorno;
     
    public StreamedContent getArquivoRetorno() {
        FacesContext context = FacesContext.getCurrentInstance();
        RelatorioFor ru = new RelatorioFor();
        HashMap parametrosRelatorio = new HashMap();
        try {
            this.arquivoRetorno = ru.geraRelatorio(parametrosRelatorio);
        } catch (Exception e) {
            context.addMessage(null, new FacesMessage(e.getMessage()));
            return null;
        }         
        return this.arquivoRetorno;
    }    
    public void setArquivoRetorno(StreamedContent arquivoRetorno) {
        this.arquivoRetorno = arquivoRetorno;
    }    
}