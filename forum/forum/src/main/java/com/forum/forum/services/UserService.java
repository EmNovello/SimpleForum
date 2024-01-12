package com.forum.forum.services;

import com.forum.forum.entities.User;
import com.forum.forum.repositories.UserRepository;
import com.forum.forum.supports.exceptions.UserAlreadyExistsByEmailException;
import com.forum.forum.supports.exceptions.UserAlreadyExistsByUsernameException;
import com.forum.forum.supports.exceptions.UserNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Page;
import java.util.*;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.KeycloakBuilder;
import org.keycloak.OAuth2Constants;
import org.keycloak.representations.idm.UserRepresentation;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.admin.client.resource.UsersResource;
import org.keycloak.representations.idm.CredentialRepresentation;
import javax.ws.rs.core.Response;
import org.keycloak.representations.idm.RoleRepresentation;
import org.keycloak.admin.client.CreatedResponseUtil;


@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;
    @Value("${keycloak.auth-server-url}")
    private String urlServer;
    @Value("${keycloak.realm}")
    private String realm;
    @Value("${keycloak.resource}")
    private String clientId;
    @Value("${custom-properties.client-secret}")
    private String clientSecret;
    @Value("${custom-properties.admin-username}")
    private String adminUsername;
    @Value("${custom-properties.admin-password}")
    private String adminPassword;


    @Transactional(readOnly = true, propagation = Propagation.REQUIRED)
    public List<User> getByUsernameContaining(String username, int pageNumber, int pageSize) {
        Pageable pag = PageRequest.of(pageNumber, pageSize);
        Page<User> pagRes = userRepository.findByUsernameContaining(username, pag);
        return pagRes.getContent();
    }

    @Transactional(readOnly = true, propagation = Propagation.REQUIRES_NEW)
    public User getByEmail(String email) throws UserNotFoundException {
        User res = userRepository.findByEmail(email);
        if (res != null) {
            return res;
        } else {
            throw new UserNotFoundException();
        }
    }

    @Transactional(readOnly = true, propagation = Propagation.REQUIRED)
    public List<User> getAllUsers(int pageNumber, int pageSize) {
        Pageable paging = PageRequest.of(pageNumber, pageSize);
        Page<User> pagedResult = userRepository.TakeAll(paging);
        if (pagedResult.hasContent())
            return pagedResult.getContent();
        else
            return new ArrayList<>();
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public User registerUser(User user) throws UserAlreadyExistsByEmailException, UserAlreadyExistsByUsernameException {
        if (userRepository.existsByEmail(user.getEmail()))
            throw new UserAlreadyExistsByEmailException();
        if (userRepository.existsByUsername(user.getUsername()))
            throw new UserAlreadyExistsByUsernameException();

        Keycloak keycloak = KeycloakBuilder.builder()
                .serverUrl(urlServer)
                .realm(realm)
                .grantType(OAuth2Constants.PASSWORD)
                .clientId(clientId)
                .clientSecret(clientSecret)
                .username(adminUsername)
                .password(adminPassword)
                .build();

        User added = userRepository.save(user);

        // Define user
        UserRepresentation userKeycloak = new UserRepresentation();
        userKeycloak.setEnabled(true);
        userKeycloak.setUsername(added.getEmail());
        userKeycloak.setFirstName(added.getUsername());
        userKeycloak.setLastName("");

        if (userKeycloak.getUsername() != null)
            userKeycloak.setAttributes(Collections.singletonMap("username", Collections.singletonList(added.getUsername())));

        // Get realm
        RealmResource realmResource = keycloak.realm(realm);
        UsersResource usersResource = realmResource.users();

        CredentialRepresentation passwordCred = new CredentialRepresentation();
        passwordCred.setTemporary(false);
        passwordCred.setType(CredentialRepresentation.PASSWORD);
        passwordCred.setValue(added.getPassword());
        List<CredentialRepresentation> list = new LinkedList<>();
        list.add(passwordCred);
        userKeycloak.setCredentials(list);

        Response response = usersResource.create(userKeycloak);
        String userId = CreatedResponseUtil.getCreatedId(response);
        System.out.printf("User created with userId: %s%n", userId);

        List<RoleRepresentation> roles = usersResource.get(userId).roles().realmLevel().listAvailable();
        RoleRepresentation role = roles.stream().filter(r -> r.getName().equals("user_role")).findFirst().orElse(null);
        usersResource.get(userId).roles().realmLevel().add(Collections.singletonList(role));

        return added;
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void deleteUser(long userId) throws UserNotFoundException {
        if (!userRepository.existsById(userId))
            throw new UserNotFoundException();

        User user = userRepository.getById(userId);
        long id = userRepository.findByEmail(user.getEmail()).getId();
        userRepository.deleteById(id);

        Keycloak keycloak = KeycloakBuilder.builder()
                .serverUrl(urlServer)
                .realm(realm)
                .grantType(OAuth2Constants.PASSWORD)
                .clientId(clientId)
                .clientSecret(clientSecret)
                .username(adminUsername)
                .password(adminPassword)
                .build();
        List<UserRepresentation> userList = keycloak.realm(realm).users().search(user.getEmail());
        for (UserRepresentation userRepresentation : userList) {
            if (userRepresentation.getUsername().equals(user.getEmail().toLowerCase())) {
                keycloak.realm(realm).users().delete(userRepresentation.getId());
            }
        }
    }
}