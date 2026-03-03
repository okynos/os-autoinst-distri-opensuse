# SUSE's openQA tests
#
# Copyright 2024 SUSE LLC
# SPDX-License-Identifier: FSFAP

# Summary: Handles GRUB screen.
# Maintainer: QE Installation and Migration (QE Iam) <none@suse.de>

package Yam::Agama::Pom::GrubMenuAgamaPage;
use strict;
use warnings;
use testapi;

sub new {
    my ($class, $args) = @_;
    return bless {
        grub_menu_base => $args->{grub_menu_base},
        tag_first_entry_highlighted => 'grub-menu-install-highlighted',
    }, $class;
}

sub select_install_product { }
sub boot_from_hd { shift->{grub_menu_base}->boot_from_hd() }
sub select_check_installation_medium_entry { shift->{grub_menu_base}->select_check_installation_medium_entry() }
sub edit_current_entry { shift->{grub_menu_base}->edit_current_entry() }
sub select_first_entry { shift->{grub_menu_base}->select_first_entry() }
sub select_rescue_system_entry { shift->{grub_menu_base}->select_rescue_system_entry() }

sub expect_is_shown {
    my ($self) = @_;
    assert_screen($self->{tag_first_entry_highlighted}, 60);
}

1;
