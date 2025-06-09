package org.michaloleniacz.project.user;

import org.michaloleniacz.project.http.core.context.RequestContext;
import org.michaloleniacz.project.shared.dto.UserDto;

public class UserController {
    private final UserService userService;
    public UserController(UserService userService) {
        this.userService = userService;
    }

    public void getUserByEmail(RequestContext context) {
        userService.getUserByEmail(context);
    }
}
