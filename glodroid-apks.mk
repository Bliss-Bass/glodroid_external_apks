PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/preinstall.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/preinstall.rc                       \
    $(LOCAL_PATH)/preinstall.sh:$(TARGET_COPY_OUT_VENDOR)/etc/preinstall/preinstall.sh                 \
    $(LOCAL_PATH)/fenix-arm.apk:$(TARGET_COPY_OUT_VENDOR)/etc/preinstall/fenix.apk_arm                 \
    $(LOCAL_PATH)/fenix-arm64.apk:$(TARGET_COPY_OUT_VENDOR)/etc/preinstall/fenix.apk_arm64             \
    $(LOCAL_PATH)/termux.apk:$(TARGET_COPY_OUT_VENDOR)/etc/preinstall/termux.apk_all                   \
    $(LOCAL_PATH)/setorientation.apk:$(TARGET_COPY_OUT_VENDOR)/etc/preinstall/setorientation.apk_all   \

ifeq ($(USE_SMARTDOCK),true)
    PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/smartdock.apk:$(TARGET_COPY_OUT_VENDOR)/etc/preinstall/smartdock.apk_all

endif

ifneq ($(BLISS_REMOVE_KSU),true)
    PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/xtmapper.apk:$(TARGET_COPY_OUT_VENDOR)/etc/preinstall/xtmapper.apk_all \
        $(LOCAL_PATH)/kernelsu.apk:$(TARGET_COPY_OUT_VENDOR)/etc/preinstall/kernelsu.apk_all

endif
