# frozen_string_literal: true

require "bundler/gem_tasks"
task default: %i[]

require "erb"
require "open3"

DEFINE2RB_BIN = File.join(__dir__, "bin/define2rb")
C2FFIFIDDLE_BIN = File.join(__dir__, "bin/c2ffi2fiddle")
C2FFI_BIN = File.expand_path("~/c2ffi/build/bin/c2ffi")

SDL_REPO_URL = "https://github.com/libsdl-org/SDL.git"
SDL_SRC_DIR = File.join(__dir__, "tmp", "SDL")
SDL_INCLUDE_DIR = File.join(SDL_SRC_DIR, "include")
SDL_AST_FILE = File.join(__dir__, "tmp", "sdl.json")
SDL_HEADERS_DIR = File.join(SDL_INCLUDE_DIR, "SDL3")
SDL_HEADERS_MANIFEST_FILE = File.join(__dir__, "dev/manifest/sdl_headers.list")
SDL3_BINDINGS_TEMPLATE_FILE = File.join(__dir__, "dev/template/sdl3_bindings.erb")
SDL3_BINDINGS_OUTPUT_FILE = File.join(__dir__, "lib/rb_sdl3/sdl3/bindings.rb")

namespace :generate do
  desc "generate rb_sdl3/sdl3/bindings.rb"
  task :sdl3_bindings, [] do |t, args|
    @macros_code = generate_macros_code(SDL_HEADERS_DIR, SDL_HEADERS_MANIFEST_FILE)
    @cdecls_code = generate_cdecls_code(SDL_AST_FILE, "SDL_")

    erb = ERB.new(File.binread(SDL3_BINDINGS_TEMPLATE_FILE))
    erb.filename = SDL3_BINDINGS_TEMPLATE_FILE
    output = erb.result
    File.binwrite(SDL3_BINDINGS_OUTPUT_FILE, output)
  end
end

def generate_macros_code(header_dir, manifest_file)
  header_files = File.foreach(manifest_file, chomp: true).map { |basename|
    File.join(header_dir, basename)
  }
  o, s = Open3.capture2("ruby", DEFINE2RB_BIN, *header_files)
  unless s.success?
    raise "Generation failed: define2rb #{header_dir} (exitstatus=#{s.exitstatus})"
  end
  o
end

def generate_cdecls_code(ast_json_path, prefix)
  o, s = Open3.capture2("ruby", C2FFIFIDDLE_BIN, "--only-basename-prefix=#{prefix}", ast_json_path)
  unless s.success?
    raise "Generation failed: c2ffi2fiddle #{ast_json_path} (exitstatus=#{s.exitstatus})"
  end
  o.lstrip!
  o
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
