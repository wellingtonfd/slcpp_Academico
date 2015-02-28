/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utils.security;

import javax.faces.context.FacesContext;
import javax.faces.application.FacesMessage;
import javax.faces.bean.SessionScoped;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 *
 * @author sacramento
 */
@SessionScoped
public class AccountController {

    @Autowired
    @Qualifier("jdbcUserDetailsManager")
    private JdbcUserDetailsManager jdbcUserDetailsManager;

    FacesContext context = FacesContext.getCurrentInstance();

    @RequestMapping(value = "/WEB-INF/include/configuracoes/alterarSenha.jsf", method = RequestMethod.GET)

    public void showChangePasswordPage() {
        FacesMessage mensagem = new FacesMessage(
                "Senha Alterada!!");
        mensagem.setSeverity(FacesMessage.SEVERITY_ERROR);
        context.addMessage(null, mensagem);
    }

    @RequestMapping(value = "/WEB-INF/include/configuracoes/alterarSenha.jsf", method = RequestMethod.POST)

    public String submitChangePasswordPage(@RequestParam("oldpassword") String oldPassword, @RequestParam("password") String newPassword) {
        jdbcUserDetailsManager.changePassword(oldPassword, newPassword);
        SecurityContextHolder.clearContext();
        return "/index";
    }

}
