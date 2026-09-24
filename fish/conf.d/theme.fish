status is-interactive; or return

fish_config theme choose mine

# pure prompt colors are not fish theme variables, so they get their own light/dark switch
function __theme_pure --argument-names mode
    switch $mode
        case light
            set -g pure_color_current_directory 0969da
            set -g pure_color_success 8250df
            set -g pure_color_prompt_on_success 8250df
            set -g pure_color_prompt_on_error cf222e
            set -g pure_color_mute 6e7781
        case '*'
            set -g pure_color_current_directory 73D0FF
            set -g pure_color_success DBF
            set -g pure_color_prompt_on_success DBF
            set -g pure_color_prompt_on_error EE1111
            set -g pure_color_mute brblack
    end
end
function __theme_pure_on_change --on-variable fish_terminal_color_theme
    __theme_pure $fish_terminal_color_theme
end
__theme_pure $fish_terminal_color_theme
