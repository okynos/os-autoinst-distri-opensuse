## Copyright 2025 SUSE LLC
# SPDX-License-Identifier: GPL-2.0-or-later

# Summary: Include defined parameters to Zypper configuration in Agama live ISO
# Maintainer: QE YaST and Migration (QE Yam) <qe-yam at suse de>

use strict;
use warnings;
use testapi
use scheduler 'get_test_suite_data';

sub run {
    my $test_data = get_test_suite_data();

    select_console 'root-console';

    foreach my $param (@{$test_data->{zypper_parameters}}) {
        script_run("echo $param > /etc/zypp/zypp.conf");
    }
    assert_script_run("zypper refresh", timeout => 60);
}

1;
