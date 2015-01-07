use 5.006;

package MouseX::App::Cmd;
use Mouse;
use English '-no_match_vars';
use File::Basename ();

# VERSION
use namespace::clean -except => 'meta';
extends 'Mouse::Object', 'App::Cmd';

sub BUILDARGS {
    my ( undef, @arg ) = @_;
    return {} if !@arg;
    return { arg => $arg[0] } if 1 == @arg;
    return {@arg};
}

sub BUILD {
    my $self  = shift;
    my $class = blessed $self;
    $self->{arg0}      = File::Basename::basename($PROGRAM_NAME);
    $self->{command}   = $class->_command( {} );
    $self->{full_arg0} = $PROGRAM_NAME;
    return;
}

## no critic (Modules::RequireExplicitInclusion)
__PACKAGE__->meta->make_immutable();
1;

# ABSTRACT: Mashes up MouseX::Getopt and App::Cmd

=head1 SYNOPSIS

    package YourApp::Cmd;
    use Mouse;

    extends qw(MouseX::App::Cmd);


    package YourApp::Cmd::Command::blort;
    use Mouse;

    extends qw(MouseX::App::Cmd::Command);

    has blortex => (
        traits => [qw(Getopt)],
        isa => 'Bool',
        is  => 'rw',
        cmd_aliases   => 'X',
        documentation => 'use the blortext algorithm',
    );

    has recheck => (
        traits => [qw(Getopt)],
        isa => 'Bool',
        is  => 'rw',
        cmd_aliases => 'r',
        documentation => 'recheck all results',
    );

    sub execute {
        my ( $self, $opt, $args ) = @_;

        # you may ignore $opt, it's in the attributes anyway

        my $result = $self->blortex ? blortex() : blort();

        recheck($result) if $self->recheck;

        print $result;
    }

=head1 DESCRIPTION

This module marries L<App::Cmd|App::Cmd> with L<MouseX::Getopt|MouseX::Getopt>.

Use it like L<App::Cmd|App::Cmd> advises (especially see
L<App::Cmd::Tutorial|App::Cmd::Tutorial>), swapping
L<App::Cmd::Command|App::Cmd::Command> for
L<MouseX::App::Cmd::Command|MouseX::App::Cmd::Command>.

Then you can write your moose commands as Mouse classes, with
L<MouseX::Getopt|MouseX::Getopt>
defining the options for you instead of C<opt_spec> returning a
L<Getopt::Long::Descriptive|Getopt::Long::Descriptive> spec.

=method BUILD

After calling C<new> this method is automatically run, setting underlying
L<App::Cmd|App::Cmd> attributes as per its documentation.

=head1 SEE ALSO

=over

=item L<App::Cmd|App::Cmd>

=item L<App::Cmd::Tutorial|App::Cmd::Tutorial>

=item L<MouseX::Getopt|MouseX::Getopt>

=item L<MouseX::App::Cmd::Command|MouseX::App::Cmd::Command>

=back
