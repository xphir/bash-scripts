#!/bin/bash
# Loop through each of our nvme devices (this will loop through devices like /dev/nvme0 or /dev/nvme2, but will skip partitions like /dev/nvme0n1)
# Note this will not handle more than 10 nvme devices
for NVME_DEVICE in /dev/nvme?
do
	# Initial Declares
	TEMP_STATUS=0
	TEMP_STATUS_TEXT=OK
	SMART_STATUS=0
	SMART_STATUS_TEXT=OK
	# Grab our smart info for this nvme drive
	SMARTCTL_X_OUTPUT=$(smartctl $NVME_DEVICE -x)
	# Get the name of this drive (eg. NVME0 or NVME1)
	DEVICE_NAME=$(echo ${NVME_DEVICE///dev\//})
	# SMART Temperature Information
	WARNING_TEMP=$(echo "$SMARTCTL_X_OUTPUT" | grep 'Warning  Comp. Temp. Threshold:' | awk '{print $5}')
	CRITICAL_TEMP=$(echo "$SMARTCTL_X_OUTPUT" | grep 'Critical Comp. Temp. Threshold:' | awk '{print $5}')
	TEMP=$(echo "$SMARTCTL_X_OUTPUT" | grep Temperature: | awk '{print $2}')
	# SMART DETAILS
	BRAND=$(echo "$SMARTCTL_X_OUTPUT" | grep 'Model Number:' | awk '{print $3}')
	MODEL_NUMBER=$(echo "$SMARTCTL_X_OUTPUT" | grep 'Model Number:' | awk '{print $4}')
	SERIAL_NUMBER=$(echo "$SMARTCTL_X_OUTPUT" | grep 'Serial Number' | awk '{print $3}')
	SMART_STATUS_STRING=$(echo "$SMARTCTL_X_OUTPUT" | grep 'SMART overall-health self-assessment test result:' | awk '{print $6}')
	DATA_UNITS_READ=$(echo "$SMARTCTL_X_OUTPUT" | grep 'Data Units Read:' | awk '{print $5}' | tr -d [])
	DATA_UNITS_WRITTEN=$(echo "$SMARTCTL_X_OUTPUT" | grep 'Data Units Written:' | awk '{print $5}' | tr -d [])
	POWER_CYCLES=$(echo "$SMARTCTL_X_OUTPUT" | grep 'Power Cycles:' | awk '{print $3}')
	POWER_ON_HOURS=$(echo "$SMARTCTL_X_OUTPUT" | grep 'Power On Hours:' | awk '{print $4}')
	UNSAFE_SHUTDOWNS=$(echo "$SMARTCTL_X_OUTPUT" | grep 'Unsafe Shutdowns:' | awk '{print $3}')
	MEDIA_AND_DATA_INTEGRITY_ERRORS=$(echo "$SMARTCTL_X_OUTPUT" | grep 'Media and Data Integrity Errors:' | awk '{print $6}')
	ERROR_INFORMATION_LOG_ENTRIES=$(echo "$SMARTCTL_X_OUTPUT" | grep 'Error Information Log Entries:' | awk '{print $5}')
	# Get our temp status
	if [ $TEMP -ge $CRITICAL_TEMP ]
	then
		TEMP_STATUS=2
		TEMP_STATUS_TEXT=CRITICAL
	elif [ $TEMP -ge $WARNING_TEMP ]
	then
		TEMP_STATUS=1
		TEMP_STATUS_TEXT=WARNING
	fi

	# Get our smart status
	if [ "$SMART_STATUS_STRING" = "PASSED" ]
	then
		SMART_STATUS=0
		SMART_STATUS_TEXT=OK
	elif [ "$SMART_STATUS_STRING" = "FAILED!" ]
	then
		SMART_STATUS=2
		SMART_STATUS_TEXT=CRITICAL
	fi
	echo "$TEMP_STATUS ${DEVICE_NAME^^}_TEMP temperature=$TEMP;$WARNING_TEMP;$CRITICAL_TEMP $TEMP_STATUS_TEXT - $TEMP °C"
	echo "$SMART_STATUS ${DEVICE_NAME^^}_SMART units_read_tb=$DATA_UNITS_READ|units_written_tb=$DATA_UNITS_WRITTEN|power_cycles=$POWER_CYCLES|unsafe_shutdowns=$UNSAFE_SHUTDOWNS|media_and_data_integrity_errors=$MEDIA_AND_DATA_INTEGRITY_ERRORS|error_information_log_entries=$ERROR_INFORMATION_LOG_ENTRIES $SMART_STATUS_TEXT - $BRAND $MODEL_NUMBER $SERIAL_NUMBER  - $SMART_STATUS_STRING SMART Tests "
done
