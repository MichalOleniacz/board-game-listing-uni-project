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

    public void getUserDetails(RequestContext context) {
        userService.getUserDetails(context);
    }

    public void updateUserDetails(RequestContext context) {
        userService.updateUserDetails(context);
    }

    public void promoteUserToAdmin(RequestContext context) {
        userService.promoteUserToAdmin(context);
    }
}
