#!/usr/bin/env crystal

def find_library(library : String) : String?
  if Process.find_executable "locate"
    IO.pipe do |r, w|
      Process.run "locate", ["-l1", "lib#{library}.a"], output: w
      w.close
      r.gets
    end
  else
    path = "/usr/lib/lib#{library}.a"
    return path if File.exists? path
    path = "/usr/local/lib/lib#{library}.a"
    return path if File.exists? path
    nil
  end
end

clang_target = `clang -v 2>&1`.each_line.find("") { |l| l =~ /^Target:/ }.split(/\s+/)[1]
clang_target.not_nil!
cc_cmd = IO.pipe do |r, w|
  puts "crystal build --release -o bin/git-cleanup-branch-darwin-x86_64 --cross-compile --target #{clang_target} bin/git-cleanup-branch.cr"
  Process.run "crystal", ["build", "--release", "-o", "bin/git-cleanup-branch-darwin-x86_64", "--cross-compile", "--target", clang_target, "bin/git-cleanup-branch.cr"], output: w
  w.close
  r.gets_to_end
end
cc_cmd = cc_cmd.gsub(/-l(\w+)/) { |s, m| find_library(m[1]) || s }
puts cc_cmd
system cc_cmd
