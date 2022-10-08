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

function _G.Installed(name)
  if fn['Installed'](name) > 0 then
    return true
  end
  return false
end

function _G.WINDOWS()
  if fn['WINDOWS']() > 0 then
    return true
  end
  return false
end

function _G.LINUX()
  if fn['LINUX']() > 0 then
    return true
  end
  return false
end

function _G.UNIX()
  if fn['UNIX']() > 0 then
    return true
  end
  return false
end

