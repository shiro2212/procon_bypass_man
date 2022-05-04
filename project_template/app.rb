#!/usr/bin/env ruby

require 'bundler/inline'

begin
  gemfile do
    source 'https://rubygems.org'
    git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }
    gem 'procon_bypass_man', '0.1.23'
  end
rescue Bundler::Source::Git::GitCommandError => e
  # install中に強制終了するとgitの管理ファイルが不正状態になり、次のエラーが起きるので発生したらcache directoryを削除する
  #"Git error: command `git fetch --force --quiet --tags https://github.com/splaplapla/procon_bypass_man refs/heads/\\*:refs/heads/\\*` in directory /home/pi/.rbenv/versions/3.0.1/lib/ruby/gems/3.0.0/cache/bundler/git/procon_bypass_man-ae4c9016d76b667658c8ba66f3bbd2eebf2656af has failed.\n\nIf this error persists you could try removing the cache directory '/home/pi/.rbenv/versions/3.0.1/lib/ruby/gems/3.0.0/cache/bundler/git/procon_bypass_man-ae4c9016d76b667658c8ba66f3bbd2eebf2656af'"
  if /try removing the cache directory '([^']+)'/ =~ e.message
    FileUtils.rm_rf($1)
    retry
  end
end

ProconBypassMan.configure do |config|
  config.root = File.expand_path(__dir__)
  config.logger = Logger.new("#{ProconBypassMan.root}/app.log", 5, 1024 * 1024 * 10)
  config.logger.level = :debug

  # バイパスするログを全部app.logに流すか
  config.verbose_bypass_log = false

  # webからProconBypassManを操作できるwebサービス
  # config.api_servers = ['https://pbm-cloud.herokuapp.com']

  # エラーが起きたらerror.logに書き込みます
  config.enable_critical_error_logging = true

  # pbm-cloudで使う場合はnever_exitにtrueをセットしてください. trueがセットされている場合、不慮の事故が発生してもプロセスが終了しなくなります
  config.never_exit_accidentally = true

  # 操作が高頻度で固まるときは、 gadget_to_procon_interval の数値は大きくしてください
  config.bypass_mode = { mode: :normal, gadget_to_procon_interval: 5 }
end

ProconBypassMan.run(setting_path: "/usr/share/pbm/current/setting.yml")
