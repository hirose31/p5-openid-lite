package OpenID::Lite::SessionHandler::DH::SHA256;

use Any::Moose;
extends 'OpenID::Lite::SessionHandler::DH';

use OpenID::Lite::Constants::AssocType qw(HMAC_SHA256);
use OpenID::Lite::Constants::SessionType qw(DH_SHA256);

use Digest::SHA ();

has '+_session_type' => (
    is      => 'rw',
    isa     => 'Str',
    default => DH_SHA256,
);

has '+_allowed_assoc_types' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub { [ HMAC_SHA256 ] },
);

has '+_secret_length' => (
    is      => 'ro',
    isa     => 'Int',
    default => 20,
);

override '_hash' => sub {
    my ( $self, $dh_sec ) = @_;
    return Digest::SHA::sha256( $dh_sec );
};

no Any::Moose;
__PACKAGE__->meta->make_immutable;
1;


