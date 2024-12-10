## Copyright 2024 SUSE LLC
# SPDX-License-Identifier: GPL-2.0-or-later

# Summary: Boot to agama adding bootloader kernel parameters and expecting web ui up and running.
# At the moment redirecting to legacy handling for s390x booting.
# Maintainer: QE YaST and Migration (QE Yam) <qe-yam at suse de>

use base "installbasetest";
use strict;
use warnings;

use testapi;
use Utils::Architectures;
use Utils::Backends;

use Mojo::Util 'trim';
use File::Basename;

BEGIN {
    unshift @INC, dirname(__FILE__) . '/../../installation';
}
use bootloader_s390;
use bootloader_zkvm;
use bootloader_pvm;

sub run {
    my $self = shift;

    # prepare kernel parameters
    if (my $agama_auto = get_var('AGAMA_AUTO')) {
        my $path = data_url($agama_auto);
        set_var('EXTRABOOTPARAMS', get_var('EXTRABOOTPARAMS', '') . " agama.auto=\"$path\"");
    }
    my @params = split ' ', trim(get_var('EXTRABOOTPARAMS', ''));

    # for now using legacy code to handle s390x
    if (is_s390x()) {
        if (is_backend_s390x()) {
            record_info('bootloader_s390x');
            $self->bootloader_s390::run();
        } elsif (is_svirt) {
            record_info('bootloader_zkvm');
            $self->bootloader_zkvm::run();
        }
        return;
    }

    my $grub_menu = $testapi::distri->get_grub_menu_agama();
    my $grub_edition = $testapi::distri->get_grub_edition();

    if (is_pvm_hmc()) {
        my $iso = get_required_var('ISO');
        my $repo = get_required_var('REPO_0');
        my $mntpoint = "mnt/openqa/repo/$repo/boot/ppc64le";

        if (my $ppc64le_grub_http = get_var('PPC64LE_GRUB_HTTP')) {
            # Enable grub http protocol to load file from OSD: (http,10.145.10.207)/assets/repo/$repo/boot/ppc64le
            $mntpoint = "$ppc64le_grub_http/assets/repo/$repo/boot/ppc64le";
            record_info("Updated boot path for PPC64LE_GRUB_HTTP defined", $mntpoint);
        }

        $self->bootloader_pvm::boot_pvm();
        $grub_menu->expect_is_shown();
        $grub_menu->cmd();

        $grub_edition->type("linux $mntpoint/linux");
        $grub_edition->type("vga=normal");
        #$grub_edition->type("install=$mirror");
        $grub_edition->type("console=hvc0");
        $grub_edition->type("kernel.softlockup_panic=1");
        $grub_edition->type("Y2DEBUG=1");
        if(my $extrabootparams = get_var('EXTRABOOTPARAMS')){
            $grub_edition->type($extrabootparams);
        }
        else{
            $grub_edition->type("live.password=$testapi::password");
        }
        my $host = get_var('OPENQA_HOSTNAME', 'openqa.opensuse.org');
        $grub_edition->type("root=live:http://$host/assets/repo/$iso");
        $grub_edition->key_return();

        $grub_edition->type("initrd $mntpoint/initrd");
        $grub_edition->key_return();
    }else{
        $grub_menu->expect_is_shown();
        $grub_menu->edit_current_entry();
        $grub_edition->move_cursor_to_end_of_kernel_line();
        $grub_edition->type(\@params);
    }

    $grub_edition->boot();
    if (!get_var('KEEP_DISKS')){
        prepare_disks;
    }
    my $agama_up_an_running = $testapi::distri->get_agama_up_an_running();
    $agama_up_an_running->expect_is_shown();
}

1;
