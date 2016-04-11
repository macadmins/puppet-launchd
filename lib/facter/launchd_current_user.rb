#launchd_current_user.rb
Facter.add(:launchd_current_user) do
  confine :kernel => "Darwin"
  setcode do
    Facter::Util::Resolution.exec("/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,\"\"][username in [u\"loginwindow\", None, u\"\"]]; sys.stdout.write(username);'")
  end
end
