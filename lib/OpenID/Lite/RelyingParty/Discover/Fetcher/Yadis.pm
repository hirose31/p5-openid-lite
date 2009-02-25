package OpenID::Lite::RelyingParty::Discover::Fetcher::Yadis;

use Mouse;
with 'OpenID::Lite::Role::AgentHandler';
with 'OpenID::Lite::Role::ErrorHandler';

use OpenID::Lite::RelyingParty::Discover::Fetcher::Yadis::HTMLExtractor;
use OpenID::Lite::RelyingParty::Discover::FetchResult;
use OpenID::Lite::Constants::Yadis
    qw(XRDS_HEADER YADIS_HEADER XRDS_CONTENT_TYPE);

has '_html_extractor' => (
    is         => 'ro',
    lazy_build => 1,
);

sub fetch {
    my ( $self, $uri ) = @_;

    my $res = $self->agent->get( $uri, 'Accept' => XRDS_CONTENT_TYPE );
    return $self->ERROR( sprintf q{Failed Yadis discovery on "%s"}, $uri )
        unless $res->is_success;

    my $result = OpenID::Lite::RelyingParty::Discover::FetchResult->new;
    $result->normalized_identifier($uri);

    my $content_type = $res->header('Content-Type');
    if ( $content_type && lc $content_type eq lc XRDS_CONTENT_TYPE ) {
        $result->content_type( lc $content_type );
        $result->final_url( $res->base->as_string );
        $result->content( $res->content );
    }
    else {

        my $yadis_location = $self->_extract_location($res)
            or return $self->ERROR(
            sprintf q{Failed Yadis discovery for url "%s"}, $uri );

        $res = $self->agent->get($yadis_location);
        return $self->ERROR( sprintf q{Failed Yadis discovery for url "%s"},
            $yadis_location )
            unless $res->is_success;

        $result->content_type( lc $res->header('Content-Type') );
        $result->final_url( $res->base->as_string );
        $result->content( $res->content );
    }
    return $result;
}

sub _extract_location {
    my ( $self, $res ) = @_;
    return $self->_extract_location_from_header($res)
        || $self->_extract_location_from_html( $res->content );
}

sub _extract_location_from_header {
    my ( $self, $res ) = @_;
    return $res->header(XRDS_HEADER)
        || $res->header(YADIS_HEADER);
}

sub _extract_location_from_html {
    my ( $self, $content ) = @_;
    return $self->_html_extractor->extract($content);
}

sub _build__html_extractor {
    my $self = shift;
    OpenID::Lite::RelyingParty::Discover::Fetcher::Yadis::HTMLExtractor->new;
}

1;

