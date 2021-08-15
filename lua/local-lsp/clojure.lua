-- clojure--language-server settings
--

local function config(server_config)
	server_config.capabilities.textDocument.completion.completionItem.snippetSupport = false
	return server_config
end

return {
	config = config,
}
