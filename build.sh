#!/usr/bin/env bash

set -x
set -e

docker build -t ansible:latest .

TMP_PATH=$(mktemp -d)
ANSIBLE_PATH=${TMP_PATH}/ansible/
docker save ansible:latest -o ${TMP_PATH}/ansible.tar
mkdir ${ANSIBLE_PATH}
tar xf ${TMP_PATH}/ansible.tar -C ${ANSIBLE_PATH}
layer_tar=$(cat ${ANSIBLE_PATH}/manifest.json | jq '.[0].Layers[0]' | sed 's/\"//g')

LAYER_PARENT_PATH=$(mktemp -d)
mkdir ${LAYER_PARENT_PATH}/layer
tar xf ${ANSIBLE_PATH}/${layer_tar} -C ${LAYER_PARENT_PATH}/layer
cp binary.sh ${LAYER_PARENT_PATH}/binary.sh

if [ ! -d ./bin ]; then
    mkdir bin
fi
echo ${LAYER_PARENT_PATH}
pushd ${LAYER_PARENT_PATH}
makeself . ./ansible.run "Ansible" ./binary.sh
popd
mv ${LAYER_PARENT_PATH}/ansible.run ./bin/ansible.run

rm -rf ${TMP_PATH}
rm -rf ${LAYER_PARENT_PATH}

