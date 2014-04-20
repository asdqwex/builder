# We need:
racksjs = require  './racks.js'
rack = false
sys = require 'sys'
fs = require 'fs'
exec = require('child_process').exec
Connection = require 'ssh2'
sleep = require 'sleep'

# The cookbooks
repo = 'https://github.com/asdqwex/salt.git'

# The keys to the kingdom
pubKey = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDiYXESJlAJ1KLKRPpQetKkv4nczQKg921LB2yuO4ehFQ+yVtVYa1QAhi/Qkpqmb7FbkJd+HZ4wAbtGDEXgal14mbvMJ368zo48/AUzpBYFC9lVdVY4Pz/KBBV1uzLOTZdKlo2JUBHY+jiGLN8cZR7W6V8mmz+0DEfeCSdWuICJtNH+pYC+D5CMK76noiTbqhEJ+WOjMZLm5fDYigZqXQz1BzkrmJMmnX5WP1DR3Ll9tmq39AwlPMMyFKHdahepe/5oVe9YCsapqtPaf6zAanhuRxihfZIaYrwKFdyJB3lC2BRfsrv3SXP+CoaaqJa/gZd2ydWgDOrL3grbqdYUcJfh root@dev'
privKey = '''
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEA4mFxEiZQCdSiykT6UHrSpL+J3M0CoPdtSwdsrjuHoRUPslbV
WGtUAIYv0JKapm+xW5CXfh2eMAG7RgxF4GpdeJm7zCd+vM6OPPwFM6QWBQvZVXVW
OD8/ygQVdbsyzk2XSpaNiVAR2Po4hizfHGUe1ulfJps/tAxH3gknVriAibTR/qWA
vg+QjCu+p6Ik26oRCfljozGS5uXw2IoGal0M9Qc5K5iTJp1+Vj9Q0dy5fbZqt/QM
JTzDMhSh3WoXqXv+aFXvWArGqarT2n+swGp4bkcYoX2SGmK8ChXciQd5QtgUX7K7
90lz/gqGmqiWv4GXdsnVoAzqy94K26nWFHCX4QIDAQABAoIBAAiuNdi9UVpfJfLd
nD+Txhn9IjsuPUiQ1EcJPNidfcDmftiWzc17KBhxDMpRpM52//UD4Vs7pYIvvs+b
zt4hFf523qWgahKxVPDvtP9a7mE5KBdHzYuQmVCUwYHnMLaKcR+yEDFQua55Qcub
Ut7S3dDd2AEx+Mpdoi/YaALCRmOBUghccYz9MExuoVYriRYnvetJs8XeRpOgNYBV
YuFjf2D60xDqPGCECTD1bktZPZv868g2XJQVdo0p0VpIWzNilRLIHhC8os43ZtW1
NVy9ZpO6YEQ8Mt922meaNR+rp0HGk9nZOMMGbMlj7T8ccONrVHhJTUAeeAWb7p61
EIqAFVUCgYEA9qwIn9aXmzxssjavYvfJITbvou07c5s/hBA0vhyRf4VjGE9q+fAg
spYy1uviKopWspjxfbISafTB9JDtgxS9xA3YDutyXygsDiYhEigi+gKDFrMlVcTa
7/xZog5g2Mk523AyxzlY5ZJq1ffRE/fSJsT8uLxKwaGD8tfQ9tuRzbsCgYEA6vD4
+m32wefYiitiR3k86wiO/i6sOJHCOPoovkrnfRaV9rZaflgqG2nNmK+GiE5KP34+
ejvyj5MPY9cPU4MkQVhvUyUc4d346NayB0uybOLbVh2QqSp3nPF0cBNGd/0mQdtS
da9AVwWUNzPv26AJGOvj+p5PvwI4P+IO8JWcSRMCgYBvRlPtpuRlRvDRxBGCV70H
mrynhtUW5aXVcWoZiNGp8QYu5USg004swczVXzt7bUSG9K+bwETGP39vUCGUzDp+
wrAAqv3BJ2IYT+MDSc/dcFyqVM42zsLlF7VngYz2vm+3Kfn+HUSY61/+ffh3RYgr
rRlETMx8ZNwdJHZDpfE0GQKBgFp5jggyzLIDrLoY1vIbWEBSvW5ZXu0yBI+YlpQh
mF/tkLa/pr29CgoghpJkFfTr4V/uJ/U+nLx5r5WNPlO0zwNzIPvt8N9yceaIt2pj
1kRkYH8bR5g9yG5h9asrYRnYHSGDao/ze12Hwno3wAjd6mL0hIkA6kjue+buET7I
/rSNAoGAKZA/ri9OmOLhPvT0vxrl2pIXfDGVqHwLvNO4aQdxZ9RKmWZ0/YxDU7sC
rRFP5xFhCFyn9KClLMWfHv44nL32CM7/o2wBhSFqyMshsZaNZ/+egQzC4lhBcKJg
rmCmYfedD1bdKIzK+Hmn4FxBKlexZfQsM2gVWxJaYErRickD6M4=
-----END RSA PRIVATE KEY-----
'''

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
		# create servers
		buildNetwork recipe.networks, (networks) ->
			# create cloud networks
			buildStorage recipe.storage, (storage) ->
				# create cbs volumes
				attachNetwork steak.networks, steak.servers, (vips) ->
					# create vip for each server on each network
					attachStorage steak.storage, steak.servers, (devices) ->
						# attach cbs volume to corresponding server (matches on name)
						setupSshKeys steak.servers, () ->
							# copy public and private keys to all servers
							checkoutSaltConfigs () ->
								# checkout salt repo
								buildSaltConfigs steak.servers, () ->
									# add all servers to minion config as masters
									# add all servers to hosts file
									checkinSaltConfigs () ->
										# checkin configs to  salt repo
										deploySaltConfigs () ->
											# checkout saltrepo on all servers
												installSaltDaemons () ->
													# install master and minion daemons on each server
													runLocalState () ->
														# run salt saltstate locally to configure salt minion and master
														startSaltDaemons () ->
															#start master and then start minion
															runAppState () ->
																# run the applications saltstate
									
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

