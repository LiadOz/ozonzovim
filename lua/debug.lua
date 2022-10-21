--local mason_registery = require('mason_registery')
--mason_registery.is_installed()

local dap = require('dap')

dap.adapters.python = {
    type = 'server';
    host = '127.0.0.1';
    port = 1337;
}

dap.configurations.python = {
    {
        type = 'python';
        request = 'attach';
        name = 'Attach remote';
    },
}

local wk = require('which-key')
local mappings = {
    d = {
        name = 'debug+',
        b = { function() dap.toggle_breakpoint({}, {}, {}) end, 'toggle breakpoint' },
        l = { function() dap.list_breakpoints() end, 'list breakpoints' },
    }
}
wk.register(mappings, { prefix = "<leader>" })
wk.register(mappings, { mode = "v", prefix = "<leader>" })

local Hydra = require('hydra')
local hint = {
        type = 'window',
        border = 'rounded',
}
Hydra({
    name = 'debug mode',
    mode = {'n', 'x'},
    body = '<leader>d',
    config = {
        hint = hint,
        color = 'pink',
    },
    heads = {
        { 'c', dap.continue, { desc = 'continue' } },
        { 'n', dap.step_over, { desc = 'step over' } },
        { 'i', dap.step_into, { desc = 'step into' } },
        { 'o', dap.step_out, { desc = 'step out' } },
        { 'u', dap.up, { desc = 'stack up' } },
        { 'd', dap.down, { desc = 'stack down' } },
        { 'D', function() dap.disconnect({terminateDebuggee = false}) end, {desc = 'disconnect'} },
        { 't', dap.run_to_cursor, { desc = 'run to cursor' } },
        { 'r', dap.repl.toggle, { desc = 'repl', exit = true } },
        { 'T', dap.terminate, {desc = 'terminate', exit = true} },
        { 'q', nil, { exit = true, desc = 'exit mode'}},
    }

})
