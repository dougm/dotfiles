# RVC plugins

Plugins for [Ruby vSphere Client](https://github.com/vmware/rvc)

## bosh.vcenter

Connect to vCenter instances by [BOSH](https://github.com/cloudfoundry/bosh) deployment name.

This plugin command uses vCenter properties from both BOSH and Micro BOSH
[deployment manifests](https://github.com/cloudfoundry/oss-docs/tree/master/bosh)
to connect to vCenter via RVC.  The bosh.vcenter command will connect to vCenter
and cd to datacenter/cluster/pool/vms.

Example:

        > bosh.vcenter dev179
        /cf-dev179.x.x.x/LAS01/computers/CLUSTER14/resourcePool/pools/Dev179/vms> ls
        0 sc-dff4843d-9077-47f5-bab7-6d94c1b9d657: poweredOff
        ...
        8 vm-4ec48ee1-acb8-4997-a857-e8d9c33786c8: poweredOn
        9 vm-dac12047-094b-486c-b61e-ee10a1e1d453: poweredOn
        10 vm-3c3e9be8-34a8-497c-a812-dac0c6f77988: poweredOn
        ...

The plugin can also be used to start RVC itself with vCenter connection using a
BOSH deployment name.  Example:

        $ ruby ~/.rvc/bosh.rb dev179
