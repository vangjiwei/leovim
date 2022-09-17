-- NOTE: WARN: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#Python
local dap_install_path = "~/.leovim.d/dapinstall"
local dap = require('dap')
-- python
dap.adapters.python = {
    type    = 'executable';
    command = dap_install_path .. '/debugpy/bin/python';
    args    = { '-m', 'debugpy.adapter' };
}
dap.configurations.python = {
    {
        type = 'python';
        request = 'launch';
        name = "Launch file";
        program = "${file}";
        pythonPath = function()
            return dap_install_path .. '/debugpy/bin/python';
        end;
    }
}
-- lldb
if vim.g.dap_cpprust == 'vscode-cpptools' then
    dap.adapters.cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = dap_install_path .. '/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
    }
    dap.configurations.cpp = {
        {
            name = "Launch file",
            type = "cppdbg",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = true,
        },
        {
            name = 'Attach to gdbserver :1234',
            type = 'cppdbg',
            request = 'launch',
            MIMode = 'gdb',
            miDebuggerServerAddress = 'localhost:1234',
            miDebuggerPath = '/usr/bin/gdb',
            cwd = '${workspaceFolder}',
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end
        }
    }
else
    dap.adapters.codelldb = function(on_adapter)
        local stdout       = vim.loop.new_pipe(false)
        local stderr       = vim.loop.new_pipe(false)
        local cmd          = dap_install_path .. '/codelldb/extension/adapter/codelldb'
        local handle, pid_or_err
        local opts         = {
            stdio = { nil, stdout, stderr },
            detached = true,
        }
        handle, pid_or_err = vim.loop.spawn(cmd, opts, function(code)
            stdout:close()
            stderr:close()
            handle:close()
            if code ~= 0 then
                print("codelldb exited with code", code)
            end
        end)
        assert(handle, "Error running codelldb: " .. tostring(pid_or_err))
        stdout:read_start(function(err, chunk)
            assert(not err, err)
            if chunk then
                local port = chunk:match('Listening on port (%d+)')
                if port then
                    vim.schedule(function()
                        on_adapter({
                            type = 'server',
                            host = '127.0.0.1',
                            port = port
                        })
                    end)
                else
                    vim.schedule(function()
                        require("dap.repl").append(chunk)
                    end)
                end
            end
        end)
        stderr:read_start(function(err, chunk)
            assert(not err, err)
            if chunk then
                vim.schedule(function()
                    require("dap.repl").append(chunk)
                end)
            end
        end)
    end
    dap.configurations.cpp = {
        {
            name = "Launch file",
            type = "codelldb",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = true,
        }
    }
end
dap.configurations.c    = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
-- node
dap.adapters.node       = {
    type    = 'executable';
    command = 'node';
    args    = { dap_install_path .. '/jsnode/out/src/nodeDebug.js' };
}
