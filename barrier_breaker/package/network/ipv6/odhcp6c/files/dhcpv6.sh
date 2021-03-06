#!/bin/sh

. /lib/functions.sh
. ../netifd-proto.sh
init_proto "$@"

proto_dhcpv6_init_config() {
	proto_config_add_string 'reqaddress:or("try","force","none")'
	proto_config_add_string 'reqprefix:or("auto","no",range(0, 64))'
	proto_config_add_string clientid
	proto_config_add_string 'reqopts:list(uinteger)'
	proto_config_add_string 'noslaaconly:bool'
	proto_config_add_string 'forceprefix:bool'
	proto_config_add_string 'norelease:bool'
	proto_config_add_string 'ip6prefix:ip6addr'
	proto_config_add_string iface_dslite
	proto_config_add_string 'ifaceid:ip6addr'
	proto_config_add_string 'sourcerouting:bool'
	proto_config_add_string "userclass"
	proto_config_add_string "vendorclass"
	proto_config_add_boolean delegate
}

proto_dhcpv6_setup() {
	local config="$1"
	local iface="$2"

	local reqaddress reqprefix clientid reqopts noslaaconly forceprefix norelease ip6prefix iface_dslite ifaceid sourcerouting userclass vendorclass delegate
	json_get_vars reqaddress reqprefix clientid reqopts noslaaconly forceprefix norelease ip6prefix iface_dslite ifaceid sourcerouting userclass vendorclass delegate


	# Configure
	local opts=""
	[ -n "$reqaddress" ] && append opts "-N$reqaddress"

	[ -z "$reqprefix" -o "$reqprefix" = "auto" ] && reqprefix=0
	[ "$reqprefix" != "no" ] && append opts "-P$reqprefix"

	[ -n "$clientid" ] && append opts "-c$clientid"

	[ "$noslaaconly" = "1" ] && append opts "-S"

	[ "$forceprefix" = "1" ] && append opts "-F"

	[ "$norelease" = "1" ] && append opts "-k"

	[ -n "$ifaceid" ] && append opts "-i$ifaceid"

	[ -n "$vendorclass" ] && append opts "-V$vendorclass"

	[ -n "$userclass" ] && append opts "-u$userclass"

	for opt in $reqopts; do
		append opts "-r$opt"
	done

	[ -n "$ip6prefix" ] && proto_export "USERPREFIX=$ip6prefix"
	[ -n "$iface_dslite" ] && proto_export "IFACE_DSLITE=$iface_dslite"
	[ "$sourcerouting" != "0" ] && proto_export "SOURCE_ROUTING=1"
	[ "$delegate" = "0" ] && proto_export "IFACE_DSLITE_DELEGATE=0"

	proto_export "INTERFACE=$config"
	proto_run_command "$config" odhcp6c \
		-s /lib/netifd/dhcpv6.script \
		$opts $iface
}

proto_dhcpv6_teardown() {
	local interface="$1"
	proto_kill_command "$interface"
}

add_protocol dhcpv6

