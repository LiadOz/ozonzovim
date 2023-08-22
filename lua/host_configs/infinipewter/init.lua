local M = {}
--local dap = require('dap')
--dap.adapters.cppdbg = {
    --type = 'executable',
    --command = '/Users/loz/nvim/cpptools/extension/debugAdapters/bin/OpenDebugAD7'
--}

--dap.adapters.codelldb = {
    --type = 'server',
    --port = 13000,
    --executable = {
        --command = '/Users/loz/.local/share/nvim/mason/bin/codelldb',
        --args = {"--port" , "13000"}
    --}
--}

--require('dap.ext.vscode').load_launchjs(nil, {cppdbg = {'c', 'cpp'}})
--dap.configurations.cpp = {
    ----{
        ----name = 'Attach to lldb',
        ----type = 'codelldb',
        ----request = 'launch',
        ----program = function() -- debugged program executable
            ----return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        ----end,
        ------cwd = '${workspaceFolder}',
        ----initCommands = {
            ----'platform select remote-linux',
            ----'platform connect connect://gdc-qa-io-069:1337',
            ----'settings set target.inherit-env false'
        ----}
    ----}
    --{
        --name = 'Attach to gdb server lldb',
        --type = 'cppdbg',
        --request = 'launch',
        --stopAtConnect = true,
        --stopAtEntry = true,
        ----customLaunchSetupCommands = {
            ----{ text = 'gdb-remote gdc-qa-io-069:1337', description = 'connect to remote', ignroeFailures = false },
            ----{ text='settings append target.source-map /root/test ${workspaceFolder}', description='set source maps', ignoreFailures = false },
        ----},
        --program = function() -- debugged program executable
            --return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        --end,
        ---- coreDumpPath = '' path to core dump to debug
        --additionalSOLibSearchPath = '', -- where to search .so files
        --cwd = '${workspaceFolder}',
        --targetArchitecture = 'x86_64',
        --sourceFileMap = {
            --['/root/test'] = '${workspaceFolder}'
        --},
        ----linux = {
            ----MIMode = 'gdb',
        ----},
        ----osx = {
            ----MIMode = 'lldb',
            ----MIDebuggerPath = '/usr/bin/lldb'
        ----},
        --MIMode = 'lldb',
        ----launchCompleteCommand = "exec-continue", -- continue since the server already initiated the executable
        ----launchCompleteCommand = "None", -- continue since the server already initiated the executable
        --miDebuggerArgs = '', -- args for debugger
        ----miDebuggerServerAddress = 'gdc-qa-io-069:1337',
    --}
--}

--dap.configurations.c = dap.configurations.cpp

function M.pre_plugin_setup()
  local plugins = require('core.plugins')

  plugins.add_plugin({
    "liadoz/meta-breakpoints.nvim",
    dir = "~/ozonzono/meta-breakpoints.nvim"
  })
end

function M.post_plugin_setup()
end

return M
