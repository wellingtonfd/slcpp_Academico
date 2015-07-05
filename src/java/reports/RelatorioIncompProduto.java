package reports;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.sql.Connection;
import java.util.HashMap;
import javax.faces.context.FacesContext;
 
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.export.JRPdfExporter;
 
import org.primefaces.model.DefaultStreamedContent;
import org.primefaces.model.StreamedContent;
 
public class RelatorioIncompProduto {
         
    public StreamedContent geraRelatorio(HashMap parametrosRelatorio) throws Exception {
         
        StreamedContent arquivoRetorno = null;
 
        try {
            Connection conexao = jasperConnection.getConexao();                
            String jr = FacesContext.getCurrentInstance().getExternalContext().getRealPath("WEB-INF/reports/Incompatibilidade.jasper");
            JasperPrint jp = JasperFillManager.fillReport(jr, parametrosRelatorio, conexao);
             
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            JRPdfExporter exporter = new JRPdfExporter();
            exporter.setParameter(JRExporterParameter.JASPER_PRINT, jp);
            exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, baos);
            exporter.exportReport();
 
            ByteArrayInputStream bais = new ByteArrayInputStream(baos.toByteArray());
             
            arquivoRetorno = new DefaultStreamedContent(bais, "pdf", "ProdutoIncompativeis.pdf");
             
        } catch (JRException e) {
            e.printStackTrace();
            throw new Exception("Não foi possível gerar o relatório.", e);
        } catch (FileNotFoundException e) {
            throw new Exception("Arquivo do relatório nõo encontrado.", e);
        }
        return arquivoRetorno;
    }
}