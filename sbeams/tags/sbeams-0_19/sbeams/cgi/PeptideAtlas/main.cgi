#!/usr/local/bin/perl

###############################################################################
# Program     : main.cgi
# Author      : Eric Deutsch <edeutsch@systemsbiology.org>
# $Id$
#
# Description : This script authenticates the user, and then
#               displays the opening access page.
#
# SBEAMS is Copyright (C) 2000-2003 by Eric Deutsch
# This program is governed by the terms of the GNU General Public License (GPL)
# version 2 as published by the Free Software Foundation.  It is provided
# WITHOUT ANY WARRANTY.  See the full description of GPL terms in the
# LICENSE file distributed with this software.
#
###############################################################################


###############################################################################
# Get the script set up with everything it will need
###############################################################################
use strict;
use vars qw ($q $sbeams $sbeamsPeptideAtlas $PROGRAM_FILE_NAME
             $current_contact_id $current_username);
use lib qw (../../lib/perl);
#use CGI;
use CGI::Carp qw(fatalsToBrowser croak);

use SBEAMS::Connection qw($q);
use SBEAMS::Connection::Settings;
use SBEAMS::Connection::Tables;
use SBEAMS::Connection::TabMenu;

use SBEAMS::PeptideAtlas;
use SBEAMS::PeptideAtlas::Settings;

#$q   = new CGI;
$sbeams = new SBEAMS::Connection;
$sbeamsPeptideAtlas = new SBEAMS::PeptideAtlas;
$sbeamsPeptideAtlas->setSBEAMS($sbeams);


###############################################################################
# Global Variables
###############################################################################
$PROGRAM_FILE_NAME = 'main.cgi';
main();


###############################################################################
# Main Program:
#
# Call $sbeams->Authentication and stop immediately if authentication
# fails else continue.
###############################################################################
sub main { 

    #### Do the SBEAMS authentication and exit if a username is not returned
    exit unless ($current_username = $sbeams->Authenticate( allow_anonymous_access => 1 ) );

    #### Print the header, do what the program does, and print footer
    $sbeamsPeptideAtlas->printPageHeader();

    showMainPage();

    $sbeamsPeptideAtlas->printPageFooter();

} # end main


###############################################################################
# Show the main welcome page
###############################################################################
sub showMainPage {

    $sbeams->printUserContext();

    print <<"    END";
        <BR>
    END

    # Create new tabmenu item.  This may be a $sbeams object method in the future.
    my $tabmenu = 
        SBEAMS::Connection::TabMenu->new( cgi => $q,
                                          activeColor => 'ffcc99',
                                          inactiveColor   => 'cccccc',
                                          hoverColor => 'ffff99',
                                          atextColor => '000000', # black
                                          itextColor => 'ff0000', # black
                                          # paramName => 'mytabname', # uses this as cgi param
                                          #maSkin => 1,   # If true, use MA look/feel
                                          #isSticky => 0, # If true, pass thru cgi params 
                                          # boxContent => 0, # If true draw line around content
                                          # labels => \@labels # Will make one tab per $lab (@labels)
    );

    #Preferred way to add tabs.  label is required, helptext optional
    $tabmenu->addTab( label => 'Browse Peptides', 
                      helptext => 'Multi-constraint browsing of PeptideAtlas',
                      URL => "$CGI_BASE_DIR/PeptideAtlas/GetPeptides" );

    $tabmenu->addTab( label => 'Get Peptide', 
                      helptext => 'Look-up info on a peptide by sequence or name',
                      URL => "$CGI_BASE_DIR/PeptideAtlas/GetPeptide" 
                      );

    $tabmenu->addTab( label => 'Browse Proteins',
                      helptext => 'Not implemented yet',
                      URL => "$CGI_BASE_DIR/PeptideAtlas/main.cgi"
                      );

    $tabmenu->addTab( label => 'Get Protein',
                      helptext => 'Not implemented yet',
                      URL => "$CGI_BASE_DIR/PeptideAtlas/main.cgi"
                      );

    my $content; 

    if ( $tabmenu->getActiveTabName() eq 'Browse Proteins' ||
         $tabmenu->getActiveTabName() eq 'Get Protein' ) {

        $content = "<BR><BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>[coming soon, not implemented yet]<B><BR><BR>";

    }

    $tabmenu->addHRule();

    $tabmenu->addContent( $content );

    print "$tabmenu";


#   print "$SERVER_BASE_DIR <BR>  $CGI_BASE_DIR <BR>";

} # end showMainPage