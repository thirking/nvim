local function report_legacy()
  vim.notify_once("The current version may have some deprecated features, time to upgrade!",
    vim.log.levels.WARN)
end

if not vim.uv then
  vim.uv = vim.loop
  report_legacy()
end

if not vim.list_contains then
  vim.list_contains = vim.tbl_contains
  report_legacy()
end

if not vim.islist then
  vim.islist = vim.tbl_islist
  report_legacy()
end

if not vim.lsp.get_clients then
  vim.lsp.get_clients = vim.lsp.get_active_clients
  report_legacy()
end
