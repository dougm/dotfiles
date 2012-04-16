require "resolv"

opts :vcenter do
  summary "Connect to bosh vCenter"
  arg :name, "bosh instance name"
end

def vcenter name
  deployments = ENV['CF_DEPLOYMENTS'] || "#{ENV['HOME']}/cf/deployments"
  yml = ["micro_bosh.yml", "cloud/assets/director/director.yml.erb"].map {|f|
    File.join(deployments, name, f)
  }.select {|path| File.exists?(path)}.first
  config = YAML.load(File.read(yml))['cloud']['properties']['vcenters'].first
  begin
    host = Resolv.new.getname(config['host'])
  rescue
    host = config['host']
  end
  dc = config['datacenters'].first
  unless $shell.connections[host]
    ENV['RBVMOMI_PASSWORD'] = config['password']
    CMD.vim.connect "#{config['user']}@#{host}", {}
  end
  cluster_path = File.join("", host, dc['name'], "computers", dc['clusters'].first)
  CMD.basic.cd RVC::Util.lookup_single(cluster_path)
ensure
  ENV['RBVMOMI_PASSWORD'] = nil
end
