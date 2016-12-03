#!/sbin/busybox sh

BB=/sbin/busybox;

case "$1" in
	CPUFrequencyList)
		for CPUFREQ in `$BB cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies`; do
		LABEL=$((CPUFREQ / 1000));
			$BB echo "$CPUFREQ:\"${LABEL} MHz\", ";
		done;
	;;
	CPUGovernorList)
		for CPUGOV in `$BB cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors`; do
			$BB echo "\"$CPUGOV\",";
		done;
	;;	
	DefaultCPUFrequency)
		CPU0_FREQMAX="$(expr `cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq` / 1000)MHz";
		CPU0_FREQMIN="$(expr `cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq` / 1000)MHz";
		echo "CPU Max frequency: $CPU0_FREQMAX@nCPU Min frequency: $CPU0_FREQMIN"
	;;
	DefaultCPUCURFrequency)
		CPU0_FREQCUR=`$BB cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2> /dev/null`;
		CPU1_FREQCUR=`$BB cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq 2> /dev/null`;
		CPU2_FREQCUR=`$BB cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_cur_freq 2> /dev/null`;
		CPU3_FREQCUR=`$BB cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_cur_freq 2> /dev/null`;
		
		if [ -z "$CPU0_FREQCUR" ]; then CPU0_FREQCUR="Offline"; else CPU0_FREQCUR="$((CPU0_FREQCUR / 1000)) MHz"; fi;
		if [ -z "$CPU1_FREQCUR" ]; then CPU1_FREQCUR="Offline"; else CPU1_FREQCUR="$((CPU1_FREQCUR / 1000)) MHz"; fi;
		if [ -z "$CPU2_FREQCUR" ]; then CPU2_FREQCUR="Offline"; else CPU2_FREQCUR="$((CPU2_FREQCUR / 1000)) MHz"; fi;
		if [ -z "$CPU3_FREQCUR" ]; then CPU3_FREQCUR="Offline"; else CPU3_FREQCUR="$((CPU3_FREQCUR / 1000)) MHz"; fi;
		$BB echo "CPU Core0: ${CPU0_FREQCUR}@nCPU Core1: ${CPU1_FREQCUR}@nCPU Core2: ${CPU2_FREQCUR}@nCPU Core3: ${CPU3_FREQCUR}";
	;;
	DefaultGPUGovernor)
		POLICY=`$BB cat /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/pwrscale/policy`
		if [ "$POLICY" = "trustzone" ]; then
			$BB echo "`$BB cat /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/pwrscale/$POLICY/governor`"
		else
			$BB echo $POLICY;
		fi;
	;;
	DirKernelIMG)
		$BB echo "/dev/block/platform/msm_sdcc.1/by-name/boot";
	;;
	DirCPUGovernor)
		$BB echo "/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor";
	;;
	DirCPUGovernorTree)
		$BB echo "/sys/devices/system/cpu/cpufreq";
	;;
	DirCPUMaxFrequency)
		$BB echo "/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq";
	;;
	DirCPUMinFrequency)
		$BB echo "/sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq";
	;;
	DirGPUGovernor)
		$BB echo "/sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/pwrscale/trustzone/governor";
	;;
	DirGPUMaxFrequency)
		$BB echo "/sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/max_gpuclk";
	;;
	DirGPUMinPwrLevel)
		$BB echo "/sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/min_pwrlevel";
	;;
	DirGPUNumPwrLevels)
		$BB echo "/sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/num_pwrlevels";
	;;
	DirGPUPolicy)
		$BB echo "/sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/pwrscale/policy";
	;;
	DirIOReadAheadSize)
		$BB echo "/sys/block/mmcblk0/queue/read_ahead_kb";
	;;
	DirIOScheduler)
		$BB echo "/sys/block/mmcblk0/queue/scheduler";
	;;
	DirIOSchedulerTree)
		$BB echo "/sys/block/mmcblk0/queue/iosched";
	;;
	DirTCPCongestion)
		$BB echo "/proc/sys/net/ipv4/tcp_congestion_control";
	;;
	GPUFrequencyList)
		for GPUFREQ in `$BB cat /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/gpu_available_frequencies | $BB tr ' ' '\n' | $BB sort -u` ; do
		LABEL=$((GPUFREQ / 1000000));
			$BB echo "$GPUFREQ:\"${LABEL} MHz\", ";
		done;
	;;
	GPUGovernorList)
		GOV="ondemand, performance";
		if [ -f "/sys/module/msm_kgsl_core/parameters/simple_laziness" ] || [ -f "/sys/module/msm_kgsl_core/parameters/simple_ramp_threshold" ]; then
			GOV="$GOV, simple";
		fi;
		
		$BB echo $GOV;
	;;
	GPUPowerLevel)
		NUM_PWRLVL=`$BB cat /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/num_pwrlevels`;
		PWR_LEVEL=-1;
		for GPUFREQ in `$BB cat /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/gpu_available_frequencies`; do
		PWR_LEVEL=$((PWR_LEVEL + 1));
		MIN_PWRLVL=$((NUM_PWRLVL - PWR_LEVEL));
		LABEL=$((GPUFREQ / 1000000));
			$BB echo "$MIN_PWRLVL:\"${LABEL} MHz\", ";
		done;
	;;
	IOSchedulerList)
		for IOSCHED in `$BB cat /sys/block/mmcblk0/queue/scheduler | $BB sed -e 's/\]//;s/\[//'`; do
			$BB echo "\"$IOSCHED\",";
		done;
	;;
	LiveBatteryTemperature)
		BAT_C=`$BB awk '{ print $1 / 10 }' /sys/class/power_supply/battery/temp`;
		BAT_F=`$BB awk "BEGIN { print ( ($BAT_C * 1.8) + 32 ) }"`;
		BAT_H=`$BB cat /sys/class/power_supply/battery/health`;

		$BB echo "$BAT_C°C | $BAT_F°F@nHealth: $BAT_H";
	;;
	LiveCPUTemperature)
		CPU_C=`$BB cat /sys/class/thermal/thermal_zone5/temp`;
		CPU_F=`$BB awk "BEGIN { print ( ($CPU_C * 1.8) + 32 ) }"`;

		$BB echo "$CPU_C°C";
	;;
	LiveSOCTemperature)
		SOC_C=`$BB cat /sys/class/thermal/thermal_zone1/temp`;
		SOC_F=`$BB awk "BEGIN { print ( ($CPU_C * 1.8) + 32 ) }"`;

		$BB echo "$SOC_C°C";
	;;
	LiveGPUFrequency)
		GPUFREQ="$((`$BB cat /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/gpuclk` / 1000000)) MHz";
		$BB echo "$GPUFREQ";
	;;
	LiveMemory)
		while read TYPE MEM KB; do
			if [ "$TYPE" = "MemTotal:" ]; then
				TOTAL="$((MEM / 1024)) MB";
			elif [ "$TYPE" = "MemFree:" ]; then
				CACHED=$((MEM / 1024));
			elif [ "$TYPE" = "Cached:" ]; then
				FREE=$((MEM / 1024));
			fi;
		done < /proc/meminfo;

		FREE="$((FREE + CACHED)) MB";
		$BB echo "Total: $TOTAL@nFree: $FREE";
	;;
	LiveTime)
		STATE="";
		CNT=0;
		SUM=`$BB awk '{s+=$2} END {print s}' /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state`;

		while read FREQ TIME; do
			if [ "$CNT" -ge $2 ] && [ "$CNT" -le $3 ]; then
				FREQ="$((FREQ / 1000)) MHz:";
				if [ $TIME -ge "100" ]; then
					PERC=`$BB awk "BEGIN { print ( ($TIME / $SUM) * 100) }"`;
					PERC="`$BB printf "%0.1f\n" $PERC`%";
					TIME=$((TIME / 100));
					STATE="$STATE $FREQ `$BB echo - | $BB awk -v "S=$TIME" '{printf "%dh:%dm:%ds",S/(60*60),S%(60*60)/60,S%60}'` ($PERC)@n";
				fi;
			fi;
			CNT=$((CNT+1));
		done < /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state;

		STATE=${STATE%??};
		$BB echo "$STATE";
	;;
	LiveUpTime)
		TOTAL=`$BB awk '{ print $1 }' /proc/uptime`;
		AWAKE=$((`$BB awk '{s+=$2} END {print s}' /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state` / 100));
		SLEEP=`$BB awk "BEGIN { print ($TOTAL - $AWAKE) }"`;

		PERC_A=`$BB awk "BEGIN { print ( ($AWAKE / $TOTAL) * 100) }"`;
		PERC_A="`$BB printf "%0.1f\n" $PERC_A`%";
		PERC_S=`$BB awk "BEGIN { print ( ($SLEEP / $TOTAL) * 100) }"`;
		PERC_S="`$BB printf "%0.1f\n" $PERC_S`%";

		TOTAL=`$BB echo - | $BB awk -v "S=$TOTAL" '{printf "%dh:%dm:%ds",S/(60*60),S%(60*60)/60,S%60}'`;
		AWAKE=`$BB echo - | $BB awk -v "S=$AWAKE" '{printf "%dh:%dm:%ds",S/(60*60),S%(60*60)/60,S%60}'`;
		SLEEP=`$BB echo - | $BB awk -v "S=$SLEEP" '{printf "%dh:%dm:%ds",S/(60*60),S%(60*60)/60,S%60}'`;
		$BB echo "Total: $TOTAL (100.0%)@nSleep: $SLEEP ($PERC_S)@nAwake: $AWAKE ($PERC_A)";
	;;
	LiveUnUsed)
		UNUSED="";
		while read FREQ TIME; do
			FREQ="$((FREQ / 1000)) MHz";
			if [ $TIME -lt "100" ]; then
				UNUSED="$UNUSED$FREQ, ";
			fi;
		done < /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state;

		UNUSED=${UNUSED%??};
		$BB echo "$UNUSED";
	;;
	LiveWakelocksKernel)
		WL="";
		CNT=0;
		PATH=/sdcard/wakelocks.txt;
		$BB sort -nrk 7 /proc/wakelocks > $PATH;

		while read NAME COUNT EXPIRE_COUNT WAKE_COUNT ACTIVE_SINCE TOTAL_TIME SLEEP_TIME MAX_TIME LAST_CHANGE; do
			if [ $CNT -lt 10 ]; then
				NAME=`$BB echo $NAME | $BB sed 's/PowerManagerService./PMS./;s/"//g'`
				TIME=`$BB awk "BEGIN { print ( $SLEEP_TIME / 1000000000 ) }"`;
				TIME=`$BB echo - | $BB awk -v "S=$TIME" '{printf "%dh:%dm:%ds",S/(60*60),S%(60*60)/60,S%60}'`;
				WL="$WL$NAME: $TIME@n";
			fi;
			CNT=$((CNT+1));
		done < $PATH;
		$BB rm -f $PATH;

		WL=${WL%??};
		$BB echo $WL;
	;;
	MaxCPU)
		$BB echo "4";
	;;
	MinFreqIndex)
		ID=0;
		MAXID=8;
		while read FREQ TIME; do
			LABEL=$((FREQ / 1000));
			if [ $FREQ -gt "384000" ] && [ $ID -le $MAXID ]; then
				MFIT="$MFIT $ID:\"${LABEL} MHz\", ";
			fi;
			ID=$((ID + 1));
		done < /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state;

		$BB echo $MFIT;
	;;
	SetCPUGovernor)
		for CPU in /sys/devices/system/cpu/cpu[1-3]; do
			$BB echo 1 > $CPU/online;
			$BB echo $2 > $CPU/cpufreq/scaling_governor;
		done;
	;;
	SetCPUMaxFrequency)
		for CPU in /sys/devices/system/cpu/cpu[1-3]; do
			$BB echo 1 > $CPU/online;
			$BB echo $2 > $CPU/cpufreq/scaling_max_freq;
		done;
	;;
	SetCPUMinFrequency)
		for CPU in /sys/devices/system/cpu/cpu[1-3]; do
			$BB echo 1 > $CPU/online;
			$BB echo $2 > $CPU/cpufreq/scaling_min_freq;
		done;
	;;
	SetGPUMinPwrLevel)
		NUM_PWRLVL=`$BB cat /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/num_pwrlevels`;
			if [[ ! -z $3 ]]; then
				PWR_LEVEL=$3;
				MIN_PWRLVL=$((NUM_PWRLVL - PWR_LEVEL));
				$BB echo $MIN_PWRLVL > $2;
			fi;
		$BB echo $((NUM_PWRLVL - `$BB cat $2`));
	;;
	SetGPUGovernor)
		POLICY=/sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/pwrscale/policy;

		if [[ ! -z $3 ]]; then
			case $3 in
				ondemand)
					$BB echo "trustzone" > $POLICY;
					$BB echo $3 > $2;
				;;
				performance)
					$BB echo "trustzone" > $POLICY;
					$BB echo $3 > $2;
				;;
				simple)
					$BB echo "trustzone" > $POLICY;
					$BB echo $3 > $2;
				;;
			esac;
		fi;

		if [ `$BB cat $POLICY` = "trustzone" ]; then
			$BB echo `$BB cat $2`;
		else
			$BB echo `$BB cat $POLICY`;
		fi;
	;;
	TCPCongestionList)
		for TCPCC in `$BB cat /proc/sys/net/ipv4/tcp_available_congestion_control` ; do
			$BB echo "\"$TCPCC\",";
		done;
	;;
	LiveDefaultCPUGovernor)
		cpugov_show=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor);
		echo "$cpugov_show";
	;;
	LiveCPU_HOTPLUG)
		if [ "$(cat /sys/module/msm_hotplug/msm_enabled)" -eq "1" ]; then
			MSM_HOTPLUG=Active;
		else
			MSM_HOTPLUG=Inactive;
		fi;
		if [ "$(cat /sys/module/msm_mpdecision/parameters/enabled)" -eq "1" ]; then
			MSM_MPDECISION=Active;
		else
			MSM_MPDECISION=Inactive;
		fi;
		$BB echo "MSM Hotplug: $MSM_HOTPLUG@nMSM MPDECISION: $MSM_MPDECISION"
	;;
esac;
