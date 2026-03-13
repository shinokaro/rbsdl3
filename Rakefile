# frozen_string_literal: true

require "bundler/gem_tasks"
task default: %i[]

require "erb"

TEMP_DIR = File.join(__dir__, "tmp")
MANIFEST_DIR = File.join(__dir__, "manifest")
TEMPLATE_DIR = File.join(__dir__, "template")
LIB_DIR = File.join(__dir__, "lib")

C2FFI_BIN = File.expand_path("~/c2ffi/build/bin/c2ffi")

SDL_SPECS = {
  sdl: {
    name_suffix: "", rb_name: "sdl"
  }.freeze,
  sdl_image: {
    name_suffix: "_image", rb_name: "image"
  }.freeze,
  sdl_mixer: {
    name_suffix: "_mixer", rb_name: "mixer",
  }.freeze,
  sdl_ttf: {
    name_suffix: "_ttf", rb_name: "ttf", root_header_file: "SDL_textengine.h"
  }.freeze,
}.freeze

class SDLSpec
  attr_reader :spec
  private :spec

  def initialize(key)
    @spec = SDL_SPECS.fetch(key.to_sym)
  end

  def suffix = spec.fetch(:name_suffix)
  def lib_name        = "SDL#{suffix}"
  def include_subdir  = "SDL3#{suffix}"
  def module_name     = "SDL#{suffix}"

  def repo_url = "https://github.com/libsdl-org/#{lib_name}.git"
  def src_dir = File.join(TEMP_DIR, lib_name)
  def ast_file = File.join(TEMP_DIR, "#{lib_name}.json")
  def include_dir = File.join(src_dir, "include")
  def headers_dir = File.join(include_dir, include_subdir)
  def root_header_file = File.join(headers_dir, spec[:root_header_file] || "#{lib_name}.h")
  def headers_manifest_file = File.join(MANIFEST_DIR, "#{lib_name}_headers")

  def module_filename = spec.fetch(:rb_name)
  def bindings_relpath = File.join("rbsdl3", module_filename)
  def bindings_template_file = File.join(TEMPLATE_DIR, "bindings.rb.erb")
  def bindings_manual_code_file = File.join(TEMPLATE_DIR, "#{bindings_relpath}.rb")
  def bindings_rb_file = File.join(LIB_DIR, "#{bindings_relpath}.rb")
end

namespace :bindings do
  namespace :generate do
    SDL_SPECS.keys.each { |name|
      spec = SDLSpec.new(name)
      desc "Generate Ruby bindings: lib/#{spec.bindings_relpath}.rb"
      task name do
        bindings_erb = bindings_renderer(spec.bindings_template_file)
        bindings_erb.instance_eval {
          @lib_name = spec.lib_name
          @module_name = spec.module_name
          manual_code_file = spec.bindings_manual_code_file
          if File.exist?(manual_code_file)
            @manual_code = File.binread(manual_code_file)
          end
          @macros_code = generate_macros_code(spec.headers_dir, spec.headers_manifest_file)
          @cdecls_code = generate_cdecls_code(spec.ast_file, spec.headers_dir)
        }
        module_path = spec.bindings_rb_file
        mkdir_p(File.dirname(module_path))
        File.binwrite(module_path, bindings_erb.render)
      end
      task name => "ast:generate:#{name}"
    }

    desc "Generate Ruby bindings for all SDL specs (runs ast:generate:* as prerequisites)"
    task :all => SDL_SPECS.keys
  end
end

module BindingTemplateHelper
  def reindent_lines(s, last_line)
    indent = last_line.split($/).last.to_s[/\A\s*/]
    s.each_line.map { |l| l =~ /\S/ ? indent + l : $/ }.join
  end
end

def bindings_renderer(template_file)
  erb = ERB.new(File.binread(template_file), trim_mode: "-")
  erb.filename = template_file
  klass = erb.def_class(Object, "render()")
  klass.include(BindingTemplateHelper)
  klass.new
end

def generate_macros_code(header_dir, manifest_file)
  require_relative "rakelib/define2rb"
  out = "".dup
  File.foreach(manifest_file, chomp: true).each { |basename|
    path = File.join(header_dir, basename)
    src = File.binread(path)
    rb = Define2Rb.src2rb(src)
    (out << rb << $/) unless rb.empty?
  }
  out
end

def generate_cdecls_code(ast_json_path, source)
  require "prettyprint"
  require_relative "rakelib/ast2rb"

  out = "".dup
  classifier = AST2Rb::EntryClassifier.new(source)
  PrettyPrint.format(out) { |q|
    ee = AST2Rb::EntryEmitter.new(q, classifier)
    AST2Rb.load_file(ast_json_path).each { |entry|
      ee.emit_entry(entry)
    }
  }
  out.lstrip!
  out
end

namespace :sources do
  namespace :checkout do
    SDL_SPECS.keys.each { |name|
      spec = SDLSpec.new(name)
      desc "Fetch and checkout #{spec.lib_name} release tag (default: latest; detached HEAD)"
      task name, [:tag] do |t, args|
        src_dir = spec.src_dir
        ensure_official_repo!(src_dir, spec.repo_url)

        tag = args[:tag] || resolve_latest_release_tag(src_dir)
        unless tag
          raise "tag is required, e.g. release-3.x.xx"
        end
        checkout_tag(src_dir, tag)
      end
    }

    desc "Fetch and checkout latest release tags for all SDL specs (detached HEAD)"
    task :all => SDL_SPECS.keys
  end
end

def resolve_latest_release_tag(dir)
  cmd = %W[git -C #{dir} ls-remote --tags --refs origin refs/tags/release-3.*]
  IO.popen(cmd) do |ls|
    ls.readlines(chomp: true).filter_map { |line|
      next unless line in /\/(release-(\d+\.\d+\.\d+))\z/
      [Gem::Version.new($2), $1]
    }.max_by(&:first)&.last
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

def checkout_tag(dir, tag)
  unless system(*%W[git -C #{dir} show-ref --tags --verify refs/tags/#{tag}])
    run %W[git -C #{dir} fetch --depth 1 origin tag #{tag}]
  end

  run %W[git -C #{dir} checkout -f tags/#{tag}]
end

namespace :ast do
  namespace :generate do
    SDL_SPECS.keys.each { |name|
      spec = SDLSpec.new(name)
      desc "Generate C2FFI AST (JSON) from #{spec.lib_name} headers into tmp/#{spec.lib_name}.json"
      task name do
        extract_ast(spec.root_header_file, [spec.include_dir], spec.ast_file)
      end
    }
  end
end

def extract_ast(root_header, sys_includes = [], output = nil)
  cmd = [C2FFI_BIN]
  cmd += sys_includes.flat_map { |dir| ["-i", dir] }
  cmd += ["-o", output] if output
  cmd << root_header
  run cmd
end
