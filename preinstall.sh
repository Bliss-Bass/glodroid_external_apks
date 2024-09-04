#!/system/bin/sh

first_run=$(getprop persist.glodroid.first_run)

ARCH=$(getprop ro.bionic.arch)
APK_PATH=/vendor/etc/preinstall

install_apk() {
   echo Installing $1
   [[ -f "$APK_PATH/$1_$ARCH" ]] && pm install -g "$APK_PATH/$1_$ARCH" && return
   [[ -f "$APK_PATH/$1_all" ]] && pm install -g "$APK_PATH/$1_all" && return
}

set_custom_package_perms()
{
	# Set up custom package permissions

	current_user="0"

	# KioskLauncher
	exists_kiosk=$(pm list packages org.blissos.kiosklauncher | grep -c org.blissos.kiosklauncher)
	if [ $exists_kiosk -eq 1 ]; then
		pm set-home-activity "org.blissos.kiosklauncher/.ui.MainActivity"
		am start -a android.intent.action.MAIN -c android.intent.category.HOME
	fi

	# MultiClientIME
	exists_mcime=$(pm list packages com.example.android.multiclientinputmethod | grep -c com.example.android.multiclientinputmethod)
	if [ $exists_mcime -eq 1 ]; then
		# Enable desktop mode on external display (required for MultiDisplay Input)
		settings put global force_desktop_mode_on_external_displays "$FORCE_DESKTOP_ON_EXTERNAL"
	fi

	# ZQYMultiClientIME
	exists_zqymcime=$(pm list packages com.zqy.multidisplayinput | grep -c com.zqy.multidisplayinput)
	if [ $exists_zqymcime -eq 1 ]; then
		# Enable desktop mode on external display (required for MultiDisplay Input)
		settings put global force_desktop_mode_on_external_displays "$FORCE_DESKTOP_ON_EXTERNAL"
	fi

	# GBoard 
	exists_gboard=$(pm list packages com.google.android.inputmethod.latin | grep -c com.google.android.inputmethod.latin)
	if [ $exists_gboard -eq 1 ]; then
		if [ ! -f /data/misc/gboard/default ]; then
			# set default input method
			ime enable com.google.android.inputmethod.latin/com.android.inputmethod.latin.LatinIME
			ime set com.google.android.inputmethod.latin/com.android.inputmethod.latin.LatinIME
			# Set config marker
			mkdir -p /data/misc/gboard
			touch /data/misc/gboard/default
			chown 1000.1000 /data/misc/gboard /data/misc/gboard/*
			chmod 775 /data/misc/gboard
			chmod 664 /data/misc/gboard/default
		fi
	fi

	# BlissRestrictedLauncher
	exists_restlauncher=$(pm list packages com.bliss.restrictedlauncher | grep -c com.bliss.restrictedlauncher)
	if [ $exists_restlauncher -eq 1 ]; then
		if [ ! -f /data/misc/rlconfig/admin ]; then
			# set device admin
			dpm set-device-owner com.bliss.restrictedlauncher/.DeviceAdmin
			mkdir -p /data/misc/rlconfig
			touch /data/misc/rlconfig/admin
			chown 1000.1000 /data/misc/rlconfig /data/misc/rlconfig/*
			chmod 775 /data/misc/rlconfig
			chmod 664 /data/misc/rlconfig/admin
		fi
		# set overlays enabled
		settings put secure secure_overlay_settings 1

		# allow displaying over other apps if in Go mode
		settings put system alert_window_bypass_low_ram 1

		pm grant com.bliss.restrictedlauncher android.permission.SYSTEM_ALERT_WINDOW
		pm set-home-activity "com.bliss.restrictedlauncher/.activities.LauncherActivity"
		am start -a android.intent.action.MAIN -c android.intent.category.HOME

		if [ -f /data/data/com.bliss.restrictedlauncher/files/whitelist.lst ]; then
			if [ ! -f /data/misc/rlpconfig/whitelist ]; then
				echo -e "\ncom.android.printservice.recommendation" >> /data/data/com.bliss.restrictedlauncher/files/whitelist.lst
				echo -e "com.android.printspooler" >> /data/data/com.bliss.restrictedlauncher/files/whitelist.lst
				echo -e "com.android.systemui" >> /data/data/com.bliss.restrictedlauncher/files/whitelist.lst
				echo -e "com.android.packageinstaller" >> /data/data/com.bliss.restrictedlauncher/files/whitelist.lst				
				mkdir -p /data/misc/rlconfig
				touch /data/misc/rlconfig/whitelist
				chown 1000.1000 /data/misc/rlconfig /data/misc/rlconfig/*
				chmod 775 /data/misc/rlconfig
				chmod 664 /data/misc/rlconfig/whitelist
			fi
		fi
	fi

	# BlissRestrictedLauncherPro
	exists_restlauncherpro=$(pm list packages com.bliss.restrictedlauncher.pro | grep -c com.bliss.restrictedlauncher.pro)
	if [ $exists_restlauncherpro -eq 1 ]; then
		if [ ! -f /data/misc/rlpconfig/admin ]; then
			# set device admin
			dpm set-device-owner com.bliss.restrictedlauncher.pro/com.bliss.restrictedlauncher.DeviceAdmin
			mkdir -p /data/misc/rlconfig
			touch /data/misc/rlconfig/admin
			chown 1000.1000 /data/misc/rlconfig /data/misc/rlconfig/*
			chmod 775 /data/misc/rlconfig
			chmod 664 /data/misc/rlconfig/admin
		fi
		# set overlays enabled
		settings put secure secure_overlay_settings 1

		# allow displaying over other apps if in Go mode
		settings put system alert_window_bypass_low_ram 1
				
		pm grant com.bliss.restrictedlauncher.pro android.permission.SYSTEM_ALERT_WINDOW
		pm set-home-activity "com.bliss.restrictedlauncher.pro/com.bliss.restrictedlauncher.activities.LauncherActivity"
		am start -a android.intent.action.MAIN -c android.intent.category.HOME

		if [ -f /data/data/com.bliss.restrictedlauncher.pro/files/whitelist.lst ]; then
			if [ ! -f /data/misc/rlpconfig/whitelist ]; then
				echo -e "\ncom.android.printservice.recommendation" >> /data/data/com.bliss.restrictedlauncher.pro/files/whitelist.lst
				echo -e "com.android.printspooler" >> /data/data/com.bliss.restrictedlauncher.pro/files/whitelist.lst
				echo -e "com.android.systemui" >> /data/data/com.bliss.restrictedlauncher.pro/files/whitelist.lst
				echo -e "com.android.packageinstaller" >> /data/data/com.bliss.restrictedlauncher.pro/files/whitelist.lst				
				mkdir -p /data/misc/rlconfig
				touch /data/misc/rlconfig/whitelist
				chown 1000.1000 /data/misc/rlconfig /data/misc/rlconfig/*
				chmod 775 /data/misc/rlconfig
				chmod 664 /data/misc/rlconfig/whitelist
			fi
		fi
	fi

	# Molla Launcher
	exists_molla=$(pm list packages com.sinu.molla | grep -c com.sinu.molla)
	if [ $exists_molla -eq 1 ]; then
		pm set-home-activity "com.sinu.molla/.MainActivity"
		am start -a android.intent.action.MAIN -c android.intent.category.HOME
	fi

	# CrossLauncher
	exists_cross=$(pm list packages id.psw.vshlauncher | grep -c id.psw.vshlauncher)
	if [ $exists_cross -eq 1 ]; then
		pm set-home-activity "id.psw.vshlauncher/.activities.Xmb"
		am start -a android.intent.action.MAIN -c android.intent.category.HOME
	fi

	# TV-Mode Launcher
	exists_tvl=$(pm list packages nl.ndat.tvlauncher | grep -c nl.ndat.tvlauncher)
	if [ $exists_tvl -eq 1 ]; then
		pm set-home-activity "nl.ndat.tvlauncher/.MainActivity"
		am start -a android.intent.action.MAIN -c android.intent.category.HOME
	fi

	# Titanius Launcher
	exists_titanius=$(pm list packages app.titanius.launcher | grep -c app.titanius.launcher)
	if [ $exists_titanius -eq 1 ]; then
		pm set-home-activity "app.titanius.launcher/.MainActivity"
		am start -a android.intent.action.MAIN -c android.intent.category.HOME
	fi

	# Garlic-Launcher
	exists_garliclauncher=$(pm list packages com.sagiadinos.garlic.launcher | grep -c com.sagiadinos.garlic.launcher)
	if [ $exists_garliclauncher -eq 1 ]; then
		if [ ! -f /data/misc/glauncherconfig/admin ]; then
			# set device admin
			dpm set-device-owner com.sagiadinos.garlic.launcher/.receiver.AdminReceiver
			mkdir -p /data/misc/glauncherconfig
			touch /data/misc/glauncherconfig/admin
			chown 1000.1000 /data/misc/glauncherconfig /data/misc/glauncherconfig/*
			chmod 775 /data/misc/glauncherconfig
			chmod 664 /data/misc/glauncherconfig/admin
		fi
		pm set-home-activity "com.sagiadinos.garlic.launcher/.MainActivity"
		am start -a android.intent.action.MAIN -c android.intent.category.HOME
	fi
		
	# SmartDock
	exists_smartdock=$(pm list packages cu.axel.smartdock | grep -c cu.axel.smartdock)
	if [ $exists_smartdock -eq 1 ]; then
		pm grant cu.axel.smartdock android.permission.SYSTEM_ALERT_WINDOW
		pm grant cu.axel.smartdock android.permission.GET_TASKS
		pm grant cu.axel.smartdock android.permission.REORDER_TASKS
		pm grant cu.axel.smartdock android.permission.REMOVE_TASKS
		pm grant cu.axel.smartdock android.permission.ACCESS_WIFI_STATE
		pm grant cu.axel.smartdock android.permission.CHANGE_WIFI_STATE
		pm grant cu.axel.smartdock android.permission.ACCESS_NETWORK_STATE
		pm grant cu.axel.smartdock android.permission.ACCESS_COARSE_LOCATION
		pm grant cu.axel.smartdock android.permission.ACCESS_FINE_LOCATION
		pm grant cu.axel.smartdock android.permission.READ_EXTERNAL_STORAGE
		pm grant cu.axel.smartdock android.permission.MANAGE_USERS
		pm grant cu.axel.smartdock android.permission.BLUETOOTH_ADMIN
		pm grant cu.axel.smartdock android.permission.BLUETOOTH_CONNECT
		pm grant cu.axel.smartdock android.permission.BLUETOOTH
		pm grant cu.axel.smartdock android.permission.REQUEST_DELETE_PACKAGES
		pm grant cu.axel.smartdock android.permission.ACCESS_SUPERUSER
		pm grant cu.axel.smartdock android.permission.PACKAGE_USAGE_STATS
		pm grant cu.axel.smartdock android.permission.QUERY_ALL_PACKAGES
		pm grant cu.axel.smartdock android.permission.WRITE_SECURE_SETTINGS
		pm grant --user $current_user cu.axel.smartdock android.permission.WRITE_SECURE_SETTINGS
		appops set cu.axel.smartdock WRITE_SECURE_SETTINGS allow
		pm grant cu.axel.smartdock android.permission.WRITE_SETTINGS
		pm grant --user $current_user cu.axel.smartdock android.permission.WRITE_SETTINGS
		appops set cu.axel.smartdock WRITE_SETTINGS allow
		pm grant cu.axel.smartdock android.permission.BIND_ACCESSIBILITY_SERVICE
		pm grant --user $current_user cu.axel.smartdock android.permission.BIND_ACCESSIBILITY_SERVICE
		appops set cu.axel.smartdock BIND_ACCESSIBILITY_SERVICE allow
		pm grant cu.axel.smartdock android.permission.BIND_NOTIFICATION_LISTENER_SERVICE
		pm grant --user $current_user cu.axel.smartdock android.permission.BIND_NOTIFICATION_LISTENER_SERVICE
		appops set cu.axel.smartdock BIND_NOTIFICATION_LISTENER_SERVICE allow
		pm grant cu.axel.smartdock android.permission.BIND_DEVICE_ADMIN
		pm grant --user $current_user cu.axel.smartdock android.permission.BIND_DEVICE_ADMIN
		appops set cu.axel.smartdock BIND_DEVICE_ADMIN allow
		pm grant cu.axel.smartdock android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
		pm grant --user $current_user cu.axel.smartdock android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS

		# set overlays enabled
		settings put secure secure_overlay_settings 1

		# allow displaying over other apps if in Go mode
		settings put system alert_window_bypass_low_ram 1

		if [ ! -f /data/misc/sdconfig/accessibility ] && ! pm list packages | grep -q "com.blissos.setupwizard"; then
			# set accessibility services
			eas=$(settings get secure enabled_accessibility_services)
			if [ -n "$eas" ]; then
				settings put secure enabled_accessibility_services $eas:cu.axel.smartdock/cu.axel.smartdock.services.DockService
			else
				settings put secure enabled_accessibility_services cu.axel.smartdock/cu.axel.smartdock.services.DockService
			fi
			mkdir -p /data/misc/sdconfig
			touch /data/misc/sdconfig/accessibility
			chown 1000.1000 /data/misc/sdconfig /data/misc/sdconfig/*
			chmod 775 /data/misc/sdconfig
			chmod 664 /data/misc/sdconfig/accessibility
		fi
		if [ ! -f /data/misc/sdconfig/notification ]; then
			# set notification listeners
			enl=$(settings get secure enabled_notification_listeners)
			if [ -n "$enl" ]; then
				settings put secure enabled_notification_listeners $enl:cu.axel.smartdock/cu.axel.smartdock.services.NotificationService
				
			else
				settings put secure enabled_notification_listeners cu.axel.smartdock/cu.axel.smartdock.services.NotificationService
			fi
			mkdir -p /data/misc/sdconfig
			touch /data/misc/sdconfig/notification
			chown 1000.1000 /data/misc/sdconfig /data/misc/sdconfig/*
			chmod 775 /data/misc/sdconfig
			chmod 664 /data/misc/sdconfig/notification
		fi
		if [ ! -f /data/misc/sdconfig/admin ]; then
			# set device admin
			dpm set-active-admin --user current cu.axel.smartdock/android.app.admin.DeviceAdminReceiver
			mkdir -p /data/misc/sdconfig
			touch /data/misc/sdconfig/admin
			chown 1000.1000 /data/misc/sdconfig /data/misc/sdconfig/*
			chmod 775 /data/misc/sdconfig
			chmod 664 /data/misc/sdconfig/admin
		fi

		if [ $(settings get global development_settings_enabled) == 0 ]; then
			settings put global development_settings_enabled 1
		fi

		# set launcher
		SET_SMARTDOCK_DEFAULT=$(getprop persist.glodroid.set_smartdock_default)
		[ -n "$SET_SMARTDOCK_DEFAULT" ] && pm set-home-activity "cu.axel.smartdock/.activities.LauncherActivity" || pm set-home-activity "com.android.launcher3/.LauncherProvider"
	
	fi

	# com.farmerbb.taskbar
	exists_taskbar=$(pm list packages com.farmerbb.taskbar | grep -c com.farmerbb.taskbar)
	if [ $exists_taskbar -eq 1 ]; then
		pm grant com.farmerbb.taskbar android.permission.PACKAGE_USAGE_STATS
		pm grant --user $current_user com.farmerbb.taskbar android.permission.WRITE_SECURE_SETTINGS
		appops set com.farmerbb.taskbar BIND_DEVICE_ADMIN allow
		pm grant com.farmerbb.taskbar android.permission.GET_TASKS
		pm grant com.farmerbb.taskbar android.permission.BIND_CONTROLS
		pm grant com.farmerbb.taskbar android.permission.BIND_INPUT_METHOD
		pm grant com.farmerbb.taskbar android.permission.BIND_QUICK_SETTINGS_TILE
		pm grant com.farmerbb.taskbar android.permission.REBOOT
		pm grant --user $current_user com.farmerbb.taskbar android.permission.BIND_ACCESSIBILITY_SERVICE
		appops set com.farmerbb.taskbar BIND_ACCESSIBILITY_SERVICE allow
		pm grant --user $current_user com.farmerbb.taskbar android.permission.MANAGE_OVERLAY_PERMISSION
		appops set com.farmerbb.taskbar MANAGE_OVERLAY_PERMISSION allow
		pm grant com.farmerbb.taskbar android.permission.SYSTEM_ALERT_WINDOW
		pm grant com.farmerbb.taskbar android.permission.USE_FULL_SCREEN_INTENT

		# set overlays enabled
		settings put secure secure_overlay_settings 1
	fi

	# MicroG: com.google.android.gms
	is_microg=$(dumpsys package com.google.android.gms | grep -m 1 -c org.microg.gms)
	if [ $is_microg -eq 1 ]; then
		exists_gms=$(pm list packages com.google.android.gms | grep -c com.google.android.gms)
		if [ $exists_gms -eq 1 ]; then
			pm grant com.google.android.gms android.permission.ACCESS_FINE_LOCATION
			pm grant com.google.android.gms android.permission.READ_EXTERNAL_STORAGE
			pm grant com.google.android.gms android.permission.ACCESS_BACKGROUND_LOCATION
			pm grant com.google.android.gms android.permission.ACCESS_COARSE_UPDATES
			pm grant --user $current_user com.google.android.gms android.permission.FAKE_PACKAGE_SIGNATURE
			appops set com.google.android.gms android.permission.FAKE_PACKAGE_SIGNATURE
			pm grant --user $current_user com.google.android.gms android.permission.MICROG_SPOOF_SIGNATURE
			appops set com.google.android.gms android.permission.MICROG_SPOOF_SIGNATURE
			pm grant --user $current_user com.google.android.gms android.permission.WRITE_SECURE_SETTINGS
			appops set com.google.android.gms android.permission.WRITE_SECURE_SETTINGS
			pm grant com.google.android.gms android.permission.SYSTEM_ALERT_WINDOW
			pm grant --user $current_user com.google.android.gms android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
			appops set com.google.android.gms android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
		fi
		exists_vending=$(pm list packages com.google.android.vending | grep -c com.google.android.vending)
		if [ $exists_vending -eq 1 ]; then
			pm grant --user $current_user com.google.android.vending android.permission.FAKE_PACKAGE_SIGNATURE
			appops set com.google.android.vending android.permission.FAKE_PACKAGE_SIGNATURE
		fi
	fi

	# Ax86 StartMenu
	exists_ax86startmenu=$(pm list packages com.ax86.startmenu | grep -c com.ax86.startmenu)
	if [ $exists_ax86startmenu -eq 1 ]; then
		# 3GB size in kB : https://source.android.com/devices/tech/perf/low-ram
		SIZE_3GB=3145728

		mem_size=`cat /proc/meminfo | grep MemTotal | tr -s ' ' | cut -d ' ' -f 2`

		if [ "$mem_size" -ge "$SIZE_3GB" ]; then
			set_property ro.sf.blurs_are_expensive 1
			set_property ro.surface_flinger.supports_background_blur 1
			wm disable-blur 0
		fi
	fi

}

POST_INST=/data/vendor/post_inst_complete
USER_APPS=/system/etc/user_app/*
BUILD_DATETIME=$(getprop ro.build.date.utc)
POST_INST_NUM=$(cat $POST_INST)

if [ ! "$BUILD_DATETIME" == "$POST_INST_NUM" ]; then
	# GD apps
	install_apk fenix.apk
	install_apk fdroid.apk
	# Bliss apps
	install_apk kernelsu.apk
	install_apk smartdock.apk
	install_apk termux.apk
	install_apk xtmapper.apk
	install_apk setorientation.apk
	# Bliss user_apps
	for apk in $USER_APPS
	do		
		pm install $apk
	done
	rm "$POST_INST"
	touch "$POST_INST"
	echo $BUILD_DATETIME > "$POST_INST"
fi

set_custom_package_perms

