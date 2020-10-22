#!/bin/bash
chown mrfishy:mrfishy /home/fishy/.config/fish/config.fish

service ssh start && service nginx start