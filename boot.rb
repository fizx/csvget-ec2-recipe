#!/usr/bin/env ruby
def die(s);STDERR.puts(s);exit(1);end
def p(s);print(s);STDOUT.flush;end
def sys(s);puts(s);system(s);end

if ARGV.length != 2
  die "Usage: #{$0} KEYPAIR_NAME SSH_KEYPAIR_FILE"
end
key_name, key_path = ARGV

puts "Booting instance..."
instance = `ec2run -k #{key_name} ami-ff46a796`[/\bi-\w+\b/]
die("No instance") unless instance
p "Waiting for instance..."

booted = nil
until booted
  p "."
  lines = `ec2-describe-instances`
  booted = lines.find{|line| line =~ /#{instance}.*running/  }
  sleep 1
end
host = booted[/[\w\-\.]+amazonaws\.com/]

sys "scp -o StrictHostKeyChecking=no -i #{key_path} init.sh root@#{host}:~"
sys "ssh -o StrictHostKeyChecking=no -i #{key_path} root@#{host} 'sh init.sh'"
