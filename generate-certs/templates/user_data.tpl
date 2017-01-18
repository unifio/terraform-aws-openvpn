#cloud-config
manage_etc_hosts: True

runcmd:
  - echo "S3_REGION=\"${region}\"" > /etc/default/openvpn-cert-generator
  - echo "S3_CERT_ROOT_PATH=\"s3://${replace(s3_bucket,"/(/)+$/","")}/\"" >> /etc/default/openvpn-cert-generator
  - echo "KEY_SIZE=${cert_key_size}" >> /etc/default/openvpn-cert-generator
  - echo "S3_DIR_OVERRIDE=\"${replace(s3_dir_override,"/^(/)+|(/)+$/","")}\"" >> /etc/default/openvpn-cert-generator
  - echo "KEY_CITY=\"${key_city}\"" >> /etc/default/openvpn-cert-generator
  - echo "KEY_ORG=\"${key_org}\"" >> /etc/default/openvpn-cert-generator
  - echo "KEY_EMAIL=\"${key_email}\"" >> /etc/default/openvpn-cert-generator
  - echo "KEY_OU=\"${key_ou}\"" >> /etc/default/openvpn-cert-generator
  - echo "KEY_NAME=\"${cert_key_name}\"" >> /etc/default/openvpn-cert-generator
  - echo "KEY_COUNTRY=\"${key_country}\"" >> /etc/default/openvpn-cert-generator
  - echo "KEY_PROVINCE=\"${key_province}\"" >> /etc/default/openvpn-cert-generator
  - echo "ACTIVE_CLIENTS=\"${active_clients}\"" >> /etc/default/openvpn-cert-generator
  - echo "REVOKED_CLIENTS=\"${revoked_clients}\"" >> /etc/default/openvpn-cert-generator
  - echo "OPENVPN_HOST=\"${openvpn_host}\"" >> /etc/default/openvpn-cert-generator
  - echo "FORCE_CERT_REGEN=${force_cert_regen}" >> /etc/default/openvpn-cert-generator
  - echo "S3_PUSH_DRYRUN=${s3_push_dryrun}" >> /etc/default/openvpn-cert-generator

  - systemctl start openvpn-cert-generator.service

output : { all : '| tee -a /var/log/cloud-init-output.log' }
