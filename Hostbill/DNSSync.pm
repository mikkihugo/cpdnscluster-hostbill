package Cpanel::NameServer::Remote::Hostbill::DNSSync;

use strict;
use warnings;
use Cpanel::Logger;
use Cpanel::HTTP::Client;
use JSON;

our $VERSION = '1.0.0';
my $logger = Cpanel::Logger->new();

sub new {
    my ($class, %args) = @_;
    my $self = {
        api_url  => $args{'api_url'},
        api_id   => $args{'api_id'},
        api_key  => $args{'api_key'},
        dnsapp   => $args{'dnsapp'},
        debug    => $args{'debug'} // 0
    };
    bless $self, $class;
    return $self;
}

sub getips {
    my ($self) = @_;
    $logger->info("Fetching nameserver IPs from Hostbill API") if $self->{debug};

    my $client = Cpanel::HTTP::Client->new(timeout => 60);
    my $resp = $client->get(
        "$self->{api_url}?call=getNameserverIPs&api_id=$self->{api_id}&api_key=$self->{api_key}&dnsapp=$self->{dnsapp}"
    );

    if ($resp->{'success'}) {
        return $resp->{'data'};
    } else {
        $logger->error("Failed to fetch nameserver IPs: " . ($resp->{'error'} // 'Unknown error'));
        return [];
    }
}

sub getzonelist {
    my ($self) = @_;
    $logger->info("Fetching zone list from Hostbill API") if $self->{debug};

    my $client = Cpanel::HTTP::Client->new(timeout => 60);
    my $resp = $client->get(
        "$self->{api_url}?call=getDNSZones&api_id=$self->{api_id}&api_key=$self->{api_key}&dnsapp=$self->{dnsapp}"
    );

    if ($resp->{'success'}) {
        return $resp->{'data'};
    } else {
        $logger->error("Failed to fetch zone list: " . ($resp->{'error'} // 'Unknown error'));
        return [];
    }
}

sub getzone {
    my ($self, $domain) = @_;
    $logger->info("Fetching zone details for $domain") if $self->{debug};

    my $client = Cpanel::HTTP::Client->new(timeout => 60);
    my $resp = $client->get(
        "$self->{api_url}?call=getDNSZoneDetails&api_id=$self->{api_id}&api_key=$self->{api_key}&dnsapp=$self->{dnsapp}&domain=$domain"
    );

    if ($resp->{'success'}) {
        return $resp->{'data'};
    } else {
        $logger->error("Failed to fetch zone details for $domain: " . ($resp->{'error'} // 'Unknown error'));
        return {};
    }
}

sub addzoneconf {
    my ($self, $domain, $ns_records) = @_;
    $logger->info("Adding zone $domain to Hostbill API") if $self->{debug};

    my $client = Cpanel::HTTP::Client->new(timeout => 60);
    my $resp = $client->post(
        "$self->{api_url}",
        {
            call    => 'addDNSZone',
            api_id  => $self->{api_id'},
            api_key => $self->{api_key'},
            dnsapp  => $self->{dnsapp},
            name    => $domain,
            ns_records => $ns_records
        }
    );

    return $resp->{'success'};
}

sub removezone {
    my ($self, $domain) = @_;
    $logger->info("Removing zone $domain from Hostbill API") if $self->{debug};

    my $client = Cpanel::HTTP::Client->new(timeout => 60);
    my $resp = $client->post(
        "$self->{api_url}",
        {
            call    => 'deleteDNSZone',
            api_id  => $self->{api_id'},
            api_key => $self->{api_key'},
            dnsapp  => $self->{dnsapp},
            name    => $domain
        }
    );

    return $resp->{'success'};
}

sub savezone {
    my ($self, $domain, $records) = @_;
    $logger->info("Saving zone $domain in Hostbill API") if $self->{debug};

    my $client = Cpanel::HTTP::Client->new(timeout => 60);
    my $resp = $client->post(
        "$self->{api_url}",
        {
            call    => 'editDNSRecord',
            api_id  => $self->{api_id'},
            api_key => $self->{api_key'},
            dnsapp  => $self->{dnsapp},
            name    => $domain,
            records => encode_json($records)
        }
    );

    return $resp->{'success'};
}

sub synczones {
    my ($self) = @_;
    $logger->info("Syncing zones with Hostbill API") if $self->{debug};

    my $zones = $self->getzonelist();
    foreach my $zone (@$zones) {
        $self->savezone($zone->{'name'}, $zone->{'records'});
    }
    return 1;
}

sub zoneexists {
    my ($self, $domain) = @_;
    my $zones = $self->getzonelist();
    return scalar grep { $_->{'name'} eq $domain } @$zones;
}

1;
