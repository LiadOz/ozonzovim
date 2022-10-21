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

local breakpoints = require('dap.breakpoints')
local phantom_breakpoints = {}
print(vim.inspect(phantom_breakpoints))
local function toggle_phantom_breakpoint()
    local bufnr = vim.api.nvim_get_current_buf()
    local lnum = vim.api.nvim_win_get_cursor(0)[1]
    local pbp = {
        bufnr = bufnr,
        lnum = lnum
    }
    table.insert(phantom_breakpoints, pbp)
    dap.toggle_breakpoint({}, {}, {})
    print(vim.inspect(pbp))
end

local function wrapped_continue()
    dap.continue()
    local bufnr = vim.api.nvim_get_current_buf()
    print("curr bufnr=" .. bufnr)
    local lnum = vim.api.nvim_win_get_cursor(0)[1]
    print("curr lnum=" .. lnum)
    for _, bp in ipairs(phantom_breakpoints) do
        print(vim.inspect(bp))
        if (bp.bufnr == bufnr and bp.lnum == lnum) then
            wrapped_continue()
        end
    end
end

local wk = require('which-key')
local mappings = {
    d = {
        name = 'debug+',
        b = { function() dap.toggle_breakpoint() end, 'toggle breakpoint' },
        B = { function() toggle_phantom_breakpoint() end, 'toggle pbreakpoint' },
        l = { function() dap.list_breakpoints() end, 'list breakpoints' },
        C = { wrapped_continue, 'wrapped continue' }
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
        { 'D', function() dap.disconnect({terminateDebuggee = false}) end, { exit = true, desc = 'disconnect'} },
        { 't', dap.run_to_cursor, { desc = 'run to cursor' } },
        { 'r', dap.repl.toggle, { desc = 'repl', exit = true } },
        { 'T', dap.terminate, {desc = 'terminate', exit = true} },
        { 'q', nil, { exit = true, desc = 'exit mode'}},
    }

})

require('nvim-dap-virtual-text').setup()
