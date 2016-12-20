require_relative '../../app/services/secrets_vault'

namespace :secrets do
  desc "Encrypt allication.yml"
  task :encrypt do
    SecretsVault.encrypt
  end

  desc "Decrypt allication.yml"
  task :decrypt do
    SecretsVault.decrypt
  end
end
