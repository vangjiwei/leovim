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

function _G.get_adapter(adapter)
  local adp = ""
  if WINDOWS() then
    adp = fn.expand("$HOME/AppData/Local/nvim-data/mason/bin/") .. adapter .. ".cmd"
  elseif UNIX() then
    adp =  fn.expand("$HOME/.local/share/nvim/mason/bin/") .. adapter
  else
    return nil
  end
  if fn.filereadable(adp) > 0 then
    return adp
  else
    return nil
  end
end
