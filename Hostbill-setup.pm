package Cpanel::NameServer::Setup::Remote::Hostbill;

use strict;
use warnings;
use Cpanel::Logger;
use Cpanel::NameServer::Remote::Hostbill::API;

our @ISA = ('Cpanel::NameServer::Setup::Remote');
our $VERSION = '1.0.0';

my $logger = Cpanel::Logger->new();

sub setup {
    my ($self, %opts) = @_;

    if (!exists $opts{'api_id'} || !exists $opts{'api_key'}) {
        return 0, 'API credentials are missing.';
    }

    my $config_file = "/var/cpanel/cluster/root/config/hostbill";
    open(my $fh, '>', $config_file) or return 0, "Failed to open config file: $!";
    print $fh "api_url=$opts{'api_url'}\n";
    print $fh "api_id=$opts{'api_id'}\n";
    print $fh "api_key=$opts{'api_key'}\n";
    print $fh "dnsapp=$opts{'dnsapp'}\n";
    print $fh "ns_config=$opts{'ns_config'}\n";
    print $fh "debug=$opts{'debug'}\n";
    close($fh);

    return 1, 'The configuration has been saved successfully.';
}

sub get_config {
    return {
        'options' => [
            {
                'name'        => 'api_url',
                'type'        => 'text',
                'locale_text' => 'API URL',
                'default'     => 'https://portal.centralcloud.com/admin/api'
            },
            {
                'name'        => 'api_id',
                'type'        => 'text',
                'locale_text' => 'API ID',
                'default'     => '550c53d50958f3a8b421'
            },
            {
                'name'        => 'api_key',
                'type'        => 'text',
                'locale_text' => 'API Key',
                'default'     => 'b93e22bd2eeebab3f198'
            },
            {
                'name'        => 'dnsapp',
                'type'        => 'text',
                'locale_text' => 'DNS App ID',
                'default'     => '1'
            },
            {
                'name'        => 'ns_config',
                'type'        => 'radio',
                'locale_text' => 'NS Config',
                'options'     => [
                    { value => 'force', label => 'Force NS records to Hostbill' },
                    { value => 'ensure', label => 'Ensure Hostbill NS records are included' },
                    { value => 'default', label => 'Do not modify' }
                ],
                'default'     => 'force'
            },
            {
                'name'        => 'debug',
                'type'        => 'binary',
                'locale_text' => 'Debug Mode',
                'default'     => 0
            }
        ],
        'name' => 'Hostbill'
    };
}

1;
