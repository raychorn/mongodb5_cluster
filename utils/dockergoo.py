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
    with open(fname, 'w') as fOut:
        @tunnel.ssh_tunnel(remote='10.0.0.179:22', ssh_username='raychorn', ssh_pkey='~/.ssh/id_rsa_desktop-JJ95ENL_no_passphrase', remote_bind_address='127.0.0.1:2375', local_bind_address='127.0.0.1:12375')
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
