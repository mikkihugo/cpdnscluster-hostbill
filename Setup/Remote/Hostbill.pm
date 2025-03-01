package Cpanel::NameServer::Remote::Hostbill;

use strict;
use warnings;
use Cpanel::Logger;
use Cpanel::NameServer::Remote::Hostbill::DNSSync;

our @ISA = ('Cpanel::NameServer::Remote');
our $VERSION = '1.0.0';

my $logger = Cpanel::Logger->new();

# Constructor: reads configuration from the per-user config file and instantiates DNSSync
sub new {
    my ($class, %args) = @_;
    my $self = {
        debug           => $args{'debug'} // 0,
        api_url         => $args{'api_url'},
        api_id          => $args{'api_id'},
        api_key         => $args{'api_key'},
        dnsapp          => $args{'dnsapp'},
        exclude_local   => $args{'exclude_local'} // 1,
        excluded_domains => $args{'excluded_domains'} // '',
    };
    bless $self, $class;
    $self->{dnssync} = Cpanel::NameServer::Remote::Hostbill::DNSSync->new(%$self);
    return $self;
}

# Delegate required methods to DNSSync
sub getips      { return shift->{dnssync}->getips(@_); }
sub addzoneconf { return shift->{dnssync}->addzoneconf(@_); }
sub getzone     { return shift->{dnssync}->getzone(@_); }
sub getzonelist { return shift->{dnssync}->getzonelist(@_); }
sub getzones    { return shift->{dnssync}->getzones(@_); }
sub quickzoneadd{ return shift->{dnssync}->quickzoneadd(@_); }
sub removezone  { return shift->{dnssync}->removezone(@_); }
sub removezones { return shift->{dnssync}->removezones(@_); }
sub savezone    { return shift->{dnssync}->savezone(@_); }
sub synczones   { return shift->{dnssync}->synczones(@_); }
sub zoneexists  { return shift->{dnssync}->zoneexists(@_); }
sub getpath     { return shift->{dnssync}->getpath(@_); }

sub version { return $VERSION; }

sub _debug {
    my ($self, $msg) = @_;
    if ($self->{debug}) {
        $logger->info("[Hostbill Plugin] $msg");
    }
}

1;
