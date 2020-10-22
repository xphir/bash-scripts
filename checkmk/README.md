# Check MK Scripts

## Scripts for Check MK local checks
https://checkmk.com/cms_localchecks.html

### nvme_check.sh
This script gives monitoring on the NVMe devices on a linux machine (tested on proxmox)
Returns a temperature result and a smart result

Temperature results example
> 0 NVME0_TEMP temperature=35;75;80 OK - 35 °C

SMART results example
> 0 NVME0_SMART units_read_tb=1.08|units_written_tb=3.67|power_cycles=68|unsafe_shutdowns=27|media_and_data_integrity_errors=2|error_information_log_entries=0 OK - KINGSTON SA2000M81000G 50026B728267EFAF  - PASSED SMART Tests
