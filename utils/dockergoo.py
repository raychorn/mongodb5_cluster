import os
import sys
import docker
import dotenv

import fast_json as json

import socket

dotenv.load_dotenv(dotenv.find_dotenv())
assert os.environ.get('DOCKER_HOST'), 'DOCKER_HOST is not set.'

libs = os.environ.get('libs')
if (libs):
    sys.path.insert(0, libs)

__host__ = socket.gethostname()
__is_prod__ = __host__ in ['DESKTOP-9J3LL5Q']

from vyperlogix.misc import _utils
from vyperlogix.decorators import tunnel

ssh_pkey = os.environ.get('PRIVKEY')
assert _utils.is_something(ssh_pkey), 'ssh_pkey is not set.  Check your .env file.'

remote_bind_address = os.environ.get('REMOTE_DOCKER')
assert _utils.is_something(remote_bind_address), 'remote_bind_address is not set.  Check your .env file.'

local_bind_port = os.environ.get('DOCKER_PORT')

local_bind_address = '127.0.0.1:{}'.format(local_bind_port)

def get_volumes(containers, type='volume'):
    volumes = []
    for container in containers:
        for mount in container.get('Mounts'):
            mount_type = mount.get('type')
            if (mount_type == type):
                volumes.append(mount)
    return volumes


if (__name__ == "__main__"):
    fname = os.path.curdir + '/report.json'

    sources = os.environ.get('SOURCE')
    assert _utils.is_something(sources), 'SOURCE is not set.  Check your .env file.'
    sources = eval(sources)
    the_sources = []
    for name in sources:
        addr = os.environ.get(name)
        assert _utils.is_something(addr), 'The deployment: {} is not set.  Check your .env file.'.format(name)
        the_sources.append({'name': name, 'addr': addr})

    deployments = os.environ.get('DEPLOYMENT')
    assert _utils.is_something(deployments), 'DEPLOYMENT is not set.  Check your .env file.'
    deployments = eval(deployments)

    the_deployments = []
    for name in deployments:
        addr = os.environ.get(name)
        assert _utils.is_something(addr), 'The deployment: {} is not set.  Check your .env file.'.format(name)
        the_deployments.append({'name': name, 'addr': addr})

    for a_deployment in the_deployments:
        remote_addr = a_deployment.get('addr')
        assert _utils.is_something(remote_addr), 'The deployment addr: {} is not set.  Check your .env file.'.format(remote_addr)
        ssh_username = remote_addr.split('@')[0]
        remote = remote_addr.split('@')[-1]
        assert _utils.is_something(remote), 'The deployment IP: {} is not set.  Check your .env file.'.format(remote)
        if (remote.fine(':') == -1):
            remote = '{}:{}'.format(remote, 22)
        with open(fname, 'w') as fOut:
            @tunnel.ssh_tunnel(remote=remote, ssh_username=ssh_username, ssh_pkey=ssh_pkey, remote_bind_address=remote_bind_address, local_bind_address=local_bind_address)
            def do_the_thing(**kwargs):
                _utils.os_command('netstat -tunlp', message='(***)', verbose=True)
                host = os.environ.get('DOCKER_HOST{}'.format('' if (__is_prod__) else '_DEV'))
                assert host, 'DOCKER_HOST is not set.'
                client = docker.DockerClient(base_url=host)
                containers = []
                volumes = get_volumes(containers)
                all_volumes = client.volumes.list()
                for c in client.containers.list():
                    print(c.name)
                    containers.append(c.attrs)
                    if (0):
                        j = json.dumps(c.attrs, indent=4)
                        if (1):
                            print(j, file= fOut)
                        print('='*30)
                        print()
                print(json.dumps(containers, indent=4), file= fOut)

            do_the_thing()
        print('Done.')
