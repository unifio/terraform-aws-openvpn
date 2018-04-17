#cloud-config
runcmd:
  - sleep 60
  - yum update -y
  - yum install jq -y
  - curl -s -O https://bootstrap.pypa.io/get-pip.py && python get-pip.py
  - /usr/local/bin/pip install awscli && ln -sf /usr/local/bin/aws /usr/bin/

  - export INSTANCE_ID=`curl http://169.254.169.254/latest/meta-data/instance-id`
  - docker pull ${openvpn_docker_image}:${openvpn_docker_tag}
  - mkdir -p /opt/openvpn
  - touch /opt/openvpn/.env && chmod 700 /opt/openvpn/.env
  - touch /opt/openvpn/server-append.conf && chmod 700 /opt/openvpn/server-append.conf
  - echo "OPENVPN_S3_PULL_CERTS=true" >> /opt/openvpn/.env
  - echo "OPENVPN_S3_CERT_PATH=${replace(s3_bucket,"/(/)+$/","")}/${replace(s3_bucket_prefix,"/^(/)+|(/)+$/","")}" >> /opt/openvpn/.env
  - if [ -n "${vpc_dns_ip}" ]; then echo "push \"dhcp-option DNS ${vpc_dns_ip}\"" >> /opt/openvpn/server-append.conf;fi
  - echo "push \"route $(ip route get 8.8.8.8| grep src| sed 's/.*src \(.*\)$/\1/g') 255.255.255.255 net_gateway\"" >> /opt/openvpn/server-append.conf
  - echo "push \"route ${cidrhost(element(split(",",route_cidrs),1), 0)}  ${cidrnetmask(element(split(",",route_cidrs),1))}\"" >> /opt/openvpn/server-append.conf
  - echo "push \"route ${cidrhost(element(split(",",route_cidrs),2), 0)}  ${cidrnetmask(element(split(",",route_cidrs),2))}\"" >> /opt/openvpn/server-append.conf
  - echo "push \"route ${cidrhost(element(split(",",route_cidrs),3), 0)}  ${cidrnetmask(element(split(",",route_cidrs),3))}\"" >> /opt/openvpn/server-append.conf
  - echo "push \"route ${cidrhost(element(split(",",route_cidrs),4), 0)}  ${cidrnetmask(element(split(",",route_cidrs),4))}\"" >> /opt/openvpn/server-append.conf
  - for route in `echo ${additional_routes} | tr ',' ' '`; do echo "push \"route $${route}  255.255.255.255\"" >> /opt/openvpn/server-append.conf;done

  - echo "OPENVPN_COMPRESS_ALGORITHM=lzo" >> /opt/openvpn/.env
  - echo "OPENVPN_KEY_DHSIZE=1024" >> /opt/openvpn/.env
  - echo "OPENVPN_TLS_ENABLE=false" >> /opt/openvpn/.env

  - docker run -d --name openvpn --env-file=/opt/openvpn/.env --cap-add=NET_ADMIN --device=/dev/net/tun -v /opt/openvpn/:/etc/openvpn/ -v /var/run/openvpn/:/var/run/openvpn -p 1194:1194/tcp ${openvpn_docker_image}:${openvpn_docker_tag} /start_server.sh
  - if [ ${assign_eip} = 'true' ]; then for eip in `aws ec2 describe-tags --region=${region} --filters  "Name=resource-type,Values=elastic-ip" "Name=value,Values=${stack_item_label}" | jq -r '.Tags[].ResourceId'`; do if [ `aws ec2 describe-addresses --allocation-id $${eip} --region=${region} | jq -r '.Addresses[].InstanceId'` = 'null' ]; then echo "$${eip} is available, assigning it to current instance";aws ec2 associate-address --instance-id "$${INSTANCE_ID}" --allocation-id $${eip} --region=${region};else echo "$${eip} is taken";fi; done;fi

output : { all : '| tee -a /var/log/cloud-init-output.log' }
