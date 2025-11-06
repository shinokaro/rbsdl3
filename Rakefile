# frozen_string_literal: true

require "bundler/gem_tasks"
task default: %i[]

require "erb"
require "open3"
require "stringio"

DEFINE2RB_PATH = File.join(__dir__, "bin/define2rb")
C2FFIFIDDLE_PATH = File.join(__dir__, "bin/c2ffi2fiddle")

namespace :generate do
  desc "generate rb_sdl3/sdl3/bindings.rb"
  task :sdl3_bindings, [:header_dir] do |t, args|
    header_dir = args[:header_dir]
    c2ffi_json_path = File.join(__dir__, "tmp/sdl3.json")
    template_path = File.join(__dir__, "dev/template/sdl3_bindings.erb")
    bindings_path = File.join(__dir__, "lib/rb_sdl3/sdl3/bindings.rb")
    headers_manifest_path = File.join(__dir__, "dev/manifest/sdl_headers.list")
    header_paths = File.binread(headers_manifest_path).split($/).map { |basename|
      File.join(header_dir, basename)
    }

    buf = StringIO.new("".dup, "r+b")

    o, s = Open3.capture2("ruby", DEFINE2RB_PATH, *header_paths)
    unless s.success?
      raise "Generation failed: define2rb #{header_dir} (exitstatus=#{s.exitstatus})"
    end

    buf.puts ""
    buf.puts "# define2rb-translated macros from SDL headers"
    buf.puts "#"
    buf.puts o

    o, s = Open3.capture2("ruby", C2FFIFIDDLE_PATH, "--only-basename-prefix=SDL", c2ffi_json_path)
    unless s.success?
      raise "Generation failed: c2ffi2fiddle #{c2ffi_json_path} (exitstatus=#{s.exitstatus})"
    end

    buf.puts ""
    buf.puts "# c2ffi-generated C declarations from SDL headers"
    buf.puts "#"
    buf.puts o.lstrip!

    @dsl = buf.string
    output = ERB.new(File.binread(template_path), trim_mode: "-").result
    File.binwrite(bindings_path, output)
  end
end
