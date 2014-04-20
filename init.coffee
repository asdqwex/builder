# We need:
racksjs = require  './racks.js'
rack = false
Connection = require 'ssh2'
sleep = require 'sleep'

# to cook:
recipe = {
	servers: {
		'gluster1': {
			name: 'gluster1'
			imageRef: "80fbcb55-b206-41f9-9bc2-2dd7aac6c061"
			flavorRef: "performance1-1"
			metadata: { label: 'glusterfs-node' }
		}
		#'gluster2': {
		#	name: 'gluster2'
		#	imageRef: "80fbcb55-b206-41f9-9bc2-2dd7aac6c061"
		#	flavorRef: "performance1-1"
		#	metadata: { label: 'glusterfs-node' }
		#}
		#'#gluster3': {
		#	name: 'gluster3'
		#	imageRef: "80fbcb55-b206-41f9-9bc2-2dd7aac6c061"
		#	flavorRef: "performance1-1"
		#	metadata: { label: 'glusterfs-node' }
		#}
	}
	networks: {
		'gluster-private': {
			label: 'gluster-private'
			cidr: '172.16.0.0/24'
		}
	}
	storage: {
		'gluster1': {
			display_name: 'gluster1'
			size: '100'
		}
		#'gluster2': {
		#	display_name: 'glusterBrick2'
		#	size: '100'
		#}
		#'gluster3': {
		#	display_name: 'glusterBrick3'
		#	size: '100'
		#}
	}
}

# this is what we consume
steak = {
	servers: {}
	networks: {}
	storage: {}
}

# lets do it
new racksjs {username: process.argv[2], apiKey: process.argv[3], verbosity: 0, cache:  false}, (rs) =>
	rack = rs
	rack.datacenter = 'IAD'
	buildServers recipe.servers, (servers) ->
		#console.log 'steak', steak
		buildNetwork recipe.networks, (networks) ->
			#console.log 'steak', steak
			buildStorage recipe.storage, (storage) ->
				#console.log 'steak', steak
				attachNetwork steak.networks, steak.servers, (vips) ->
					#console.log 'steak', steak
					attachStorage steak.storage, steak.servers, (devices) ->
						#console.log 'steak', steak
						bootstrapSaltminions steak.servers, (minions) ->
							#console.log 'steak', steak
							runHighstate steak.servers, (cluster) ->
								#console.log 'steak', steak
								for server, details of steak.servers
									console.log details.info
								#verifyCluster cluster, (status) ->							

# core function definitions

buildServers = (servers , cb) ->
	apiCalls = 0
	for name, server of servers
		apiCalls++
		console.log 'creating server:', name
		rack.servers.new server, (response) ->
			console.log 'server creation submitted for:', response.id
			response.systemActive (details) ->
				console.log 'server created:', details.name, 'at', details.accessIPv4
				steak.servers[details.name] = response
				steak.servers[details.name].info = details
				apiCalls--
				if apiCalls == 0
					cb()
						
buildNetwork = (networks, cb) ->
	for name, network of networks
		console.log 'creating network', name, network
		rack.networks.new network, (cloudnet) ->
			console.log 'network created', cloudnet.id
			steak.networks[cloudnet.label] = cloudnet
			cb()

buildStorage = (storage, cb) ->
	apiCalls = 0
	for name, volume of storage
		apiCalls++
		console.log 'creating volume', name, 'size', volume.size
		rack.cloudBlockStorage.volumes.new volume, (details) ->
			console.log 'created volume', details.id
			steak.storage[details.display_name] = details
			apiCalls--
			if apiCalls == 0
				cb()

attachNetwork = (networks, servers, cb) ->
	for id, network of networks
		apiCalls = 0
		console.log 'network found:', network.label
		for name, server of servers
			apiCalls++
			do ->
				servername = name
				myserver = server
				myserver.attachNetwork {network_id: network.id}, (vip) ->
					sleep.sleep(10)
					myserver.getVips (vips) ->
						for item in vips.virtual_interfaces
							for address in item.ip_addresses
								if address.network_label == network.label
									steak.servers[servername].info.glusterVip = address.address
									console.log 'gluster-network address', address
									apiCalls--
									if apiCalls == 0
										cb()

attachStorage = (volumes, servers, cb) ->
	for id, volume of volumes
		console.log 'found volume', id
		for name, server of servers
			if name == volume.display_name
				attachment = {
					volumeAttachment: {
      					device: null,
      					volumeId: volume.id
   						}
   					}
				console.log 'attaching volume', id, 'to server', name
				server.attachVolume attachment, (volId) ->
					console.log 'attachment deatils', volId.volumeAttachment.device
					cb()

bootstrapSaltminions = (minions, cb) ->
	bootstrap = 'curl -L http://bootstrap.saltstack.org | sh'
	for name, server of minions
		minion = {
			host: server.info.accessIPv4
			port: 22
			username: 'root'
			password: server.adminPass
		}
		console.log 'target:', minion.host
		sshCommand minion, bootstrap, (reply) ->
			cb()

runHighstate = (minions, cb) ->
	getHighState = 'wget -O /root/recipes.tar -r -np https://github.com/asdqwex/salted-gluster/raw/master/recipes.tar'
	extractHighState = 'mkdir -p /srv/salt && tar -xvf /root/recipes.tar -C /srv/salt'
	highState = 'salt-call -l quiet --local state.highstate'
	minion = {}
	for name, server of minions
		minion = {
			host: server.info.accessIPv4
			port: 22
			username: 'root'
			password: server.adminPass
		}
		sshCommand minion, getHighState, () ->
			sshCommand minion, extractHighState, () ->
				sshCommand minion, highState, () ->
					cb()


verifyCluster = (mountpoint, cb) ->

# Utility functions

sshCommand = (target, command, cb) ->
	c = new Connection()

	c.on 'ready' , () ->
		console.log 'Connection :: ready'
		c.exec command, (err, stream) ->
			if err 
				throw err
			stream.on 'data', (data, extended) ->
				console.log (extended == 'stderr' ? 'STDERR: ' : 'STDOUT: ')+data
			stream.on 'end', () ->
				console.log 'Stream :: EOF'
			stream.on 'close', () ->
				console.log 'Stream :: close'
			stream.on 'exit', (code, signal) ->
				console.log 'Stream :: exit :: code: '+code+', signal: '+signal
				c.end()
	c.on 'error', (err) ->
		console.log 'Connection :: error :: ' + err
	c.on 'end', () ->
		console.log 'Connection :: end'
	c.on 'close', (had_error) ->
		console.log 'Connection :: close'
		cb()
	c.connect target