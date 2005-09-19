#!/local/programs/bin/perl -w

#$Id$

use DBI;
use Test::More; 
use Digest::MD5 qw( md5 md5_base64 );
use strict;

# Number of times to execute each statement.
use constant ITERATIONS => 10;
use constant REFRESH_HANDLE => 0;
use constant VERBOSE => 0;

# Quiet down in there!
close(STDERR);

# Immediate gratification desired, do not buffer output
$|++; 

my %queries = ( 1 => 'SELECT TOP 10000 * FROM proteomics.dbo.search_hit',
                2 => 'SELECT TOP 10000 * FROM proteomics.dbo.msms_spectrum_peak',
                3 => 'SELECT TOP 10000 * FROM proteomics.dbo.quantitation',
              ); 

my $num_tests = scalar(keys(%queries)) * 2 + 1;
plan( tests => $num_tests );
  
# Set up user agent and sbeams objects
my $dbh = dbConnect();
my $msg = ( ref($dbh) ) ?  "Connect to db ($dbh->{Driver}->{Name}, version $dbh->{Driver}->{Version}  )" : "Failed to connect to database, $dbh";
ok( ref($dbh), $msg ); 

# Setup
my %results;


SKIP: {
skip "queries, db connection failed", $num_tests - 1 unless ref($dbh);
# Establish baseline data.
for my $key ( sort( keys( %queries ) ) ) { 
  my $sth = $dbh->prepare( $queries{$key} );
  $sth->execute;
  my @results = stringify( $sth );
  $results{$key} = \@results;
  ok( $results{$key} , "Got data for query $key" );
}


# Loop through each query and execute it the specified number of times.
my $status = 1;
my $iterations = ITERATIONS;
for my $key ( sort( keys( %queries ) ) ) {
#   Get a fresh handle, if so configured 
  if ( REFRESH_HANDLE ) {
    eval { $dbh->disconnect() };
    $dbh = dbConnect();
  }
  for( my $i = 1; $i < $iterations; $i++ ) {

    # prep and exec query
    my $sth = $dbh->prepare( $queries{$key} );
    $sth->execute();

    # Check number and content of return values
    my( $num, $string ) = stringify( $sth );

    # Define error conditions
    if ( $num != $results{$key}->[0] ) {
      print STDERR "$num results returned, $results{$key} expected at iteration $i for query $key\n";
      $status = 0;
      last;
    } elsif ( $string ne $results{$key}->[1] ) {
      print STDERR "MD5 sum different at iteration $i for query $key\n";
      $status = 0;
      last;
    }
  }
  ok( $status, "Run query $key for $iterations iterations" );
}
} # End skip block
eval { $dbh->disconnect() };

#+
# Join each row on '::', concatenate the whole shebang, and take an MD5Sum of the result.
#-
sub stringify {
  my $sth = shift;
  my $cnt = 0;
  my $contents = '';
  while ( my @row = $sth->fetchrow_array() ) {
    $cnt++;
    $contents .= join "::", map{ ( defined $_ ) ? $_ : 'NULL' } @row;
  }
  my $chksum = md5_base64( $contents );
#  print STDERR "$chksum => $contents\n" if 1; # Debug stmt, proves something is working!
  print "checksum => $chksum\n" if VERBOSE; # Debug stmt, proves something is working!
  return ( $cnt, $chksum );
}

sub dbConnect {
  # Define the database you want to interrogate
  my $db = 'sqlserv';
          # 'pgsql';
          # 'mysql';
          # 'sqlserv';
  
 my %connect = ( mysql => "DBI:mysql:host=mysql;database=test", 
                 sqlserv => "DBI:Sybase:server=mssql;database=SBEAMSTest1", 
                 pgsql => "DBI:Pg:host=pgsql;dbname=sbeamstest1" );

  my $user = 'sbeams_user';

  my %pass = ( mysql => 'mysql_pass',
               sqlserv => 'mssql_pass',
               pgsql => 'pgsql_pass' ); 

  my $dbh;
  eval { $dbh = DBI->connect( $connect{$db}, $user, $pass{$db}, { RaiseError => 1, AutoCommit => 0 } ) }; 

  my $errstr;
  if ( $@ ) {
    my @errs = split /\n/, $DBI::errstr;
    $errstr = $errs[0];
  }
    

  return $dbh || $errstr;
}

