#!/bin/bash
#she bang will execute sript in  Linux

instance=("mongodb" "catalog" "mysql" "rabbitMq" "catalogue" "user" "cart" "shipping" "payment" "web")


for name in ${instance[@]}; do
    
    if [ $name == "shipping" ] || [ $name == "mysql" ]
    then
        instance_type="t3.medium"
    else
        instance_type="t3.micro"
    fi
    echo "creating instance for: $name with instancetype: $instance_type"
done



