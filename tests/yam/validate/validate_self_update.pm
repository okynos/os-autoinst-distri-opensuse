# SUSE's openQA tests
#
# Copyright 2025 SUSE LLC
# SPDX-License-Identifier: FSFAP

# Summary: Validate that the self update is performed by agama via /etc/live-self-update/result
# Maintainer: QE YaST and Migration (QE Yam) <qe-yam at suse de>

use base "consoletest";
use testapi;
use Config::Tiny;
use Test::Assert ':all';
use scheduler 'get_test_suite_data';

sub run {
    select_console 'root-console';

    # We will swap this command to /etc/live-self-update/result file when it comes to the latest build
    my $self_update_output = script_output('journalctl --no-pager -o cat -t live-self-update');

    if ($self_update_output !~ 'Self update successfully finished') {
        die "Error, self update did not ended successfully"
    }
}

1;
