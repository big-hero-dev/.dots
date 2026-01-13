local ok, hints = pcall(require, "lsp-endhints")
if not ok then
	return
end

hints.setup()
