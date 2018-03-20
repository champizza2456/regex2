# Perl Regular Expression
# Created by Thanaboon Muangwong 57070503415
use File::Copy qw(mv);
use File::Path qw(make_path);
$dir = '/tmp/mp3/playlists/*.m3u';
@files = glob($dir);

foreach (@files){
		open(my $fh,"<",$_) or die "Can't open $_";
		my @lines = <$fh>;
    my @songs;
    $path = $lines[0];
    chomp $path;
    ($path2) = $path =~ m/\/(.+)\//g;
    $newdir = join "",$path2,"/files";
    $newdir =~ s/(cd-lib)\/mp3/music/;
    $newdir =~ s/_//g;
  	print "Song's new path: $newdir\n";
    foreach (@lines){
      ($songName) = $_ =~ m/[\w-]*\.mp3/g;
      chomp $_;
      $_ =~ s/cd-lib/tmp/g;
      $_ =~ s/LittleFeat/LittleFeet/g;
      push(@songs,$songName);
    }
    print "@songs";
    make_path($newdir,{error => \my $err});
    if(@$err){
      print "There is an error in creating directory\n"
    }
    ($playlistName) = $newdir =~ m/([^\/]*)\/files/g;
    ($playlistPath) = $newdir =~ m/.+(?=$playlistName)/g;
    $songPath = $lines[0];
    ($songY) = $songPath =~ m/\/(.+)\//g;
    print "song path: ",$songY,"\n";
    $playlistFileName = join "",$playlistPath,$playlistName,".m3u";
    print "m3u:",$playlistFileName,"\n";
  	open(my $fd, '>', $playlistFileName);
  	foreach (@songs){
      $songOldPath = join "",$songY,"/",$_;
      my $slash = "/";
      my $dot = ".";
      $dummy = join "",$slash,$songOldPath;
      $joindot = join "",$dot,$slash;
      print "$dummy\n";
      if(mv("$dummy","$newdir")){
        my $songline = join "",$joindot,$playlistName,"/files/",$_;
  			print $fd "$songline\n";
  			print "$songline added to playlist.\n";
      }
      else
      {
        print "Not Found.\nNot add to playlist\n";
      }
    }
    close $fd;
    print "Finish\n";
}
