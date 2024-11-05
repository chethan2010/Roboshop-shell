#!/bin/bash
#she bang will execute sript in  Linux

instance=("mongodb" "catalog" "mysql" "rabbitMq" "catalogue" "user" "cart" "shipping" "payment" "web")


for name in ${instance[@]};
    echo "creating instance for: $name"

done