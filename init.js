// Generated by CoffeeScript 1.6.3
(function() {
  var Connection, attachNetwork, attachStorage, buildNetwork, buildSaltConfigs, buildServers, buildStorage, checkinSaltConfigs, checkoutSaltConfigs, deploySaltConfigs, exec, fs, installSaltDaemons, localCommand, privKey, pubKey, rack, racksjs, recipe, repo, runAppState, runLocalState, setupSshKeys, sleep, sshCommand, startSaltDaemons, steak, sys,
    _this = this;

  racksjs = require('./racks.js');

  rack = false;

  sys = require('sys');

  fs = require('fs');

  exec = require('child_process').exec;

  Connection = require('ssh2');

  sleep = require('sleep');

  repo = 'git@github.com:asdqwex/salt.git';

  pubKey = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDiYXESJlAJ1KLKRPpQetKkv4nczQKg921LB2yuO4ehFQ+yVtVYa1QAhi/Qkpqmb7FbkJd+HZ4wAbtGDEXgal14mbvMJ368zo48/AUzpBYFC9lVdVY4Pz/KBBV1uzLOTZdKlo2JUBHY+jiGLN8cZR7W6V8mmz+0DEfeCSdWuICJtNH+pYC+D5CMK76noiTbqhEJ+WOjMZLm5fDYigZqXQz1BzkrmJMmnX5WP1DR3Ll9tmq39AwlPMMyFKHdahepe/5oVe9YCsapqtPaf6zAanhuRxihfZIaYrwKFdyJB3lC2BRfsrv3SXP+CoaaqJa/gZd2ydWgDOrL3grbqdYUcJfh root@dev';

  privKey = '-----BEGIN RSA PRIVATE KEY-----\nMIIEogIBAAKCAQEA4mFxEiZQCdSiykT6UHrSpL+J3M0CoPdtSwdsrjuHoRUPslbV\nWGtUAIYv0JKapm+xW5CXfh2eMAG7RgxF4GpdeJm7zCd+vM6OPPwFM6QWBQvZVXVW\nOD8/ygQVdbsyzk2XSpaNiVAR2Po4hizfHGUe1ulfJps/tAxH3gknVriAibTR/qWA\nvg+QjCu+p6Ik26oRCfljozGS5uXw2IoGal0M9Qc5K5iTJp1+Vj9Q0dy5fbZqt/QM\nJTzDMhSh3WoXqXv+aFXvWArGqarT2n+swGp4bkcYoX2SGmK8ChXciQd5QtgUX7K7\n90lz/gqGmqiWv4GXdsnVoAzqy94K26nWFHCX4QIDAQABAoIBAAiuNdi9UVpfJfLd\nnD+Txhn9IjsuPUiQ1EcJPNidfcDmftiWzc17KBhxDMpRpM52//UD4Vs7pYIvvs+b\nzt4hFf523qWgahKxVPDvtP9a7mE5KBdHzYuQmVCUwYHnMLaKcR+yEDFQua55Qcub\nUt7S3dDd2AEx+Mpdoi/YaALCRmOBUghccYz9MExuoVYriRYnvetJs8XeRpOgNYBV\nYuFjf2D60xDqPGCECTD1bktZPZv868g2XJQVdo0p0VpIWzNilRLIHhC8os43ZtW1\nNVy9ZpO6YEQ8Mt922meaNR+rp0HGk9nZOMMGbMlj7T8ccONrVHhJTUAeeAWb7p61\nEIqAFVUCgYEA9qwIn9aXmzxssjavYvfJITbvou07c5s/hBA0vhyRf4VjGE9q+fAg\nspYy1uviKopWspjxfbISafTB9JDtgxS9xA3YDutyXygsDiYhEigi+gKDFrMlVcTa\n7/xZog5g2Mk523AyxzlY5ZJq1ffRE/fSJsT8uLxKwaGD8tfQ9tuRzbsCgYEA6vD4\n+m32wefYiitiR3k86wiO/i6sOJHCOPoovkrnfRaV9rZaflgqG2nNmK+GiE5KP34+\nejvyj5MPY9cPU4MkQVhvUyUc4d346NayB0uybOLbVh2QqSp3nPF0cBNGd/0mQdtS\nda9AVwWUNzPv26AJGOvj+p5PvwI4P+IO8JWcSRMCgYBvRlPtpuRlRvDRxBGCV70H\nmrynhtUW5aXVcWoZiNGp8QYu5USg004swczVXzt7bUSG9K+bwETGP39vUCGUzDp+\nwrAAqv3BJ2IYT+MDSc/dcFyqVM42zsLlF7VngYz2vm+3Kfn+HUSY61/+ffh3RYgr\nrRlETMx8ZNwdJHZDpfE0GQKBgFp5jggyzLIDrLoY1vIbWEBSvW5ZXu0yBI+YlpQh\nmF/tkLa/pr29CgoghpJkFfTr4V/uJ/U+nLx5r5WNPlO0zwNzIPvt8N9yceaIt2pj\n1kRkYH8bR5g9yG5h9asrYRnYHSGDao/ze12Hwno3wAjd6mL0hIkA6kjue+buET7I\n/rSNAoGAKZA/ri9OmOLhPvT0vxrl2pIXfDGVqHwLvNO4aQdxZ9RKmWZ0/YxDU7sC\nrRFP5xFhCFyn9KClLMWfHv44nL32CM7/o2wBhSFqyMshsZaNZ/+egQzC4lhBcKJg\nrmCmYfedD1bdKIzK+Hmn4FxBKlexZfQsM2gVWxJaYErRickD6M4=\n-----END RSA PRIVATE KEY-----';

  recipe = {
    servers: {
      'gluster1': {
        name: 'gluster1',
        imageRef: "80fbcb55-b206-41f9-9bc2-2dd7aac6c061",
        flavorRef: "performance1-1",
        metadata: {
          label: 'glusterfs-node'
        }
      }
    },
    networks: {
      'gluster-private': {
        label: 'gluster-private',
        cidr: '172.16.0.0/24'
      }
    },
    storage: {
      'gluster1': {
        display_name: 'gluster1',
        size: '100'
      }
    }
  };

  steak = {
    servers: {},
    networks: {},
    storage: {}
  };

  new racksjs({
    username: process.argv[2],
    apiKey: process.argv[3],
    verbosity: 0,
    cache: false
  }, function(rs) {
    rack = rs;
    rack.datacenter = 'IAD';
    return buildServers(recipe.servers, function(servers) {
      return buildNetwork(recipe.networks, function(networks) {
        return buildStorage(recipe.storage, function(storage) {
          return attachNetwork(steak.networks, steak.servers, function(vips) {
            return attachStorage(steak.storage, steak.servers, function(devices) {
              return setupSshKeys(steak.servers, function() {
                return checkoutSaltConfigs(function() {
                  return buildSaltConfigs(steak.servers, function() {
                    return checkinSaltConfigs(function() {
                      return deploySaltConfigs(steak.servers, function() {
                        return installSaltDaemons(steak.servers, function() {
                          return runLocalState(steak.servers, function() {
                            return startSaltDaemons(steak.servers, function() {
                              return runAppState(steak.servers, function() {});
                            });
                          });
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  });

  buildServers = function(servers, cb) {
    var apiCalls, name, server, _results;
    apiCalls = 0;
    _results = [];
    for (name in servers) {
      server = servers[name];
      apiCalls++;
      console.log('creating server:', name);
      _results.push(rack.servers["new"](server, function(response) {
        console.log('server creation submitted for:', response.id);
        return response.systemActive(function(details) {
          console.log('server created:', details.name, 'at', details.accessIPv4);
          steak.servers[details.name] = response;
          steak.servers[details.name].info = details;
          apiCalls--;
          if (apiCalls === 0) {
            return cb();
          }
        });
      }));
    }
    return _results;
  };

  buildNetwork = function(networks, cb) {
    var name, network, _results;
    _results = [];
    for (name in networks) {
      network = networks[name];
      console.log('creating network', name, network);
      _results.push(rack.networks["new"](network, function(cloudnet) {
        console.log('network created', cloudnet.id);
        steak.networks[cloudnet.label] = cloudnet;
        return cb();
      }));
    }
    return _results;
  };

  buildStorage = function(storage, cb) {
    var apiCalls, name, volume, _results;
    apiCalls = 0;
    _results = [];
    for (name in storage) {
      volume = storage[name];
      apiCalls++;
      console.log('creating volume', name, 'size', volume.size);
      _results.push(rack.cloudBlockStorage.volumes["new"](volume, function(details) {
        console.log('created volume', details.id);
        steak.storage[details.display_name] = details;
        apiCalls--;
        if (apiCalls === 0) {
          return cb();
        }
      }));
    }
    return _results;
  };

  attachNetwork = function(networks, servers, cb) {
    var apiCalls, id, name, network, server, _results;
    _results = [];
    for (id in networks) {
      network = networks[id];
      apiCalls = 0;
      console.log('network found:', network.label);
      _results.push((function() {
        var _results1;
        _results1 = [];
        for (name in servers) {
          server = servers[name];
          apiCalls++;
          _results1.push((function() {
            var myserver, servername;
            servername = name;
            myserver = server;
            return myserver.attachNetwork({
              network_id: network.id
            }, function(vip) {
              sleep.sleep(10);
              return myserver.getVips(function(vips) {
                var address, item, _i, _len, _ref, _results2;
                _ref = vips.virtual_interfaces;
                _results2 = [];
                for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                  item = _ref[_i];
                  _results2.push((function() {
                    var _j, _len1, _ref1, _results3;
                    _ref1 = item.ip_addresses;
                    _results3 = [];
                    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
                      address = _ref1[_j];
                      if (address.network_label === network.label) {
                        steak.servers[servername].info.glusterVip = address.address;
                        console.log('gluster-network address', address);
                        apiCalls--;
                        if (apiCalls === 0) {
                          _results3.push(cb());
                        } else {
                          _results3.push(void 0);
                        }
                      } else {
                        _results3.push(void 0);
                      }
                    }
                    return _results3;
                  })());
                }
                return _results2;
              });
            });
          })());
        }
        return _results1;
      })());
    }
    return _results;
  };

  attachStorage = function(volumes, servers, cb) {
    var attachment, id, name, server, volume, _results;
    _results = [];
    for (id in volumes) {
      volume = volumes[id];
      console.log('found volume', id);
      _results.push((function() {
        var _results1;
        _results1 = [];
        for (name in servers) {
          server = servers[name];
          if (name === volume.display_name) {
            attachment = {
              volumeAttachment: {
                device: null,
                volumeId: volume.id
              }
            };
            console.log('attaching volume', id, 'to server', name);
            _results1.push(server.attachVolume(attachment, function(volId) {
              console.log('attachment deatils', volId.volumeAttachment.device);
              return cb();
            }));
          } else {
            _results1.push(void 0);
          }
        }
        return _results1;
      })());
    }
    return _results;
  };

  setupSshKeys = function(servers, cb) {
    var injectKeys, name, server, target, _results;
    console.log('setupSshKeys');
    injectKeys = 'echo "' + privKey + '" > ~/.ssh/id_rsa && echo "' + pubKey + '" >> ~/.ssh/authorized_keys';
    _results = [];
    for (name in servers) {
      server = servers[name];
      target = {
        host: server.info.accessIPv4,
        port: 22,
        username: 'root',
        password: server.adminPass
      };
      console.log('target:', target.host);
      _results.push(sshCommand(target, injectKeys, function(reply) {
        return cb();
      }));
    }
    return _results;
  };

  checkoutSaltConfigs = function(cb) {
    var command;
    console.log('checkoutSaltConfigs');
    command = 'cd /tmp/ && rm -rf /tmp/salt && git clone ' + repo;
    console.log(command);
    return localCommand(command, function(out) {
      return cb();
    });
  };

  buildSaltConfigs = function(servers, cb) {
    var generateHosts, generateMinionConfig, getIps;
    console.log('buildSaltConfigs');
    getIps = function(servers, cb) {
      var ipCount, ips, name, server, _results;
      ipCount = 0;
      ips = [];
      _results = [];
      for (name in servers) {
        server = servers[name];
        _results.push((function() {
          var currentServer;
          currentServer = server;
          ipCount++;
          ips.push(currentServer.info.glusterVip);
          if (ipCount === Object.keys(servers).length) {
            return cb(ips);
          }
        })());
      }
      return _results;
    };
    generateMinionConfig = function(ips, cb) {
      var minionConfig, minionCount, name, server, _results;
      minionConfig = 'master: \r\n';
      fs.appendFile('/tmp/salt/minion', minionConfig, function(err) {});
      minionCount = 0;
      _results = [];
      for (name in servers) {
        server = servers[name];
        _results.push((function() {
          var currentServer, line;
          currentServer = server;
          line = currentServer.info.glusterVip.toString();
          return fs.appendFile('/tmp/salt/minion', line, function() {
            minionCount++;
            if (minionCount === ips.length) {
              return cb();
            }
          });
        })());
      }
      return _results;
    };
    generateHosts = function(servers, cb) {
      var hostsCount, line, name, server, _results;
      hostsCount = 0;
      line = '';
      _results = [];
      for (name in servers) {
        server = servers[name];
        _results.push((function() {
          var currentServer;
          currentServer = server;
          line = currentServer.info.glusterVip.toString() + "		" + name;
          console.log(line);
          return fs.appendFile('/tmp/salt/hosts', line, function(err) {
            hostsCount++;
            if (hostsCount === Object.keys(servers).length) {
              return cb(line);
            }
          });
        })());
      }
      return _results;
    };
    return getIps(servers, function(ips) {
      return generateMinionConfig(ips, function(minioncfg) {
        return generateHosts(servers, function(hosts) {
          return cb();
        });
      });
    });
  };

  checkinSaltConfigs = function(cb) {
    var command;
    console.log('checkinSaltConfigs');
    command = 'cd /tmp/salt && git add . && git commit -m "deployemnt" && git push ';
    return localCommand(command, function(out) {
      console.log(out);
      return cb();
    });
  };

  deploySaltConfigs = function(servers, cb) {
    var checkloutConfigs, name, server, target, _results;
    console.log('deploySaltConfigs');
    checkloutConfigs = 'apt-get -y install git && cd /root && git clone ' + repo;
    _results = [];
    for (name in servers) {
      server = servers[name];
      target = {
        host: server.info.accessIPv4,
        port: 22,
        username: 'root',
        password: server.adminPass
      };
      console.log('target:', target.host);
      _results.push(sshCommand(target, checkloutConfigs, function(reply) {
        return cb();
      }));
    }
    return _results;
  };

  installSaltDaemons = function(servers, cb) {
    var bootstrap, minion, name, server, _results;
    console.log('installSaltDaemons');
    bootstrap = 'curl -L http://bootstrap.saltstack.org | sudo sh -s -- -M -X';
    _results = [];
    for (name in servers) {
      server = servers[name];
      minion = {
        host: server.info.accessIPv4,
        port: 22,
        username: 'root',
        password: server.adminPass
      };
      console.log('target:', minion.host);
      _results.push(sshCommand(minion, bootstrap, function(reply) {
        return cb();
      }));
    }
    return _results;
  };

  runLocalState = function(servers, cb) {
    var localState, name, server, target, _results;
    console.log('runLocalState');
    localState = 'salt-call state.highstate --local';
    _results = [];
    for (name in servers) {
      server = servers[name];
      target = {
        host: server.info.accessIPv4,
        port: 22,
        username: 'root',
        password: server.adminPass
      };
      console.log('target:', target.host);
      _results.push(sshCommand(target, localState, function(reply) {
        return cb();
      }));
    }
    return _results;
  };

  startSaltDaemons = function(servers, cb) {
    var name, server, startServices, target, _results;
    console.log('startSaltDaemons');
    startServices = 'service salt-master start && serivce salt-minion start';
    _results = [];
    for (name in servers) {
      server = servers[name];
      target = {
        host: server.info.accessIPv4,
        port: 22,
        username: 'root',
        password: server.adminPass
      };
      console.log('target:', target.host);
      _results.push(sshCommand(target, startServices, function(reply) {
        return cb();
      }));
    }
    return _results;
  };

  runAppState = function(servers, cb) {
    var appState, count, name, server, target, _results;
    console.log('runAppState');
    appState = 'salt-call state.highstate';
    count = 0;
    _results = [];
    for (name in servers) {
      server = servers[name];
      count++;
      target = {
        host: server.info.accessIPv4,
        port: 22,
        username: 'root',
        password: server.adminPass
      };
      console.log('target:', target.host);
      _results.push(sshCommand(target, appState, function(reply) {
        return cb();
      }));
    }
    return _results;
  };

  sshCommand = function(target, command, cb) {
    var c;
    c = new Connection();
    c.on('ready', function() {
      console.log('Connection :: ready');
      return c.exec(command, function(err, stream) {
        if (err) {
          throw err;
        }
        stream.on('data', function(data, extended) {
          var _ref;
          return console.log(((_ref = extended === 'stderr') != null ? _ref : {
            'STDERR: ': 'STDOUT: '
          }) + data);
        });
        stream.on('end', function() {
          return console.log('Stream :: EOF');
        });
        stream.on('close', function() {
          return console.log('Stream :: close');
        });
        return stream.on('exit', function(code, signal) {
          console.log('Stream :: exit :: code: ' + code + ', signal: ' + signal);
          return c.end();
        });
      });
    });
    c.on('error', function(err) {
      return console.log('Connection :: error :: ' + err);
    });
    c.on('end', function() {
      return console.log('Connection :: end');
    });
    c.on('close', function(had_error) {
      console.log('Connection :: close');
      return cb();
    });
    return c.connect(target);
  };

  localCommand = function(command, cb) {
    return exec(command, function(error, stdout, stderr) {
      sys.print('stdout: ' + stdout);
      sys.print('stderr: ' + stderr);
      return cb();
    });
  };

}).call(this);
