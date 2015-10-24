/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ui.factory;

import entiti.Roler;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.faces.view.ViewScoped;
import javax.inject.Inject;
import javax.inject.Named;
import reports.jasperConnection;

/**
 *
 * @author sacramento
 */
@Named(value = "rolerController")
@ViewScoped
public class RolerController extends AbstractController<Roler>{
    
    @Inject
    private UsuarioController idUsuarioController;
    
    public RolerController() {
        super(Roler.class);
    }
    
    public  void resetParents(){
        idUsuarioController.setSelected(null);
        
    }
    
    public List<Roler> getRolerList(){
        
        List<Roler> rolers = new ArrayList<Roler>();
        
        ResultSet rs;
        try{
            Connection connection = jasperConnection.getConexao();
            
            String query = "SELECT * FROM roler r ORDER BY r.id_roler;";
            PreparedStatement prepared = connection.prepareStatement(query);
            rs = prepared.executeQuery();
            
            while(rs.next()){
                Roler roler = new Roler();
                roler.setIdRoler(rs.getInt("id_roler"));
                roler.setNomeRoler(rs.getString("nome_roler"));
                roler.setDescricao(rs.getString("descricao"));
                rolers.add(roler);
              
            }
            connection.close();
            
        }catch(Exception e){
            e.printStackTrace();
        }
        
        
        return rolers;
        
    }
    
}
