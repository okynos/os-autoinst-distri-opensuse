# SUSE's openQA tests
#
# Copyright 2024 SUSE LLC
# SPDX-License-Identifier: FSFAP

# Summary: Handles GRUB cmd.
# Maintainer: QE YaST and Migration (QE Yam) <qe-yam at suse de>

package Yam::Agama::Pom::GrubCmdPage;
use strict;
use warnings;

use testapi;

sub new {
    my ($class, $args) = @_;
    return bless {
        max_interval => $args->{max_interval},
        key_return => 'ret'
    }, $class;
}

sub type {
    my ($self, $args) = @_;
    type_string_slow("$args ", max_interval => $self->{max_interval});
    wait_still_screen(1);
    save_screenshot();
}

sub enter_key {
    my ($self) = @_;
    send_key($self->{key_return});
}

sub boot {
    my ($self) = @_;
    enter_cmd("boot");
}

1;
