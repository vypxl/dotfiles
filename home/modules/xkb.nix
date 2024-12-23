{ ... }:
{
  xdg.configFile."xkb/symbols/us-umlaut".text = ''
    default partial alphanumeric_keys
    xkb_symbols "basic" {
        include "us(altgr-intl)"
        name[Group1] = "English (US, international with German umlaut)";
        key <AD07> { [ u, U, udiaeresis, Udiaeresis ] };
        key <AD09> { [ o, O, odiaeresis, Odiaeresis ] };
        key <AC01> { [ a, A, adiaeresis, Adiaeresis ] };
        key <AC02> { [ s, S, ssharp ] };
    };
  '';
}
