#!/usr/bin/bash

ssh -NL 65117:127.0.0.1:27017 -i ~/.ssh/id_rsa_desktop-JJ95ENL_no_passphrase raychorn@10.0.0.179
ssh -NL 65217:127.0.0.1:27017 -i ~/.ssh/id_rsa_desktop-JJ95ENL_no_passphrase raychorn@10.0.0.239
ssh -NL 65317:127.0.0.1:27017 -i ~/.ssh/id_rsa_desktop-JJ95ENL_no_passphrase raychorn@10.0.0.233
ssh -NL 65417:127.0.0.1:27017 -i ~/.ssh/id_rsa_desktop-JJ95ENL_no_passphrase raychorn@10.0.0.240
