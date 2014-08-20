package br.com.login;


/**
 *
 * @author Administrador
 * @author Wellington Duarte
 */
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import br.com.login.Conexao;
import java.sql.Connection;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.RequestScoped;
import javax.faces.context.FacesContext;


@ManagedBean
@RequestScoped
public class Logar {

    /**
     * Creates a new instance of Logar
     */
    public static String login;
    public static String senha;
    private Conexao conectar;    
    public static Connection con = null;
    private String conectou = "Digite o usuário e senha";
    
    
    public Logar() {
    }

    /**
     * @return the usuario
     */
    public String getLogin() {
        return login;
    }

    /**
     * @param usuario the usuario to set
     */
    public void setLogin(String login) {
        this.login = login;
    }

    /**
     * @return the senha
     */
    public String getSenha() {
        return senha;
    }

    /**
     * @param senha the senha to set
     */
    public void setSenha(String senha) {
        this.senha = senha;
    }
    
   
    /**
     * @return the conectou
     */
    public String getConectou() {
        return conectou;
    }

    /**
     * @param conectou the conectou to set
     */
    public void setConectou(String conectou) {
        this.conectou = conectou;
    }
    
     public void logar()
    {       
       try{ 
        con = conectar.conectar(login, senha);
        if(con != null){            
                setConectou("OK");
                FacesContext.getCurrentInstance().getExternalContext().redirect("acessoAdmin.jsf");
            }
        else {            
                setConectou("Usuário e/ou senha inválidos");
        }
       } catch(Exception erro)
       {
        setConectou("Houve erro de conexão ->"+erro.getMessage());
       }          
    }   
     
       public Connection logarRetorno()
    {       
       try{ 
        con = conectar.conectar(login, senha);
        return con;
       } catch(Exception erro)
       {
        return null;
       }          
    }  
     
     public void encerrar()
     {
         conectar.encerrarSessao();
         con = null;
     }        
                    
}
