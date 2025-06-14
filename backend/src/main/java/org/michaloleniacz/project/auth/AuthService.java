package org.michaloleniacz.project.auth;

import org.michaloleniacz.project.auth.dto.AuthLoginRequestDto;
import org.michaloleniacz.project.auth.dto.AuthRegisterRequestDto;
import org.michaloleniacz.project.auth.dto.AuthAttemptResponseDto;
import org.michaloleniacz.project.config.AppConfig;
import org.michaloleniacz.project.http.HttpStatus;
import org.michaloleniacz.project.http.core.context.RequestContext;
import org.michaloleniacz.project.persistance.domain.SessionRepository;
import org.michaloleniacz.project.persistance.domain.UserRepository;
import org.michaloleniacz.project.session.Session;
import org.michaloleniacz.project.shared.dto.UserDto;
import org.michaloleniacz.project.shared.error.BadRequestException;
import org.michaloleniacz.project.shared.error.InternalServerErrorException;
import org.michaloleniacz.project.shared.error.UnauthorizedException;
import org.michaloleniacz.project.user.User;
import org.michaloleniacz.project.util.Logger;
import org.michaloleniacz.project.util.passwordHasher.PasswordHasherStrategy;

import java.time.Instant;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Stream;

public class AuthService {
    private final UserRepository userRepository;
    private final SessionRepository sessionRepository;
    private final PasswordHasherStrategy passwordHasherImpl;
    private final AppConfig appConfig = AppConfig.getInstance();
    private final int sessionTTL = appConfig.getInt("auth.session.ttl", 3600);
    private final String redirectUrl = appConfig.get("auth.redirectUrl");
    private final String logoutUrl = appConfig.get("auth.logoutUrl");
    private final String sessionCookieName = appConfig.get("session.cookie.name");

    private final AuthAttemptResponseDto authSuccessResponseDto = new AuthAttemptResponseDto(true, redirectUrl);
    private final AuthAttemptResponseDto authFailureResponseDto = new AuthAttemptResponseDto(false, logoutUrl);

    public AuthService(UserRepository userRepository, SessionRepository sessionRepository, PasswordHasherStrategy passwordHasherImpl) {
        this.userRepository = userRepository;
        this.sessionRepository = sessionRepository;
        this.passwordHasherImpl = passwordHasherImpl;
    }

    public void login(RequestContext ctx) {
        AuthLoginRequestDto dto = ctx.getParsedBody();

        Optional<User> maybeExistingUser = userRepository.findFullUserByEmail(dto.email());
        if (maybeExistingUser.isEmpty()) {
            throw new BadRequestException("Email not found.");
        }

        User existingUser = maybeExistingUser.get();

        String hashedPassword = passwordHasherImpl.hash(dto.password());
        if (!Objects.equals(hashedPassword, existingUser.passwordHash())) {
            throw new BadRequestException("Password does not match.");
        }

        String sessionToken = UUID.randomUUID().toString();
        Session newSession = new Session(
                sessionToken,
                existingUser.id(),
                Instant.now(),
                Instant.now().plusSeconds(sessionTTL)
        );

        sessionRepository.save(newSession);

        ctx.response()
                .status(HttpStatus.OK)
                .json(authSuccessResponseDto)
                .header("Set-Cookie", sessionCookieName + "=" + sessionToken.toString() + "; Max-Age=" + sessionTTL +"; Path=/; HttpOnly; SameSite=Lax")
                .send();
    }

    public void register(RequestContext ctx) throws InternalServerErrorException, BadRequestException {
        if (ctx.hasSession()) {
            ctx.response()
                    .status(HttpStatus.OK)
                    .json(authSuccessResponseDto)
                    .send();
            return;
        }

        AuthRegisterRequestDto dto = ctx.getParsedBody();

        Optional<UserDto> maybeExistingUser = userRepository.findByEmail(dto.email());
        if (maybeExistingUser.isPresent()) {
            throw new BadRequestException("Email already exists.");
        }

        if (Stream.of(dto.email(), dto.password(), dto.username()).anyMatch(String::isEmpty)) {
            throw new BadRequestException("All fields are required.");
        };

        UUID uuid = UUID.randomUUID();

        Logger.debug("Registering new user: " + uuid);

        User newUser = new User(
                uuid,
                dto.username(),
                dto.email(),
                passwordHasherImpl.hash(dto.password()),
                UserRole.USER
        );

        if (!userRepository.add(newUser)) {
            throw new InternalServerErrorException("Error creating new user in database");
        };

        String sessionToken = UUID.randomUUID().toString();
        Session newSession = new Session(
                sessionToken,
                uuid,
                Instant.now(),
                Instant.now().plusSeconds(sessionTTL)
        );

        sessionRepository.save(newSession);
        ctx.response()
                .status(HttpStatus.OK)
                .json(authSuccessResponseDto)
                .header("Set-Cookie", sessionCookieName + "=" + sessionToken.toString() + "; Max-Age=3600; Path=/; HttpOnly; SameSite=Lax")
                .send();
    }

    public void logout(RequestContext ctx) {
        if (!ctx.hasSession()) {
            throw new UnauthorizedException("You are not logged in.");
        }

        Optional<Session> maybeSession = ctx.getSession();
        if (maybeSession.isEmpty()) {
            throw new UnauthorizedException("You are not logged in.");
        }

        Session session = maybeSession.get();
        try {
            sessionRepository.delete(session);
            ctx.response()
                    .header("Set-Cookie", "SESSIONID=; Max-Age=0; Path=/; SameSite=Lax; HttpOnly")
                    .json(authFailureResponseDto)
                    .status(HttpStatus.OK)
                    .send();
        } catch (Exception e) {
            throw new InternalServerErrorException("Error deleting session.");
        }
    }
}
