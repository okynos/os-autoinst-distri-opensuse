# Copyright SUSE LLC
# SPDX-License-Identifier: GPL-2.0-or-later

# Summary: Check that deployed resource in the cloud are as expected
# Maintainer: QE-SAP <qe-sap@suse.de>, Michele Pagot <michele.pagot@suse.com>

use strict;
use warnings;
use Mojo::Base 'publiccloud::basetest';
use testapi;
use serial_terminal qw( select_serial_terminal );
use sles4sap::ipaddr2 qw(
  ipaddr2_cluster_sanity
  ipaddr2_deployment_logs
  ipaddr2_destroy
  ipaddr2_os_cloud_init_logs
  ipaddr2_os_sanity
);

sub run {
    my ($self) = @_;

    die('Azure is the only CSP supported for the moment')
      unless check_var('PUBLIC_CLOUD_PROVIDER', 'AZURE');

    select_serial_terminal;
    ipaddr2_os_sanity();
    ipaddr2_cluster_sanity();
}

sub test_flags {
    return {fatal => 1, publiccloud_multi_module => 1};
}

sub post_fail_hook {
    my ($self) = shift;
    ipaddr2_deployment_logs() if check_var('IPADDR2_DIAGNOSTIC', 1);
    ipaddr2_os_cloud_init_logs() unless check_var('IPADDR2_CLOUDINIT', 0);
    ipaddr2_destroy();
    $self->SUPER::post_fail_hook;
}

1;
