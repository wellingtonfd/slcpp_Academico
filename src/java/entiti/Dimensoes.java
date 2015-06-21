/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package entiti;

import java.io.Serializable;
import java.util.Objects;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Gustavo
 */

@Entity
@Table(name = "dimensoes")
@XmlRootElement
@NamedQueries({
@NamedQuery(name = "Dimensoes.findAll", query = "SELECT a FROM Dimensoes a"),
@NamedQuery(name = "Dimensoes.findByIdImensoes", query = "SELECT a FROM Dimensoes a WHERE a.idDimensoes = :idDimensoes")})
public class Dimensoes implements Serializable {
 
    
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id_dimensoes")
    private Integer idDimensoes; 
    
    
    //TODO Mapeamento base de dados
    private double largura;
    
    private double altura;
    
    private double comprimento;

    public double getComprimento() {
        return comprimento;
    }

    public void setComprimento(double comprimento) {
        this.comprimento = comprimento;
    }

    
    /**
     * Dimensões x,y
     * @params double comprimento
     * @params double largura 
     */
    public Dimensoes(double comprimento, double largura) {
        this.largura = largura;
        this.comprimento = comprimento;
    }
        

    public double getLargura() {
        return largura;
    }

    public void setLargura(double largura) {
        this.largura = largura;
    }

    public double getAltura() {
        return altura;
    }

    public void setAltura(double altura) {
        this.altura = altura;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 13 * hash + Objects.hashCode(this.idDimensoes);
        hash = 13 * hash + (int) (Double.doubleToLongBits(this.largura) ^ (Double.doubleToLongBits(this.largura) >>> 32));
        hash = 13 * hash + (int) (Double.doubleToLongBits(this.altura) ^ (Double.doubleToLongBits(this.altura) >>> 32));
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Dimensoes other = (Dimensoes) obj;
        return true;
    }
    
    
    
    
    
    
}
