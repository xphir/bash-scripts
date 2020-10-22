# Proxmox bug fix scripts

## RRDC update error & RRD update error fix: illegal attempt to update using time
Note: The following values in the error will be different for you .
| Variable         | Note                                                    |
|----------------- |---------------------------------------------------------|
| {SERVERNAME}     | Your Proxmox server name (eg. pve)                      |
| {VMID}           | Your VM id (eg. 103)                                    |
| {STORAGE_LOCAL}  | Your local storage name (eg. local-zfs)                 |
| {STORAGE_NET}    | Your network storage name (you might not have this one) |

This error seems to occur after you have made a time change to your server (eg, changed the BIOS time). It didn't seem to fix the issue even when I revered the time change. If you have a cluster it will show this error on every server within the cluster.

Sample error message (this shows up in your syslog)

> Oct  3 19:55:28 {SERVERNAME} pmxcfs[915]: [status] notice: RRDC update error /var/lib/rrdcached/db/pve2-node/{SERVERNAME}: -1
> Oct  3 19:55:28 {SERVERNAME} pmxcfs[915]: [status] notice: RRD update error /var/lib/rrdcached/db/pve2-node/{SERVERNAME}: /var/lib/rrdcached/db/pve2-node/{SERVERNAME}: illegal attempt to update using time 1601718928 when last update time is 1601727313 (minimum one second step)
> Oct  3 19:55:28 {SERVERNAME} pvestatd[1077]: file '/var/run/qemu-server/{VMID}.pid' modified in future
> Oct  3 19:55:28 {SERVERNAME} pmxcfs[915]: [status] notice: RRDC update error /var/lib/rrdcached/db/pve2-vm/{VMID}: -1
> Oct  3 19:55:29 {SERVERNAME} pmxcfs[915]: [status] notice: RRDC update error /var/lib/rrdcached/db/pve2-storage/{SERVERNAME}/{STORAGE_LOCAL}: -1
> Oct  3 19:55:29 {SERVERNAME} pmxcfs[915]: [status] notice: RRD update error /var/lib/rrdcached/db/pve2-storage/{SERVERNAME}/{STORAGE_LOCAL}: /var/lib/rrdcached/db/pve2-storage/{SERVERNAME}/{STORAGE_LOCAL}: illegal attempt to update using time 1601718928 when last update time is 1601727313 (minimum one second step)
> Oct  3 19:55:29 {SERVERNAME} pmxcfs[915]: [status] notice: RRDC update error /var/lib/rrdcached/db/pve2-storage/{SERVERNAME}/{STORAGE_NET}: -1
> Oct  3 19:55:29 {SERVERNAME} pmxcfs[915]: [status] notice: RRDC update error /var/lib/rrdcached/db/pve2-storage/{SERVERNAME}/local: -1
> Oct  3 19:55:29 {SERVERNAME} pmxcfs[915]: [status] notice: RRD update error /var/lib/rrdcached/db/pve2-storage/{SERVERNAME}/local: /var/lib/rrdcached/db/pve2-storage/{SERVERNAME}/local: illegal attempt to update using time 1601718928 when last update time is 1601727313 (minimum one second step) 

Solution Script

`bash <(curl -Ss https://raw.githubusercontent.com/xphir/proxmox/master/bugfixes/FIX-rrdcached-illegal-attempt-to-update-using-time.sh)`
