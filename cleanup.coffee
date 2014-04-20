racksjs = require  './racks.js'
sleep = require 'sleep'
targeLabel = 'glusterfs-node'

new racksjs {username: process.argv[2], apiKey: process.argv[3], verbosity: 3, cache:  false}, (rs) =>
	rs.datacenter = 'IAD'
	deleteServers = (cb) ->
		servercount = 0
		rs.servers.all (servers) ->
			if servers.length > 0
				for server in servers
					server.metadata (metadata) ->
						if metadata.metadata.label = 'glusterfs-node'
							console.log 'deleteing server:', server.name
							servercount++
							server.delete (reply) ->
								console.log reply
								if --servercount == 0 
										console.log 'deleteserver calling back'
										cb()
						else
							console.log 'skipping server:', server.name
			else
				console.log 'no servers found'
				cb()
	
	deleteVolumes = (cb) ->
		volumecount = 0
		rs.cloudBlockStorage.volumes.all (volumes) ->
			if volumes.length > 0
				for volume in volumes
					volumecount++ 
					volume.delete (reply) ->
						console.log reply
						if --volumecount == 0
							console.log 'deleteVolumes calling back'
							cb()
			else
				console.log 'no volumes found'
				cb()

	deleteNetworks = (cb) ->
		netcount = 0
		rs.cloudServersOpenStack.networks.all (networks) ->
			if networks.length > 2
				for network in networks
					netcount++
					if network.id isnt '00000000-0000-0000-0000-000000000000' and network.id isnt '11111111-1111-1111-1111-111111111111'	
						console.log network
						network.delete (reply) ->
							console.log reply
							if --netcount == 0
								console.log 'deleteNetworks calling back'
								cb()
			else
				console.log 'no networks found'
				cb()

	deleteServers () ->
		sleep.sleep(10)
		deleteVolumes () ->
			sleep.sleep(10)
			deleteNetworks () ->
				sleep.sleep(10)
				console.log 'fin'




