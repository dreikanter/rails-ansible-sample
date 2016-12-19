# Provisioning automation for Rails

## Wishlist

- Ansible playbook for provisioning Rails app servers
- Compatibility with Vagrant
- Ubuntu 16.04
- Install:
  - Postgres
  - Redis
  - ElasticSearch
  - Ruby (from sources or prebuilt binaries)
  - Rails apps
  - Sidekiq
  - nginx
  - nodejs
  - Systemd configuration


## Distributing pre-built Ruby binaries

Assuming (1) this is Linux machine with installed ruby-install, (2) bucket name to upload binaries is `rubies-stash`, and (3) AWS CLI is properly configured:

``` bash
cd
ruby-install --install-dir ~/.rubies/2.3.3 --cleanup ruby 2.3.3 -- --disable-install-rdoc
tar -zcvf 2.3.3.tar.gz -C ~/ 2.3.3
aws s3 cp 2.3.3.tar.gz s3://rubies-stash
```
