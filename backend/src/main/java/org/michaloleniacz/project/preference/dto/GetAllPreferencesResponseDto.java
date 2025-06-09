package org.michaloleniacz.project.preference.dto;

import java.util.ArrayList;

public record GetAllPreferencesResponseDto (
        ArrayList<PreferenceDto> preferences
) { }
