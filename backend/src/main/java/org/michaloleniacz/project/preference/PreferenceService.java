package org.michaloleniacz.project.preference;

import org.michaloleniacz.project.http.HttpStatus;
import org.michaloleniacz.project.http.core.context.RequestContext;
import org.michaloleniacz.project.persistance.domain.PreferenceRepository;
import org.michaloleniacz.project.preference.dto.AddPreferenceRequestDto;
import org.michaloleniacz.project.preference.dto.PreferenceDto;
import org.michaloleniacz.project.preference.dto.RemovePreferenceRequestDto;
import org.michaloleniacz.project.preference.dto.UserPreferencesResponseDto;
import org.michaloleniacz.project.shared.dto.UserDto;
import org.michaloleniacz.project.shared.error.InternalServerErrorException;
import org.michaloleniacz.project.shared.error.UnauthorizedException;

import java.util.ArrayList;
import java.util.Optional;

public class PreferenceService {
    private PreferenceRepository repository;
    public PreferenceService(PreferenceRepository repository) {
        this.repository = repository;
    }

    public void getPreferencesForUser(RequestContext ctx) {
        Optional<UserDto> maybeUser = ctx.getUser();
        if (maybeUser.isEmpty()) {
            throw new UnauthorizedException("You are not allowed to access these preferences");
        }

        UserDto user = maybeUser.get();

        try {
            final ArrayList<PreferenceDto> preferences = repository.getPreferencesForUser(user.id());
            UserPreferencesResponseDto res = new UserPreferencesResponseDto(preferences);
            ctx.response()
                    .status(HttpStatus.OK)
                    .json(res)
                    .send();
        } catch (Exception e) {
            throw new InternalServerErrorException(HttpStatus.INTERNAL_SERVER_ERROR.getReason());
        }
    }

    public void addPreference(RequestContext ctx) {
        Optional<UserDto> maybeUser = ctx.getUser();
        if (maybeUser.isEmpty()) {
            throw new UnauthorizedException("You are not allowed to access these preferences");
        }

        UserDto user = maybeUser.get();
        AddPreferenceRequestDto body = ctx.getParsedBody();

        try {
            repository.addPreference(user.id(), body.preferenceId());
            ctx.response()
                    .status(HttpStatus.CREATED)
                    .send();
        } catch (Exception e) {
            throw new InternalServerErrorException(HttpStatus.INTERNAL_SERVER_ERROR.getReason());
        }
    }

    public void removePreference(RequestContext ctx) {
        Optional<UserDto> maybeUser = ctx.getUser();
        if (maybeUser.isEmpty()) {
            throw new UnauthorizedException("You are not allowed to access these preferences");
        }

        UserDto user = maybeUser.get();
        RemovePreferenceRequestDto body = ctx.getParsedBody();

        try {
            repository.removePreference(user.id(), body.preferenceId());
            ctx.response()
                    .status(HttpStatus.OK)
                    .send();
        } catch (Exception e) {
            throw new InternalServerErrorException(HttpStatus.INTERNAL_SERVER_ERROR.getReason());
        }
    }

    public void getAllPreferences(RequestContext ctx) {
        try {
            final ArrayList<PreferenceDto> preferences = repository.getAllPreferences();
            ctx.response()
                    .status(HttpStatus.OK)
                    .json(new UserPreferencesResponseDto(preferences))
                    .send();
        } catch (Exception e) {
            throw new InternalServerErrorException(HttpStatus.INTERNAL_SERVER_ERROR.getReason());
        }
    }
}
