#!/usr/bin/env perl
 
use strict;
use warnings;

use HTTP::Tiny;
use JSON::PP qw(encode_json decode_json);

#######
# GET #
#######

# create an agent
my $agent = HTTP::Tiny->new(
default_headers => {
    'X-Custom-App-Name' => 'ExampleApp',
    'X-Custom-Auth-Token' => 'fb349ef1-91e4-fake-4b05-aaa2-52246b77ea66',
    'Accept' => "application/json",
    },
);

# talk to the API 
my $response = $agent->get('https://api.example.com/user/current');
 
# parse the result as JSON
my $result = $response->{content} ? decode_json $response->{content} : {};
 
# handle errors
unless ($response->{success}) {
die "$response->{status}: $result->{code} ($result->{message})\n";
}
 
# result holds the data from the server result
print "Hello $result->{firstname} $result->{lastname}\n";

# print out each user's details
print "Users with access to the account:\n";

foreach my $user (@{ $result }) {
    print " * $user->{_cid} ($user->{firstname} $user->{lastname})\n";
}

#-----------------------------------------------------------#

#######
# PUT #
#######

# talk to the API
my $response = $agent->put('https://api.example.com/user/current', {
    content => encode_json {
    firstname => "Gonzo",
    },
});

print "Your first name is now $result->{firstname}\n";

#-----------------------------------------------------------#

########
# POST #
########

# talk to the API
my $response = $agent->post('https://api.example.com/annotation', {
    content => encode_json {
    title => "Zaras Birthday",
    description => "Zara is four today",
    start => 1332216000,
    stop => 1332302399,
    }
});

print "Created annotation: $result->{_cid} ($result->{title})\n";

#-----------------------------------------------------------#

##########
# DELETE #
##########

# talk to the API
my $response = $agent->delete('https://api.example.com/graph/123456');
 
print "DELETED!\n";

#-----------------------------------------------------------#
