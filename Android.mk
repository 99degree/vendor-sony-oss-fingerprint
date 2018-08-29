ifneq ($(TARGET_DEVICE_NO_FPC), true)
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := android.hardware.biometrics.fingerprint@2.1-service.sony
LOCAL_INIT_RC := android.hardware.biometrics.fingerprint@2.1-service.sony.rc
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_SRC_FILES := \
    BiometricsFingerprint.cpp \
    service.cpp \
    QSEEComFunc.c \
    common.c

ifeq ($(filter-out kitakami,$(SOMC_PLATFORM)),)
LOCAL_SRC_FILES += fpc_imp_kitakami.c
LOCAL_CFLAGS += -DFPC_DB_PER_GID
endif

ifeq ($(filter-out loire,$(SOMC_PLATFORM)),)
LOCAL_SRC_FILES += fpc_imp_loire_tone.c
endif

ifeq ($(filter-out tone,$(SOMC_PLATFORM)),)
LOCAL_SRC_FILES += fpc_imp_loire_tone.c
LOCAL_CFLAGS += -DUSE_FPC_TONE
endif

ifeq ($(filter-out yoshino,$(SOMC_PLATFORM)),)
LOCAL_SRC_FILES += fpc_imp_yoshino_nile.c
endif

ifeq ($(filter-out nile,$(SOMC_PLATFORM)),)
LOCAL_SRC_FILES += fpc_imp_yoshino_nile.c
LOCAL_CFLAGS += -DUSE_FPC_NILE
endif

LOCAL_SHARED_LIBRARIES := \
    libcutils \
    liblog \
    libhidlbase \
    libhidltransport \
    libhardware \
    libutils \
    libdl \
    android.hardware.biometrics.fingerprint@2.1

LOCAL_CONLYFLAGS := -std=c99

SYSFS_PREFIX := "/sys/devices/soc/fpc1145_device"
ifeq ($(SOMC_KERNEL_VERSION),3.10)
SYSFS_PREFIX := "/sys/devices/soc.0/fpc1145_device"
endif
ifeq ($(SOMC_KERNEL_VERSION),4.9)
SYSFS_PREFIX := "/sys/devices/platform/soc/fpc1145_device"
endif

ifeq ($(TARGET_COMPILE_WITH_MSM_KERNEL),true)
LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
endif

LOCAL_CFLAGS += \
    -DSYSFS_PREFIX=\"$(SYSFS_PREFIX)\" \
    -DPLATFORM_SDK_VERSION=$(PLATFORM_SDK_VERSION) \
    -Wno-missing-field-initializers \
    -Wno-unused-variable \
    -Wno-error=extern-c-compat \
    -Wno-sign-compare

include $(BUILD_EXECUTABLE)
endif
