ENV['VAGRANT_APP_NAME']  ||= 'myapp'
ENV['VAGRANT_HOSTNAME']  ||= "#{ENV['VAGRANT_APP_NAME']}.dev"
ENV['VAGRANT_IP']        ||= '192.168.99.99'
ENV['VAGRANT_MEMORY_MB'] ||= '2024'
ENV['VAGRANT_CPUS']      ||= '1'

Vagrant.require_version '>= 1.5'

REQUIRED_PLUGINS = [
  ['vagrant-bindfs', '1.0.1'],
  ['vagrant-vbguest', '0.13.0'],
  ['vagrant-hostmanager', '1.8.5']
].freeze

def require_plugins!(plugins)
  plugins = plugins.reject { |p| Vagrant.has_plugin?(p.first) }
  plugins.each do |plugin, version|
    next if Vagrant.has_plugin?(plugin)
    system(install_plugin_command(plugin, version)) || exit!
  end
  exit system('vagrant', *ARGV) unless plugins.empty?
end

def install_plugin_command(plugin, version = nil)
  [].tap do |a|
    a << 'vagrant plugin install'
    a << plugin
    a << "--plugin-version #{version}" if version
  end.join(' ')
end

require_plugins!(REQUIRED_PLUGINS)

Vagrant.configure('2') do |config|
  config.vm.provider :virtualbox do |vb, _override|
    vb.memory = Integer(ENV['VAGRANT_MEMORY_MB'])
    vb.cpus = Integer(ENV['VAGRANT_CPUS'])
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
  end

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.synced_folder '.', "/var/#{ENV['VAGRANT_APP_NAME']}"
  config.bindfs.bind_folder "/var/#{ENV['VAGRANT_APP_NAME']}", "/#{ENV['VAGRANT_APP_NAME']}"

  config.vm.define ENV['VAGRANT_APP_NAME'] do |machine|
    config.vm.box = 'bento/ubuntu-16.04'
    machine.vm.hostname = ENV['VAGRANT_HOSTNAME']

    machine.vm.network 'forwarded_port', guest: 3000, host: 3000, auto_correct: true
    machine.vm.network 'forwarded_port', guest: 1080, host: 1080, auto_correct: true
    machine.vm.network 'forwarded_port', guest: 2812, host: 2812, auto_correct: true
    machine.vm.network 'private_network', ip: ENV['VAGRANT_IP']

    # Auxiliary domain names to create
    # machine.hostmanager.aliases = %W(
    #   admin.#{ENV['VAGRANT_HOSTNAME']}
    # )

    # Ansible will run [provisioning_path] playbook on the guest system
    machine.vm.provision :ansible_local do |ansible|
      ansible.verbose = true
      ansible.install = true
      ansible.version = '2.2'
      ansible.provisioning_path = "/#{ENV['VAGRANT_APP_NAME']}/ansible"
      ansible.limit = "all"
      ansible.playbook = 'provision.yml'
      ansible.inventory_path = 'inventory/development'
    end
  end

  config.ssh.forward_agent = true
end
