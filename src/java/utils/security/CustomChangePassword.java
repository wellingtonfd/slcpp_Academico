/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utils.security;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ApplicationContextException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserCache;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.cache.NullUserCache;
import org.springframework.security.core.userdetails.jdbc.JdbcDaoImpl;
import org.springframework.security.provisioning.UserDetailsManager;

/**
 *
 * @author sacramento
 */
public class CustomChangePassword extends JdbcDaoImpl implements UserDetailsManager {

    public static final String DEF_CHANGE_PASSWORD_SQL = "update usuario set senha = ? where login = ?";

    protected final Log loggerC = LogFactory.getLog(getClass());

    private final String changePasswordSql = DEF_CHANGE_PASSWORD_SQL;

    private AuthenticationManager authenticationManager;

    private final UserCache userCache = new NullUserCache();
    
    
    @Override
    protected void initDao() throws ApplicationContextException {
        if (authenticationManager == null) {
            loggerC.info("No authentication manager set. Reauthentication of users when changing passwords will " +
                    "not be performed.");
        }

        super.initDao();
    }

    @Override
    public void createUser(UserDetails ud) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void updateUser(UserDetails ud) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void deleteUser(String string) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void changePassword(String oldPassword, String newPassword) throws AuthenticationException {
        Authentication currentUser = SecurityContextHolder.getContext().getAuthentication();

        if (currentUser == null) {
            // This would indicate bad coding somewhere
            throw new AccessDeniedException("Can't change password as no Authentication object found in context " +
                    "for current user.");
        }

        String username = currentUser.getName();

        // If an authentication manager has been set, re-authenticate the user with the supplied password.
        if (authenticationManager != null) {
            loggerC.debug("Reauthenticating user '"+ username + "' for password change request.");

            authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(username, oldPassword));
        } else {
            loggerC.debug("No authentication manager set. Password won't be re-checked.");
        }

        loggerC.debug("Changing password for user '"+ username + "'");

        getJdbcTemplate().update(changePasswordSql, newPassword, username);

        SecurityContextHolder.getContext().setAuthentication(createNewAuthentication(currentUser, newPassword));

        userCache.removeUserFromCache(username);
    }

    @Override
    public boolean userExists(String string) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    protected Authentication createNewAuthentication(Authentication currentAuth, String newPassword) {
        UserDetails user = loadUserByUsername(currentAuth.getName());

        UsernamePasswordAuthenticationToken newAuthentication =
                new UsernamePasswordAuthenticationToken(user, null, user.getAuthorities());
        newAuthentication.setDetails(currentAuth.getDetails());

        return newAuthentication;
    }

}
