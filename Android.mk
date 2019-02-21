#
# Copyright (C) 2014 The Android-x86 Open Source Project
#
# Licensed under the GNU General Public License Version 2 or later.
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.gnu.org/licenses/gpl.html
#

LOCAL_PATH := $(call my-dir)

ntfs_3g_CFLAGS := -O2 -Wall -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H -DHAVE_LINUX_FS_H

# libfuse-lite
include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(addprefix libfuse-lite/, \
	fuse.c \
	fusermount.c \
	fuse_kern_chan.c \
	fuse_loop.c \
	fuse_lowlevel.c \
	fuse_opt.c \
	fuse_session.c \
	fuse_signals.c \
	helper.c \
	mount.c \
	mount_util.c \
)
LOCAL_CFLAGS := $(ntfs_3g_CFLAGS)
LOCAL_MODULE := libfuse-lite
LOCAL_MODULE_TAGS := optional
LOCAL_C_INCLUDES := $(LOCAL_PATH)/include/fuse-lite
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_C_INCLUDES)
include $(BUILD_SHARED_LIBRARY)

# libntfs-3g
include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(addprefix libntfs-3g/, \
	acls.c \
	attrib.c \
	attrlist.c \
	bitmap.c \
	bootsect.c \
	cache.c \
	collate.c \
	compat.c \
	compress.c \
	debug.c \
	device.c \
	dir.c \
	ea.c \
	efs.c \
	index.c \
	inode.c \
	ioctl.c \
	lcnalloc.c \
	logfile.c \
	logging.c \
	mft.c \
	misc.c \
	mst.c \
	object_id.c \
	realpath.c \
	reparse.c \
	runlist.c \
	security.c \
	unistr.c \
	unix_io.c \
	volume.c \
	xattrs.c \
)
LOCAL_CFLAGS := $(ntfs_3g_CFLAGS) -Wno-address-of-packed-member
LOCAL_MODULE := libntfs-3g
LOCAL_MODULE_TAGS := optional
LOCAL_C_INCLUDES := $(LOCAL_PATH)/include/ntfs-3g
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_C_INCLUDES)
include $(BUILD_SHARED_LIBRARY)

# ntfs-3g
include $(CLEAR_VARS)
LOCAL_SRC_FILES := src/ntfs-3g.c src/ntfs-3g_common.c
LOCAL_CFLAGS := $(ntfs_3g_CFLAGS)
LOCAL_MODULE := ntfs-3g
LOCAL_MODULE_TAGS := optional
LOCAL_SHARED_LIBRARIES := libfuse-lite libntfs-3g
LOCAL_POST_INSTALL_CMD := $(hide) ln -sf $(LOCAL_MODULE) $(TARGET_OUT)/bin/mount.ntfs
include $(BUILD_EXECUTABLE)

# ntfsprogs - ntfsfix
include $(CLEAR_VARS)
LOCAL_SRC_FILES := ntfsprogs/ntfsfix.c ntfsprogs/utils.c
LOCAL_CFLAGS := $(ntfs_3g_CFLAGS)
LOCAL_MODULE := ntfsfix
LOCAL_MODULE_TAGS := optional
LOCAL_SHARED_LIBRARIES := libfuse-lite libntfs-3g
LOCAL_POST_INSTALL_CMD := $(hide) ln -sf $(LOCAL_MODULE) $(TARGET_OUT)/bin/fsck.ntfs
include $(BUILD_EXECUTABLE)

# ntfsprogs - mkntfs
include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(addprefix ntfsprogs/,attrdef.c boot.c mkntfs.c sd.c utils.c)
LOCAL_CFLAGS := $(ntfs_3g_CFLAGS)
LOCAL_MODULE := mkntfs
LOCAL_MODULE_TAGS := optional
LOCAL_SHARED_LIBRARIES := libfuse-lite libntfs-3g
LOCAL_POST_INSTALL_CMD := $(hide) ln -sf $(LOCAL_MODULE) $(TARGET_OUT)/bin/mkfs.ntfs
include $(BUILD_EXECUTABLE)
