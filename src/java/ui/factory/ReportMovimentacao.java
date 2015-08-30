/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ui.factory;

import java.util.Date;
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
@ManagedBean(name = "ReportMovimentacao")
public class ReportMovimentacao {

    private StreamedContent arquivoRetorno;
    private String nomeReport = "Relatorio Movimentacao";
    private Date dtInicial;
    private Date dtFinal;

    public Date getDtInicial() {
        return dtInicial;
    }

    public void setDtInicial(Date dtInicial) {
        this.dtInicial = dtInicial;
    }

    public Date getDtFinal() {
        return dtFinal;
    }

    public void setDtFinal(Date dtFinal) {
        this.dtFinal = dtFinal;
    }
    
    public String getNomeReport() {
        return nomeReport;
    }

    String jr = FacesContext.getCurrentInstance().getExternalContext().getRealPath("WEB-INF/reports/Relatorio_Movimentacao/lotePorProduto.jasper");

    public StreamedContent getArquivoRetorno() {
        FacesContext context = FacesContext.getCurrentInstance();
        ReportUtil ru = new ReportUtil();
        HashMap parametrosRelatorio = new HashMap();
        parametrosRelatorio.put("datainicial",dtInicial );
        parametrosRelatorio.put("datafinal",dtFinal );
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
