#!/usr/bin/perl -w
use strict;
use warnings FATAL => 'all';

# tests for Orthologger Module
use Test::More tests=> 4;

use lib '/home/tomfy/cxgn/cxgn-corelibs/lib';
use lib '/home/tomfy/Orthologger/lib';

use CXGN::Phylo::Parser;
use Orthologger;

# This is family 2830, with 25 genes in 13 taxa.
my $gene_tree_newick = '((jgi_Selmo1_91292[species=Selaginella]:0.00532,jgi_Selmo1_158231[species=Selaginella]:0.00016)[speciation=0]:0.06862,((Bradi1g48740.1[spe
cies=Brachypodium_distachyon]:0.03551,(((Sb10g004030.1[species=Sorghum_bicolor]:0.0001,GRMZM2G140689_P02[species=Zea_mays]:0.0001)[speciatio
n=1]:0.00015,(GRMZM2G016330_P01[species=Zea_mays]:0.0001,GRMZM2G016330_P03[species=Zea_mays]:0.0001)[speciation=0]:0.00536)[speciation=0]:0.
02677,(LOC_Os06g06410.1[species=Oryza_sativa]:0.01662,LOC_Os06g06410.2[species=Oryza_sativa]:0.00015)[speciation=0]:0.00288)[speciation=1]:0
.02333)[speciation=0]:0.08447,((Solyc03g121130.2.1[species=Solanum_lycopersicum]:0.03887,(((POPTR_0014s08830.1[species=Populus_trichocarpa]:
0.0001,POPTR_0014s08830.2[species=Populus_trichocarpa]:0.0001)[speciation=0]:0.05550,(X_30131.m006857[species=Ricinus_communis]:0.01095,X_30
131.m007044[species=Ricinus_communis]:0.00016)[speciation=0]:0.02176)[speciation=1]:0.04630,(evm.model.supercontig_184.11[species=Carica_pap
aya]:0.04198,(AT2G46230.1[species=Arabidopsis_thaliana]:0.01153,AT2G46230.2[species=Arabidopsis_thaliana]:0.07275)[speciation=0]:0.15150)[sp
eciation=1]:0.02371)[speciation=1]:0.01878)[speciation=1]:0.01095,((GSVIVT01026915001[species=Vitis_vinifera]:0.0001,GSVIVT01027024001[speci
es=Vitis_vinifera]:0.0001)[speciation=0]:0.07067,(((Glyma12g31740.1[species=Glycine_max]:0.0001,Glyma13g38690.1[species=Glycine_max]:0.0001)
[speciation=0]:0.0001,(Glyma13g38690.2[species=Glycine_max]:0.0001,Glyma13g38690.3[species=Glycine_max]:0.0001)[speciation=0]:0.0001)[specia
tion=0]:0.01992,(IMGA_Medtr6g086290.1[species=Medicago_truncatula]:0.02191,IMGA_Medtr7g116720.1[species=Medicago_truncatula]:0.00015)[specia
tion=0]:0.06024)[speciation=1]:0.05419)[speciation=1]:0.01302)[speciation=0]:0.0167)[speciation=1]:0.06862)';

$gene_tree_newick =~ s/\s//g; # remove whitespace.

my $species_tree_newick = '(Selaginella[species=Selaginella]:1,(((sorghum[species=Sorghum_bicolor]:1,maize[species=Zea_mays]:1):1,(rice[species=Oryza_sativa]:1,brachypodium[species=Brachypodium_distachyon]:1):1):1,(tomato[species=Solanum_lycopersicum]:1,(grape[species=Vitis_vinifera]:1,((papaya[species=Carica_papaya]:1,arabidopsis[species=Arabidopsis_thaliana]:1):1,((soy[species=Glycine_max]:1,medicago[species=Medicago_truncatula]:1):1,(castorbean[species=Ricinus_communis]:1,Poplar[species=Populus_trichocarpa]:1):1):1):1):1):1):1)'; 
$species_tree_newick =~ s/\s//g; # remove whitespace.

		my $gt_parser = CXGN::Phylo::Parse_newick->new($gene_tree_newick);
		my $gene_tree = $gt_parser->parse();

	my $st_parser = CXGN::Phylo::Parse_newick->new($species_tree_newick);
		my $species_tree = $st_parser->parse();

