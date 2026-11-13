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
local terminal    = "footclient"      -- Mais leve que kitty (mude para kitty se preferir)
local fileManager = "thunar"    -- Mais leve que dolphin (evita daemons do KDE)
local menu        = "fuzzel"    -- Mais leve que wofi

-- ==========================================
-- 3. AUTOSTART
-- ==========================================
hl.on("hyprland.start", function()
hl.exec_cmd("waybar")       -- Apenas uma instância
hl.exec_cmd("mako")
hl.exec_cmd("hypridle")
hl.exec_cmd("foot --server")
hl.exec_cmd("systemctl --user start hyprpolkitagent")

-- monitora texto e imagens copiadas
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
hl.env("LIBVA_DRIVER_NAME", "iHD") -- Driver Intel nativo

-- ==========================================
-- 5. CONFIGURAÇÃO UNIFICADA (PERFORMANCE MÁXIMA)
-- ==========================================
hl.config({
    general = {
        gaps_in          = 1,
        gaps_out         = 0,
        border_size      = 1,
        col = {
            active_border   = "rgba(33ccffee)", -- Cor sólida evita gradientes caros
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
--NÃO FUNCIONA        vfr                      = true,  -- ESSENCIAL: Reduz CPU/GPU para 0% em tela parada
        vrr                      = 1,     -- 1 = Ativado (FreeSync / G-Sync)
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

-- Execução de programas
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal)) -- abre o terminal
hl.bind(mainMod .. " + C", hl.dsp.window.close()) -- fecha a janela ativa
hl.bind(mainMod .. " + M", hl.dsp.exit()) -- desligamento direto, chamada nativa sem passar por hyprctl
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager)) -- abre o gerenciador de arquivos no workspace específico pra isso.
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" })) -- alterna a janela ativa entre flutuante e fixa

-- Lançador de aplicativos (SUPER + D ou SUPER + Espaço)
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("fuzzel"))
--hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu)) -- abre o menu de aplicativos/programas

hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- ainda não sei o que faz
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- não sei o que faz
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock")) -- bloqueia a sessão
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu -p 'Clipboard: ' | cliphist decode | wl-copy")) -- histórco de ctrl+C (100)

--hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("pkill hyprsunset || hyprsunset --temperature 4000")) -- alterna a temperatura de cor da tela

-- OCR da tela direto para o clipboard (Português + Inglês)
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | tesseract stdin stdout -l por+eng | tr -d '\f' | wl-copy]]))

-- Alternar visibilidade do Waybar (Modo Foco)
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))

-- Print (sem modificador): seleciona área e copia para o clipboard
hl.bind("Print", hl.dsp.exec_cmd([[sh -c 'grim -g "$(slurp)" - | wl-copy']])) -- usa a tecla PrintScreen pra fazer um print

-- SHIFT + Print: tela inteira salva na pasta Imagens
hl.bind("SHIFT + Print", hl.dsp.exec_cmd([[sh -c 'grim "$HOME/Imagens/screenshot_$(date +%Y%m%d_%H%M%S).png"']])) -- parece não funcionar

-- Menu de desligamento / encerramento (SUPER + Escape ou SUPER + Backspace)
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("~/.config/hypr/powermenu.sh"))

-- Foco nas janelas
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))


-- Workspaces de 1 a 10:
-- SUPER + [1-9,0]         -> Foca a workspace
-- SUPER + SHIFT + [1-9,0] -> Move a janela ativa e vai junto
-- SUPER + ALT + [1-9,0]  -> Envia a janela para lá silenciosamente (você fica onde está)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,                hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,        hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + ALT + " .. key,         hl.dsp.window.move({ workspace = i, silent = true }))
end

