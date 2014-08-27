package br.com.login;

import java.io.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperRunManager;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.HashMap;

@WebServlet("/Relatorio")
 public class Relatorio extends HttpServlet {
   static final long serialVersionUID = 1L;
   
   private Connection getConnection(){
       Connection connection=null;
  try {
          //cria a conex�o com o banco de dados
          Class.forName("org.postgresql.Driver");
          String db = "jdbc:postgresql://localhost:5432/academico/?user=postgres&1234=";
          connection = DriverManager.getConnection(db);
         
      } catch (SQLException ex) {
          ex.printStackTrace();
      } catch (ClassNotFoundException ex) {
          ex.printStackTrace();
      }
          
     return connection;  
     
       
  }
  
  protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

      ServletOutputStream servletOutputStream = response.getOutputStream();
      
      String caminho = "/relatorios/";
      String relatorio = caminho+"users.jasper";
      InputStream reportStream = getServletConfig().
              getServletContext().
              getResourceAsStream(relatorio);
     
      ServletContext context = getServletContext();
      
      try {
          
          Connection connection = getConnection();
          //caminho da imagem
          HashMap<String, String> map = new HashMap<String, String>();
          map.put("IMAGE_PATH", context.getRealPath(caminho)+File.separator);

          //para gerar o relatorio em PDF
          // o m�todo runReportToPdfStream foi usado
          JasperRunManager.runReportToPdfStream(reportStream, servletOutputStream, map,connection);
          
          // envia o relat�rio em formato PDF para o browser
          response.setContentType("application/pdf");
          servletOutputStream.flush();
          servletOutputStream.close();
          if(connection!=null)connection.close();
      } catch (SQLException ex) {
              Logger.getLogger("global").log(Level.SEVERE, null, ex);
      }
      catch (JRException e) {
          // display stack trace in the browser
          StringWriter stringWriter = new StringWriter();
          PrintWriter printWriter = new PrintWriter(stringWriter);
          e.printStackTrace(printWriter);
          response.setContentType("text/plain");
          response.getOutputStream().print(stringWriter.toString());
      }

      
  } 	
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		processRequest(request, response);
	}  	
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		processRequest(request, response);
	}   	  	    
}