my $Orthologger_obj = Orthologger->new( {'gene_tree' => $gene_tree, 'species_tree' => $species_tree, 'reroot' => 'mindl'} );
ok( defined $Orthologger_obj, 'new() returned something.');
isa_ok( $Orthologger_obj, 'Orthologger' );

#print "Rerooted tree: \n", $Orthologger_obj->get_gene_tree()->generate_newick(), "\n\n";


my $ortholog_report_string = $Orthologger_obj->ortholog_result_string();

#print "Got ortholog report string:\n", $ortholog_report_string, "\n";
my $expected_ortholog_report_string = 'orthologs of jgi_Selmo1_91292:  AT2G46230.1 AT2G46230.2 Bradi1g48740.1 GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 GSVIVT01026915001 GSVIVT01027024001 Glyma12g31740.1 Glyma13g38690.1 Glyma13g38690.2 Glyma13g38690.3 IMGA_Medtr6g086290.1 IMGA_Medtr7g116720.1 LOC_Os06g06410.1 LOC_Os06g06410.2 POPTR_0014s08830.1 POPTR_0014s08830.2 Sb10g004030.1 Solyc03g121130.2.1 X_30131.m006857 X_30131.m007044 evm.model.supercontig_184.11
orthologs of jgi_Selmo1_158231:  AT2G46230.1 AT2G46230.2 Bradi1g48740.1 GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 GSVIVT01026915001 GSVIVT01027024001 Glyma12g31740.1 Glyma13g38690.1 Glyma13g38690.2 Glyma13g38690.3 IMGA_Medtr6g086290.1 IMGA_Medtr7g116720.1 LOC_Os06g06410.1 LOC_Os06g06410.2 POPTR_0014s08830.1 POPTR_0014s08830.2 Sb10g004030.1 Solyc03g121130.2.1 X_30131.m006857 X_30131.m007044 evm.model.supercontig_184.11
orthologs of Bradi1g48740.1:  AT2G46230.1 AT2G46230.2 GSVIVT01026915001 GSVIVT01027024001 Glyma12g31740.1 Glyma13g38690.1 Glyma13g38690.2 Glyma13g38690.3 IMGA_Medtr6g086290.1 IMGA_Medtr7g116720.1 POPTR_0014s08830.1 POPTR_0014s08830.2 Solyc03g121130.2.1 X_30131.m006857 X_30131.m007044 evm.model.supercontig_184.11 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of Sb10g004030.1:  GRMZM2G140689_P02 LOC_Os06g06410.1 LOC_Os06g06410.2 AT2G46230.1 AT2G46230.2 GSVIVT01026915001 GSVIVT01027024001 Glyma12g31740.1 Glyma13g38690.1 Glyma13g38690.2 Glyma13g38690.3 IMGA_Medtr6g086290.1 IMGA_Medtr7g116720.1 POPTR_0014s08830.1 POPTR_0014s08830.2 Solyc03g121130.2.1 X_30131.m006857 X_30131.m007044 evm.model.supercontig_184.11 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of GRMZM2G140689_P02:  Sb10g004030.1 LOC_Os06g06410.1 LOC_Os06g06410.2 AT2G46230.1 AT2G46230.2 GSVIVT01026915001 GSVIVT01027024001 Glyma12g31740.1 Glyma13g38690.1 Glyma13g38690.2 Glyma13g38690.3 IMGA_Medtr6g086290.1 IMGA_Medtr7g116720.1 POPTR_0014s08830.1 POPTR_0014s08830.2 Solyc03g121130.2.1 X_30131.m006857 X_30131.m007044 evm.model.supercontig_184.11 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of GRMZM2G016330_P01:  LOC_Os06g06410.1 LOC_Os06g06410.2 AT2G46230.1 AT2G46230.2 GSVIVT01026915001 GSVIVT01027024001 Glyma12g31740.1 Glyma13g38690.1 Glyma13g38690.2 Glyma13g38690.3 IMGA_Medtr6g086290.1 IMGA_Medtr7g116720.1 POPTR_0014s08830.1 POPTR_0014s08830.2 Solyc03g121130.2.1 X_30131.m006857 X_30131.m007044 evm.model.supercontig_184.11 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of GRMZM2G016330_P03:  LOC_Os06g06410.1 LOC_Os06g06410.2 AT2G46230.1 AT2G46230.2 GSVIVT01026915001 GSVIVT01027024001 Glyma12g31740.1 Glyma13g38690.1 Glyma13g38690.2 Glyma13g38690.3 IMGA_Medtr6g086290.1 IMGA_Medtr7g116720.1 POPTR_0014s08830.1 POPTR_0014s08830.2 Solyc03g121130.2.1 X_30131.m006857 X_30131.m007044 evm.model.supercontig_184.11 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of LOC_Os06g06410.1:  GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 Sb10g004030.1 AT2G46230.1 AT2G46230.2 GSVIVT01026915001 GSVIVT01027024001 Glyma12g31740.1 Glyma13g38690.1 Glyma13g38690.2 Glyma13g38690.3 IMGA_Medtr6g086290.1 IMGA_Medtr7g116720.1 POPTR_0014s08830.1 POPTR_0014s08830.2 Solyc03g121130.2.1 X_30131.m006857 X_30131.m007044 evm.model.supercontig_184.11 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of LOC_Os06g06410.2:  GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 Sb10g004030.1 AT2G46230.1 AT2G46230.2 GSVIVT01026915001 GSVIVT01027024001 Glyma12g31740.1 Glyma13g38690.1 Glyma13g38690.2 Glyma13g38690.3 IMGA_Medtr6g086290.1 IMGA_Medtr7g116720.1 POPTR_0014s08830.1 POPTR_0014s08830.2 Solyc03g121130.2.1 X_30131.m006857 X_30131.m007044 evm.model.supercontig_184.11 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of Solyc03g121130.2.1:  AT2G46230.1 AT2G46230.2 POPTR_0014s08830.1 POPTR_0014s08830.2 X_30131.m006857 X_30131.m007044 evm.model.supercontig_184.11 Bradi1g48740.1 GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 LOC_Os06g06410.1 LOC_Os06g06410.2 Sb10g004030.1 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of POPTR_0014s08830.1:  X_30131.m006857 X_30131.m007044 AT2G46230.1 AT2G46230.2 evm.model.supercontig_184.11 Solyc03g121130.2.1 Bradi1g48740.1 GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 LOC_Os06g06410.1 LOC_Os06g06410.2 Sb10g004030.1 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of POPTR_0014s08830.2:  X_30131.m006857 X_30131.m007044 AT2G46230.1 AT2G46230.2 evm.model.supercontig_184.11 Solyc03g121130.2.1 Bradi1g48740.1 GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 LOC_Os06g06410.1 LOC_Os06g06410.2 Sb10g004030.1 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of X_30131.m006857:  POPTR_0014s08830.1 POPTR_0014s08830.2 AT2G46230.1 AT2G46230.2 evm.model.supercontig_184.11 Solyc03g121130.2.1 Bradi1g48740.1 GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 LOC_Os06g06410.1 LOC_Os06g06410.2 Sb10g004030.1 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of X_30131.m007044:  POPTR_0014s08830.1 POPTR_0014s08830.2 AT2G46230.1 AT2G46230.2 evm.model.supercontig_184.11 Solyc03g121130.2.1 Bradi1g48740.1 GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 LOC_Os06g06410.1 LOC_Os06g06410.2 Sb10g004030.1 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of evm.model.supercontig_184.11:  AT2G46230.1 AT2G46230.2 POPTR_0014s08830.1 POPTR_0014s08830.2 X_30131.m006857 X_30131.m007044 Solyc03g121130.2.1 Bradi1g48740.1 GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 LOC_Os06g06410.1 LOC_Os06g06410.2 Sb10g004030.1 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of AT2G46230.1:  evm.model.supercontig_184.11 POPTR_0014s08830.1 POPTR_0014s08830.2 X_30131.m006857 X_30131.m007044 Solyc03g121130.2.1 Bradi1g48740.1 GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 LOC_Os06g06410.1 LOC_Os06g06410.2 Sb10g004030.1 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of AT2G46230.2:  evm.model.supercontig_184.11 POPTR_0014s08830.1 POPTR_0014s08830.2 X_30131.m006857 X_30131.m007044 Solyc03g121130.2.1 Bradi1g48740.1 GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 LOC_Os06g06410.1 LOC_Os06g06410.2 Sb10g004030.1 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of GSVIVT01026915001:  Glyma12g31740.1 Glyma13g38690.1 Glyma13g38690.2 Glyma13g38690.3 IMGA_Medtr6g086290.1 IMGA_Medtr7g116720.1 Bradi1g48740.1 GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 LOC_Os06g06410.1 LOC_Os06g06410.2 Sb10g004030.1 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of GSVIVT01027024001:  Glyma12g31740.1 Glyma13g38690.1 Glyma13g38690.2 Glyma13g38690.3 IMGA_Medtr6g086290.1 IMGA_Medtr7g116720.1 Bradi1g48740.1 GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 LOC_Os06g06410.1 LOC_Os06g06410.2 Sb10g004030.1 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of Glyma12g31740.1:  IMGA_Medtr6g086290.1 IMGA_Medtr7g116720.1 GSVIVT01026915001 GSVIVT01027024001 Bradi1g48740.1 GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 LOC_Os06g06410.1 LOC_Os06g06410.2 Sb10g004030.1 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of Glyma13g38690.1:  IMGA_Medtr6g086290.1 IMGA_Medtr7g116720.1 GSVIVT01026915001 GSVIVT01027024001 Bradi1g48740.1 GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 LOC_Os06g06410.1 LOC_Os06g06410.2 Sb10g004030.1 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of Glyma13g38690.2:  IMGA_Medtr6g086290.1 IMGA_Medtr7g116720.1 GSVIVT01026915001 GSVIVT01027024001 Bradi1g48740.1 GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 LOC_Os06g06410.1 LOC_Os06g06410.2 Sb10g004030.1 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of Glyma13g38690.3:  IMGA_Medtr6g086290.1 IMGA_Medtr7g116720.1 GSVIVT01026915001 GSVIVT01027024001 Bradi1g48740.1 GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 LOC_Os06g06410.1 LOC_Os06g06410.2 Sb10g004030.1 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of IMGA_Medtr6g086290.1:  Glyma12g31740.1 Glyma13g38690.1 Glyma13g38690.2 Glyma13g38690.3 GSVIVT01026915001 GSVIVT01027024001 Bradi1g48740.1 GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 LOC_Os06g06410.1 LOC_Os06g06410.2 Sb10g004030.1 jgi_Selmo1_158231 jgi_Selmo1_91292
orthologs of IMGA_Medtr7g116720.1:  Glyma12g31740.1 Glyma13g38690.1 Glyma13g38690.2 Glyma13g38690.3 GSVIVT01026915001 GSVIVT01027024001 Bradi1g48740.1 GRMZM2G016330_P01 GRMZM2G016330_P03 GRMZM2G140689_P02 LOC_Os06g06410.1 LOC_Os06g06410.2 Sb10g004030.1 jgi_Selmo1_158231 jgi_Selmo1_91292';

my @ortholog_lines = split("\n", $ortholog_report_string);
my @expected_ortholog_lines = split("\n", $expected_ortholog_report_string);
my ($nlines, $nxlines) = (scalar @ortholog_lines, scalar @expected_ortholog_lines); 
is($nlines, $nxlines, "Check number of output lines agrees with expectation: $nlines, $nxlines.");

my @sorted_ortholog_lines = sort @ortholog_lines;
my @sorted_expected_ortholog_lines = sort @expected_ortholog_lines;
$ortholog_report_string = join("\n", @sorted_ortholog_lines);
$expected_ortholog_report_string = join("\n", @sorted_expected_ortholog_lines);

#ok($ortholog_report_string eq $expected_ortholog_report_string, "Check ortholog report string agrees with expectation.");
is($ortholog_report_string, $expected_ortholog_report_string, 'Check ortholog report string agrees with expectation.');

# while (@ortholog_lines){
#   my $line = shift @ortholog_lines;
# my $xline = shift @expected_ortholog_lines;
# is($line, $xline);
# }
