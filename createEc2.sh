#!/bin/bash
#she bang will execute sript in  Linux

instance=("mongodb" "catalog" "mysql" "rabbitMq" "catalogue" "user" "cart" "shipping" "payment" "web")
domain_name="daws93.online"
hosted-zone-id="Z09537313IGF7OTO5RVXH"
for name in ${instance[@]}; do
    
    if [ $name == "shipping" ] || [ $name == "mysql" ]
    then
        instance_type="t3.medium"
    else
        instance_type="t3.micro"
    fi
    echo "creating instance for: $name with instancetype: $instance_type"
    instance_id=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type  $instance_type --security-group-ids sg-0d185c7bed4d71abf --subnet-id subnet-0c4b9afbef22588bd --query 'Instances[0].InstancId[]' --output text)
    echo "Instance created for:$name"
    
     aws ec2 create-tags --resources $instance_id --tags Key=Name,Value=$name

    if [ $name == "web" ]
    then
         aws ec2 wait instance-running --instance-ids $instance_id
    public_ip= $(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[0].Instances[0].[PublicIpAddress]' --output text)
    ip_to_use=$public_ip
    else
    Private_ip= $(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[0].Instances[0].[PrivateIpAddress]' --output text)
    ip_to_use=$private_ip
    fi
          echo "creating R53 record for $name"
    aws route53 change-resource-record-sets --hosted-zone-id $hosted_zone_id --change-batch '
    {
        "Comment": "Creating a record set for '$name'"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$name.$domain_name'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$ip_to_use'"
            }]
        }
        }]
    }'
    
done



