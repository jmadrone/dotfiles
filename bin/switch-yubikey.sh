#!/bin/bash
pkill gpg-agent ssh-agent pinentry ; eval $(gpg-agent --daemon --enable-ssh-support)
gpg-connect-agent updatestartuptty /bye
