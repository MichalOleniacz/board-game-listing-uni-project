package org.michaloleniacz.project.user;

import org.michaloleniacz.project.http.HttpStatus;
import org.michaloleniacz.project.http.core.context.RequestContext;
import org.michaloleniacz.project.persistance.domain.UserRepository;
import org.michaloleniacz.project.shared.dto.UserDto;

import java.util.UUID;

public class UserService {
    private final UserRepository userRepository;
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public void getUser(RequestContext ctx) {
        userRepository.findById(UUID.randomUUID());
        ctx.response().status(HttpStatus.OK).send();
    }
}
