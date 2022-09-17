local status_ok, _ = pcall(require, "lspconfig")

if not status_ok then
	return
end

require("qmmr.lsp.lsp-installer")
require("qmmr.lsp.handlers").setup()
