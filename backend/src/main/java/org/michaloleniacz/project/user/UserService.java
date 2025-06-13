package org.michaloleniacz.project.user;

import org.michaloleniacz.project.auth.UserRole;
import org.michaloleniacz.project.http.HttpStatus;
import org.michaloleniacz.project.http.core.context.RequestContext;
import org.michaloleniacz.project.persistance.domain.UserRepository;
import org.michaloleniacz.project.shared.dto.UserDto;
import org.michaloleniacz.project.shared.error.BadRequestException;
import org.michaloleniacz.project.shared.error.UnauthorizedException;
import org.michaloleniacz.project.user.dto.PromoteUserToAdminRequestDto;
import org.michaloleniacz.project.user.dto.UserDetailsDto;

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

    public void getUserDetails(RequestContext ctx) {
        if (!(ctx.hasSession() && ctx.getUser().isPresent())) {
            throw new UnauthorizedException("You are not logged in.");
        }

        Optional<UserDto> maybeUser = ctx.getUser();
        if (!maybeUser.isPresent()) {
            throw new BadRequestException("User does not exists.");
        }

        UserDto user = maybeUser.get();

        Optional<UserDetailsDto> maybeUserDetails = userRepository.getUserDetails(user.id());
        if (maybeUserDetails.isEmpty()) {
            throw new BadRequestException("User details not found.");
        }

        ctx.response()
                .json(maybeUserDetails.get())
                .status(HttpStatus.OK)
                .send();
    }

    public void updateUserDetails(RequestContext ctx) {
        if (!(ctx.hasSession() && ctx.getUser().isPresent())) {
            throw new UnauthorizedException("You are not logged in.");
        }

        Optional<UserDto> maybeUser = ctx.getUser();
        if (!maybeUser.isPresent()) {
            throw new BadRequestException("User does not exists.");
        }

        UserDto user = maybeUser.get();
        UserDetailsDto dto = ctx.getParsedBody();

        userRepository.updateUserDetails(user.id(), dto);
        ctx.response()
                .status(HttpStatus.OK)
                .send();
    }

    public void promoteUserToAdmin(RequestContext ctx) {
        if (!(ctx.hasSession() && ctx.getUser().isPresent())) {
            throw new UnauthorizedException("You are not logged in.");
        }

        Optional<UserDto> maybeUser = ctx.getUser();
        if (maybeUser.isEmpty()) {
            throw new BadRequestException("User does not exists.");
        }

        PromoteUserToAdminRequestDto dto = ctx.getParsedBody();

        Optional<UserDto> maybeTargetUser = userRepository.findByEmail(dto.email());
        if (maybeTargetUser.isEmpty()) {
            throw new BadRequestException("User does not exists.");
        }
        UserDto targetUser = maybeTargetUser.get();

        userRepository.updateRole(targetUser.id(), UserRole.ADMIN);
        ctx.response()
                .status(HttpStatus.OK)
                .send();
    }
}
