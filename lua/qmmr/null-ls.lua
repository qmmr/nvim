local status_ok, null_ls = pcall(require, "null-ls")

if not status_ok then
  return "Null-ls was not found"
end

local formatting = null_ls.builtins.formatting

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local callback = function()
    vim.lsp.buf.format({
        bufnr = bufnr,
        filter = function(client)
            return client.name == "null-ls"
        end
    })
end

null_ls.setup({
  sources = {
    formatting.prettierd
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = callback
      })
    end

    if client.server_capabilities.documentFormattingProvider then
      vim.cmd("nnoremap <silent><buffer> <leader>f :lua vim.lsp.buf.format({  filter = function(client) return client.name == \"null-ls\" end })<CR>")
    end

    if client.server_capabilities.documentRangeFormattingProvider then
      vim.cmd("xnoremap <silent><buffer> <leader>f :lua vim.lsp.buf.range_formatting({})<CR>")
    end
  end,
})
