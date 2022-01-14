require 'open3'

LOGFILE = '/tmp/bootstrap.log'

def log_s(s)
  open(LOGFILE, 'a') { |f| f << s + "\n" }
end

def log_exec(cmd)
  stdout, stderr, status = Open3.capture3 cmd

  log_s "$ #{cmd}"
  log_s stdout
  log_s stderr

  return status
end

def log_exec_fail(cmd)
  if not log_exec(cmd).success?
    puts "Error while executing `#{cmd}`"
    puts "See #{LOGFILE} for details"
    exit 1
  end
end
