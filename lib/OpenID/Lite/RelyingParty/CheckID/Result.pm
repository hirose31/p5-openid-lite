package OpenID::Lite::RelyingParty::CheckID::Result;

use Any::Moose;
use OpenID::Lite::Constants::CheckIDResponse qw(:all);

# common properties
has 'type' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'message' => (
    is      => 'ro',
    isa     => 'Str',
    default => '',
);

# used under error status
has 'contact' => (
    is      => 'ro',
    isa     => 'Str',
    default => '',
);

has 'reference' => (
    is      => 'ro',
    isa     => 'Str',
    default => '',
);

# used under setup_needed status
has 'url' => (
    is        => 'ro',
    isa       => 'Str',
    predicate => 'has_url',
);

# used under successful status
has 'claimed_identifier' => (
    is  => 'ro',
    isa => 'Str',
);

has 'identity' => (
    is  => 'ro',
    isa => 'Str',
);

sub is_invalid {
    my $self = shift;
    return $self->type eq IS_INVALID;
}

sub is_error {
    my $self = shift;
    return $self->type eq IS_ERROR;
}

sub is_canceled {
    my $self = shift;
    return $self->type eq IS_CANCELED;
}

sub is_setup_needed {
    my $self = shift;
    return $self->type eq IS_SETUP_NEEDED;
}

sub is_success {
    my $self = shift;
    return $self->type eq IS_SUCCESS;
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
1;