-- Janelas flutuantes com o Mouse
    hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
    hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Controles multimídia
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
    hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
    hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })


    -- ==========================================
    -- WORKSPACES DEDICADAS
    -- ==========================================

    -- 1. TERMINAL
    hl.bind(mainMod .. " + T",         hl.dsp.focus({ workspace = "name:terminal" }))
    hl.bind(mainMod .. " + SHIFT + T", hl.dsp.window.move({ workspace = "name:terminal" }))

    -- 2. AGENDA
    hl.bind(mainMod .. " + A",         hl.dsp.focus({ workspace = "name:agenda" }))
    hl.bind(mainMod .. " + SHIFT + A", hl.dsp.window.move({ workspace = "name:agenda" }))

    -- 3. E-MAIL
    hl.bind(mainMod .. " + ALT + E",         hl.dsp.focus({ workspace = "name:email" }))
    hl.bind(mainMod .. " + ALT + SHIFT + E", hl.dsp.window.move({ workspace = "name:email" }))

    -- 4. ARQUIVOS
    hl.bind(mainMod .. " + F",         hl.dsp.focus({ workspace = "name:arquivos" }))
    hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.move({ workspace = "name:arquivos" }))

    -- ==========================================
    -- MOVER JANELAS SILENCIOSAMENTE (ALT)
    -- ==========================================

    -- 1. Workspaces numerados (1 a 10)
    for i = 1, 10 do
        local key = tostring(i % 10) -- O workspace 10 usa a tecla "0"
        hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.window.move({ workspace = i, silent = true }))
        end

        -- 2. Workspaces nomeados dedicados
        hl.bind(mainMod .. " + ALT + T",        hl.dsp.window.move({ workspace = "name:terminal", silent = true }))
        hl.bind(mainMod .. " + ALT + A",        hl.dsp.window.move({ workspace = "name:agenda",   silent = true }))
        hl.bind(mainMod .. " + ALT + CTRL + E", hl.dsp.window.move({ workspace = "name:email",    silent = true }))
        hl.bind(mainMod .. " + ALT + F",        hl.dsp.window.move({ workspace = "name:arquivos", silent = true }))

-- JANELAS ACIMA DE 10
        -- Pula para o próximo workspace vazio disponível (ex: 11, 12...)
        hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("hyprctl dispatch workspace empty"))

        -- Envia a janela atual para o próximo workspace vazio sem sair da tela
        hl.bind(mainMod .. " + ALT + N", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent empty"))

    -- ==========================================
    -- 7. REGRAS DE JANELAS
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

    -- Abre o Thunderbird diretamente na workspace especial de email
    hl.window_rule({
        name      = "auto-email-scratchpad",
        match     = { class = "thunderbird" },
        workspace = "special:email",
    })

    -- Abre janelas com classe 'calendar' diretamente na agenda
    hl.window_rule({
        name      = "auto-agenda-scratchpad",
        match     = { class = "org.gnome.Calendar" },
        workspace = "special:agenda",
    })

    -- Abre o Gerenciador de Arquivos no workspace de Arquivos
    hl.window_rule({
        name      = "auto-arquivos-workspace",
        match     = { class = "thunar" },
        workspace = "name:arquivos",
    })

    -- Regra para Picture-in-Picture automático (Firefox e navegadores Chromium)
    hl.window_rule({
        name      = "pip-floating",
        match     = { title = "^(Picture-in-Picture|Imagem sobre imagem)$" },
                   float     = true,
                   pin       = true, -- Permanece visível mesmo trocando de workspace
                   keep_aspect_ratio = true,
    })

    -- Garante que janelas de diálogo do VS Code abram centralizadas e flutuantes
    hl.window_rule({
        name  = "vscode-dialogs",
        match = {
            class = "^(code|Code|code-oss)$",
                   title = "^(Open Folder|Open File|Save As|Workspace Trust)$",
        },
        float  = true,
        center = true,
    })

    -- ==========================================
    -- CAIXAS DE DIÁLOGO E POPUPS FLUTUANTES
    -- ==========================================

    -- 1. Captura caixas de diálogo por títulos comuns (Inglês e Português)
    hl.window_rule({
        name  = "floating-dialogs-by-title",
        match = {
            title = "^(Abrir.*|Salvar.*|Confirmar.*|Selecionar.*|Escolher.*|Open.*|Save.*|Confirm.*|Select.*|Choose.*|File Upload.*|Preferences.*|Settings.*|Propriedades.*|Properties.*|Workspace Trust.*)$",
        },
        float  = true,
        center = true,
    })

    -- 2. Portais nativos do Wayland, autenticação e utilitários rápidos
    hl.window_rule({
        name  = "floating-dialogs-by-class",
        match = {
            class = "^(xdg-desktop-portal.*|hyprpolkitagent|org.kde.polkit-kde-authentication-agent-1|pavucontrol|nm-connection-editor|blueman-manager|file-roller)$",
        },
        float  = true,
        center = true,
    })

    hl.window_rule({
        name  = "floating-dialogs-sized",
        match = {
            title = "^(Abrir.*|Salvar.*|Open.*|Save.*)$",
        },
        float  = true,
        center = true,
        size   = "850 550", -- Largura e Altura em pixels
    })

    -- ==========================================
    -- TERMINAL SEMPRE FLUTUANTE
    -- ==========================================
    hl.window_rule({
        name  = "floating-terminal",
        match = {
            class = "^(foot|footclient)$",
        },
        float = true,
    })


