package org.michaloleniacz.project.preference.dto;

import java.util.ArrayList;

public record UserPreferencesResponseDto (
    ArrayList<PreferenceDto> preferences
) {}
