package reports;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import javax.faces.context.FacesContext;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
 
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.design.JasperDesign;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.xml.JRXmlLoader;
 
import org.primefaces.model.DefaultStreamedContent;
import org.primefaces.model.StreamedContent;
 
public class RelatorioFunc {
 
     
    public StreamedContent geraRelatorio(HashMap parametrosRelatorio) throws Exception {
         
        StreamedContent arquivoRetorno = null;
 
        try {
            Connection conexao = jasperConnection.getConexao();                
            String jr = FacesContext.getCurrentInstance().getExternalContext().getRealPath("WEB-INF/reports/Relatorio_Funcionario/RelatorioFun.jasper");
            JasperPrint jp = JasperFillManager.fillReport(jr, parametrosRelatorio, conexao);
             
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            JRPdfExporter exporter = new JRPdfExporter();
            exporter.setParameter(JRExporterParameter.JASPER_PRINT, jp);
            exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, baos);
            exporter.exportReport();
 
            ByteArrayInputStream bais = new ByteArrayInputStream(baos.toByteArray());
             
            arquivoRetorno = new DefaultStreamedContent(bais, "pdf", "RelatorioFuncionario.pdf");
             
        } catch (JRException e) {
            e.printStackTrace();
            throw new Exception("Não foi possível gerar o relatório.", e);
        } catch (FileNotFoundException e) {
            throw new Exception("Arquivo do relatório nõo encontrado.", e);
        }
        return arquivoRetorno;
    }
}