if vim.tbl_flatten then
  vim.tbl_flatten = function(tbl)
    return vim.iter(tbl):flatten():totable()
  end
end

if vim.validate then
  local old_validate = vim.validate
  vim.validate = function(...)
    local ok, res = pcall(old_validate, ...)
    if not ok then
      return old_validate(...)
    end
    return res
  end
end

