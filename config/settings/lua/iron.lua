local iron = require("iron.core")
iron.setup({
  config = {
    -- If iron should expose `<plug>(...)` mappings for the plugins
    should_map_plug = false,
    close_window_on_exit = true,
    -- Whether a repl should be discarded or not
    scratch_repl = true,
    -- Your repl definitions come here
    repl_definition = {
      sh = {
        command = { "bash" }
      }
    },
    repl_open_cmd = require('iron.view').split.vertical.botright('44%', {
      winfixwidth = false,
      winfixheight = true,
      number = true
    }),
  },
  -- Iron doesn't set keymaps by default anymore. Set them here
  -- or use `should_map_plug = true` and map from you vim files
  keymaps = {
    send_motion = "c<tab>",
    visual_send = "cl",
    send_file = "<leader>S",
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
--- setup for each ft
if vim.fn.executable('radian') then
  iron.setup{
    config = {
      repl_definition = {
        r = {
          command = {"radian"}
        }
      }
    }
  }
elseif vim.fn.executable('R') then
  iron.setup{
    config = {
      repl_definition = {
        r = {
          command = {"R"}
        }
      }
    }
  }
end
if vim.fn.executable('ipython') then
  iron.setup{
    config = {
      repl_definition = {
        python = {
          command = { "ipython", "--no-autoindent" }
        }
      }
    }
  }
elseif vim.fn.executable('python3') then
  iron.setup{
    config = {
      repl_definition = {
        python = {
          command = {"python3"}
        }
      }
    }
  }
elseif vim.fn.executable('python') then
  iron.setup{
    config = {
      repl_definition = {
        python = {
          command = {"python"}
        }
      }
    }
  }
end