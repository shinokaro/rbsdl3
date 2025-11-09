# frozen_string_literal: true

require "bundler/gem_tasks"
task default: %i[]

require "erb"
require "open3"
require "stringio"

DEFINE2RB_PATH = File.join(__dir__, "bin/define2rb")
C2FFIFIDDLE_PATH = File.join(__dir__, "bin/c2ffi2fiddle")
C2FFI_BIN = File.expand_path("~/c2ffi/build/bin/c2ffi")

SDL_REPO_URL = "https://github.com/libsdl-org/SDL.git"
SDL_SRC_DIR = File.join(__dir__, "tmp", "SDL")
SDL_INCLUDE_DIR = File.join(SDL_SRC_DIR, "include")
SDL_AST_FILE = File.join(__dir__, "tmp", "sdl.json")

namespace :generate do
  desc "generate rb_sdl3/sdl3/bindings.rb"
  task :sdl3_bindings, [] do |t, args|
    header_dir = File.join(SDL_INCLUDE_DIR, "SDL3")
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

    o, s = Open3.capture2("ruby", C2FFIFIDDLE_PATH, "--only-basename-prefix=SDL", SDL_AST_FILE)
    unless s.success?
      raise "Generation failed: c2ffi2fiddle #{SDL_AST_FILE} (exitstatus=#{s.exitstatus})"
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

namespace :sources do
  namespace :sdl do
    desc "Initialize a sparse partial clone of SDL, restricting the working tree to include/ only"
    task :init, [] do |t, args|
      git_init(SDL_SRC_DIR, SDL_REPO_URL)
    end

    desc "Fetch and checkout the specified SDL release tag (detached HEAD)"
    task :checkout_tag, [:name] do |t,args|
      unless args[:name]
        raise "name is required, e.g. release-3.x.xx"
      end
      name = args[:name]

      checkout_tag(SDL_SRC_DIR, name)
    end
  end
end

def run(cmd)
  puts cmd.join(" ")
  system(*cmd, exception: true)
end

def git_init(dir, repo)
  run %W[git init #{dir}]
  run %W[git -C #{dir} remote add origin #{repo}]
  run %W[git -C #{dir} config remote.origin.promisor true]
  run %W[git -C #{dir} config core.partialCloneFilter blob:none]
  run %W[git -C #{dir} config advice.detachedHead false]
  run %W[git -C #{dir} sparse-checkout init --cone]
  run %W[git -C #{dir} sparse-checkout set include]
end

def checkout_tag(dir, name)
  run %W[git -C #{dir} fetch --depth 1 origin tag #{name}]
  run %W[git -C #{dir} checkout -f #{name}]
end

namespace :c2ffi_ast do
  desc "Generate C2FFI AST (JSON) from SDL headers (root: SDL3/SDL.h) into tmp/sdl.json"
  task :sdl, [] do |t, args|
    root_header = File.join(SDL_INCLUDE_DIR, "SDL3", "SDL.h")
    extract_ast(root_header, [SDL_INCLUDE_DIR], SDL_AST_FILE)
  end
end

def extract_ast(root_header, sys_includes = [], output = nil)
  cmd = [C2FFI_BIN]
  cmd += sys_includes.flat_map { |dir| ["-i", dir] }
  cmd += ["-o", output] if output
  cmd << root_header
  run cmd
end
