{ pkgs, dsl, ... }:
with dsl; {
  plugins = with pkgs; [
    # dracula
    gruvbox-nvim
    vimPlugins.lualine-nvim
    vimPlugins.tabline-nvim
    vimPlugins.nvim-web-devicons
    node-type-nvim
    vim-circom-syntax
    tokyonight-nvim
    kanagawa-nvim
    spacecamp-vim
    # airline-vim
    tagbar-vim
    colors150-vim
    presence-nvim
    nerdtree-vim
    nvim-tree
    rose-pine-nvim
    startup-nvim
    asciiart-nvim
    nvim-gdb
    glow-nvim
    auto-session-nvim
    focus-nvim
    competitest-nvim
    cphelper-nvim
    # statusline-action-hints

    # jump to character on line
    # quick-scope
  ];

  # autocmd ColorScheme * highlight QuickScopePrimary guifg='#ff0000' guibg='#0000ff' ctermfg='196'
  # autocmd ColorScheme * highlight QuickScopeSecondary guifg='#880000' guibg='#000088' gui=underline ctermfg='196'
  # noremap <F4> :NvimTreeOpen <cr>
  vimscript = ''
    noremap <F1> :mksession! .vim.session <cr>
    noremap <F2> :source .vim.session <cr>
    noremap <F3> :! rm .vim.session <cr>
    noremap <F8> :TagbarToggle <cr>
    autocmd ColorScheme * highlight Comment guifg='#ff0000'
  '';

  setup.tabline.show_index = false;

  setup.node-type = {};

  lua = ''
  require("tokyonight").setup({
      -- your configuration comes here
      -- or leave it empty to use the default settings
      style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
      light_style = "night", -- The theme is used when the background is set to light
      transparent = false, -- Enable this to disable setting the background color
      terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "dark", -- style for sidebars, see below
        floats = "dark", -- style for floating windows
      },
      sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
      day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
      hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead.
      dim_inactive = false, -- dims inactive windows
      lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

      --- You can override specific color groups to use other groups or a hex color
      --- function will be called with a ColorScheme table
      ---@param colors ColorScheme
      on_colors = function(colors) end,

      --- You can override specific highlights to use other groups or a hex color
      --- function will be called with a Highlights and ColorScheme table
      ---@param highlights Highlights
      ---@param colors ColorScheme
      on_highlights = function(hl, c)
      local prompt = "#2d3149"
      hl.TelescopeNormal = {
        bg = c.bg_dark,
        fg = c.fg_dark,
      }
      hl.TelescopeBorder = {
        bg = c.bg_dark,
        fg = c.bg_dark,
      }
      hl.TelescopePromptNormal = {
        bg = prompt,
      }
      hl.TelescopePromptBorder = {
        bg = prompt,
        fg = prompt,
      }
      hl.TelescopePromptTitle = {
        bg = prompt,
        fg = prompt,
      }
      hl.TelescopePreviewTitle = {
        bg = c.bg_dark,
        fg = c.bg_dark,
      }
      hl.TelescopeResultsTitle = {
        bg = c.bg_dark,
        fg = c.bg_dark,
      }
    end,
    })

    vim.cmd("colorscheme tokyonight-night")

    vim.g.tree_open = 0
    function ToggleNvimTree()
      if vim.o.modifiable == true then
        vim.g.tree_open = 1
        vim.cmd('NvimTreeOpen')
      elseif vim.g.tree_open == 1 then
        vim.cmd("NvimTreeClose")
        vim.g.tree_open = 0
      end
    end

    vim.api.nvim_set_keymap('n', '<F4>', ':lua ToggleNvimTree()<CR>', { noremap = true, silent = true })

    require('glow').setup({
      style = "dark",
      width = 120,
    })

    -- require("auto-session").setup({
    --   log_level = "error",
    --   auto_session_enable_last_session = falsr,
    --   cwd_change_handling = {
    --     restore_upcoming_session = true, -- already the default, no need to specify like this, only here as an example
    --     pre_cwd_changed_hook = nil, -- already the default, no need to specify like this, only here as an example
    --   post_cwd_changed_hook = function() -- example refreshing the lualine status line _after_ the cwd changes
    --       require("lualine").refresh() -- refresh lualine so the new session name is displayed in the status bar
    --     end,
    --   },
    -- })

    -- vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

    require("focus").setup({enable = true})

    require('competitest').setup({
      local_config_file_name = ".competitest.lua",

      floating_border = "rounded",
      floating_border_highlight = "FloatBorder",
      picker_ui = {
        width = 0.2,
        height = 0.3,
        mappings = {
        focus_next = { "j", "<down>", "<Tab>" },
        focus_prev = { "k", "<up>", "<S-Tab>" },
        close = { "<esc>", "<C-c>", "q", "Q" },
        submit = { "<cr>" },
        },
      },
      editor_ui = {
          popup_width = 0.4,
          popup_height = 0.6,
          show_nu = true,
          show_rnu = false,
          normal_mode_mappings = {
          switch_window = { "<C-h>", "<C-l>", "<C-i>" },
          save_and_close = "<C-s>",
          cancel = { "q", "Q" },
        },
        insert_mode_mappings = {
          switch_window = { "<C-h>", "<C-l>", "<C-i>" },
          save_and_close = "<C-s>",
          cancel = "<C-q>",
        },
      },
      runner_ui = {
        interface = "popup",
        selector_show_nu = false,
        selector_show_rnu = false,
        show_nu = true,
        show_rnu = false,
        mappings = {
          run_again = "R",
          run_all_again = "<C-r>",
          kill = "K",
          kill_all = "<C-k>",
          view_input = { "i", "I" },
          view_output = { "a", "A" },
          view_stdout = { "o", "O" },
          view_stderr = { "e", "E" },
          toggle_diff = { "d", "D" },
          close = { "q", "Q" },
        },
          viewer = {
            width = 0.5,
            height = 0.5,
            show_nu = true,
            show_rnu = false,
            close_mappings = { "q", "Q" },
          },
      },
      popup_ui = {
        total_width = 0.8,
        total_height = 0.8,
        layout = {
          { 4, "tc" },
          { 5, { { 1, "so" }, { 1, "si" } } },
          { 5, { { 1, "eo" }, { 1, "se" } } },
        },
      },
      split_ui = {
        position = "right",
        relative_to_editor = true,
        total_width = 0.3,
        vertical_layout = {
          { 1, "tc" },
          { 1, { { 1, "so" }, { 1, "eo" } } },
          { 1, { { 1, "si" }, { 1, "se" } } },
        },
        total_height = 0.4,
        horizontal_layout = {
          { 2, "tc" },
          { 3, { { 1, "so" }, { 1, "si" } } },
          { 3, { { 1, "eo" }, { 1, "se" } } },
        },
      },

      save_current_file = true,
      save_all_files = false,
      compile_directory = ".",
      compile_command = {
        c = { exec = "gcc", args = { "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
        cpp = { exec = "g++", args = { "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
        rust = { exec = "rustc", args = { "$(FNAME)" } },
        java = { exec = "javac", args = { "$(FNAME)" } },
      },
      running_directory = ".",
      run_command = {
        c = { exec = "./$(FNOEXT)" },
        cpp = { exec = "./$(FNOEXT)" },
        rust = { exec = "./$(FNOEXT)" },
        python = { exec = "python", args = { "$(FNAME)" } },
        java = { exec = "java", args = { "$(FNOEXT)" } },
      },
      multiple_testing = -1,
      maximum_time = 5000,
      output_compare_method = "squish",
      view_output_diff = false,

      testcases_directory = ".",
      testcases_use_single_file = false,
      testcases_auto_detect_storage = true,
      testcases_single_file_format = "$(FNOEXT).testcases",
      testcases_input_file_format = "$(FNOEXT)_input$(TCNUM).txt",
      testcases_output_file_format = "$(FNOEXT)_output$(TCNUM).txt",

      companion_port = 27121,
      receive_print_message = true,
      template_file = {
        c = "~/.nvim/templates/file.c",
        cpp = "~/.nvim/templates/file.cpp",
        rs = "~/.nvim/templates/file.rs"
      },
      evaluate_template_modifiers = true,
      date_format = "%c",
      received_files_extension = "rs",
      received_problems_path = "$(CWD)/$(PROBLEM).$(FEXT)",
      received_problems_prompt_path = true,
      received_contests_directory = "$(CWD)",
      received_contests_problems_path = "$(PROBLEM).$(FEXT)",
      received_contests_prompt_directory = true,
      received_contests_prompt_extension = true,
      open_received_problems = true,
      open_received_contests = true,
      replace_received_testcases = false,
    })

    require('asciiart').setup({
      render = {
        min_padding = 5,
        show_label = true,
        use_dither = true,
        foreground_color = false,
        background_color = false
      },
      events = {
        update_on_nvim_resize = true,
      },
    })
    require("startup").setup({theme = "dragon0"})
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.opt.termguicolors = true
    require("nvim-tree").setup({
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
    })
    require("rose-pine").setup({
        variant = "auto", -- auto, main, moon, or dawn
        dark_variant = "main", -- main, moon, or dawn
        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        enable = {
            terminal = true,
            legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
            migrations = true, -- Handle deprecated options automatically
        },

        styles = {
            bold = true,
            italic = true,
            transparency = false,
        },

        groups = {
            border = "muted",
            link = "iris",
            panel = "surface",

            error = "love",
            hint = "iris",
            info = "foam",
            note = "pine",
            todo = "rose",
            warn = "gold",

            git_add = "foam",
            git_change = "rose",
            git_delete = "love",
            git_dirty = "rose",
            git_ignore = "muted",
            git_merge = "iris",
            git_rename = "pine",
            git_stage = "iris",
            git_text = "rose",
            git_untracked = "subtle",

            h1 = "iris",
            h2 = "foam",
            h3 = "rose",
            h4 = "gold",
            h5 = "pine",
            h6 = "foam",
        },

        highlight_groups = {
            -- Comment = { fg = "foam" },
            -- VertSplit = { fg = "muted", bg = "muted" },
        },

        before_highlight = function(group, highlight, palette)
            -- Disable all undercurls
            -- if highlight.undercurl then
            --     highlight.undercurl = false
            -- end
            --
            -- Change palette colour
            -- if highlight.fg == palette.pine then
            --     highlight.fg = palette.foam
            -- end
        end,
    })
    require('kanagawa').setup({
      compile = false,             -- enable compiling the colorscheme
      undercurl = true,            -- enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true},
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,         -- do not set background color
      dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
      terminalColors = true,       -- define vim.g.terminal_color_{0,17}
      colors = {                   -- add/modify theme and palette colors
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      overrides = function(colors) -- add/modify highlights
          return {}
      end,
      theme = "wave",              -- Load "wave" theme when 'background' option is not set
      background = {               -- map the value of 'background' option to a theme
          dark = "dragon",           -- try "dragon" !
          light = "lotus"
        },
    })
   require("gruvbox").setup({
      terminal_colors = true, -- add neovim terminal colors
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true, -- invert background for search, diffs, statuslines and errors
      contrast = "",  -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {
        SignColumn = { link = "Normal" },
        GruvboxGreenSign = { bg = "" },
        GruvboxOrangeSign = { bg = "" },
        GruvboxPurpleSign = { bg = "" },
        GruvboxYellowSign = { bg = "" },
        GruvboxRedSign = { bg = "" },
        GruvboxBlueSign = { bg = "" },
        GruvboxAquaSign = { bg = "" },
        TelescopeSelection = { link = "Visual" },
        ["@variable"] = { link = "GruvboxBlue" },
        TermCursor = { bg = "#fabd2f", fg = "#282828" },
        Visual = {bg = "#d79921", fg = "#282828"},
        Linenr = {fg = "#7c6f64", bg = ""},
        debugPC = {fg = "", bg = "#3d4220"},
        DapBreakpoint = {fg = "", bg = "#472322"},
        DapBreakpointSymbol = {bg = ""}
      },
      dim_inactive = false,
      transparent_mode = false,
  })

  '';
  # setup.statusline-action-hints = {
  #     definition_identifier = "gd";
  #     template = "%s ref:%s";
  # };

  setup.lualine = {
    options = {
      theme = "tokyonight";
      component_separators = {
        left = "";
        right = "";
      };
      section_separators = {
        left = "";
        right = "";
      };
      globalstatus = true;
    };
    sections = {
      lualine_a = [ "mode" ];
      lualine_b = [ "branch" "diff" "diagnostics" ];
      lualine_c = [ "filename" ];
      # lualine_x = [/* (rawLua "require(\"statusline-action-hints\").statusline") */ (rawLua "require(\"node-type\").statusline") "encoding" "fileformat" ];
      lualine_z = [ "location" ];
    };
    tabline = { };
    extensions = { };
  };
}
