# frozen_string_literal: true

require "bundler/gem_tasks"
task default: %i[]

require "erb"
require "open3"

TEMP_DIR = File.join(__dir__, "tmp")
DEV_DIR = File.join(__dir__, "dev")
MANIFEST_DIR = File.join(DEV_DIR, "manifest")
TEMPLATE_DIR = File.join(DEV_DIR, "template")
RBSDL3_LIB_DIR = File.join(__dir__, "lib", "rb_sdl3")

DEFINE2RB_BIN = File.join(__dir__, "bin/define2rb")
C2FFIFIDDLE_BIN = File.join(__dir__, "bin/c2ffi2fiddle")
C2FFI_BIN = File.expand_path("~/c2ffi/build/bin/c2ffi")

SDL_SPECS = {
  SDL: { include_subdir: "SDL3", bindings_subdir: "sdl3" },
}

def repo_url(name) = "https://github.com/libsdl-org/#{name}.git"
def src_dir(name) = File.join(TEMP_DIR, name)
def ast_file(name) = File.join(TEMP_DIR, "#{name}.json")
def include_dir(name) = File.join(src_dir(name), "include")
def headers_dir(name) = File.join(include_dir(name), SDL_SPECS.fetch(name.to_sym)[:include_subdir])
def root_header_file(name) = File.join(headers_dir(name), "#{name}.h")
def headers_manifest_file(name) = File.join(MANIFEST_DIR, SDL_SPECS.fetch(name.to_sym)[:bindings_subdir], "headers.list")
def bindings_template_file(name) = File.join(TEMPLATE_DIR, SDL_SPECS.fetch(name.to_sym)[:bindings_subdir], "bindings.erb")
def bindings_rb_file(name) = File.join(RBSDL3_LIB_DIR, SDL_SPECS.fetch(name.to_sym)[:bindings_subdir], "bindings.rb")

namespace :generate do
  desc "generate rb_sdl3/sdl3/bindings.rb"
  task :sdl3_bindings, [] do |t, args|
    spec_name = "SDL"
    @macros_code = generate_macros_code(headers_dir(spec_name), headers_manifest_file(spec_name))
    @cdecls_code = generate_cdecls_code(ast_file(spec_name), headers_dir(spec_name))

    output = bindings_renderer(bindings_template_file(spec_name)).render(@macros_code, @cdecls_code)
    File.binwrite(bindings_rb_file(spec_name), output)
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

def generate_cdecls_code(ast_json_path, source)
  o, s = Open3.capture2("ruby", C2FFIFIDDLE_BIN, "--source=#{source}", ast_json_path)
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

      spec_name = "SDL"
      src = src_dir(spec_name)
      ensure_official_repo!(src, repo_url(spec_name))

      checkout_tag(src, args[:name])
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
    spec_name = "SDL"
    extract_ast(root_header_file(spec_name), [include_dir(spec_name)], ast_file(spec_name))
  end
end

def extract_ast(root_header, sys_includes = [], output = nil)
  cmd = [C2FFI_BIN]
  cmd += sys_includes.flat_map { |dir| ["-i", dir] }
  cmd += ["-o", output] if output
  cmd << root_header
  run cmd
end
