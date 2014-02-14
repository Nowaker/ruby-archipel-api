# Archipel API

Ruby API for Archipel Agent, an XMPP-based orchestrator. See [http://archipelproject.org/](http://archipelproject.org/).

This gem is brought to you by [PacmanVPS](https://www.pacmanvps.com), an Arch Linux VPS hosting provider.
You can use it to manage your PacmanVPS-hosted virtual machines.

## Installation

Add this line to your application's Gemfile:

    :::ruby
    gem 'archipel-api'

Then execute:

    $ bundle

## Usage

Authenticate any time you instantiate an API object:

    :::ruby
    vm = Archipel::VmApi.new login: 'login@xmpp.example.com',
        password: 'secret', server: 'xmpp.example.com',

    hypervisor = Archipel::HypervisorApi.new login: 'login@xmpp.example.com',
        password: 'secret', server: 'xmpp.example.com',
        hypervisor: 'hypervisor@xmpp.pacmanvps.com/resource'

Or provide global settings:

    :::ruby
    Archipel.defaults login: 'login@xmpp.example.com',
        password: 'secret', server: 'xmpp.example.com',
        hypervisor: 'hypervisor@xmpp.pacmanvps.com/resource'

    vm = Archipel::VmApi.new
    hypervisor = Archipel::HypervisorApi.new

### VmApi

Both regular users and administrators are interested in `VmApi` only to manage their virtual machines.

- start

- create_disk
- list_disks
- remove_disk

- grant_permissions
- revoke_permissions
- subscribe - make VM subscribe to a given user so VM appears in user's roster (if they are granted permissions)

- define_vm - apply the XML, equivalent of clicking "Validate" in Definition tab of Archipel web UI
- xml - retrieve an XML representation of VM

See [unit tests](https://bitbucket.org/stratushost/ruby-archipel-api/src/master/spec/units/vm_api_spec.rb?at=master)
for usage examples.

### HypervisorApi

Administrators are also interested in `HypervisorApi` which allows to create new VMs, remove them, etc.

If you don't know what your hypervisor name is, see `/etc/archipel/archipel.conf`.

Hypervisor should always contain a resource, e.g. `name@server/resource`:

- `name` - get from `hypervisor_xmpp_jid` in `[HYPERVISOR]`
- `server` - get from `xmpp_server` in `[DEFAULT]`
- `resource` - get from `hypervisor_name` in `[HYPERVISOR]`; if it's `auto`, the server's hostname is used - call `hostname` to get it

Supported calls:

- register_user
- list_users
- unregister_user

- create_vm
- list_vm
- delete_vm

- grant_permissions

See [unit tests](https://bitbucket.org/stratushost/ruby-archipel-api/src/master/spec/units/hypervisor_api_spec.rb?at=master)
for usage examples.

## Future plans

We are planning to provide command line wrapper for use in your shell.

Current version doesn't connects and disconnects any time you perform an action.
This approach is not suitable if you want to perform lots of different tasks in one go.

Bugs are listed in the [issue tracker](https://bitbucket.org/stratushost/ruby-archipel-api/issues?status=new&status=open).

## Contributing

1. Fork it (`https://bitbucket.org/stratushost/ruby-archipel-api/fork`)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. [Create a pull request](https://bitbucket.org/stratushost/ruby-archipel-api/pull-requests)
6. Include this text in the description: `The code is licensed under MIT.`
7. Thanks!

## License

Copyright (c) 2014 StratusHost Damian Nowak

Licensed under [MIT](https://bitbucket.org/stratushost/ruby-archipel-api/src/ba6789b5d88c9604808dadcc2f1a9a41eb866434/LICENSE.txt?at=master).
