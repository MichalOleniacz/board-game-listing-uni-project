package org.michaloleniacz.project.preference;

import org.michaloleniacz.project.http.core.context.RequestContext;

public class PreferenceController {
    private PreferenceService preferenceService;
    public PreferenceController(PreferenceService preferenceService) {
        this.preferenceService = preferenceService;
    }

    public void getPreferencesForUser(RequestContext context) {
        preferenceService.getPreferencesForUser(context);
    }

    public void getAllPreferences(RequestContext context) {
        preferenceService.getAllPreferences(context);
    }

    public void removePreference(RequestContext context) {
        preferenceService.removePreference(context);
    }

    public void addPreference(RequestContext context) {
        preferenceService.addPreference(context);
    }
}
