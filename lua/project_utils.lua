local M = {}

local projects_dirs = require('projects')
M.projects_dirs = projects_dirs

local function get_project_path(path)
    for _, value in pairs(projects_dirs) do
        if path:find(value) then
            return value
        end
    end
    return nil
end

M.get_project_path = get_project_path

local function get_cwd_project_dir ()
    -- returns the project dir from cwd if there is no project return the cwd
    local cwd = vim.fn.getcwd()
    local project_path = get_project_path(cwd)
    if project_path then
        return project_path
    end
    return cwd
end

M.get_cwd_project_dir = get_cwd_project_dir

return M