setupSshKeys = (servers, cb) ->
	injectKeys = 'echo "' + privKey + '" > ~/.ssh/id_rsa && echo "' + pubKey + '" >> ~/.ssh/authorized_keys'

	for name, server of servers
		target = {
			host: server.info.accessIPv4
			port: 22
			username: 'root'
			password: server.adminPass
		}
		console.log 'target:', target.host
		sshCommand target, injectKeys, (reply) ->
			cb()

checkoutSaltConfigs = (cb) ->
	command = 'cd /tmp/ && git clone ' + repo

	localCommand command, (out) ->
		console.log out

buildSaltConfigs = (servers, cb) ->
		ipCopunt = 0
		serverCounter = 0
		ips = []
		minionConfig = 'master: \r\n'
		#get just the ips
		for name, server of servers 
			serverCounter++
			ips.append(server.info.glusterVip)
			if serverCounter >= servers.length
				for ip in ips
					ipCopunt++
					# add all servers to minion config as masters
					minionconfig = minionConfig + server.info.glusterVip + '\r\n'
					if ipCopunt >= ips.length
						data = fs.readFileSync '/tmp/salt/minion'
						fd = fs.openSync '/tmp/salt/minion', 'w+'
						buffer = new Buffer minionConfig
						fs.writeSync fd, buffer, 0, buffer.length
						fs.writeSync fd, data, 0, data.length
						fs.close fd
						# add all servers to hosts file
						for ip in ips
							line = ip +"	"+name
							fs.appendFile '/tmp/salt/hosts', line, (err)->
								console.log err

checkinSaltConfigs = (cb) ->
	command = 'cd /tmp/salt && git add . && git commit -m "deployemnt" && git push '

	localCommand command, (out) ->
		console.log out

deploySaltConfigs = (servers, cb) ->
	checkloutConfigs = 'cd /root && git clone ' + repo

	for name, server of servers
		target = {
			host: server.info.accessIPv4
			port: 22
			username: 'root'
			password: server.adminPass
		}
		console.log 'target:', target.host
		sshCommand target, checkloutConfigs, (reply) ->
			cb()


installSaltDaemons = (cb) ->
	# bootstrap all nodes and master/minion
	bootstrap = 'curl -L http://bootstrap.saltstack.org | sudo sh -s -- -M -X'
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

runLocalState = () ->
	localState = 'salt-call state.highstate --local'
	for name, server of servers
		target = {
			host: server.info.accessIPv4
			port: 22
			username: 'root'
			password: server.adminPass
		}
		console.log 'target:', target.host
		sshCommand target, localState, (reply) ->
			cb()

startSaltDaemons = () ->
	startServices = 'service salt-master start && serivce salt-minion start'
	for name, server of servers
		target = {
			host: server.info.accessIPv4
			port: 22
			username: 'root'
			password: server.adminPass
		}
		console.log 'target:', target.host
		sshCommand target, startServices, (reply) ->
			cb()

runAppState = () ->
	appState = 'salt-call state.highstate'
	for name, server of servers
		target = {
			host: server.info.accessIPv4
			port: 22
			username: 'root'
			password: server.adminPass
		}
		console.log 'target:', target.host
		sshCommand target, appState, (reply) ->
			cb()

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

localCommand = (command, cb) ->
	exec command, (error, stdout, stderr) ->
		sys.print 'stdout: ' + stdout
		sys.print 'stderr: ' + stderr
		if error != null
			console.log 'exec error: ' + error

