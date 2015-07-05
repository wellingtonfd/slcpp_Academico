/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ui.factory;

import java.util.HashMap;
import javax.faces.bean.ManagedBean;
import org.primefaces.model.StreamedContent;
import reports.ReportUtil;
import javax.faces.context.FacesContext;
import javax.faces.application.FacesMessage;

/**
 *
 * @author sacramento
 */
@ManagedBean(name = "reportIncomp")
public class ReportIncomp {

    private StreamedContent arquivoRetorno;
    String jr = FacesContext.getCurrentInstance().getExternalContext().getRealPath("WEB-INF/reports/Incompatibilidade.jasper");
    private int produto;
    private String nomeReport = "Incompatibilidade";

    public String getNomeReport() {
        return nomeReport;
    }

    public int getProduto() {
        return produto;
    }

    public void setProduto(int produto) {
        this.produto = produto;
    }

    public StreamedContent getArquivoRetorno() {
        FacesContext context = FacesContext.getCurrentInstance();
        ReportUtil ru = new ReportUtil();
        HashMap incompatibilidade = new HashMap();
        incompatibilidade.put("produto", produto);

        try {
            this.arquivoRetorno = ru.geraRelatorio(incompatibilidade,jr,nomeReport);
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
