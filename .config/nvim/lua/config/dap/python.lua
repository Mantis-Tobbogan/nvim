local dap = require("dap")

-- ========================================
-- Helper Functions
-- ========================================
local function get_python_path()
  local cwd = vim.fn.getcwd()
  if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
    return cwd .. "/venv/bin/python"
  elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
    return cwd .. "/.venv/bin/python"
  else
    return "/usr/bin/python3"
  end
end

-- ========================================
-- Python Debugger Configuration (debugpy)
-- ========================================
dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    pythonPath = get_python_path,
  },
  {
    type = "python",
    request = "launch",
    name = "Launch file with arguments",
    program = "${file}",
    args = function()
      local args_string = vim.fn.input("Arguments: ")
      return vim.split(args_string, " +")
    end,
    pythonPath = get_python_path,
  },
  {
    type = "python",
    request = "launch",
    name = "Django",
    program = "${workspaceFolder}/manage.py",
    args = {
      "runserver",
    },
    pythonPath = get_python_path,
    django = true,
    console = "integratedTerminal",
  },
  {
    type = "python",
    request = "launch",
    name = "Django runserver (custom port)",
    program = "${workspaceFolder}/manage.py",
    args = function()
      local port = vim.fn.input("Port [8000]: ")
      port = port ~= "" and port or "8000"
      return { "runserver", port }
    end,
    pythonPath = get_python_path,
    django = true,
    console = "integratedTerminal",
  },
  {
    type = "python",
    request = "launch",
    name = "Flask",
    module = "flask",
    env = {
      FLASK_APP = "app.py",
      FLASK_DEBUG = "1",
    },
    args = {
      "run",
      "--no-debugger",
    },
    pythonPath = get_python_path,
    console = "integratedTerminal",
  },
  {
    type = "python",
    request = "launch",
    name = "Flask (custom app)",
    module = "flask",
    env = function()
      local app = vim.fn.input("Flask app [app.py]: ")
      app = app ~= "" and app or "app.py"
      return {
        FLASK_APP = app,
        FLASK_DEBUG = "1",
      }
    end,
    args = {
      "run",
      "--no-debugger",
    },
    pythonPath = get_python_path,
    console = "integratedTerminal",
  },
  {
    type = "python",
    request = "launch",
    name = "FastAPI",
    module = "uvicorn",
    args = function()
      local app = vim.fn.input("App module [main:app]: ")
      app = app ~= "" and app or "main:app"
      return {
        app,
        "--reload",
      }
    end,
    pythonPath = get_python_path,
    console = "integratedTerminal",
  },
  {
    type = "python",
    request = "launch",
    name = "Python: Module",
    module = function()
      return vim.fn.input("Module name: ")
    end,
    pythonPath = get_python_path,
  },
  {
    type = "python",
    request = "launch",
    name = "Python: Current Test",
    module = "pytest",
    args = {
      "${file}",
      "-v",
    },
    pythonPath = get_python_path,
    console = "integratedTerminal",
  },
  {
    type = "python",
    request = "launch",
    name = "Python: All Tests",
    module = "pytest",
    args = {
      "-v",
    },
    pythonPath = get_python_path,
    console = "integratedTerminal",
  },
  {
    type = "python",
    request = "attach",
    name = "Attach remote",
    connect = function()
      local host = vim.fn.input("Host [127.0.0.1]: ")
      host = host ~= "" and host or "127.0.0.1"
      local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
      return { host = host, port = port }
    end,
  },
}
