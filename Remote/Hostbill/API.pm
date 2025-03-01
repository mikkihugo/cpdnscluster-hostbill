package Cpanel::NameServer::Remote::Hostbill::API;

use strict;
use warnings;
use Cpanel::HTTP::Client;

sub new {
    my ($class, %args) = @_;
    my $self = {
        api_url  => $args{'api_url'},
        api_id   => $args{'api_id'},
        api_key  => $args{'api_key'},
        dnsapp   => $args{'dnsapp'}
    };
    bless $self, $class;
    return $self;
}

sub get_zones {
    my ($self) = @_;
    my $client = Cpanel::HTTP::Client->new(timeout => 60);
    my $resp = $client->get(
        "$self->{api_url}?call=getDNSZones&api_id=$self->{api_id}&api_key=$self->{api_key}"
    );
    return $resp->{'success'} ? $resp->{'data'} : [];
}

sub add_zone {
    my ($self, $domain, $ns_records) = @_;
    my $client = Cpanel::HTTP::Client->new(timeout => 60);
    my $resp = $client->post(
        "$self->{api_url}",
        {
            call    => 'addDNSZone',
            api_id  => $self->{'api_id'},
            api_key => $self->{'api_key'},
            name    => $domain,
            ns_records => $ns_records
        }
    );
    return $resp->{'success'};
}

1;
