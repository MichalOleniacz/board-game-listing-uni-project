package org.michaloleniacz.project.user;

import org.michaloleniacz.project.http.HttpStatus;
import org.michaloleniacz.project.http.core.context.RequestContext;
import org.michaloleniacz.project.persistance.domain.UserRepository;
import org.michaloleniacz.project.shared.dto.UserDto;
import org.michaloleniacz.project.shared.error.BadRequestException;
import org.michaloleniacz.project.shared.error.UnauthorizedException;

import java.util.Optional;
import java.util.UUID;

public class UserService {
    private final UserRepository userRepository;
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public void getUserByEmail(RequestContext ctx) {
        if (!(ctx.hasSession() && ctx.getUser().isPresent())) {
            throw new UnauthorizedException("You are not logged in.");
        }

        String email = ctx.getQueryParam("email");

        Optional<UserDto> user = userRepository.findByEmail(email);

        if (user.isEmpty()) {
            throw new BadRequestException("User does not exists.");
        }

        UserDto userDto = user.get();

        ctx.response()
                .json(userDto)
                .status(HttpStatus.OK)
                .send();
    }
}
