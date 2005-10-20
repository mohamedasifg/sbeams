#!/usr/local/bin/perl -w

#####################################################################
# Program	: SQLTest.t
# Author	: Jeff Howbert <peak.list@verizon.net>
# $Id$
#
# Description	: This script exercises specific SQL statements in a
#		  variety of modules, primarily to confirm they
#		  execute correctly when passed to different SQL
#		  engines.
#
# SBEAMS is Copyright (C) 2000-2005 Institute for Systems Biology
# This program is governed by the terms of the GNU General Public
# License (GPL) version 2 as published by the Free Software
# Foundation.  It is provided WITHOUT ANY WARRANTY.  See the full
# description of GPL terms in the LICENSE file distributed with this
# software.
#####################################################################

use strict;
use FindBin qw ( $Bin );
use lib( "$Bin/../.." );         # path to $SBEAMS/lib/perl directory
use Test::More;


###############################################################################
# BEGIN
###############################################################################
BEGIN {
    plan tests => 6;
    use_ok( 'SBEAMS::Connection' );
    use_ok( 'SBEAMS::Connection::Settings' );
    use_ok( 'SBEAMS::Connection::Tables' );
} # end BEGIN


###############################################################################
# END
###############################################################################
END {
    breakdown();
} # end END


###############################################################################
# MAIN
###############################################################################
use vars qw ( $sbeams );   # Main SBEAMS Connection object

ok($sbeams = SBEAMS::Connection->new(),"create main SBEAMS object");

#### Authenticate the current user
my $current_username;
ok($current_username = $sbeams->Authenticate(
			 permitted_work_groups_ref=>['Admin'],
			 #connect_read_only=>1,
			),"Authenticate current user");


#######################################################
# Test individal methods here
#######################################################

ok(testSimpleStringColumnConcat(),"Simple varchar column concatenation");







###############################################################################
# testSimpleStringColumnConcat
###############################################################################
sub testSimpleStringColumnConcat {

  my $sql = qq~
SELECT first_name+' '+last_name
  FROM $TB_CONTACT
  ~;

  my @contacts = $sbeams->selectOneColumn($sql);

  if (defined(@contacts) && scalar(@contacts)>1 &&
      grep(/SBEAMS Administrator/,@contacts)) {
    diag("Returned ".scalar(@contacts)." rows");
    return(1);
  }

  return(0);
}



###############################################################################
# breakdown
###############################################################################
sub breakdown {
#    print "After the script, there was ... END\n\n";
}



################################################################################

1;

__END__

################################################################################
################################################################################
################################################################################

=head1  SQLTest.t

=head2  DESCRIPTION

This script exercises specific SQL statements in a variety of modules,
primarily to confirm they execute correctly when passed to different SQL
engines.

Executable currently located in sbeams/lib/perl/t/Core.

=head2  USAGE

Invoke on the command line as "SQLTest.t [ arg1 arg2 ... ]", where name of
script is followed zero or more arguments, each argument being the name of
a database instance used by the SBEAMS system.  The database instance names
should be the same as the names appearing as section headings in SBEAMS.conf.

Sample usages:

SQLTest.t               # defaults to "SQLTest.t dev1"
SQLTest.t mysql
SQLTest.t mssql
SQLTest.t mysql mssql
SQLTest.t dev1 mssql mysql

=head2  KNOWN BUGS AND LIMITATIONS

1) "SQLTest.t default" gives errors.
2) "SQLTest.t xxx", where xxx is not one of the database instance names
used in SBEAMS.conf, gives appropriate notification, but throws off the
count of tests.
3) Running the script with against a database instance that is valid
within SBEAMS.conf but inaccessible may cause premature termination
of the script.

=head2  AUTHOR

Jeff Howbert <peak.list@verizon.net>

=cut
