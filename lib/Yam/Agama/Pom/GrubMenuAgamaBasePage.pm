# SUSE's openQA tests
#
# Copyright 2026 SUSE LLC
# SPDX-License-Identifier: FSFAP

# Summary: Handles common grub Agama screen actions.
# Maintainer: QE Installation and Migration (QE Iam) <none@suse.de>

package Yam::Agama::Pom::GrubMenuAgamaBasePage;
use strict;
use warnings;
use testapi;

sub new {
    my ($class, $args) = @_;
    return bless {
        grub_menu_base => $args->{grub_menu_base},
    }, $class;
}

sub edit_current_entry { shift->{grub_menu_base}->boot_from_hd() }
sub select_first_entry { shift->{grub_menu_base}->boot_from_hd() }

sub boot_from_hd {
    send_key_until_needlematch 'inst-bootmenu-boot-harddisk', 'down';
    send_key 'ret';
}

sub select_check_installation_medium_entry {
    my ($self) = @_;
    send_key_until_needlematch('grub-menu-agama-mediacheck-highlighted', 'down');
}

sub select_rescue_system_entry {
    send_key_until_needlematch('grub-menu-agama-rescue-system-highlighted', 'down');
}

1;
