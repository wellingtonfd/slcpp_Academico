/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ui.factory;

import java.util.HashMap;
import javax.faces.bean.ManagedBean;
import org.primefaces.model.StreamedContent;
import javax.faces.context.FacesContext;
import javax.faces.application.FacesMessage;
import reports.ReportUtil;

/**
 *
 * @author sacramento
 */
@ManagedBean(name = "ReportEpi")
public class ReportEpi {

    private StreamedContent arquivoRetorno;
    private String nomeReport = "Relatorio EPI";

    public String getNomeReport() {
        return nomeReport;
    }

    String jr = FacesContext.getCurrentInstance().getExternalContext().getRealPath("WEB-INF/reports/Relatorio_Epe/RelatorioEpi.jasper");

    public StreamedContent getArquivoRetorno() {
        FacesContext context = FacesContext.getCurrentInstance();
        ReportUtil ru = new ReportUtil();
        HashMap parametrosRelatorio = new HashMap();
        try {
            this.arquivoRetorno = ru.geraRelatorio(parametrosRelatorio,jr,nomeReport);
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