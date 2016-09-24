require 'rake'

inputs = {
  'stack_item_label'    => 'expl-tst',
  'stack_item_fullname' => 'Example Stack',
  'vpc_id'              => 'vpc-xxxxxx',
  'region'              => 'us-east-1',
  'subnets'             => 'subnet-111111,subnet-222222',
  'instance_type'       => 't2.small',
  'key_name'            => 'example',
  'route_cidrs'         => '10.10.0.0/25,10.10.0.128/25,10.10.4.0/25,10.10.4.128/25',
  's3_bucket'           => 'openvpn-certs',
  's3_bucket_prefix'    => '20160603',
  'openvpn_host'        => 'vpn.example.io'
}

task :default => :verify

desc "Verify the stack"
task :verify do

  vars = []
  inputs.each() do |var, value|
    vars.push("-var '#{var}=\"#{value}\"'")
  end

  ['server','cert-gen'].each do |stack|
    task_args = {:stack => stack, :args => vars.join(' ')}
    Rake::Task['clean'].execute(Rake::TaskArguments.new(task_args.keys, task_args.values))
    Rake::Task['plan'].execute(Rake::TaskArguments.new(task_args.keys, task_args.values))
  end
end

desc "Remove existing local state if present"
task :clean, [:stack] do |t, args|
  sh "cd examples/#{args['stack']} && rm -fr .terraform *.tfstate*"
end

desc "Create execution plan"
task :plan, [:stack, :args] do |t, args|
  sh "cd examples/#{args['stack']} && terraform get && terraform plan -module-depth=-1 -input=false #{args['args']}"
end
