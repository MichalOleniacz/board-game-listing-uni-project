package org.michaloleniacz.project.persistance.domain;


import org.michaloleniacz.project.preference.dto.PreferenceDto;

import java.util.ArrayList;
import java.util.UUID;

public interface PreferenceRepository {
    public void addPreference(UUID userId, int preferenceId);
    public void removePreference(UUID userId, int preferenceId);
    public void registerNewPreference(String preferenceName);
    public ArrayList<PreferenceDto> getPreferencesForUser(UUID userId);
    public ArrayList<PreferenceDto> getAllPreferences();
}
