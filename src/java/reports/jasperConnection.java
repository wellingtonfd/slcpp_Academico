/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reports;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 *
 * @author sacramento
 */
public class jasperConnection {
    
    public static Connection getConexao() throws Exception {
        java.sql.Connection conexao = null;
        try {
            Context initContext = new InitialContext();
            DataSource ds = (DataSource) initContext.lookup("slcpp");
            conexao = (java.sql.Connection) ds.getConnection();
        } catch (NamingException e) {
            throw new Exception("Não foi possível encontrar o nome da conexão do banco.", e);
        } catch (SQLException e) {
            throw new Exception("Ocorreu um erro de SQL.", e);
        }
        return conexao;
    }
    
}
