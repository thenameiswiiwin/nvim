return {
  -- Nvim-dap: Debug Adapter Protocol client
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Conditional Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "Pause",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Configure default adapters
      dap.adapters.lldb = {
        type = "executable",
        command = "lldb-vscode",
        name = "lldb",
      }

      dap.adapters.node2 = {
        type = "executable",
        command = "node",
        args = {
          vim.fn.stdpath("data")
            .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js",
        },
      }

      -- Configure language-specific debug configurations

      -- JavaScript/TypeScript
      dap.configurations.javascript = {
        {
          name = "Launch",
          type = "node2",
          request = "launch",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
        },
        {
          name = "Attach",
          type = "node2",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
      }

      dap.configurations.typescript = dap.configurations.javascript

      -- Minimal UI with performance improvements
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        render = {
          indent = 1,
          max_value_lines = 100, -- Maximum number of lines for a value
          max_type_length = 100, -- Maximum length of variable types
        },
      })

      -- Virtual text integration with performance optimization
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        virt_text_pos = "eol",
        all_frames = false,
        only_first_definition = true, -- Show virtual text only for the first definition
        display_callback = function(variable, _buf, _stackframe, _node)
          return variable.name .. " = " .. variable.value
        end,
      })

      -- Set up Mason DAP integration to automatically install adapters
      require("mason-nvim-dap").setup({
        automatic_installation = true,
        ensure_installed = {
          "js-debug-adapter", -- For JavaScript/TypeScript
          "codelldb", -- For Rust/C++
          "delve", -- For Go
          "php-debug-adapter", -- For PHP
        },
        handlers = {},
      })

      -- Auto-open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Set up debug signs
      vim.fn.sign_define("DapBreakpoint", {
        text = "●",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "◆", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" }
      )
      vim.fn.sign_define(
        "DapLogPoint",
        { text = "◆", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapStopped", {
        text = "→",
        texthl = "DiagnosticSignWarn",
        linehl = "DapStoppedLine",
        numhl = "",
      })
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "●", texthl = "DiagnosticSignHint", linehl = "", numhl = "" }
      )
    end,
  },

  -- Nvim-dap-ui: UI for DAP
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle DAP UI",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "Eval Expression",
        mode = { "n", "v" },
      },
    },
  },

  -- Nvim-dap-virtual-text: Inline variable values
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
  },
}
