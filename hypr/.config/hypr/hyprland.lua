-- ==========================================
-- 1. MONITORES
-- ==========================================
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- ==========================================
-- 2. PROGRAMAS PADRÃO (STACK LEVE)
-- ==========================================
local terminal    = "footclient"
local fileManager = "thunar"
local menu        = "fuzzel"

-- ==========================================
-- 3. AUTOSTART
-- ==========================================
hl.on("hyprland.start", function()
hl.exec_cmd("waybar")
hl.exec_cmd("mako")
hl.exec_cmd("hypridle")
hl.exec_cmd("foot --server")
hl.exec_cmd("systemctl --user start hyprpolkitagent")

-- Monitora texto e imagens copiadas
hl.exec_cmd("wl-paste --type text --watch cliphist store")
hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

-- ==========================================
-- 4. VARIÁVEIS DE AMBIENTE (WAYLAND NATIVO)
-- ==========================================
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("LIBVA_DRIVER_NAME", "iHD")

-- ==========================================
-- 5. CONFIGURAÇÃO UNIFICADA (PERFORMANCE)
-- ==========================================
hl.config({
    general = {
        gaps_in          = 1,
        gaps_out         = 0,
        border_size      = 1,
        col = {
            active_border   = "rgba(33ccffee)",
          inactive_border = "rgba(595959aa)",
        },
        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding         = 0,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = false,
        },
        blur = {
            enabled = false,
        },
    },

    animations = {
        enabled = false,
    },

    misc = {
        vrr                      = 1,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms  = true,
        key_press_enables_dpms   = true,
        force_default_wallpaper  = 0,
    },

    dwindle = {
        preserve_split = true,
        smart_split    = false,
    },

    layers = {
        allow_new_top_layers_over_existing_fullscreen = true,
    },

    input = {
        kb_layout    = "br",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
})

-- ==========================================
-- 6. ATALHOS DE TECLADO
-- ==========================================
local mainMod = "SUPER"

-- Aplicativos e Janelas
hl.bind(mainMod .. " + Q",         hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + D",         hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + C",         hl.dsp.window.close())
hl.bind(mainMod .. " + V",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",         hl.dsp.window.pseudo())      -- Mantém tamanho original da janela dentro do tiling
hl.bind(mainMod .. " + J",         hl.dsp.layout("togglesplit")) -- Alterna divisão entre vertical e horizontal
hl.bind(mainMod .. " + L",         hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + M",         hl.dsp.exit())
hl.bind(mainMod .. " + Escape",    hl.dsp.exec_cmd("~/.config/hypr/powermenu.sh"))
hl.bind(mainMod .. " + B",         hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))

-- Histórico de Clipboard, Consulta de Atalhos e OCR
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu -p 'Clipboard: ' | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + H",         hl.dsp.exec_cmd([[sh -c 'grep -E "hl\.bind\(" ~/.config/hypr/hyprland.lua | fuzzel --dmenu -w 80']]))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | tesseract stdin stdout -l por+eng | tr -d '\f' | wl-copy]]))

-- Capturas de Tela (Área no clipboard / Tela cheia em ~/Imagens)
hl.bind("Print",           hl.dsp.exec_cmd([[sh -c 'grim -g "$(slurp)" - | wl-copy']]))
hl.bind("SHIFT + Print",   hl.dsp.exec_cmd([[sh -c 'mkdir -p "$HOME/Imagens" && grim "$HOME/Imagens/screenshot_$(date +%Y%m%d_%H%M%S).png"']]))
hl.bind("SHIFT + Sys_Req", hl.dsp.exec_cmd([[sh -c 'mkdir -p "$HOME/Imagens" && grim "$HOME/Imagens/screenshot_$(date +%Y%m%d_%H%M%S).png"']]))

-- Alternância de Janelas e Workspaces (Tab e Fuzzel)
hl.bind("ALT + Tab",         hl.dsp.exec_cmd([[hyprctl --batch "dispatch cyclenext ; dispatch bringactivetotop"]]))
hl.bind("ALT + SHIFT + Tab", hl.dsp.exec_cmd([[hyprctl --batch "dispatch cyclenext prev ; dispatch bringactivetotop"]]))
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("hyprctl dispatch workspace previous"))
hl.bind(mainMod .. " + W",   hl.dsp.exec_cmd([[sh -c 'addr=$(hyprctl clients -j | jq -r ".[] | select(.mapped == true) | \"[\(.workspace.name)] \(.class) - \(.title) | \(.address)\"" | fuzzel --dmenu -w 75 | sed "s/.*| //"); [ -n "$addr" ] && hyprctl dispatch focuswindow "address:$addr"']]))

-- Notificações (Mako)
hl.bind(mainMod .. " + BackSpace",         hl.dsp.exec_cmd("makoctl dismiss"))
hl.bind(mainMod .. " + SHIFT + BackSpace", hl.dsp.exec_cmd("makoctl dismiss -a"))
hl.bind(mainMod .. " + CTRL + BackSpace",  hl.dsp.exec_cmd("makoctl restore"))
hl.bind(mainMod .. " + SHIFT + D",         hl.dsp.exec_cmd([[sh -c 'if makoctl mode | grep -q "dnd"; then makoctl mode -r dnd && notify-send -u low -t 2000 "Notificações" "Modo normal ativado"; else notify-send -u low -t 1500 "Notificações" "Não Perturbe ativado" && sleep 1.6 && makoctl mode -a dnd; fi']]))

-- Foco nas Janelas (Setas)
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Mouse (Mover e Redimensionar Flutuantes)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Controles Multimídia e Brilho
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- ==========================================
-- 7. WORKSPACES (1-10, 11-20, NOVO E FIXOS)
-- ==========================================

-- Workspaces 1 a 10
for i = 1, 10 do
    local key = tostring(i % 10)
    hl.bind(mainMod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + ALT + " .. key,     hl.dsp.window.move({ workspace = i, silent = true }))
    end

    -- Workspaces 11 a 20 (Modificador CTRL)
for i = 1, 10 do
    local key = tostring(i % 10)
    local ws  = i + 10
    hl.bind(mainMod .. " + CTRL + " .. key,         hl.dsp.focus({ workspace = ws }))
    hl.bind(mainMod .. " + CTRL + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws }))
    hl.bind(mainMod .. " + CTRL + ALT + " .. key,   hl.dsp.window.move({ workspace = ws, silent = true }))
    end
--[ESSE BLOCO ABAIXO NÃO FUNCIONA]
-- Criar novo workspace sempre além do maior aberto (ex: 11, 12...)
hl.bind(mainMod .. " + N",       hl.dsp.exec_cmd([[sh -c 'next=$(hyprctl workspaces -j | jq "[.[].id | select(. > 0)] | (max // 0) + 1"); hyprctl dispatch workspace "$next"']]))
hl.bind(mainMod .. " + ALT + N", hl.dsp.exec_cmd([[sh -c 'next=$(hyprctl workspaces -j | jq "[.[].id | select(. > 0)] | (max // 0) + 1"); hyprctl dispatch movetoworkspacesilent "$next"']]))
-- Criar novo workspace sempre além do maior aberto (ex: 11, 12...)
hl.bind(mainMod .. " + N",       hl.dsp.exec_cmd([[sh -c 'hyprctl dispatch workspace $(hyprctl workspaces | awk "/^workspace ID [0-9]+ / {if (\$3>m) m=\$3} END {print m+1}")']]))
hl.bind(mainMod .. " + ALT + N", hl.dsp.exec_cmd([[sh -c 'hyprctl dispatch movetoworkspacesilent $(hyprctl workspaces | awk "/^workspace ID [0-9]+ / {if (\$3>m) m=\$3} END {print m+1}")']]))
--[ESSE BLOCO ACIMA NÃO FUNCIONA]

-- Workspaces Dedicados (Nomeados)
-- 1. Terminal
hl.bind(mainMod .. " + T",         hl.dsp.focus({ workspace = "name:terminal" }))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.window.move({ workspace = "name:terminal" }))
hl.bind(mainMod .. " + ALT + T",   hl.dsp.window.move({ workspace = "name:terminal", silent = true }))

-- 2. Agenda
hl.bind(mainMod .. " + A",         hl.dsp.focus({ workspace = "name:agenda" }))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.window.move({ workspace = "name:agenda" }))
hl.bind(mainMod .. " + ALT + A",   hl.dsp.window.move({ workspace = "name:agenda", silent = true }))

-- 3. E-mail
hl.bind(mainMod .. " + ALT + E",         hl.dsp.focus({ workspace = "name:email" }))
hl.bind(mainMod .. " + ALT + SHIFT + E", hl.dsp.window.move({ workspace = "name:email" }))
hl.bind(mainMod .. " + ALT + CTRL + E",  hl.dsp.window.move({ workspace = "name:email", silent = true }))

-- 4. Arquivos
hl.bind(mainMod .. " + F",         hl.dsp.focus({ workspace = "name:arquivos" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.move({ workspace = "name:arquivos" }))
hl.bind(mainMod .. " + ALT + F",   hl.dsp.window.move({ workspace = "name:arquivos", silent = true }))

-- ==========================================
-- 8. REGRAS DE JANELAS
-- ==========================================
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Aplicativos fixos nos seus workspaces nomeados
hl.window_rule({
    name      = "auto-email-workspace",
    match     = { class = "thunderbird" },
    workspace = "name:email",
})

hl.window_rule({
    name      = "auto-agenda-workspace",
    match     = { class = "org.gnome.Calendar" },
    workspace = "name:agenda",
})

hl.window_rule({
    name      = "auto-arquivos-workspace",
    match     = { class = "thunar" },
    workspace = "name:arquivos",
})

-- Terminal sempre flutuante
hl.window_rule({
    name  = "floating-terminal",
    match = { class = "^(foot|footclient)$" },
               float = true,
})

-- Picture-in-Picture (Navegadores)
hl.window_rule({
    name              = "pip-floating",
    match             = { title = "^(Picture-in-Picture|Imagem sobre imagem)$" },
               float             = true,
               pin               = true,
               keep_aspect_ratio = true,
})

-- Diálogos do VS Code
hl.window_rule({
    name  = "vscode-dialogs",
    match = {
        class = "^(code|Code|code-oss)$",
               title = "^(Open Folder|Open File|Save As|Workspace Trust)$",
    },
    float  = true,
    center = true,
})

-- Caixas de diálogo por título (Português e Inglês)
hl.window_rule({
    name  = "floating-dialogs-by-title",
    match = {
        title = "^(Abrir.*|Salvar.*|Confirmar.*|Selecionar.*|Escolher.*|Open.*|Save.*|Confirm.*|Select.*|Choose.*|File Upload.*|Preferences.*|Settings.*|Propriedades.*|Properties.*|Workspace Trust.*)$",
    },
    float  = true,
    center = true,
})

-- Portais Wayland e utilitários rápidos
hl.window_rule({
    name  = "floating-dialogs-by-class",
    match = {
        class = "^(xdg-desktop-portal.*|hyprpolkitagent|org.kde.polkit-kde-authentication-agent-1|pavucontrol|nm-connection-editor|blueman-manager|file-roller)$",
    },
    float  = true,
    center = true,
})

-- Tamanho padrão para diálogos de abrir/salvar
hl.window_rule({
    name  = "floating-dialogs-sized",
    match = {
        title = "^(Abrir.*|Salvar.*|Open.*|Save.*)$",
    },
    float  = true,
    center = true,
    size   = "850 550",
})
