#use strict;
use URI::Escape;
use HTTP::Tiny;
use vars qw($VERSION %IRSSI);
use JSON::PP;
use Data::Dumper;
use Irssi;

my $json = JSON::PP->new->allow_nonref;

$VERSION = '0.0.2';
%IRSSI = (
	name => 'giphy',
	authors => 'Lee Helpingstine',
    contact => 'sig11@reprehensible.net',
	description => 'Searches giphy to emulate slack\'s /giphy command.'
);

my $api_key = 'dc6zaTOxFJmzC';


sub searchGiphy {
	my ($search, $server, $dest) = @_;

	my $url = "http://api.giphy.com/v1/gifs/search?api_key=dc6zaTOxFJmzC&limit=10&q=" . uri_escape($search);
	my $http = HTTP::Tiny->new();
	my $response = $http->get($url);
	my $obj = $json->decode($response->{content});

    my $link = $obj->{data}[int(rand(scalar(keys $obj->{data})))]->{url};

	if ($dest->{type} eq "CHANNEL" || $dest->{type} eq "QUERY") {
        $dest->command("/msg " . $dest->{name} . " GIPHY $search " . $link);
	}

}

Irssi::command_bind('giphy', \&searchGiphy);
