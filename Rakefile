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

    output = bindings_renderer(SDL3_BINDINGS_TEMPLATE_FILE).render(@macros_code, @cdecls_code)
    File.binwrite(SDL3_BINDINGS_OUTPUT_FILE, output)
  end
end

module BindingTemplateHelper
  def reindent_lines(s, last_line)
    indent = last_line.split($/).last.to_s[/\A\s*/]
    s.each_line.map { |l| l =~ /\S/ ? indent + l : $/ }.join
  end
end

def bindings_renderer(template_file)
  erb = ERB.new(File.binread(template_file))
  erb.filename = template_file
  klass = erb.def_class(Object, "render(macros_code, cdecls_code)")
  klass.include(BindingTemplateHelper)
  klass.new
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
    desc "Fetch and checkout the specified SDL release tag (detached HEAD)"
    task :checkout_tag, [:name] do |t,args|
      unless args[:name]
        raise "name is required, e.g. release-3.x.xx"
      end

      ensure_official_repo!(SDL_SRC_DIR, SDL_REPO_URL)

      checkout_tag(SDL_SRC_DIR, args[:name])
    end
  end
end

def ensure_official_repo!(src_dir, repo_url)
  unless File.exist?(src_dir)
    git_init(src_dir, repo_url)
    return
  end

  unless File.exist?(File.join(src_dir, ".git"))
    raise "SDL source directory is not a git repository (missing .git): #{src_dir}"
  end

  origin_url = git_origin_url(src_dir)
  unless origin_url == repo_url
    raise "SDL source directory origin URL mismatch: expected #{repo_url}, got #{origin_url} for #{src_dir}"
  end
end

def git_origin_url(src_dir)
  IO.popen(%W[git -C #{src_dir} remote get-url origin], &:read).chomp
end

def run(cmd)
  puts cmd.join(" ")
  system(*cmd, exception: true)
end

def git_init(dir, repo)
  if File.exist?(dir)
    raise "Target path already exists and will not be initialized: #{dir}"
  end

  begin
    run %W[git init #{dir}]
    run %W[git -C #{dir} remote add origin #{repo}]
    run %W[git -C #{dir} config remote.origin.promisor true]
    run %W[git -C #{dir} config core.partialCloneFilter blob:none]
    run %W[git -C #{dir} config advice.detachedHead false]
    run %W[git -C #{dir} sparse-checkout init --cone]
    run %W[git -C #{dir} sparse-checkout set include]
  rescue => git_error
    if File.directory?(dir)
      begin
        remove_entry_secure(dir)
      rescue => e
        warn "Cleanup failed for #{dir}: #{e.message}"
      end
    end
    raise git_error
  end
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
