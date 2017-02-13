#cloud-config
## The sed and daemon-reload entries are temporary and will be removed once permission issue is handled on base AMI.
## https://github.com/WhistleLabs/terraform-aws-openvpn/pull/2
runcmd:
  - echo "OPENVPN_CERT_SOURCE=s3://${replace(s3_bucket,"/(/)+$/","")}/${replace(s3_bucket_prefix,"/^(/)+|(/)+$/","")}" > /etc/openvpn/get-openvpn-certs.env
  - echo "push \"route $(ip route get 8.8.8.8| grep src| sed 's/.*src \(.*\)$/\1/g') 255.255.255.255 net_gateway\"" >> /etc/openvpn/server.conf
  - echo "push \"route ${cidrhost(element(split(",",route_cidrs),1), 0)}  ${cidrnetmask(element(split(",",route_cidrs),1))}\"" >> /etc/openvpn/server.conf
  - echo "push \"route ${cidrhost(element(split(",",route_cidrs),2), 0)}  ${cidrnetmask(element(split(",",route_cidrs),2))}\"" >> /etc/openvpn/server.conf
  - echo "push \"route ${cidrhost(element(split(",",route_cidrs),3), 0)}  ${cidrnetmask(element(split(",",route_cidrs),3))}\"" >> /etc/openvpn/server.conf
  - echo "push \"route ${cidrhost(element(split(",",route_cidrs),4), 0)}  ${cidrnetmask(element(split(",",route_cidrs),4))}\"" >> /etc/openvpn/server.conf
  - sed -i 's/\(ExecStartPost=.*chmod.*$\)/ExecStartPost=\/bin\/chown -R nobody:nogroup \/etc\/openvpn\n\1\n/g' /etc/systemd/system/get-openvpn-certs.service
  - systemctl daemon-reload
  - systemctl start get-openvpn-certs
  - systemctl restart openvpn@server
  - systemctl restart iptables

output : { all : '| tee -a /var/log/cloud-init-output.log' }
