racksjs = require  './racks.js'
rack = false

new racksjs {username: process.argv[2], apiKey: process.argv[3], verbosity: 0, cache:  false}, (rs) =>
	rack = rs
	rack.datacenter = 'IAD'
	rack.servers.all (servers) ->
		for server in servers
			server.metadata (metadata) ->
				console.log metadata