local iron = require("iron.core")
iron.setup ({
  config = {
    -- If iron should expose `<plug>(...)` mappings for the plugins
    should_map_plug = false,
    close_window_on_exit = true,
    -- Whether a repl should be discarded or not
    scratch_repl = true,
    -- Your repl definitions come here
    repl_definition = {
      sh = {
        command = {"bash"}
      },
      python = {
        command = {"ipython", "--no-autoindent"}
      }
    },
    repl_open_cmd = require('iron.view').split.vertical.botright(function()
        return math.floor(vim.o.columns / 2)
    end),
    buflisted = false,
  },
  -- Iron doesn't set keymaps by default anymore. Set them here
  -- or use `should_map_plug = true` and map from you vim files
  keymaps = {
    send_motion = "c<tab>",
    visual_send = "cl",
    send_file = "<leader>R",
    send_line = "cl",
    send_mark = "c.",
    mark_motion = "cm",
    mark_visual = "cm",
    remove_mark = "dm",
    cr = "cj",
    clear = "ck",
    exit = "cq",
    interrupt = "ch",
  },
  -- If the highlight is on, you can change how it looks
  -- For the available options, check nvim_set_hl
  highlight = {
    italic = false
  }
})
