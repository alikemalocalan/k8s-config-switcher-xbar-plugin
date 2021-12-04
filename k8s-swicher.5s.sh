#!/usr/bin/env bash

# <xbar.title>K8S Config Switcher</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>Ali Kemal Öcalan</xbar.author>
# <xbar.author.github>alikemalocalan</xbar.author.github>
# <xbar.desc>Simple K(s config switcher for working with multi k8s cluster  </xbar.desc>
# <xbar.dependencies></xbar.dependencies>
# <xbar.image></xbar.image>

KUBE_HOME="$HOME/.kube"
default_file_path="$KUBE_HOME/default"
config_file="$KUBE_HOME/config"

if test -f "$default_file_path"; then
  if [[ -n $1 ]]; then
    cat "$KUBE_HOME/$1" >$config_file
    echo $1 >$default_file_path
  fi
else
  touch $default_file_path
  cp $config_file "$config_file.bak"
fi

echo "K8S Switcher"
echo "--"
default_config=$(head -n 1 $default_file_path | tr -d '\n'  | sed -e 's/\.k8s$//')

echo "$default_config | color=green"

inactive_configs=$(eval "ls $KUBE_HOME | grep .k8s | sed -e 's/\.k8s$//'")

for f in $inactive_configs; do
  if [ "$f" != "$default_config" ]; then
    echo "$f | bash='$0' param1=$f.k8s terminal=false refresh=true"
  fi
done
