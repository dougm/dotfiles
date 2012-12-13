require "yaml"
require "resolv"

def vcenter_config name
  deployments = ENV["CF_DEPLOYMENTS"] || "#{ENV["HOME"]}/cf/deployments"

  yml = ["bosh.yml", "micro_bosh.yml"].map {|f|
    File.join(deployments, name, f)
  }.select {|path| File.exists?(path)}.first

  config = YAML.load(File.read(yml))

  if File.basename(yml) == "bosh.yml"
    config = config["properties"]["vcenter"]
  else
    config = config["cloud"]["properties"]["vcenters"].first
  end

  ENV["RBVMOMI_PASSWORD"] = config["password"]
  ENV["RBVMOMI_USER"] = config["user"]

  config
end

def vcenter_host config
  address = config["address"] || config["host"]
  Resolv.new.getname(address)
rescue
  address
end

def vcenter name
  config = vcenter_config(name)
  host = vcenter_host(config)

  unless $shell.connections[host]
    $shell.cmds.vim.connect host, {}
  end

  dc = config["datacenters"].first
  cluster = dc["clusters"].first
  cluster_name = cluster.keys.first
  cluster_path = File.join("", host, dc["name"], "computers", cluster_name)
  if pool = cluster[cluster_name]["resource_pool"]
    cluster_path = File.join(cluster_path, "resourcePool", "pools", pool, "vms")
  end

  $shell.cmds.basic.cd $shell.fs.lookup_single(cluster_path)
end

if __FILE__ == $0
  config = vcenter_config(ARGV[0])

  exec "rvc", vcenter_host(config)
else
  opts :vcenter do
    summary "Connect to bosh vCenter"
    arg :name, "bosh instance name"
  end
end
