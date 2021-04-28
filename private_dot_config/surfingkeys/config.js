settings.hintAlign = 'left';
settings.modeAfterYank = 'Normal';
settings.omnibarPosition = 'bottom';

settings.theme = `
.sk_theme {
    font-family: JetBrainsMono Nerd Font, JetBrainsMono, Ubuntu Mono, monospace;
    font-size: 14px;
    background: #282828;
    color: #ebdbb2;
}
.sk_theme tbody {
    color: #b8bb26;
}
.sk_theme input {
    color: #d9dce0;
}
.sk_theme .url {
    color: #98971a;
}
.sk_theme .annotation {
    color: #b16286;
}
.sk_theme .omnibar_highlight {
    color: #ebdbb2;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
    background: #282828;
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
    background: #d3869b;
}
#sk_status, #sk_find {
    font-size: 20pt;
}
`;

// disable emoji completion
iunmap(':');
