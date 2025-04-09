local M = {}

-- Fast file reading
M.read_file = function(path)
  local fd = vim.loop.fs_open(path, "r", 438)
  if not fd then
    return nil
  end
  local stat = vim.loop.fs_fstat(fd)
  local data = vim.loop.fs_read(fd, stat.size, 0)
  vim.loop.fs_close(fd)
  return data
end

-- Fast file writing
M.write_file = function(path, data)
  local fd = vim.loop.fs_open(path, "w", 438)
  if not fd then
    return false
  end
  local success = vim.loop.fs_write(fd, data, 0)
  vim.loop.fs_close(fd)
  return success
end

return M
