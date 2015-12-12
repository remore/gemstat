desc 'build gem with the preprocessing in place'
task :build do
  gems = [
    "ivyxxcspcqlaocvjbghawvbdartwsfffurhnqzlwvsbgieweawfntuwecdcminmiaunqteqgbrfuxppntjdvyvsswxwepnbfqstnrnsotrhndihkudyahthaxatviwrwtgllwbqhibouqctrxtypac"
  ]
  gems.each do |gem|
    system "find #{File.dirname(__FILE__)}/bin/gemfiles/#{gem[0]} | grep #{gem} | xargs git rm"
    system "git commit -m ''"
    system "find #{File.dirname(__FILE__)}/bin/gemfiles/#{gem[0]} | grep #{gem} | xargs rm -rf"
  end
  system "gem build gemstat.gemspec"
end
