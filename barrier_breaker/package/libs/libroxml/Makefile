#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libroxml
PKG_VERSION:=2.3.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://download.libroxml.net/pool/v2.x
PKG_MD5SUM:=a975f91be150f7a19168a45ce15769ca
PKG_MAINTAINER:=Felix Fietkau <nbd@openwrt.org>

PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/libroxml
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=Minimum, easy-to-use, C implementation for xml file parsing
  URL:=http://www.libroxml.net/
endef

CONFIGURE_ARGS += \
	--enable-shared \
	--enable-static \
	--disable-xml-xpath-engine \
	--disable-roxml

define Build/InstallDev
	$(INSTALL_DIR) $(1)
	$(CP) $(PKG_INSTALL_DIR)/* $(1)/
endef

define Package/libroxml/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libroxml.so.* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libroxml))
