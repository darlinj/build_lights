namespace :code do

  desc 'Runs all code quality checks'
  task :all => [:trailing_spaces, :debugger]

  desc 'check for trailing spaces'
  task :trailing_spaces do
    grep_for_trailing_space %w{config features lib public spec *.rb *.ru}, ['jquery-*.js']
  end

  desc 'check for debugger statements'
  task :debugger do
    grep_for_debugger %w{config features lib spec *.rb *.ru}, ['code_quality.rake']
  end

  def grep_for_trailing_space(file_patterns, exclude_patterns)
    grep '^.*[[:space:]]+$',
          file_patterns,
          'trailing spaces',
          exclude_patterns
  end

  def grep_for_debugger(file_patterns, exclude_patterns)
    grep  'debugger',
          file_patterns,
          'debugger statement found',
          exclude_patterns
  end

  def grep(regex, file_patterns, error_message, exclude_patterns=[], perl_regex=false)
    files_found = ""
    command = "grep -r -n --binary-files=without-match '#{regex}' #{file_patterns.join(' ')}"
    exclude_patterns.each do |exclude_pattern|
      command << " --exclude '#{exclude_pattern}'"
    end
    command << (perl_regex ? ' -P' : ' -E')
    files_found << `#{command}`
    abort("#{error_message} found:\n#{files_found}") unless files_found.empty?
  end
end
