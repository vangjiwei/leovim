local fn = vim.fn


function _G.inspect(item)
  vim.pretty_print(item)
end

function _G.executable(name)
  if fn.executable(name) > 0 then
    return true
  end
  return false
end

function _G.installed(name)
  if fn['Installed'](name) > 0 then
    return true
  end
  return false
end
